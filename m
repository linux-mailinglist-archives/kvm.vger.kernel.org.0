Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E0D52D4D8
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiESNrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiESNqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F5D1ADA8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B72BFB8235B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E8FC385B8;
        Thu, 19 May 2022 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967971;
        bh=gNfFOi6pd5y/KMC1EENc0l08zoMIj4rMl1P1lAcHzmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6nFRAbTKYWiGRYq2O+qFR9S7ODm9TBeMw0yMLdLvLR/o74yXsoLWW4DrFBKaSsT1
         0vsUeJ2J5x3lKmZDM3DzioeP03cx9RPsw4ayjkiazraeWQUPpTssdRZoZkAnQWplWJ
         IGrc6LSRZSXv6xum3n3ZBXvddcMIRhK6yXDbCbKEyRoCNwR5xwfMMYElYbbIiKW4DE
         aGwDDY8rDzdvBJ+hPY3BBZJq2fiIDkR1n0vaS7ObwSB1jFR3ViSsYmzo0ISSwIhX+w
         h96nvNClKHlT7x0CSd29JeyzM5Jai4cwvnVa7Zbc1hfw6O94eQP+YNvqmR0BHHfEC/
         lCuQ55bVYcFsw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 57/89] KVM: arm64: Trap debug break and watch from guest
Date:   Thu, 19 May 2022 14:41:32 +0100
Message-Id: <20220519134204.5379-58-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index c0403416ce1d..cd0712e13ab0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -108,7 +108,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 
 	/* Trap Debug */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), feature_ids))
-		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
 	/* Trap OS Double Lock */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), feature_ids))
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index ddea42d7baf9..e732826f9624 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -356,6 +356,17 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
+
+	/* Group 1 ID registers */
+	RAZ_WI(SYS_REVIDR_EL1),
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-- 
2.36.1.124.g0e6072fb45-goog

