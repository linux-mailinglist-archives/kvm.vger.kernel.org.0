Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6894246B1E2
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 05:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhLGEfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 23:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbhLGEfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 23:35:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8892FC061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 20:31:32 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf12-20020a17090ac7cc00b001a968c11642so1308895pjb.4
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 20:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=K7euZbyWNX2ta4I57cBHSw4Q5N0mYoG5GUIKq874i+o=;
        b=dPhH/UsMOylT5QvMK9bZDLTGOriozO3FD1jzQcbKMul8WzY6i8jcO0GaHI0Qt9N+7f
         tZA3jtLHRLds4VR6Pbmn4MZnBioviDrliJUlAt/7k0ExE/UEtloUkbA0BIqR/+QvTHYD
         SEiPnvYmZfBO0kTFAQD84O28CVxgOz/6RKzHR9xfpLfnhiH0KVNgums6ovhDmsNbqnTD
         BxPKK7NR2HTnWTDGjrrMF3UvIOmCNfjsZR8wyb2NcPLeX/UG6d6lvejBbZKZczWDmhd1
         vGwrn4tr0QKTxsk8Y0fEM5RyVspbsEKXTQiDHfMQ9366FaD5seypcTE4HNoeITXBjBS+
         dZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=K7euZbyWNX2ta4I57cBHSw4Q5N0mYoG5GUIKq874i+o=;
        b=qKRDgMV0vmUjgmZwLLS3tSqGZzLWXP1tdFuPKBBjMqXxmUmFUhC4+M6CO+g5633GLo
         Yi0QDsiqjJynXGviR5iIXY3p+KKxRPHhGQ75Mbal+l/TOyxPRfXiZXCuFv5A98RZYGIp
         B7cLRdUM+XIOOF75EN70TMr2BEcmAVnQWt605Z/lIRhuWC3Dk4Dh5nkvnq8+IMsdmmV1
         Z5IcfztjY2eooSE25wtubH0kjABwkQKltLQREJOsSxjvOSECAtyEH2eAzZfHu3VWbAs0
         5N1ndBtKq+sroUJI2loxxKoeOkcMVihGppFQnOqiHohmEQK1wbpgVs/wCbZR+oPSPwLe
         zDxQ==
X-Gm-Message-State: AOAM5331/4m47kp0X/LQBGorbPDuIHrvzSyFEBFFn7imTInV4gvHBqkp
        6mhqzYJJ1yiIYfy+zL6REZhOaiO2xMjc
X-Google-Smtp-Source: ABdhPJxiQK8cujFiXdSCJI7KloTZeBJuh8vfwX8QTFSo8Fw35fpkzgDpmwRR/cakDUoIew9SskGdWxgaqR6a
X-Received: from marcorr-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e50])
 (user=marcorr job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr385955pjb.0.1638851491597; Mon, 06 Dec 2021 20:31:31 -0800 (PST)
Date:   Mon,  6 Dec 2021 20:31:00 -0800
Message-Id: <20211207043100.3357474-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH] KVM: x86: Always set kvm_run->if_flag
From:   Marc Orr <marcorr@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_run struct's if_flag is apart of the userspace/kernel API. The
SEV-ES patches failed to set this flag because it's no longer needed by
QEMU (according to the comment in the source code). However, other
hypervisors may make use of this flag. Therefore, set the flag for
guests with encrypted regiesters (i.e., with guest_state_protected set).

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Signed-off-by: Marc Orr <marcorr@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c             | 6 ++++++
 arch/x86/kvm/x86.c                 | 9 +--------
 5 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..9e50da3ed01a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -47,6 +47,7 @@ KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
+KVM_X86_OP(get_if_flag)
 KVM_X86_OP(tlb_flush_all)
 KVM_X86_OP(tlb_flush_current)
 KVM_X86_OP_NULL(tlb_remote_flush)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 860ed500580c..a7f868ff23e7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1349,6 +1349,7 @@ struct kvm_x86_ops {
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
+	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
 
 	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
 	void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d0f68d11ec70..91608f8c0cde 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1585,6 +1585,13 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	to_svm(vcpu)->vmcb->save.rflags = rflags;
 }
 
+static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
+{
+	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
+
+	return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
+}
+
 static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	switch (reg) {
@@ -4621,6 +4628,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.cache_reg = svm_cache_reg,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
+	.get_if_flag = svm_get_if_flag,
 
 	.tlb_flush_all = svm_flush_tlb,
 	.tlb_flush_current = svm_flush_tlb,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9453743ce0c4..6056baa13977 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1363,6 +1363,11 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 		vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
+static bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
+{
+	return !!(vmx_get_rflags(vcpu) & X86_EFLAGS_IF);
+}
+
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
@@ -7575,6 +7580,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cache_reg = vmx_cache_reg,
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
+	.get_if_flag = vmx_get_if_flag,
 
 	.tlb_flush_all = vmx_flush_tlb_all,
 	.tlb_flush_current = vmx_flush_tlb_current,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0aa4dd53c7f..45e836db5bcd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8995,14 +8995,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
-	/*
-	 * if_flag is obsolete and useless, so do not bother
-	 * setting it for SEV-ES guests.  Userspace can just
-	 * use kvm_run->ready_for_interrupt_injection.
-	 */
-	kvm_run->if_flag = !vcpu->arch.guest_state_protected
-		&& (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
-
+	kvm_run->if_flag = static_call(kvm_x86_get_if_flag)(vcpu);
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 
-- 
2.34.1.400.ga245620fadb-goog

