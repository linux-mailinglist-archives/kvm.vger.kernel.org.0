Return-Path: <kvm+bounces-16662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C5F8BC6FE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 291CB1F237AA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37F8144D0C;
	Mon,  6 May 2024 05:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HzjPM7Dg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E350D1448EE
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973523; cv=none; b=UodUIm4DRaNJxKIIZ/TPYyU9yuCCG+3cQRtZGiXqbzzFB8wTM7ZB+9PSGLkONIPk8GUiu17PmF6/EXqpcZgjKAJY53i22P7C/cCiKnhlXAl3Dom23F8y8KfZSnxgg/lYOUDEFMY+8ZoV6M99UVmoGoPNIYwT4S6/DziIEi52bWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973523; c=relaxed/simple;
	bh=CRmJx6bmBTrt55OQbc2L7YG1RD5vUsWMFN+L1SLZN1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5YCIBOFHsrWtGvddjPbxR00+00XFvOMjuHzC8OXoIeIE7XYUmMbxzGZB3Gfal14GZjFLa+Xcj2OCTs0kAa5+/LJGUVTC7rctMIe6j7up78Ry0tqvz1IfZrIqu5XLAktFwSQr71sAW6pFHUywYbWmCAqGufPpmqyNLv/RwnvjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HzjPM7Dg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b3773153feso1394036a91.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973521; x=1715578321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=obFJjCnNqS0Mu/IpEVbvx0gHj3S8/pWzsZSXQ1iuE2o=;
        b=HzjPM7DgDQ/v9Ru1xy1sAU9qFQpmyiPsuqlICsHjY4GPxfjvqGKraO99lijZ0QnQ/O
         QobG4dXN+C0RUDcwb1uMEF9DGvGIvGJodCDDudzqp0Pxr3lbkwtcLwu5X7aUMMnn7t9V
         dTgfKCthpPQ4gs20BB2P+F+gYIjlhTnITGJ0JJhStYxc8/PI7n46UgCelROO8H+TEPBa
         dfOBqtzh/GAfXzZup1X0d+4D1iMxJFtiaBsflwHvi7ytjTmRdDF2tz0FbSNsvH8mgfhM
         uva2g0TiKmMnw1ua+MkDR05jtS9s19E2ITsYNxe9cW8aqOVYzotAIp7apKrwm2gWT7tM
         nT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973521; x=1715578321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=obFJjCnNqS0Mu/IpEVbvx0gHj3S8/pWzsZSXQ1iuE2o=;
        b=JkeKfccZ5SBdo5tDiX7JCS3563kv7YOncYRSYGTalA8IWy452bmN008xZqxulhfKNk
         OYKkxI8xV2aci5DR/l8ZyLfnBJ83nGFdMDZgyUFbQeebLQ6EyAHOH9a4zxOo366wh/6D
         kg35SWJH8EtLBKvy+rzIv35aGJ7Q8MeOttp7UQ0ygDMcpFhbjc48ob04O2XC0guGNSIB
         /hwYhof8KdZLtEw/Iy5s4hbd1t7XJQS9e1biWBx9G7kWouYtEMfNyosttENOo6kXxyUh
         qBdRdHrkZ0386kUQblRK3pULkVu4VYzytjDage6Aig6WUwV9IrcoByr2ESGI0aGSgavH
         INtw==
X-Forwarded-Encrypted: i=1; AJvYcCXjgXmhcxt6tz6KtmgTdFzTviVtL64T+T/LJ9zx9wzpmAw9rFw6mKLzw6YyXgUvtTUNI2OriJCsPyI2os/bm4pNDn4z
X-Gm-Message-State: AOJu0Yy++4MbUTk+gq8u5fOFQZwIGIgvjs+c2R59GU9GnXRcgnudOiPL
	Cg2TjAWg2v6p5gV1z1mQHBLvAkyWy1pIW3WGFtGvXKU/f2kWeNzomMqedm7GdHgvqjxd+2/7P+m
	I6Ck+Kg==
X-Google-Smtp-Source: AGHT+IFYp8coMMMQBNCwd97fczYgJy2ue1P30RZll3cvaIcmpsrwWSW7fDCLCClAJjUuBkJxelFlX0RornAO
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:9f91:b0:2b0:73ac:ff38 with SMTP id
 o17-20020a17090a9f9100b002b073acff38mr25441pjp.1.1714973521086; Sun, 05 May
 2024 22:32:01 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:15 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-51-mizhang@google.com>
Subject: [PATCH v2 50/54] KVM: x86/pmu/svm: Implement callback to disable MSR interception
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

From: Sandipan Das <sandipan.das@amd.com>

Implement the AMD-specific callback for passthrough PMU that disables
interception of PMU-related MSRs if the guest PMU counters qualify the
requirement of passthrough. The PMU registers include the following.
 - PerfCntrGlobalStatus (MSR 0xc0000300)
 - PerfCntrGlobalCtl (MSR 0xc0000301)
 - PerfCntrGlobalStatusClr (MSR 0xc0000302)
 - PerfCntrGlobalStatusSet (MSR 0xc0000303)
 - PERF_CTLx and PERF_CTRx pairs (MSRs 0xc0010200..0xc001020b)

Note that the passthrough/interception is invoked after each CPUID set. Since
CPUID set can be done multiple times, do the intercept/clear of the bitmap
explicitly for each counters as well as global registers.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 385478103f65..2ad62b8ac2c2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -247,6 +247,49 @@ static bool amd_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void amd_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int msr_clear = !!(is_passthrough_pmu_enabled(vcpu));
+	int i;
+
+	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
+		/*
+		 * PERF_CTLx registers require interception in order to clear
+		 * HostOnly bit and set GuestOnly bit. This is to prevent the
+		 * PERF_CTRx registers from counting before VM entry and after
+		 * VM exit.
+		 */
+		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTL + 2 * i, 0, 0);
+
+		/*
+		 * Pass through counters exposed to the guest and intercept
+		 * counters that are unexposed. Do this explicitly since this
+		 * function may be set multiple times before vcpu runs.
+		 */
+		if (i >= pmu->nr_arch_gp_counters)
+			msr_clear = 0;
+		set_msr_interception(vcpu, svm->msrpm, MSR_F15H_PERF_CTR + 2 * i, msr_clear, msr_clear);
+	}
+
+	/*
+	 * In mediated passthrough vPMU, intercept global PMU MSRs when guest
+	 * PMU only owns a subset of counters provided in HW or its version is
+	 * less than 2.
+	 */
+	if (is_passthrough_pmu_enabled(vcpu) && pmu->version > 1 &&
+	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp)
+		msr_clear = 1;
+	else
+		msr_clear = 0;
+
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, msr_clear, msr_clear);
+	set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, msr_clear, msr_clear);
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -257,6 +300,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.is_rdpmc_passthru_allowed = amd_is_rdpmc_passthru_allowed,
+	.passthrough_pmu_msrs = amd_passthrough_pmu_msrs,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


