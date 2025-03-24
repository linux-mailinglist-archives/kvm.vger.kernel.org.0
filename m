Return-Path: <kvm+bounces-41840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCA1A6E14D
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DA4D3A71A5
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C459269D11;
	Mon, 24 Mar 2025 17:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zcbco0U3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C5C269898
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837615; cv=none; b=ZuQNT6DQSRdgBegOh4sPdk69AwI2L06uVcS/oG3ThxQmsILZ/AnvY+QOBV9TrjrvOzs4/jr5BS/WCMql6fw8eTGonk6l4CSgo4NZUjqnxUd7lPYAU5dqO8y7BukudQ5YRsa060EtaUMxcno9m0QH6m7B5VgtaWm9dAxISp48q00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837615; c=relaxed/simple;
	bh=FoH7tcwE2GeOWEZefq9DrN/eLcHxhIICNsQu5pyoq5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTzrZX2li4UWkgSQO+g132CaBYSRIOefA5v0FIjnAIUNhTSK0ynxY+prr+VbHlOYSlTpLDtJt8J+cP3+z+J1/DwXFgbXz+dAI7XBdBqOwsYI8Z2XaL2bKGeAhpT9NK7lXoT5ehyQyc5Zn842vLRy+ZzcEYkEGRFToHN19BhV55A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zcbco0U3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225ab228a37so68791555ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837612; x=1743442412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4OJAB7txnhcLTcXVYrfnb5vnccIxSZ8DO2qJNaOYpK0=;
        b=zcbco0U3TX5qrbjFdtCpf+5jZIbdBVS0xbLIab9r9HToLxKrkgCxe0oTA0nEUXujd+
         Ft6k7K4iQbVnW865TAQbBDFhcqgwEaXY2uPlwvegZBqOaMMNML1Gb17Luxb3EK7iTUeN
         8jA5sqykKHzcPL+YApgKBQIu8O+tN0Atm/RetygYqD/JbeoQMsdQ89fNkhfNUAQSlgYS
         LqRg9s4JGH8vQKX1WKUHfKqFaL2iLTyebEqkpey8y4Xz0YHxts1WkxMpFZ3P3x3+/N1H
         qLnHECavEVOOPp8gq12fo2b8xQsf/G2Cb5sMoVLZYsNdbx50c4fDfyW3AAmAY5VySzeE
         Y6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837612; x=1743442412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OJAB7txnhcLTcXVYrfnb5vnccIxSZ8DO2qJNaOYpK0=;
        b=CGIfuTmwUb3OlUTC/8zc2jiZIeL8WeEnAy4NkjHM+n4arLk9JKVLHNBA6uqENMdR0R
         zkMHNnrII9r6G/e8PrWqXOYKql4SZLqlnFfTE8AXN9kC5B3C/dMTswqfBS/N6dkMjKmB
         Fx4bsmrPzWrGySwosoh+QAJMaQ1MsksTKGX8TepBOL+fgSdRcsdZdB29OxERJyFsDUR2
         BcERAl9IKItI1TZvT8sP9nWnCttPb+ar5wWXPuUxeX7pw4tRBgE1K5gPMEyDRMgTGIyM
         754W19bckIa6/K5TQ6/cGo74JnycLTsHpoAaJjl4cXVLf3rSJCm4IquKXWS6MakfQA4u
         ryrA==
X-Forwarded-Encrypted: i=1; AJvYcCXolpR1jt16mGSqxrhnzfqWE32THLaTKbpxcG0GrWmnB3ZXLDOWgpGjCo1GDcJLj2QOu6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl844IrENAP8dpcIDoPb2W+DTlHY2KivhdEuy7g/ndtSmIV6qx
	zGIxz5vYYODC6K1z16t4jxUpMVvaynp14CCJnIvagMOU0gzRGiRJSl9ZyjQ9bkiBywLd8ToReMV
	Bp46j1A==
X-Google-Smtp-Source: AGHT+IEWTl/R0f1qfRJlE3emUEFa0yj+sOW5pbNSYV28FCQ8VzTuf09ewlLJoB3GkYH0qtajqpf5IDFU59K+
X-Received: from plbkw5.prod.google.com ([2002:a17:902:f905:b0:226:342c:5750])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:985:b0:220:c813:dfce
 with SMTP id d9443c01a7336-22780e0a965mr250833335ad.39.1742837612577; Mon, 24
 Mar 2025 10:33:32 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:31:05 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-26-mizhang@google.com>
Subject: [PATCH v4 25/38] KVM: x86/pmu: Add AMD PMU registers to direct access list
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Add all PMU-related MSRs (including legacy K7 MSRs) to the list of
possible direct access MSRs.  Most of them will not be intercepted when
using passthrough PMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/svm.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a713c803a3a3..bff351992468 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -143,6 +143,30 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_K7_EVNTSEL0,			.always = false },
+	{ .index = MSR_K7_PERFCTR0,			.always = false },
+	{ .index = MSR_K7_EVNTSEL1,			.always = false },
+	{ .index = MSR_K7_PERFCTR1,			.always = false },
+	{ .index = MSR_K7_EVNTSEL2,			.always = false },
+	{ .index = MSR_K7_PERFCTR2,			.always = false },
+	{ .index = MSR_K7_EVNTSEL3,			.always = false },
+	{ .index = MSR_K7_PERFCTR3,			.always = false },
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
index 9d7cdb8fbf87..ae71bf5f12d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	72
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.49.0.395.g12beb8f557-goog


