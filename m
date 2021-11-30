Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAD6462DAF
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbhK3Hpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbhK3Hpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:45:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20828C061574;
        Mon, 29 Nov 2021 23:42:34 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id o4so19701347pfp.13;
        Mon, 29 Nov 2021 23:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySY5gs4YmNlohZdoUrGBvO2t4ksP1moPL1VkuQOudcA=;
        b=XgJFvNg09Gdtz8x5xAK2L/MmHGIT8RZmo/pEGWoGD9+NE/J54ZK0VXCayTxE4ohAxZ
         pdVL+8f1DNgLEt8VuccErQxrz98Nui5d4PFSTZ6tdBU5FX51aaJoZC5w79Hu/RRKLf+Q
         K5xdSAboJJFGjdyKsQGuSpNadbOQbmWnB1hbz5y0KGKKN4gQ38e5Io26K8schL2RVNCF
         pkLlbuhNtTN4+fTpZnBuEVc7WyB4S1zKdqYkZKhITOmcr4Czr7WG8QluM5UBRyV/hTlX
         mOJmXc2WVy0DKi8LPT4qf5Ssab7J3cfmEL+ev47y6SGOFqCbypbfrMkbHX8F4M+O8MIb
         XDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySY5gs4YmNlohZdoUrGBvO2t4ksP1moPL1VkuQOudcA=;
        b=mBWZ3YcR6UmOH4iv6Vs13vQzrWH8rl66NuUKP9OmLcozyws9NbbPTt9eBIbNMyfqw+
         WvRSXt/ZUfZaWnS/9QIf4K8IKF6gAFNbJg4G9iLCN29sPI2HPt9frf0KsBABayYfhJw5
         33E2Q37WFUW0l3cYmW9L3Nt9yOEfNXd4Lf1/muYa+85N68QQCp8AmAVHsdV2dfLZ1Zgq
         IUYZ+tI/BjlPjHIB+u3SYggktrEXafOJgVXDGElNgIbc77iu1x91PWF9+XZHgthjptj5
         uYpTvgwvqTdpkpbTMRygUYotPuAPcN0NdV8EIaogXE+NFMQdkC5tfHFB+ZKoQL5J/hrg
         glGA==
X-Gm-Message-State: AOAM533NzAZ/09/XgCJDbv0muBgnmpG3TA0IXrV6PIJ8LLbeu61075UC
        r0z2rggTSvEoHwc1a+5xLME=
X-Google-Smtp-Source: ABdhPJyS/8uN9LDDNxbK5mQUO6ZcKb/OZOARz1X1CnAVdseszQ7/miVlmsO7RnqH4kxSU45uxZL4zQ==
X-Received: by 2002:a05:6a00:1783:b0:49f:c134:c6e2 with SMTP id s3-20020a056a00178300b0049fc134c6e2mr45261010pfg.0.1638258153697;
        Mon, 29 Nov 2021 23:42:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
Date:   Tue, 30 Nov 2021 15:42:16 +0800
Message-Id: <20211130074221.93635-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current pmc->eventsel for fixed counter is underutilised. The
pmc->eventsel can be setup for all known available fixed counters
since we have mapping between fixed pmc index and
the intel_arch_events array.

Either gp or fixed counter, it will simplify the later checks for
consistency between eventsel and perf_hw_id.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b7456b2177b..b7ab5fd03681 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -459,6 +459,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
+{
+	size_t size = ARRAY_SIZE(fixed_pmc_events);
+	struct kvm_pmc *pmc;
+	u32 event;
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		event = fixed_pmc_events[array_index_nospec(i, size)];
+		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
+			intel_arch_events[event].eventsel;
+	}
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -506,6 +521,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
+		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
-- 
2.33.1

