Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D44277D264
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbjHOStt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbjHOStQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F412684
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DF5865F69
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E59C433C7;
        Tue, 15 Aug 2023 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125221;
        bh=2MC33VMubl8Wc9QSc0xTB0giIGZo60Zeezs0Qg0LdXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edoi+fZeepxyjeapWBbtnA720RNM/axdOSszV/L3UCZXf3aFzsuK9V3bB7WQNUdAJ
         Q8kBsxZHMw0vmOMSc2jhaTiWhyP5kZQoTIQeAH629aChNdkxDR/Gf0tnICqHOTsyl0
         5J99Hx18ks+7eCfxgzXtLxLmqHKbw1qe1GWXJm60xzyUqKDbQnyeORdwT910v1UNsa
         t4m++3W7GfgXvKVNaeWx6V9ZihtDa5MtEfpChLHMukiAsgbS06l7ENDhA2OvnFoEdJ
         nrFq95Lbz/EqFR2yPvnrJXFok5g3lTMx5zdh4Pz30tZChIRl0KTJwYefDhkqokGBta
         BgrtD5qKvB3dA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywr-0055Sd-Nk;
        Tue, 15 Aug 2023 19:39:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 24/28] KVM: arm64: nv: Expand ERET trap forwarding to handle FGT
Date:   Tue, 15 Aug 2023 19:38:58 +0100
Message-Id: <20230815183903.2735724-25-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

We already handle ERET being trapped from a L1 guest in hyp context.
However, with FGT, we can also have ERET being trapped from L2, and
this needs to be reinjected into L1.

Add the required exception routing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 3b86d534b995..617ae6dea5d5 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -222,7 +222,22 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
 		return kvm_handle_ptrauth(vcpu);
 
-	kvm_emulate_nested_eret(vcpu);
+	/*
+	 * If we got here, two possibilities:
+	 *
+	 * - the guest is in EL2, and we need to fully emulate ERET
+	 *
+	 * - the guest is in EL1, and we need to reinject the
+         *   exception into the L1 hypervisor.
+	 *
+	 * If KVM ever traps ERET for its own use, we'll have to
+	 * revisit this.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		kvm_emulate_nested_eret(vcpu);
+	else
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
 	return 1;
 }
 
-- 
2.34.1

