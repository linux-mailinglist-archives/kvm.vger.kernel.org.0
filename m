Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE52F3EBDC2
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhHMVNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbhHMVNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8EEC0617AF
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w23-20020a170902d71700b0012d8286e44bso1028816ply.3
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ImD1K6W7q85b9plMlOYBF1Iglgh9e6yeR/4CNYhFQRg=;
        b=CZFVMacm4oRYM5riU6/kN8e+8QOv4ScQvNs7LSvfERJ4elKZRbXW+cb8Ajm1AP7A30
         RlwtBzLAGwJRbBQWXxizFVNyyhNotO7OsTweXQX2WsecNIfppBRrIGEldPfIqtK9rgBN
         q7lpifCkdvblOQzMIvdIsuToYogD0ih5pb8s6uGOzcaKoRfNg1CbXQA8AL2yutqZVz2n
         8t0Yb2b/6OxkhH7s4fpA/CBTuUYvc2vf1xbJRoEEZeWlyn3rmztALV6Z/xF4qjv3pcjb
         6rMgBz/c/geaxKZAZbK/g/LH+ddcynHYz4byTRGuv7/ja26tgAFuvg2zc8H6ed7fUDXE
         zxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ImD1K6W7q85b9plMlOYBF1Iglgh9e6yeR/4CNYhFQRg=;
        b=KsCPN3toWUvs+vFieQ+f/6erQNzT+rmgZIOGwNbu6gkqb29aHL2ZoNfbwFY2TQtjWq
         S0ZUE8IQ1MDTwhNjAMBseiLsLIwNJ+Q/oVKXZe07D1ruN7n2HydCXAOvv8t5nHXwYTvy
         vGmC6LaAwP2WepIFQJp3TMWTkjz0PwJH+P2LW+UEpc+fVuOd6skZAOGGRPlLMBM8pLIs
         ZovXkBylKxoHAC6YW0AGzW4dk9YJBxzJoNr1ErpvlKbzTs54LJ09IIJMq2ZdhbRlU6Fa
         EgWOrBteoyAgsZkbuA2Vn4x45AYK8QQ8iJgMyT53rzU8g6vLq4A2R672DOCkh/NWMY1w
         5wNA==
X-Gm-Message-State: AOAM531Uy4Jm5pOe7dJw2zoyZZ8eLjplcZ3JDPHsUQhTI/ua38Jwv6Cq
        2ugparXNo5Sw/ZOKSz1Mft6OYiWVXDPn
X-Google-Smtp-Source: ABdhPJz7Stco5O4WRJcJOWee+TYY1OyxYEHxh5Gszj92Xn7xpZ+r+S55XXaa2Tso8A7V93Qrha+yjd75ByH2
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:903:1243:b029:107:eca4:d5bf with SMTP
 id u3-20020a1709031243b0290107eca4d5bfmr3528610plh.15.1628889156661; Fri, 13
 Aug 2021 14:12:36 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:05 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-5-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 04/10] KVM: arm64: selftests: Add basic support for arch_timers
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
 .../kvm/include/aarch64/arch_timer.h          | 138 ++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
new file mode 100644
index 000000000000..e6144ab95348
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) specific defines
+ */
+
+#ifndef SELFTEST_KVM_ARCH_TIMER_H
+#define SELFTEST_KVM_ARCH_TIMER_H
+
+#include <linux/sizes.h>
+
+#include "processor.h"
+
+enum arch_timer {
+	VIRTUAL,
+	PHYSICAL,
+};
+
+#define CTL_ENABLE	(1 << 0)
+#define CTL_ISTATUS	(1 << 2)
+#define CTL_IMASK	(1 << 1)
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
+		return write_sysreg(cntv_cval_el0, cval);
+	case PHYSICAL:
+		return write_sysreg(cntp_cval_el0, cval);
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
+		return write_sysreg(cntv_tval_el0, tval);
+	case PHYSICAL:
+		return write_sysreg(cntp_tval_el0, tval);
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
+		return write_sysreg(cntv_ctl_el0, ctl);
+	case PHYSICAL:
+		return write_sysreg(cntp_ctl_el0, ctl);
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

