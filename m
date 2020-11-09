Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A212AC305
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 18:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgKIR7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 12:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730269AbgKIR7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 12:59:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650B820809;
        Mon,  9 Nov 2020 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944772;
        bh=CvlpepUleGE92S4Hy7ecNff+HZV8FbvvzRSLVzB5XVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBKUSi0NyN0DsyawPKfhWMx/yU2o8IGxYh7bT9yco3OsXC4PRFKQ92zySp730oowm
         ClZXLOGHe6edWxMRe37Bg6+6iNVCJ204Jxulrzd6AFqTx2rQcbcziqxxYlmLgELaW/
         TM6YsK8RmoOjwltJwnzO/nPGUMuLzch2Wtxu2+Ig=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcBRy-009BQs-Jc; Mon, 09 Nov 2020 17:59:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, ndesaulniers@google.com,
        dbrazdil@google.com, kernel-team@android.com
Subject: [PATCH v2 5/5] KVM: arm64: Avoid repetitive stack access on host EL1 to EL2 exception
Date:   Mon,  9 Nov 2020 17:59:23 +0000
Message-Id: <20201109175923.445945-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109175923.445945-1-maz@kernel.org>
References: <20201109175923.445945-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, ndesaulniers@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Registers x0/x1 get repeateadly pushed and poped during a host
HVC call. Instead, leave the registers on the stack, trading
a store instruction on the fast path for an add on the slow path.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 4e207c1c5126..fe2740b224cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -13,8 +13,6 @@
 	.text
 
 SYM_FUNC_START(__host_exit)
-	stp	x0, x1, [sp, #-16]!
-
 	get_host_ctxt	x0, x1
 
 	/* Store the host regs x2 and x3 */
@@ -99,13 +97,15 @@ SYM_FUNC_END(__hyp_do_panic)
 	mrs	x0, esr_el2
 	lsr	x0, x0, #ESR_ELx_EC_SHIFT
 	cmp	x0, #ESR_ELx_EC_HVC64
-	ldp	x0, x1, [sp], #16
 	b.ne	__host_exit
 
+	ldp	x0, x1, [sp]		// Don't fixup the stack yet
+
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.hs	__host_exit
 
+	add	sp, sp, #16
 	/*
 	 * Compute the idmap address of __kvm_handle_stub_hvc and
 	 * jump there. Since we use kimage_voffset, do not use the
-- 
2.28.0

