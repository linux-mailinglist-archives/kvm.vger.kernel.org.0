Return-Path: <kvm+bounces-16626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE068BC6D9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12F5F1F21F0D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330BD1419A0;
	Mon,  6 May 2024 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0b2jmsvo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40D1411F4
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973455; cv=none; b=thJ75M6cm4zj3SC56gUHZJkLsr42y8rG/cT4IUR7YQuhG0TUjNHB1Lnu3KTZUrKrImuLGrkbLu9mmghLE7cJqGQ8ZNJrJ27cJtURPinsrjKTBpV8PFPFk9xkOTKdJWgjdcNDMcxU8qcTGzleDmV/LqtgDmSWm72TFRO57w6J53Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973455; c=relaxed/simple;
	bh=wRxUTC7x9CWXEvNMF7E9sx/rU7V4s3S4YgbgezX91CY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ERfzEoXtnBeyitUfZVtRt35cHpKsvlgSl24BQHvMQ5fhsVwEX7ujvKDQzRIozh3iZCmu0AkXepP3v73ROI5dbzH6AqW3qdEqkogD7X0Wjou+q7cMBYsIduSJfCyihJecjed/AZ92y8cGVAgb97a9a4knoXc4ajOaH7/qxzP79R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0b2jmsvo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be1fcf9abso20843457b3.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973453; x=1715578253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bP3oBwDW20hxSg6WVcXvnMQIVNdAHwD/LZxVaA/0aug=;
        b=0b2jmsvoLPhYw+sh3OmL3+R+9NIMVFg/6Mxr95uN0jjPp6PJdNbfgsKBx5jfSSPo69
         1RFAlfa+wWiF7O83KBCtoFgQAx5LClu3K/vhwiY/l5kHZPzsrd+5oS6osXY+3m83xdmf
         ggbCsjnnxO0oDFjr0Zfb6s8EQN7FuZ2E2BUunkP4YkVOkVJJRvENFyCERA9clIpP1oKH
         A9aakFfhSdNhJRWEsGGbbwbvKqB7/3T8s5H2341e8W000++UpQ52BONDxIGGNfKXqTCQ
         DI3E12cQ2N7bj3xnrMTYj8iirXl83TUduKBpP2/Ty37LlwK3c4bZLqoiMtkob1WAMcZg
         ecWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973453; x=1715578253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bP3oBwDW20hxSg6WVcXvnMQIVNdAHwD/LZxVaA/0aug=;
        b=FWllX4HlrypZpl4YUiZ3/PoMfWWZ16zDY54ZG/H34atDIEcefMUri1hUQxSYEzKwuu
         Q+MqkzALnYU5W0s470fsY7L+XDmoNkJ6xxv4WZ5SWIqyi7TQ5Wp6o3R3LxW52dPgmuwB
         XiGXp+hFWM3PSyo3jYJu6irM3KnsIXu8Xzpghqf8YD98rkSqWgQHx49wz6k5OtycZQ7J
         LiKz2o+JLBDd4vvOjx+nxgVMt1vTt1Y4ZBGe368+FL2wWx3mQShwHysKYSu8Lo/W4pzW
         4x4q1Zg11VtlPXg2pvZVFlgn85g9I4kghXjpo3Qu3qc9RoE8mbk+/53r7SgG4rtAEHDt
         psvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHh9jxDn7WpZ1HLjvXnIiCHxEvus85/9+bE6Hk7H5JBIQ+IdHwI3/hO78C1qKe5TS4axl/qGP+890c5ejmjcdRvHbr
X-Gm-Message-State: AOJu0YxoJE2j+pTke/C/hyg7Ouu+gnstss617G+e6EDPYbZ9p5uYO5M3
	l8FX22E81XgJO5VqTKwMBjzaVKkIOEwxUAWhjN8X96+ZKaefFdeOioA8AJX9WxMwor6MCg4/CD6
	UolRO/Q==
X-Google-Smtp-Source: AGHT+IH9mg0Ubq4dcyz/RQ1HXFgbY1IeX2tzHvbTCxN9Jfy0soPCuTeJii35p/Rl/hpDX+KAqDrATNqsyKJ+
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a0d:d541:0:b0:614:f416:9415 with SMTP id
 x62-20020a0dd541000000b00614f4169415mr2641013ywd.7.1714973453141; Sun, 05 May
 2024 22:30:53 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:39 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-15-mizhang@google.com>
Subject: [PATCH v2 14/54] perf: core/x86: Plumb passthrough PMU capability
 from x86_pmu to x86_pmu_cap
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

Plumb passthrough PMU capability to x86_pmu_cap in order to let any kernel
entity such as KVM know that host PMU support passthrough PMU mode and has
the implementation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 1 +
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index c0f6e294fcad..f5a043410614 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3023,6 +3023,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
+	cap->passthrough	= !!(x86_pmu.flags & PMU_FL_PASSTHROUGH);
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4d8f907a9416..62d327cb5424 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6246,6 +6246,7 @@ __init int intel_pmu_init(void)
 
 	/* The perf side of core PMU is ready to support the passthrough vPMU. */
 	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
+	x86_pmu.flags |= PMU_FL_PASSTHROUGH;
 
 	/*
 	 * Install the hw-cache-events table:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index fb56518356ec..bdf6d114d05a 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1020,6 +1020,7 @@ do {									\
 #define PMU_FL_MEM_LOADS_AUX	0x100 /* Require an auxiliary event for the complete memory info */
 #define PMU_FL_RETIRE_LATENCY	0x200 /* Support Retire Latency in PEBS */
 #define PMU_FL_BR_CNTR		0x400 /* Support branch counter logging */
+#define PMU_FL_PASSTHROUGH      0x800 /* Support passthrough mode */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 807ea9c98567..39a6379162bc 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -258,6 +258,7 @@ struct x86_pmu_capability {
 	unsigned int	events_mask;
 	int		events_mask_len;
 	unsigned int	pebs_ept	:1;
+	unsigned int	passthrough	:1;
 };
 
 /*
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


