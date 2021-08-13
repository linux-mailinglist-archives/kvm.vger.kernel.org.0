Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB243EBDC5
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhHMVNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbhHMVNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550EDC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u12-20020a170902e80c00b0012da2362222so394486plg.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
        b=MhG5TU2H2ct2ePotEwsSicyPDViGj0p0dNgvzvpHXfmVNKqBmc1ZjQmPtVVAonuJde
         BU+CeTRJkh0LBh+ubPpNFVTSxgKARa20AUTl8UQiMdHKXlAEYg7RnMQBmXry/Jq7tX6E
         HyjPLsCcwyg3Zm1H7xPkB/no+Ap0vtPMhCs6M7l5NmkCSDM3W+D9gq/VGH4//+udAhr5
         ZNR5VqLEllVpwMz9aoouLjSaz6VtfrwP4iv5p7fAAyZO0G3qasezZh7DVxHXqG67ICIg
         Q3oz6prc8gemBfCQX6JsypAqCGtUl0xbSekKnIyYMTtb6sBPimMXP1uueLUXJ7ixrNba
         liOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
        b=uF1ukMRsnn0ryEk9vm6r0VOR9+ounRRw4nZX7GAe+cecAZ5fxH1FKjHkXRi6ZASDVL
         bZT5I5F3Vk6TdHPTXEQ58gUdAj9TeUFXSnoYuyP99JlecoaiYKbrf0nuHbHPplMg16vQ
         6GMmlgtRdejnREYOezUezaaluz86qK0O7Glz6FCG91OXUc5ddL0GmYX3SBq+expUuFIA
         Qb/sSeX4UtrZNBaNH4MmNrLjtXYHEaAndAM9N/N+GzzAYI940jYI7/m+lcaXR/jqsGj1
         l6R/3wCpJiajH/oHdyfyGIJFDg4BhYXCuuCnXC3FsKuv2nFbQPwGUyCecSehwQVf9Utl
         9LPw==
X-Gm-Message-State: AOAM530zd/IvR/TnsGxFf4ps/ylNwNYMhhYIJ/f9RF2GA0yrq8k+gn8+
        VzSOjGi0qDyLGpwTz7+zpzSRhzh4yzJN
X-Google-Smtp-Source: ABdhPJwH9oPaXtIBXMnqXUclGdeHpy/TJgguUlPX0A6ayjUbxiIAsAwI3OwGGCxv8ROPipGomDhawmTskznH
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:de16:: with SMTP id
 m22mr4506677pjv.54.1628889163792; Fri, 13 Aug 2021 14:12:43 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:08 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-8-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 07/10] KVM: arm64: selftests: Add support to get the vcpuid
 from MPIDR_EL1
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

At times, such as when in the interrupt handler, the guest wants to
get the vCPU-id that it's running on. As a result, introduce
get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
requested caller.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index ae7a079ae180..e9342e63d05d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -248,4 +248,23 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+#define MPIDR_LEVEL_BITS 8
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
+#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
+
+static inline uint32_t get_vcpuid(void)
+{
+	uint32_t vcpuid = 0;
+	uint64_t mpidr = read_sysreg(mpidr_el1);
+
+	/* KVM limits only 16 vCPUs at level 0 */
+	vcpuid = mpidr & 0x0f;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
+
+	return vcpuid;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

