Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7B453208
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhKPMY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbhKPMYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:24:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65540C061570;
        Tue, 16 Nov 2021 04:21:28 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h24so15631162pjq.2;
        Tue, 16 Nov 2021 04:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7F5Lvhn24cMlzWrTzTbYKCZovRCb/JxaUFwZhQfpJYI=;
        b=c7/8iYDW6CPgL2+6c9XdepSzToGCkAU618zw7Rf0b2NxASDxHgTXTJfq+xqckOKfV2
         UBuOna+hWgbXA4eloGc9wYGFJi+hRM3Hjj8ZvQtfaRB8vD+Ke7OYlgpnvf7jgOrLBzMz
         4V8U4k4LMeiORIzEPSa/OTAIKrGfEt6t14zEn1eHXK1aVvWG7aeFGgJQxUAIoG/WbUFP
         I3yMWgm+AGKwy99C2LUGSyso+v3P/Z1u7zC8N3FG1w/JCx3N8yk+JACd15CjMjR+ilIV
         rB+rwWctPkiho5+Hb/3qPg8Vt3PyYd6gekRgdldArVK1lqDbuh/WrA+m9MkUAW6Cfsl9
         WNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7F5Lvhn24cMlzWrTzTbYKCZovRCb/JxaUFwZhQfpJYI=;
        b=jnnc4C3walPxSMGDJGb+X62/cn4ohzfFNUqkPZdKFkRPHkgHTZyHp1Lf2q9BHGh9PQ
         bisGpfUklDkIDhyKkyG8B6cG+gV50wZ9Hb/UHdlcvvZKP0FyiJRfDs7VVeEnHe9bNAT6
         DoE8Ep43Qw8OpGA2ZIKF8+vWZa7roVTm7lsfbEJCRRol43Qk4XAVR1mjU6BzhaMJpOHI
         gGC0hBdbqWYKvJ/PZ+r0CdBeKk1eZLMkDHNHcu+z+cwByOIdWWBtfAmp/JOqpNC+e6+J
         6h+v6lS0wUsufOqGjgvFmTJCO0lgC451s0JkzHWyZYHrNft1+BVXiUwQxJ/Ymjr9lxcp
         rntA==
X-Gm-Message-State: AOAM5332vDwOLb85tgs+86Cdwc/37Jm8Bvz9/TLuiyEl1GK+npGSn06W
        wAJLj4S4qp532xYnbdwhOU+X5hJTTFQ=
X-Google-Smtp-Source: ABdhPJzKvgNYtORCAC+bBm1gM/c4U1DBnoWftkoeApwsDxv4ebs7fw62i9zu444hrIpaQQ0qTZA5pA==
X-Received: by 2002:a17:902:ee95:b0:141:f28f:7296 with SMTP id a21-20020a170902ee9500b00141f28f7296mr44669774pld.50.1637065287983;
        Tue, 16 Nov 2021 04:21:27 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i67sm18557613pfg.189.2021.11.16.04.21.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 04:21:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
Date:   Tue, 16 Nov 2021 20:20:27 +0800
Message-Id: <20211116122030.4698-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116122030.4698-1-likexu@tencent.com>
References: <20211116122030.4698-1-likexu@tencent.com>
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
index b8e0d21b7c8a..51b00dbb2d1e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -460,6 +460,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -507,6 +522,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
+		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
-- 
2.33.1

