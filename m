Return-Path: <kvm+bounces-16620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A83F38BC6D0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48F3C1F21F0E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4906BB33;
	Mon,  6 May 2024 05:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Liw7Re4c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9837C12836B
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973444; cv=none; b=cyi37+1Scu9wxTiLYl8og3593WnIa9mubablgZ0V57KSeeeMnxIxw8XGDgo6ntrgOAfb+Ij4rVf3Q4MC2RIwjjL6h8piRQ3sRS2hqNsWsm6wolmo3mphu2EQmo3UTSloppr37JrulYoiwZY08zFLF9NDks4HYNyOHooxfN4iPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973444; c=relaxed/simple;
	bh=e6HJtq3VlBTRpaF0F2n9f5Hlm40o+qujKAZEWxlcBfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MgBN/gY0j1+XuLZuYnibHi/O+4IJuHp6wP4WEIXNnxUJ4hW6PCwhVUyEu2yZtP6QsH3V9D8OzQiKVINVu0hk4XOJUHujTSUAdhhMUfQ4vIY93dVjaCTpGJwADm95zzqvQ+JvUts7kvtVArpxNO3NuIV3SSiRCjOFD+Azhbmgeg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Liw7Re4c; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ec3e871624so19256125ad.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973442; x=1715578242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N3A8K+va4AQ9IyqUUj0RdyU/UcM+D35suYK+hJhAU5Q=;
        b=Liw7Re4cGM0zj0jFFrrV8oWe2f7TskJPQOqyWd5405jEg2QY8aYYrIxff56HUMaSTw
         6v1dyBnKVblgCZ8J25Vc8QiK2AvzINmdFNAjaWs2cDxbOXTJXPAl+zZiKcc5qlGd5OLQ
         ED5shZX9Nm8wg9nA6bF9hJxBiMP6/7JFxz1dj7OWmjpR5SAkIja0NFKbIAIPVIenA5+X
         CmWJ8oT/7oBwalS6G9jw0vImHwAfDEOpuWn8zN30GS+Xzpiz3cJz5+7y3hB+Igz7923y
         YKs54eDDjrKgSF7HASe9hfEQHRqs291C6pTTULomMql10XRfhV+Owi9nP9RnIWIU9e9o
         S//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973442; x=1715578242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3A8K+va4AQ9IyqUUj0RdyU/UcM+D35suYK+hJhAU5Q=;
        b=d05ffrKCULL9AG11fM68EDEkMy+IDdzLhbsRMlkOKjYhAYN/uEmLrMN4dKYimVhSHa
         OWY2cawIbqMJZfO3kaw3v7/6+LawXqeCf7D7EWk7jcbNGM9p8dI77IqQB/txOtoA8Wpk
         JY3xuUElsIcBnztk/E/yGNPLWFfwPZ98aIPz0QaJ4UiegGzoxy49FvKuJLJ1+AGwqHTp
         sB+6rfafz2k6Cl3Om1MGncGZobBs9jDFQJ+ykBMl0WKfMat0C9w6gIxhPPeztazvyE+J
         OK+3f4grgMXN+Qv9eH5EMTDqjxRHmqFEEx7y0CwAFo5XcML2OMpQzf93PySuU+3QD3Ct
         LVFA==
X-Forwarded-Encrypted: i=1; AJvYcCWRe479+PG2UbUverIqGGtKGGl+DE3GWcYKFAknvQSZPVkFK6OQ4x8bvF+bXboWf97Cepylb0dEeeytOrpf88xKiMm+
X-Gm-Message-State: AOJu0YyMSpUwTWlNhiLMnUN6b4nv4GGDrSPScHr3rgk8gkdCkthUVWLv
	qP2tB7Z/JD3EL5HYV8lLNfFDzX20f3pDNI+qhaIMXV+ubNOss1dKCvNw7TDwC0nHSEsPyuK3bXP
	qa+kzQA==
X-Google-Smtp-Source: AGHT+IGyFB0RtQesKy95nA4gxkykHi1rIRqPkz0y9xzm3NAuAEK6vcV+5of6I0ib0fIEygudiZ0jd6x/brX1
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:ecc7:b0:1e2:118f:e587 with SMTP id
 a7-20020a170902ecc700b001e2118fe587mr398273plh.13.1714973441753; Sun, 05 May
 2024 22:30:41 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:33 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-9-mizhang@google.com>
Subject: [PATCH v2 08/54] perf/x86/intel: Support PERF_PMU_CAP_PASSTHROUGH_VPMU
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

From: Kan Liang <kan.liang@linux.intel.com>

Apply the PERF_PMU_CAP_PASSTHROUGH_VPMU for Intel core PMU. It only
indicates that the perf side of core PMU is ready to support the
passthrough vPMU.  Besides the capability, the hypervisor should still need
to check the PMU version and other capabilities to decide whether to enable
the passthrough vPMU.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/events/intel/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 768d1414897f..4d8f907a9416 100644
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
@@ -6242,6 +6244,9 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
+	/* The perf side of core PMU is ready to support the passthrough vPMU. */
+	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


