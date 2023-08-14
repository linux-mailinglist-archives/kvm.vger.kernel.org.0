Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B577B7CB
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjHNLwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjHNLva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5D31AA;
        Mon, 14 Aug 2023 04:51:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-686f0d66652so4062542b3a.2;
        Mon, 14 Aug 2023 04:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013889; x=1692618689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AP8ae3qQgO3DzVD/Nec443NRAN8vAky7C/bENgh3Bkg=;
        b=Q37UaYZA+7waWRGB3LCdyEMCricYxPaScACuYS5DMXNVBLv6cMYSEfuK5ErgLpd4vk
         lVjFndTlY32Qtw3r1cLEwOrYslCFiqzEh2QqBysDUu5Nv2VQjuRlLEvSVPn7W8OtPR3/
         0Wy8YF6oVeIUkjmrIkfKyjlc+cEDV8L2uMY9xmAIaJ8G4zdtkusptcoVzWyGStuwBt0q
         suYdjct53S/qe0B4M6EJ1ZeMa9imlcMnO9y2VJbKiN7tIAtf02meNc+A60CZdInOzlpI
         hOLwOXbNWxdp7wo2atKHK4PI+VPpTilNz4z6i4EZdXSLCLtbQGHDY1hus3o9KaszWTWR
         pS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013889; x=1692618689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AP8ae3qQgO3DzVD/Nec443NRAN8vAky7C/bENgh3Bkg=;
        b=l0zwlL+azSQtwaIbuERed5OJBfhHa2yO/qiQQqVuCMnhYaU1CcZZzMpsQpW113RfW/
         C6bB4XK5LFUjPPNvFjqNZe3brud8ItkMLrpIISsD6UZme5HOt729oSOnaqh6PB7dKNP8
         /mb2KeeLUcS0qh02IWEXvVYBcgiNJlTR9pAxdetD0UmooUDlgkhqW37qvV/NaMchfgG/
         TlgRw3ttmkx+kfDjpe5byv5rCe0pk6gO3ee4Q8UumgJyxdYKrkrS+jo6QHuUr3wanpm8
         UJ8KDKrQBKIeOJDxsBzF0aykfIowYTTJPK0HwzmZ6LQ59Dkx773SwNO9zbBGR2nfzLkW
         saXA==
X-Gm-Message-State: AOJu0YzXcJa+L7bi1s9nTTe8HDIAZXH197Tq9gGEgAnTcvqZzVRZdEV9
        4CNY39vaa1Q13Hu74AzNxX3hYyWHmuxWtKc1lZg=
X-Google-Smtp-Source: AGHT+IEQpjnn4VlPM2TBrIJh0yzw3qHi9E878iI4plyMnLxbGqFqN1X4lZztYvRiXzH+s9rTLBGXFA==
X-Received: by 2002:a05:6a20:9187:b0:138:1980:1837 with SMTP id v7-20020a056a20918700b0013819801837mr13062892pzd.13.1692013889157;
        Mon, 14 Aug 2023 04:51:29 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:28 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/11] KVM: selftests: Add pmu.h for PMU events and common masks
Date:   Mon, 14 Aug 2023 19:50:59 +0800
Message-Id: <20230814115108.45741-3-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

By defining the PMU performance events and masks relevant for x86 in
the new pmu.h header, it becomes easier to reference them, minimizing
potential errors in code that handles these values.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/include/x86_64/pmu.h        | 124 ++++++++++++++++++
 1 file changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/pmu.h b/tools/testing/selftests/kvm/include/x86_64/pmu.h
