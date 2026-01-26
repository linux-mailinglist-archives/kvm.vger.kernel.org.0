Return-Path: <kvm+bounces-69143-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aK4QJEFcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69143-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B81888234
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4996B302561A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC36E339867;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxYqgDIv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634B338936;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429858; cv=none; b=sXrnRW8gqMTp4vIo0+NRTdgKnBh2RPl7GWPUuqtunXKSTmTrGo8NoVEzRQk3cTZ2jmwoS5Gl+nDV1rAjZQBtgli8RzhQahiV5Q66Si8qE9b40ZiGJQ6JqKUT+VRIMkHcnpE09j0z8sFUXTb8f6Ga6Cxy+IUo0oEO2p+Kw8AT4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429858; c=relaxed/simple;
	bh=rJgheB6THcstxt2wbh5QI4RzkAO+EKvuEAN0WWCmPRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuhWYd8zxPJ8i8/mJ1QJEJn6KYXn02rOsJTwNHmagqXbHnRIa5qSIgWI8KNr1X/s1A9WB4fvXMyzOjpB6rFvJsl43Iw/z985Gy3VHa7Vhfas6CtQD4YqhzYx0nGIr1Gs2NrM6Ml1srtvUBW77RHP6KXkOb1DOiKys6Q6wO0cc9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxYqgDIv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093AAC116C6;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429858;
	bh=rJgheB6THcstxt2wbh5QI4RzkAO+EKvuEAN0WWCmPRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxYqgDIvPwCgbKnPAopDR2//Jz9pVsvT5YHWC738jTDv4KBhEAyrwcrY/NyqNNJOA
	 KUHBstcoKcMAdw6bGLLDK+mgfbJMd4nF6ew6cxdXvGv/KwM6ilQwhjr3j4SLSLJj+/
	 nuHt7kh9EpaEJ2kKQkt949FoyRmYnFNsEV7MbnNOycVyIolEhAp43rgfPEvteYHJCN
	 bi1cPvc7dRaiEO9gCF1hl4toIe/Sd7pubnURSoyovO38m7LkhQGpS3KmsnS02NG1C3
	 Q3xtsDgoTEwHdOh8NpDj6WXzpRweM4FwqfwI+h4RQXyQP6MuoF4PJYc7eK/kTdXPqS
	 BgRQqAajx4Pog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXE-00000005hx6-1DLf;
	Mon, 26 Jan 2026 12:17:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
Date: Mon, 26 Jan 2026 12:16:54 +0000
Message-ID: <20260126121655.1641736-21-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69143-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2B81888234
X-Rspamd-Action: no action

Computing RESx values is hard. Verifying that they are correct is
harder. Add a debugfs file called "resx" that will dump all the RESx
values for a given VM.

I found it useful, maybe you will too.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 98 +++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c82b071ade2a5..54072f6ec9d4b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,6 +375,7 @@ struct kvm_arch {
 
 	/* Iterator for idreg debugfs */
 	u8	idreg_debugfs_iter;
+	u16	sr_resx_iter;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96c..f3f92b489b588 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5090,12 +5090,110 @@ static const struct seq_operations idregs_debug_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
+static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
+{
+	unsigned long i, sr_idx = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *r = &sys_reg_descs[i];
+
+		if (r->reg < __SANITISED_REG_START__)
+			continue;
+
+		if (sr_idx == pos)
+			return r;
+
+		sr_idx++;
+	}
+
+	return NULL;
+}
+
+static void *sr_resx_start(struct seq_file *s, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+	u16 *iter;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	if (!kvm->arch.sysreg_masks)
+		return NULL;
+
+	iter = &kvm->arch.sr_resx_iter;
+	if (*iter != (u16)~0)
+		return ERR_PTR(-EBUSY);
+
+	*iter = *pos;
+	if (!sr_resx_find(kvm, *iter))
+		iter = NULL;
+
+	return iter;
+}
+
+static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+
+	(*pos)++;
+
+	if (sr_resx_find(kvm, kvm->arch.sr_resx_iter + 1)) {
+		kvm->arch.sr_resx_iter++;
+
+		return &kvm->arch.sr_resx_iter;
+	}
+
+	return NULL;
+}
+
+static void sr_resx_stop(struct seq_file *s, void *v)
+{
+	struct kvm *kvm = s->private;
+
+	if (IS_ERR(v))
+		return;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	kvm->arch.sr_resx_iter = ~0;
+}
+
+static int sr_resx_show(struct seq_file *s, void *v)
+{
+	const struct sys_reg_desc *desc;
+	struct kvm *kvm = s->private;
+	struct resx resx;
+
+	desc = sr_resx_find(kvm, kvm->arch.sr_resx_iter);
+
+	if (!desc->name)
+		return 0;
+
+	resx = kvm_get_sysreg_resx(kvm, desc->reg);
+
+	seq_printf(s, "%20s:\tRES0:%016llx\tRES1:%016llx\n",
+		   desc->name, resx.res0, resx.res1);
+
+	return 0;
+}
+
+static const struct seq_operations sr_resx_sops = {
+	.start	= sr_resx_start,
+	.next	= sr_resx_next,
+	.stop	= sr_resx_stop,
+	.show	= sr_resx_show,
+};
+
+DEFINE_SEQ_ATTRIBUTE(sr_resx);
+
 void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 {
 	kvm->arch.idreg_debugfs_iter = ~0;
+	kvm->arch.sr_resx_iter = ~0;
 
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
+	debugfs_create_file("resx", 0444, kvm->debugfs_dentry, kvm,
+			    &sr_resx_fops);
 }
 
 static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *reg)
-- 
2.47.3


