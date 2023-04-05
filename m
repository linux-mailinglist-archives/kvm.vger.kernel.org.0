Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CFA6D826E
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbjDEPra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbjDEPr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52E728A
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70E7A63F05
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A51C433D2;
        Wed,  5 Apr 2023 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709590;
        bh=R76HaO8qoXwTusW877BsCKlHkjCFGvuoQfdtYgi9v/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvrmfVHqB8oL64YI4j2xaSeYxR+Goun2pP9Q7DIuwrXw79k54u/Do3R65JHRCB22J
         t6G6iyI3uEgpHsFi3jq1+EF0gUpxxLMpHZ7ucwzINPLexJ5iHS+9LoGNdZNi26f/be
         EI3vGp5WH9fSQxAU8iQYSQO8i+g6ZTVL7/2UXUNLDku7QNE2ZxDkCcchyE2rPsm6da
         C//r7QNgK/GZ3OjGghEv0QHvIZYLbYhOxYYEZ7qHNFo3HR2JYpcWNBIfZQxMuZMKSC
         ulRP91iRoU5Z8PGyCYLI5UcoKkZBFUrd4mGlCG74Bcq27FCedFnxaFiVMZFoTsaAAL
         KbA3l6ocM56XA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5Fw-0062PV-Ow;
        Wed, 05 Apr 2023 16:41:04 +0100
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
Subject: [PATCH v9 50/50] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
Date:   Wed,  5 Apr 2023 16:40:08 +0100
Message-Id: <20230405154008.3552854-51-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although FEAT_ECV allows us to correctly enable the timers, it also
reduces performances pretty badly (a L2 guest doing a lot of virtio
emulated in L1 userspace results in a 30% degradation).

Mitigate this by emulating the CTL/CVAL register reads in the
inner run loop, without returning to the general kernel. This halves
the overhead described above.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index a3555b90d9e1..a9ac61505a86 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -201,11 +201,60 @@ static bool kvm_hyp_handle_tlbi_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_ecv(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr, val;
+
+	/*
+	 * Having FEAT_ECV allows for a better quality of timer emulation.
+	 * However, this comes at a huge cost in terms of traps. Try and
+	 * satisfy the reads without returning to the kernel if we can.
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_ECV))
+		return false;
+
+	if (!vcpu_has_nv2(vcpu))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) != ESR_ELx_SYS64_ISS_DIR_READ)
+		return false;
+
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_CNTP_CTL_EL02:
+	case SYS_CNTP_CTL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		break;
+	case SYS_CNTP_CVAL_EL02:
+	case SYS_CNTP_CVAL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		break;
+	case SYS_CNTV_CTL_EL02:
+	case SYS_CNTV_CTL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		break;
+	case SYS_CNTV_CVAL_EL02:
+	case SYS_CNTV_CVAL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		break;
+	default:
+		return false;
+	}
+
+	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el1(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_ecv(vcpu, exit_code))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.34.1

