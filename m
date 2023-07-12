Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B61750C34
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjGLPRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjGLPRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415A1FC3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C19586185F
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 15:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A519C433C9;
        Wed, 12 Jul 2023 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689175043;
        bh=2V0mF+wnt6a7YeHr1SC7Is8uAo/AxpT4iqi4HxUg2rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnPu4pSwuA00WphEIcWSQnQT4rryNGGyIAwJ5e7TjfrlqR0hIGXiQ+Ju0+6xdGPi1
         c2PNNaEsGkfBnUIY9phQs9QoslkXr4D7xqxBRM8aU4NSfMpwI9NE6bwObj98c6JCEw
         Kd8lOZBRiqjotbwvNDs1+eFMbzvfo35VCxIIHRsp0JIl8fkMks57rmp1J0sqkiqFuB
         T6vFOSICC4DitF2Y8bFxfYyydpZRCz5ed3o4RADnFtbTWY7ZucBcwcPhkiJ9uDT1gj
         I+7NBvf7gyImPv4sivNWH5lYtLf3oc++rHziqbDUoS6Ct8rZ+IlOZvmc03bN6st8l5
         cMaUzRrGdat8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIr-00CUNF-TA;
        Wed, 12 Jul 2023 15:58:53 +0100
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
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 23/27] KVM: arm64: nv: Add SVC trap forwarding
Date:   Wed, 12 Jul 2023 15:58:06 +0100
Message-Id: <20230712145810.3864793-24-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
traps to be forwarded. Take this opportunity to deny any 32bit activity
when NV is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c         |  4 ++++
 arch/arm64/kvm/handle_exit.c | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..f876e1bbaad2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -36,6 +36,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
@@ -811,6 +812,9 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
 
+	if (vcpu_has_nv(vcpu))
+		return true;
+
 	return !kvm_supports_32bit_el0();
 }
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6dcd6604b6bc..3b86d534b995 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -226,6 +226,17 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_svc(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * So far, SVC traps only for NV via HFGITR_EL2. A SVC from a
+	 * 32bit guest would be caught by vpcu_mode_is_bad_32bit(), so
+	 * we should only have to deal with a 64 bit exception.
+	 */
+	kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -239,6 +250,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
+	[ESR_ELx_EC_SVC64]	= handle_svc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
-- 
2.34.1

