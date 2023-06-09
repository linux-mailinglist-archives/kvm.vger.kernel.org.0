Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7842672A019
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbjFIQWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjFIQWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62F22D44
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCDA659E5
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E5FC433AE;
        Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686327731;
        bh=PWi6LY8XpJQzudXyIWXRXdjw/fgswuqZz0wPMwkGK68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/0Rf2wHBnIwMtjD2MpgEMHhwaejFyC2B7sotvaATGgppNBY4meIlU2O2x4FKvDbG
         PNzGYvj31IfT5hdTOMe+Te6Im1xjOtKD4mmImOKeL+RpEFrOwpjhlxtZKAcbk3tLNc
         1BZ/O37kHq8ikOLKR7T4G3MIIVwOoQA46IOvkl4v9qnhYnDK+uSgkWMievn1bDKEqO
         mbUUIPyI5g1rVOTt8eI4fqeEd4adLUuug7Wfew6SQWsclSjrqRNL4s4qnGAyNT3w7C
         xtW/i/ANTav410IedHLbEFp+/Tv1lBzHkV7FCHKURWtzFi53Q1US9vjpJ/lSjE0SLc
         x00PscsI3UJkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esL-0048L7-TF;
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
Subject: [PATCH v3 07/17] arm64: Use CPACR_EL1 format to set CPTR_EL2 when E2H is set
Date:   Fri,  9 Jun 2023 17:21:50 +0100
Message-Id: <20230609162200.2024064-8-maz@kernel.org>
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

When HCR_EL2.E2H is set, the CPTR_EL2 register takes the CPACR_EL1
format. Yes, this is good fun.

Hack the bits of startup code that assume E2H=0 while setting up
CPTR_EL2 to make them grok the CPTR_EL1 format.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 225bf1f2514d..bba508ffa12d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -129,8 +129,15 @@
 .endm
 
 /* Coprocessor traps */
-.macro __init_el2_nvhe_cptr
+.macro __init_el2_cptr
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .LnVHE_\@
+	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
+	b	.Lset_cptr_\@
+.LnVHE_\@:
 	mov	x0, #0x33ff
+.Lset_cptr_\@:
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
 .endm
 
@@ -196,7 +203,7 @@
 	__init_el2_gicv3
 	__init_el2_hstr
 	__init_el2_nvhe_idregs
-	__init_el2_nvhe_cptr
+	__init_el2_cptr
 	__init_el2_fgt
 	__init_el2_nvhe_prepare_eret
 .endm
@@ -244,7 +251,17 @@
 
 .Linit_sve_\@:	/* SVE register access */
 	mrs	x0, cptr_el2			// Disable SVE traps
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .Lcptr_nvhe_\@
+
+	// VHE case
+	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
+	b	.Lset_cptr_\@
+
+.Lcptr_nvhe_\@: // nVHE case
 	bic	x0, x0, #CPTR_EL2_TZ
+.Lset_cptr_\@:
 	msr	cptr_el2, x0
 	isb
 	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
-- 
2.34.1

