Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982F51E28A6
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbgEZRYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:24:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57848 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389297AbgEZRXu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDqT4f1uQJQIvqNZdczXvG2GH6h9ulU5SAl7/Q8kB/8=;
        b=Jl64DSxpZWV8+XyACgSQtYCbEVkoo9jtsKc1x1Z0bUdLI253Wq5lc3mCSulFALkcVOt7xZ
        O2lNxaISXe7UjyREF+vFgY5S9w9dSbML20UNlUnNXMjjhB20y7ekYDmY2i6pph5BMt3mKj
        CLLngVoxzMOKdNpO6J7wplr5XgFdn84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-RpGjj48_MO6R99ao2ZqtPA-1; Tue, 26 May 2020 13:23:48 -0400
X-MC-Unique: RpGjj48_MO6R99ao2ZqtPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CD08805723;
        Tue, 26 May 2020 17:23:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3791F5D9E8;
        Tue, 26 May 2020 17:23:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 20/28] KVM: SVM: preserve VGIF across VMCB switch
Date:   Tue, 26 May 2020 13:23:00 -0400
Message-Id: <20200526172308.111575-21-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is only one GIF flag for the whole processor, so make sure it is
not clobbered when switching to L2 (in which case we also have to include
the V_GIF_ENABLE_MASK, lest we confuse enable_gif/disable_gif/gif_set).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f5956ecfeeac..607531db8a94 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -293,6 +293,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
+	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
@@ -308,7 +309,10 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
-	svm->vmcb->control.int_ctl             = svm->nested.ctl.int_ctl | V_INTR_MASKING_MASK;
+	svm->vmcb->control.int_ctl             =
+		(svm->nested.ctl.int_ctl & ~mask) |
+		(svm->nested.hsave->control.int_ctl & mask);
+
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
 	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-- 
2.26.2


