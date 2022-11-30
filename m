Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E7F63E52B
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiK3XQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiK3XPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:15:52 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED15934FE
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:22 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 11-20020a63000b000000b004776fe2eebfso87228pga.9
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MNb2EYVPWStrykfINBQ1OEVdy8d63OVY3M7i83QW588=;
        b=X88aoYriNA6OrMOF08cmypo00a6V6N7HB7xl0qrV74rGvZGdUgCNMH4KsBq/raO9Xb
         5BtWFZ3ogcCM5KKDgh1PW2bztbFo0y4OQf1T9q+9Ruv3zRc+yWldSvf5iWLEHw6bFrz2
         J3Zk3uSbom/xeGZ3dVomfPe/i+ml5FUHWqSqvI0uRuVc8YEhPckj6nHpDeg1wNKImYIq
         AflIcFnNW/mNjt/I8LP9no13K6piZeE255q9IO0NJk72FpgQ40QDyC0ElY2FkrB8tel1
         fHBrH+1FYatMZD2gaAoFNz9LbqrJUvCgBI3FGsAuBG28+HvjqWPPeHTWV+eC1EsOKQD9
         SLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MNb2EYVPWStrykfINBQ1OEVdy8d63OVY3M7i83QW588=;
        b=bOoMv33yKZClgDa9Rr67MWpyIJ9gXiWJYuGowqgsNBe+JbhT82Q0HBAem3oXVZnR1w
         R2BJZwvzo+HcOLjEgARWGF2jDdMy5KPT/X2XL76nCErAtBFr/lr18LDMVFcKR3frIiBy
         IT6j70vjURJJha6L6qIRauO1Kh+Gj7BiysEooc7frGyBmIEETBbi2nt6GVRISa+BYQrR
         JYwiSS9+b14OlaP/Oz1R3Tv5S5OmV7ZOhCfKwTQEWZQ58oG58YBY86GJzpUXchl+He1j
         Aw2Ez9jtWQkzu9HaBR9W6MiSZ3Di59haoW2uTI9M0+JgjvVoKVglM+K8ALNM61xuqpCM
         OAHA==
X-Gm-Message-State: ANoB5pkJ3K0ConfLVYgKZstdY+uWoRnhCVfW6b5QzTPEo6/UnpTfGxnr
        AGht4Eqt529vKrG7LVniHqPEbDURUoY=
X-Google-Smtp-Source: AA0mqf4HvVRReBelnZ1aTZ9u4Kpeo0MkfB0ZDc1pvtcNBc9h8B2qf8UeK2gbNnMaASNEOkZQ4ylBqewlbR4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10cd:b0:567:546c:718b with SMTP id
 d13-20020a056a0010cd00b00567546c718bmr44472147pfu.17.1669849848848; Wed, 30
 Nov 2022 15:10:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:25 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-42-seanjc@google.com>
Subject: [PATCH v2 41/50] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
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

From: Chao Gao <chao.gao@intel.com>

The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
hotplug callback to ONLINE section so that it can abort onlining a CPU in
certain cases to avoid potentially breaking VMs running on existing CPUs.
For example, when KVM fails to enable hardware virtualization on the
hotplugged CPU.

Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
when offlining a CPU, all user tasks and non-pinned kernel tasks have left
the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
CPU offline callback to disable hardware virtualization at that point.
Likewise, KVM's online callback can enable hardware virtualization before
any vCPU task gets a chance to run on hotplugged CPUs.

Drop kvm_x86_check_processor_compatibility()'s WARN that IRQs are
disabled, as the ONLINE section runs with IRQs disabled.  The WARN wasn't
intended to be a requirement, e.g. disabling preemption is sufficient,
the IRQ thing was purely an aggressive sanity check since the helper was
only ever invoked via SMP function call.

Rename KVM's CPU hotplug callbacks accordingly.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
[sean: drop WARN that IRQs are disabled]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c         |  2 --
 include/linux/cpuhotplug.h |  2 +-
 virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a9e74cedbc6..dad30097f0c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9283,8 +9283,6 @@ static int kvm_x86_check_processor_compatibility(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
-	WARN_ON(!irqs_disabled());
-
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 7337414e4947..de45be38dd27 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -185,7 +185,6 @@ enum cpuhp_state {
 	CPUHP_AP_CSKY_TIMER_STARTING,
 	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
-	CPUHP_AP_KVM_STARTING,
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
@@ -200,6 +199,7 @@ enum cpuhp_state {
 
 	/* Online section invoked on the hotplugged CPU from the hotplug thread */
 	CPUHP_AP_ONLINE_IDLE,
+	CPUHP_AP_KVM_ONLINE,
 	CPUHP_AP_SCHED_WAIT_EMPTY,
 	CPUHP_AP_SMPBOOT_THREADS,
 	CPUHP_AP_X86_VDSO_VMA_ONLINE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3900bd3d75cb..f26ea779710a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5045,13 +5045,27 @@ static void hardware_enable_nolock(void *junk)
 	}
 }
 
-static int kvm_starting_cpu(unsigned int cpu)
+static int kvm_online_cpu(unsigned int cpu)
 {
+	int ret = 0;
+
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
 	raw_spin_lock(&kvm_count_lock);
-	if (kvm_usage_count)
+	if (kvm_usage_count) {
+		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+
 		hardware_enable_nolock(NULL);
+		if (atomic_read(&hardware_enable_failed)) {
+			atomic_set(&hardware_enable_failed, 0);
+			ret = -EIO;
+		}
+	}
 	raw_spin_unlock(&kvm_count_lock);
-	return 0;
+	return ret;
 }
 
 static void hardware_disable_nolock(void *junk)
@@ -5064,7 +5078,7 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable();
 }
 
-static int kvm_dying_cpu(unsigned int cpu)
+static int kvm_offline_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
@@ -5841,8 +5855,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL))
 		return -ENOMEM;
 
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-				      kvm_starting_cpu, kvm_dying_cpu);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -5916,7 +5930,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 out_free_2:
 	free_cpumask_var(cpus_hardware_enabled);
 	return r;
@@ -5942,7 +5956,7 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
-- 
2.38.1.584.g0f3c55d4c2-goog

