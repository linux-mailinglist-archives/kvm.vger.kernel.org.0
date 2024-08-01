Return-Path: <kvm+bounces-22877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 956BC94427A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00D3BB2330D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7D61509BE;
	Thu,  1 Aug 2024 05:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PFvEsRow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97921509A5
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488435; cv=none; b=H1b/05+ySnbXW9+huU1Hm7b5QcjVmt1ZGAZ5eb6+vYFv3JqiPdSXxdv6I/IsYMhJrCcwXnm8OLcEd/PTRRdQP2lEFygqKn6z6lFWYhFSAxDwG2two4B77dXMZvUNUxoyOog4KgeOpkpXGW/Tpd3bHs3Q4+RGBNc24G97JTbIWYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488435; c=relaxed/simple;
	bh=gtemBvTk2lbV8xf3rduUWl3sB4EfzskwrEwm5VO2/vE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/lOCdgrcexcmnf4UweLWXU7PwJtkycobnPKSCSvus2KXyHuUqdw9KOYFwoTFitooDe3k6QzPhk9OVnHGX3ndH4x/LlCfmEkqzPlqyD/VazMNfapa/cCZNW4i927POWa8wxwc44TmA76nT6NuCOVmlNUtjtezhcNY/S8Htd0cmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PFvEsRow; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650fccfd1dfso120371997b3.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488433; x=1723093233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TIaORN0fE0skJR5pSCv7IKrnjEmXFRXmkgvuWeH6mb8=;
        b=PFvEsRowABhzjOebOTBtaYd3yoGrCsT0R+Jb4sHXQ2OKiE9Gd8gaHqFFZUmEF6rtLQ
         DkTBTu+ClomVXcpwqpVmf6EUO5BVUQDEIi/V8FEUU0Cmm8AHrE5QzlUUY/YiDksmpo15
         ZejNfZM/62H5C72HThkNywl3vn3aAReUYR48IVDoyi5JijSDs1zNfJy42us8W4XckJGg
         0r0kfdn7Hn2HEb0uc1bumQIUNI2RVqB1/zKNjasUQyzsg22qIC3OqLYxbXsJF/DP7Sat
         /43mmeyLRujSyGlNpwmk5bctVp5WKqTaJXznrQ85AL4bODmIFSyR4sIsFyFxuL1eVCCC
         Rf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488433; x=1723093233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TIaORN0fE0skJR5pSCv7IKrnjEmXFRXmkgvuWeH6mb8=;
        b=VAis3KeiaGxxiHCBVtmGQDBBlX/GZgSHnYN/HuEiiL7R2r4jyRYK9pCvcK+mKraO7o
         l+1lbbAwcHN5V7cJ4uMTIz59b2hAHk2voUVQLwmL9aO5R5dXw9jqMm4t9pd9rIr8FRMN
         hVF2he4otP7LMTliX8+VjcKLUlDNheHEyq+IZto96Q4jC4/cxqrZs5h5FZooA5EsGM6y
         UQOVmjkycb0zrASbEpGufq7fwd5kRJ4wCZMbxEhrnsc5NRmO+JwH9mIpn/Np/tNobqgv
         CNsVT7wbbXiuZXI0BO6qVR/mLeSrU6VwA/BYbPJxoh0bYeYVPZO0D8aoHn912XN3uPYF
         8Jsw==
X-Forwarded-Encrypted: i=1; AJvYcCWozEGohh8rX1Jc4KtuF9OObtUsGuU3XmjDx63FvRflFrCmUDYKryNs+JHQgSAja+J/LlxooS6w5AqqAkVZ3U/siymp
X-Gm-Message-State: AOJu0YwUll37uoiqpb2YJihvexZMbfj0CZwK0nfJRfrIFlAPSU8KhbXd
	ckMUpkMJTdorzBhMjO64n6DYlg5cCeI1zJl48iEI3zdPig4sAv4fVCNd3IYUuX+TWggSddIo+4n
	3UaV91Q==
X-Google-Smtp-Source: AGHT+IE6GrVg0oI7YgKfRUu8LQp7LFjo+hVTe1xzxA7oLbHsyfE7RwuRCLp1ZikHSyVNP5OgmZRb2O/kzfY7
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:2009:b0:e0b:1407:e357 with SMTP id
 3f1490d57ef6-e0bcd1fd0e3mr2207276.3.1722488432889; Wed, 31 Jul 2024 22:00:32
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:53 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-45-mizhang@google.com>
Subject: [RFC PATCH v3 44/58] KVM: x86/pmu: Implement emulated counter
 increment for passthrough PMU
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement emulated counter increment for passthrough PMU under KVM_REQ_PMU.
Defer the counter increment to KVM_REQ_PMU handler because counter
increment requests come from kvm_pmu_trigger_event() which can be triggered
within the KVM_RUN inner loop or outside of the inner loop. This means the
counter increment could happen before or after PMU context switch.

So process counter increment in one place makes the implementation simple.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5cc539bdcc7e..41057d0122bd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -510,6 +510,18 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 				     eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 
+static void kvm_pmu_handle_event_in_passthrough_pmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	static_call_cond(kvm_x86_pmu_set_overflow)(vcpu);
+
+	if (atomic64_read(&pmu->__reprogram_pmi)) {
+		kvm_make_request(KVM_REQ_PMI, vcpu);
+		atomic64_set(&pmu->__reprogram_pmi, 0ull);
+	}
+}
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
@@ -517,6 +529,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc;
 	int bit;
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		return kvm_pmu_handle_event_in_passthrough_pmu(vcpu);
+
 	bitmap_copy(bitmap, pmu->reprogram_pmi, X86_PMC_IDX_MAX);
 
 	/*
@@ -848,6 +863,17 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+static void kvm_passthrough_pmu_incr_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
+{
+	if (static_call(kvm_x86_pmu_incr_counter)(pmc)) {
+		__set_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->global_status);
+		kvm_make_request(KVM_REQ_PMU, vcpu);
+
+		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT)
+			set_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
+	}
+}
+
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
 	pmc->emulated_counter++;
@@ -880,7 +906,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
 }
 
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
+static void __kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel,
+				    bool is_passthrough)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -914,9 +941,19 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
 			continue;
 
-		kvm_pmu_incr_counter(pmc);
+		if (is_passthrough)
+			kvm_passthrough_pmu_incr_counter(vcpu, pmc);
+		else
+			kvm_pmu_incr_counter(pmc);
 	}
 }
+
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
+{
+	bool is_passthrough = is_passthrough_pmu_enabled(vcpu);
+
+	__kvm_pmu_trigger_event(vcpu, eventsel, is_passthrough);
+}
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
 static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
-- 
2.46.0.rc1.232.g9752f9e123-goog


