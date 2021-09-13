Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E969409E82
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348287AbhIMUwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348250AbhIMUvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:51:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C150C0613E1
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:50:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k15-20020a25240f000000b0059efafc5a58so14552092ybk.11
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
        b=dkwAaN+LMm6q6/tB7urEEM/7txHMfCp1yhEmH8oTSSC5G1JbBVb95On7HExWMTLTlN
         3cXIoUFeGGMdfRQC4MNL7aP9VmrS4Fe+eHCP7yUL3arzSTlYuO8akfR5jS0vUHa7XXNA
         3OI8KyIk+mslCm7yPV1vhpfiA/Ba9h1lX5egHL2gxptQ2ch9lVlH+5iOx9HcJANmNn32
         rjz3vqIGy74jr984zD9uo9pXVr1CgydnPYgm1WnRKZ3FbdPGQyp5KCekA4D+3BtGI81G
         d6f8N2lvxT7WcHx/Otrt+PGPOnGMo6ISulk/Xzs+W71PNknHOah1LkDcX/gX9orguSK4
         vHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
        b=Jp4idTBftHsro2QY3geIOQFSBl0NClVBF26zShwD9Ym1Ibq5VsNhAUYmSbAHPd0+ZN
         6QKvB11rrmrNkpmYfbbh0XObjNcLOl9KoCFAf40h2hVRRw1uDPvGLHOESIMNyLGvVHNg
         3AvPlUkED/RjBEvOAER0D/2P1It8GL/q+N/m5/f6xXWhWwGJT6HrkzMy8UC4g/zBcsJA
         WKCGMFqg1BecmIHP7co9cRxyd2MSR8/t/IJ+b/HRNleRLf7z8MhO9x5QaUglE8CFwSjV
         uWGfR+9yV+zthwFxNlDFXUIWx7BiBV0UQ99ExyzxGNb+v8YKec4zLe+1XKZ45OVLXbG9
         yysQ==
X-Gm-Message-State: AOAM530zZWa3u55y8uaDqiLUiC6KKRqyzQ9DhjzXsRLr7LlbwIsaUn7l
        q4PBRO9rffPNt7hHm2Jh6/rgNYtIh8V4
X-Google-Smtp-Source: ABdhPJx7o2pSPQVSa/VQZq1XUtFrn7ZyngcYvhLBDeiBG0SA9xzMD53Z15pr27SHTsOPEN6MGy9A8rGlE4Tx
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:7146:: with SMTP id
 m67mr18421920ybc.353.1631566200594; Mon, 13 Sep 2021 13:50:00 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:24 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-9-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 08/14] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 265054c24481..515d04a3c27d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -172,4 +172,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
+static inline void local_irq_enable(void)
+{
+	asm volatile("msr daifclr, #3" : : : "memory");
+}
+
+static inline void local_irq_disable(void)
+{
+	asm volatile("msr daifset, #3" : : : "memory");
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.309.g3052b89438-goog

