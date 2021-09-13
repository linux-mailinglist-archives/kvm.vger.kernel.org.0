Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA564409E80
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbhIMUwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348193AbhIMUvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:51:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDC2C0613DE
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d6-20020a63d646000000b00268d368ead8so8031450pgj.6
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=XCvIJVs/DuwD6DVXVIzmTZNaPbpYhKQLqpZ+rykxYdMxB/84Qi3vvYNUM88AonXgYm
         3V6M6oTDcFmeLBGC5wdKY8zvWQpQhY0wyzDGjzao2o0kiQeF8MKozUm6aPUJDoNJvQ0v
         Lmji7B2c73sTFVtY40SkEnXFX4/nn96K40bYLwW1C3pGJ5ybkts2yHh9IuwHH2le2c/F
         bklsQntTOO03t4HxTTxahmaU0/nj5BytTybtnNuD2k1GS2D8URinNWESa7cXIMFXBD7G
         9OnHFMdEybV2SP5svwz3As2tL0s9uOYNxase9+yjgy4dHZZJJIzB8FxgLSP4ZBdHFgbL
         qNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
        b=y/zm+v4qiw3ld+tU4cMdgws3tTztZlPubTOHiecD25A1MyTfZOGoxVC5H9Q5m+7HHF
         OTT4iIRLVBkCjC9daItq9hrn5Rjiyy37J57KI5n0KBowNDqpbTjbqcwgtlQUhRg66VHm
         7Gzn3123DxLE6VXlmjf02vA28SS3eDbJwggMXnpPygU0HmTXlTYST36/Y6lixxGMbIF6
         7Nyh/Uv5hUtqu6dysC3Q2co9SiqPnJ2jZsCXfx7aLNvOeWksl7Esy32KffXlWA4MXglI
         FZWmCs0AskFwXD2m2dX8j5miagfpIeLOjwqjRn3l7qfEPf3gZIgmzE/5j75czMpYoGgc
         wX+w==
X-Gm-Message-State: AOAM530x0e2UZclK3/GViFypNcbQuIC0QpIhjUcHVn+1DYjuVIObCXfz
        IrciFS8agYijbY9mEYHd341utVTybh71
X-Google-Smtp-Source: ABdhPJwfTceLZYDZAwbbgQTF9ZLpvhVdpi6vUBIdVg4ocUiJi21dM3Cwnc6gs258WgslLA9IFf0uYZgYLOjP
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1706:b0:434:9def:d275 with SMTP
 id h6-20020a056a00170600b004349defd275mr1328644pfc.1.1631566198555; Mon, 13
 Sep 2021 13:49:58 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:23 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-8-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 07/14] KVM: arm64: selftests: Add basic support to generate delays
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

