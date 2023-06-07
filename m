Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038A6725152
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbjFGBCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240228AbjFGBCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:02:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD8E5E
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:02:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso11018739276.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 18:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099731; x=1688691731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ppsx8Ceq66P31QklC+vqilKr6uT5OJgGHpP85vCiA6Y=;
        b=60F2xJuBCyVXi/iBprpW3GuxweYIVitbrvYdm3N96FsZqqFZ2ro1VTYWQECv2oLH9T
         CI2gz2e+UlSu7s1pZXNnbwYXsEm+k1euxY3C6yIvCmgmIolJD6TR5bB60JPREl2ol0gP
         hUNdZCWVahrHPFGvnvx5lSuPCK2zZm/XEuwkEfQ9bE2FTi6Ktk2TQUq6hJD+hEK9ICD1
         BpdjfAF91eQb+bXOMKDTyqAtwYsVy7brSn5oVc8QGBuG9yLErI4FpJwMLGo6GaKFT2H7
         N6Vk66Ff9rcSaU4QdOi/RBaBpfvf+XkX0h5fR2BbtqVkXmcdT/v9WsRrMgsA53jGf3bp
         8hDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099731; x=1688691731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ppsx8Ceq66P31QklC+vqilKr6uT5OJgGHpP85vCiA6Y=;
        b=hxGezls7iEtj03lscQVwuBcmxxEtKcqnKUxo7ghffRlOcnc5Pdv0RaPjQ6HA6gyjjK
         sSl4q4sPAvKV98tYmvE5qWpAGw/XU50XLD9zQpHA35kvvBozs/aFBRP7B6mkYmkDm9vH
         nFJE/4ib9ZDrC3j/m0WJDzLEb8rJ4VOrAz3c2l5g8A+oxC/4TV3fMUVLMcCOsI8ecKxE
         lKwSu/TyP2pBTdbQgPoPgdo0cVEwPxiX6urOVE54gWouGYHxn9JWlM7d8irODrtp2yqw
         PiEIs5g3tlj82UM18wH1aHqPiO9ZyobsdrdqplAJYLSjOgxhugeaFckhV2v16EwjQkyE
         kWKw==
X-Gm-Message-State: AC+VfDyw4qmJlT8eJSG6qTdrkvzJBsxKG5nEnjh6lylbwz96JE19klVs
        U4BPmL1R4NpByNZ874alqGSreqdh6qc=
X-Google-Smtp-Source: ACHHUZ5lSKXxJyCIlFQNj+i2NLpdxteCe7UtCpTwxSQ6kftQAsIgDzwiQgT7wsKkC5cGIzPkeFP8vs8gKPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50d3:0:b0:bb3:c4c2:5d2a with SMTP id
 e202-20020a2550d3000000b00bb3c4c25d2amr1201172ybb.7.1686099731265; Tue, 06
 Jun 2023 18:02:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 18:02:03 -0700
In-Reply-To: <20230607010206.1425277-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607010206.1425277-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: x86/pmu: Use enums instead of hardcoded magic for
 arch event indices
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Add "enum intel_pmu_architectural_events" to replace the magic numbers for
the (pseudo-)architectural events, and to give a meaningful name to each
event so that new readers don't need psychic powers to understand what the
code is doing.

Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 55 ++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 84be32d9f365..0050d71c9c01 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -22,23 +22,51 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
+enum intel_pmu_architectural_events {
+	/*
+	 * The order of the architectural events matters as support for each
+	 * event is enumerated via CPUID using the index of the event.
+	 */
+	INTEL_ARCH_CPU_CYCLES,
+	INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	INTEL_ARCH_REFERENCE_CYCLES,
+	INTEL_ARCH_LLC_REFERENCES,
+	INTEL_ARCH_LLC_MISSES,
+	INTEL_ARCH_BRANCHES_RETIRED,
+	INTEL_ARCH_BRANCHES_MISPREDICTED,
+
+	NR_REAL_INTEL_ARCH_EVENTS,
+
+	/*
+	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
+	 * TSC reference cycles.  The architectural reference cycles event may
+	 * or may not actually use the TSC as the reference, e.g. might use the
+	 * core crystal clock or the bus clock (yeah, "architectural").
+	 */
+	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
+	NR_INTEL_ARCH_EVENTS,
+};
+
 static struct {
 	u8 eventsel;
 	u8 unit_mask;
 } const intel_arch_events[] = {
-	[0] = { 0x3c, 0x00 },
-	[1] = { 0xc0, 0x00 },
-	[2] = { 0x3c, 0x01 },
-	[3] = { 0x2e, 0x4f },
-	[4] = { 0x2e, 0x41 },
-	[5] = { 0xc4, 0x00 },
-	[6] = { 0xc5, 0x00 },
-	/* The above index must match CPUID 0x0A.EBX bit vector */
-	[7] = { 0x00, 0x03 },
+	[INTEL_ARCH_CPU_CYCLES]			= { 0x3c, 0x00 },
+	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= { 0xc0, 0x00 },
+	[INTEL_ARCH_REFERENCE_CYCLES]		= { 0x3c, 0x01 },
+	[INTEL_ARCH_LLC_REFERENCES]		= { 0x2e, 0x4f },
+	[INTEL_ARCH_LLC_MISSES]			= { 0x2e, 0x41 },
+	[INTEL_ARCH_BRANCHES_RETIRED]		= { 0xc4, 0x00 },
+	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
+	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */
-static int fixed_pmc_events[] = {1, 0, 7};
+static int fixed_pmc_events[] = {
+	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	[1] = INTEL_ARCH_CPU_CYCLES,
+	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
+};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
@@ -92,13 +120,16 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
+	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
+
+	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
 		    intel_arch_events[i].unit_mask != unit_mask)
 			continue;
 
 		/* disable event that reported as not present by cpuid */
-		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
+		if ((i < PSEUDO_ARCH_REFERENCE_CYCLES) &&
+		    !(pmu->available_event_types & (1 << i)))
 			return false;
 
 		break;
-- 
2.41.0.162.gfafddb0af9-goog

