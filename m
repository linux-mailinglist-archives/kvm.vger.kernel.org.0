Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52AB3F0B31
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhHRSoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhHRSoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:02 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C94C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:26 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so2462452qkd.0
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0Y0O8/jMTi8+MKBw8+SC9CkFDxQTH0x1K+F2lorBjNw=;
        b=U4fCLEUOOczPm8ogE1eilqE2IX/q5dZYpTUaPZ7In9Xogc9Is2YYJ4PdA5z5akOnRb
         zbnCmhl/HcZiIWVFvBIxyxxxWDZwfM/6rVRUQbVjmR0xu4pEvT0dEiDNpHqpVKRUlGSg
         PrFH48Vl3R6SocBK9oc3ILkAflN3crptqFzwjm4iUdBsl8VZ7NgJfjxxzHZLEhZ1oZIb
         jCtqNb38XKIM7qCfGQh1ZXTf+UqyRJY/NYgCWUu8I9lHeBt8/9iAkp5OIkPk6FaOfAwk
         cvm2eEiSk3GiQf/6uwc3lmoxtOIXSFNluzN0FdPD8706siUbSTwTmZb8Ww1BYCvnptzP
         pLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Y0O8/jMTi8+MKBw8+SC9CkFDxQTH0x1K+F2lorBjNw=;
        b=lgFAJVXyOPCv1sjQaOy2SEtgrWb6T2Ve7T07MYjYBa/XcNQrI0ovbwRlXhSehiH8OS
         vhuiHGuvX6PORv1tDpdKueBd+RP72XPMpHUK2CXWQDEma/r4VXEoQRT818yDGxEnHN8P
         ITIaCl0h61oamGTZj6YjZwxUCPYLEbAtVVTG2FaIZDufdeUhcCoBK0TEZknDNFGeMD3l
         y4J2gT/YWL2mCGrofvabSG2f/FxbJBDVm7wV+32DepGe9ex34opMrPgy9PLZ5FiCBuYG
         3rPAHvoodhhHHso6wOhOMWBMjU8scu/un1uuS7C3m8hJPCrpalwqq5c543itqBq/+OLe
         Sj/w==
X-Gm-Message-State: AOAM532ep0Gulg/dBKKOo/HyKwfDqo2gq0zBpGyv9tbBXpQWJFts3rI6
        5FOvj9WWDBMmpWK99SMJT5G1jl9lb/kg
X-Google-Smtp-Source: ABdhPJzQWgpNp1Calgoj+b5RrQwbZcpvRpTehG5RJ6gjpdwYc8hrymlLG30VoJ0I1EDe0HQTY+K2VPCWx3ze
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:d8a:: with SMTP id
 e10mr10482331qve.22.1629312205652; Wed, 18 Aug 2021 11:43:25 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:05 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-5-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 04/10] KVM: arm64: selftests: Add basic support for arch_timers
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
index 000000000000..9df5b63abc47
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
+		write_sysreg(cntv_cval_el0, cval);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_cval_el0, cval);
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
+		write_sysreg(cntv_tval_el0, tval);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_tval_el0, tval);
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
+		write_sysreg(cntv_ctl_el0, ctl);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_ctl_el0, ctl);
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
2.33.0.rc1.237.g0d66db33f3-goog

