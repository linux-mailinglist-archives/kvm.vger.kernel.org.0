Return-Path: <kvm+bounces-22853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D98944261
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0F2928491C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5069314AD25;
	Thu,  1 Aug 2024 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HXY1uDEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345FA14A602
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488389; cv=none; b=sITN6z3zZgmPxIOtWCLPz6TEtMeD1MWwnk1OS0lPbv4pxtDuASkgzVWyFKw1Gm+jNRoXDdZViVf8YFoMAoZukA7KIONdHxSVXAunHjKnzezLbCD9HO2TwU0SYvX6tPpm5AIulTKKFKvLsAYrBaXaeywz/dceJb9Z/mdE6/o+OOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488389; c=relaxed/simple;
	bh=DmaqoFrNzmr8Co3BtZYZ3sN8u8+AQaBmtrlmA+BnoV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bGrAfkRub+NnpFrKZOWUs+5YTwmtgXTRSEhKkqEVloSNaKanwxG6VmXB8Bw362jpHbjAD0cc10MWZrdzLJ2n1ZMytUAD3+qvxiF8JcUi/pwXh42cbKOtASamtqzpRojgvORAxPp/X6iK1Zd3HOMHzDDkxtDF97KKFBtvinPE4UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HXY1uDEX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a242496838so5202095a12.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488387; x=1723093187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BZY24OME/y+6YnDgfJl2/HTI8j4mWVFxPD5yIL3mP5U=;
        b=HXY1uDEXfW8WvuOcEBUcHU2YHyxorpNeNL5dFbKmHv4sUG/zlIIGg21jA7GqCpdPtl
         4HXkej02s1lW7TpHyilMoD7gt/xYfC7tstmimYgKjpxYKGltj2WD46HNTDE6nvArGa/j
         Hh9jJdbadJ2Rj6N4aziYbJ4+MmT8Upd7086bJiwr868Aud4/4o7Tsc0HUKPf5grlE/yA
         B7g8hFd1BkjeGO0VcRocH5qWKY+QXxl3T7WWAlHukgLkXdBoFc4qFY57nYrfxb6JQbAO
         /vGyFN+MJa2mYfTMXBHDLbYCBicOqlQfkBtt0OxmnjJ3KVSQhCneprecTxkyVimSQA3w
         lTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488387; x=1723093187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZY24OME/y+6YnDgfJl2/HTI8j4mWVFxPD5yIL3mP5U=;
        b=QjO1dYrvDFPsM7lemPfxajDk5O7XdofILYLP7zYJaXmyRgkhMQccGMk3fc7bbe67M+
         UK/CUJeHumtHerJOQyi/aSZnRFTqxElOT+CttvN2CYCmk+Frp14exIZlc5s241JkD6YW
         uDskhtKzod3LXGIjUUE7rIQDnjpuIQRYxZKO92hzhmpXdMSXDOGmDkcHFZqqrZ98FBHx
         R+gu3nMTsyak8gNPm6fTJvdeSXVAanpte1WgsA83fpKGbCNg1D+FO1AgRqrf5O4+p9o4
         My1DSTPHs8Ad8n28XreiyAYQPjV9wi7fOelaRiU7etPPbyvAtpIjCCXlqx1EwSB7N6du
         dW6g==
X-Forwarded-Encrypted: i=1; AJvYcCXsGPyin1w87Ujx0cwFdbpqwy+TfM3apesQcYkQcHUpJ0LPIOTz2cOSTPZvA2XAdEeOAmGuUz0UrN6ujbkwHU2To519
X-Gm-Message-State: AOJu0YzlV87Pm05wBj3RBHnuSv4v84YrybIxReqYLR1aMlYEoccZxnFq
	ej4ShBkr2byvrad8Ff7Elf5IOacwqSP/Y6J7kF/9nl8dCnX0OdImU7f/vFn80cQTVPXLF880cv8
	D93wY5A==
X-Google-Smtp-Source: AGHT+IHFPMD1Fq57svUf/REJRzdZUqR1Ipzwj18MNvxMBjrLkVe7FTwvAMyTJry2Sy3HQp9p1YdM6vMus0Bj
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a65:6904:0:b0:75a:6218:3d10 with SMTP id
 41be03b00d2f7-7b634b5422bmr2921a12.5.1722488387315; Wed, 31 Jul 2024 21:59:47
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:29 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-21-mizhang@google.com>
Subject: [RFC PATCH v3 20/58] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
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

Currently, the global control bits for a vcpu are restored to the reset
state only if the guest PMU version is less than 2. This works for
emulated PMU as the MSRs are intercepted and backing events are created
for and managed by the host PMU [1].

If such a guest in run with passthrough PMU, the counters no longer work
because the global enable bits are cleared. Hence, set the global enable
bits to their reset state if passthrough PMU is used.

A passthrough-capable host may not necessarily support PMU version 2 and
it can choose to restore or save the global control state from struct
kvm_pmu in the PMU context save and restore helpers depending on the
availability of the global control register.

[1] 7b46b733bdb4 ("KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"");

Reported-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
[removed the fixes tag]
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5768ea2935e9..e656f72fdace 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 * in the global controls).  Emulate that behavior when refreshing the
 	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
 	 */
-	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
+	if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)
 		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


