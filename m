Return-Path: <kvm+bounces-3194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DD0801881
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9F6C1C20B87
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFA28467;
	Sat,  2 Dec 2023 00:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AAY+Tv3H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EC71BC6
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:40 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2865a614ed6so1396129a91.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475479; x=1702080279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kARN2t1cDT1nPhBBpb3LTJ5yo8qfPIAw+yo3QqNarOE=;
        b=AAY+Tv3HRsRRO7etlXqC0lCOCShST/GGftsFzjIet2J7cna2R5K4TW+Y61HpbcKnLf
         sSm13SLogQ3Wex8o9pMrXgfes8g8h3edtoWHygcq2Nw89h/Esp3vVCX9u6StgV8ZbOr/
         xp+dMlXlN3M8BeyHDnB8RWxkCPQuoTXhnXTMRCKeJi9/ypGqDa8hyDlGjhdfoLel7NFg
         rp5Ph59GGvzjmxvsfB+liF6LhCgqcC8c6VNCZxXV2svH8cHUTcplApVgnI+LW8RfTZY3
         cMyq/7FpSrVhNmePc9xljNXA/h2WYyj7sjS4BthD5+lum2rwrNFPqYl6AfXNAiZpvxP8
         03mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475479; x=1702080279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kARN2t1cDT1nPhBBpb3LTJ5yo8qfPIAw+yo3QqNarOE=;
        b=Q385irUPPUaY/VijIPi0uofQWiemUyegaP1CJRFz/PMHU6x9FlZK4goiBGcTYBLgxf
         3pnHH4e/jDdfmXtOB7Y58LY5bNDUWnBTCMxYgHCSXz6iq7DqdFFeK5kosTYPFo3lXjlU
         XpOePwC9+/wkQidrU3wudZRiaSa2eE7BMBuS0Z+/YM5XdfNk/GnXmoaQo/w8lfY+Y9lc
         mmbLdjVDsXo5cBkePoTcOGTMqldbZl/CuZfVKGA8urZ9LYFPQUWlsTT3LQO1xf7L07NA
         7fMx127+SI3umwky2Z8Q04ek27ksaqei6FQeGt8jgpoxXIl9BK9wn/5/opI8eQCouQS/
         OBcQ==
X-Gm-Message-State: AOJu0YwwpJ7lfHRi374cxMpiASxiboUEkKgfNUboRyxAPT+3XQ4wf2hI
	ZwfCqEgjgh0zLz27kpj8x53qbms0FMw=
X-Google-Smtp-Source: AGHT+IGkgfpbdPCK5UBd6AozaX6YxWcy/rifmqb9aNIZ5Kc3MKHGLaSP/2ib181qUSOmDWEVRIzpY9ZYZqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3291:b0:1cf:5cd7:8416 with SMTP id
 jh17-20020a170903329100b001cf5cd78416mr5059080plb.13.1701475479406; Fri, 01
 Dec 2023 16:04:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:59 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-11-seanjc@google.com>
Subject: [PATCH v9 10/28] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly check for attempts to read unsupported PMC types instead of
letting the bounds check fail.  Functionally, letting the check fail is
ok, but it's unnecessarily subtle and does a poor job of documenting the
architectural behavior that KVM is emulating.

Opportunistically add macros for the type vs. index to further document
what is going on.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 644de27bd48a..bd4f4bdf5419 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -23,6 +23,9 @@
 /* Perf's "BASE" is wildly misleading, this is a single-bit flag, not a base. */
 #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
 
+#define INTEL_RDPMC_TYPE_MASK	GENMASK(31, 16)
+#define INTEL_RDPMC_INDEX_MASK	GENMASK(15, 0)
+
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
@@ -82,9 +85,13 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	/*
 	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
 	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
-	 * i.e. let RDPMC fail due to accessing a non-existent counter.
+	 * i.e. let RDPMC fail due to accessing a non-existent counter.  Reject
+	 * attempts to read all other types, which are unknown/unsupported.
 	 */
-	idx &= ~INTEL_RDPMC_FIXED;
+	if (idx & INTEL_RDPMC_TYPE_MASK & ~INTEL_RDPMC_FIXED)
+		return NULL;
+
+	idx &= INTEL_RDPMC_INDEX_MASK;
 	if (fixed) {
 		counters = pmu->fixed_counters;
 		num_counters = pmu->nr_arch_fixed_counters;
-- 
2.43.0.rc2.451.g8631bc7472-goog


