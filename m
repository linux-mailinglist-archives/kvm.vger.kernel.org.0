Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96AB2989D3
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 10:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1737062AbgJZJvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737090AbgJZJvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FDA2240A;
        Mon, 26 Oct 2020 09:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705894;
        bh=kDb9dgfCqN99WeV24iJj+2Y3Ko1XbY7GmOWMOSHZFRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0uB4nnBViQmZ0yG0HUdZ2oAUBpo7Ogfn9eUSIePu+mNpKjrd69owbaK2YKTJWGdQ
         5L9s4x7b+GTB1CmlM3SF/ZS7x6UhpZejjTCcKKIDeAhzUy1UAAPmxk4KfziZ7jTLnL
         ORp6r2As0mmFKFG9RXdZJ6eFEI7Y0eyJQP9vsjjU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA4-004HZn-Ei; Mon, 26 Oct 2020 09:51:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 6/8] KVM: arm64: Patch kimage_voffset instead of loading the EL1 value
Date:   Mon, 26 Oct 2020 09:51:14 +0000
Message-Id: <20201026095116.72051-7-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026095116.72051-1-maz@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly using the kimage_voffset variable is fine for now, but
will become more problematic as we start distrusting EL1.

Instead, patch the kimage_voffset into the HYP text, ensuring
we don't have to load an untrusted value later on.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/image-vars.h | 4 +---
 arch/arm64/kvm/hyp/nvhe/host.S | 7 ++++++-
 arch/arm64/kvm/va_layout.c     | 6 ++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index b5b0fdd1043c..259c704a548a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -65,13 +65,11 @@ __efistub__ctype		= _ctype;
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
+KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
-/* Kernel constant needed to compute idmap addresses. */
-KVM_NVHE_ALIAS(kimage_voffset);
-
 /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
 KVM_NVHE_ALIAS(__hyp_panic_string);
 KVM_NVHE_ALIAS(panic);
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ed27f06a31ba..e2d316d13180 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -115,7 +115,12 @@ SYM_FUNC_END(__hyp_do_panic)
 	 * Preserve x0-x4, which may contain stub parameters.
 	 */
 	ldr	x5, =__kvm_handle_stub_hvc
-	ldr_l	x6, kimage_voffset
+alternative_cb kvm_get_kimage_voffset
+	movz	x6, #0
+	movk	x6, #0, lsl #16
+	movk	x6, #0, lsl #32
+	movk	x6, #0, lsl #48
+alternative_cb_end
 
 	/* x5 = __pa(x5) */
 	sub	x5, x5, x6
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 1d00d2cb93fd..d61117805de0 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -251,3 +251,9 @@ void kvm_update_kimg_phys_offset(struct alt_instr *alt,
 {
 	generate_mov_q(kimage_voffset + PHYS_OFFSET, origptr, updptr, nr_inst);
 }
+
+void kvm_get_kimage_voffset(struct alt_instr *alt,
+			    __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	generate_mov_q(kimage_voffset, origptr, updptr, nr_inst);
+}
-- 
2.28.0