new file mode 100644
index 000000000000..eb60b2065fac
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/pmu.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/pmu.h
+ *
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+#ifndef SELFTEST_KVM_PMU_H
+#define SELFTEST_KVM_PMU_H
+
+#include "processor.h"
+
+#define GP_COUNTER_NR_OFS_BIT			8
+#define EVENT_LENGTH_OFS_BIT			24
+#define INTEL_PMC_IDX_FIXED			32
+
+#define AMD64_NR_COUNTERS			4
+#define AMD64_NR_COUNTERS_CORE			6
+
+#define PMU_CAP_FW_WRITES			BIT_ULL(13)
+#define RDPMC_FIXED_BASE			BIT_ULL(30)
+
+#define ARCH_PERFMON_EVENTSEL_EVENT		GENMASK_ULL(7, 0)
+#define ARCH_PERFMON_EVENTSEL_UMASK		GENMASK_ULL(15, 8)
+#define ARCH_PERFMON_EVENTSEL_USR		BIT_ULL(16)
+#define ARCH_PERFMON_EVENTSEL_OS		BIT_ULL(17)
+
+#define ARCH_PERFMON_EVENTSEL_EDGE		BIT_ULL(18)
+#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL	BIT_ULL(19)
+#define ARCH_PERFMON_EVENTSEL_INT		BIT_ULL(20)
+#define ARCH_PERFMON_EVENTSEL_ANY		BIT_ULL(21)
+#define ARCH_PERFMON_EVENTSEL_ENABLE		BIT_ULL(22)
+#define ARCH_PERFMON_EVENTSEL_INV		BIT_ULL(23)
+#define ARCH_PERFMON_EVENTSEL_CMASK		GENMASK_ULL(31, 24)
+
+#define PMU_VERSION_MASK			GENMASK_ULL(7, 0)
+#define EVENT_LENGTH_MASK			GENMASK_ULL(31, EVENT_LENGTH_OFS_BIT)
+#define GP_COUNTER_NR_MASK			GENMASK_ULL(15, GP_COUNTER_NR_OFS_BIT)
+#define FIXED_COUNTER_NR_MASK			GENMASK_ULL(4, 0)
+
+/* Definitions for Architectural Performance Events */
+#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
+
+enum intel_pmu_architectural_events {
+	/*
+	 * The order of the architectural events matters as support for each
+	 * event is enumerated via CPUID using the index of the event.
+	 */
+	INTEL_ARCH_CPU_CYCLES,
+	INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	INTEL_ARCH_REFERENCE_CYCLES,
+	INTEL_ARCH_LLC_REFERENCES,
+	INTEL_ARCH_LLC_MISSES,
+	INTEL_ARCH_BRANCHES_RETIRED,
+	INTEL_ARCH_BRANCHES_MISPREDICTED,
+
+	NR_REAL_INTEL_ARCH_EVENTS,
+
+	/*
+	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
+	 * TSC reference cycles. The architectural reference cycles event may
+	 * or may not actually use the TSC as the reference, e.g. might use the
+	 * core crystal clock or the bus clock (yeah, "architectural").
+	 */
+	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
+	NR_INTEL_ARCH_EVENTS,
+};
+
+static const uint64_t intel_arch_events[] = {
+	[INTEL_ARCH_CPU_CYCLES]			= ARCH_EVENT(0x3c, 0x0),
+	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= ARCH_EVENT(0xc0, 0x0),
+	[INTEL_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0x3c, 0x1),
+	[INTEL_ARCH_LLC_REFERENCES]		= ARCH_EVENT(0x2e, 0x4f),
+	[INTEL_ARCH_LLC_MISSES]			= ARCH_EVENT(0x2e, 0x41),
+	[INTEL_ARCH_BRANCHES_RETIRED]		= ARCH_EVENT(0xc4, 0x0),
+	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= ARCH_EVENT(0xc5, 0x0),
+	[PSEUDO_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0xa4, 0x1),
+};
+
+/* mapping between fixed pmc index and intel_arch_events array */
+static const int fixed_pmc_events[] = {
+	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	[1] = INTEL_ARCH_CPU_CYCLES,
+	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
+};
+
+enum amd_pmu_k7_events {
+	AMD_ZEN_CORE_CYCLES,
+	AMD_ZEN_INSTRUCTIONS,
+	AMD_ZEN_BRANCHES,
+	AMD_ZEN_BRANCH_MISSES,
+};
+
+static const uint64_t amd_arch_events[] = {
+	[AMD_ZEN_CORE_CYCLES]			= ARCH_EVENT(0x76, 0x00),
+	[AMD_ZEN_INSTRUCTIONS]			= ARCH_EVENT(0xc0, 0x00),
+	[AMD_ZEN_BRANCHES]			= ARCH_EVENT(0xc2, 0x00),
+	[AMD_ZEN_BRANCH_MISSES]			= ARCH_EVENT(0xc3, 0x00),
+};
+
+static inline bool arch_event_is_supported(struct kvm_vcpu *vcpu,
+					   uint8_t arch_event)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+
+	return !(entry->ebx & BIT_ULL(arch_event)) &&
+		(kvm_cpuid_property(vcpu->cpuid,
+		 X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH) > arch_event);
+}
+
+static inline bool fixed_counter_is_supported(struct kvm_vcpu *vcpu,
+					      uint8_t fixed_counter_idx)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+
+	return (entry->ecx & BIT_ULL(fixed_counter_idx) ||
+		(kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_PMU_NR_FIXED_COUNTERS) >
+		 fixed_counter_idx));
+}
+
+#endif /* SELFTEST_KVM_PMU_H */
-- 
2.39.3

