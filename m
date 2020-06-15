Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8F1F98C5
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 15:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbgFONdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 09:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbgFONdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 09:33:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E55A5207DA;
        Mon, 15 Jun 2020 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592228015;
        bh=Ccxvsr57UrAOLR+owG6CU5hnOo2EH/JVGx8ixgxFI2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmU/xjTru6gFM9+f8qmaA7uRV1aNdGPUHhTJ3eDqGhH7cctrJzj0vvaGRmRFWtndY
         YpTK8cuVc7Rkabblin5xMD2oqmlnMjQFxVcIhBsmtx0KWlExF2XLs4iG1MVcMO0Zdw
         ZQJYLG7lbMF0Rc0W4hTBt/4lqyUaXPBZiDvEzGt4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkp9N-0036w9-CW; Mon, 15 Jun 2020 14:27:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 10/17] KVM: arm64: debug: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Mon, 15 Jun 2020 14:27:12 +0100
Message-Id: <20200615132719.1932408-11-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200615132719.1932408-1-maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a wrapper for the sysreg accesses, let's use that
consistently.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/debug-sr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 2a6bfa2d3a94..aa2e62c4ed59 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -129,8 +129,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-					  struct kvm_guest_debug_arch *dbg,
+static void __hyp_text __debug_save_state(struct kvm_guest_debug_arch *dbg,
 					  struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
@@ -148,8 +147,7 @@ static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt_sys_reg(ctxt, MDCCINT_EL1) = read_sysreg(mdccint_el1);
 }
 
-static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-					     struct kvm_guest_debug_arch *dbg,
+static void __hyp_text __debug_restore_state(struct kvm_guest_debug_arch *dbg,
 					     struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
@@ -190,8 +188,8 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
-	__debug_save_state(vcpu, host_dbg, host_ctxt);
-	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
+	__debug_save_state(host_dbg, host_ctxt);
+	__debug_restore_state(guest_dbg, guest_ctxt);
 }
 
 void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
@@ -212,8 +210,8 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
-	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
-	__debug_restore_state(vcpu, host_dbg, host_ctxt);
+	__debug_save_state(guest_dbg, guest_ctxt);
+	__debug_restore_state(host_dbg, host_ctxt);
 
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
-- 
2.27.0

