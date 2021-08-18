Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC53F0B34
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhHRSoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhHRSoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E875C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e10-20020a17090301ca00b0012dd6a04c04so775410plh.10
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
        b=D8RHHn21WpX7lOwcIGclpa5kQE9RPrULMWoIr/pvS4NpZo0Om1eqeAlu1PRP1P1eUF
         IdyNGXYQlZoDhrnT3JirR7kCp1sfABUN3wP8ISx+/rHQNa/uaYACjvTkMJcse4rGqVlz
         XBnxDwirlSF4VOhIF/5nBLRWCCTw+r4O15fySStZfB+TkB7wprD5I4OlSun+ipBQweza
         scQJh4Nv3ll/qCJW/B2bso3VW59XorbpEscb4i/A0aKU5v/j81XzbvdWK1xd2FNCXBNU
         Hf5rPzbe/jNV39F4/ok6ZZoZoEzVv1ekZWY/46D5H2j638X6BySeNRbZJFoT54/mOoUr
         +TGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
        b=O3KEHLasVozbaDx1CFSoVjPJD6iBBH+Fy+n4lbsCD5LNLy7eAyNZ+2nS8WA7mwI+Uw
         k0x8/NYT1DCtCrCvdh9Vm26fkBKGTpH2AR0+Rv4I03PvMz+SvaP512kjF8W0hanrcRSs
         WerJLd8rTlz1MCaAnsaiaxNGXNJOQ1Ag2t5F7eAfq7hoJXeUE6nI61Xc389p091SJ1Yj
         BnEC58ZGBL9Bz1YloR5JSm7piI0FszO4F1+p4am1H58pKTRfd2tz7dN8rcIRrvaYpAJN
         DFyUMpU1X5a/H6E0E/RFP3XCRweTte0G22BXfqNlA6awk+7GIzo77eUVk78nofxi4OSQ
         5lRw==
X-Gm-Message-State: AOAM530DERm1XBo2K/n5wMdqAaAHc2pWn+GhejCpUcpkteQkG1T6PAag
        AYhVdCYVOr+DXX4ZUYcD211lZRcns+q+
X-Google-Smtp-Source: ABdhPJxNdjQSpOttv8J6ZV+X+0iEAxdfgHwp5u0JVDm7jCBLggrHgvVi0/5rLv6kFjQEQdwhUcVWtBV59Aca
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:43a7:: with SMTP id
 r36mr91749pjg.1.1629312212315; Wed, 18 Aug 2021 11:43:32 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:08 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-8-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 07/10] KVM: arm64: selftests: Add support to get the vcpuid
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

