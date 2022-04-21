Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1400050A704
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390750AbiDUR16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390749AbiDUR15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:27:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C5111A0F
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:25:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m8-20020a17090aab0800b001cb1320ef6eso5364220pjq.3
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8t4eVojPvYSH2xTm3DL0zaPTfx4JFrgfzDpSMaoX9u0=;
        b=db3Lo98cKZ5kAAw2S4zuo7KjKHAd8IgVk33Ld7svpRkfstG6qOa6jRSdpzS9gPzR/e
         FwvteDtg6MmoF/CqNQzajdMiAvTr59DYgW6RbwD6+V/rqIPJAFco3ciuP/hKIDM4yz9d
         10ngDw1TcMzjH2lAlc44i32IlJDz+n/lpefCqT4cxo+AbeANk/87TMXksNrIUitOCJPL
         1NT1/jETGWQZIc6HrAuqlnB0M0UqQdmKtaHCos7+QF8d3Y4EQgwes82uxDFJq8zArEEh
         TxxnoFp/hNuKB6+XfcZjnszlC3Fy3ezmvMtrcd+i+D+IPdD1UL++FB52ri0xc2YRx0EE
         VKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8t4eVojPvYSH2xTm3DL0zaPTfx4JFrgfzDpSMaoX9u0=;
        b=bMGQbro8wpxS7Pw49fLQqyAOb7K1MhvHTebHC4y4Ux7P+H1TOB0ljAyQY6TkoGdLwM
         Mr4jrFm7bBSZPOod82hJqkqdz1MnCh9x+yZWUybc2m5DwYGpnvZ0INXRbWXPfJM4cRsW
         7L6ZsRAO2nU738H/6DEDFKoPSpuXCfjm5h0x9VcIujylHERDSWbtPoUVJI6Tyk8oMgkC
         8m4pAg3P/KD9UUJWDljxOop3TxbbtMJ4nFcOIsDp8Hwa1GlUY4Ep0272LQEfOUbIaDYg
         0qdQK93AsN6frEcGWiEfx5lGKeR7Ec9GiV4P6Pe69fMf3TMFzzV/lhS294KAXKKnZsU1
         nbRw==
X-Gm-Message-State: AOAM530SAlDbz4lIB9vZt58h1rIL0rs1XJRsZK7Ls5VcuU+zmdDCRDuH
        BdZipDui1kgJm6cqutMa7fZNckFYHsw/BivSUub0Yu4d/zToLLpS/xg+tPjPh5Y6oTJdl1qbwo0
        xdf/7RT9iWbf1eW4Woxi5BnCWZlWIbhkGVnm3PW56j6hLA+fKx1lJlhZP4Ytr5mE=
X-Google-Smtp-Source: ABdhPJw5mWDDuvMlHT1nqqi/Kv20hx5nLuNCU3A8I2DjkzdrtKdrMLtb+waH8DyzSkiX9oph4plPpf1uhaBb/A==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:aa7:8215:0:b0:4f7:125a:c88c with SMTP id
 k21-20020aa78215000000b004f7125ac88cmr686667pfi.70.1650561906775; Thu, 21 Apr
 2022 10:25:06 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:23:53 +0000
Message-Id: <20220421172352.188745-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, mlevitsk@redhat.com,
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
v3:
    fixed typo
v2:
    fixed commit msg indentation
    added WARN_ON_ONCE in kvm_hyperv_tsc_notifier
    opened up condition in __get_kvmclock

 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..f6f6ddaa2f6a 100644
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
+		(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {
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
2.36.0.rc2.479.g8af0fa9b8e-goog

