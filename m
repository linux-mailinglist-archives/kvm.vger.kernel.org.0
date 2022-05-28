Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DBF536CB1
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355853AbiE1LuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355438AbiE1LuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F049C10544
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E5D4B826FD
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3F4C34100;
        Sat, 28 May 2022 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738606;
        bh=Ec6u8EQqS5wxvthn3XSyusPvGBwQrVTlwCZ9oXTDvkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0p5wup+2w0opbr/dlcTkosvR5+j8BDyV0JtjQ4fc85x+bvP4gUGl8+a7glZlvrcK
         zaEmLDWKyTWtq73TSRlc4UKwgWef6+0pndxbzzDM9SrEPgbEdB967pz2DnTm5JNczL
         PP6BfPj3CdY63np6MUH61stttsxbuaUOfKsYIAf5ifpiWoGz16c6GZKOzXQ5EHctH+
         q1ujLSo9S4M5rhAw45Y55ZYkS5/bn/dEpYciFq0GjM5fz7R0qrMcR24bAgpLOQQNUM
         GWEDnrDsBK7xfU00/1FZ7prBwYe38yd5Sh40sZCdZkc3C4+ehXZ6AeAccWQCZlF0Q/
         WBPHs06b4ejkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumC-00EEGh-Jj; Sat, 28 May 2022 12:38:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 13/18] KVM: arm64: Kill unused vcpu flags field
Date:   Sat, 28 May 2022 12:38:23 +0100
Message-Id: <20220528113829.1043361-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Horray, we have now sorted all the preexisting flags, and the
'flags' field is now unused. Get rid of it while nobody is
looking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe7e1c44e6e9..d571c9991a11 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -335,9 +335,6 @@ struct kvm_vcpu_arch {
 		FP_STATE_DIRTY_GUEST,
 	} fp_state;
 
-	/* Miscellaneous vcpu state flags */
-	u64 flags;
-
 	/* Configuration flags */
 	u64 cflags;
 
-- 
2.34.1

