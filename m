Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D0B58350B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 00:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiG0WFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 18:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiG0WFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 18:05:00 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B639F4F65B;
        Wed, 27 Jul 2022 15:04:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r186so24280pgr.2;
        Wed, 27 Jul 2022 15:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OiEj/R0C3vTV+d3PwcjLmHykKOPJgu0AEZlp4Qdcy4Q=;
        b=cvo9jO6J0wLArB5Xs4cPzAPCM3Gb7qtmxxTetz5HeMRuG+XF/1dxo9Jay/0EkQPaD3
         G9IwPi0kv0CYiyH2BvjwnOTEaaRS/8mtdXwIB+9A43ywLyhAz0QnxDV6jJ48qYnQmAXW
         MZX+0ex9e74H+4mqNsFUcdd7IhcOfvQXrcUXMC52JCVIS7U+4P18jizf+igy49AYked2
         lMHAeYgGF4F9B3SvplxYyIbB1UQUHNxgS2YWLhJZodV1aHSdrCWi5f7VktXOJ3YUFf1A
         MQHsd1JpQrH9fkgLaGXQd9nmo77rxiCAsSRIR2hFoGCBBWc/w1dQNeGs3lIehvvjL9Q6
         xaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OiEj/R0C3vTV+d3PwcjLmHykKOPJgu0AEZlp4Qdcy4Q=;
        b=msUhMGQjl+KNpXxli8rkT+0YroO/3KLv8ay/zuBVTgN+n46kgJckxRb9quf7MsXPyl
         2H3tGhXtBsXh8s1QFfOFHR0Pz/Ah05CuTbOYboTJUNE7ncIg/dyBbYxetVs294b/vT2F
         oHJuB/iOp8SdqLJTXMu5dkNS1ZDyRfXo9q1sOF8rcuSA6Ow6GquFqnGlzIbarSGHVZdA
         1iPH8sSgkupbr3pL1aCAqyQY4VC8KAl+yw4vK16MhKI+FHu/0Ofe3/sZK7rJsB8wpsgx
         jPJ5tQj3dNqax1lgnFugKFDqYYetjeGG+7hAt/NjqwR5FC2Jpt5zadtoobkSAM3pDzWn
         cwtg==
X-Gm-Message-State: AJIora8A9ZUVSJMfnuh5/vtUnjojvvlzTpYuyXZ6AojJ5e7/PSfiHV9O
        zSHjiGQGeJJkoAZYRYdJ/gcoW62e/g/gdA==
X-Google-Smtp-Source: AGRyM1uC00vgkFudu0aCP4qQC+TZ3+sx/1U5xCnb4EWVxe7VQAm9clQyAE/Z+Ak0/6t30Vp2jUURGw==
X-Received: by 2002:a63:4613:0:b0:40d:91e2:e9bf with SMTP id t19-20020a634613000000b0040d91e2e9bfmr20789285pga.235.1658959498812;
        Wed, 27 Jul 2022 15:04:58 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id i2-20020a170902c94200b0016d773aae60sm5904135pla.19.2022.07.27.15.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 15:04:57 -0700 (PDT)
Date:   Wed, 27 Jul 2022 15:04:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 003/102] KVM: Refactor CPU compatibility check on
 module initialiization
Message-ID: <20220727220456.GA3669189@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is the updated version.

