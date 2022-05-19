Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2899E52D497
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiESNpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiESNp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD62633B2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65B5D6179E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C8AC34119;
        Thu, 19 May 2022 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967923;
        bh=3CjY4Pec448XotcyN2iqZqW/AXk9FKiq5AorkwA5PIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah5dMC5WL11TdBzKBFW4Bm7Zf9QsydkXGKdBlSpTd3G5QGJbK85WTN2cy469QC4ob
         /Ke2PCNB091Ze8VKttP1KicuACFtsKPLDbf24CemZhY1WpCwsnIwK16Ry1BBmcRU4V
         V4Ooe8GEU+9EvDOonvoO5BlORgY7iMI/1dlajlgTk/j03cJwQ89WlP3IFCKa7osB2v
         BTGEs6Abq4Tr/F35/f96HSYeol7vZc0gf6QUbYifbzXQYgPWmkqEfNFND86Mxc1zRh
         VI+zByOsw5wmlxrriGPanviEM+V75OACVZrfev4deRza+qgONZSTQpWJ+cD6DUDWk1
         WemTltlhe7UrQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 45/89] KVM: arm64: Add the {flush,sync}_timer_state() primitives
Date:   Thu, 19 May 2022 14:41:20 +0100
Message-Id: <20220519134204.5379-46-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

In preparation for save/restore of the timer state at EL2 for protected
VMs, introduce a couple of sync/flush primitives for the architected
timer, in much the same way as we have for the GIC.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 58515e5d24ec..32e7e1cad00f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -63,6 +63,38 @@ static void sync_vgic_state(struct kvm_vcpu *host_vcpu,
 		WRITE_ONCE(host_cpu_if->vgic_lr[i], shadow_cpu_if->vgic_lr[i]);
 }
 
+static void flush_timer_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	if (!shadow_state_is_protected(shadow_state))
+		return;
+
+	/*
+	 * A shadow vcpu has no offset, and sees vtime == ptime. The
+	 * ptimer is fully emulated by EL1 and cannot be trusted.
+	 */
+	write_sysreg(0, cntvoff_el2);
+	isb();
+	write_sysreg_el0(__vcpu_sys_reg(shadow_vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+	write_sysreg_el0(__vcpu_sys_reg(shadow_vcpu, CNTV_CTL_EL0), SYS_CNTV_CTL);
+}
+
+static void sync_timer_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	if (!shadow_state_is_protected(shadow_state))
+		return;
+
+	/*
+	 * Preserve the vtimer state so that it is always correct,
+	 * even if the host tries to make a mess.
+	 */
+	__vcpu_sys_reg(shadow_vcpu, CNTV_CVAL_EL0) = read_sysreg_el0(SYS_CNTV_CVAL);
+	__vcpu_sys_reg(shadow_vcpu, CNTV_CTL_EL0) = read_sysreg_el0(SYS_CNTV_CTL);
+}
+
 static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
@@ -85,6 +117,7 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	flush_vgic_state(host_vcpu, shadow_vcpu);
+	flush_timer_state(shadow_state);
 }
 
 static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
@@ -102,6 +135,7 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	host_vcpu->arch.flags		= shadow_vcpu->arch.flags;
 
 	sync_vgic_state(host_vcpu, shadow_vcpu);
+	sync_timer_state(shadow_state);
 }
 
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

