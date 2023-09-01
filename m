Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A47790248
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 20:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345041AbjIAS5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 14:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjIAS5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 14:57:15 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4400ACEB
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 11:57:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27359a369ceso737658a91.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 11:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693594632; x=1694199432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qm2t4oYHMRlDZwlTVB/slNf/FI/jt/9yEfgX1cV18MI=;
        b=OSZZmiC7pSJIvxoohpbpSzgs7GUD42hryBFE71OPGfhqJHNyiIjWV3isgpJTuzk9he
         E8PHB8+QFXGHiTep0MFHNpSyR2o97DxlNvcFbjokKLr+GmmRFc2YRX14KvWG19BKoD/7
         AZkOShO45sH4TAngdr/f8xtXG4a5Xt4nmDc99saRygt7v5Gr7TDsmTadNhQ2gHDk5xxL
         gf9o0cnqIjPFWYQ6CQ8PbTrWHLHnkww1mBHa6ChU8kQF3XJ8CAaAQGtzq3ANL4aWqwOX
         +mwEXibCyiPgRlEH1NpfJMSibl4tCf/t/2sZUMCauIm1TSXbWVYi56ooJYLXQ336ITkq
         pnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693594632; x=1694199432;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qm2t4oYHMRlDZwlTVB/slNf/FI/jt/9yEfgX1cV18MI=;
        b=LxGilwPcv0ws08xyC1eja9A6CzZPOdjMBJFCr1OorhEp3y8igfQvLptuQ5kERhDp3W
         T8eSsr6ir+Z0exKy6aBXBMPquk1aBSq0uBSNLOTeKFykowVevL11iHSyN+h2MJgUaycj
         1/B6Nbbad/cJRsIaIpnBtCl28oyYxQN96NgYu0NFZI/H12nyG/DKI9Ufz3RsgWK0ZA8r
         MgnkJ7npRw+pwwu+O7HbNe89LB9HGl3JQTMENvb8W0KDa9GYAFrcqLrylVUGJtd0pMUR
         0EADuFGfkLisoah70uGy+tvY86kFU9xSnUhhMHVgGdsFynKEoAPvScstcrg59DuqEaj0
         O7/w==
X-Gm-Message-State: AOJu0YwoKnK6sUWJdHyoEKbGio4R92YsWNIQpfdznuQRIXOhIAPDnQjh
        aMm4Cml+HIPQD9c6/8YC1EpAStuS0oQ1len+y/d1rIj3c8OCcSJQXWXUMUNFl/3bpIEvt3dkKqb
        XpOUXupRV86tgHE7reqFEQNLNZMkwcSc0PFOq3lwS/44pWhEKI0NEzKP1HET951o=
X-Google-Smtp-Source: AGHT+IHn8741RfcYdMy9aS/LGDItUFIPknbl0iNh4Dc4jHJ758ijDfkQyzmkwBMGvgS+WlecCIRRSXhnXTHwxQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:ca8c:b0:271:8d4d:d04c with SMTP
 id y12-20020a17090aca8c00b002718d4dd04cmr738171pjt.7.1693594631582; Fri, 01
 Sep 2023 11:57:11 -0700 (PDT)
Date:   Fri,  1 Sep 2023 11:56:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901185646.2823254-1-jmattson@google.com>
Subject: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <likexu@tencent.com>, Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
VM-exit that also invokes __kvm_perf_overflow() as a result of
instruction emulation, kvm_pmu_deliver_pmi() will be called twice
before the next VM-entry.

That shouldn't be a problem. The local APIC is supposed to
automatically set the mask flag in LVTPC when it handles a PMI, so the
second PMI should be inhibited. However, KVM's local APIC emulation
fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
are delivered via the local APIC. In the common case, where LVTPC is
configured to deliver an NMI, the first NMI is vectored through the
guest IDT, and the second one is held pending. When the NMI handler
returns, the second NMI is vectored through the IDT. For Linux guests,
this results in the "dazed and confused" spurious NMI message.

Though the obvious fix is to set the mask flag in LVTPC when handling
a PMI, KVM's logic around synthesizing a PMI is unnecessarily
convoluted.

Remove the irq_work callback for synthesizing a PMI, and all of the
logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().

Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/pmu.c              | 27 +--------------------------
 arch/x86/kvm/x86.c              |  3 +++
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..f6b9e3ae08bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -528,7 +528,6 @@ struct kvm_pmu {
 	u64 raw_event_mask;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
-	struct irq_work irq_work;
 
 	/*
 	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bf653df86112..0c117cd24077 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -93,14 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
-{
-	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
-
-	kvm_pmu_deliver_pmi(vcpu);
-}
-
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -124,20 +116,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
 
-	if (!pmc->intr || skip_pmi)
-		return;
-
-	/*
-	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
-	 * can be ejected on a guest mode re-entry. Otherwise we can't
-	 * be sure that vcpu wasn't executing hlt instruction at the
-	 * time of vmexit and is not going to re-enter guest mode until
-	 * woken up. So we should wake it, but this is impossible from
-	 * NMI context. Do it from irq work instead.
-	 */
-	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
-		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
-	else
+	if (pmc->intr && !skip_pmi)
 		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 }
 
@@ -677,9 +656,6 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-
-	irq_work_sync(&pmu->irq_work);
 	static_call(kvm_x86_pmu_reset)(vcpu);
 }
 
@@ -689,7 +665,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	static_call(kvm_x86_pmu_init)(vcpu);
-	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
 	kvm_pmu_refresh(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c381770bcbf1..0732c09fbd2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12841,6 +12841,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 #endif
 
+	if (kvm_test_request(KVM_REQ_PMI, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
-- 
2.42.0.283.g2d96d420d3-goog

