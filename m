Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B8372C39
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 16:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhEDOlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 10:41:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231469AbhEDOle (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 10:41:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620139239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wt9K6YQznnVTSlM+wBZuxaJaw70iMsclaRDQntCDebw=;
        b=RumHYX0VEHETjAXuZ/zct/4JC3BByLl3Fodxr0yjn54Wf2d5c6WPa9p+D+t9yUM91dvklR
        Io1NA3r4CnvBuFmz0aPJqDqFLz5TxHCiqnz9Tyc8CHClugdk9hocQ0r6mc0N79ydlz78uC
        ylSJIx/pwvKeQgFSadpVzutsyauBX1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-cVRCHkyZPk2R1noufbkHBQ-1; Tue, 04 May 2021 10:40:36 -0400
X-MC-Unique: cVRCHkyZPk2R1noufbkHBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 624AE83DC0F;
        Tue,  4 May 2021 14:40:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 745225D9D5;
        Tue,  4 May 2021 14:40:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] KVM: nSVM: remove a warning about vmcb01 VM exit reason
Date:   Tue,  4 May 2021 17:39:36 +0300
Message-Id: <20210504143936.1644378-3-mlevitsk@redhat.com>
In-Reply-To: <20210504143936.1644378-1-mlevitsk@redhat.com>
References: <20210504143936.1644378-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While in most cases, when returning to use the VMCB01,
the exit reason stored in it will be SVM_EXIT_VMRUN,
on first VM exit after a nested migration this field
can contain anything since the VM entry did happen
before the migration.

Remove this warning to avoid the false positive.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b331446f67f3..5e8d8443154e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -764,7 +764,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
-	WARN_ON_ONCE(svm->vmcb->control.exit_code != SVM_EXIT_VMRUN);
 
 	/*
 	 * On vmexit the  GIF is set to false and
-- 
2.26.2

