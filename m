Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC929F28A
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgJ2RHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgJ2RHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 13:07:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4004C0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:07:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x9so2485761pll.2
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=3KRaFeCn8cu3srAmF4IqkMbqw53L1XtWTUY3QLwzm8A=;
        b=t20WR8sbbc0t+hHqP0qvWHo0kcugXLSSIbgMij7zHAdObBFxCOrZS7wMjsh8SjzAEb
         A5Ao8fR9DuTUL535/I7Ze9/amqAJnrRqT0oNP7yhcvA9ZIpgAHlu0JSBHiGs1lxRc7xL
         Ces2Br8g37lUCaoPk+V4hDXhkvEYBdn3mju0c/Nvw2eB9KeSRrC/ZwA84JLLXw8/JFSn
         LemE+nsNBMndPGfuBfcFJ4XjWnXVbRQou2ckzZiceJhOgCyjfBvT3QVWh42sOHsdmBmR
         Dgucjd1lGPxCppc1ANudQMSLcBRFXzogAEprxJwJQ4Wb9nCDwaxzY52tDUUSOZX7Q2dc
         g06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=3KRaFeCn8cu3srAmF4IqkMbqw53L1XtWTUY3QLwzm8A=;
        b=MCDXOrxskRbNb1ZFkWIt87TSza/8ZwKgNSPPtY62wHSJcgfYd5LsycCYQna07SFi3u
         N4CN6uRQ9qz8Jgh5FbN3pIi4OXqaTNhnZI3rmLZYaAjF27CV3N4p62q2GEKr5HUfWbHj
         7q1zhJD4ccMLpfMQ0ExGN/HyEVsbbekehqen8Fq5AVDWVd4h9IPQHLSl6LJt9SAJIXKx
         jbSqd6IvGmE6WrktrjT8ogR37H5/429iusX6Pxx+ykJD2Ra83U2ZPHxLbJQH/gUXElNC
         D9Xd7qBh00Af1UbcDJWkXVlcNifp7k6/AgofP/5rKGwGeZz1p7YYBSGUdebqsZMolnGR
         rlGA==
X-Gm-Message-State: AOAM5301hXZB4z+Esig7YJ/MMGB/OQNgPmXu4A40GL3ogZJR7QtsVTYW
        F6yCaLGsJgBjxlvzo8NgqbMvPBc8xEgsGYNep0XTlRBzop7oTgGZqr8k4fU3UZTJneaX6anLon0
        K1GiMPGCWrBp8y9A0sshEVwc6EGZFVpYQmuDo9Ik8OOrPhiSuFpCSZD09ZPFKxHA=
X-Google-Smtp-Source: ABdhPJzdyBN0vZRnYTUtU26tvuqbi86yZG9jcd8CaZWXaoCe2HyeE+Po353hIfl1Zu2xtw1wBwUAIToKGay+Ww==
Sender: "jmattson via sendgmr" <jmattson@turtle.sea.corp.google.com>
X-Received: from turtle.sea.corp.google.com ([2620:15c:100:202:725a:fff:fe43:64b1])
 (user=jmattson job=sendgmr) by 2002:a17:90a:3fcb:: with SMTP id
 u11mr735876pjm.128.1603991220167; Thu, 29 Oct 2020 10:07:00 -0700 (PDT)
Date:   Thu, 29 Oct 2020 10:06:48 -0700
Message-Id: <20201029170648.483210-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] kvm: x86: Sink cpuid update into vendor-specific set_cr4 functions
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Abhiroop Dabral <adabral@paloaltonetworks.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>,
        Dexuan Cui <dexuan.cui@intel.com>,
        Huaitong Han <huaitong.han@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On emulated VM-entry and VM-exit, update the CPUID bits that reflect
CR4.OSXSAVE and CR4.PKE.

This fixes a bug where the CPUID bits could continue to reflect L2 CR4
values after emulated VM-exit to L1. It also fixes a related bug where
the CPUID bits could continue to reflect L1 CR4 values after emulated
VM-entry to L2. The latter bug is mainly relevant to SVM, wherein
CPUID is not a required intercept. However, it could also be relevant
to VMX, because the code to conditionally update these CPUID bits
assumes that the guest CPUID and the guest CR4 are always in sync.

Fixes: 8eb3f87d903168 ("KVM: nVMX: fix guest CR4 loading when emulating L2 to L1 exit")
Fixes: 2acf923e38fb6a ("KVM: VMX: Enable XSAVE/XRSTOR for guest")
Fixes: b9baba86148904 ("KVM, pkeys: expose CPUID/CR4 to guest")
Reported-by: Abhiroop Dabral <adabral@paloaltonetworks.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Cc: Haozhong Zhang <haozhong.zhang@intel.com>
Cc: Dexuan Cui <dexuan.cui@intel.com>
Cc: Huaitong Han <huaitong.han@intel.com>
---
 arch/x86/kvm/cpuid.c   | 1 +
 arch/x86/kvm/svm/svm.c | 4 ++++
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 arch/x86/kvm/x86.c     | 8 --------
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a278b3701d..661732be33f5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -139,6 +139,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..78163e345e84 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1699,6 +1699,10 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
+
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+		kvm_update_cpuid_runtime(vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d14c94d0aff1..bd2cb47f113b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3095,6 +3095,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	unsigned long old_cr4 = vcpu->arch.cr4;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
 	 * Pass through host's Machine Check Enable value to hw_cr4, which
@@ -3166,6 +3167,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
+
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+		kvm_update_cpuid_runtime(vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..e95c333724c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1014,9 +1014,6 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
@@ -9522,7 +9519,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct msr_data apic_base_msr;
 	int mmu_reset_needed = 0;
-	int cpuid_update_needed = 0;
 	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
 	int ret = -EINVAL;
@@ -9557,11 +9553,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	vcpu->arch.cr0 = sregs->cr0;
 
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
-	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
-				(X86_CR4_OSXSAVE | X86_CR4_PKE));
 	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
-	if (cpuid_update_needed)
-		kvm_update_cpuid_runtime(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
-- 
2.29.1.341.ge80a0c044ae-goog

