Return-Path: <kvm+bounces-16655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1D08BC6F6
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B2EE1C21110
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471F6143C7A;
	Mon,  6 May 2024 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tc2QyGBr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8815143C60
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973510; cv=none; b=IK9bhlYajqWDw9LEL3YLolCfnGew3JsYj+M6vLKqiU+kIgJpfjDwPS19t1hsOFZO+bvCJSoB2wwSwuzjlQdU1+aHEeeD52LqFyiqOGsCnx2cg0i4v0oMrjSFDwgdVangmnX8emapJLy5dvChTksFUNj2ssZjDB+OCKMTidT0rYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973510; c=relaxed/simple;
	bh=b/P/gkmdpkwdCe7Xv7Hg2B3zNjJs1cOBq5vflYDSvQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CRb0yPtJ6oIaTGz1BZTuSXkrIMeRbItImwE+iHeTtKALDYxXQINW1zxitroGsUlHssAD8LgLOmrl7yPioInU8kCPqiEEVt4Hlm1ryZfoPK/0mqXyYYbKI6qStKb3u7v1a5TzzLVruW2j15hKRtyoYgONyxZM1q60OjVlAFLjXzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tc2QyGBr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b028ae5easo31282267b3.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973507; x=1715578307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tX8Dgq5ewz02szpnrMWrF7pO4CEI9/6VrSnV9138ff8=;
        b=Tc2QyGBrrlJ1U2Gs/ax8er3VbGvnZd3mvT8v5tKzIRJsVCTBf4kxyBUsZe2I+KtSeb
         VRBgd6icB2XZE8jTdYepX+jepAb6c5aKtJhHu2YnQZsHF343BK3EmUZtYcPR9f8OPpmS
         or9pKPuTKw1E53uFdFsBZTAwRHrhxuJKBfT/CXAjUeTkl8dJmUkLwVd7RbrzOXEIHiMG
         jfKwz/xcZB/LEIlZynC13/tzbygUWbRYp4em5vxFb9fnubnHAUiyJf3nCPWGlkgNyCG+
         627dQjPqbNAIdaxaycqc4m75wvflJlPjMtkVtGS6pDf78NwNehatMgBjLLmXpaXs7c/A
         izuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973507; x=1715578307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tX8Dgq5ewz02szpnrMWrF7pO4CEI9/6VrSnV9138ff8=;
        b=gTyoAJDq5zK+Y7BDXLWsF774Nn3lRte4wqEhT5yzgkTlQu+jZ9V41OUMw7y4XlHLOZ
         Uj9KjLSsSD9ZyOyqBX56vv+uUf4X/vM5iYRSk63WXCIR0mRGyFrpvz/YnaPYsTtgg4yM
         TGg//Rn4/NJkv74gWQ/llsINsz8v3gBIBSX73/EgFaf1sgWS3aRzteH46s0ne0MssXmO
         dGplEa5QWbsOOMn4io2NMjGGSZu34OzNxMurWZpAnC19iT4o/OSdNtM065+LWR+c1Bsw
         F6boS5OZU3glXP0jgskgcoPNJ8wqb+CVCsFWAHdU5FHDWPF7ce0UnSecZu8v06c+f4WM
         RpMA==
X-Forwarded-Encrypted: i=1; AJvYcCXrekE8Lhf6y6NbKEYRNnv6Rw23Y19NiZJKasu8dLcG8KRUjYASVz1ro1WeHM+vHMXtHEKlwzQaBizUI7JLIX3p71HW
X-Gm-Message-State: AOJu0YyRdI9tjo+aj9FkhuB2boty37uZqrjeEMFkReoezJc6hQrqyWxL
	/mE+qtz4boV75W/9S8G2r3PREnR91P25BdF837QvUVGFvo6UOyZh1AILLnrhKIWuAZcchdRV89t
	bwUqOFw==
X-Google-Smtp-Source: AGHT+IG0dJqulSQCgFV/zhqyz9b6/M0NS8Knkq7ByoXipCtrR2cMK7wbJyY7hepfUVtSnQc1M0T72skWCOQc
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1502:b0:de4:c54c:6754 with SMTP id
 q2-20020a056902150200b00de4c54c6754mr3292381ybu.3.1714973506891; Sun, 05 May
 2024 22:31:46 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:07 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-43-mizhang@google.com>
Subject: [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter increment
 for passthrough PMU
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
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
 arch/x86/kvm/pmu.c | 50 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a12012a00c11..06e70f74559d 100644
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
@@ -880,11 +906,13 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
 }
 
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
+static void __kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel,
+				    bool is_passthrough)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	bool is_pmc_allowed;
 	int i;
 
 	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
@@ -896,6 +924,12 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		return;
 
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
+		if (is_passthrough)
+			is_pmc_allowed = pmc_speculative_in_use(pmc) &&
+					 check_pmu_event_filter(pmc);
+		else
+			is_pmc_allowed = pmc_event_is_allowed(pmc);
+
 		/*
 		 * Ignore checks for edge detect (all events currently emulated
 		 * but KVM are always rising edges), pin control (unsupported
@@ -911,12 +945,22 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		 * could ignoring them, so do the simple thing for now.
 		 */
 		if (((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB) ||
-		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
+		    !is_pmc_allowed || !cpl_is_matched(pmc))
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
2.45.0.rc1.225.g2a3ae87e7f-goog


