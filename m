Return-Path: <kvm+bounces-57264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E38C0B524CE
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5DA11C21C3B
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 23:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9688127A92F;
	Wed, 10 Sep 2025 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnUwSVJL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E406D274668
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 23:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757548265; cv=none; b=nmIM3wDNdETa1WTRqDJ7lBo2VBodLyP+I6zuw4ZdpFy9Qn6XteNwGPaOUBDHOyYIg+Pavr6FSFZwIo9ohj9i+Be65/JRIoTOJLPVeRx+0Cod/diP3ZDe+DmJgPldkM2JFRVHIgxiXhRn9g23JNsJ5Kmf/Oii4F1RKbLiLRSh3j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757548265; c=relaxed/simple;
	bh=lT9wxRvvCIPJxXs5LthvBDL+Ph0L298VM/1LfR7jVG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NmSv5GjrcnqlWOj9jvIIQMHK8Txi4ZcGm8jnPa6FUEbaccNaKoV/jIMHuRwl/oYpX4h59iwrZWOztHfu1Ez8b4vyqX6/6fGZgaHx6cuCxcWOTSBS1YiAyGYllSfq+VxzPfO/SBnkFMQKJkgpKofpSmo7Hv2nDz9s0ADnCxMNtdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bnUwSVJL; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174bdce2so111035a12.2
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 16:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548263; x=1758153063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QdKgArnQrwIFW/ARGiTdXi98XW2fxSfLYpo+hZTfmQ8=;
        b=bnUwSVJLUtj2MFS3euLw2onzuMQ/6FNfJ2ARXFaJK5kJHgVMKe/5ol4QRmL8wu6tE4
         req5OdeIiAoesKCd80kflOkEVoRLbJAbB9X13RL06Sc6/ZBxSpY8IsUzn38OHKHllUoZ
         /75muWmqasU02L0zIMR9EXji4nRVRtDMR6ScjRXVoxt4Ose5EDh04Mnl8hjsbvVxvNAp
         NcsCJoInJMFa5kkObalGB+u7c2ffMApV2zW4diO9AWE7JvKoU3KqdYXNVONYt7vensRk
         2s3baYwCHVjdxZ+/WjrruwMabaXGxxEMiH09VCObeP7kraK3e01242eyZuNwSy/bczio
         f+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548263; x=1758153063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QdKgArnQrwIFW/ARGiTdXi98XW2fxSfLYpo+hZTfmQ8=;
        b=DsFk5M9NBsLEf1t9A81o5gYEhCl8ymNUf0gC95dPyfAO8WUkg8EH67axHU4YAAeQql
         h9c81PPbWhKY9oQci1K9jongaDm23RNaoVStlLNbu755sFaqmYxcE+6S9UvGfrZvEnf9
         lImBIP2F0VFq+kU0jFcY3v02QDTnCOs8fWKGHYlbw/e+vspss5Td1gnzIzr0L7D/qo6o
         u5mJPlW2LJznfLE5iZzUjEdduOa19ZblyhBaCBYXpx6DH5SbFaY3nXt+jbhNBihOogrk
         pRFnLETamz4yOPHl0G+hGml+U0R5hXf/OVoXEIzTtiFC/MIsmVwK75I40HUDC1JXFpDF
         ltWA==
X-Forwarded-Encrypted: i=1; AJvYcCUxJuze/6MJc2wvD6GgenECDLIUr3AOdd8Badh/NdJycqPUnkaX/LhDDaQYu1iQ1uDtCI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+e8s/GFzsO72oX2py5RrgRW6AKGMZ7NtAeALlJ5AzzNaARaCX
	i0ZYCrw6hKsvLOp2fxRTVMvJG3yOD3pTzhMhitZEOMhgB2cZaDIJvfcc1TKe1iggDVutJv7B73M
	T2rb+rw==
X-Google-Smtp-Source: AGHT+IHAOPoqLqzW42pDcQ2iL3CgvV4MYVB044aGs9+gV2plwshaHJewVBH05WXowEYEqUEjkGVyJvd+7wQ=
X-Received: from pgma18.prod.google.com ([2002:a63:1a52:0:b0:b49:dc77:f407])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4321:b0:24d:d206:699c
 with SMTP id adf61e73a8af0-2534519d154mr25197522637.53.1757548263178; Wed, 10
 Sep 2025 16:51:03 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:51:01 -0700
