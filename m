Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E061703EBE
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 22:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245292AbjEOUqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 16:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242842AbjEOUqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 16:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD99AD13
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 13:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 500536325C
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A951AC4339B;
        Mon, 15 May 2023 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684183566;
        bh=fxToMJPXBRwBImuWVs5OjxsfYe0QdWmMyVn4i/4v4BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5G04jrCHJKBpu/EONUAdL8S1KrONbGXuhaWrZ6bwd674MNCf8TlMAAXFUQbWvSsq
         /mHiP1E5YCWaTYPvJfQK+icVi1uKpPYRalw0NNRXWCgX3zXtH/utHlBQx2SBqTYkh8
         v1RRn/WG8j8AWW5Kpz45ql/hOgCyTAFTmnpbDhzGw9VzbZXq7YI1/M0ZpmaQTZn1cC
         PSG0dD6lBOAR0uU1f0FZJgB3myKNi0dkqRY363jbz/nX781n8qQjUusJ+GpGxGHZhS
         0Okf+z/L9OfpFBFQHWYQtwENi1J8DT+RNHF7qMO3WOKk7TPJp7uJTfOwAyZoM7OoKU
         yv/P7ZeZvmM6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyf52-00FM0a-PL;
        Mon, 15 May 2023 21:46:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Handle trap of tagged Set/Way CMOs
Date:   Mon, 15 May 2023 21:46:01 +0100
Message-Id: <20230515204601.1270428-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
References: <20230515204601.1270428-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, steven.price@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We appear to have missed the Set/Way CMOs when adding MTE support.
Not that we really expect anyone to use them, but you never know
what stupidity some people can come up with...

Treat these mostly like we deal with the classic S/W CMOs, only
with an additional check that MTE really is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..753aa7418149 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -211,6 +211,19 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_dcgsw(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (!kvm_has_mte(vcpu->kvm)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	/* Treat MTE S/W ops as we treat the classic ones: with contempt */
+	return access_dcsw(vcpu, p, r);
+}
+
 static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
 {
 	switch (r->aarch32_map) {
@@ -1756,8 +1769,14 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
 
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
-- 
2.34.1

