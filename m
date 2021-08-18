Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDA3F0B33
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhHRSoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbhHRSoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32297C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id 5-20020a170902ee45b029012d3a69c6c5so781543plo.7
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
        b=XclqRPUA0/dOnnUxZ6e5xfFEGz1bzMNLZDMWFZSNFvSFo8M+XkqAR82qhWjdPE04Gd
         aXBogWWruyzy9kxHz03pmBGH/UtNF0W3hCs5Aaq4tpFylnvpbS77o1qVZhE6gSQuUQw4
         mJkGlM8sPbtWCf+da7Jh+QMhfXB3oiO3IwX+9fwS1X7zzd6PquEQPLAul6Z6D2FsdeuH
         O1YzzLW8k2PHAi3uM/cXlCc5b8E7dTrTBvjTkL5DH6rkSScy+NHjgpTDduDeCEmNH+mF
         K/Okj9Ec+GiUjBFew8hgsuz9H4bIcWhcekTwVtjgiLg39+UVOacGwheMLt6SoqfOWwiK
         SluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
        b=nkmdYRT/z2FzGgC1NpvaEff+Sz9QzLgR8/KyArEPodANV6cJo64ayZBWDMsX3yQDQJ
         dLlt+RbDNtZ7Udc/wg74DvxFn/eM5ISkz+OoAEpHorplJ+GShydOj/sQEEYYI2Y4+9iQ
         1wtTR7GWKSDUo4SJ0ynsM+CqlJthkFeXThKJz98Yt7erogVOj+r2KA/DB4vKKW8EIYVU
         8L++KPCcUnD3B9sgQgq9qAcqqDZomdUQuw6HZfDlqbTORPpz1L+U03upbRljTWrDeBG3
         z7Kv9aGGPWeTDQ4Vt86TrdjcdonytHZ2pWcHhbBCrXiTKZH50oyMgXpwBCkp0l6D0+A2
         lDRA==
X-Gm-Message-State: AOAM533ZhWqxU/Pp6+2bHH/p40BDrdnWAbRkRN5iE71xY7gyKOKhnsws
        slosoe9kFgLGb3wt4J6rglQcDezpPDHW
X-Google-Smtp-Source: ABdhPJxc2j/d30LFbliRbem66L7CuOMyzlZyrRGCesZ+JnC9QmoojdAvcyujHgWDyq8CQJl8cLQINmB345v+
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:903:4055:b0:12e:ce88:e896 with SMTP id
 n21-20020a170903405500b0012ece88e896mr4978961pla.21.1629312207724; Wed, 18
 Aug 2021 11:43:27 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:06 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-6-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 05/10] KVM: arm64: selftests: Add basic support to generate delays
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

