Return-Path: <kvm+bounces-16664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B96CD8BC700
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C69ECB21E53
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3811144D28;
	Mon,  6 May 2024 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NhdB47hE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965E1144D19
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973527; cv=none; b=mI6pmInF09HdrLTQUjiwF2Bd+bNFxGxjj8G4k6P1y7rlQ4ev/D6YknjSpD0vexGulKgnuCfjStlI9PenbXLcnxDdJFFoRS9v0oxXqpKUzxEDsSBl9w6HZJm91oeAOvBHhqYEP+WGWiPq1IufmwN/D3RH+zAA2+I8BykMOnizxOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973527; c=relaxed/simple;
	bh=wdPL8dcbid8PnFKN2WjLETKYo47YTFvfbY7t+ghBzb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pfAdAhGet/jhOGesH2VP6+NCKnA6jnHLX7hDNLswJTsDGdepzvZf6WFQwQbDDRWw5cDnB9v8xy4V/IxnHu9nxf443Am0ZYo/bs5GA+I7Ze6FX7WGNQLCA0wd5l7ZD7liCdk9KOMmNZlEvbYx9NHHPUfidoAQdIHf+BQaMh1zFaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NhdB47hE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be1fcf9abso20851357b3.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973525; x=1715578325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oF58bMgfpMDSfKcTqfRJ2uMfc94pZsxsRE8CrdesvXQ=;
        b=NhdB47hEiYLcmxnX9Hh7+Mnox7qGcvmjC6Fo8kOi0hbKJ4n596RV5Vg7gRBRvTFDYL
         ZJyd9ez7vD9TwMrDVztaIu2PWnpVwAlbuXe1NLQgUnSkhEpofFwNH/zRj3x7btTmC3dj
         XjQwEjd8spFYs+BWO3syg70bG3+wHE4TPe2pIivfmS7XXqKe+IEv0FgCxBPhSp/aSuT/
         pfRcBJwf0S03TKS7HlIintILW0wQCQSiPhRPEHLyU1ohlJuOMG29tzPtzpJXJ+b1lVoY
         1N9qyYcfhSyxCSnZ0Pf7d+zB+IKczlO7TWcBAC5N0MjHdp0Ef2kOQ+jDgFg4jOoqm6uv
         4spQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973525; x=1715578325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF58bMgfpMDSfKcTqfRJ2uMfc94pZsxsRE8CrdesvXQ=;
        b=Sx6cDef7mQeHO/1hMc6zg3Hbun3oZOLpS0EZYwrjlZ18R78a9Wlys3NuvPYhy//mHF
         XyzoT3Cn+o3nWiXo+ZGot/MWjbeiQC6kv8hzPvH+NsbIKsHTdsqyCTpJbG/ZlVWjfiQ9
         8Yfv/YU+2Vu3KilGjjRhC2wXV4uNeuUFugnsRA/cHVy8wJ/zUrTNy2656fyHHaUyLwWl
         rfBboFSdKnJC4VxpHuxblCF9AEAyvdcOXrhiwGb8hIXkoDgmUHB5Rn2plkbkb340uoqA
         x4bGR7BzZSxIM36woRtW6Qij0SrnNFQfXMrDfpZ7RRAANT97DfBKAXJ0GIM96X+ha6ef
         pyNw==
X-Forwarded-Encrypted: i=1; AJvYcCUYOasD9413HvYS8PAtlQKens9HwkeBADOm1dgNF/umXUH1oR3fo2foXFWm9kr6ozDcyvXvvB1ZbabTouEMRvtbnL3j
X-Gm-Message-State: AOJu0YwUW8y+FCd221y/2knlW1j0JYh+Vy04wh3xQTejTgPuHF+2QCzi
	WJI6wQAEsIWGUPzGTopc8S3cQNEfSax7w0FhTi2wpvJr5TmG8R0t6DrSjfb53q9TNpN/TRIYUSc
	fiVOSVA==
X-Google-Smtp-Source: AGHT+IGELUxxw5ZU6ZczIKxSiz7ENtZfxB1cVvB32fDAu0mXngW8DrWy1sQxK64WjqgNg7CRYXrDS9N/k96R
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:ac56:0:b0:de4:c2d4:e14f with SMTP id
 r22-20020a25ac56000000b00de4c2d4e14fmr2809017ybd.11.1714973524760; Sun, 05
 May 2024 22:32:04 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:17 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-53-mizhang@google.com>
Subject: [PATCH v2 52/54] KVM: x86/pmu/svm: Add registers to direct access list
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

From: Sandipan Das <sandipan.das@amd.com>

Add all PMU-related MSRs to the list of possible direct access MSRs.
Most of them will not be intercepted when using passthrough PMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/svm.c | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 84dd1f560d0a..ccc08c43f7fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -140,6 +140,22 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_F15H_PERF_CTL0,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR0,			.always = false },
+	{ .index = MSR_F15H_PERF_CTL1,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR1,			.always = false },
+	{ .index = MSR_F15H_PERF_CTL2,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR2,			.always = false },
+	{ .index = MSR_F15H_PERF_CTL3,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR3,			.always = false },
+	{ .index = MSR_F15H_PERF_CTL4,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR4,			.always = false },
+	{ .index = MSR_F15H_PERF_CTL5,			.always = false },
+	{ .index = MSR_F15H_PERF_CTR5,			.always = false },
+	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,	.always = false },
+	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,	.always = false },
+	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,	.always = false },
+	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,	.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f1fbd874c45..beb552a9ab05 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	63
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


