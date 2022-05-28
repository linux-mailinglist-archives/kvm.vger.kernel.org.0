Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D80536CA7
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiE1Lt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiE1Lt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:49:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D4763F2
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C139D60E0A
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2515BC34100;
        Sat, 28 May 2022 11:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738594;
        bh=C9c28cedZULwe3x4XI5ibuDlgiUGa4VC7XtN6wvnzwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIC+dN8rg1nItQp2y4Mj7faOO7iw4JkaFZNWTRJb9S4B1Twp2lSF0xCgfwYPTEdrA
         pmtUwu/W3Nw/aXg0ZGz9vcrNa0ZGvb9G4J64BNa4ZJSPrM2rQii3TaLLBYHiMsDM41
         jjTT+aqkKNFPQdME4CGBVENhqb7RkEF4IuYUaP3tcHqJJhtgJy5vldy5QdRdHoxtJX
         zd0hWzF6CS2yMFDh2svFN+3+F/eiMSCgRT3Lod8jcAp0uowQiMrMbCAevFR8Tk8wRG
         WmQjjFN6zx8tIpuFWlmcOw5Ju7yusQtGtjzyy2Qwy0yq11VKOhZmAwyQuVyx8T7umJ
         Yyxksk+FZv5WA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumD-00EEGh-3t; Sat, 28 May 2022 12:38:37 +0100
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
Subject: [PATCH 15/18] KVM: arm64: Warn when PENDING_EXCEPTION and INCREMENT_PC are set together
Date:   Sat, 28 May 2022 12:38:25 +0100
Message-Id: <20220528113829.1043361-16-maz@kernel.org>
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

We really don't want PENDING_EXCEPTION and INCREMENT_PC to ever be
set at the same time, as they are mutually exclusive. Add checks
that will generate a warning should this ever happen.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c   | 2 ++
 arch/arm64/kvm/inject_fault.c        | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 46e631cd8d9e..861fa0b24a7f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -473,6 +473,7 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 
 static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu_get_flag(vcpu, PENDING_EXCEPTION));
 	vcpu_set_flag(vcpu, INCREMENT_PC);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 2841a2d447a1..04973984b6db 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -38,6 +38,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a9a7b513f3b0..2f4b9afc16ec 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -20,6 +20,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
@@ -51,6 +53,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
@@ -71,6 +75,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 static void inject_undef32(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA32_UND);
 }
@@ -94,6 +100,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 
 	far = vcpu_read_sys_reg(vcpu, FAR_EL1);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	if (is_pabt) {
 		vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 		vcpu_set_flag(vcpu, EXCEPT_AA32_IABT);
-- 
2.34.1

