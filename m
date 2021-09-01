Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B723FE4AE
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344472AbhIAVPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343712AbhIAVPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A92C061760
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s3-20020a1709029883b029012b41197000so247055plp.16
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+AY8FeEMdxANwbygbtDaWIs43jeZEXZSs/Nh/5qOONM=;
        b=sEIY6pZWU9JUoxbD3SFQAJZ+HaGDWEhhiX68l598G5kx1J0UFKGKlaSU38oiDTa1Tx
         M7YtesHq9xYqY0otdE0WpP3W5upth9uNrvUqlySOeWYnXdGfchoX7OqBLWKau4auWQci
         /Ml7YMnAC38eUFvCK8SQG8vG3CCC+WSwiLxcpI2nY/kIbj7jXbgrh4aijRFluLZH8qTQ
         r6862jdf17hMV2ehP0rYONQtfJac19PddlZr8gfK+HFjgAhjc3Uz1i5jonJrhI12qoMx
         tF06MUmg9WXAq6agNAue9s+mZxU7IgFJhBH9Ayn0+bL0etqXxP9RchKd8tiKtxV4bPA6
         xt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+AY8FeEMdxANwbygbtDaWIs43jeZEXZSs/Nh/5qOONM=;
        b=BFtznyhR4lWILfwZuLFke09QUG+WOqHiqlv8r8jUA/6qe3stEk6KWxudG4zCpqQ4BL
         SCp0X0mDgm8Pp/IR8T0lZGL3EDb9fJV43Aec3aSO3FoN92easu9TT4BKmb5Lx2MDhKid
         8iZUxM4L5ZHBPibJRWS1tPhSLShmhdBOPUeXdIgadjyLxwIoUDklJnHP2VRxJOARd+dd
         zmbbPxNpPtEgRboSrLZVy/IN5y0wXKTw8HZSSQU6ocPTaffHVLnx/ha+QMF1HtsQcG7l
         4/wEDvbR7aQLmbbricO6In84gsPkAGvDiekEQrM/zbpRStph/5XHpK31qifURs9/5DWj
         yPFw==
X-Gm-Message-State: AOAM530MBfmmaom2F29Ay2vq0YtlabX9lZ/dHwNsveXYwSzBXa+AZ95Y
        vqZU5nwxvASq9JDmx00Lr/odceRIu7ZC
X-Google-Smtp-Source: ABdhPJzfQCQqY7ZDdEh40WA7Lnhk+LTL8HLswLGjRlSmvbVQ8MCEnZQQ9EpYsHt2TdSwBvGTdcslFJvAEGDG
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:1888:0:b029:3c9:7957:519b with SMTP id
 130-20020a6218880000b02903c97957519bmr1345245pfy.17.1630530872495; Wed, 01
 Sep 2021 14:14:32 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:05 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-6-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 05/12] KVM: arm64: selftests: Add basic support to generate delays
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add udelay() support to generate a delay in the guest.

The routines are derived and simplified from kernel's
arch/arm64/lib/delay.c.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/delay.h     | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/delay.h b/tools/testing/selftests/kvm/include/aarch64/delay.h
new file mode 100644
index 000000000000..329e4f5079ea
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/delay.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM simple delay routines
+ */
+
+#ifndef SELFTEST_KVM_ARM_DELAY_H
+#define SELFTEST_KVM_ARM_DELAY_H
+
+#include "arch_timer.h"
+
+static inline void __delay(uint64_t cycles)
+{
+	enum arch_timer timer = VIRTUAL;
+	uint64_t start = timer_get_cntct(timer);
+
+	while ((timer_get_cntct(timer) - start) < cycles)
+		cpu_relax();
+}
+
+static inline void udelay(unsigned long usec)
+{
+	__delay(usec_to_cycles(usec));
+}
+
+#endif /* SELFTEST_KVM_ARM_DELAY_H */
-- 
2.33.0.153.gba50c8fa24-goog

