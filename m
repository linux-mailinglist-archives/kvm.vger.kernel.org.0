Return-Path: <kvm+bounces-22879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D87AC94427C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B82941C22977
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887A513D896;
	Thu,  1 Aug 2024 05:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u6UWW2+W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592E81514DC
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488438; cv=none; b=h6u+SmKxR45NeGVkarrXfxfZ6SbIRZ9m15TofrdFuZvjivDnaAKK0LPeI5NC0lWFAGkkGACljExopT+RQwpl0DjML3kGSKBiNmgbZyW9JEq66qmVljKRNp1znosBrrUcONNhZbcRJud39aztqn4Y5y2vYjCzvgWn61kBkmzpOQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488438; c=relaxed/simple;
	bh=/t9IB+N1Gp0Cv22UUgWbguzFF9F5B22srQNp+4bgaSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mh54f1Uw5NupUDFL7pls1wwNBFg8caHBHbPag59IEGuse1zmKdZWVMTV9zlzfpP1JqsuV2QtL1UGc1r7WIQV6z/d1N8wleieFH9HVRY154ONdsKG0Y2B5C58aPJEHD1MiP1vsiLqObDE7X0D6xvLUTChrWFUtCxtnMKUAEN2uX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u6UWW2+W; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd72932d74so52848755ad.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488437; x=1723093237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h27QCl+dRCmN06LWHq3+Vp6xAQ68Ef9l13jpLFvCsdw=;
        b=u6UWW2+WKQdI8ZmZvey/FGnqJXMO7Mlx1DEH0QRE3LxvsGiYK+PlJkHZhd1E99n+bH
         WlihIv36xCy5U2fk21bZTGsYbZL0eXXptJ4YQ0iGvkf2I+d0bB1qHULheY1y0yiXllcP
         GvgSt4vkXEpU6qIuAVfGApeh0H4/DA8QXHpubvJw7WJdR8ELvtuVG9jbAf0qjiTvr5W7
         Uo77euQk9eAxS1wrX7wvJNcp96JVIkdSk+kw1TZKohDQhQrUpT1s+wccen/YWVJzoOBU
         X+Pe5csMM2izc51pXmhkXrRVIIV6RYklkUiZTgU/XnsAyw+4cktDGZF8UX0QqAQQG+1K
         nVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488437; x=1723093237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h27QCl+dRCmN06LWHq3+Vp6xAQ68Ef9l13jpLFvCsdw=;
        b=Krxvft81c/npYu0O0BfQNLVD98RZZ5rCI3IJiQ+1i6dy361/nQMZF6SFUv35/FBz2v
         y+wFM2XPJvHrHa2tj2t0PVXPPMjuB9NkgaeBwQN6++xi9dq8t45nKc4W1fJHKDZOm1fo
         KeSigyqHQMYSoc3Qw7gpPwti0XmMKrBZinwf8Mx2l30TiactM0wEVQUGO27w/A1amwUe
         8ajAVfd0jdriUIdzESXOX12L6b0AFfI1eQ+iBlkdTEFC/1DiDh9I3c7voKN+15Kr41Aq
         8Q5/rm867Fym2UpDZ7hsNOx+LGedWRl+L+l/4375UaNaTgxi7ARFQSHOECvjcxrGA0BB
         vrcg==
X-Forwarded-Encrypted: i=1; AJvYcCW7j9VMcCfZnFSX0IsvGKVPRFLN0ymP3wFMVyT0uFNivSP9RUIpx9B9Ufv/cWYAkb/StPbJ6h18Z4mMcI1Tmc48My5/
X-Gm-Message-State: AOJu0YxQTPQOxWoZp5d8S5o13FBgW4FfwwmUe5y537zlZ3sCxpg1Tyjt
	iyeZzF57lDn+4LetoOYYKsc2Oxts17jd/AbRDf129fjKz7mPCaFas672ShMQRNSirAkw27DMsiP
	rkaL17Q==
X-Google-Smtp-Source: AGHT+IFL9RF67FQNgTpNi/3id+k6hiRWIHGowxUpl+EsGdYy19ECvfREAviEIESyvW4wGaOhadsbXurHFTAA
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:db07:b0:1fb:5a07:7977 with SMTP id
 d9443c01a7336-1ff4ce4424amr1132565ad.3.1722488436555; Wed, 31 Jul 2024
 22:00:36 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:55 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-47-mizhang@google.com>
Subject: [RFC PATCH v3 46/58] KVM: x86/pmu: Disconnect counter reprogram logic
 from passthrough PMU
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

Disconnect counter reprogram logic because passthrough PMU never use host
PMU nor does it use perf API to do anything. Instead, when passthrough PMU
is enabled, touching anywhere around counter reprogram part should be an
error.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 3 +++
 arch/x86/kvm/pmu.h | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3604cf467b34..fcd188cc389a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -478,6 +478,9 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	bool emulate_overflow;
 	u8 fixed_ctr_ctrl;
 
+	if (WARN_ONCE(pmu->passthrough, "Passthrough PMU never reprogram counter\n"))
+		return 0;
+
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_event_is_allowed(pmc))
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7e006cb61296..10553bc1ae1d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -256,6 +256,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 {
+	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
+	if (pmc_to_pmu(pmc)->passthrough)
+		return;
+
 	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
@@ -264,6 +268,10 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
 
+	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
+	if (pmu->passthrough)
+		return;
+
 	if (!diff)
 		return;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


