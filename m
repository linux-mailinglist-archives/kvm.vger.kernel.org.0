Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6364132B5A3
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382025AbhCCHTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835973AbhCBTfa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SzjuyznxpHiwjJyqCw7pTG5yzuQjpxnWz5L2dep73w=;
        b=PDLAcd4//OoqfxDdGVPPd5z9nIqWqi08q2KtWgDaGJBfHjtTPm/67o15DAPTiWQ98z2YHs
        b96u2t+YPg37QKOEJuJjeEPioKbIdE2KHOWUnMDswoe2wHuOAtBT6bnkq9BS7P2DPBoygH
        DBtxxufRUv0SdtgUfT2Z+rAa3wr0J0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-kYXzFYRoOqOqtqlxp3BnXQ-1; Tue, 02 Mar 2021 14:33:48 -0500
X-MC-Unique: kYXzFYRoOqOqtqlxp3BnXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 774D3106BB23;
        Tue,  2 Mar 2021 19:33:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2208B60BFA;
        Tue,  2 Mar 2021 19:33:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 05/23] KVM: nSVM: do not copy vmcb01->control blindly to vmcb02->control
Date:   Tue,  2 Mar 2021 14:33:25 -0500
Message-Id: <20210302193343.313318-6-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most fields were going to be overwritten by vmcb12 control fields, or
do not matter at all because they are filled by the processor on vmexit.
Therefore, we need not copy them from vmcb01 to vmcb02 on vmentry.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 23 +++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h    |  2 +-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4d136465dee1..f88d0614d9b8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -428,9 +428,28 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 
-	/* FIXME: go through each field one by one.  */
-	svm->nested.vmcb02.ptr->control = svm->vmcb01.ptr->control;
+	/*
+	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
+	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
+	 */
+
+	/*
+	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
+	 * avic_physical_id.
+	 */
+	WARN_ON(svm->vmcb01.ptr->control.int_ctl & AVIC_ENABLE_MASK);
+
+	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
+	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
+	svm->vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
+	svm->vmcb->control.msrpm_base_pa = svm->vmcb01.ptr->control.msrpm_base_pa;
+
+	/* Done at vmrun: asid.  */
+
+	/* Also overwritten later if necessary.  */
+	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
+	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(&svm->vcpu);
 
-- 
2.26.2


