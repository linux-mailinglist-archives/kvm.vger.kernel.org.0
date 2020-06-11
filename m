Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E971F6455
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 11:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgFKJKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 05:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgFKJKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 05:10:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77CE2207ED;
        Thu, 11 Jun 2020 09:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591866610;
        bh=Em4/jIjhjqpTahQChLRnGzJ5UpaAk8Yvip8fJLBOHrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBWfe1Szo0ax7lAYon9w3gkQkV0g14c+k9O8LW4Lr2k6UWdQZwWpELgLNO8KzGE8i
         eQBRUF+JFHuHTPuMpTMPmCNNr0rabNBpqle5cR3eA1TKehix7ltQeyS3mL5ehEi5/c
         PmTLd7l1D7NcCA0ZA2M7AiIsxtDgBeQkKy8sWISo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjJDt-0022ZT-2G; Thu, 11 Jun 2020 10:10:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/11] KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
Date:   Thu, 11 Jun 2020 10:09:48 +0100
Message-Id: <20200611090956.1537104-4-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, james.morse@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

ACTLR_EL1 is a 64bit register while the 32bit ACTLR is obviously 32bit.
For 32bit software, the extra bits are accessible via ACTLR2... which
KVM doesn't emulate.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200529150656.7339-3-james.morse@arm.com
---
 arch/arm64/kvm/sys_regs_generic_v8.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 9cb6b4c8355a..aa9d356451eb 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -27,6 +27,14 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 		return ignore_write(vcpu, p);
 
 	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
+
+	if (p->is_aarch32) {
+		if (r->Op2 & 2)
+			p->regval = upper_32_bits(p->regval);
+		else
+			p->regval = lower_32_bits(p->regval);
+	}
+
 	return true;
 }
 
@@ -47,6 +55,8 @@ static const struct sys_reg_desc genericv8_cp15_regs[] = {
 	/* ACTLR */
 	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
 	  access_actlr },
+	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
+	  access_actlr },
 };
 
 static struct kvm_sys_reg_target_table genericv8_target_table = {
-- 
2.26.2

