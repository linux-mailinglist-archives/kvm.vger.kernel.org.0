Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B9140A168
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350491AbhIMXMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349599AbhIMXL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCAEC0613E6
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id l124-20020a622582000000b00415b9d86203so7068155pfl.23
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=L74ftL0MnBDplytzX70ckvtTydMK0Eqbh058KvbeC7UELLvibodQtUhzEX3sYxlYaJ
         A2UkkQkn/G8fh+gpTXpjWgOV6XSPp1b7hJCymZ/nnuhX99gImgZBDhAsLQ+gcmxawHmq
         Ff+VM14GiOcjF0C8O95JMlr+EnM4Dv+iTOybu/LJosUhlXrnoelVNW0b3qmZAsAYxN8W
         96Fwg3AuXRFT68xYPygavi2uYU+F47+Ri4xMSufvj9uNMeya/FU8TN97LCCo15fY6210
         PYSQVNmyPuSLz+SeTHQrezFBodpaX0Hc2kB6Bd6aphu2xJpd4xO2ce/NNiM/ppfyeYKl
         Qkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=gJ1RIUwvVCrimj7VVAG/5/NoGUPaWtUjxkCgoJZrSdgIIXemM9PmpaaTcgvJw8vqW+
         5Le2UPr922kk1fQ/hkQlpegt5ncALfAI5ACnLLiLDPFE718pgx/ZFgQ7VjyfPxxCqIlv
         xe3Khb4a1v3QwjBbyxhu5Fmpd+0DkoP0tTV9mlrExlhRwnBq1/l2xWYOyjgLvoTYEhWf
         l/9nd2lQoLEAFeqLQ1pVkJeu8bZW/zXmodlhDNRy1rGFNosk5WvhsaTF0mM9AbbR9gvO
         WxqpqUZHzydFPjtu0PdlouPfhxBHx/QIiDH0OflWfyRU44glEb6hh+ocmukiw33fAvpg
         ORmQ==
X-Gm-Message-State: AOAM530Ru2u9VI0JwJy3ucee3UankgFkSPWtrekZ8KBFR4NVrrCEFgUg
        U8xWbtSzK9Z6cM8QjZ7cQ0gO+TlAOCR3
X-Google-Smtp-Source: ABdhPJy8bvr4FrZXQ2nQUysQcP7QaTOqreVVEVwJaF6HiOLbS3oknxNpc+PhzJi/hmUqnKElBX+9Bl/Hnfw0
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:6c97:: with SMTP id
 y23mr2075372pjj.117.1631574617035; Mon, 13 Sep 2021 16:10:17 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:48 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-8-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 07/14] KVM: arm64: selftests: Add basic support to generate delays
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
2.33.0.309.g3052b89438-goog

