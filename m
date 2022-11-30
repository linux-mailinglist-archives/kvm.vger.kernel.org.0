Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24A63E517
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiK3XPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiK3XOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:14:45 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C28E99F38
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:06 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 145-20020a621497000000b00574fab7294dso175486pfu.13
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D3FaB2LQWUdh9329yK1/LRRjE6BHL9vT84hTzCwYUZY=;
        b=F0Uv7HJ3uLD6my3CPg9c/FvAdlevE5UrgwJ52oKbdKk+h5pZQ52R0A1ujwUbyda5be
         kT7hr3m17CSHrE1wqdrO8WnhFVLHbQUmFj/AHeRDhIbeEgLy25Z35oiEJSUghp9d7Mvw
         EMvHrrXXLjdbC6nrvYYBKHYtONVA9nuR5/1rOJ5nX9vtMt4pH3KARms+yyAenpIRQ0wN
         Qvd43wOl6PzaVLPZ767z3WS2EvSh9lILv6Vuzj5BuNFPpqzBEscwlX2yFLGnewIU1D/n
         AS6gWh9JiHPdRq6xbA0faOzZWTQx8VU6OdYrvQhQzjtuYmnftngmGkjXlabZhl5EzkQE
         VogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D3FaB2LQWUdh9329yK1/LRRjE6BHL9vT84hTzCwYUZY=;
        b=fesNPFb/KFuG0Hp3hcOodOzn6oQDDrqZ8ebAOg9DpAD9QPYDucvQ+5d9OpgUzPrjfO
         aa45Y1Ja5pomSqlvPV6NUmVL+q12th0NwwGa5llsWokKena2ilS6xi3cJixwk1P3vKmp
         HGQNDOGEu6QnAO1ZjmoNy1Ifn7uMTGxQeaKbqiRzDEHBypqLeYbWflN9o6aeto8VGP2g
         B9JezDErNJQxHUuYoki/fFfM099JPETcrWDWRco4J7AW2Cb4YcifsbhGs5pSD1gp1nfc
         hUrCXCRqS9FUsSFUlwCldQ0NDVFhIQeyuOSgLOO/+MYuW+mYepAAjrc+GajxHqOmbwVr
         Tr1Q==
X-Gm-Message-State: ANoB5pmHOVla1KBJwtY7cwUMfdn6ImbFWkN82z13VmmPngGjRLZ0n7/0
        8rQAPCDXduHpsg/BArtQpQhaNmEsk6E=
X-Google-Smtp-Source: AA0mqf6dzizXuyPBFdbqHp5eNQJR39tQ8HwhM4MMFjuS8vZtDz9I3IquPQQoAu2jtVBkbtAudijruyIdWeQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec04:b0:189:894c:6b58 with SMTP id
 l4-20020a170902ec0400b00189894c6b58mr18422710pld.172.1669849840042; Wed, 30
 Nov 2022 15:10:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:20 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-37-seanjc@google.com>
Subject: [PATCH v2 36/50] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do basic VMX/SVM support checks directly in vendor code instead of
implementing them via kvm_x86_ops hooks.  Beyond the superficial benefit
of providing common messages, which isn't even clearly a net positive
since vendor code can provide more precise/detailed messages, there's
zero advantage to bouncing through common x86 code.

Consolidating the checks will also simplify performing the checks
across all CPUs (in a future patch).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/svm/svm.c          | 38 +++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.c          | 37 +++++++++++++++++---------------
 arch/x86/kvm/x86.c              | 11 ----------
 4 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 04a9ae66fb8d..d79aedf70908 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1729,8 +1729,6 @@ struct kvm_x86_nested_ops {
 };
 
 struct kvm_x86_init_ops {
-	int (*cpu_has_kvm_support)(void);
-	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab53da3fbcd1..49ccef9fae81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -519,21 +519,28 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 		vcpu->arch.osvw.status |= 1;
 }
 
