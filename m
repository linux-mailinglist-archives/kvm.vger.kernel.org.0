Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39D160598
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgBPSxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 13:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgBPSxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 13:53:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62B522522;
        Sun, 16 Feb 2020 18:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581879220;
        bh=h8Q7AtQVzmQQIR2f94c+ic8PYd9dsaAo6eI6biKkE0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAaV4yNPdtB97Yr6J92OyDUgth9fPR+izVYUFK6bhaKUOxkAq/IBwhgSP7ZMs8Pbj
         DlwVxMT3KAAp4bQ3s1C43Ekf+DWLBwL5moZ47VM3BrCqu/il0mLwsxqxX61osfrVFE
         3Jfbqbp2KoXGVE582184Oeazi8eGsSz2Xf0CXmCQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3P2x-005iWD-57; Sun, 16 Feb 2020 18:53:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
Date:   Sun, 16 Feb 2020 18:53:22 +0000
Message-Id: <20200216185324.32596-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200216185324.32596-1-maz@kernel.org>
References: <20200216185324.32596-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our PMU code is only implementing the ARMv8.1 features, so let's
stick to this when reporting the feature set to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 682fedd7700f..06b2d0dc6c73 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1093,6 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 				 FEATURE(ID_AA64ISAR1_GPA) |
 				 FEATURE(ID_AA64ISAR1_GPI));
 		break;
+	case SYS_ID_AA64DFR0_EL1:
+		/* Limit PMU to ARMv8.1 */
+		val &= ~FEATURE(ID_AA64DFR0_PMUVER);
+		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 4);
+		break;
 	}
 
 	return val;
-- 
2.20.1

