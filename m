Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587034042EA
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349503AbhIIBjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349565AbhIIBjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:39:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24384C0613C1
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y134-20020a25dc8c000000b0059f0301df0fso356480ybe.21
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ulk7lg3SWnBNJFJ99cX5GWqXCF6sjZDZS2dWa8toKKg=;
        b=jAKHD524wMO49NuE4IB1vnqJEKtcCTjhkAwc3lAUtMyKw7Pk9/nLq9TvVIs7Fu98Xr
         nSWsoHAe2XeE8Lcln5RyLQ6TtzzvHNH723D9gqRRsYNHzHjZTM0ohw50/OJQx0ba0iq/
         VDoROgSTz02R5syU054odn28QPH/NVNwsN95Nx67AY1PpnffxyEtUA5d8Pep3hHETDO5
         lmXuKBHKiUbMLZhSKk5VjWX13w/o3OPOiMxDPMoW10YOWiCqhlhROfxubrdXEO3ubUbD
         SQ9/N1tDjNrG5uM4OOdqLZagmr6EL8nBnD9Q3pqzjIBrGIx2zWPW6WK5ydoB4L+WpGuV
         jxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ulk7lg3SWnBNJFJ99cX5GWqXCF6sjZDZS2dWa8toKKg=;
        b=firi885480h/k21JKq7CwowmvHlw7b0EK7SJf2OM2u1rS21ptNMHTTu1OVVp1u0wsn
         GkTRZsDUgC8QjMqNYlAjDe0PTpDVJCdaue7647Ckn/kgiqIKZWXMEay8f9GzVfD1ixDQ
         +/mDu0dpFXqpO0uK7xUaurJTakqovM35Grwdj/7hp78XtrN8V1CZPrwOJFFQmDusNkx6
         6YxKcYZDYuQSlk2QaQN6SS9IwgK/A+ufSlrvmnXfQG6vEmsq0NbBYHOno7wdWwBJ+KDl
         UdEtyxeV96QfdePz/+4I12V0gsqYHqRgfYqbSKeK1lgmoleOehJlf+qTF2B8ZdIyiHQ/
         FPYQ==
X-Gm-Message-State: AOAM531fSJjRCT2huDwPfy/xtZzDsnNh7L0YVhrSpU9lCbv1divr8sow
        +qx03b0P49+GPvVlPlwgJLUbuc9F5q4w
X-Google-Smtp-Source: ABdhPJyd54TWYs4V5EnAlAUH5QhP/9ocrgnHZwTJO7/wp1dYTGqkAgZiD35uxEgGmkNMyaHA6QEGHxdCjfz4
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a5b:791:: with SMTP id b17mr568206ybq.263.1631151519339;
 Wed, 08 Sep 2021 18:38:39 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:06 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-7-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 06/18] KVM: arm64: selftests: Add basic support for arch_timers
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

Add a minimalistic library support to access the virtual timers,
that can be used for simple timing functionalities, such as
introducing delays in the guest.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/include/aarch64/arch_timer.h          | 142 ++++++++++++++++++
 1 file changed, 142 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
new file mode 100644
index 000000000000..cb7c03de3a21
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Timer specific interface
+ */
+
+#ifndef SELFTEST_KVM_ARCH_TIMER_H
+#define SELFTEST_KVM_ARCH_TIMER_H
+
+#include "processor.h"
+
+enum arch_timer {
+	VIRTUAL,
+	PHYSICAL,
+};
+
+#define CTL_ENABLE	(1 << 0)
+#define CTL_IMASK	(1 << 1)
+#define CTL_ISTATUS	(1 << 2)
+
+#define msec_to_cycles(msec)	\
+	(timer_get_cntfrq() * (uint64_t)(msec) / 1000)
+
+#define usec_to_cycles(usec)	\
+	(timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
+
+#define cycles_to_usec(cycles) \
+	((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
+
+static inline uint32_t timer_get_cntfrq(void)
+{
+	return read_sysreg(cntfrq_el0);
+}
+
+static inline uint64_t timer_get_cntct(enum arch_timer timer)
+{
+	isb();
+
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntvct_el0);
+	case PHYSICAL:
+		return read_sysreg(cntpct_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
+{
+	switch (timer) {
+	case VIRTUAL:
+		write_sysreg(cval, cntv_cval_el0);
+		break;
+	case PHYSICAL:
+		write_sysreg(cval, cntp_cval_el0);
+		break;
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline uint64_t timer_get_cval(enum arch_timer timer)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntv_cval_el0);
+	case PHYSICAL:
+		return read_sysreg(cntp_cval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+{
+	switch (timer) {
+	case VIRTUAL:
+		write_sysreg(tval, cntv_tval_el0);
+		break;
+	case PHYSICAL:
+		write_sysreg(tval, cntp_tval_el0);
+		break;
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
+{
+	switch (timer) {
+	case VIRTUAL:
+		write_sysreg(ctl, cntv_ctl_el0);
+		break;
+	case PHYSICAL:
+		write_sysreg(ctl, cntp_ctl_el0);
+		break;
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline uint32_t timer_get_ctl(enum arch_timer timer)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntv_ctl_el0);
+	case PHYSICAL:
+		return read_sysreg(cntp_ctl_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
+{
+	uint64_t now_ct = timer_get_cntct(timer);
+	uint64_t next_ct = now_ct + msec_to_cycles(msec);
+
+	timer_set_cval(timer, next_ct);
+}
+
+static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
+{
+	timer_set_tval(timer, msec_to_cycles(msec));
+}
+
+#endif /* SELFTEST_KVM_ARCH_TIMER_H */
-- 
2.33.0.153.gba50c8fa24-goog

