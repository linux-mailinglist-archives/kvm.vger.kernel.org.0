Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BD7543B97
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiFHShH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiFHShF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 14:37:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE5B7C166
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 11:37:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e19-20020aa79813000000b0051bba91468eso10613083pfl.14
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DfjmzaWWoX0k5XZEXukor9GG8uSlQINloYhG87Q46C4=;
        b=ASdFCk5RyDfEwlmNNvK9gIWZPKLEpa/FOnomlGGRO9lvlhy2n/yYhusT0bGCNrZ8KZ
         Dts525udqhIwBVrYWSOazLXje/v5bSFle0byXlpvpYltfrhqs4PxIkpo61B9IKzdFqcG
         x0FZN7xOYqCrJcXQRSbl6boUxfn/R1tXVGGbbeINb1vPoaS8NjsWCzkpXPUvzBwM8T/K
         HYKTgNTIyreG4shGKX3CmBj7qHwN1Xv2ul8ZA8Zdiy2PW2NEJk5ccWEjNGQDUkxwMIQw
         oYszbK6LU7BRuwNUBjX/S5z681OZHAel/5RGYhRyAHdpQ4U+xtpq7nDcBFO+VfQibdlH
         6UZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DfjmzaWWoX0k5XZEXukor9GG8uSlQINloYhG87Q46C4=;
        b=Z8C2iVcIbMNaEs7ikwRw/WY7etp2z5rz/q48Im9aPA1/3BQinnoEkrWhh+LJRGK+uQ
         CajWu3laXeIsTOTglHDLQpL1G29OMLQkRaAjPhKxk62gWgFXxXpUYoQ2N5t+7THlI3Ow
         Hb0wMgU35vUNCC5dhQsPFcef5bKG/sYicgsLGdTsEOjsvlcmJcZObq7/4Jdr6FHsLsr3
         F94XxJnoWL8CMUR9jh5DIRvL4ohD8WuQPQ2TJihTJL8MmDesxT7V/LDewAOA8bYhkJfo
         OBJEBFFjOUf1cmyUjFRlPk6+Piga9hKyJ+t7lxsU7G1phKZ4Hswoj63fiHfYkQh9SFJx
         8b7g==
X-Gm-Message-State: AOAM5321ghFXN71gNBvCUxvXqYflpXqhapTX05p4+el/U/cMAO9HLF2T
        tpk0Yv5Rq9y+9lL6vQ4dlitaNfWgUGlT9hVVi+mvdKU0tPXctJnONfXg2jz07OCHJV7yC1H8zm5
        ewWq7LO9mEOPnQKMuKcVqbhdH/qAm8H3ZfIP1ubT7Y5QA7frePIr8MIfkhMWF398=
X-Google-Smtp-Source: ABdhPJyR/nGDzgv2WaKKDT1QO54zECMljbzWsxfJFDIOpOv2MJ2BDjZRIil51+86glIH8MU9ujdzACJliY1CvA==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:a17:90a:9109:b0:1cb:a814:8947 with SMTP
 id k9-20020a17090a910900b001cba8148947mr567613pjo.52.1654713424216; Wed, 08
 Jun 2022 11:37:04 -0700 (PDT)
Date:   Wed,  8 Jun 2022 18:35:26 +0000
Message-Id: <20220608183525.1143682-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCHv6] KVM: x86: Use current rather than snapshotted TSC frequency
 if it is constant
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, mlevitsk@redhat.com,
        Anton Romanov <romanton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't snapshot tsc_khz into per-cpu cpu_tsc_khz if the host TSC is
constant, in which case the actual TSC frequency will never change and thus
capturing TSC during initialization is unnecessary, KVM can simply use
tsc_khz.  This value is snapshotted from
kvm_timer_init->kvmclock_cpu_online->tsc_khz_changed(NULL)

