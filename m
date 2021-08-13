Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AC3EBDC3
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhHMVNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbhHMVNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94871C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ns7-20020a17090b250700b0017942fa12a8so1972235pjb.6
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
        b=CWKvMvq482YcNTRILLKxrh/xXxR9laMMXd5epUlsTlwgqwSaX6jxASp2d+jPJJHATO
         uq70iG5BIugJ6LTQ/N2CA7kNudIDf8jJOq/Mbeq72/1jYBoPwBj47fTLtm7ZYZ3UHWgj
         LXD5RMu1CojOoWF8rcnS78THeu4/0Aohx6EMP0HZc8Ps0Zk+qQTVPDS7U6/VXSXlbPZJ
         MjtBHGnHlUOfk96OBdhBl4berWwQsylBeu4KtAOyoCtCXEftrQk+hdqlCoLRPcYIV2va
         rR0J/hpsbfkRpmGM9c+uIbBOYxu6mjORsohBqt1WNdT5lSCYEoBSYWpOvv5dKH1WGhF0
         jlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
        b=KAnBvK7i5UlCiGBCQ/N8RI8heAxE7CATvrxjrBXSXjepyC1+viFk0+NrFKHWWnCpEa
         n9iwUR9nx2JgjR6y+GTz2pBPtb+DN5Q3JPpp1aohIuKCf7Ur6AEn+dJ6ucbXXIzyz3lp
         nnQAtjFl4fCiGktQUT3P/TphJ0gSFExJOPhKTepflK9DrA+14cKF4CqK8wthcN5riKCR
         hZxsMlQ39MD9I+/TF3cPzPzLOG0Ev1t71zMuOy/oRonvlfkDtlCv8xe9kiYHVknzsDiJ
         7iveAh8TCyvhn2e+EGysLfXK6Z19X2CU3ALlrEJpjLQeWNYqAN/BBBoTvBLjnLngmA54
         +Vuw==
X-Gm-Message-State: AOAM530lOQBh60M1FWmLZcA0svmtfUMyr+aIOx9OgNmVbxyWITC+G9Na
        v5UdMHbMxgfIBpwHdTOidyzlVDzWRApe
X-Google-Smtp-Source: ABdhPJxkQK9wa8EAKeJUZV8Gv80qxslUu0aDGjvZsi5a5rtCn9QS93AjUmOYIEaffTe0zniAjkpecuN6BdRu
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:7584:b0:12d:8cb5:c7b8 with SMTP id
 j4-20020a170902758400b0012d8cb5c7b8mr3462236pll.84.1628889159142; Fri, 13 Aug
 2021 14:12:39 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:06 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-6-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 05/10] KVM: arm64: selftests: Add basic support to generate delays
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
2.33.0.rc1.237.g0d66db33f3-goog

