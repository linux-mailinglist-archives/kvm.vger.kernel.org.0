Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ADD426089
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 01:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbhJGXhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 19:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241753AbhJGXg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 19:36:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640B7C061570
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 16:35:05 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso563971pgi.21
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 16:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zdzYxOXw6HRBi/j9Q4Djh6DlKsT7KOqy9GkRVsRm4i4=;
        b=PvCCl4ZEQDsLP+V4LSuwH3sCogQbp1B9/TjEPTV8Nu5kiq6lYaDWIAyAbL60TcCriO
         TvK03v2M+Fk6kFFH8ucJeeM6OQTB1aTWP1gmvUqjbGltaij4+2MAeHFGuX4HCenQLwzT
         nNb/riJFKx1B2mLcVjIq+qwj1R8H7LegcugghClZjUKpaskRXhrO4DA6ZdCJfuB/XTnL
         62oIU8it2w+FC9kvR7JrAZq4iWZLeYlkl7mTVgjJLhcU+nP2uohiXmICjub5LWvb1ad8
         TRrchyPGubtZPJSPWL/JIdDssStNCNcvQo8H2EqT/ReRwJw2ZJutddbBu7KoJPNit/CD
         +M+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zdzYxOXw6HRBi/j9Q4Djh6DlKsT7KOqy9GkRVsRm4i4=;
        b=IteT4L8oNwNkQyPXC6U1xcAEM8cDMwHcIq+WlcQwEt1q1IHA571jq8zk41wA4BYZO/
         6WN+bxfQ8IIm1DWJ8Kn9B1jezjVrTTlck5mCepzPwgKSCpqeciU/sDDtRI4tk5FA/kDI
         iPEVx1Gi+y1ybDa+K0sCrRammHzmSwqYDWj51au4Z/iSIjmEz4Xqa9SQn37iTo8qjUoR
         4rwmrCAA03a6auxJK3ywJPME/d97MQOohHdT9qNHeL712jdPskcBs6uPs3o7tfTReAQW
         ssJlwz4G9B7KARDXNyNL/GPjpN9JCAeXmTLOS5+m05CFiV74oHU5atrcFsU7S24rzE2D
         uE3Q==
X-Gm-Message-State: AOAM5332uwrC7H8uUkDjpi7+tghsVYyVxLuwKcE89A+yTRdR7F3MkMsO
        NY8ZMzCKRw04VNYJVBsE4td/KTtJZLna
X-Google-Smtp-Source: ABdhPJyilhCRZk0a0SoW62S+ez80OkitwK2J0PNfM9M/q/wH8V2CCWfESNfQOqN3LyPJYXZ7p4mJxSOzXVdc
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b093:b029:12c:843:b55a with SMTP
 id p19-20020a170902b093b029012c0843b55amr6613361plr.83.1633649704900; Thu, 07
 Oct 2021 16:35:04 -0700 (PDT)
Date:   Thu,  7 Oct 2021 23:34:31 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-8-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 07/15] KVM: arm64: selftests: Add basic support to generate delays
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
2.33.0.882.g93a45727a2-goog

