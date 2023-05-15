Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E766703A61
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbjEORuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244725AbjEORua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E69DD83
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C4062F39
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A3C433EF;
        Mon, 15 May 2023 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172905;
        bh=i362DZ3h2u+AfxyIjFns+AqkAhvdt9zkDqgn13AeCFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPD9h4s5eF+ZWozjazOo295f7MyK9OuJnNNa28pv3WHgx4tQp3aL55GQCBqYYCbwV
         4xNQ9UGx294Yx8ruj0bQ0DMobJ+OlTbBgPJ4LdVplcQFiinDpqzkavpkttIYOfhlqf
         E68n8Y0JxB0n1TOOhOey1Sqz0wCStpiA7pdsB2qKxksjm/o0dHY+7qBUbQXflyeEO0
         2BZjqQnGmja1eWaJOBsAbT3uCOU8oHzlXOZ76xZKVPzuO+QarZeO5ZdgdNokTKCFo1
         mD8O0yCHhiHYgpHA7TY6rDPhkSreoLH++g6FMrF5eZYPa+dgUI/w52GBAKKZcrfdZY
         +4FvUi1OC5HxA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc3A-00FJAF-Sb;
        Mon, 15 May 2023 18:31:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 55/59] KVM: arm64: nv: Enable ARMv8.4-NV support
Date:   Mon, 15 May 2023 18:30:59 +0100
Message-Id: <20230515173103.1017669-56-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As all the VNCR-capable system registers are nicely separated
from the rest of the crowd, let's set HCR_EL2.NV2 on and let
the ball rolling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 23 +++++++++++++----------
 arch/arm64/include/asm/sysreg.h      |  1 +
 arch/arm64/kvm/hyp/vhe/switch.c      | 14 +++++++++++++-
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index be56ff626be2..461377f79c60 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -255,21 +255,24 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 
 static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
 {
-	if (!__vcpu_el2_e2h_is_set(ctxt)) {
-		/*
-		 * Clear the .M field when writing SPSR to the CPU, so that we
-		 * can detect when the CPU clobbered our SPSR copy during a
-		 * local exception.
-		 */
-		val &= ~0xc;
-	}
+	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	if (vcpu_has_nv2(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
+		return val;
 
-	return val;
+	/*
+	 * Clear the .M field when writing SPSR to the CPU, so that we
+	 * can detect when the CPU clobbered our SPSR copy during a
+	 * local exception.
+	 */
+	return val &= ~0xc;
 }
 
 static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
 {
-	if (__vcpu_el2_e2h_is_set(ctxt))
+	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	if (vcpu_has_nv2(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
 		return val;
 
 	/*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3508ba196b55..72ff6df5d75b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -472,6 +472,7 @@
 #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
 #define SYS_HDFGRTR_EL2			sys_reg(3, 4, 3, 1, 4)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 154d994c1015..0aeafda5b966 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -47,7 +47,13 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			 * the EL1 virtual memory control register accesses
 			 * as well as the AT S1 operations.
 			 */
-			hcr |= HCR_TVM | HCR_TRVM | HCR_AT | HCR_TTLB | HCR_NV1;
+			if (vcpu_has_nv2(vcpu)) {
+				hcr &= ~HCR_TVM;
+			} else {
+				hcr |= HCR_TVM | HCR_TRVM | HCR_TTLB;
+			}
+
+			hcr |= HCR_AT | HCR_NV1;
 		} else {
 			/*
 			 * For a guest hypervisor on v8.1 (VHE), allow to
@@ -81,6 +87,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			if (!vcpu_el2_tge_is_set(vcpu))
 				hcr |= HCR_AT | HCR_TTLB;
 		}
+
+		if (vcpu_has_nv2(vcpu)) {
+			hcr |= HCR_AT | HCR_TTLB | HCR_NV2;
+			write_sysreg_s(vcpu->arch.ctxt.vncr_array,
+				       SYS_VNCR_EL2);
+		}
 	} else if (vcpu_has_nv(vcpu)) {
 		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
 
-- 
2.34.1

