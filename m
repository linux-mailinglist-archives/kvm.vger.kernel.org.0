Return-Path: <kvm+bounces-22887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FC0944284
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF11028960C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F91153565;
	Thu,  1 Aug 2024 05:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wcxmruUm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC211534EF
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488454; cv=none; b=HPv3wz28lgrP76TOQxV+bgDj3Pv1cy+utGnlfcHqqCBUHQNImb7yAWqvTuOqsHLBLjCPI+VBBN/ftZxIHljezXW7vwBr8bDXOaxDuLJ85I50sPWs0Z8q+ZanoxvOliEBOs09bECd2Tysedpd5yjHXTTk0GlsoT+HvzRsW3UAK7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488454; c=relaxed/simple;
	bh=AQu9CJlpiD7JOUVngaIJhBzSsl0Ca9lu4IgWe3SQ/fk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RTU5IxoYleU9kNkpBFDv1DqkD9LyeqXMRZAR5iaDyXasTKzeoT9nXtENmGbxNF+MEbtYVa3fLgCjY1+qc9dRMeE68SBkQNzfPMFHJoOLlbXlDUYB/lmUnqvGTSDwzOHZeuG5g4I4bt8y0ikMf67cSWoPWCyl7A1f4AUce8Xzr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wcxmruUm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-79028eac001so6061377a12.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488452; x=1723093252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8hg3GW7u9rE2O+00AHYjQL6l0Apz+A7KMtHXAzzNMVY=;
        b=wcxmruUmAcp5EaTl8kfoLrWLUbgE1DCjQ3ILXHltZEB1NW42VupKcNWkR9axCpllCW
         5ch3OSfGPTivGpb4KJC6t4ML5LtEpLoumyheByikGDRYueDyoDt+ZbYa1e5lQP8rtAUj
         3ZQwd2iSvRSEbaNADG5xPmEj2xtMyLdGleX6X5kdgxEI6uP/c7poGQ+lxMxQYOA2sgDj
         fX+GqglAOE5vDGPBAaAu2kOpMnbxDhIGV3/ufd2dO5sKHVvHORDmMcPHAxanTg+vbrdj
         XdyBZxI+QRFFGjAJem3TacSf7asDRZDTNqhPuqhoik6iDEqkwluIWv8Hu/HIZOwj/F3J
         4ZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488452; x=1723093252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hg3GW7u9rE2O+00AHYjQL6l0Apz+A7KMtHXAzzNMVY=;
        b=rf5gOp4Qz9Zr+5UdXWjxLdOL5qfENcxsqKpV3px/WLyLX2e9mA6Hjszb4rKrPn31rV
         V+FuVbWG/y65n8WBYYl3HGvqRcosGBJnExfI9ZGisEyRhKHTL5e5qQAZjnpIlMjZXoQG
         LcIIA6HVrzkzEG2Y3U87kaXLUr5MCsE3xz6GDTojZTgT6f0QfmhbwBXeqnCEyWYKhj/1
         nUqRSwD64qxLdTWANJTu3Zoa2o/hJ9/dhrwfJFnIPJQXw0S7lD8u00X+1zmJE2ka8Nu8
         +vWBLpEV5JZ6MfeWvuOfKA/XPJUVNN4IJcNjXsBZOaFJ2rgAD5MrxzlCh1u92zCcjiFI
         XMfw==
X-Forwarded-Encrypted: i=1; AJvYcCWM8RfbUPlDTwfsOn7Hcpc35w4Br0BxKXOXMJUA6NxS585GsfSkPzji30pl2Nf2yctFACh+DMV4pmSKnSaU5kVT+OYf
X-Gm-Message-State: AOJu0Ywuy0COCYPc60Wia86Bqmm2L6Hr4JE7JgWBoBamPWmvlQAiz6nu
	plzsVFOcEZoM6YLNAy2jIxVlyRWBWFbnuPrLNEIzzWE490bS0ZfnG1ru+G8GbWr3kIo/N2Fj+RA
	fkSb6lw==
X-Google-Smtp-Source: AGHT+IEyzaQ1LIq/msoDOdJZ/0w7NMmQUez/LxB6xhMj0/9BAUy0e4hdyO+JVmr21/iEnITcymNYQ6Uqf8KT
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:eb84:b0:1fb:325d:2b62 with SMTP id
 d9443c01a7336-1ff4d224c09mr430825ad.10.1722488451817; Wed, 31 Jul 2024
 22:00:51 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:03 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-55-mizhang@google.com>
Subject: [RFC PATCH v3 54/58] KVM: x86/pmu/svm: Add registers to direct access list
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
index fc78f34832ca..ff07f6ee867a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -141,6 +141,30 @@ static const struct svm_direct_access_msrs {
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
index 0f1472690b59..d096b405c9f3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	72
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.46.0.rc1.232.g9752f9e123-goog


