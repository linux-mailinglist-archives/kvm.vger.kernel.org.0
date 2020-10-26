Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1683C2989D0
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 10:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768646AbgJZJvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737069AbgJZJvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AB82222EC;
        Mon, 26 Oct 2020 09:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705891;
        bh=M9e70BEFvF5FajpDUL4748IzzfhwguzKhvy5dXrsgVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vROdnfbQxI4Ju2iB6xoCt7CemBetIOumxE1d+KQqxDvEdVsJnhGCsSIb2cfp+IrKt
         4asYcTyiMm1cYQIk95FWa4uF7WlLY8FflURgUu+ArxLtXpX68VgL5n65f4aZ2VSVim
         NhcyLDWCyx2LKy2f+gKC3uOIDnTuflgQBp3P5A2w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA1-004HZn-Qc; Mon, 26 Oct 2020 09:51:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 1/8] KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
Date:   Mon, 26 Oct 2020 09:51:09 +0000
Message-Id: <20201026095116.72051-2-maz@kernel.org>
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

The hyp-init code starts by stashing a register in TPIDR_EL2
in in order to free a register. This happens no matter if the
HVC call is legal or not.

Although nothing wrong seems to come out of it, it feels odd
to alter the EL2 state for something that eventually returns
an error.

Instead, use the fact that we know exactly which bits of the
__kvm_hyp_init call are non-zero to perform the check with
a series of EOR/ROR instructions, combined with a build-time
check that the value is the one we expect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 47224dc62c51..b11a9d7db677 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -57,16 +57,25 @@ __do_hyp_init:
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	/* Set tpidr_el2 for use by HYP to free a register */
-	msr	tpidr_el2, x2
-
-	mov	x2, #KVM_HOST_SMCCC_FUNC(__kvm_hyp_init)
-	cmp	x0, x2
-	b.eq	1f
+	// We only actively check bits [24:31], and everything
+	// else has to be zero, which we check at build time.
+#if (KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) & 0xFFFFFFFF00FFFFFF)
+#error Unexpected __KVM_HOST_SMCCC_FUNC___kvm_hyp_init value
+#endif
+
+	ror	x0, x0, #24
+	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 24) & 0xF)
+	ror	x0, x0, #4
+	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 28) & 0xF)
+	cbz	x0, 1f
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:	phys_to_ttbr x0, x1
+1:
+	/* Set tpidr_el2 for use by HYP to free a register */
+	msr	tpidr_el2, x2
+
+	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
 	orr	x0, x0, #TTBR_CNP_BIT
 alternative_else_nop_endif
-- 
2.28.0

