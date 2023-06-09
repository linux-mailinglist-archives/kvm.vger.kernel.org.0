Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0CD72A014
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242162AbjFIQWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241521AbjFIQWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A95735BC
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A59659D9
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABF3C433AC;
        Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686327731;
        bh=Eb4P+yvkDgqtafWekJ5k0MGdRtAE8LRnoYczU5+CLgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWnRHMbefvmhHYGW/2HagmMXu27fXUKULiLdpB85Qp8+WNyJGmaXjNGC4o2J9E8wq
         696sexaLxFhdIUQqn7Pc409FvCzdkrTOIodu9U55hgxkl78w94fahmlSwOA0vSSH3/
         A5lBUYYWLp2uO9dZenLJORUOW/Is+gHIaIhEz09HmKmiT8pSPULITNKLbpzveovh9y
         eCdj48V4UEUK45dNyqDUZdSzs62Poh2JMF8HxO/Rfew/TL+R4yrnHDbNs1QV0vLZhE
         qznr5YXPK0CezsHt4JBWyCLJO5b/Xp4eWl2q5dUl+boGXRyEJElbWcBT1vFGEQcx9I
         /NzPaaSMI80Pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esL-0048L7-GX;
        Fri, 09 Jun 2023 17:22:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 05/17] arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
Date:   Fri,  9 Jun 2023 17:21:48 +0100
Message-Id: <20230609162200.2024064-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the OVERRIDE_HVHE SW override is set (as a precursor of
the KVM_HVHE capability), do not enable VHE for the kernel
and drop to EL1 as if VHE was either disabled or unavailable.

Further changes will enable VHE at EL2 only, with the kernel
still running at EL1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 9439240c3fcf..5c71e1019545 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	tbnz	x1, #0, 1f
 
 	// Needs to be VHE capable, obviously
-	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
+	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
+
+0:	// Check whether we only want the hypervisor to run VHE, not the kernel
+	adr_l	x1, arm64_sw_feature_override
+	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
+	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
+	and	x2, x2, x1
+	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
+	cbz	x2, 2f
 
 1:	mov_q	x0, HVC_STUB_ERR
 	eret
-- 
2.34.1

