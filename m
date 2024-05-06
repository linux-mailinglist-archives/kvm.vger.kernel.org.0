Return-Path: <kvm+bounces-16613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BF18BC6C7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EB5B1F21BE0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF54C482DB;
	Mon,  6 May 2024 05:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOGx83fE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62D74654B
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973431; cv=none; b=ojcAhYF5wGXMcTJy6No1btQk3KaRpMWtfZr4uUmUZy5TkNiDamIIHx5tHjKUFGa+Wl7hBceZAhQ6EKOzcL1RtFe9p1Zqd9rmy8UZq+lpYbP4c0sdtKPAMrmI9dzogdenSZgXIIcuCi1HwsxrzZBsN8QtUxv9zyjqN0pbYRfLlgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973431; c=relaxed/simple;
	bh=lgGol9X9PrvDjavTqlM9a/BDUdJpyT52hF22FchYLKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoeOuZpjlgdmmU8xA3FO0BPRaHsJcMsR5/j0bJUCAwQ0UnAg6hNW2CgZiW4kqJFbdb2KPBkj1nR9CzzWZ9I54gHswZQ/oT0VItSjOBYD2T47dE2Z7sryS8HoMhv9bVrOSgbiLZXM1DX7GWotpHxwQP1MkixHwTPENpGMjF39/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOGx83fE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f46acb3537so566607b3a.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973429; x=1715578229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ACCDkCRlD9tBHoUvBKfn0tCSNmu+4uS3hC8KCTfss/M=;
        b=hOGx83fEoY1D3j5dH5nXeAYnSSNbIHiu/SvDYf4O6jwsVCO6ksiKH08/6jlK8iAYvw
         P5XCZHAklkjM6tNRx96JUFyporoJaitOQWx6fdtTwGsW0bBscaY75ciCTwcUN/6SFsVC
         72xkMRhneBxiKVtfovZRIw2sAwcTMuS/wQ5Fw2NPQStUcPxePdbeWoGImSjMfQQONxWc
         Es1hB+QxTJxNzxWH62YXL5xUCDGM4bCY8fHs0dB1CChazCrGNnX2jRRL57L7Sy340+Qp
         zwnrf3Game/2DmdR+KXd/6xHjtnJdWt8QlCqucXE98Ou323+mTPsfweto+bnN7NmNiyl
         hErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973429; x=1715578229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ACCDkCRlD9tBHoUvBKfn0tCSNmu+4uS3hC8KCTfss/M=;
        b=B8WoxQBN5X9Khfdo3caVJnaidcqmG2SWGtvYb8T+/15XCsu7pn4i63mskUHjoabphN
         E+QxDNkvgBmUigdzf6Lv+/EiAVy2NeBcPpW52iauVXnVMQkf4+U4RhG4ix0MpvO5DFlb
         6eTvXoEwMtv4FBdRh9yOE+DXA2lJs8PDzY8WuQkKe6hWZAzcdj86xrD9aVrYjdLpr37v
         +pq7JWeN+RRWH0vwEyN42e/GbSwxGVY5rrpRS9fkLGTuys3Zyylqy5fFrAuAvmxJzE5l
         MswLRdopeT/NCFGBIa9GGRR9OfokfH6XMHpvfOxnSP1JoH53AXuc5ubUd1Fg3tj8yoUB
         i/cQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjBffsZJKhNK9yGii7AYfUNhsyHVOuhSHl5D8VfacygYI95jO1oEKoXyozIkBlSNPhZ0Q9TReEVP0Xd/438AlsHwU5
X-Gm-Message-State: AOJu0Yw31W19GKcxXaCAq4vjjYjpiHwFbv///l57wSO7biFEXwxtZ39Z
	va1BRT6YRyiFx6am15QojWvEFYU/iLGfwTbrxh+Wm/jwJF6jBRP/s/v6zyEq9/+c4seEEbbSQKj
	wM6wghg==
X-Google-Smtp-Source: AGHT+IEYX4QtJtZ/gu/SdroIPQpUpze1OVtX91ab7uVt7OcHA79QmRucTrnpzZmqcXaHZl7kYfEN/QektcBg
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:992:b0:6eb:1d5:a3a with SMTP id
 u18-20020a056a00099200b006eb01d50a3amr187533pfg.1.1714973428832; Sun, 05 May
 2024 22:30:28 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:26 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-2-mizhang@google.com>
