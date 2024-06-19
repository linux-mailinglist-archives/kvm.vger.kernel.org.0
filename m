Return-Path: <kvm+bounces-20005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E79E90F552
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D009EB22204
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764F515689A;
	Wed, 19 Jun 2024 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cCs9WkTp"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904F156256
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818855; cv=none; b=G1L78HbmepbriWBP5Rx9/Xbd7KZAgd4ZagFpzPF+bOn//mKvzqwuRkrKCndeWUNrmG/e1SJdnuDdS3xzHNzX0zM/fZ/8yk67oyLrPJoNHVIdy4TAWnfFvouo3IFhCjFBsEcXhEiEG4jiNMfvT5VS91cb8qfVNzv+3uoG8FIXPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818855; c=relaxed/simple;
	bh=e5boOnLNNN78OtWXTgz32BzufodoUCp/2YuT6bu97x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0KObDp4g+Y2unDJ9Iso9+/m5BO0LrVf5WgDK2NKLsTrOeijFJQEUy5FoRL6Zx3ejHLAUHd5+jHDbJvWuKpocaQlPijGjiY9lSuS67Uc5A6phI2giTc9nIFb3qYi7ygQheLtxGdfrhq1W/Tqn/xXBMORsgBTs/aME3M6bh0nGBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cCs9WkTp; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSqihC6V4LLi7Ia3RUNgIqC7bmww88xhf1H5i7EP+XA=;
	b=cCs9WkTp6aWzsVNNw2qr7I5QlwY81sMWBOuD6G42Ho43vnTfhG7/60Ttwi4eesmTq8qu+6
	dQ89uSxmN22+vKHJ890sY/pglpG5Pz5jPnWWIlKtm/8VGCMDQ2uct5jynEey49G1+pZmMo
	fue1ssauY8TjqkqHTX3AUN9KJLB1ilg=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 02/10] KVM: arm64: Make idregs debugfs iterator search sysreg table directly
Date: Wed, 19 Jun 2024 17:40:28 +0000
Message-ID: <20240619174036.483943-3-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

CTR_EL0 complicates the existing scheme for iterating feature ID
registers, as it is not in the contiguous range that we presently
support. Just search the sysreg table for the Nth feature ID register in
anticipation of this. Yes, the debugfs interface has quadratic time
completixy now. Boo hoo.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad453c7ad6cc..1036f865c826 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2753,8 +2753,6 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
 };
 
-static const struct sys_reg_desc *first_idreg;
-
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3440,6 +3438,25 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
+{
+	unsigned long i, idreg_idx = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *r = &sys_reg_descs[i];
+
+		if (!is_vm_ftr_id_reg(reg_to_encoding(r)))
+			continue;
+
+		if (idreg_idx == pos)
+			return r;
+
+		idreg_idx++;
+	}
+
+	return NULL;
+}
+
 static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
@@ -3451,7 +3468,7 @@ static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
 	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags) &&
 	    *iter == (u8)~0) {
 		*iter = *pos;
-		if (*iter >= KVM_ARM_ID_REG_NUM)
+		if (!idregs_debug_find(kvm, *iter))
 			iter = NULL;
 	} else {
 		iter = ERR_PTR(-EBUSY);
@@ -3468,7 +3485,7 @@ static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if ((kvm->arch.idreg_debugfs_iter + 1) < KVM_ARM_ID_REG_NUM) {
+	if (idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter + 1)) {
 		kvm->arch.idreg_debugfs_iter++;
 
 		return &kvm->arch.idreg_debugfs_iter;
@@ -3493,10 +3510,10 @@ static void idregs_debug_stop(struct seq_file *s, void *v)
 
 static int idregs_debug_show(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
 	const struct sys_reg_desc *desc;
+	struct kvm *kvm = s->private;
 
-	desc = first_idreg + kvm->arch.idreg_debugfs_iter;
+	desc = idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter);
 
 	if (!desc->name)
 		return 0;
@@ -4115,7 +4132,6 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 
 int __init kvm_sys_reg_table_init(void)
 {
-	struct sys_reg_params params;
 	bool valid = true;
 	unsigned int i;
 	int ret = 0;
@@ -4136,12 +4152,6 @@ int __init kvm_sys_reg_table_init(void)
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
 		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
 
-	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
-	params = encoding_to_params(SYS_ID_PFR0_EL1);
-	first_idreg = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-	if (!first_idreg)
-		return -EINVAL;
-
 	ret = populate_nv_trap_config();
 
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
-- 
2.45.2.627.g7a2c4fd464-goog


