Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE4617279
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKBXZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiKBXYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:24:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66411829
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-37360a6236fso803547b3.12
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hVDla26eytMn5VFnbgyTVPls5SmrgGd/F0K2RutwtIE=;
        b=iDIyHkMK4rG4gjhR62NbU2u6gdWGP2OsiuMyUm8igYAHn8Yp75bJ9TkqULzcOkedq9
         lrMjOcoojkzBjBrlWbrxKO2hIi08hnG2vGMjy19X2fXFVzh41QfLnOmL8FwroxgO3U/9
         M/y/STwQ9eY7WF8E0/2v/0v9jH+QmXpfdWTDy77I/CMIhnQwVipOJiVFqKmJ5knT8kO6
         /eER3jJeTkGs/T4H5Ju8HiQ1eI0gIKHtbfqcKoWDK8SihPIEH+EjdUsL3+2iNE+kxZKc
         HsZJGEKFI4GV2S8b1QPqcice4sYcmqQ+Iksou1vJeTEdz8AoPZCMtO8nunZ43hRprA3N
         Kt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hVDla26eytMn5VFnbgyTVPls5SmrgGd/F0K2RutwtIE=;
        b=NPF4ABiWKfy0k7LaFc/ndraHUgY1hozXnKX+wCOYssb0Rfeg0f68y1ZIpZswqnJxSL
         rtvu1O63OAuDsFUR5/DnM1Ndjx2SZWhsT0QbZMPfR4+sJm1rXYOwPybnsd3Z87QGapH6
         5h8osE1xjcHicry/xiCuFT1vOwFe9t+qTI7Y3o3Hgzhc9Ce0MKCFjJ0BZniJH8SK6Sh5
         IdrW/LzSGSdXynEdMO+7fQ9DzXjAHE/u+mmNZatWMN1OT7ow8m6+rdvYHBbXgqwbYLQP
         qhw0iYVsLxv1jW0lXvjWTdigDbJV6iI3jYNLLQjyIt9MRoepZrsoVRKQgEmMOM6Ng30F
         WK9w==
X-Gm-Message-State: ACrzQf2LjxNADJIqc2mMmxxOIqew8kXC4gXZvd9cAWOm7JzlLO4Va4Y0
        XQ5k16MEsRt7cT4y6wVRYBCyJlx4WYM=
X-Google-Smtp-Source: AMsMyM6yoiTEPBcJzZyJoKfkq9RPyOM1vrXjFEM4y195PpXNkSIWWHhhXy8+p52Rv2+c/CoREZHcmA1s9zk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b10d:0:b0:6cc:3aa3:8cf2 with SMTP id
 g13-20020a25b10d000000b006cc3aa38cf2mr22841832ybj.261.1667431216148; Wed, 02
 Nov 2022 16:20:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:19:03 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-37-seanjc@google.com>
Subject: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
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
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
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

From: Chao Gao <chao.gao@intel.com>

Do compatibility checks when enabling hardware to effectively add
compatibility checks when onlining a CPU.  Abort enabling, i.e. the
online process, if the (hotplugged) CPU is incompatible with the known
good setup.

At init time, KVM does compatibility checks to ensure that all online
CPUs support hardware virtualization and a common set of features. But
KVM uses hotplugged CPUs without such compatibility checks. On Intel
CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX, or
VM-Entry failure if the hotplugged CPU doesn't support all features
enabled by KVM.

Note, this is little more than a NOP on SVM, as SVM already checks for
full SVM support during hardware enabling.

