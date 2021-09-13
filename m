Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3ACA40A16A
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbhIMXM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349601AbhIMXL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:58 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE03C0613E2
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:15 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u8-20020a0cee88000000b00363b89e1c50so58846852qvr.16
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T9aisqSrZe7Zpv0T/yzDlGfSGVHfKhvu7NylFmNxams=;
        b=rBjucDJ3ta+k3wuxs0ust81R0svbewqZMCunIwqkivqf5ghQ+IBtCYPT2ypBXC3p6S
         WWO0MUvCWHKcquTPg0gZpedDeiPF8nw/cfR7Lx8mJO+dO+K09Z4zupg3xltJhJcQLIvn
         HE5Otzk07L0SPs6cc1sRaItub4GJr/W2KrL2kKspUpvA96Qs9WsrOjbASLy32C0z5TWX
         ZkTbTwkwxKoX+FoDkLg9/sredz8o0OHK0kM1CMf97snA6VO+jLZ9i8MVR67dcVduqh63
         08kHAo5sU+moYAZ6Rx9yuaVBN76qocEEJGz9Y1zLLbsW0ZNC4M+h8RA7SKmZxmKde9dN
         EVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T9aisqSrZe7Zpv0T/yzDlGfSGVHfKhvu7NylFmNxams=;
        b=rRMn/XxaAJU2xgkfvtGnaHG8WkKy5Cr+XiQCM8D5UImN/MfRUroka/FpRhKMPOkOn1
         w5LwbwVDPF6fNbpJkyKtrZJpIfU4VklMNnOQyaCz/78j7zz7iHVsO09pIldbkKkrJuVq
         8XWeHh2cFFav6PN0m2UsgpOdqPJyn8AS9yugiZwPaM5amhW+QpODKu8+FaDVMlToqvoN
         +e8icOut6cBxrQfbwJJHnq4n8W50uESCywjXpBmnRYnut/AJwVSp3ZEyyW6S72vF2VYF
         M4S+IIDk94Wyxprb6yqvaaC7n+tVUJGMLLr+51mBDPG4zxyVNSig5oauOQXQsBUozaOG
         UxtA==
X-Gm-Message-State: AOAM5300W5S6ZiOQqae3jmG0qC3guL7xPP+hSOBZHvPluKmUDJxtC58y
        ah9vAgnuqg2RbSG0QCwuTvJpH+i4hGS3
X-Google-Smtp-Source: ABdhPJzPkHDhPfGSe3Cv01rERiBExMAW2NfsoPtPQLMMLRxd0+wQEDVBUIdIySdfPMKeqHZDMhF5eiwdHa7S
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:2609:: with SMTP id
 gu9mr2278889qvb.35.1631574615036; Mon, 13 Sep 2021 16:10:15 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:47 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-7-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 06/14] KVM: arm64: selftests: Add basic support for arch_timers
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.33.0.309.g3052b89438-goog

