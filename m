Return-Path: <kvm+bounces-48874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF89AD4353
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 235F5189CAD5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B22926658A;
	Tue, 10 Jun 2025 19:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfF5o8sU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C723F266571
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585274; cv=none; b=D3xuYAxKkZhKINXuh4YPsfnOW0i0yGP+uJmO5yHlSQp9/Djm26kjaFsRcxbD1LUBn8RD4siwpoG+pp53DdjMWOX3aHCmA57L6sNS7l0TdObdSqHFBNRgKBSBUIHPSlD6QqTDCxz5Ob2grK4oajWA1e4wdXOc42uLXbJ4phK0BcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585274; c=relaxed/simple;
	bh=lOJgZdyvxobsyrL2erVUsi4bAxihTHwXuzU0Tuf7duU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LcX26Qc+LLpxLsJICmc/ypPaIG8m8Z8JaAe96cWE1Ajp5Q0nLKMcUqPxe1F1ZkVtjY7APbNRoIb/VRxROcgqSgBUwzq7JiTEKS6p8S2Oc5BVPNC2o9UJSbekErT5iA37sjyjIHNIRzgXY4R7ofr8E0Rz6Cw6QYMrVxyntUNTHwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfF5o8sU; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74841f2aee2so1513791b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585272; x=1750190072; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DgOi8bW4J0BL+9gSRv0FBVgmkTespc1rc8qyKO+GCeQ=;
        b=cfF5o8sUgH7gFAxnln1jq0DcLU0XSOiquyOTVQygimgLsh/esetsYiaD7UOZFsDYap
         SmmjTdqHGGt+nzFf5hu7G6NQy742ROK82Oto+Z6iBsSxS6qlnzo3C8bbjH8wb/8sbPGU
         UrQNiz5fHdRJ7Qw+RSo5Fy7svkPtwzDj8rwO1VzUYh1esl/ulf5S8rjlGqruxBajBxVV
         cbD9vY3FViAOiQi2KVfo9M8mwGRENLBmbP/eAabFukGjGzMxq4v3bpoLnsxjPQyfQAfP
         3uYRvpaXKbkxpBmcRvtPbfvhhi24njZ3ErI3OFucpMniY85xiThhPckzfse5V/TtEiDY
         O11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585272; x=1750190072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DgOi8bW4J0BL+9gSRv0FBVgmkTespc1rc8qyKO+GCeQ=;
        b=ZBPDs25J3nCibs9vne0aIVIzuPoAMw8iJFTsb5ox5eM2CMoYhsVzxA1tGx5PZU4e9w
         ZrPPfmQ78SOfp7HTOYO4eJKVrAyjwfaBsmjizxsJ2ZcldqnZAIG+VCEbrlzYNct9+Ybp
         YR4xxv/DLhRMnPNrD2lUBMaQrCUsb4i8fxUFr+KSA/fOcD4EcRnDx8Up7Cn30v5geN32
         fXbbL0y3h6Vp+bF/wV4620o+ZAhhwv3mnHgAQFiUsJQocXZ2X509QHJBzk6KMUTxIniM
         sLzrtOtjC77D+pFgYs/Q7wuu7DVEvQs/3owqwqkodNiTI3lWpVMbuxE6i/0nDtsvog8o
         a7RA==
X-Gm-Message-State: AOJu0YzBrXP++JbHqK+Xt7TDCtx4Pj9mdf1J40lcvAriuHtcJLGfhBEw
	MtZr+U99eynf6QeXRmfQWSwwXJp09PtTwyyb+9fdbRJxmZnOHfYXTmQ+TuiVjmk1+LI8MgxIAyG
	ILTB1fQ==
X-Google-Smtp-Source: AGHT+IHNBwA3q8bkqNviCDsL7dYvbTbH2tOlzp+6u2GdK5L3AQsramFvKn9nJKaM2vAJL4fvI8yBwMDYjqY=
X-Received: from pgac17.prod.google.com ([2002:a05:6a02:2951:b0:b2c:41dc:da38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d4b:b0:215:e1a0:805f
 with SMTP id adf61e73a8af0-21f867300e0mr1371116637.31.1749585272198; Tue, 10
 Jun 2025 12:54:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:09 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 08/14] x86/pmu: Use X86_PROPERTY_PMU_*
 macros to retrieve PMU information
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use the recently introduced X86_PROPERTY_PMU_* macros to get PMU
information instead of open coding equivalent functionality.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 92707698..fb46b196 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -7,21 +7,19 @@ void pmu_init(void)
 	pmu.is_intel = is_intel();
 
 	if (pmu.is_intel) {
-		struct cpuid cpuid_10 = cpuid(10);
-
-		pmu.version = cpuid_10.a & 0xff;
+		pmu.version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
 
 		if (pmu.version > 1) {
-			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
+			pmu.nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+			pmu.fixed_counter_width = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH);
 		}
 
-		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
-		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
-		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
+		pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+		pmu.gp_counter_width = this_cpu_property(X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH);
+		pmu.arch_event_mask_length = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
 
 		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
-		pmu.arch_event_available = ~cpuid_10.b &
+		pmu.arch_event_available = ~this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK) &
 					   (BIT(pmu.arch_event_mask_length) - 1);
 
 		if (this_cpu_has(X86_FEATURE_PDCM))
@@ -39,7 +37,7 @@ void pmu_init(void)
 			/* Performance Monitoring Version 2 Supported */
 			if (this_cpu_has(X86_FEATURE_AMD_PMU_V2)) {
 				pmu.version = 2;
-				pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
+				pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_NR_PERFCTR_CORE);
 			} else {
 				pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
 			}
-- 
2.50.0.rc0.642.g800a2b2222-goog


