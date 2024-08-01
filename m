Return-Path: <kvm+bounces-22868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B19C944271
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55B4E28744C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DA014E2C9;
	Thu,  1 Aug 2024 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZcfC3CBj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1814D45E
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488418; cv=none; b=gI6VDYQLEaGTzQQiBx9jfanLsy9kIIGuraA227uj3z6a3dwXrODYLkr99DE0tN7ufxGhK4Vgme8EdyZBRLsKysYsDvcT8C8+2f6e9eKv5DAi+UfBU4O7XVxxB5EqlIbjmwHwY8pyFRjkE/xk57yLfCrLyeMJ275MLFPWwhct7pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488418; c=relaxed/simple;
	bh=Rj2gupleinIeOJ4kMvsxNFt16M17oDTj0RlHR3E7rxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqhpzIxhqZViIqrQV2uNd2f7xStxxjZkTCN2LUvyBm20C2S/jKlpCBYHlMMPwzCWlHyIsk8CQvzIUFyZj5yONoDIzA2vyayRh7m7inM0kKJMfDUJ8uT4a/0rwLCA59UAK/I7nYHf6pnfKh4hQWrRn0POVodcqteMSt8HS1ffPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZcfC3CBj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5e651bcdso66725365ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488416; x=1723093216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pn0DNQGT68J/BKfX5XJXHgSRwinQWRsCNvIBUEjyeLQ=;
        b=ZcfC3CBjA1hOsie4lZa+xI4UR8etK+PtzytDJ1MC+lRqvva3ND9PvXaEaNkAGDskpR
         OC5VBW3uLGAAt30QaWfyZGwpin3rD1mynr4q7a5RMZXb8MYhcy0vhsSdFS5T6kor9rqx
         Q2wCsagUH9rHeGpGRdsG6Ye70qihyf1MI/b33vgPXlExhEQTNBk8jyZjmmvin0z7opWx
         VsvDCi7BOrPDR56xoSfA0G6WTypPPAjk8Fn0Ur4koPikGN0eW8NOrxjjQrrATRMR7GH8
         D0GVgPb74f/f3wpFFYFizOjMLIqzpeZzQit32N2U0b6yHodhjSmbeejSo0eakf4pkXJ+
         fq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488416; x=1723093216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pn0DNQGT68J/BKfX5XJXHgSRwinQWRsCNvIBUEjyeLQ=;
        b=cktOli1r8YUWBeus9z6pFHxkJluTnDCBkS4s5R2afRIZsODZ+saa9zJDoOgMJGjx73
         +QTdWHXW9xuwqXmk9vEZ9+LPuplL9KWPpmXbWYNzXRAuaVVWgLhjrDVUlp2HkbYFuLMC
         JcCjVrBXC5gPtITOBMk+NeBo+gAC+5fCTTUECJflGWUMwFRcFfkZaPj8jX1GOh7gFa2X
         GYd4OBb/2hUu/yhnTqlwyNYwYeMLG+e1g3IdvuIKDjCcri9ZfFWyucAv1VyxTVZZkkEy
         WIrNO2/irAVJ8N0o4i3u67wtV9BwTE98qTy9aq4of/7w6l8Wc2MCePiMbeHO1hxW9R0g
         voCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNyYbNJHZSJcewHaNN+kEYnte1Jg2emiz7XI41CPUkKUDwCLh5SFC93biTuYhffHAyaf5Opio1JDT1F4XIEEVN0YA/
X-Gm-Message-State: AOJu0YyQ/Vb/tw7k3SbfJGufPyhRnQOiv9AN+6grPKbGuaOxQIu7T3K+
	gOvaiMp6B9qHY9oOmwd78DMGDtB+ydPfVSKo8q5H2VMOBFxwlB7jcQoyJcNdBzF4bIDDiqg8zDo
	bU/ehkg==
X-Google-Smtp-Source: AGHT+IFSr6KydggPLsI+JPw3CVmdbWxptejcGi1U+C/f+6hocUkPmWtWinmmFWhFFdZB9oLJOos9ql+5L8lk
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:f54f:b0:1ff:393f:8dcb with SMTP id
 d9443c01a7336-1ff4ce4e6f2mr1128855ad.2.1722488415706; Wed, 31 Jul 2024
 22:00:15 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:44 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-36-mizhang@google.com>
Subject: [RFC PATCH v3 35/58] KVM: x86/pmu: Allow writing to event selector
 for GP counters if event is allowed
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

Only allow writing to event selector if event is allowed in filter. Since
passthrough PMU implementation does the PMU context switch at VM Enter/Exit
boudary, even if the value of event selector passes the checking, it cannot
be written directly to HW since PMU HW is owned by the host PMU at the
moment.  Because of that, introduce eventsel_hw to cache that value which
will be assigned into HW just before VM entry.

Note that regardless of whether an event value is allowed, the value will
be cached in pmc->eventsel and guest VM can always read the cached value
back. This implementation is consistent with the HW CPU design.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              |  5 ++---
 arch/x86/kvm/vmx/pmu_intel.c    | 13 ++++++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 603727312f9c..e5c288d4264f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -522,6 +522,7 @@ struct kvm_pmc {
 	 */
 	u64 emulated_counter;
 	u64 eventsel;
+	u64 eventsel_hw;
 	u64 msr_counter;
 	u64 msr_eventsel;
 	struct perf_event *perf_event;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9aa08472b7df..545930f743b9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1085,10 +1085,9 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 		rdpmcl(i, pmc->counter);
-		rdmsrl(pmc->msr_eventsel, pmc->eventsel);
 		if (pmc->counter)
 			wrmsrl(pmc->msr_counter, 0);
-		if (pmc->eventsel)
+		if (pmc->eventsel_hw)
 			wrmsrl(pmc->msr_eventsel, 0);
 	}
 
@@ -1118,7 +1117,7 @@ void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 		wrmsrl(pmc->msr_counter, pmc->counter);
-		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel);
+		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel_hw);
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 89c8f73a48c8..0cd38c5632ee 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -399,7 +399,18 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data & reserved_bits)
 				return 1;
 
-			if (data != pmc->eventsel) {
+			if (is_passthrough_pmu_enabled(vcpu)) {
+				pmc->eventsel = data;
+				if (!check_pmu_event_filter(pmc)) {
+					if (pmc->eventsel_hw &
+					    ARCH_PERFMON_EVENTSEL_ENABLE) {
+						pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+						pmc->counter = 0;
+					}
+					return 0;
+				}
+				pmc->eventsel_hw = data;
+			} else if (data != pmc->eventsel) {
 				pmc->eventsel = data;
 				kvm_pmu_request_counter_reprogram(pmc);
 			}
-- 
2.46.0.rc1.232.g9752f9e123-goog


