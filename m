Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454EB2A33D3
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgKBTQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgKBTQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 14:16:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8434B223AC;
        Mon,  2 Nov 2020 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604344577;
        bh=HeMaj9byEng8Q/QID9Mu5LlGP6pKlERJDGJvinzDGpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/caZB/3u4Ch9rOy61aYNcyfRl6Zrlt7Rm7qgUIS/j+L7AL3s+1OAVtTsaewfOm0N
         Xas4E3qUsUASUmAT0IeXhWRmj+DL2Pn8tRDsWyJzArNAklKqfGXa5Q4EYqlXa7Gj/Q
         Mzbm56NAGd+NKgOMm6CLXSqIfwp3xLdp2i9bfVh4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZfJP-006nxn-Ov; Mon, 02 Nov 2020 19:16:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 6/8] KVM: arm64: Drop is_aarch32 trap attribute
Date:   Mon,  2 Nov 2020 19:16:07 +0000
Message-Id: <20201102191609.265711-7-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

is_aarch32 is only used once, and can be trivially replaced by
testing Op0 instead. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c        | 7 ++-----
 arch/arm64/kvm/sys_regs.h        | 1 -
 arch/arm64/kvm/vgic-sys-reg-v3.c | 2 --
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46df63c2f321..2048e7e7bd7c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -208,7 +208,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	 * equivalent to ICC_SGI0R_EL1, as there is no "alternative" secure
 	 * group.
 	 */
-	if (p->is_aarch32) {
+	if (p->Op0 == 0) {		/* AArch32 */
 		switch (p->Op1) {
 		default:		/* Keep GCC quiet */
 		case 0:			/* ICC_SGI1R */
@@ -219,7 +219,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 			g1 = false;
 			break;
 		}
-	} else {
+	} else {			/* AArch64 */
 		switch (p->Op2) {
 		default:		/* Keep GCC quiet */
 		case 5:			/* ICC_SGI1R_EL1 */
@@ -2167,7 +2167,6 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
 	int Rt2 = (esr >> 10) & 0x1f;
 
-	params.is_aarch32 = true;
 	params.CRm = (esr >> 1) & 0xf;
 	params.is_write = ((esr & 1) == 0);
 
@@ -2217,7 +2216,6 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	u32 esr = kvm_vcpu_get_esr(vcpu);
 	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
 
-	params.is_aarch32 = true;
 	params.CRm = (esr >> 1) & 0xf;
 	params.regval = vcpu_get_reg(vcpu, Rt);
 	params.is_write = ((esr & 1) == 0);
@@ -2311,7 +2309,6 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
-	params.is_aarch32 = false;
 	params.Op0 = (esr >> 20) & 3;
 	params.Op1 = (esr >> 14) & 0x7;
 	params.CRn = (esr >> 10) & 0xf;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 8c4958d6b5ce..416153b593a6 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -19,7 +19,6 @@ struct sys_reg_params {
 	u8	Op2;
 	u64	regval;
 	bool	is_write;
-	bool	is_aarch32;
 };
 
 struct sys_reg_desc {
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 806d6701a7da..07d5271e9f05 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -268,7 +268,6 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 
 	params.regval = *reg;
 	params.is_write = is_write;
-	params.is_aarch32 = false;
 
 	if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
 			      ARRAY_SIZE(gic_v3_icc_reg_descs)))
@@ -287,7 +286,6 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 	if (is_write)
 		params.regval = *reg;
 	params.is_write = is_write;
-	params.is_aarch32 = false;
 
 	r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
 			   ARRAY_SIZE(gic_v3_icc_reg_descs));
-- 
2.28.0