Subject: [PATCH v2 01/54] KVM: x86/pmu: Set enable bits for GP counters in
 PERF_GLOBAL_CTRL at "RESET"
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

From: Sean Christopherson <seanjc@google.com>

Set the enable bits for general purpose counters in IA32_PERF_GLOBAL_CTRL
when refreshing the PMU to emulate the MSR's architecturally defined
post-RESET behavior.  Per Intel's SDM:

  IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.

and

  Where "n" is the number of general-purpose counters available in the processor.

AMD also documents this behavior for PerfMonV2 CPUs in one of AMD's many
PPRs.

Do not set any PERF_GLOBAL_CTRL bits if there are no general purpose
counters, although a literal reading of the SDM would require the CPU to
set either bits 63:0 or 31:0.  The intent of the behavior is to globally
enable all GP counters; honor the intent, if not the letter of the law.

Leaving PERF_GLOBAL_CTRL '0' effectively breaks PMU usage in guests that
haven't been updated to work with PMUs that support PERF_GLOBAL_CTRL.
This bug was recently exposed when KVM added supported for AMD's
PerfMonV2, i.e. when KVM started exposing a vPMU with PERF_GLOBAL_CTRL to
guest software that only knew how to program v1 PMUs (that don't support
PERF_GLOBAL_CTRL).

Failure to emulate the post-RESET behavior results in such guests
unknowingly leaving all general purpose counters globally disabled (the
entire reason the post-RESET value sets the GP counter enable bits is to
maintain backwards compatibility).

The bug has likely gone unnoticed because PERF_GLOBAL_CTRL has been
supported on Intel CPUs for as long as KVM has existed, i.e. hardly anyone
is running guest software that isn't aware of PERF_GLOBAL_CTRL on Intel
PMUs.  And because up until v6.0, KVM _did_ emulate the behavior for Intel
CPUs, although the old behavior was likely dumb luck.

Because (a) that old code was also broken in its own way (the history of
this code is a comedy of errors), and (b) PERF_GLOBAL_CTRL was documented
as having a value of '0' post-RESET in all SDMs before March 2023.

Initial vPMU support in commit f5132b01386b ("KVM: Expose a version 2
architectural PMU to a guests") *almost* got it right (again likely by
dumb luck), but for some reason only set the bits if the guest PMU was
advertised as v1:

        if (pmu->version == 1) {
                pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
                return;
        }

Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be
enabled on reset") then tried to remedy that goof, presumably because
guest PMUs were leaving PERF_GLOBAL_CTRL '0', i.e. weren't enabling
counters.

        pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
                (((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
        pmu->global_ctrl_mask = ~pmu->global_ctrl;

That was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu:
Don't overwrite the pmu->global_ctrl when refreshing") removed
*everything*.  However, it did so based on the behavior defined by the
SDM , which at the time stated that "Global Perf Counter Controls" is
'0' at Power-Up and RESET.

But then the March 2023 SDM (325462-079US), stealthily changed its
"IA-32 and Intel 64 Processor States Following Power-up, Reset, or INIT"
table to say:

  IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.

Note, kvm_pmu_refresh() can be invoked multiple times, i.e. it's not a
"pure" RESET flow.  But it can only be called prior to the first KVM_RUN,
i.e. the guest will only ever observe the final value.

Note #2, KVM has always cleared global_ctrl during refresh (see commit
f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")),
i.e. there is no danger of breaking existing setups by clobbering a value
set by userspace.

Reported-by: Babu Moger <babu.moger@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Mingwei Zhang <mizhang@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20240309013641.1413400-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c397b28e3d1b..a593b03c9aed 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -775,8 +775,20 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_data_cfg_mask = ~0ull;
 	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 
-	if (vcpu->kvm->arch.enable_pmu)
-		static_call(kvm_x86_pmu_refresh)(vcpu);
+	if (!vcpu->kvm->arch.enable_pmu)
+		return;
+
+	static_call(kvm_x86_pmu_refresh)(vcpu);
+
+	/*
+	 * At RESET, both Intel and AMD CPUs set all enable bits for general
+	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
+	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
+	 * in the global controls).  Emulate that behavior when refreshing the
+	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
+	 */
+	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
+		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


