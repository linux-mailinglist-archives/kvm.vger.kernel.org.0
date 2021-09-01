Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7913FE4AA
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbhIAVPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343897AbhIAVP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7C2C061796
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:30 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b5-20020a6541c5000000b002661347cfbcso410415pgq.1
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bqVlFpnmP8NmTTti9CdOhbMypDVSrXZ53ek7S7Y13dg=;
        b=AR+RDnLHNZuVu6FIvRaDOeDqjj39uN9iakX22xaIHLpaOytDQhgjx40e8j9ZNl6RzS
         wSgDgLBA0CeS9FO09aRCRjcUwfaVNTJrkjMa4RUQ19m5yOwQSapCy+0U3MxFECUV9ht7
         INthlaNZa7PH6ekx/zmAF3sTgxATpQ5CWSu4KTRyzo6r30dkkNfTTH1622pPsjkPIAFS
         LiwzJdoE2PpDyuUCyFXPLTu/JX31eL29eHuJPl8XwVtHC3r7k35FVQVG8PGeY6v9t68G
         NXxZ9jTChQOtO3NPmeuDEqCa8eCtO0+0NWQenjgAfTYc9gc3nlCizX9UAa4Ia51iDKLZ
         wjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bqVlFpnmP8NmTTti9CdOhbMypDVSrXZ53ek7S7Y13dg=;
        b=BlZGFwDPSVvptezNijpEveQczwN8Lj3FOeYW9yYZMGCerf8a5zXIq2eLIaRiDAWZsf
         VugVhRGfXdolwlD/BPEoK2fCp1QS0oC9e96anm7fApLRHOq7bYvzddWRcPTnmPD7gM5I
         wV3RBC0hRGTd46qPUEIsjKRC+WzAOHTnEc4BhRoYpbY6ZgrLk6KD1jgUSEdWWuuE1snv
         zDmya3/RhZj30k9bRj2gT29A2FFL+a5SazfwM82y0I7xM1XIs+9ZY61NXWhrHvAs3yr5
         ImhCWMb2yxt3xGsMRKumLMj6H7f+QR1w87riY7uoYqMRHxU21beeOXZflCOXWRpdQS+5
         SMHw==
X-Gm-Message-State: AOAM532XfpjvqAN3Bdpu4npCs7HL0+YOiOULGVionODtg3qw/NPeet20
        8xbxqzFbnmji7g2l58bDgsBB9mnC87ak
X-Google-Smtp-Source: ABdhPJzGx/trwzoiKd7u6u8XYzmhqnFpS6SWs9oellLrfXtEBkF9rbw+PGJ3ocNzV3eBNmXBmMCTuNw7Qg+j
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a65:5887:: with SMTP id
 d7mr967741pgu.285.1630530870253; Wed, 01 Sep 2021 14:14:30 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:04 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-5-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 04/12] KVM: arm64: selftests: Add basic support for arch_timers
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
2.33.0.153.gba50c8fa24-goog

