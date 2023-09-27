Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A857AFF7B
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjI0JJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjI0JJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517B3DE
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91DAC433CC;
        Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805759;
        bh=SukBelkNld/+KfqGlJLCx5XPqjafNh6F4NcPqIZXwU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rghtXBWVKJRbpfGhFi8TLYbKl0gGAIJLlH1aDbrapIl/9QI2mOKO9Y3jVF6wAlVwm
         brFbg/PHCy8mTmJiTms0x38JG+GNhWb9VWkSTrjH+0zpMLnZ+Hb3j91xYt9expM+Rd
         cCGjgQb1YXBB6VWw/SxKxtav3duiFtp3LmrEoUN9oGIcdXK60dmctkVOLClbqyrqyA
         CtuCJwa6BBundM4TI6fVxCsNa5lNoxBxtWZZRpubOOuSxr8w07AL7tCHqKsjPNMi49
         r8ukiv1npMIHxPPXLdRIsVn0OQWFql/sDs3fN4pwy6Hl3HmgEHFv2Xmh2vqOtlHIs4
         80W0JbWIZpdPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXl-00GaLb-Cp;
        Wed, 27 Sep 2023 10:09:17 +0100
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
Subject: [PATCH v3 05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
Date:   Wed, 27 Sep 2023 10:09:05 +0100
Message-Id: <20230927090911.3355209-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
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

When dumping the debug information, use vcpu_idx instead of vcpu_id,
as this is independent of any userspace influence.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
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

