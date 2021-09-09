Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24984042F9
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349876AbhIIBkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242112AbhIIBkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:40:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A1FC0613A3
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a2585480000b02905937897e3daso436915ybn.2
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=joYYrt7hpuPfUeQcd44dEnmpKJRkC3m+olCPcRklPKY=;
        b=FmT4tXPeRDgw2DsrBZpZGU6PcjTlqMTB9wZqCZm9tFBuL4YGumdgIw8m9nJpGy7K2o
         QYsOw8LRgRYm95W4lSQlPjO7sHUsJHvmCf//Z9HkzC5WFE0ltOxtgtruZBHWU5+lyW8d
         tyISweHmsA2pL8jnZ1XopsISmcAGv1TGUh3i1sOmjVR+89zSpnjVbubTD5YxqU6axujR
         iC5Bo6uEchxMhU7sTZonLg1PKJy5nk4TN+T3O3lRQY+zvf8akm5MfKalvVWOHQh+ZZZh
         xa6NDR8lw9UzwQzVVyNZ4oE7mAM9CccSUMU4oq2kLeew6YO2bKG9NmIZqb2LZBM5sUaT
         cSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=joYYrt7hpuPfUeQcd44dEnmpKJRkC3m+olCPcRklPKY=;
        b=x7Q/gjoaVOtaW8AzbkMLnCdIzWLj6iJgJlkIhaN2U6qUN+aqaUrD02Y+Y05ruOYEzF
         jqjs0KX/zVRzWp4A2wumm4DvgswVmq5/OO9j3wY/sNB7FliI5Hl80odbxPOLEXcKq7RH
         m3zqqlhOaUXm4V8ktwaXcFIKNrliNlmIu8gvVyy3DK/M57jO8AK4R1zSrOSN2qJAXvMO
         /8zJtnAv1ri1JwQsIeyFvMFyu19RWIqE54VqTIUgXmaG/58dlwi1jTbJgZQmBpoOz5uy
         zbtpEPIo9mLYIJWdyJ4kaclWoJGN99tCzadJ5iwA/GZTLm5Jrs+M+2gvYZA8xTgFkqQr
         7ePA==
X-Gm-Message-State: AOAM533k0N/yMjEEvaUAMku5ZCrqQ0U842yqeZSWh/gP59gRdggTgm1T
        e+HSnBVIaGTJKeC1yVBjYSSNSrhZdTee
X-Google-Smtp-Source: ABdhPJwFC/OW1Z5F2EdPKG+1rynUG9GSXEW3pl0UpRo9goR7t0bNT4MLjGR/06vsJCUHuxOMHJCWVlVpiEKi
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:3894:: with SMTP id
 f142mr565481yba.464.1631151524424; Wed, 08 Sep 2021 18:38:44 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:08 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-9-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 08/18] KVM: arm64: selftests: Add support to disable and
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
index 166d273ad715..b6088c3c67a3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -184,4 +184,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.153.gba50c8fa24-goog

