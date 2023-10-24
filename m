Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB27D43EB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjJXA0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjJXA0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:26:43 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA4510C
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7a6fd18abso51562867b3.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107200; x=1698712000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xj3Z6F7wtWkzGUCF9WkpLNZQGBSMludr8th6Vmamu+0=;
        b=RFpUY5O3ZnwQB/qyj/xfIACsmkSXkQfqhgnKyfhhw4b9ic2ebsFm6pmMPDhp8Ueza4
         nFjHokhYEzLG79M6H4T4IyniknSILbyN0/LbLFiFCbRFTlRO1S6xWrdPMaDXyAOaYyLT
         5fZkhVts9wioNIU8ZvgxdoMayQxR/u1SbVo4r69lL2ZY2d71wmAqJGjLm7Vii17fGL31
         WtsyP6dz/5quWe8JJ5aD++Q0PgTFKO7WWf/APPQbmjxW9SgJwa9bw7w5S9bGn70yxalw
         JepDJBguIN/hjH88DP5DdHVVCejACxNPGI4cIyKq6iYkQfpODH/iBs+wa/vldul0ELPt
         yokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107200; x=1698712000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xj3Z6F7wtWkzGUCF9WkpLNZQGBSMludr8th6Vmamu+0=;
        b=uoc8nUV7HEJo1Vf9CnVlerqMVdiXdkcDmCIjaiu9jNWpi5DxFbvlQBvoVMS8dupAr3
         MIzKBJVG5g/heMDDzwMS3tSpY4NidwZk0OpVx0qYGLnSkQK0Cl6R5Vuh8PwzIBjYY5T+
         vVRg3/cm7lYN/piw49npFzm5mr4AEQaVJVQXIj8ySXBN57M1pR6IBQwQzdJ/j8oFzqOz
         PvZ+dQ8DE1Z0jWYgA8gJZR5lyE3ltnsITXedUBKS8IdCNWVUm5V4VDEhtXIHdU7iaxQZ
         xwPF/7K+gzN26r5mgnhgn3xG8HUn7rRivvBHSoEGjOAaFIdgbdrljF6U3AIdQzgbdJdp
         2WyA==
X-Gm-Message-State: AOJu0YzYWP6nMWOKyrXUtsa1DJUxrjsjGU9Wq97p/ujexo5faShAzUuK
        LrLRjUEv7GHzwuReuY2sG0zyOMPnH3E=
X-Google-Smtp-Source: AGHT+IF/WocQ8dioU9d90H5SmfeM24Hr2cdDjMDDy9i8VR+00/+0ouTl4G5U15xB4MSpRuKr89Bs6SNXrOg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cac6:0:b0:5a7:b543:7f0c with SMTP id
 m189-20020a0dcac6000000b005a7b5437f0cmr247826ywd.10.1698107200739; Mon, 23
 Oct 2023 17:26:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:22 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-3-seanjc@google.com>
Subject: [PATCH v5 02/13] KVM: x86/pmu: Don't enumerate support for fixed
 counters KVM can't virtualize
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
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

Hide fixed counters for which perf is incapable of creating the associated
architectural event.  Except for the so called pseudo-architectural event
for counting TSC reference cycle, KVM virtualizes fixed counters by
creating a perf event for the associated general purpose architectural
event.  If the associated event isn't supported in hardware, KVM can't
actually virtualize the fixed counter because perf will likely not program
up the correct event.

Note, this issue is almost certainly limited to running KVM on a funky
virtual CPU model, no known real hardware has an asymmetric PMU where a
fixed counter is supported but the associated architectural event is not.

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1d64113de488..5341e8f69a22 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -19,6 +19,7 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 struct kvm_pmu_ops {
+	void (*init_pmu_capability)(void);
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
@@ -218,6 +219,9 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
 					     KVM_PMC_MAX_FIXED);
+
+	if (pmu_ops->init_pmu_capability)
+		pmu_ops->init_pmu_capability();
 }
 
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b13a472e3f2..3316fdea212a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,6 +68,36 @@ static int fixed_pmc_events[] = {
 	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
 };
 
+static void intel_init_pmu_capability(void)
+{
+	int i;
+
+	/*
+	 * Perf may (sadly) back a guest fixed counter with a general purpose
+	 * counter, and so KVM must hide fixed counters whose associated
+	 * architectural event are unsupported.  On real hardware, this should
+	 * never happen, but if KVM is running on a funky virtual CPU model...
+	 *
+	 * TODO: Drop this horror if/when KVM stops using perf events for
+	 * guest fixed counters, or can explicitly request fixed counters.
+	 */
+	for (i = 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
+		int event = fixed_pmc_events[i];
+
+		/*
+		 * Ignore pseudo-architectural events, they're a bizarre way of
+		 * requesting events from perf that _can't_ be backed with a
+		 * general purpose architectural event, i.e. they're guaranteed
+		 * to be backed by the real fixed counter.
+		 */
+		if (event < NR_REAL_INTEL_ARCH_EVENTS &&
+		    (kvm_pmu_cap.events_mask & BIT(event)))
+			break;
+	}
+
+	kvm_pmu_cap.num_counters_fixed = i;
+}
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -789,6 +819,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
+	.init_pmu_capability = intel_init_pmu_capability,
 	.hw_event_available = intel_hw_event_available,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.42.0.758.gaed0368e0e-goog

