Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76094042EB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349781AbhIIBj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349698AbhIIBju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:39:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61261C06175F
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:42 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso62495pgi.21
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hjRX/HftaWd94e+jvOSEuHmijk3nZocmEtVUiH9mvr8=;
        b=DNT8H+P/i3+0pP+A8ae3zx+/69e/d6GKxdp5tnytAlBYxL1bysblA3Z96zvM7faRnp
         MiPxYxeza9JLHN0GpF4GmSXez3T0p4LoZRVFrVHQYzEr0LcPVUlKEELrUiWxD6I0A9Wm
         taOxz6ZoahTr8qdnhqB/tnCUY5TNl9VfVe5mDKpPeuQeDd5EQckZgFf63OfLJ5Pvjd0e
         IM/ym6YPja6fesLQKlJwdRY5BdXDUXU7h6AVrtoCG6Pmgk0KHvtPv9klWAhie36Uqena
         wWc0B+bDczYGE1Sq2/AfitLnfQKqzh5MeXwN4J65tKUXEmoCgUXw+E0W60fmyDJKwhst
         rOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hjRX/HftaWd94e+jvOSEuHmijk3nZocmEtVUiH9mvr8=;
        b=n46FwLPR1i36vzR+eo1nIwcAohG2mVQjPaPN5K5r694CVbsrQeYoE7QizemF0BWTiA
         lZ5VZBsMJO4fwRsxwxWxvFbqA78PPYVW5s9iooCJt05Vu4sBPUxY8/64wo7dJEmJEbES
         jFfBctONp/YE5jNKF1ot+DUDhld2GgX7ViQJL0u+Db77WKR2oxBAB2ZEqBiKaC9vjgOf
         p+gDIH5J8FW0IGTH5+7/03llbwQovKI58fdjYXuLLb17H0iz3Z2u11skk8KOkmZQ9M1e
         xiZCKuo4g3LwHUWcqG7hcGClnIKnufV2a/D+e/Js4m5aynsOkvf+ylGB1bTXhBzdzFn6
         nVZQ==
X-Gm-Message-State: AOAM5331T3sUnW7j+BQzY4QJH2BAzAIs45O4JUMBigyVKOzY21Zqes78
        N1gLvRKvE5eFs0xCfOg1O+QGn7pJSeL7
X-Google-Smtp-Source: ABdhPJyDh2cPwprGNDmaMLhS9RKCSqm8CaY83z9TCFAffNsjqNFL2DJ5xQrC3RTO9+d6S+9VLvSevr3OyarG
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:a415:b029:129:5342:eab7 with SMTP
 id p21-20020a170902a415b02901295342eab7mr420693plq.26.1631151521851; Wed, 08
 Sep 2021 18:38:41 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:07 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-8-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 07/18] KVM: arm64: selftests: Add basic support to generate delays
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
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

