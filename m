Return-Path: <kvm+bounces-22872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C18BC944275
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68AA41F239F0
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7D614F135;
	Thu,  1 Aug 2024 05:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2qTOfQ3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4914EC42
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488425; cv=none; b=h7KuAMKK9oYlTi8q441x4LWtL4SM/MqcYT0HveCCaQAJe+Ze+quMRilZozuWvApACsVW5lQkAyFClM2kns9du8s+YBfh48RfLTELXhBIP+96D1WpxKBKKCR8Wad7ZXXWLDI+t6VFbPq0C6WrCBSgeRzT4ghQkTDzG/d3pmQCxO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488425; c=relaxed/simple;
	bh=GqCQnIP6R+UN05hqGjPkN/T2Em6ifHploh1jeGX/+PU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLUu6HAtnTOzK3Uw9KBHkOUUfbh35EII323jyHIzSsciyNPXhNTikAy3wtPPhi6Ir36TmNny1Wue3xWad7AxHjdq8B+fKaoMDfzmj7x7mUKBlIMCZ94cF5CNX1v0yzfok2qpEX4xlh0q2PUSplVyZn104qnj73ZVzd/7noNQorU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2qTOfQ3h; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a23a0fb195so6696908a12.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488424; x=1723093224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+CFrfDGrFiZkK906go6M7xBsrwmWC22BGlbM4Q3ki74=;
        b=2qTOfQ3hn5y8YAyoYSX3hDXKKRadm/emJpR+eJhA3VULkgjNKLCjydieWFTwhjjDHB
         fEDoqStiu2H1C86gH3d4BHYUrtXuNcjy9FG5dhjX5XVhI0AN5OBtSVP0LFIQ4WYii1hH
         eD+DJ95cmse+XpLAjmL4vTulsCCViwNipoOHxQDPeIZKYrCn1h++BrL3fIohFNU83ETj
         UH0vaSfD60veSITq0nIMjaHzH1sX9DKm4TG0PEvahnOg2SezNBj1DcDzFgqjN0xWPJcV
         SU7z70048qcivtqC1F9Z9WMHBkASTQPMldMjLB7w1dP0MtuazEaKGa3IGbQOUXZ6sCey
         TpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488424; x=1723093224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CFrfDGrFiZkK906go6M7xBsrwmWC22BGlbM4Q3ki74=;
        b=m4rQPsSgFnkZv/A7NhZoYhZxG+vjs3z7RZh2gULNJ4NpHxlcVLx2tciZ4P1doHaj3a
         oTDFvimgagZkzGBjkeIkju+lmNHX6KwASTm0eUPpB8+A9/uncZQmYEYq9Q+USgqgbSCu
         YZ1ICAbjw9GqOHmaP00T77Ws+3q0NQivzB2jX69bS8P34rfFJXfdllLqn3RxsdyQB74S
         CnTUnLDfW+MiuWCrbG1cHnHR3uTAhxdcyIRZyEfdA2L8yEON3rzFdXO5kom3fq2vNVI6
         iNjNvnm4lXMra/D0zxNjlOgpXXthEiKJu6Zj22qM+Oh6i6Npz9Rcj+zQSS2p9JO+HF1o
         ooEg==
X-Forwarded-Encrypted: i=1; AJvYcCW8hrUE2r5cQWtHdD+S1HhxeIZWxWgCVnTLJ/ymTXhdm9fZxsoTnhayXDxhQUbIc5TU/PYA6twAm9CVoclxFLGUY1iz
X-Gm-Message-State: AOJu0YxKPr1rMwCS0fyoEO1nEd+2RcJgSHvRt057P3EShYx7Izt0biaf
	xFjvTJwezICPYd8fx9VvW0+SIRm6cPXT6X2BUgpjs7QlOxOpf80EX3RmsN1jkc4/c5WFjGUyN3N
	JWsuNBg==
X-Google-Smtp-Source: AGHT+IF8IwpLv21C9d4LG9BaErE5Gf7fmPC9Sda/hlrd14dwgLHEKydBQ5WIEeD0RreCXXR2vtQ0FeG3FP9p
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:3e44:0:b0:6e4:9469:9e3c with SMTP id
 41be03b00d2f7-7b6316c53d4mr2601a12.0.1722488423510; Wed, 31 Jul 2024 22:00:23
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:48 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-40-mizhang@google.com>
Subject: [RFC PATCH v3 39/58] KVM: x86/pmu: Notify perf core at KVM context
 switch boundary
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

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Before restore guest PMU context, call perf_guest_enter() to let perf core
sched out all exclude_guest perf events and switch PMI to dedicated
KVM_GUEST_PMI_VECTOR.

After save guest PMU context, call perf_guest_exit() to let perf core
switch PMI back to NMI and sched in exclude_guest perf events.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 545930f743b9..5cc539bdcc7e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1097,6 +1097,8 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 		if (pmc->counter)
 			wrmsrl(pmc->msr_counter, 0);
 	}
+
+	perf_guest_exit();
 }
 
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
@@ -1107,6 +1109,8 @@ void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_irqs_disabled();
 
+	perf_guest_enter(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+
 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
 
 	/*
-- 
2.46.0.rc1.232.g9752f9e123-goog


