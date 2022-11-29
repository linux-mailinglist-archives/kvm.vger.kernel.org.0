Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8AB63C832
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiK2TVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbiK2TU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:20:56 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0756E544;
        Tue, 29 Nov 2022 11:20:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669749605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laDyv7YUrXbfqGAwMagZdnkFS+VaAukLw7cc05haSWA=;
        b=UdwE2yD+Xreg9YPfNtiPciJasEmnad33G1DHyWSBDA7LwaT7n3KiwnnNO9bOgfsuBoI54F
        tbwcE9gGmZR/9cDmZ4YCQnOunSbgBloPF44HFlAEaw3Wbv927EOOsrVHVQZJ6abGcSkfq1
        IGTSDogzwposXRkOGXjkbNu+97c6p1U=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: arm64: Condition HW AF updates on config option
Date:   Tue, 29 Nov 2022 19:19:46 +0000
Message-Id: <20221129191946.1735662-5-oliver.upton@linux.dev>
In-Reply-To: <20221129191946.1735662-1-oliver.upton@linux.dev>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As it currently stands, KVM makes use of FEAT_HAFDBS unconditionally.
Use of the feature in the rest of the kernel is guarded by an associated
Kconfig option.

Align KVM with the rest of the kernel and only enable VTCR_HA when
ARM64_HW_AFDBM is enabled. This can be helpful for testing changes to
the stage-2 access fault path on Armv8.1+ implementations.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1a3dd9774707..9c651b6d4092 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -584,12 +584,14 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 		lvls = 2;
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
+#ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
 	 * on all CPUs. The features is RES0 on CPUs without the support
 	 * and must be ignored by the CPUs.
 	 */
 	vtcr |= VTCR_EL2_HA;
+#endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
-- 
2.38.1.584.g0f3c55d4c2-goog

