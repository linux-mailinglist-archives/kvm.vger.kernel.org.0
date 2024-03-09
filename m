Return-Path: <kvm+bounces-11438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E14876EA0
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B27CC1F22233
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E052D052;
	Sat,  9 Mar 2024 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1um5wWwV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9630B22F13
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709948210; cv=none; b=DAAZZkQ0+AmjG4LhMIh2cO0x29LvojVi1FBpjyMc6/Z4UMpMi7E6JL7x5VylzbTib15BH61dplp4SSk+WJPhLCajdt/vDBhpm2LFCcA6alpTCtRSJDJrBm3CiWhOCqhT8kV7c52FoHAj/QNbeWbr7q4E+04PEdvZi6PlEmnpFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709948210; c=relaxed/simple;
	bh=SWsPpADQLluvQvp2PRySI9bpj5F6vQcm7E3y70V4Wao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=USIlB3d8BBVPghac4LMgtq6gscuWS6RAwIYa/nM3heG0Xnt/NqIuGQUGHMsgAhHiyOMSbHQYr/OdNJBRqxLYe6eYJrTy9/nARnjFDOLUhb0p3VH83sH6r1VOxfs8NV9V5XihL8Dk3e0hlDEZb7QRhG8pOWwcIgAb6mQt+AQ0TB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1um5wWwV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dccc49ef73eso2626616276.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709948207; x=1710553007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rCwYO/7ilSpOBa4ppOSKCckO3uqB/kQ100+4pH+GXZY=;
        b=1um5wWwVzvKeIcQ4osLWCCjiUOwsPI8wZM+fFTDqJeGa3S5wAEA45vMVF4QvlTOvq6
         0Hj24Hu/hHbZ1SEUCy+IuWQM43KaPE79KFDduwdeoo/ymuCe0krgG7mqfQY1Z/99JQt5
         7NGSGkdtzaOLLEddIjY8WwMhgvvD2/9f8niXya6omOzXkWP0oXKUSlEbvaH6Z65LLjAC
         KK9q8LSX4z9BQ6rJfk+ZhsMnNvAs6m42/GG157FGg81jtc1RA7luBv7xdpOop43RwqGE
         gKtS38CzNrcGpG11inBe3vrMHOCZFffTdstcedBLbrO6BKHYMhFuBPHhzKQvwPfN/4/p
         hNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709948207; x=1710553007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCwYO/7ilSpOBa4ppOSKCckO3uqB/kQ100+4pH+GXZY=;
        b=qr8oriFRBl6x5ogtJyuZc/tDLhlOhJSr9DKm1pblzFts8xePw+7T7PF693w8aG79TC
         h6sfSPhhs1xsxI+mNVE9Yl5SlecmICsVTKAlcuEu1JzCrjAbwzyYXzkVpeiMCfrrGbQF
         4eYx/V4V0iJgY3If+KlMcRcDdA1/JzFJ9mkMG6VylrYkjBMLXoOQbtVGuFsPVVKBtolQ
         zVG8Yf72ubMkX5wMvziWQhRiiMz8AdWW51o/kBRaqxqp2plA9QJ5o/Z1X4qh5Algtgae
         1rJfRWspdpkOtgzszbN/LxyDcu1U3IsmK/Cr07FgReLvScdeEXjbuui+mdhEUVaDOf8W
         /iuA==
X-Gm-Message-State: AOJu0YwHfqMb0WA6NHNcomYtNjYRKofol/Y5uxOuXRmkQvSHm1us+54W
	b+R51YUJQ7MDyQ/z3hmjxnXe1QMiOLmouxtGYF5XR4JmI/Um2QddcPxykOTGiXrFTf153a++aN4
	jwQ==
X-Google-Smtp-Source: AGHT+IFvwDv/b0ydhsjPUXHw+jUb9gLdfBmL+i1F0ATMcxKeC9RIVzkgTlzWkZAwh4wYWsQF1XGiHgwcQwY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100d:b0:dcc:8be2:7cb0 with SMTP id
 w13-20020a056902100d00b00dcc8be27cb0mr40937ybt.0.1709948207688; Fri, 08 Mar
 2024 17:36:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:36:41 -0800
In-Reply-To: <20240309013641.1413400-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309013641.1413400-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309013641.1413400-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Verify post-RESET value of
 PERF_GLOBAL_CTRL in PMCs test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Babu Moger <babu.moger@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest assert in the PMU counters test to verify that KVM stuffs
the vCPU's post-RESET value to globally enable all general purpose
counters.  Per Intel's SDM,

  IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.

and

  Where "n" is the number of general-purpose counters available in
  the processor.

For the edge case where there are zero GP counters, follow the spirit
of the architecture, not the SDM's literal wording, which doesn't account
for this possibility and would require the CPU to set _all_ bits in
PERF_GLOBAL_CTRL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 29609b52f8fa..26c85815f7e9 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -416,12 +416,30 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 
 static void guest_test_gp_counters(void)
 {
+	uint8_t pmu_version = guest_get_pmu_version();
 	uint8_t nr_gp_counters = 0;
 	uint32_t base_msr;
 
-	if (guest_get_pmu_version())
+	if (pmu_version)
 		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 
+	/*
+	 * For v2+ PMUs, PERF_GLOBAL_CTRL's architectural post-RESET value is
+	 * "Sets bits n-1:0 and clears the upper bits", where 'n' is the number
+	 * of GP counters.  If there are no GP counters, require KVM to leave
+	 * PERF_GLOBAL_CTRL '0'.  This edge case isn't covered by the SDM, but
+	 * follow the spirit of the architecture and only globally enable GP
+	 * counters, of which there are none.
+	 */
+	if (pmu_version > 1) {
+		uint64_t global_ctrl = rdmsr(MSR_CORE_PERF_GLOBAL_CTRL);
+
+		if (nr_gp_counters)
+			GUEST_ASSERT_EQ(global_ctrl, GENMASK_ULL(nr_gp_counters - 1, 0));
+		else
+			GUEST_ASSERT_EQ(global_ctrl, 0);
+	}
+
 	if (this_cpu_has(X86_FEATURE_PDCM) &&
 	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
 		base_msr = MSR_IA32_PMC0;
-- 
2.44.0.278.ge034bb2e1d-goog


