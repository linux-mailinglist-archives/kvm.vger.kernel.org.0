Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88C7A8B7D
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjITSRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjITSRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0930DD9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7DC433CD;
        Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233860;
        bh=OvTnh8UHlSYCCG4Btbi7L6uQqPfkzFjL8On87GirJBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBA/WMH2f0BrCPdItWtCNO2MiygAFYVeUtaNjx8o7exjoh5T/eOv7/6F4sMJM/opJ
         FIHXNCXzQsbqT8Ea78BnWU3kCdORaVSkHGVFhadcN+rE4b3LEBhWM8ewcU0LyvWni3
         3U0sAW7yM0U3cpZOHMNqQpeiblO4fSG1rtD6WQSpl3y8LpJIRHeyQHuxCgXCjjGYyb
         MXJjohFI14tPik1Dsktte1HuLAtWXa6sXFl0H60+fOA/h/CLAEs5aGOoT3ZBvIymcJ
         iBKDaWeNzdky3AyA9oGYXoabpOBm9v2bBV2uqlcuhk79FmcCmxZshayXCwuwXDKMCQ
         vp6+Q6pyNd/qQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1lZ-00Ejx0-VB;
        Wed, 20 Sep 2023 19:17:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
Date:   Wed, 20 Sep 2023 19:17:25 +0100
Message-Id: <20230920181731.2232453-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 07aa0437125a..85606a531dc3 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -166,7 +166,7 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 
 	if (vcpu) {
 		hdr = "VCPU";
-		id = vcpu->vcpu_id;
+		id = vcpu->vcpu_idx;
 	}
 
 	seq_printf(s, "\n");
@@ -212,7 +212,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		      "     %2d "
 		      "\n",
 			type, irq->intid,
-			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
+			(irq->target_vcpu) ? irq->target_vcpu->vcpu_idx : -1,
 			pending,
 			irq->line_level,
 			irq->active,
@@ -224,7 +224,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 			irq->mpidr,
 			irq->source,
 			irq->priority,
-			(irq->vcpu) ? irq->vcpu->vcpu_id : -1);
+			(irq->vcpu) ? irq->vcpu->vcpu_idx : -1);
 }
 
 static int vgic_debug_show(struct seq_file *s, void *v)
-- 
2.34.1

