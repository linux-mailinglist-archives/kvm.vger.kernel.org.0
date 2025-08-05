Return-Path: <kvm+bounces-54042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED19AB1BAA6
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B78D21682B0
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687692BD5A2;
	Tue,  5 Aug 2025 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1FZsnIT3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B85B2BD59A
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420748; cv=none; b=Gs46saNeb2jiuG42RMn+NOzEcjwpesRKEfFtZM7qfdhO7dG0hlIgYr+iEt1P8HctaT+eIAOl/wSHPfYZGNp8WpYhpa9KECiYm4FwhspD8RxAllz9EXHEmO5kxJPsnlD91nNVOsXWueCe9LBrDkjqd/FdFM2BrFPDXvDp2T2x0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420748; c=relaxed/simple;
	bh=jIspsSukkN0GcXbnX6kROdAooWTTjWRdQLcWRVvZSm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=npGx7kn1eTrnoMF3a3Hr4YhBSZVshNPcpYr7GDXb8K8XIN8hdpUZJ0Dlefv6C9UbSid/jbcP/s2YQR6kFiAAxwSiNRiTiSXnSl3dwbAw3cBeiWM5eQ6hus2AGaw7qECejamxuIU0B9V+WuJ5LGGQClr0bilOixQMUA5ST+xKwyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1FZsnIT3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b42249503c4so141329a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420745; x=1755025545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MHm9cX+2a6wEZOmXR7zbZQOpP1vpd9jsxwALDJhOINI=;
        b=1FZsnIT3yJ8q2jprrQl17a+wlTnvPRnswOiXvhW6M46or3ohP4Ar597wqNeGE17r+y
         acwBKMQkytbLVK2PmjG0fHvNjj+G1DOwXvhKMvIGC+minWXMNf6E7VuwDBIH8/NBUf9T
         5KQT7nakWSB1m8ln+ZXLQ+giFTKv0t/kKJc4RanJOeuluZU/euq7pU9LRIHq4MOqpErw
         KXRGlXwBfqAmsjOF57Jgb7YatO11jsj+cq6201PrWl4iztrG5Wf9SNH8tXpO8x29DBfD
         anVGYRzvPz0Ypq/o/pJ6nX0qihKYr4ax6xQAU48sx+YRD14E08sg5q7uYRz3XYkdT/dY
         34Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420745; x=1755025545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHm9cX+2a6wEZOmXR7zbZQOpP1vpd9jsxwALDJhOINI=;
        b=EzEz8v472ZbJIVECBFfD0o9ANnYPgbe45D6QbQLngGQLIxYIq6fJKN1aXIQm25ACb1
         c6QHQFnbFKg8AUvqyFAo1Nj188IFmnCgPek1WtLYVnFNt3whl9CZgL6DC77pZgj/Imga
         /44eVUcgSORLSfFc3u0TX+x0QKXSSCcIc+rzoLjHnzqM6rrsbGKMoqt8gHb5FWaGKx9h
         b570LJi7vKrh0NKjvEustNFIceDDVY4jk7HFMLTYsmV3R/D9C2bRex2Wr7cwsgVvo7iZ
         BD335qANHUkJu7lg/TQficRn/ErTtiS7jk23I/Eqr4/99fOwgZbAdNYWoqKJ/UndOst7
         JmLg==
X-Gm-Message-State: AOJu0YziNExNv3zYsNKzJzSkJHHblaCAyacXGQ8Dp4RniKB7PnjfdUXC
	4x5q9DzCnUoOMFt4jEzqvbLh6hWIXf8MHh9atxD5tWWd9aEHOgSAocBvlYzMSkENQdil1J3aLuR
	kPSWpcw==
X-Google-Smtp-Source: AGHT+IGDasRXwFiMQ86DEaBEHpeUlL+2maKDx6zxVfD8zjsFQ8EmHiEcKjpKDebLzmI3pok4pfMV0qtxJc0=
X-Received: from pjbns14.prod.google.com ([2002:a17:90b:250e:b0:31e:a865:8b32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8c:b0:31e:f30f:6d3b
 with SMTP id 98e67ed59e1d1-3216684b05emr89332a91.2.1754420745302; Tue, 05 Aug
 2025 12:05:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:17 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-10-seanjc@google.com>
Subject: [PATCH 09/18] KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_init_pmu_capability() to pmu.c so that future changes can access
variables that have no business being visible outside of pmu.c.
kvm_init_pmu_capability() is called once per module load, there's is zero
reason it needs to be inlined.

No functional change intended.

Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h | 47 +---------------------------------------------
 2 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 75e9cfc689f8..eb17d90916ea 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -96,6 +96,53 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
+void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
+{
+	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
+
+	/*
+	 * Hybrid PMUs don't play nice with virtualization without careful
+	 * configuration by userspace, and KVM's APIs for reporting supported
+	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
+	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
+		enable_pmu = false;
+
+	if (enable_pmu) {
+		perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+		/*
+		 * WARN if perf did NOT disable hardware PMU if the number of
+		 * architecturally required GP counters aren't present, i.e. if
+		 * there are a non-zero number of counters, but fewer than what
+		 * is architecturally required.
+		 */
+		if (!kvm_pmu_cap.num_counters_gp ||
+		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
+			enable_pmu = false;
+		else if (is_intel && !kvm_pmu_cap.version)
+			enable_pmu = false;
+	}
+
+	if (!enable_pmu) {
+		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+		return;
+	}
+
+	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
+					  pmu_ops->MAX_NR_GP_COUNTERS);
+	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
+					     KVM_MAX_NR_FIXED_COUNTERS);
+
+	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
+		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
+	kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED =
+		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+}
+
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd6005..13477066eb40 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -180,52 +180,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 extern struct x86_pmu_capability kvm_pmu_cap;
 extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
 
-static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
-{
-	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
-	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
-
-	/*
-	 * Hybrid PMUs don't play nice with virtualization without careful
-	 * configuration by userspace, and KVM's APIs for reporting supported
-	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
-	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
-		enable_pmu = false;
-
-	if (enable_pmu) {
-		perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
-		/*
-		 * WARN if perf did NOT disable hardware PMU if the number of
-		 * architecturally required GP counters aren't present, i.e. if
-		 * there are a non-zero number of counters, but fewer than what
-		 * is architecturally required.
-		 */
-		if (!kvm_pmu_cap.num_counters_gp ||
-		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
-			enable_pmu = false;
-		else if (is_intel && !kvm_pmu_cap.version)
-			enable_pmu = false;
-	}
-
-	if (!enable_pmu) {
-		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
-		return;
-	}
-
-	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
-	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
-					  pmu_ops->MAX_NR_GP_COUNTERS);
-	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
-					     KVM_MAX_NR_FIXED_COUNTERS);
-
-	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
-		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
-	kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED =
-		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
-}
+void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
 
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 {
-- 
2.50.1.565.gc32cd1483b-goog


