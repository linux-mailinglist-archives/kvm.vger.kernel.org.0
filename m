Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468DC605AA5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiJTJHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiJTJHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F0219C061
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1DBC7CE24E6
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EAAC43141;
        Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256857;
        bh=ganBQ4L/dvVMWO5OFk6Mq4WiwjzqiqwYGyYnNy84GgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSBgjhG9z5iCoFua1qGliENNg7Tv5zYXf0LRE3jFYF1/165HMX9XCyrMBUZJE1Jko
         iavc13BmIn62XOQ2UfU3Pcw9HlAC1K12pc1/F37aVgRQeJD+3syEqDG5xnu/z6mGkY
         a465yJsKdQlO832qgAMlQsJ1aC/KZLVPb7Ren2d2oyD7myPwoX3psEMhKg54IbvgtF
         44110184sqT1ZgS4eh28xHFAqPSfZK/98b1z7YLdh83uNfYjOWfokYDTAZcj/klXLT
         eevYHKrvBmcURH9ZveBIwDYccdhuwosHiI+mA/ioACoPq0U3wg0zea8GsaT5QgI1/j
         pSVZGjqcY8Dgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWZ-000Buf-Ag;
        Thu, 20 Oct 2022 10:07:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 03/17] arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
Date:   Thu, 20 Oct 2022 10:07:13 +0100
Message-Id: <20221020090727.3669908-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 2ee18c860f2a..0601cc9592bd 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -157,7 +157,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	tbnz	x1, #0, 1f
 
 	// Needs to be VHE capable, obviously
-	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f
+	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f
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

