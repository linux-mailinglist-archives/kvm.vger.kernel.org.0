Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAACE3EBDC4
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhHMVNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhHMVNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:09 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C02C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:42 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id n14-20020a0c9d4e0000b0290354a5f8c800so8040710qvf.17
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
        b=r0k0+ikMP+nOEPjnHb3kh0VDZqt0D+H2nuLUBq14wDIIrLdIEvXnBOSas2Lnh/OyL4
         CXCi+1wjWGm+uuzR/+F4+YThArIna/irnOVVvryV+4tMHygQrOUqPqZi8WdxKxJCssC3
         GGElclHOo5x66fTisjkXmEvYKFvnK4UYX2rmblaHoaGqTnyhSr03Ife5Q1WvN/6wBlD4
         OT8YA8Le1w4fIoD/xTImcX8RrfIzUdwICHA6GscI1DM5iBC0lySuSVTjLB24pJz5dVcL
         zlwSYVMEvXdGNUEMSQLHiOeOEvpDdtEH8bg+WJBxGKBxUetDL3jnYAt9sBdzbaWmG3IB
         xXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
        b=HPTzNOufZiLYa2Q8LBzY8KItSpG6CAcyos7Zu7oG27UePqRbySO11MRKUdxtXL5ZCo
         KUrts94NGW6fQtXbu8Ad1jyQFnNaWsi0UoNdUZDMiU1K3JfUfm33DPUltZccxoGHMLtU
         WPEylkTJxSlLDe1N3kpbocA9T1a3vO8zT5X+q0SxIVYboP7U26Jb37rrLoJjMsE71lFk
         HHMn2kYlvqeIpu95+uxZtV56akH5LJzQ+ZD4RSqrSb4xV8cyPI4QcIxn6Bhb9R2PZEuy
         mPenT/9lnnJqktMSqvITOMCsJmZKPFpau/39hGHnsgaiVQHnN7ADhAlhrPft1ra0LJ5m
         wcDQ==
X-Gm-Message-State: AOAM530bPl/sG8FbKsAa14p5EOpbqrZ2Fd7YkQKsm6Qm7XJ7DSxpEVxu
        T6dk8CB+TI61FK9H1RqiPn6pV56yvcCZ
X-Google-Smtp-Source: ABdhPJxjPFd/WGD8GEReOFcK3uuVRxEQIBB7zBhKOuKFdJXYU7cQwfdP28cvL37njnXSkd6SSW2+Pj0+Dz7M
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:ca2:: with SMTP id
 s2mr4551920qvs.35.1628889161419; Fri, 13 Aug 2021 14:12:41 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:07 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-7-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 06/10] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c83ff99282ed..ae7a079ae180 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -238,4 +238,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.rc1.237.g0d66db33f3-goog

