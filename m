Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F4546298
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348347AbiFJJf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344120AbiFJJft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513C819C29
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9BB761ED8
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0240CC3411F;
        Fri, 10 Jun 2022 09:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853747;
        bh=jbtE45MUd9nV3Z8bCfIwAlBr4MHgnoXHgJYkftSo/C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKAcBUiCi9RuFk/2o3s3Ps+lQakp9/48ct98m/wo+f7BtpDRh68/deXDut0DsYAHO
         9CJe/93aiVcWbxISacI0S8Zuod1Pf+XVx2bCIxvh7MrJqg+rVJSV8AZ0MzO4BMqFOv
         1qW2lmA5txHwbwnbDKNYLS00Ujzy2CirT/cJrtRF1u9anrKzkTRbNpi/MCG7eQzaWP
         Z5v/AB1Dr82z2mWg+X8ZZDK8Bhaf7If80m8sczFkBzKt4QK9yX9nYRGahIvH3BoYWg
         nBn+LEme0jnc/CrSq2tY1xqguPpAUqFZ95O/giK56DDWgSH3IkxGBqOVwi9dNhOTHO
         7wKb9DebkwUfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawr-00H6Dt-V4; Fri, 10 Jun 2022 10:28:58 +0100
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
Subject: [PATCH v2 17/19] KVM: arm64: Reduce the size of the vcpu flag members
Date:   Fri, 10 Jun 2022 10:28:36 +0100
Message-Id: <20220610092838.1205755-18-maz@kernel.org>
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

Now that we can detect flags overflowing their container, reduce
the size of all flag set members in the vcpu struct, turning them
into 8bit quantities.

Even with the FP state enum occupying 32bit, the whole of the state
that was represented by flags is smaller by one byte. Profit!

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6a37018f40b7..c6975ecf5a5f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -333,13 +333,13 @@ struct kvm_vcpu_arch {
 	} fp_state;
 
 	/* Configuration flags, set once and for all before the vcpu can run */
-	u64 cflags;
+	u8 cflags;
 
 	/* Input flags to the hypervisor code, potentially cleared after use */
-	u64 iflags;
+	u8 iflags;
 
 	/* State flags for kernel bookkeeping, unused by the hypervisor code */
-	u64 sflags;
+	u8 sflags;
 
 	/*
 	 * We maintain more than a single set of debug registers to support
-- 
2.34.1

