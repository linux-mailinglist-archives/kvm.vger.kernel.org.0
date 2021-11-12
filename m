Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2CE44F018
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 00:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhKLXzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 18:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhKLXzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 18:55:48 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEE6C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:52:56 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a16-20020a17090aa51000b001a78699acceso5459377pjq.8
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vO9tXWUVJjddhvP2tTSCGlf8+k/jvi7WTohhGWv8ZZ0=;
        b=H4zIEBBy0qnlBgThJl0NG/bwMVca9P7hrP5Wv3n//gpssvvR7Cr9SCWOGE7eExXkza
         yHBMh6om5OpOd7T438Ihi+MoJjuqw3m0jwQQtnOz/ZQTjaSe1iQ7XzVLrpr82B7yLj7o
         wh+kCCtdynKWda+QdW7TYP0oXzBfJHzY1j/1CHp7lKCDZYREq+SDSx6x3MrKKU7FDiTI
         T+m8tAFb07CDyvaKIAU9xunSfmX2hmAmbsEOyVWHzuFL4gDzCCndxt1O/l5YJmkybFON
         Kfl/Zq7kfMMgpAHmvAzf0CUQpM+T1KxP0Bn/l4y8pdNhp3abWpNi3aWsCm8v5d2gyyPX
         zbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vO9tXWUVJjddhvP2tTSCGlf8+k/jvi7WTohhGWv8ZZ0=;
        b=cStmxxnAkg14qg0jHWZ8MS+niAhncsnkuIajTiPR9LhFOD9BhjcXRP8kMNqv/9UHME
         xm4cTgWQypsqt3M/Kt0zEbzvwVzsrEB45SA0IMj9ICL1+iw8K8yV/WX8CLMDxgoBBnCG
         RyGTbo3smvZ0bwtXQC5yxkL9Dzo1SZdzpTStbAzsyTGQ5GnD8ANOWrqYHfu2WdWfWKzk
         6bBPGLlx9FlLJsDcJ/aDUM8UkCw7ciZQfTydy99cGLYGwywcDUHXxL9dFv6fsT/LVF5E
         DKUgdQRqZgHB9IzGUkHUkYiQ1W8526Ne5S9BQ8Ai5CADQP29HdZtC2owO21VyIQ8kWOs
         WMMw==
X-Gm-Message-State: AOAM533pi8S5BHWgbPcIKnFvScki0eao8fapAApYEXLCsRgbc1HRsDRh
        bvXzia0+Oo0eSmw0svJ0S7TFh2442+ZsnEQC2eUZcP0FCN1GsddoqjVfTmmLolSQC5cP4zCi6Gg
        b9igFZQ01RqgmWquopG5zMl8sj6F1POiqJ9UnwEgC9VXOcCvg3rTD9aq9mL2FdA4=
X-Google-Smtp-Source: ABdhPJw/mAMkk9NETIzghn5Cjoe0/y69IsC3tC3qzNlLfkp5kqEChpQO9yT7/PGG917TjKfuuNtTzGnXPOWprQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr97745pjf.1.1636761175787; Fri, 12 Nov 2021 15:52:55 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:52:34 -0800
In-Reply-To: <20211112235235.1125060-1-jmattson@google.com>
Message-Id: <20211112235235.1125060-2-jmattson@google.com>
Mime-Version: 1.0
References: <20211112235235.1125060-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 1/2] KVM: x86: Update vPMCs when retiring instructions
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM retires a guest instruction through emulation, increment any
vPMCs that are configured to monitor "instructions retired," and
update the sample period of those counters so that they will overflow
at the right time.

Signed-off-by: Eric Hankland <ehankland@google.com>
[jmattson:
  - Split the code to increment "branch instructions retired" into a
    separate commit.
  - Added 'static' to kvm_pmu_incr_counter() definition.
  - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
    PERF_EVENT_STATE_ACTIVE.
]
Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
---
 arch/x86/kvm/pmu.c | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h |  1 +
 arch/x86/kvm/x86.c |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 09873f6488f7..153c488032a5 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -490,6 +490,37 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+static void kvm_pmu_incr_counter(struct kvm_pmc *pmc, u64 evt)
+{
+	u64 counter_value, sample_period;
+
+	if (pmc->perf_event &&
+	    pmc->perf_event->attr.type == PERF_TYPE_HARDWARE &&
+	    pmc->perf_event->state == PERF_EVENT_STATE_ACTIVE &&
+	    pmc->perf_event->attr.config == evt) {
+		pmc->counter++;
+		counter_value = pmc_read_counter(pmc);
+		sample_period = get_sample_period(pmc, counter_value);
+		if (!counter_value)
+			perf_event_overflow(pmc->perf_event, NULL, NULL);
+		if (local64_read(&pmc->perf_event->hw.period_left) >
+		    sample_period)
+			perf_event_period(pmc->perf_event, sample_period);
+	}
+}
+
+void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
+		kvm_pmu_incr_counter(&pmu->gp_counters[i], evt);
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		kvm_pmu_incr_counter(&pmu->fixed_counters[i], evt);
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_record_event);
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 59d6b76203d5..d1dd2294f8fb 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -159,6 +159,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7def720227d..bd49e2a204d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7854,6 +7854,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (unlikely(!r))
 		return 0;
 
+	kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
 	 * not been saved yet.
@@ -8101,6 +8103,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
+			kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.34.0.rc1.387.gb447b232ab-goog

