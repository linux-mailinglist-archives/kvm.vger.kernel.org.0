Return-Path: <kvm+bounces-67429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C47D058BA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4A47373A68A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D12B2E9EAE;
	Thu,  8 Jan 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liNKre/p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1429BDBD;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=lc04R4JeuJ/3Sj4S2Lj3nEET9zSN077et+/TF4FrEcvgh/Xv+tbFTw+Py9EUGH4aC1QbX+nB5gfjrIhxM/RsqIXg9k+W+mwl0K3qwvVOicGb9Th+w1WowUuG3CZf4VIN95+Yv65ilEl+rTk7k/qU3XKb+qgVszwKQN1zYvIR2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=v78Ho1jfctKksx+ghNDA5fnROsXHxo8/3r+Q1Sd63M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKCHW28K+jrG/bWEpPdAUL7cdFJMqZbXNXwivSEG9RlfnErReO+tcewOBpaTBxoYZPoj8Wbp54Ok7HOYETqMLRjnfsrnEzvVUNsZflkpD0jvZ3c5Inaq7dYwuGGMKXdedds0ho7ZTa8Nf7tzj5PxZm1kZp1ENE3B+aUqGtbgLoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liNKre/p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C0AC19425;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893559;
	bh=v78Ho1jfctKksx+ghNDA5fnROsXHxo8/3r+Q1Sd63M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liNKre/p2z+wYybw/l2XQ6GEjPKMs7/OgykCUAmBFiLjkPk3Pfx7fn8Ak2evkVWSp
	 QhgdGKQcwxmwdN+q/GAJlPK9LyaAbtgvHQ8Ne8IJBkpSelJC2pH5CEccPG5fX2vCRS
	 o1GK3piAYfK/EhXFOeEof0h1FsabSfUuTtMoADmEQf6dL4hq2lFL7J0RnAyO4dWlQJ
	 rJVt4XDXpC6TgSxM6cCLUmi27acEQyjuyoCTNtqv/nqXEdmC2E54oA7Pp4M4LoRcfm
	 Fdu1BpI45sAcnH3REVfvF1wstLCz9jImiyR9UxumuN/RgMVJjlxU01EfiTw5ILoUDm
	 QC9S/CB9kNuBQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsD-00000000W9F-16BJ;
	Thu, 08 Jan 2026 17:32:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 4/9] KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
Date: Thu,  8 Jan 2026 17:32:28 +0000
Message-ID: <20260108173233.2911955-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a bit of infrastrtcture to triage_sysreg_trap() to handle the
case of registers falling into the Feature ID space that do not
have a local handler.

For these, we can directly apply the FEAT_IDST semantics and inject
an EC=0x18 exception. Otherwise, an UNDEF will do.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.h       | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 616eb6ad68701..4aabd624c4be5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2588,6 +2588,19 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 
 		params = esr_sys64_to_params(esr);
 
+		/*
+		 * This implements the pseudocode UnimplementedIDRegister()
+		 * helper for the purpose of dealing with FEAT_IDST.
+		 */
+		if (in_feat_id_space(&params)) {
+			if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
+				kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+			else
+				kvm_inject_undefined(vcpu);
+
+			return true;
+		}
+
 		/*
 		 * Check for the IMPDEF range, as per DDI0487 J.a,
 		 * D18.3.2 Reserved encodings for IMPLEMENTATION
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index b3f904472fac5..2a983664220ce 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -49,6 +49,16 @@ struct sys_reg_params {
 				  .Op2 = ((esr) >> 17) & 0x7,			\
 				  .is_write = !((esr) & 1) })
 
+/*
+ * The Feature ID space is defined as the System register space in AArch64
+ * with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+ */
+static inline bool in_feat_id_space(struct sys_reg_params *p)
+{
+	return (p->Op0 == 3 && !(p->Op1 & 0b100) && p->Op1 != 2 &&
+		p->CRn == 0 && !(p->CRm & 0b1000));
+}
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
-- 
2.47.3


