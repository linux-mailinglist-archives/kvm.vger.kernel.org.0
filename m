Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE23E16059A
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgBPSxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 13:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgBPSxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 13:53:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1E0208C4;
        Sun, 16 Feb 2020 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581879220;
        bh=W0DXE0Y6+7MX/BeEDfPtsK4Pl3uK+rz6OmCb9Cb4oyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtNr/Z3Kz1m00IzB61aegM9IO8i7TZ+S/jUqTW2WuN3qQbylw+ZgE7hsMi4JKjY7T
         QmMAbqFuwFmq0BsQD3QVoNIn2l+MNKRfxJg9jxODUB4pIOcn4vNKyAeosQhNCXX2QX
         RnRgDKtfVTQCfv8OF6LWWfYlZv2FwfIyVz73sUEc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3P2w-005iWD-86; Sun, 16 Feb 2020 18:53:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/5] KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
Date:   Sun, 16 Feb 2020 18:53:20 +0000
Message-Id: <20200216185324.32596-2-maz@kernel.org>
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

The AArch32 CP14 DBGDIDR has bit 15 set to RES1, which our current
emulation doesn't set. Just add the missing bit.

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e909b117f0c..da82c4b03aab 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1658,7 +1658,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
 			     (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
 			     (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20)
-			     | (6 << 16) | (el3 << 14) | (el3 << 12));
+			     | (6 << 16) | (1 << 15) | (el3 << 14) | (el3 << 12));
 		return true;
 	}
 }
-- 
2.20.1