-static int has_svm(void)
+static bool kvm_is_svm_supported(void)
 {
 	const char *msg;
+	u64 vm_cr;
 
 	if (!cpu_has_svm(&msg)) {
-		printk(KERN_INFO "has_svm: %s\n", msg);
-		return 0;
+		pr_err("SVM not supported, %s\n", msg);
+		return false;
 	}
 
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		pr_info("KVM is unsupported when running as an SEV guest\n");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	rdmsrl(MSR_VM_CR, vm_cr);
+	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
+		pr_err("SVM disabled (by BIOS) in MSR_VM_CR\n");
+		return false;
+	}
+
+	return true;
 }
 
 void __svm_write_tsc_multiplier(u64 multiplier)
@@ -572,10 +579,9 @@ static int svm_hardware_enable(void)
 	if (efer & EFER_SVME)
 		return -EBUSY;
 
-	if (!has_svm()) {
-		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
+	if (!kvm_is_svm_supported())
 		return -EINVAL;
-	}
+
 	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
@@ -4070,17 +4076,6 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
-static int is_disabled(void)
-{
-	u64 vm_cr;
-
-	rdmsrl(MSR_VM_CR, vm_cr);
-	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE))
-		return 1;
-
-	return 0;
-}
-
 static void
 svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 {
@@ -5080,8 +5075,6 @@ static __init int svm_hardware_setup(void)
 
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
-	.cpu_has_kvm_support = has_svm,
-	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
 	.check_processor_compatibility = svm_check_processor_compat,
 
@@ -5095,6 +5088,9 @@ static int __init svm_init(void)
 
 	__unused_size_checks();
 
+	if (!kvm_is_svm_supported())
+		return -EOPNOTSUPP;
+
 	r = kvm_x86_vendor_init(&svm_init_ops);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f7d9f88b314..23b64bf4bfcf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2485,17 +2485,6 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static __init int cpu_has_kvm_support(void)
-{
-	return cpu_has_vmx();
-}
-
-static __init int vmx_disabled_by_bios(void)
-{
-	return !this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	       !this_cpu_has(X86_FEATURE_VMX);
-}
-
 static int kvm_cpu_vmxon(u64 vmxon_pointer)
 {
 	u64 msr;
@@ -7479,16 +7468,29 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static bool __init kvm_is_vmx_supported(void)
+{
+	if (!cpu_has_vmx()) {
+		pr_err("CPU doesn't support VMX\n");
+		return false;
+	}
+
+	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !this_cpu_has(X86_FEATURE_VMX)) {
+		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
-	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX is disabled on CPU %d\n", smp_processor_id());
+	if (!kvm_is_vmx_supported())
 		return -EIO;
-	}
 
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
@@ -8499,8 +8501,6 @@ static __init int hardware_setup(void)
 }
 
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
-	.cpu_has_kvm_support = cpu_has_kvm_support,
-	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
 	.handle_intel_pt_intr = NULL,
@@ -8543,6 +8543,9 @@ static int __init vmx_init(void)
 {
 	int r, cpu;
 
+	if (!kvm_is_vmx_supported())
+		return -EOPNOTSUPP;
+
 	/*
 	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
 	 * to unwind if a later step fails.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d5455e08191..5551f3552f08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9315,17 +9315,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EEXIST;
 	}
 
-	if (!ops->cpu_has_kvm_support()) {
-		pr_err_ratelimited("no hardware support for '%s'\n",
-				   ops->runtime_ops->name);
-		return -EOPNOTSUPP;
-	}
-	if (ops->disabled_by_bios()) {
-		pr_err_ratelimited("support for '%s' disabled by bios\n",
-				   ops->runtime_ops->name);
-		return -EOPNOTSUPP;
-	}
-
 	/*
 	 * KVM explicitly assumes that the guest has an FPU and
 	 * FXSAVE/FXRSTOR. For example, the KVM_GET_FPU explicitly casts the
-- 
2.38.1.584.g0f3c55d4c2-goog

