Return-Path: <kvm+bounces-22878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D328D94427B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 881CD28869B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A941514D4;
	Thu,  1 Aug 2024 05:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+Zel8MP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6913CF98
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488436; cv=none; b=DDhsgk5p71JsW8kp9SkNE5gNoeEZlGKT5sTN2IHUX3cYRht4G4UkLgaOw3XPwq2mtamcnogPlp/jBf+arCEhaSPIuz74HNPZO8YN9Bz/hXWY3ZXfdFC6qKCR2wxW6aCp8Oi6Fg7mEkiWmfTre9LK31DeOsGG0AlWQlD+HxF5G1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488436; c=relaxed/simple;
	bh=FR/or2X1AR+pzb7YK69oWzYFGkBpcavB6Wog21Mz7QQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i/PfTY7ISgwM98Hme1EPIxC4rx0FvyFfWRHXXE7BlCIk/xOR5SHUsZLPi2AtvW7GwAS0ElLIhNxI3xsYRrFzBP1LaSQtoXstyKt5hd+Gnmp8h0HLN3bCmhnbxunW+tDEYPccUeQhXbr6i8uUyY34fyySOzUSvLx1FATA5v7+cho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+Zel8MP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5e1ab396so66519765ad.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488435; x=1723093235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A5H6PRz3kdGjvOkv+983LAIItnKmgszUywTdiWr809I=;
        b=M+Zel8MPcbDQej9J8MhzCua3H2RhToMGPz2c0qLfBKwJhPE4+NN6dhtJy10RIjflxQ
         kPr3DDZj6yzlhYiDDbgGAsIT04iHi3gqNW/0O8+cVIx8Xy80zWgVyhpN0zpj2jH5zlm3
         xOxAeq6F8TI9cMxQnlJ3XjVm/Xd8HqC5vRNgxyfJa54qQr7aphQ2fDlhXSQgB6REAiB9
         GbQQybEEtDZkyxm8b04Bmv1uvlUl1sVBqjtDoGhc4gzer2TWgILHg/BSgXDdmTnopOJN
         yls1UuX50d2JG7QOE/Lx4f883HsAurDoOGik+fRlfTPMOROWXvGOHAPRAq9d+TmdyXra
         NWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488435; x=1723093235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5H6PRz3kdGjvOkv+983LAIItnKmgszUywTdiWr809I=;
        b=fYIdDGkFksGFHKLeqPUhP87UDRR6BlNpVujkZL3Dm0+WU6F0ajBA1C3W2aUnJFV3Gg
         DAgehX5en0Ep0SjQvi2LJAodWwnLNCst9V/9npOQqKPWD/StT9+7CIu221aWDhchs7ge
         11z3e0MB3daam0Ua844JOK5bRgRQDUZXH9Zo6B3lTL+gpijHf6EaGbE9LslVETwc+f1g
         qhVbOFS6C9DYwDukrO0dg4LGnkumnFNdjrjH9qpMEGMYmEaVopwTBCO9tt15xa4i62Tv
         lE/OB64Q56MRKIGxx+34lMLkoILw+jouFp2n8gxps9GGJZvb7h9i+R9e7GadA3+VmrWW
         RSxA==
X-Forwarded-Encrypted: i=1; AJvYcCUa11CdBcbb4zQKYlJblq0+bmF9HLFnppXk+5Ulrjt4ATIVsslKdjSBRMS3zTSKZXJaLxI5J3H0yE2SPdgG15bp35ZZ
X-Gm-Message-State: AOJu0YwlBQbAAQkVtuv++e3neuXA3yaRIu3lXqCPeZrfJGaTvHC6Y4OV
	OzmxWFiVgP4cXr52IjeDOI1qp100xn5R3d7Ff5/kQH764OhkVmqKPFB0vnJQzGBMHzQJv0bMpgo
	dOsTNRQ==
X-Google-Smtp-Source: AGHT+IGTWpbXQbXGItfLiLmaLczQ8nGBbsWUzLbJcIxXQ+6RcaYhZLMBaSJNqCH4aoSgeDRLaUv6obcP3dQU
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:903:41cd:b0:1fd:a54e:bc1f with SMTP id
 d9443c01a7336-1ff4d25a6b3mr1322245ad.11.1722488434623; Wed, 31 Jul 2024
 22:00:34 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:54 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-46-mizhang@google.com>
Subject: [RFC PATCH v3 45/58] KVM: x86/pmu: Update pmc_{read,write}_counter()
 to disconnect perf API
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

Update pmc_{read,write}_counter() to disconnect perf API because
passthrough PMU does not use host PMU on backend. Because of that
pmc->counter contains directly the actual value of the guest VM when set by
the host (VMM) side.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 5 +++++
 arch/x86/kvm/pmu.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 41057d0122bd..3604cf467b34 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -322,6 +322,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
 
 void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
+	if (pmc_to_pmu(pmc)->passthrough) {
+		pmc->counter = val;
+		return;
+	}
+
 	/*
 	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
 	 * read-modify-write.  Adjust the counter value so that its value is
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 78a7f0c5f3ba..7e006cb61296 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -116,6 +116,10 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
+	counter = pmc->counter;
+	if (pmc_to_pmu(pmc)->passthrough)
+		return counter & pmc_bitmask(pmc);
+
 	counter = pmc->counter + pmc->emulated_counter;
 
 	if (pmc->perf_event && !pmc->is_paused)
-- 
2.46.0.rc1.232.g9752f9e123-goog


