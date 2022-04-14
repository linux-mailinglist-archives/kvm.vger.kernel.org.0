Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F743501B1B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344002AbiDNSeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242401AbiDNSeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:34:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BC4EA749
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:31:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 199-20020a6307d0000000b0039d99823fafso3105473pgh.8
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Kor0dRo4G5pAltF4zJ4O8O+zCa4oI9agrZhwmovOhok=;
        b=IjnLjTRhmW4PPbAUyG6aJWhQvdeRcr3e6PgRdpoDiWdEHAMSTNht1vDFOgi2+RYwBC
         R4GuoIyRt/5TLcStQAk1wfQ+Kfz82A44BpyP6L3cZYxLr94FILwJyu01M7pP06pkTp4n
         v51EAzIp/O5vLhwojtS4L+mkLBVqJHGksWAFRpNEaMRrPFF2zrB1kFXc1vLfHapPpkmO
         KCi/atyjKsIfcFWeQzBPwp82DJ3x/ofPpHkcSUyQHAEJmU4gDAeOOADznV62vt1LBm7m
         M6nauOw5KV+TFalZCUGOc+zfwCMJSRLM0+C0sgDAroo3KsZK33UiL1NAhGb9HcR/nBiS
         Op0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Kor0dRo4G5pAltF4zJ4O8O+zCa4oI9agrZhwmovOhok=;
        b=YeyNV4LSHbJ4zkUI3LoDtGrhzsb9pV8et9oCxTWREfFFZIU0A7RzYuJ+A7mDACZkbG
         WLmznRuWk7ymgccJe4Rw+qzqcOVb7W9+3MIjzsUBmZ+h2KjsQNhTtodPtHTGC4j6a15A
         rRao6JSE9MwTtrzwsVEs2z75piqIWIvefDeVaBXUAHNL1o76M/m1FWW5FUFa8gqByonX
         srrxYoH2NE4S4c+WIupyXaP8lZeZEu3CAuMjOKWu+9mLmTUCn9XxRGLfogkSK5mXKX63
         QrQByyWNMcehO2Ws5wFun+Gp2pSbmBEVKmFIpocrhF8OSzYOaW76TzmM/qIpphVM5623
         9Kjg==
X-Gm-Message-State: AOAM5303wIy6sP46CTWvzyu/0Ph7aTl3tXx2QmXXWsH1gMFiQUI+Wlv+
        vV2avJJ+L3CMV60PgKu6EnrOGcqQbfoExx4R9Ur9vw83yrSXL12ZkhWTCAnnpw78lPWI7sSu6iV
        Crix6R0ogSEQ6IHT18qj94MNXS/fyQo0zN874y8fiOBLjPGwxvqtX3WJ4QKDd83Y=
X-Google-Smtp-Source: ABdhPJxb8DyduKf58avZf+i2AHlwSxBre7rUjg2SWoutflPeO6cIioV9ms4Mlmwqav47lCQtquKeJyhhYb2Gpw==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:aa7:8d4f:0:b0:508:229b:e82b with SMTP id
 s15-20020aa78d4f000000b00508229be82bmr6046521pfe.48.1649961111540; Thu, 14
 Apr 2022 11:31:51 -0700 (PDT)
Date:   Thu, 14 Apr 2022 18:31:27 +0000
Message-Id: <20220414183127.4080873-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] KVM: x86: Use current rather than snapshotted TSC frequency
 if it is constant
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, Anton Romanov <romanton@google.com>
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

Don't snapshot tsc_khz into per-cpu cpu_tsc_khz if the
host TSC is constant, in which case the actual TSC frequency will never
change and thus capturing TSC during initialization is
unnecessary, KVM can simply use tsc_khz.
This value is snapshotted from
kvm_timer_init->kvmclock_cpu_online->tsc_khz_changed(NULL)

On CPUs with constant TSC, but not a hardware-specified TSC frequency,
snapshotting cpu_tsc_khz and using that to set a VM's target TSC
frequency can lead to VM to think its TSC frequency is not what it actually
is if refining the TSC completes after KVM snapshots tsc_khz.  The
actual frequency never changes, only the kernel's calculation of what
that frequency is changes.

Ideally, KVM would not be able to race with TSC refinement, or would have
a hook into tsc_refine_calibration_work() to get an alert when refinement
is complete.  Avoiding the race altogether isn't practical as refinement
takes a relative eternity; it's deliberately put on a work queue outside
of the normal boot sequence to avoid unnecessarily delaying boot.

Adding a hook is doable, but somewhat gross due to KVM's ability to be
built as a module.  And if the TSC is constant, which is likely the case
for every VMX/SVM-capable CPU produced in the last decade, the race can
be hit if and only if userspace is able to create a VM before TSC
refinement completes; refinement is slow, but not that slow.

For now, punt on a proper fix, as not taking a snapshot can help some
uses cases and not taking a snapshot is arguably correct irrespective of
the race with refinement.

Signed-off-by: Anton Romanov <romanton@google.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..4ae9a03f549d 100644
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
@@ -2917,7 +2930,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 	get_cpu();
 
 	data->flags = 0;
-	if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
+	if (ka->use_master_clock && get_cpu_tsc_khz()) {
 #ifdef CONFIG_X86_64
 		struct timespec64 ts;
 
@@ -2931,7 +2944,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 		data->flags |= KVM_CLOCK_TSC_STABLE;
 		hv_clock.tsc_timestamp = ka->master_cycle_now;
 		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
+		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
 		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
@@ -3049,7 +3062,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	tgt_tsc_khz = __this_cpu_read(cpu_tsc_khz);
+	tgt_tsc_khz = get_cpu_tsc_khz();
 	if (unlikely(tgt_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -8646,9 +8659,12 @@ static void tsc_khz_changed(void *data)
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
-- 
2.36.0.rc0.470.gd361397f0d-goog

