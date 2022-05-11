Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A996522914
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 03:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbiEKBnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 21:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiEKBnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 21:43:53 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7566F266F24
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 18:43:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p9-20020a170902e74900b0015ef7192336so267712plf.14
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 18:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xMvhMJFiKjM3ygZP9/zCBMwj6FTC6TDhZ1/jSY8rNaY=;
        b=MZ/VF0LHYlX8y0v0xrBdKFT53sCPmFNMiw/En8NjkCyjLEKIff+z8nVlNrr5X3cHAT
         luGNVkjctDA+5jLuf1Fa0qa9Cj0t1o+rLcXIbWEqm2GCOKC5yrfG0mSOxyV71lltC0M9
         SiBO/9lDh2yMCfVKGxrB7WucSy3pjvoM//l7oOby7B+4yK9j+sueOZhBJQB8zhWvffxV
         ctXKMxx5inY1dVte8W8SlSty7rNjDhwhE98q+EIxxi33mTQrdg7RcYr2hib1dUi+AYFS
         Ep2Kj1eI3itN0BC3LRo6YM6BBp3/5uuKK+4DMnZ90cVWw+h8Leb7rgZsSKM2a6CAaprW
         mriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xMvhMJFiKjM3ygZP9/zCBMwj6FTC6TDhZ1/jSY8rNaY=;
        b=dMKdJ9yOH6U3byh9407ZH+AQr+zwvHDj1M1DT8zUdH2dY6Qo8VJC3ADYQfb0TqlTf3
         hIFwXElpcppEx+PG/xSQ2oVWM+YtSxqmoIROMmuu3RcQR0AOR06cwJ4uvUNEBNzzLoEu
         hzvAKAuDCnykoCsVzivx5y/dcamPm+JiIK/Bf6V+EY2zGIRJUH5q5Xa5EYMJBCRLA+8q
         QKMLp1fVHQfSuvvP/vpIigslYS/jw6CkpFJnhqPCCM3GH5YB+SUQNVnzgXx3lpYxQAh+
         7PXZ1ypnHak8ySxyH3hNU473dC5e4w287jk1gGN6oksZBQ0YJo9kXS8ZH7kg8lqahMP2
         nPSQ==
X-Gm-Message-State: AOAM531ENvQqePwD9Gz3iIY/AOqdpsHDDNfZaP1b1WrJtQrGiqslGn13
        gam4wrEn5LCb7mOZ8ayHf0mE/U1v3qk7Ye6OmzaqvZfuao1Oza8LO6HZWR79ADkAGTKyL1TwMLb
        XgX341OYvBdcJjM1qOq7k1hGpO9pPx9DeHe1BZjq97bmfjdrsLndhkMlwMTVhlpg=
X-Google-Smtp-Source: ABdhPJywcDkK/+y64KnSSCrg/gjxwPQGN2c8m/3YdcSQ4qgu4eXjJRhicdiJn3+gTFySGZ1mOme24M2Jvimweg==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:aa7:8757:0:b0:50d:48a9:f021 with SMTP id
 g23-20020aa78757000000b0050d48a9f021mr22843195pfo.24.1652233431569; Tue, 10
 May 2022 18:43:51 -0700 (PDT)
Date:   Wed, 11 May 2022 01:42:26 +0000
Message-Id: <20220511014226.3099627-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v4] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
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
---
v4 :
    * minor feedback changes
    * skip updating per-cpu tsc in kvm_hyperv_tsc_notifier
    
 arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..f0b4d5ae743b 100644
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
@@ -8646,9 +8663,10 @@ static void tsc_khz_changed(void *data)
 	struct cpufreq_freqs *freq = data;
 	unsigned long khz = 0;
 
+	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
 	if (data)
 		khz = freq->new;
-	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+	else
 		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
 		khz = tsc_khz;
@@ -8669,8 +8687,10 @@ static void kvm_hyperv_tsc_notifier(void)
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
@@ -8783,7 +8803,8 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {
 
 static int kvmclock_cpu_online(unsigned int cpu)
 {
-	tsc_khz_changed(NULL);
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		tsc_khz_changed(NULL);
 	return 0;
 }
 
-- 
2.36.0.550.gb090851708-goog

