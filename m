Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBD8682926
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjAaJlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjAaJle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:41:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BED2BF1C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A98B1B81AB3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5712DC433EF;
        Tue, 31 Jan 2023 09:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158079;
        bh=UkFdG6zfNlpkdCXoHcPWCNATAtk2HHLyoOVHUn2Pg4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8BMziAhFCLDqNgFuRYNIEOBQweA+zqn893JxYb72bh9b0IEf8ejdoPvdz8C9DVcz
         nve1+rxmIdNpwwFpW/RQInwQKkUbDtroGV66JlP6GBXbwd84cpkaPcq0q9fGa2tY3V
         A2MFOEaeEkcvf7J/b1qscUVVtKhog8yv7nnAPk0x5IAc2mVk0Xqpcui+8i4Fxn2DjZ
         QYTE1YwGMxKXtFyTuZH1cpnfr2TvmEZEfMFPyBtksUUzjc0hm6BigLxWcNgPiHd/wx
         ViFLI9lNRTyfQS3whdMqvicpf2Yza+cNepzez/UO6R9YSKmdOCiR0LWNodDfGeP6gc
         Qxf27nFyKnpog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtV-0067U2-Q0;
        Tue, 31 Jan 2023 09:25:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 30/69] KVM: arm64: nv: Forward debug traps to the nested guest
Date:   Tue, 31 Jan 2023 09:24:25 +0000
Message-Id: <20230131092504.2880505-31-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

On handling a debug trap, check whether we need to forward it to the
guest before handling it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 ++
 arch/arm64/kvm/emulate-nested.c     | 9 +++++++--
 arch/arm64/kvm/sys_regs.c           | 5 +++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7633a8c845c4..2fe5847b401f 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -59,6 +59,8 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
+			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 7c06844a5113..555771e1260d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -14,14 +14,14 @@
 
 #include "trace.h"
 
-bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
 	bool control_bit_set;
 
 	if (!vcpu_has_nv(vcpu))
 		return false;
 
-	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
 	if (!vcpu_is_el2(vcpu) && control_bit_set) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
@@ -29,6 +29,11 @@ bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
 	return false;
 }
 
+bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, HCR_EL2, control_bit);
+}
+
 bool forward_nv_traps(struct kvm_vcpu *vcpu)
 {
 	return forward_traps(vcpu, HCR_NV);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2206fedccfc6..ab4383a5cfb1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -666,6 +666,11 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
+	if (forward_traps(vcpu, HCR_TGE) ||
+	    __forward_traps(vcpu, MDCR_EL2, MDCR_EL2_TDE) ||
+	    __forward_traps(vcpu, MDCR_EL2, MDCR_EL2_TDA))
+		return false;
+
 	access_rw(vcpu, p, r);
 	if (p->is_write)
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
-- 
2.34.1

