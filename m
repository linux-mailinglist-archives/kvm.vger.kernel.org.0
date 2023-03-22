Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A496C4678
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 10:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCVJbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 05:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjCVJbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 05:31:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DB2442FE;
        Wed, 22 Mar 2023 02:31:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so8040941pjb.4;
        Wed, 22 Mar 2023 02:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679477497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b/P1OzWAyXP8n6l8YX4wHeS0sQVxDP0LeHhymaMs17I=;
        b=m1vZW/vsDyPNyox3J2edRV5FS8ChuoOn5EwpCPC35JI25c2qcuj1Xj25vD9jH+uj8f
         vcB4pQ1n8UmJ2IU7ttfWju4CM1WXWP+05VNAoODrYXdpsNSPP+mCodbf85uAAC/HQU9b
         KS5sz7IQwlK1W4miEfZrbo+iA9Fc1F5/bCJ/Cy5XOnmjxky/mX5onlgoHJdyFeoqltKL
         A6vdrfXr8JQKUAdUztBuCulhAX7LZjhlGcdQY1jHJ9v229GW5Dq428LuV0dplqRbASx8
         CuEZAaRoOGlbPaQQNf/dvCgm8L5IE9+JT/DMqxhyOzjskGsAQQot5RzznOGLFQ4xFh54
         ne8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679477497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/P1OzWAyXP8n6l8YX4wHeS0sQVxDP0LeHhymaMs17I=;
        b=qD1j7w1QWgjPZ6IwjqYFMZE6RA9kyiZ8t5xuMsBBMihoSq0erfvxtJKr7yOb6xrxNR
         ze8XYAkh2AOZSImiSPFDtw7C9IgL+HoljDsg3lm4Kpxxhpb2OHGrnIl7l5+Fc7NpRoLS
         cczFzfbckdPt54fPBYGk2fiLLemALnuyxvgkARgzYnqH2FRtpkT5EH9eIdvBhK7Q1eFR
         duvc/RhQ113Qgvme4u1yOetslERBmpsfkXim+z/O2nLb565qQvw+1U2gzzIVZgI2P8it
         BWdC0QUfW4QkUZ/aTwT3GsSzcMFMySLNnnxTol3Omy/h/ysBkawEVU1yNY5ubgTusWpV
         e7rg==
X-Gm-Message-State: AO0yUKWPGFaOaBGiah7tF2RDM5+Bqs/FPFsLA3KEmQBpr3Nbq2bjkCqd
        KzDuQKbef9g2z7u2NCuS7Dc=
X-Google-Smtp-Source: AK7set9b6mZdRbgRMmT9lm13xzF54OQhbIKXTtbpW9y1X3PoThttIpRpVP4fV22Q6v19cKeRauo5GQ==
X-Received: by 2002:a05:6a20:65a9:b0:d4:b24b:4459 with SMTP id p41-20020a056a2065a900b000d4b24b4459mr5353505pzh.13.1679477496663;
        Wed, 22 Mar 2023 02:31:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e18-20020a62ee12000000b00625b9e625fdsm9902548pfi.179.2023.03.22.02.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 02:31:36 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit width
Date:   Wed, 22 Mar 2023 17:31:17 +0800
Message-Id: <20230322093117.48335-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Per Intel SDM, the bit width of a PMU counter is specified via CPUID
only if the vCPU has FW_WRITE[bit 13] on IA32_PERF_CAPABILITIES.
When the FW_WRITE bit is not set, only EAX is valid and out-of-bounds
bits accesses do not generate #GP. Conversely when this bit is set, #GP
for out-of-bounds bits accesses will also appear on the fixed counters.
vPMU currently does not support emulation of bit widths lower than 32
bits or higher than its host capability.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Previous:
https://lore.kernel.org/kvm/20230316113312.54714-1-likexu@tencent.com/

V1 -> V2 Changelog:
- Apply #GP rule to fixed counetrs when guest has FW_WRITE;
- Apply signed rule to fixed counetrs when guest doesn't have FW_WRITE;
- Counters' bit width set by cpuid cannot be less than 32 bits;

 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..d38b820d6b9e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -470,6 +470,12 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+			if (fw_writes_is_enabled(vcpu)) {
+				if (data & ~pmu->counter_bitmask[KVM_PMC_FIXED])
+					return 1;
+			} else if (!msr_info->host_initiated) {
+				data = (s64)(s32)data;
+			}
 			pmc->counter += data - pmc_read_counter(pmc);
 			pmc_update_sample_period(pmc);
 			return 0;
@@ -516,6 +522,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid10_edx edx;
 	u64 perf_capabilities;
 	u64 counter_mask;
+	bool fw_wr = fw_writes_is_enabled(vcpu);
 	int i;
 
 	pmu->nr_arch_gp_counters = 0;
@@ -543,6 +550,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 kvm_pmu_cap.num_counters_gp);
+	eax.split.bit_width = fw_wr ? max_t(int, 32, eax.split.bit_width) : 32;
 	eax.split.bit_width = min_t(int, eax.split.bit_width,
 				    kvm_pmu_cap.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
@@ -558,6 +566,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			min3(ARRAY_SIZE(fixed_pmc_events),
 			     (size_t) edx.split.num_counters_fixed,
 			     (size_t)kvm_pmu_cap.num_counters_fixed);
+		edx.split.bit_width_fixed = fw_wr ?
+			max_t(int, 32, edx.split.bit_width_fixed) : 32;
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =

base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
-- 
2.40.0

