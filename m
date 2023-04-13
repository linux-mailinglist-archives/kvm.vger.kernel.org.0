Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1F6E08B7
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjDMIPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDMIOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B817280
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 01:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82255619C8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 08:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5BAC433A4;
        Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681373690;
        bh=7qnkNmJS0ToXyCyI12hfVyjIDL/S30SFTMaAUyF2mro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUsyRlmAM03XgN2X17YGQhBcnnLRDEztDAwGDKjrnXav8g+6neDN6PfqeV6XjwpVM
         +fg/c8ShyDDbr9mdyev5/xiZgOKkPAmVbx6rF9PPydWIapl3DPVAtTzw54BK5BI+CQ
         /ufrgVYK+BgF5lQ9PCZX7ngXKxOMwsxWLTxyqjQsi7vz7D+EDNjtytWcs2Zb6QVZyh
         +KLD5SBP+s5RBsxWbd8k1pMMjywrR4l6L+Jx23T2acoiGd49LQxwtZUrShmOH25uC2
         yJpaYBShbJR7j52zsuqjO+ybhIiiuQ7iuyp5QXzIIdeZy4Mqc4AqZtZJMuE77ZMcAm
         ImCNR+X6zDXdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pms6T-0082qd-3f;
        Thu, 13 Apr 2023 09:14:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 4/5] KVM: arm64: vhe: Synchronise with page table walker on MMU update
Date:   Thu, 13 Apr 2023 09:14:40 +0100
Message-Id: <20230413081441.165134-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081441.165134-1-maz@kernel.org>
References: <20230413081441.165134-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Contrary to nVHE, VHE is a lot easier when it comes to dealing
with speculative page table walks started at EL1. As we only change
EL1&0 translation regime when context-switching, we already benefit
from the effect of the DSB that sits in the context switch code.

We only need to take care of it in the NV case, where we can
flip between between two EL1 contexts (one of them being the virtual
EL2) without a context switch.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 7b44f6b3b547..b35a178e7e0d 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 /*
  * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
@@ -69,6 +70,17 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
 
+	/*
+	 * When running a normal EL1 guest, we only load a new vcpu
+	 * after a context switch, which imvolves a DSB, so all
+	 * speculative EL1&0 walks will have already completed.
+	 * If running NV, the vcpu may transition between vEL1 and
+	 * vEL2 without a context switch, so make sure we complete
+	 * those walks before loading a new context.
+	 */
+	if (vcpu_has_nv(vcpu))
+		dsb(nsh);
+
 	/*
 	 * Load guest EL1 and user state
 	 *
-- 
2.34.1

