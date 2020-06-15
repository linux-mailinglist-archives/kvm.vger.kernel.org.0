Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1D1F913B
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 10:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgFOIUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 04:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgFOIUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 04:20:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA85206E2;
        Mon, 15 Jun 2020 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592209205;
        bh=3JOu3whXJHagX3A5FXu4YOyMwg0buhIfq0J6saBPEWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSVi3gmPR9xUm2rCakwEj3nJ130UF203cE4RAlDZuI/haaRGRkXWZNddLJefxqnsZ
         V0TFhXghmCZq4V9HsILYwivR5UaqASj/PZe163BnLIJDF5hNmTXWy1sNbEHfZLzoil
         nTRsqhvhoxu5nK9fr7nRde30rwecznbQbbHFG94Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkkLb-0031ew-Ju; Mon, 15 Jun 2020 09:20:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if available
Date:   Mon, 15 Jun 2020 09:19:51 +0100
Message-Id: <20200615081954.6233-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200615081954.6233-1-maz@kernel.org>
References: <20200615081954.6233-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While initializing EL2, switch Pointer Authentication if detected
from EL1. We use the EL1-provided keys though.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp-init.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6e6ed5581eed..81732177507d 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -104,6 +104,17 @@ alternative_else_nop_endif
 	 */
 	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
+alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+	b	1f
+alternative_else_nop_endif
+alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
+	b	2f
+alternative_else_nop_endif
+1:
+	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
+	orr	x4, x4, #SCTLR_ELx_ENDA
+	orr	x4, x4, #SCTLR_ELx_ENDB
+2:
 	msr	sctlr_el2, x4
 	isb
 
-- 
2.27.0