Opportunistically add a pr_err() if setup_vmcs_config() fails, and
tweak all error messages to output which CPU failed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 20 +++++++++++---------
 arch/x86/kvm/vmx/vmx.c          | 33 +++++++++++++++++++--------------
 arch/x86/kvm/x86.c              |  5 +++--
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f223c845ed6e..c99222b71fcc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
 };
 
 struct kvm_x86_init_ops {
-	int (*check_processor_compatibility)(void);
+	int (*check_processor_compatibility)(int cpu);
 	int (*hardware_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index efda384d29d4..4772835174dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -525,13 +525,13 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 		vcpu->arch.osvw.status |= 1;
 }
 
-static bool kvm_is_svm_supported(void)
+static bool kvm_is_svm_supported(int cpu)
 {
 	const char *msg;
 	u64 vm_cr;
 
 	if (!cpu_has_svm(&msg)) {
-		pr_err("SVM not supported, %s\n", msg);
+		pr_err("SVM not supported by CPU %d, %s\n", cpu, msg);
 		return false;
 	}
 
@@ -542,16 +542,16 @@ static bool kvm_is_svm_supported(void)
 
 	rdmsrl(MSR_VM_CR, vm_cr);
 	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
-		pr_err("SVM disabled in MSR_VM_CR\n");
+		pr_err("SVM disabled in MSR_VM_CR on CPU %d\n", cpu);
 		return false;
 	}
 
 	return true;
 }
 
-static int __init svm_check_processor_compat(void)
+static int svm_check_processor_compat(int cpu)
 {
-	if (!kvm_is_svm_supported())
+	if (!kvm_is_svm_supported(cpu))
 		return -EIO;
 
 	return 0;
@@ -588,14 +588,16 @@ static int svm_hardware_enable(void)
 	uint64_t efer;
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
+	int r;
+
+	r = svm_check_processor_compat(me);
+	if (r)
+		return r;
 
 	rdmsrl(MSR_EFER, efer);
 	if (efer & EFER_SVME)
 		return -EBUSY;
 
-	if (!kvm_is_svm_supported())
-		return -EINVAL;
-
 	sd = per_cpu(svm_data, me);
 	if (!sd) {
 		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
@@ -5132,7 +5134,7 @@ static int __init svm_init(void)
 
 	__unused_size_checks();
 
-	if (!kvm_is_svm_supported())
+	if (!kvm_is_svm_supported(raw_smp_processor_id()))
 		return -EOPNOTSUPP;
 
 	r = kvm_x86_vendor_init(&svm_init_ops);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07d86535c032..2729de93e0ea 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2520,8 +2520,7 @@ static bool cpu_has_perf_global_ctrl_bug(void)
 	return false;
 }
 
-static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt, u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2539,7 +2538,7 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
-static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
+static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 {
 	u64 allowed;
 
@@ -2548,8 +2547,8 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
-static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-				    struct vmx_capability *vmx_cap)
+static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			     struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
@@ -2710,36 +2709,38 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-static bool __init kvm_is_vmx_supported(void)
+static bool kvm_is_vmx_supported(int cpu)
 {
 	if (!cpu_has_vmx()) {
-		pr_err("CPU doesn't support VMX\n");
+		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	    !boot_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
+		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL on CPU %d\n", cpu);
 		return false;
 	}
 
 	return true;
 }
 
-static int __init vmx_check_processor_compat(void)
+static int vmx_check_processor_compat(int cpu)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
-	if (!kvm_is_vmx_supported())
+	if (!kvm_is_vmx_supported(cpu))
 		return -EIO;
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+		pr_err("Failed to setup VMCS config on CPU %d\n", cpu);
 		return -EIO;
+	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
-	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
+	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config))) {
+		pr_err("Inconsistent VMCS config on CPU %d\n", cpu);
 		return -EIO;
 	}
 	return 0;
@@ -2771,6 +2772,10 @@ static int vmx_hardware_enable(void)
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	int r;
 
+	r = vmx_check_processor_compat(cpu);
+	if (r)
+		return r;
+
 	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
 
@@ -8517,7 +8522,7 @@ static int __init vmx_init(void)
 {
 	int r, cpu;
 
-	if (!kvm_is_vmx_supported())
+	if (!kvm_is_vmx_supported(raw_smp_processor_id()))
 		return -EOPNOTSUPP;
 
 	hv_setup_evmcs();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c1778f3308a..a7b1d916ecb2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9280,7 +9280,8 @@ struct kvm_cpu_compat_check {
 
 static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	int cpu = smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	WARN_ON(!irqs_disabled());
 
@@ -9288,7 +9289,7 @@ static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->check_processor_compatibility();
+	return ops->check_processor_compatibility(cpu);
 }
 
 static void kvm_x86_check_cpu_compat(void *data)
-- 
2.38.1.431.g37b22c650d-goog

