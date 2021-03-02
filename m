Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAAC32B5A6
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382163AbhCCHTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836005AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jK/sABQlUIwXijeaZF5SISd4pw+vNLEmcy0L0rUmmqc=;
        b=GmjKIUN8aXLAAq7aTxnizFfMGiFEwB+NGh5gu3hJ/XRprC4c9eSeT+im5bFn3aYA1oy5uM
        QjkzVvaIZOISTa7CYGmiyzAhylWy8Xn0lrAgtE4OK0jT080EXldKgSEt7HBBC17ogoGfBo
        3XVbYBtnfpiAK216nuLuiQsAQuwDS+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555--UHI-c7mMfyWVJuEfP1orQ-1; Tue, 02 Mar 2021 14:33:55 -0500
X-MC-Unique: -UHI-c7mMfyWVJuEfP1orQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04BF61E562;
        Tue,  2 Mar 2021 19:33:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A294960CC5;
        Tue,  2 Mar 2021 19:33:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 17/23] KVM: x86: Move RDPMC emulation to common code
Date:   Tue,  2 Mar 2021 14:33:37 -0500
Message-Id: <20210302193343.313318-18-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move the entirety of the accelerated RDPMC emulation to x86.c, and assign
the common handler directly to the exit handler array for VMX.  SVM has
bizarre nrips behavior that prevents it from directly invoking the common
handler.  The nrips goofiness will be addressed in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          |  5 +----
 arch/x86/kvm/vmx/vmx.c          | 10 +---------
 arch/x86/kvm/x86.c              | 15 ++++++++-------
 4 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd26756dc9c1..3f13e0a51499 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1554,7 +1554,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu);
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
-bool kvm_rdpmc(struct kvm_vcpu *vcpu);
+int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 607d7698c7ea..8cb31603bce5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2426,13 +2426,10 @@ static int rsm_interception(struct kvm_vcpu *vcpu)
 
 static int rdpmc_interception(struct kvm_vcpu *vcpu)
 {
-	int err;
-
 	if (!nrips)
 		return emulate_on_interception(vcpu);
 
-	err = kvm_rdpmc(vcpu);
-	return kvm_complete_insn_gp(vcpu, err);
+	return kvm_emulate_rdpmc(vcpu);
 }
 
 static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 83afedbdbfe1..908f7a8af064 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5192,14 +5192,6 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int handle_rdpmc(struct kvm_vcpu *vcpu)
-{
-	int err;
-
-	err = kvm_rdpmc(vcpu);
-	return kvm_complete_insn_gp(vcpu, err);
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -5622,7 +5614,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
 	[EXIT_REASON_INVD]		      = kvm_emulate_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
-	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
+	[EXIT_REASON_RDPMC]                   = kvm_emulate_rdpmc,
 	[EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
 	[EXIT_REASON_VMCLEAR]		      = handle_vmx_instruction,
 	[EXIT_REASON_VMLAUNCH]		      = handle_vmx_instruction,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90a35769951f..c1b7bdf47e7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1195,20 +1195,21 @@ void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 }
 EXPORT_SYMBOL_GPL(kvm_get_dr);
 
-bool kvm_rdpmc(struct kvm_vcpu *vcpu)
+int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
-	int err;
 
-	err = kvm_pmu_rdpmc(vcpu, ecx, &data);
-	if (err)
-		return err;
+	if (kvm_pmu_rdpmc(vcpu, ecx, &data)) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	kvm_rax_write(vcpu, (u32)data);
 	kvm_rdx_write(vcpu, data >> 32);
-	return err;
+	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_rdpmc);
+EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
 
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
-- 
2.26.2


