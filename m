Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE533417C
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 16:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhCJP1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 10:27:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhCJP1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 10:27:13 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B309964F96;
        Wed, 10 Mar 2021 15:27:12 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lK0jv-000n3G-1P; Wed, 10 Mar 2021 15:27:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, qperret@google.com,
        kernel-team@android.com
Subject: [PATCH 4/4] KVM: arm64: Force SCTLR_EL2.WXN when running nVHE
Date:   Wed, 10 Mar 2021 15:26:56 +0000
Message-Id: <20210310152656.3821253-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310152656.3821253-1-maz@kernel.org>
References: <20210310152656.3821253-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the EL2 nVHE object is nicely split into sections and that
we already differenciating permissions for data and code,
we can enable SCTLR_EL2.WXN so that we don't have to worry
about misconfiguration of the page tables.

Flip the WXN bit and get the ball running!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9d1aef631646..cc17f7d487ed 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -580,7 +580,8 @@
 #define SCTLR_ELx_M	(BIT(0))
 
 #define SCTLR_EL2_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
-			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
+			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB | \
+			 SCTLR_ELx_WXN)
 
 /* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
-- 
2.29.2

