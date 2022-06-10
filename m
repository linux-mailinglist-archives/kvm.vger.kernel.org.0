Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2154624C
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346633AbiFJJaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349161AbiFJJaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:30:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF1214AF70
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB50B83326
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485A7C3411F;
        Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853336;
        bh=lgavra4KkfkFNo+v7d2DprVkFjFFaOpmoCafz+YH1JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbvpGPQTIaD4vf1jiaIvVhpP8u/oob0O2eAkfU0mftKaMykbEwb89bQGdxPUa4uU3
         dyPuWxro66M2IIsc6Vpoy4h+4UDxFW7OccNKc09bKZID5wcUBur08QYRVTQAXgO2iY
         bbRzb11b1M4aXs3lCZ3jJWfMMJVSpFaoHVhUm/bgMkIda3cq+bdyQXx7kssthzNLoQ
         /J6S8tCQBxhtIGDq8qca/GnGPpulu1En71mnzMNKhSni37lON8lXG31TRFaTworql9
         f+iHyqo2noat+TSwQs8He5+T8w90o2D2MB6hkBTNTOXfRNJGBbuUrYKXWKfBmTiTPR
         vLyOlRTX/0UqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawo-00H6Dt-6T; Fri, 10 Jun 2022 10:28:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 02/19] KVM: arm64: Always start with clearing SME flag on load
Date:   Fri, 10 Jun 2022 10:28:21 +0100
Message-Id: <20220610092838.1205755-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On each vcpu load, we set the KVM_ARM64_HOST_SME_ENABLED
flag if SME is enabled for EL0 on the host. This is used to
restore the correct state on vpcu put.

However, it appears that nothing ever clears this flag. Once
set, it will stick until the vcpu is destroyed, which has the
potential to spuriously enable SME for userspace. As it turns
out, this is due to the SME code being more or less copied from
SVE, and inheriting the same shortcomings.

We never saw the issue because nothing uses SME, and the amount
of testing is probably still pretty low.

Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running guests")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviwed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220528113829.1043361-3-maz@kernel.org
---
 arch/arm64/kvm/fpsimd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 8267ff4642d3..6012b08ecb14 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -94,6 +94,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 * operations. Do this for ZA as well for now for simplicity.
 	 */
 	if (system_supports_sme()) {
+		vcpu->arch.flags &= ~KVM_ARM64_HOST_SME_ENABLED;
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu->arch.flags |= KVM_ARM64_HOST_SME_ENABLED;
 
-- 
2.34.1

