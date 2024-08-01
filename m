Return-Path: <kvm+bounces-22889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B44D944286
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 453AEB2352C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B584153824;
	Thu,  1 Aug 2024 05:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S9s7hcqc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D2B15358F
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488457; cv=none; b=tAyD1BDjfWAEJPwxtyOxPaMJos+EOYbudj/kWkFukCkSgsRtMeGBpgu58wCuVQtCDAkAPpHx44n9DyigOq0AGxcgbcMJeBHpO3vkL+Ai24t5FoQ0DpbomHZK5FVGz3gRVQc9nLViueWQqrXuxPzNan3wz3SIIwP+KpZZ4OtUrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488457; c=relaxed/simple;
	bh=eV0VTFji/+sFryEiNGZW9hnaYuwL+4y7PlybVqifHtQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKTOHzBQw3c407X7Ft/BvL11thGs2BPVt2eOC9taZUkOUA9244R/9QpopkUTMVej4A+MRRVs7cHcmGoIJydR/xNMOa7sPdPb48DBXWDjPOW/QUfTA49WVDBbiDkMmDl5a5BQ3ygPruxx/RrTMjojCFxar6OXJ2X0JlPc+wgC5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S9s7hcqc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d392d311cso5691211b3a.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488456; x=1723093256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3VOoyg1IkmJ6RRZa642jfLxRQmJVLrh6eRxX47OZP1k=;
        b=S9s7hcqclcz4rryG509l0g5hQImNLttXR/QrbsG0YyqRNIYf26igpoIhGpdyh8BRu1
         7BlEBhQ5ZUV7FHrzhTpPqR6/BfEzx3bUCtw13SvOnTPsrYGawfEzft47dzJ9bH44FUUE
         1CW8ckjoXF2Gkie4FSu+KGEXO+pNK04xLpIblBsbhu0BAk6l7EMqqsKdwFHYUzWJBIUD
         8JNZuVbpZOu8qFViT3XFALtPY+SOHOzFPeagC8Zje5pgJbolJGlEdTQoHdMSuuKdd7dT
         KH+veaWaJ/lmT+zLOBZTFldUBmtNVCEUIzb4GdJTqIUTrOq3RHS/N6elnXevOy013xWH
         coNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488456; x=1723093256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3VOoyg1IkmJ6RRZa642jfLxRQmJVLrh6eRxX47OZP1k=;
        b=AgWD21JKqoSiLfs8qY5F5YIBdip4idq8ktpTKDDypTlVGF5e1WbBaPpyupBK3kHEh6
         quNucrRTKk+nKIIYsyYS47LMxqkkMgPqSIh5qywCszc9w0rWJmB7qlyUgNeaKdNF/0sR
         u++LPyk1KwxkMatQxc0hIHGvnt/pv9QRb8r273D0CRZpO5IQCUnKFsVu65/AqPPDmk8p
         BcgEioWO5PbgQIRcdT0ph1oOA0wOhG3Q8HCp7cwASfPFVGIG9W/oDtl5q/zfgYm/4NFc
         N+ZR/g+WIrWhE0sP2hBBlinDyz26dzewxRw4D6SBMIbwceha2HX/mbaANMvxaf63jCF3
         RjhA==
X-Forwarded-Encrypted: i=1; AJvYcCV1cEPhk6qfFiTgK3Dq7oqVJElGU6VFNh5DaFvR4yZNQP7E9m92aeYbvzYCCIVqfZKtOhC+8pPaewpJpPC41xIfDHgS
X-Gm-Message-State: AOJu0YyScLgSu/3yeBj+0eUPIUBTHbgtnmx+gm276HD6M8zB0YaQuiw7
	DJUVpy6aWTWLW+Ri5aMCOdw27+IALvbeGZDrkxoOV9cvTAeNl7Ghq7pR4mmjNK++RieSzFyACY7
	4Pzbyxg==
X-Google-Smtp-Source: AGHT+IEclZ07ukoLzf1pYkJmmMQ+HHGVZo5A5QV38BQbp8xRkfjknzqxOFAU5OGM6vN1ghMRe70pBmZRHJTv
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:6f46:b0:70d:1e28:1c33 with SMTP id
 d2e1a72fcca58-7105d68fecfmr34795b3a.1.1722488455721; Wed, 31 Jul 2024
 22:00:55 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:05 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-57-mizhang@google.com>
Subject: [RFC PATCH v3 56/58] KVM: x86/pmu/svm: Wire up PMU filtering
 functionality for passthrough PMU
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

From: Manali Shukla <manali.shukla@amd.com>

With the Passthrough PMU enabled, the PERF_CTLx MSRs (event selectors) are
always intercepted and the event filter checking can be directly done
inside amd_pmu_set_msr().

Add a check to allow writing to event selector for GP counters if and only
if the event is allowed in filter.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 86818da66bbe..9f3e910ee453 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -166,6 +166,15 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
 			if (is_passthrough_pmu_enabled(vcpu)) {
+				if (!check_pmu_event_filter(pmc)) {
+					/*
+					 * When guest request an invalid event,
+					 * stop the counter by clearing the
+					 * event selector MSR.
+					 */
+					pmc->eventsel_hw = 0;
+					return 0;
+				}
 				data &= ~AMD64_EVENTSEL_HOSTONLY;
 				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;
 			} else {
-- 
2.46.0.rc1.232.g9752f9e123-goog


