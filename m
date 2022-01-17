Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2292B4901C6
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 06:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiAQF5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 00:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiAQF5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 00:57:13 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D72C061574;
        Sun, 16 Jan 2022 21:57:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l21-20020a17090b079500b001b49df5c4dfso2632028pjz.2;
        Sun, 16 Jan 2022 21:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4gdSmCj7yWsd2DI5GqBWLTuv6FfWDIo04+u9VO8cm4=;
        b=PcgDDloMAp6QKvrj36ECnpXVIibceDFsT7PNQ2qvcbiGtlW79G7BTQXhbR0Aa9a4il
         /21lr8MtQKlTRDv+l4Aw9pAVW8uigPfBvQK8rsL5BIe8MpsNKBPaWHi12b7zclZoXk2a
         4LBuzaiZzq0lf/maokSz6k2nGsdQdpubarEKNkY8yGp+JmQeEro2hm9SQgX8oXc9Tc/i
         9zDpVsgFBE/UtMhhUaICWLT2aMgvSgtKonw1pMHhHg7tNY8q3WhbdwttG08y/KrZ1ltn
         6hwAVFEcx218pzJavGW06NTE0eNFv51kVK5Es/Ulfu3gTknMc3CIPXgjQAqw050L8AX9
         S+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4gdSmCj7yWsd2DI5GqBWLTuv6FfWDIo04+u9VO8cm4=;
        b=0Ae0N1a9QTu2jlXjmBy2egu3mp86Z0YHXtH3HeLjU9tQyXzd4S83HxxjnV8m26nmW2
         kULo/YyDaXQ1hN0AE3/SkTyslIQaSwKnte7zY1YTRNRYIOvs9xFV5Ij69ztPGY+595Fn
         qFdNaY9w14kRch5AtchBHjHzKFCnOGJhnAUe7wXcyMoB/O6opDKycrTPQuhnev5mnN1G
         hTo72cGi18xnC54joOlrbhHvY3kJd2cIvkf8Sbv1mf5IZtHxdHwMOmD+LYF8SRoZWrKl
         nRB7PzLru9t1w6RuO8jXg5x4mXnDY6DGIXxiLowGfbKEBxRSAb2Mq1ETCcSa7ve2wf4j
         8raw==
X-Gm-Message-State: AOAM5326Z0lCLxkxEfzFNq49PoRPw+Pssth4YOaosRbPWJjfZIS+cxIG
        aJI4snRgM6rnz7FlaL4WaK4=
X-Google-Smtp-Source: ABdhPJwhbs0rnWj5qoUD0bcXPUTHc0ski6pPar3m8WCgklO4hGcqIg+G1ZJcIkr8UVmRhZ1LlWZcqw==
X-Received: by 2002:a17:902:b784:b0:14a:2fec:dda2 with SMTP id e4-20020a170902b78400b0014a2fecdda2mr21111673pls.118.1642399033104;
        Sun, 16 Jan 2022 21:57:13 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b12sm13144744pfl.121.2022.01.16.21.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 21:57:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Ananth Narayan <ananth.narayan@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43] for AMD erratum 1292
Date:   Mon, 17 Jan 2022 13:57:03 +0800
Message-Id: <20220117055703.52020-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The AMD Family 19h Models 00h-0Fh Processors may experience sampling
inaccuracies that cause the following performance counters to overcount
retire-based events. To count the non-FP affected PMC events correctly,
a patched guest with a target vCPU model would:

    - Use Core::X86::Msr::PERF_CTL2 to count the events, and
    - Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
    - Program Core::X86::Msr::PERF_CTL2[20] to 0b.

To support this use of AMD guests, KVM should not reserve bit 43
only for counter #2. Treatment of other cases remains unchanged.

Note, the host's perf subsystem will decide which hardware counter
will be used for the guest counter, based on its own physical CPU
model and its own workaround(s) in the host perf context.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..1111b12adcca 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -18,6 +18,17 @@
 #include "pmu.h"
 #include "svm.h"
 
+/*
+ * As a workaround of "Retire Based Events May Overcount" for erratum 1292,
+ * some patched guests may set PERF_CTL2[43] to 1b and PERF_CTL2[20] to 0b
+ * to count the non-FP affected PMC events correctly.
+ */
+static inline bool vcpu_overcount_retire_events(struct kvm_vcpu *vcpu)
+{
+	return guest_cpuid_family(vcpu) == 0x19 &&
+		guest_cpuid_model(vcpu) < 0x10;
+}
+
 enum pmu_type {
 	PMU_TYPE_COUNTER = 0,
 	PMU_TYPE_EVNTSEL,
@@ -252,6 +263,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 reserved_bits;
 
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
@@ -264,7 +276,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	if (pmc) {
 		if (data == pmc->eventsel)
 			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		reserved_bits = pmu->reserved_bits;
+		if (pmc->idx == 2 && vcpu_overcount_retire_events(vcpu))
+			reserved_bits &= ~BIT_ULL(43);
+		if (!(data & reserved_bits)) {
 			reprogram_gp_counter(pmc, data);
 			return 0;
 		}
-- 
2.33.1

