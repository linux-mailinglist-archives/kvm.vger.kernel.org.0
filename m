Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E427D43ED
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjJXA0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjJXA0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:26:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7404D7B
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9e1b431d0so26235985ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107202; x=1698712002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g4kIN+NDAiITyOKUUPdApOuHTeRJ+9iSBbDvve6Hp2k=;
        b=H8TaCRA2WdMcgeLNicN4Q6UXVdf2rogIWpIqrhMdMmcUXs+ILMQ2RoITtq216ZG9/5
         On9Mkcsxv5EpnKLQdm9FTezrA9m9zD9PBy8by3EXmRtfVwXFTNubp1qoEDBqaw7HLxG5
         9ADcrqhJsajjZIpJeHbFaAC3HSUtbWLMW2Au22ZiB9KSBacaF6sXhICpCRsTDPXSHTSs
         gjcJl++k3ym5PNUA06IRcTXbVx7+xKR37N0ukjXp+uD5f1nYmZG81qxqCnvuarftO+fn
         IQtY5Ker0LxxAEdS3gofO5a9bRBsl8h9ArxpQf2/VYpOOk9Cn5ZB66adJyYw2jWSpJaT
         6dCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107202; x=1698712002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4kIN+NDAiITyOKUUPdApOuHTeRJ+9iSBbDvve6Hp2k=;
        b=MmRiKOpfDeb5Mwg79OYGIhHJHjfxXewYObXO4jVLS2Aok3zBPUSUdxbYevYX+ZkKkc
         SFlBi8+dA/uKI+1a4qb3vkdja8ZpE5nRyXMU8PsogKYqIEle17Cf07Rj2mdx9Abg55oJ
         2OWPKXBep56LLnxKui47NudQIfBBYGfd+gTVbq08UmYVLCyVZ54LGwlVRPjnhBc3xdnN
         xHk6s+MyawsCPY1kjexaUxYoktv9cdePZ+j8mYXyvcuccb5ZpoDWnQm4pQa2qkS/VhrM
         FnwE21WVtprJlAK3FAvQUd8CT4bxl9/ZQr/Lchtt41W0rUD7V1vhjlyqXJ4MXavF0/BG
         oxow==
X-Gm-Message-State: AOJu0YwataT7dKYLu4o02+S960L6LhZRsKRXEthqIEUm1kwAEU4KrmjC
        hyKI0lrNvKFQXDKL3j2j+bQZAFsaDX8=
X-Google-Smtp-Source: AGHT+IGjRouHgfnwVcLwi0Ea5OGRBSKGmtfa1lqztrKmBu+4nSvOq/hXr5lioBe3jjYsvu6LQ9fiI0yKRLs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:26c6:b0:1bb:a78c:7a3e with SMTP id
 jg6-20020a17090326c600b001bba78c7a3emr226757plb.3.1698107202417; Mon, 23 Oct
 2023 17:26:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:23 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-4-seanjc@google.com>
Subject: [PATCH v5 03/13] KVM: x86/pmu: Always treat Fixed counters as
 available when supported
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
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

Now that KVM hides fixed counters that can't be virtualized, treat fixed
counters as available when they are supported, i.e. don't silently ignore
an enabled fixed counter just because guest CPUID says the associated
general purpose architectural event is unavailable.

KVM originally treated fixed counters as always available, but that got
changed as part of a fix to avoid confusing REF_CPU_CYCLES, which does NOT
map to an architectural event, with the actual architectural event used
associated with bit 7, TOPDOWN_SLOTS.

The commit justified the change with:

    If the event is marked as unavailable in the Intel guest CPUID
    0AH.EBX leaf, we need to avoid any perf_event creation, whether
    it's a gp or fixed counter.

but that justification doesn't mesh with reality.  The Intel SDM uses
"architectural events" to refer to both general purpose events (the ones
with the reverse polarity mask in CPUID.0xA.EBX) and the events for fixed
counters, e.g. the SDM makes statements like:

  Each of the fixed-function PMC can count only one architectural
  performance event.

but the fact that fixed counter 2 (TSC reference cycles) doesn't have an
associated general purpose architectural makes trying to apply the mask
from CPUID.0xA.EBX impossible.  Furthermore, the SDM never explicitly
says that an architectural events that's marked unavailable in EBX affects
the fixed counters.

Note, at the time of the change, KVM didn't enforce hardware support, i.e.
didn't prevent userspace from enumerating support in guest CPUID.0xA.EBX
for architectural events that aren't supported in hardware.  I.e. silently
dropping the fixed counter didn't somehow protection against counting the
wrong event, it just enforced guest CPUID.

Arguably, userspace is creating a bogus vCPU model by advertising a fixed
counter but saying the associated general purpose architectural event is
unavailable.  But regardless of the validity of the vCPU model, letting
the guest enable a fixed counter and then not actually having it count
anything is completely nonsensical.  I.e. even if all of the above is
wrong and it's illegal for a fixed counter to exist when the architectural
event is unavailable, silently doing nothing is still the wrong behavior
and KVM should instead disallow enabling the fixed counter in the first
place.

Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3316fdea212a..1c0a17661781 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -138,11 +138,24 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/*
+	 * Fixed counters are always available if KVM reaches this point.  If a
+	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
+	 * allow the counter's corresponding MSR to be written.  KVM does use
+	 * architectural events to program fixed counters, as the interface to
+	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
+	 * may (sadly) back a guest fixed PMC with a general purposed counter.
+	 * But if _hardware_ doesn't support the associated event, KVM simply
+	 * doesn't enumerate support for the fixed counter.
+	 */
+	if (pmc_is_fixed(pmc))
+		return true;
+
 	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
 
 	/*
 	 * Disallow events reported as unavailable in guest CPUID.  Note, this
-	 * doesn't apply to pseudo-architectural events.
+	 * doesn't apply to pseudo-architectural events (see above).
 	 */
 	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
-- 
2.42.0.758.gaed0368e0e-goog

