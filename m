Return-Path: <kvm+bounces-22890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED258944287
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64A2FB239D9
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81550153519;
	Thu,  1 Aug 2024 05:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c23YvgE1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F52153820
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488459; cv=none; b=TLaqRsbCKkpnXThFyJDuJd9SpdUKcxKKvgBPT5MW8UXnuNQXuK2YT2AgvFhK+IrsihBrHz27IaJpW2EAnTZ9JkWzARYcYWUjWceiD1i/n9yZJCWjQsntOvxQiDcqyBrMRVQJwDCZlf+chKRc+si9kbPUKNXYTt6Qsqac7aIVT+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488459; c=relaxed/simple;
	bh=rFp2g1SMteC67ga0HvXSMTdcgESu5ZuQ9UForgZgVWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ExMUDazpSphZFBqRb4AnXrqVfQsJQCfUgrmnsLqzAzesPNmaz0/aFunajwtND/oTpQAHqtkxWjI+GLXHaz1vQNz8/GaZ0p+k8k3tnwDh2u244lpP+yp80TpCBvp6j44gY7jCE0QGTMdrZjGyrMeQh/z+XHejyy6y5End58eZb6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c23YvgE1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb4d02f34cso6567707a91.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488458; x=1723093258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l8nLk/LSkHQ4nrGTbHoBdPhfqphQ88KWleGa+/sy98o=;
        b=c23YvgE1Nsz9TcCipakFlu1gQ3OoftQyjO3J665votWWNdUqZ0xfEUXv7rOSadiceS
         Zx66/u5TsF2WExc6mCKMddT4WuFcRWi8gctHjgcavpTTvfwV7Qv4226DwhFgozfsjPMJ
         yx2UfhWRH8RO8t+Jk1KTgz6PRwgAfJc6gJLhPdAc6wUPrahu0FVVyn3yeze3RSeKfkCH
         +52ktxLeCXm+5NmjhStYLenhANmQr/A4TeLyoW0icRJavoqLg77BPgw5TWtgEsgBAHhr
         Td9RiUh0/hG9oAFne1zK/pICi0VVc5CXSx+Q2O568a6F4pSEb8xJ0Tvdb+E/VnX2ttM0
         PF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488458; x=1723093258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8nLk/LSkHQ4nrGTbHoBdPhfqphQ88KWleGa+/sy98o=;
        b=bxp7BpzfyLloHu8WliSBEkziTDJ+UTvz3WjfcQdhLuwKXaMvO4xZapzLCp78+OSAv1
         FmDBPx9K1bi1sofgmwacPdXC2lq++UlfwhlU5t13hT68kn1ziTxLKmOytlB/vzvkN06X
         kvfh8WoiBYTqO/tLumnIaGnhVQ5o6bj2c8mlzSkfqY8xi8TjmwF+DgnTlp9OcPYuzHTd
         eiDnigeYySAeYzn7VbEV/AUm+HZqzZNsSdbT1jK2jboThncN0Y0X0nfJ3VblqdECY61t
         sgBZNsSl45rvvXVQxVtcOvAshwu9o2zDMa3B+VpY11qQo9AWv3JhE8h/8kQ0n46W7xuB
         MIwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLE/y0LnNTSselWszg7a0r9Uo8FMi/3VUmDT8jpuYh/AZqUwmt/ow8VivOtBuLMVAqtqYfyNA/w3HUowlI7+hFdMis
X-Gm-Message-State: AOJu0Yz/bsZ3sAdVGhIQ//cFRSiEm9Q1/HuBgC52vXTBmY4NrIGqnesV
	w4I+9t50alojMZhwusmW3rRLsWTNIM4r+CdApaYDGgRuLC03q7vsuWlAoQwK+wTa2JFlKcP95oD
	qDSvo0A==
X-Google-Smtp-Source: AGHT+IFYttR/L8EQ2gsQZV8ThmFF2D60A1iub9UHBECx0FOvbVcyN0ESaoIsP44EN0FK6nV8frsUwciHF01m
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:2cc2:b0:2c3:1985:e9c3 with SMTP id
 98e67ed59e1d1-2cfe79245e9mr3146a91.3.1722488457660; Wed, 31 Jul 2024 22:00:57
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:06 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-58-mizhang@google.com>
Subject: [RFC PATCH v3 57/58] KVM: x86/pmu/svm: Implement callback to
 increment counters
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

Implement the AMD-specific callback for passthrough PMU that increments
counters for cases such as instruction emulation. A PMI will also be
injected if the increment results in an overflow.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 9f3e910ee453..70465903ef1e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -346,6 +346,17 @@ static void amd_restore_pmu_context(struct kvm_vcpu *vcpu)
 	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);
 }
 
+static bool amd_incr_counter(struct kvm_pmc *pmc)
+{
+	pmc->counter += 1;
+	pmc->counter &= pmc_bitmask(pmc);
+
+	if (!pmc->counter)
+		return true;
+
+	return false;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -359,6 +370,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
 	.save_pmu_context = amd_save_pmu_context,
 	.restore_pmu_context = amd_restore_pmu_context,
+	.incr_counter = amd_incr_counter,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.46.0.rc1.232.g9752f9e123-goog


