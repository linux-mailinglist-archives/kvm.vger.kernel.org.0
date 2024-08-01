Return-Path: <kvm+bounces-22881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 382A394427E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 696141C21F56
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AD5148FEB;
	Thu,  1 Aug 2024 05:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Ry74xMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDD015217F
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488443; cv=none; b=NinaDh3OyfMLr6K6jY/HgYTVTX3hLN+FAqaTFWvfx88ic7Q3iMa4FO1zNEBwP8tYHqnSmz1G2QYbHK0J1N5GAH02mDEZ7WpEFrOc8/aEwE/Jr08lQI4XNt527P/qnKdn5rxCGjRIUs0PjCVuSbQkRd3ESXBJzqbtqMEW0n9xpRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488443; c=relaxed/simple;
	bh=gl95pBxp7BeyG9K/Y+Fnr6+jDVQ1IDOMug3Ga5gpSNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CphTO9VvFJj89wi2RHoku6gNKhqxRnVeQsd9NTQJZByVPoJyHi7ba7A1MQrLf1syBV7XWfrFHj1Yy+nHrZSM7XegAh7Coukn3ilUCKCe8GwtZvyHDxWbE1mn4Wx8E/Ayxhm+rOxo6C4GsgZldigUafv8Sr1JeRiufCd0gcWAx3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Ry74xMc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e087ed145caso9045340276.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488440; x=1723093240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CkIYviuQ5dR+yDR0bvvzUB4JBAAA8hfQoQWbxFCrigw=;
        b=0Ry74xMcCmcncRcFeZ0/SPAb8d5pUnKs/ZU7KPH2D5ZY6x8u5kGVgXeAZrUvBr57YT
         OyeuajcSWBLDdemiBsR90baehx2/0+8wTK5WZZpoXJzF4UYBk4EHkyYwunlh/vjVn5mg
         m4IXnX8/1+ZQEQsvzfh9ZmpJjOino7cRiwrIv+ovkPBYIfhRmH093RWYPp/nKnW6Mx0i
         Nx3SC2ntX9vJUuqrRIWLl6hPv5KCm1hTF4LWpHa/XTlHHKm2Xe4VNaTkJBjBZFcXsu5T
         6I5eetdYns1yzIZfR/060wTs2dyhByUcgoHT+wlJyWvV1cFK4EB/6ky+M5tkwH+A5/M4
         lSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488440; x=1723093240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CkIYviuQ5dR+yDR0bvvzUB4JBAAA8hfQoQWbxFCrigw=;
        b=KNHmhoFuTCHZsYnSk4VKLmpc3vy7mMVBrroyPDYYLscxjauAy53Hc+OPihoCMo1EaQ
         RQwpFgCvwFGrVi6EmmpbYnd0FSt6jOIo0MhpigutjLItiLUEmfjfinss9YHXH6Y6VqoG
         nOouj06NIj6HxF3vM5Yptjuhe1vJsm8CNuAvs2dTsEl/EtdwP1VkSxSOmxG2RclogIzp
         uDAgJAxEsOl7YdjIpp1vGfjh0TcOcZATrhh4fq4MHq40DPZYJSYemPm7Zt9IYs2v0iQU
         DJGhVip3QW20TvtBe1YcAxeWRdtjHs16p5THKk3wm5ZFHw2QBN+1dpU+KiIaucjMSTFJ
         QpKA==
X-Forwarded-Encrypted: i=1; AJvYcCUTeZiGlMtij0Sc8CGb+hn4PJN07GVeFNDc2H9dRntyyCFAjlweoZy1TBYCI9lwjdXRvmyyozjCzAUINIcvdiqOFT/W
X-Gm-Message-State: AOJu0YyUWylXvzGNuPyBLrPlsW7zg+N3dwzdVwMF7tFAgbFN53nfNkmX
	8L4VCKBHihGwa8/PdlLqWJKrL/10vZvV7HUVkUF07UHlZS0MWLLcDThsVsXe7FCIwsUIH989b+h
	ykQcThw==
X-Google-Smtp-Source: AGHT+IHdlDxVEdWmfC6yxxfRkAXJgX2CgLmJcYEVF4/LpbYxa8ZRj7AVmDXVoAKs5gqpvX3cXhcOPaWAIdy2
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:218a:b0:e05:fc91:8935 with SMTP id
 3f1490d57ef6-e0bcd28c40cmr3086276.3.1722488440480; Wed, 31 Jul 2024 22:00:40
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:57 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-49-mizhang@google.com>
Subject: [RFC PATCH v3 48/58] perf/x86/intel: Support PERF_PMU_CAP_PASSTHROUGH_VPMU
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

From: Kan Liang <kan.liang@linux.intel.com>

Apply the PERF_PMU_CAP_PASSTHROUGH_VPMU for Intel core PMU. It only
indicates that the perf side of core PMU is ready to support the
passthrough vPMU.  Besides the capability, the hypervisor should still need
to check the PMU version and other capabilities to decide whether to enable
the passthrough vPMU.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/intel/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 38c1b1f1deaa..d5bb7d4ed062 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4743,6 +4743,8 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 	else
 		pmu->pmu.capabilities &= ~PERF_PMU_CAP_AUX_OUTPUT;
 
+	pmu->pmu.capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
+
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->num_counters,
 					  pmu->num_counters_fixed,
@@ -6235,6 +6237,9 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
+	/* The perf side of core PMU is ready to support the passthrough vPMU. */
+	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
-- 
2.46.0.rc1.232.g9752f9e123-goog


