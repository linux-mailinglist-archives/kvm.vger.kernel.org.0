Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D84509462
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 02:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383538AbiDUBAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 21:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347647AbiDUBAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 21:00:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D601DBE3
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:57:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 1-20020a621601000000b0050adb936767so242931pfw.19
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ll5WMM+s64aCDj0JAwnKGgeByFVhxBcwRTYIZ6ekFK4=;
        b=WLrm3A0opZJOqOiugkaTkJ+kITwmRnBdbkQBuz1LH0s9uV5A0WnHW+ZTpGyEO2navY
         BnV2lX5UqkLpB53IaFYA93w/YWfmNKJDPNExHSPmftF0pr39N9GT+QJBmLh/gHSC1b8H
         n0WXT7nYW0/Xd3OCZYyLvF/7uIHE9BZUvBCRVu3v+dM3RPbt3DUIUW4vr6b1h2rV8ueQ
         fKzjbUZ3RajrwN2rDsaJAEJLk2sJs4rz2bGmkb9w8i28HcKH2uQyLRVltAflo7jXhOBa
         vvKHiS67xAvcV8wUyxvpdciOZ9/KXj4IEQDZskHQp6Om7Lbh8bovYDM6Kcj4cX6BbadT
         VsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ll5WMM+s64aCDj0JAwnKGgeByFVhxBcwRTYIZ6ekFK4=;
        b=f1/ybHjaeLVERZ98r5nCCNWUb8cGlDPDHTiKP2zO/4C+4ogHFCFK8SsPLK+72RI7UG
         Le3nV6NlcTWZg6zZt5IczPqX1AGvacToEQ0R3A5ErazrdYK+fK4rhVJusVy1vRggIEFM
         acy3Sn5j4kigASYFrxshp6Xq3pKRpgtAalncml/yZc4pp1aeuBdoZUeYEvufzjzzRJZl
         sy8Ajg1JtPG/mct+2cfVez8g4GAgOoNwO7ci7Utz00+MmTGQmHDmnuxLveTtD6Vuk+jZ
         J06zFPTXm6DlgPePxwWSIb+zrU2AgPDSVRO7UBvUUue1HbhTbAC84v4q9jvRRLWTS8N9
         g98g==
X-Gm-Message-State: AOAM532LRtt8VtgF+MF54HRoV9J2GebwQcwl5NSBOwbxh7+GySEP/hDy
        1+XSCwAonYWvUp3JJ2evM9R45g+DJ+m/vpcee29zCVoqDaZ6MlkOrTzgE+W7jEhMMZ+HvY6eSKk
        HKxZfn97NzTuTpTU+zTctVq4LcFurv3/6tAZrKD1Im8nHrp8dALBgZeQvpQYoYLg=
X-Google-Smtp-Source: ABdhPJyldX7sNwooilW60jGuvL+wD7vD2JBCJz41jXcFtjpNuqELMWPPn+a8INQoW490uXOqkmr/Mqx7/ieUiw==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:a17:902:a5cc:b0:158:9a2b:480e with SMTP
 id t12-20020a170902a5cc00b001589a2b480emr23221012plq.19.1650502667189; Wed,
 20 Apr 2022 17:57:47 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:56:47 +0000
Message-Id: <20220421005645.56801-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com,
        Anton Romanov <romanton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
v2:
    fixed commit msg indentation
    added WARN_ON_ONCE in kvm_hyperv_tsc_notifier
    opened up condition in __get_kvmclock
 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..1043cfd26576 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2907,6 +2907,19 @@ static void kvm_update_masterclock(struct kvm *kvm)
 	kvm_end_pvclock_update(kvm);
 }
 
+/*
+ * If kvm is built into kernel it is possible that tsc_khz saved into
+ * per-cpu cpu_tsc_khz was yet unrefined value. If CPU provides CONSTANT_TSC it
+ * doesn't make sense to snapshot it anyway so just return tsc_khz
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
@@ -2917,7 +2930,8 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 	get_cpu();
 
 	data->flags = 0;
-	if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
+	if (ka->use_master_clock &&
+		(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
 #ifdef CONFIG_X86_64
 		struct timespec64 ts;
 
@@ -2931,7 +2945,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 		data->flags |= KVM_CLOCK_TSC_STABLE;
 		hv_clock.tsc_timestamp = ka->master_cycle_now;
 		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
+		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
 		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
@@ -3049,7 +3063,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	tgt_tsc_khz = __this_cpu_read(cpu_tsc_khz);
+	tgt_tsc_khz = get_cpu_tsc_khz();
 	if (unlikely(tgt_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -8646,9 +8660,12 @@ static void tsc_khz_changed(void *data)
 	struct cpufreq_freqs *freq = data;
 	unsigned long khz = 0;
 
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return;
+
 	if (data)
 		khz = freq->new;
-	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+	else
 		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
 		khz = tsc_khz;
@@ -8661,6 +8678,8 @@ static void kvm_hyperv_tsc_notifier(void)
 	struct kvm *kvm;
 	int cpu;
 
+	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TSC_RELIABLE));
+
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_make_mclock_inprogress_request(kvm);
-- 
2.36.0.rc0.470.gd361397f0d-goog

