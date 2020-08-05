Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A1D23CF0F
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgHETMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgHES1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB64722D07;
        Wed,  5 Aug 2020 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651969;
        bh=coBFhvxK2q/R9mJrFoLvBfMpmosxtdCyB+g5bJYKGGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkXqznH8EWP/qhoxKr7NlrbevNgvrO3h1UU93seBbBi+GL1TaW5jCaUJDJvJyohaH
         GSez2l7HrAbHoGPYwDU0Z+jfCxg9PmdAb6WcpCawzdwajv3wDtjclhmxAKAuc/4e6y
         BfaqTMOFVF1+sPHdzW8U+bKPw3mDWm0nsFeF8iuQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfq-0004w9-Ay; Wed, 05 Aug 2020 18:57:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 40/56] KVM: arm64: debug: Drop useless vpcu parameter
Date:   Wed,  5 Aug 2020 18:56:44 +0100
Message-Id: <20200805175700.62775-41-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As part of the ongoing spring cleanup, remove the now useless
vcpu parameter that is passed around (host and guest contexts
give us everything we need).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 5499d6c1fd9f..0297dc63988c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -88,9 +88,8 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static inline void __debug_save_state(struct kvm_vcpu *vcpu,
-				      struct kvm_guest_debug_arch *dbg,
-				      struct kvm_cpu_context *ctxt)
+static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
+			       struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -107,9 +106,8 @@ static inline void __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt_sys_reg(ctxt, MDCCINT_EL1) = read_sysreg(mdccint_el1);
 }
 
-static inline void __debug_restore_state(struct kvm_vcpu *vcpu,
-					 struct kvm_guest_debug_arch *dbg,
-					 struct kvm_cpu_context *ctxt)
+static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
+				  struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -142,8 +140,8 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
-	__debug_save_state(vcpu, host_dbg, host_ctxt);
-	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
+	__debug_save_state(host_dbg, host_ctxt);
+	__debug_restore_state(guest_dbg, guest_ctxt);
 }
 
 static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
@@ -161,8 +159,8 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
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

