Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D516F1B44D3
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgDVMVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbgDVMVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:21:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A4421D7B;
        Wed, 22 Apr 2020 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558095;
        bh=Idczft88aog6M8M4O6TVlb0GRSTqov9o2dWVVhNYIEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkzG1l0oYIkP8ND8XsQyB8vOZbeoqon1cG4bW6FXggxGAdfCW6abvqtENI1Z+0Tnz
         cL4ehaBzWJUyTj0jRwjkmRGYAc05wQ4axRQsyD6/UivhYaHkt2Q7AOQiEhp8As504Y
         bz39DrXN82H6HdSwbCwcWKLgTxzc6eU9ruuriMoc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE3z-005UI7-9h; Wed, 22 Apr 2020 13:01:11 +0100
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
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 17/26] KVM: arm64: debug: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Wed, 22 Apr 2020 13:00:41 +0100
Message-Id: <20200422120050.3693593-18-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
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
index 998758f8b5774..421e547ed10f3 100644
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
2.26.1

