Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5072CDD7CF
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2019 11:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfJSJzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Oct 2019 05:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfJSJzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Oct 2019 05:55:33 -0400
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk [62.31.163.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A153E222C2;
        Sat, 19 Oct 2019 09:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571478932;
        bh=C+wxLu/WnnwZ3cqp2GHFnfaQZgrXjj31+JCX0m8MeoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYqx+7UMtpLMaE/KOY3jsL1gUUeMf3s+YgsbRmwJeHNiJhsZhiQnsl7bbhvmNKWrg
         s3seIIPbTqbICqVFLO61SkWTYsh7XposMSxyYa3dW0GZ6V0kOrF7u+0yAl2g0BqYPA
         nrqcyHiWEkARmUq3m6gv36fmahQT1YvI0NELSY5Y=
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH v2 2/5] arm64: KVM: Reorder system register restoration and stage-2 activation
Date:   Sat, 19 Oct 2019 10:55:18 +0100
Message-Id: <20191019095521.31722-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191019095521.31722-1-maz@kernel.org>
References: <20191019095521.31722-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to prepare for handling erratum 1319367, we need to make
sure that all system registers (and most importantly the registers
configuring the virtual memory) are set before we enable stage-2
translation.

This results in a minor reorganisation of the load sequence, without
any functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 3d3815020e36..69e10b29cbd0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -605,18 +605,23 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(host_ctxt);
 
-	__activate_vm(kern_hyp_va(vcpu->kvm));
-	__activate_traps(vcpu);
-
-	__hyp_vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
-
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 *
+	 * Also, and in order to be able to deal with erratum #1319537 (A57)
+	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
+	 * restored before we enable S2 translation.
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
+
+	__activate_vm(kern_hyp_va(vcpu->kvm));
+	__activate_traps(vcpu);
+
+	__hyp_vgic_restore_state(vcpu);
+	__timer_enable_traps(vcpu);
+
 	__debug_switch_to_guest(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
-- 
2.20.1

