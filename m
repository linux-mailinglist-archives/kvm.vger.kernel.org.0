Return-Path: <kvm+bounces-41827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D82BA6E115
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83071734A6
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019BB2676D9;
	Mon, 24 Mar 2025 17:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lqrla69f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A5264635
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837595; cv=none; b=njuzWdQAWjqvGu34n1Xoo68Plgzafpt0mTvMNKPrlxhoYHKef19Gy3HwbP6gRsXbQpJAchUjpLhn1YSst2zRnqEx6o7TSKJM4VIZgkMlNQrcTxklDw2LTfxaamaXa+By8CHED+oPhhs4NZRiLPIC/9otFnug5U8F6+T87v9cin8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837595; c=relaxed/simple;
	bh=aKPDqW/NC3IvupYuKRIdymXqUgDQVOkH4kyaS7aodbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PlZbg19PYoMSJNXxBrOqjfytCCpzMvRHfMqR16d4M1qMGkzxqivzCWPdTe/NWwYU4+O1sK+vfx5lbln56rNSuMyZQQLNmymsBR2sUI8jNZjKn1Z8c7IsK+qro3ffaMpZdj8mwrZo5bQdYhmH7mdh2fTuTo60ihO3ZFlz2fmRn30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lqrla69f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fec3e38c2dso12476535a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837591; x=1743442391; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PnRSUNVr3rnNCPEtvYKiZWXoNmnUmRmeili7I7gz5MU=;
        b=Lqrla69fQi/OIOipNCmy6MYeX8iAbsZZbwtbh3UzxcB5h37hLVOUsnNr6i2ajr6umc
         tloDyA/gygXfU4fO1nsS0W/ppTjTITuyxGGNj5nejn/0UDfl0q42GqEVdbZONH5y/sHP
         OsEvKAbrUnUad3bAPeQkp2oRn+pL1QIya7hiJNVFD7Hdy4wfXbaJk6oqDtNHmeR22Zpm
         PF8r45BL+Eqz+qZWzQi7dw/4vVUROUqTjSnQ1BfHDNL4RwvZVl4CqZOGoB4TCRcKcu8z
         /XWSvrnQK3DLcEpYo6dvAapn/H2p/9Oj4MExjpCF0my9L7JRd+nbQd7BK34oVR4o5O0A
         bj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837591; x=1743442391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PnRSUNVr3rnNCPEtvYKiZWXoNmnUmRmeili7I7gz5MU=;
        b=p52gj0vvTd8Bb7FqkyL6CnzuA15MaO311s0fAnnzw15JosNXPMX7v+mXjl0bOqSSQU
         h0QG7dHBlYCI2qxEX9sAVRneGhgK51dRZxHL/W+ZFVZ7QU3jNcRlA3A0zMcjtGU/gGx7
         /2WHeSwdmCuIKMW7iWi1N+fLCzuVQloS1UZV71KLCXfLB0WFCb5SmzaFNHSi9BizHgja
         oKUu3fIZnkcFjUjVCei78TMoO7ZqMRIdHCdEyBdas+BaAusp5N/D/lMqTRh14j1VqOeK
         5RRbfmw8OiUnIDVUf14u2/P4ZM8XrXF7EedC8CO1GfHuZid7OYlEG17woOAHJWryntvv
         yt+w==
X-Forwarded-Encrypted: i=1; AJvYcCUMW20Pi8dPUQcQuVTE8P3syiV9xo8b3Tt9RcWzztZyv2VMqkJORJeFut3rAxx26HF8SYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMkx67qUnYkJr4Qaq6ITXBlD4LtYsH5vP2Cf55SvyevmuHQKp+
	7KebbGL8LXuf18lkioGzl8jK1YRoTFNoWr1o4ScozqUtlbVAtyOiXMKOZvQA0V6vm/v4yXy8abY
	8jYSNfg==
X-Google-Smtp-Source: AGHT+IEW+7GJcDXGG6CURiKG3q1Lc5zKORtSrc56gB/zRY+t9aZM8BPwlqJUyaIgVCLGS/H1C2BVYJ2TtCKc
X-Received: from pjbqx3.prod.google.com ([2002:a17:90b:3e43:b0:2ff:5f6a:835c])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcc:b0:2f4:434d:c7ed
 with SMTP id 98e67ed59e1d1-3030fea7d0cmr26492841a91.16.1742837591632; Mon, 24
 Mar 2025 10:33:11 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:30:52 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-13-mizhang@google.com>
Subject: [PATCH v4 12/38] perf/x86/core: Do not set bit width for unavailable counters
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

Not all x86 processors have fixed counters. It may also be the case that
a processor has only fixed counters and no general-purpose counters. Set
the bit widths corresponding to each counter type only if such counters
are available.

Fixes: b3d9468a8bd2 ("perf, x86: Expose perf capability to other modules")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 96a173bbbec2..7c852ee3e217 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3107,8 +3107,8 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu_num_counters(NULL);
 	cap->num_counters_fixed	= x86_pmu_num_counters_fixed(NULL);
-	cap->bit_width_gp	= x86_pmu.cntval_bits;
-	cap->bit_width_fixed	= x86_pmu.cntval_bits;
+	cap->bit_width_gp	= cap->num_counters_gp ? x86_pmu.cntval_bits : 0;
+	cap->bit_width_fixed	= cap->num_counters_fixed ? x86_pmu.cntval_bits : 0;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
-- 
2.49.0.395.g12beb8f557-goog


