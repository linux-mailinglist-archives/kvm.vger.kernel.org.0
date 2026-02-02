Return-Path: <kvm+bounces-69902-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WAvSFazwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69902-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:45:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6782AD0448
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BAE02300F1FA
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDE938E5EA;
	Mon,  2 Feb 2026 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJOBosqN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CA538E5CF;
	Mon,  2 Feb 2026 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057825; cv=none; b=nN8PcOM6023Msqf17HUB+rk1ry3OR7S/kdk/aH/vQeAJqWAYBs8IpJLrXpSP/FG6ncjxs4ylyc0BQlHvDF8DY6/ihfvBWfwwPSs0Ud/XBxjhiIBWKbxRLOmbubGl69CPnZFSnbz4fP9edsyZl7hd7hnk55yslhhxAuoedpcWtgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057825; c=relaxed/simple;
	bh=W6QElC8ez3cKzFnlWFTTok0DI6SuUFkBLxQ9HdMrWbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIovoEd/11nHRh/RbloycqbU3/C78qiBkG4ZvKcaN7D1mnyweKqujwKDCPtNdVGZkXNeDcIRj+BN0R6w9tk7Q2+6OjZn0DrbdvcPPNd+xeka5qx83tktvbqPuDKDKWTtkNbgyy+CW3dTEvWQOBGq42dqlFybkUUYTmf5g7R02t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJOBosqN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E3C116C6;
	Mon,  2 Feb 2026 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057825;
	bh=W6QElC8ez3cKzFnlWFTTok0DI6SuUFkBLxQ9HdMrWbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJOBosqN3dxHF90aKtnQo30khpNfyAeSsvJQ/2PKEye/M6Pqj0q7HYS0Uld/SGldy
	 KIq4tDdPwUgL1XSVFThZ5tW+wgAanrBUxOVxXQb08vqjc1fCx0HWIZn8AD4e5oBOwK
	 oCH4OVXAnkhrBFbI9lJ0JDWtVZM3PbdDd2Y0wL3uNF6rKZOFKI2vQTLmgtFP7JZSVL
	 DDqMytFOWIaEfUYrLB6ejxuXJgJWvm0WIngGxXRwF41lR7J+2mLQayBisMIeXaw89t
	 Oa7kv3g/R1HnfVGIqqag3nu8WQaLlb3r+zHF7M4YJSj7ZNZLufj8PIU7bduXCPQ5BC
	 qWhhqGqXXlE/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytj-00000007sAy-2REP;
	Mon, 02 Feb 2026 18:43:43 +0000
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
Subject: [PATCH v2 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
Date: Mon,  2 Feb 2026 18:43:29 +0000
Message-ID: <20260202184329.2724080-21-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69902-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6782AD0448
X-Rspamd-Action: no action

Computing RESx values is hard. Verifying that they are correct is
harder. Add a debugfs file called "resx" that will dump all the RESx
values for a given VM.

I found it useful, maybe you will too.

Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 68 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96c..d33c39ea8fadd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5090,12 +5090,80 @@ static const struct seq_operations idregs_debug_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
+static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, loff_t pos)
+{
+	unsigned long i, sr_idx = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *r = &sys_reg_descs[i];
+
+		if (r->reg < __SANITISED_REG_START__)
+			continue;
+
+		if (sr_idx++ == pos)
+			return r;
+	}
+
+	return NULL;
+}
+
+static void *sr_resx_start(struct seq_file *s, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+
+	if (!kvm->arch.sysreg_masks)
+		return NULL;
+
+	return (void *)sr_resx_find(kvm, *pos);
+}
+
+static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+
+	(*pos)++;
+
+	return (void *)sr_resx_find(kvm, *pos);
+}
+
+static void sr_resx_stop(struct seq_file *s, void *v)
+{
+}
+
+static int sr_resx_show(struct seq_file *s, void *v)
+{
+	const struct sys_reg_desc *desc = v;
+	struct kvm *kvm = s->private;
+	struct resx resx;
+
+	if (!desc)
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
 
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
+	debugfs_create_file("resx", 0444, kvm->debugfs_dentry, kvm,
+			    &sr_resx_fops);
 }
 
 static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *reg)
-- 
2.47.3