On CPUs with constant TSC, but not a hardware-specified TSC frequency,
snapshotting cpu_tsc_khz and using that to set a VM's target TSC frequency
can lead to VM to think its TSC frequency is not what it actually is if
refining the TSC completes after KVM snapshots tsc_khz.  The actual
frequency never changes, only the kernel's calculation of what that
frequency is changes.

Ideally, KVM would not be able to race with TSC refinement, or would have
a hook into tsc_refine_calibration_work() to get an alert when refinement
is complete.  Avoiding the race altogether isn't practical as refinement
takes a relative eternity; it's deliberately put on a work queue outside of
the normal boot sequence to avoid unnecessarily delaying boot.

Adding a hook is doable, but somewhat gross due to KVM's ability to be
built as a module.  And if the TSC is constant, which is likely the case
for every VMX/SVM-capable CPU produced in the last decade, the race can be
hit if and only if userspace is able to create a VM before TSC refinement
completes; refinement is slow, but not that slow.

For now, punt on a proper fix, as not taking a snapshot can help some uses
cases and not taking a snapshot is arguably correct irrespective of the
race with refinement.

Signed-off-by: Anton Romanov <romanton@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..9295e2af8e81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2907,6 +2907,22 @@ static void kvm_update_masterclock(struct kvm *kvm)
 	kvm_end_pvclock_update(kvm);
 }
 
+/*
+ * Use the kernel's tsc_khz directly if the TSC is constant, otherwise use KVM's
+ * per-CPU value (which may be zero if a CPU is going offline).  Note, tsc_khz
+ * can change during boot even if the TSC is constant, as it's possible for KVM
+ * to be loaded before TSC calibration completes.  Ideally, KVM would get a
+ * notification when calibration completes, but practically speaking calibration
+ * will complete before userspace is alive enough to create VMs.
+ */
+static unsigned long get_cpu_tsc_khz(void)
+{
+	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return tsc_khz;
+	else
+		return __this_cpu_read(cpu_tsc_khz);
+}
+
 /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
 static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 {
@@ -2917,7 +2933,8 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 	get_cpu();
 
 	data->flags = 0;
-	if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
+	if (ka->use_master_clock &&
+	    (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {
 #ifdef CONFIG_X86_64
 		struct timespec64 ts;
 
@@ -2931,7 +2948,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 		data->flags |= KVM_CLOCK_TSC_STABLE;
 		hv_clock.tsc_timestamp = ka->master_cycle_now;
 		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
+		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
 		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
@@ -3049,7 +3066,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	tgt_tsc_khz = __this_cpu_read(cpu_tsc_khz);
+	tgt_tsc_khz = get_cpu_tsc_khz();
 	if (unlikely(tgt_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -8646,9 +8663,11 @@ static void tsc_khz_changed(void *data)
 	struct cpufreq_freqs *freq = data;
 	unsigned long khz = 0;
 
+	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
+
 	if (data)
 		khz = freq->new;
-	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+	else
 		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
 		khz = tsc_khz;
@@ -8669,8 +8688,10 @@ static void kvm_hyperv_tsc_notifier(void)
 	hyperv_stop_tsc_emulation();
 
 	/* TSC frequency always matches when on Hyper-V */
-	for_each_present_cpu(cpu)
-		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		for_each_present_cpu(cpu)
+			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+	}
 	kvm_max_guest_tsc_khz = tsc_khz;
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -8807,10 +8828,10 @@ static void kvm_timer_init(void)
 #endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
-	}
 
-	cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
-			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
+		cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
+				  kvmclock_cpu_online, kvmclock_cpu_down_prep);
+	}
 }
 
 #ifdef CONFIG_X86_64
@@ -8963,10 +8984,11 @@ void kvm_arch_exit(void)
 #endif
 	kvm_lapic_exit();
 
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
-	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
+		cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
+	}
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
 	irq_work_sync(&pvclock_irq_work);
-- 
2.36.1.476.g0c4daa206d-goog

