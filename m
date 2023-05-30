Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F4671625E
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjE3Nn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjE3NnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACA1E8;
        Tue, 30 May 2023 06:43:15 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64d1e96c082so3229144b3a.1;
        Tue, 30 May 2023 06:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454195; x=1688046195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e81MAEdFlqNIu38FeGUumaW2uymzOspjggRyaO12kBk=;
        b=ZlOL0OAxZ8h3nb7D3Xzt83s+3lOnAQk15CoGx8QbadKbv8r/vkaVjiy2SCHZ8+QV8H
         OjYz0EKvn0p8gT7KCrOY6y2TIPvqrr5Z+GYCiV8aFTTaZNPmxCt253sJvIg9QLMIbjT3
         5n6RDgFhyautH3Su6WCFxmMmW9aWBq8VUScEH86wZbZGN84bzDaIWp6BQv30vWMx7jxl
         1ZAiUkNUtm9Z7QyvU6dYDjQc1u0RIKwx1cNHdATT2fTz7IZAXs0JsCBpQgOLNfsvvfdf
         d9fSyEoK35w+C4l0IeIiMAYJ7OXBgPWPLDHz/YXZCDKT43MU7xT7k3UbX9OmgUfqnm9o
         M+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454195; x=1688046195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e81MAEdFlqNIu38FeGUumaW2uymzOspjggRyaO12kBk=;
        b=E+/9t1Uhl9wiwGlNi1IP6ayDv4L9PrVamJZB47T3aMxNoPsccwwLBkR/vgxA0q5PRD
         WLRSGs2pXV+34dXvPq3Z247naOOnRRGUPvNfD4DqjCU2si0H2nzofgPZIfyjKPOVP/9t
         IyDwcb/MtCPne0Pqeae3PD2IHm8zvmstKt4ta04gNfMdH+ts8hF5dleceScm733kyTGv
         N1OkvI/Sntr3qvt+GqpqMUUPcd1rU8Ma6V1bdKzcR1I+Q0bSQuxybeRd5gVNNnlFTfjS
         8jXi9/TkZLFBG7JRKa3bev9zLd06vfJ9H87/Gx5zU5Szm8XrnLyEiH4qT9Y8WygbALTa
         oI5Q==
X-Gm-Message-State: AC+VfDyJsE/llSPh2qlcD7/7dXD/uDG1RbO7JshWvcKPjwO+r5M591XD
        am6JURAl1oUF5mlUXlKDngK2NxmJiGuG1x5J
X-Google-Smtp-Source: ACHHUZ6i8XdpWmsiMqINJLjHRD3+TXuhWKxJUwFaHyStKSK+eKxfXCLkjjt87EqNdEZWT+4vxhPGMA==
X-Received: by 2002:a05:6a20:a123:b0:10c:18a3:cbb6 with SMTP id q35-20020a056a20a12300b0010c18a3cbb6mr2956120pzk.10.1685454195109;
        Tue, 30 May 2023 06:43:15 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:14 -0700 (PDT)
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
Subject: [PATCH v2 2/8] KVM: selftests: Add pmu.h for PMU events and common masks
Date:   Tue, 30 May 2023 21:42:42 +0800
Message-Id: <20230530134248.23998-3-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

To introduce a new pmu.h header file under
tools/testing/selftests/kvm/include/x86_64 directory to better
organize the PMU performance event constants and common masks.
It will enhance the maintainability and readability of the KVM
selftests code.

In the new pmu.h header, to define the PMU performance events and
masks that are relevant for x86_64, allowing developers to easily
reference them and minimize potential errors in code that handles
these values.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/include/x86_64/pmu.h        | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/pmu.h b/tools/testing/selftests/kvm/include/x86_64/pmu.h
new file mode 100644
index 000000000000..0e0111b11024
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/pmu.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/pmu.h
+ *
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+#ifndef _PMU_H_
+#define _PMU_H_
+
+#include "processor.h"
+
+#define GP_CTR_NUM_OFS_BIT 8
+#define EVT_LEN_OFS_BIT 24
+#define INTEL_PMC_IDX_FIXED 32
+
+#define PMU_CAP_FW_WRITES BIT_ULL(13)
+#define EVENTSEL_OS BIT_ULL(17)
+#define EVENTSEL_ANY BIT_ULL(21)
+#define EVENTSEL_EN BIT_ULL(22)
+#define RDPMC_FIXED_BASE BIT_ULL(30)
+
+#define PMU_VERSION_MASK GENMASK_ULL(7, 0)
+#define EVENTS_MASK GENMASK_ULL(7, 0)
+#define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
+#define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
+#define FIXED_CTR_NUM_MASK GENMASK_ULL(4, 0)
+
+#define X86_INTEL_PMU_VERSION		kvm_cpu_property(X86_PROPERTY_PMU_VERSION)
+#define X86_INTEL_MAX_GP_CTR_NUM	kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS)
+#define X86_INTEL_MAX_FIXED_CTR_NUM	kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS)
+#define X86_INTEL_FIXED_CTRS_BITMASK	kvm_cpu_property(X86_PROPERTY_PMU_FIXED_CTRS_BITMASK)
+
+/* Definitions for Architectural Performance Events */
+#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
+
+/* Intel Pre-defined Architectural Performance Events */
+static const uint64_t arch_events[] = {
+	[0] = ARCH_EVENT(0x3c, 0x0),
+	[1] = ARCH_EVENT(0xc0, 0x0),
+	[2] = ARCH_EVENT(0x3c, 0x1),
+	[3] = ARCH_EVENT(0x2e, 0x4f),
+	[4] = ARCH_EVENT(0x2e, 0x41),
+	[5] = ARCH_EVENT(0xc4, 0x0),
+	[6] = ARCH_EVENT(0xc5, 0x0),
+	[7] = ARCH_EVENT(0xa4, 0x1),
+};
+
+/* Association of Fixed Counters with Architectural Performance Events */
+static int fixed_events[] = {1, 0, 7};
+
+static inline uint64_t evt_code_for_fixed_ctr(uint8_t idx)
+{
+	return arch_events[fixed_events[idx]];
+}
+
+#endif /* _PMU_H_ */
-- 
2.31.1