commit 7d042749b631f668ed9e99044228f16c212161bc
Author: Isaku Yamahata <isaku.yamahata@intel.com>
Date:   Fri Apr 22 16:56:51 2022 -0700

    KVM: Refactor CPU compatibility check on module initialization
    
    TDX module requires its initialization.  It requires VMX to be enabled.
    Although there are several options of when to initialize it, the choice is
    the initialization time of the KVM kernel module.  There is no usable
    arch-specific hook for the TDX module to utilize during the KVM kernel module
    initialization.  The code doesn't enable/disable hardware (VMX in TDX case)
    during the kernel module initialization.  Add a hook for enabling hardware,
    arch-specific initialization, and disabling hardware during KVM kernel
    module initialization to make a room for TDX module initialization.  The
    current KVM enables hardware when the first VM is created and disables
    hardware when the last VM is destroyed.  When no VM is running, hardware is
    disabled.  To follow these semantics, the kernel module initialization needs
    to disable hardware. Opportunistically refactor the code to enable/disable
    hardware.
    
    Add hadware_enable_all() and hardware_disable_all() to kvm_init() and
    introduce a new arch-specific callback function,
    kvm_arch_post_hardware_enable_setup, for arch to do arch-specific
    initialization that requires hardware_enable_all().  Opportunistically,
    move kvm_arch_check_processor_compat() to to hardware_enabled_nolock().
    TDX module initialization code will go into
    kvm_arch_post_hardware_enable_setup().
    
    This patch reorders some function calls as below from (*) (**) (A) and (B)
    to (A) (B) and (*).  Here (A) and (B) depends on (*), but not (**).  By
    code inspection, only mips and VMX has the code of (*).  No other
    arch has empty (*).  So refactor mips and VMX and eliminate the
    necessity hook for (*) instead of adding an unused hook.
    
    Before this patch:
    - Arch module initialization
      - kvm_init()
        - kvm_arch_init()
        - kvm_arch_check_processor_compat() on each CPUs
      - post-arch-specific initialization -- (*): (A) and (B) depends on this
      - post-arch-specific initialization -- (**): no dependency to (A) and (B)
    
    - When creating/deleting the first/last VM
       - kvm_arch_hardware_enable() on each CPUs -- (A)
       - kvm_arch_hardware_disable() on each CPUs -- (B)
    
    After this patch:
    - Arch module initialization
      - kvm_init()
        - kvm_arch_init()
        - arch-specific initialization -- (*)
        - kvm_arch_check_processor_compat() on each CPUs
        - kvm_arch_hardware_enable() on each CPUs -- (A)
        - kvm_arch_hardware_disable() on each CPUs -- (B)
      - post-arch-specific initialization  -- (**)
    
    - When creating/deleting the first/last VM (no logic change)
       - kvm_arch_hardware_enable() on each CPUs -- (A)
       - kvm_arch_hardware_disable() on each CPUs -- (B)
    
    Code inspection result:
    As long as I inspected, I found only mips and VMX have non-empty (*) or
    non-empty (A) or (B).
    x86: tested on a real machine
    mips: compile test only
    powerpc, s390, arm, riscv: code inspection only
    
    - arch/mips/kvm/mips.c
      module init function, kvm_mips_init(), does some initialization after
      kvm_init().  Compile test only.
    
    - arch/x86/kvm/x86.c
      - uses vm_list which is statically initialized.
      - static_call(kvm_x86_hardware_enable)();
        - SVM: (*) and (**) are empty.
        - VMX: initialize percpu variable loaded_vmcss_on_cpu that VMXON uses.
    
    - arch/powerpc/kvm/powerpc.c
      kvm_arch_hardware_enable/disable() are nop
    
    - arch/s390/kvm/kvm-s390.c
      kvm_arch_hardware_enable/disable() are nop
    
    - arch/arm64/kvm/arm.c
      module init function, arm_init(), calls only kvm_init().
      (*) and (**) are empty
    
    - arch/riscv/kvm/main.c
      module init function, riscv_kvm_init(), calls only kvm_init().
      (*) and (**) are empty
    
    Co-developed-by: Sean Christopherson <seanjc@google.com>
    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 092d09fb6a7e..fd7339cff57c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1642,12 +1642,11 @@ static int __init kvm_mips_init(void)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * kvm_init() calls kvm_arch_hardware_enable/disable().  The early
+	 * initialization is needed before calling kvm_init().
+	 */
 	ret = kvm_mips_entry_setup();
-	if (ret)
-		return ret;
-
-	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-
 	if (ret)
 		return ret;
 
@@ -1656,6 +1655,13 @@ static int __init kvm_mips_init(void)
 
 	register_die_notifier(&kvm_mips_csr_die_notifier);
 
+	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+
+	if (ret) {
+		unregister_die_notifier(&kvm_mips_csr_die_notifier);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 111e0c42479a..5c59b4ea6524 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8442,6 +8442,23 @@ static void vmx_exit(void)
 }
 module_exit(vmx_exit);
 
+/*
+ * Early initialization before kvm_init() so that vmx_hardware_enable/disable()
+ * can work.
+ */
+static void __init vmx_init_early(void)
+{
+	int cpu;
+
+	/*
+	 * vmx_hardware_disable() accesses loaded_vmcss_on_cpu list.
+	 * Initialize the variable before kvm_init() that calls
+	 * vmx_hardware_enable/disable().
+	 */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+}
+
 static int __init vmx_init(void)
 {
 	int r, cpu;
@@ -8479,6 +8496,7 @@ static int __init vmx_init(void)
 	}
 #endif
 
+	vmx_init_early();
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
@@ -8499,11 +8517,8 @@ static int __init vmx_init(void)
 
 	vmx_setup_fb_clear_ctrl();
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d4f130a9f5c8..79a4988fd51f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+int kvm_arch_post_hardware_enable_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5bada53f1fe..51b8ac5faca5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4899,8 +4899,13 @@ static void hardware_enable_nolock(void *junk)
 
 	cpumask_set_cpu(cpu, cpus_hardware_enabled);
 
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		goto out;
+
 	r = kvm_arch_hardware_enable();
 
+out:
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
@@ -5697,9 +5702,9 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
+__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	return 0;
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
@@ -5732,11 +5737,23 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			goto out_free_2;
-	}
+	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
+	r = hardware_enable_all();
+	if (r)
+		goto out_free_2;
+	/*
+	 * Arch specific initialization that requires to enable virtualization
+	 * feature.  e.g. TDX module initialization requires VMXON on all
+	 * present CPUs.
+	 */
+	kvm_arch_post_hardware_enable_setup(opaque);
+	/*
+	 * Make hardware disabled after the KVM module initialization.  KVM
+	 * enables hardware when the first KVM VM is created and disables
+	 * hardware when the last KVM VM is destroyed.  When no KVM VM is
+	 * running, hardware is disabled.  Keep that semantics.
+	 */
+	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