In-Reply-To: <20250718001905.196989-4-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com> <20250718001905.196989-4-dapeng1.mi@linux.intel.com>
Message-ID: <aMIO5ZLNur5JkdYl@google.com>
Subject: Re: [PATCH v2 3/5] KVM: Selftests: Validate more arch-events in pmu_counters_test
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Dapeng Mi wrote:
> Clearwater Forest introduces 5 new architectural events (4 topdown
> level 1 metrics events and LBR inserts event). This patch supports
> to validate these 5 newly added events. The detailed info about these
> 5 events can be found in SDM section 21.2.7 "Pre-defined Architectural
>  Performance Events".
> 
> It becomes unrealistic to traverse all possible combinations of
> unavailable events mask (may need dozens of minutes to finish all
> possible combination validation). So only limit unavailable events mask
> traverse to the first 8 arch-events.

Split these into separate patches.  Buring a meaningful change like this in a big
patch that seemingly just adds architectural collateral is pure evil.
> @@ -612,15 +620,19 @@ static void test_intel_counters(void)
>  			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
>  				v, perf_caps[i]);
>  			/*
> -			 * To keep the total runtime reasonable, test every
> -			 * possible non-zero, non-reserved bitmap combination
> -			 * only with the native PMU version and the full bit
> -			 * vector length.
> +			 * To keep the total runtime reasonable, especially after
> +			 * the total number of arch-events increasing to 13, It's
> +			 * impossible to test every possible non-zero, non-reserved
> +			 * bitmap combination. Only test the first 8-bits combination
> +			 * with the native PMU version and the full bit vector length.
>  			 */
>  			if (v == pmu_version) {
> -				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
> +				int max_events = min(NR_INTEL_ARCH_EVENTS, 8);

Too arbitrary, and worse, bad coverage.  And honestly, even iterating over 255
(or 512?) different values is a waste of time.  Ha!  And test_arch_events() is
buggy, it takes unavailable_mask as u8 instead of a u32.  I'll slot in a patch
to fix that.

As for the runtime, I think it's time to throw in the towel in terms of brute
forcing the validation space, and just test a handful of hopefully-interesting
values, e.g.

---
 .../selftests/kvm/x86/pmu_counters_test.c     | 38 +++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index cfeed0103341..09ad68675576 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -577,6 +577,26 @@ static void test_intel_counters(void)
 		PMU_CAP_FW_WRITES,
 	};
 
+	/*
+	 * To keep the total runtime reasonable, test only a handful of select,
+	 * semi-arbitrary values for the mask of unavailable PMU events.  Test
+	 * 0 (all events available) and all ones (no events available) as well
+	 * as alternating bit sequencues, e.g. to detect if KVM is checking the
+	 * wrong bit(s).
+	 */
+	const uint32_t unavailable_masks[] = {
+		0x0,
+		0xffffffffu,
+		0xf0f0f0f0u,
+		0x0f0f0f0fu,
+		0xaaaaaaaau,
+		0xa0a0a0a0u,
+		0x0a0a0a0au,
+		0x55555555u,
+		0x50505050u,
+		0x05050505u,
+	};
+
 	/*
 	 * Test up to PMU v5, which is the current maximum version defined by
 	 * Intel, i.e. is the last version that is guaranteed to be backwards
@@ -614,16 +634,7 @@ static void test_intel_counters(void)
 
 			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
 				v, perf_caps[i]);
-			/*
-			 * To keep the total runtime reasonable, test every
-			 * possible non-zero, non-reserved bitmap combination
-			 * only with the native PMU version and the full bit
-			 * vector length.
-			 */
-			if (v == pmu_version) {
-				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
-					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
-			}
+
 			/*
 			 * Test single bits for all PMU version and lengths up
 			 * the number of events +1 (to verify KVM doesn't do
@@ -632,11 +643,8 @@ static void test_intel_counters(void)
 			 * ones i.e. all events being available and unavailable.
 			 */
 			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
-				test_arch_events(v, perf_caps[i], j, 0);
-				test_arch_events(v, perf_caps[i], j, -1u);
-
-				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
-					test_arch_events(v, perf_caps[i], j, BIT(k));
+				for (k = 1; k < ARRAY_SIZE(unavailable_masks); k++)
+					test_arch_events(v, perf_caps[i], j, unavailable_masks[k]);
 			}
 
 			pr_info("Testing GP counters, PMU version %u, perf_caps = %lx\n",
-- 

