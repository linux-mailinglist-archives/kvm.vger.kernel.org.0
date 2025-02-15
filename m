Return-Path: <kvm+bounces-38264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5751BA36B1A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 170FF188D2C9
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7131624D5;
	Sat, 15 Feb 2025 01:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RMKjquL5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED2815A848
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583417; cv=none; b=ccwhkIjHWkO/Fh0mXIzrqGrV1otQN9zpXXG+GZFONx9k09W1BQ9CR9V9hWyp9kwiGTG/2rUVFNkQiZ7S+f0UyGykoSxJVsDjfN2fq2F7vpnGZztaOZIHXUn5XYsOjyuoskO+dOn+pg/wHcPWkP34FguyFMstUE2FoftB+eU7cJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583417; c=relaxed/simple;
	bh=Hp5aaSxkcRqHPnT6JGS+am1QqPRhWM9yN7y9XjeP+rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S9L/rucyRjUENBLoZFIq+vmMsp3SdZbt0txkBPnH/cLJwGyrVC45g2/r0iphO8PxkxivLJmTpv5Og6kFlxZzEe0q6MsXIucLAIjkY1RTdUuDBIPtV+k6FBv4KGERRKtRK3IoKBtdal0fFbMK1neJX7SOJjR2h6xfFdu1UPPQCss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RMKjquL5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f6c90a8ddso78464575ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583415; x=1740188215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M8z23wTlGJrsXZCJC6hA4j0Ajpt8mT92vr1YSqwTIws=;
        b=RMKjquL5drrsuRCCPFFvT80BHH9pAvj8DYljNQFFiGU1V1CDf6Dex57nNby9e1y1aD
         Jr2LZyUh/bpn3NpjDQ61/GgF+9UoYvmPURFdgab1zBsSXsp90ys8oUUnTHm0zYMKYRNO
         6R1pSgMPk8Wo0YRKIkECUpFm26GS239GHFGm3h+IDq9BOjY1V61w5PFvbXNwiKU+hMEc
         yajC9iCwUIhXOZ/Q5dLdJ+PW/eqfa4HTty9lL9KmrLHJNIzFp9Ad8fBA9xlGP/jjNALm
         rhFrUO+mwzzGxWlcV9oTV5j8+4XRiTTRnfKkza6sKgFqauuEsdkFv3RArBN97BnzeiQm
         LoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583415; x=1740188215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M8z23wTlGJrsXZCJC6hA4j0Ajpt8mT92vr1YSqwTIws=;
        b=i+87l0UAq1y3h5NdUFIoz2K6H3GjaGHTFrtJisWl+AK1p0x+2qHj/pOJK/tATQdUI9
         6N2MT5MaZN0ZG7Fc4GUc1H8T0OSv0TeDeQOdD3TE2xsgIouFjHABBVsj+AE6/oc25QuC
         K8+MOxdqLrecFs06Rso/TYsxu8klfBZYr5RALdP/r5PYDSG6AbuObOaQvql5GP1jpdXw
         Lj+Tn5jnL/w57kMmAEZk4gWPSRQgeKlLulAUFh+s5H/8oSNLI9sZQPM9Xwt4gR7E/JBK
         CMLYjKXA87NR2SmzcxI//zOVVhiCelN5BFPdECnU7BihITmwFKLdEYCx0+zQHRlLYr3s
         rb/w==
X-Gm-Message-State: AOJu0YzxDV1V7XASdauVsZRB4lpus+TGnRZ/dEfUZfUj/YJF39XptVrp
	2p29KWu+bX/aWkAhnMsV2HKrQpus7PtfiIFaoa5nHOYwW4hwnJvG8ElSyuT3bU8PmVa4CaUiDE9
	8kw==
X-Google-Smtp-Source: AGHT+IFK01LDowkosgsi35sor6cqss7V7iSObhe1aKAbQLysMVS1V7AgPt3YWferScBdCUpL5C981Z0ZTOM=
X-Received: from pjbpv5.prod.google.com ([2002:a17:90b:3c85:b0:2fc:2828:dbca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d507:b0:21f:dc3:8901
 with SMTP id d9443c01a7336-221040a9a19mr24180885ad.34.1739583415055; Fri, 14
 Feb 2025 17:36:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:27 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 10/18] x86: pmu: Use macro to replace
 hard-coded ref-cycles event index
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Replace hard-coded ref-cycles event index with macro to avoid possible
mismatch issue if new event is added in the future and cause ref-cycles
event index changed, but forget to update the hard-coded ref-cycles
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index befbbe18..7ecde9f6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -55,6 +55,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -709,7 +710,8 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  intel_gp_events[INTEL_REF_CYCLES_IDX].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -745,8 +747,10 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
-	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].min =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].min * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].max =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].max * cnt.count) / tsc_delta;
 }
 
 static void check_invalid_rdpmc_gp(void)
-- 
2.48.1.601.g30ceb7b040-goog


