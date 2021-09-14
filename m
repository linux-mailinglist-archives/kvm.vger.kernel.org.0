Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384AF40BB8E
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhINWdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbhINWc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:32:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDECC061767
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y134-20020a25dc8c000000b0059f0301df0fso857406ybe.21
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=BIj10EokpMKVIQvprsrN7AGSS04qrri+1fJcyz+LKoNcHUz6j8rumrXcsiDSnFs74L
         9FDCrCun3Ns1u9bqKeeY6R1UBzZHKV3TC7bWqekk9UDFkvxAnqgIAZkKWETHfVfnNJIO
         V3hPt9oyY+k9HY3GAvt4y5fuYMjBhEHoTb7lT1apdLkLojeyq56RwWjSplDAAgxXXSXz
         k72BBzzUlAYpu8xxAEVAtyh699qXYz7ZFlfDQ1dLvloxD2CtrwRjAZHg+snteBBYW3sA
         LrqQ4rXsno5KpGxAbJWg5DroQw0n1PtxFlJ5gy/AFbhGWS37uQgYCsDnV0idazo6jKiS
         dHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=THBU924nrvDwFSVERajV3UI3DMZEQ1Scr+ze2AH5FhP8avCRW4Rnrsm/Uo3hTZUMpF
         1w/yo4TDtY1zAR91q1I8AIK53SN0KF6EPK3BAhx8+PxgYnAv5tQ91ILxQ2WIHPYJQ0G4
         zxf3GZ060J3i8wJG/2F8XprpFUsqjfnYAUWpFPStlAoAKz2vrPKdkdxespq6cMhhzdiX
         ebzWc6k7Q7UBnu6KlKRUOhebRmNOLKWtoaP2I846OPZ90Y5SLhMf/kLyp73NQcvF2xGP
         5d5zv8oBNdelnPP3Z8EOGAvx7j6T63+WVdwYofPBX1JRYtDL7q2Xx6YRHr7BPH5G6dpE
         3vPw==
X-Gm-Message-State: AOAM530pcIlieoBkBrWJoqBLS2XEevX22MHXi+XyPKqOp9zgXS4576dJ
        U/UqzQZouFqQ/z5p8NzLD4Yb8HyABrFA
X-Google-Smtp-Source: ABdhPJwg1l1wqrNj3CGGHgoFxWtUJBru+go0+LCOPCPO8I6WcM88fBLT6JZsKkfu7HZGdHrfNtOrseuPhlcy
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c9c5:: with SMTP id
 z188mr2033066ybf.223.1631658697938; Tue, 14 Sep 2021 15:31:37 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:06 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-8-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 07/15] KVM: arm64: selftests: Add basic support to generate delays
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

