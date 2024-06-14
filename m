Return-Path: <kvm+bounces-19691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91110908DC5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A9A2891B4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4344964B;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKDtXcGs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E373B298;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376377; cv=none; b=mPpxQsaQVzWQoA8Eorl17U0Ong3tFC8dIFC4lufsTandOcvPb4Ykal0O0VkIKb985JsB54hDj1VguN5RStewLORms5ryDJE+n2i12ZjikRhizXYW4aOWP/bGH1CT9/n1NbsDMNrwsPFs4aGOgYosGoO6v2nCsuZ3iSvuzGkmxpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376377; c=relaxed/simple;
	bh=R248gaby0XedPY/sNz9iwnTRy32Bls10nlswI1GHrQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F7ZZsM7v27C6akfSslMhGUNmPSjPfo3EDLTdNRTipHVq1GmSAe3PTK20Hb33ZyD2w9YZKekzjLCK9x1o3j4aljALZGP3A9jZdczfjPOnL7Mms+7QU9QdHQeufaE2mqBgvHYqL52s/h5mtkLH9lEwzP0CeJTt/3o+Klju/SfZpgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKDtXcGs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F375C4AF51;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376377;
	bh=R248gaby0XedPY/sNz9iwnTRy32Bls10nlswI1GHrQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKDtXcGsFczcU5hJJjkQEpab6DXgGGEg8HOCSt9O/k+CQNFMJC78gCAorh2Uxq4OB
	 RJ8p6Z/IkZ6KoXjplQ3z21edqb4yBbn7sia/gWeU1XbZlsqviLAkYP5wrKDoSl0qoj
	 OhM/5lFPEGtqz1FLJlXxJUOMBV/3hSsXKcTJkistxwWhggxoZLvSRR+7fbNka+8s8g
	 YE22m1O13h88Ss1vg/UNgWm4fpKT3DYugnlkAab5IOEABSE93ehwjLO6DPMKM56bUY
	 lIJv3pOIc3ZFZfLCED04vMQS9yocyesMo0A/okyOkxk/yJSl1/4VKwuRu2/fGHqpQl
	 9oksn3bNszvoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8Bz-003wb4-ID;
	Fri, 14 Jun 2024 15:46:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 09/16] KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
Date: Fri, 14 Jun 2024 15:45:45 +0100
Message-Id: <20240614144552.2773592-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TLBI ALLE1* is a pretty big hammer that invalides all S1/S2 TLBs.

This translates into the unmapping of all our shadow S2 PTs, itself
resulting in the corresponding TLB invalidations.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22a3691ce248..d8d6380b7c66 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2757,6 +2757,29 @@ static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
 	return true;
 }
 
+static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * Drop all shadow S2s, resulting in S1/S2 TLBIs for each of the
+	 * corresponding VMIDs.
+	 */
+	kvm_nested_s2_unmap(vcpu->kvm);
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
 /* Only defined here as this is an internal "abstraction" */
 union tlbi_info {
 	struct {
@@ -2880,7 +2903,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
 
-- 
2.39.2


