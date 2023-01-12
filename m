Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2A667F3E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbjALT3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbjALT2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968393E0EE
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CEFB82019
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5299C433F1;
        Thu, 12 Jan 2023 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551346;
        bh=YNMtW6qYRgKEUFaPKzZRjN4rCL/DaY441LVttCXbAOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwlecoCytOLWONq6+gHt78Dzq1zToL1fDjq4/ogfOrlGBe+PGrkEtzJrbGMSAC6ME
         Ug9IuBL5l4k25JftmI2T5sPl+pZrSAez6wemSpU+D+iPJLiV0tLNuNa83Ct+OgOPc9
         //Lf71VLmYjkaTdKNPFBChj8cJ7fJKgHdaTTOe+Olzskvfncga1ugP/hzD99LTr2+m
         OqVvk4cpsVg1W7eGmLk8VnfWqRUTeYDJGXjq0Pk4NVktyuuC1UjYi6GbPfoIdClF04
         eambVvEsBBr4/O9nRHmKSp92LSH28+O56tCO/YjTMqCQX/6wlhGTysmW67cM7ckYBB
         JYu7NJtoHr95g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG372-001IWu-Tf;
        Thu, 12 Jan 2023 19:19:45 +0000
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
Subject: [PATCH v7 22/68] KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
Date:   Thu, 12 Jan 2023 19:18:41 +0000
Message-Id: <20230112191927.1814989-23-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

From: Jintack Lim <jintack.lim@linaro.org>

Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0636475693ec..ea73377693af 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -17,6 +17,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -337,6 +338,19 @@ static __always_inline u64 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline bool guest_hyp_wfx_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
+	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return false;
+
+	return ((is_wfe && (hcr_el2 & HCR_TWE)) ||
+		(!is_wfe && (hcr_el2 & HCR_TWI)));
+}
+
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b0c343c4e062..ea73b47b99ac 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -124,8 +124,12 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
 
-	if (esr & ESR_ELx_WFx_ISS_WFE) {
+	if (guest_hyp_wfx_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	if (is_wfe) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 	} else {
-- 
2.34.1

