Return-Path: <kvm+bounces-69818-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGzLNfxmgGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69818-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4053CC9D5F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBB393012CF7
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E38311979;
	Mon,  2 Feb 2026 08:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vSBFDU9k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5E92D0292
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022646; cv=none; b=eI8sOqgnTgTX3iCevdP95CWetDpF2zt3h3CauR9dmzWbU2JqakVKgIvRjy97Of+aDNHE4SW1p5Sq7xBwmXncw9qwaYR6Cd+aALcrssE2YVmOo8XCFwZL9fLLFzkrEfCbJZyWWhirz8QM72sLKdaDlF3+WKqTF2emoCJCmZ6a46c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022646; c=relaxed/simple;
	bh=tcJKOrH2xCkEPHgXML6NiVu02FrkqYy3aC9ijl0I5cE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PoDkFi0tuZ4smNXFn+ooGQfe1oPMHkFzgQuq/kn2hUOyn4DO41ago0MTCzi2acTbV5ZNXmdOgH0bGNLAcmgo8AmcMHRj574bonsf77QmBrdzUyA06AZKXZChkgJSgEVTmVwqJLqahBvEGOwDb9ANTNxaJgKSRzpzNv2ry/XJQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vSBFDU9k; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48025e12b5bso60845175e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 00:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022643; x=1770627443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OoMXA35bVdlKlGkNfp2fyYW/VHkakTsU1N9xkHjNqUY=;
        b=vSBFDU9kpR3ULR/ugK5XSjqEXZAedrqDthfwCFCFbIFi25+wn3y3sqJiMv9iE3nyIS
         jxn1y36dIXzUON1UL/dLTT4oamXhFaYkEcjjnoKzd11anI1u1Bwyto+LgnAcFfxmKY+B
         R+LcEq43KqB+rxmtWJterxlyEpF+PMK/KFezOIteXmjZS8A654L9fqNZKZb3PXMn5IZb
         IRJpwwTtoi4XZiR9SJEhnFGlozKUkU6bnmNxoXH5NdIwz8VrkMqx3F/8xA+HzLMBG90R
         b6auynyA5ZcIcLUuJyW293B0np9nueHAzZoJDrWoeLd111kFtiAHSKm2dMmTip17Yh29
         ReHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022643; x=1770627443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OoMXA35bVdlKlGkNfp2fyYW/VHkakTsU1N9xkHjNqUY=;
        b=VRSuoJ4FX1bWAo8mKYSrc2N280lYxYSP+JOZid815dALYwCpTFIN/ZCBimWV4hOAov
         pzRYoZpuhDzmi+urlHcPuVxgR1YJX+FDaqjiTe/5+gDN4TwhCfW9UDIYG7wi08h6pp6A
         LDSaW7SXUS2L4v8HZPAnbz2ZwWeyX36/3Vjo/Hg3PNuAKfqnZI6r9iK8rPQMKCdkPA9E
         KcdfpaHrhrfJkmAfVxuf6VaRD7aEMcK3MtuAhuW+TWz1pr2jbWD8lERwV1meVJcU6ULV
         rQFWdfPlUTYxM/ndu6yKoUmyzePp2nz6DPC2Sv75ibfuJErB9iweVoY9LDeI9ZIFNqki
         MPog==
X-Gm-Message-State: AOJu0Yz6ZeYYstJLmb2J7Dq0/m4b4i07RToJwSkenM2mYPosc5ZPZK0s
	M1Oo8srMlggL+kbKmrqeWUtqi5Fdazr1k+693kWwef7JmjX66iLNJHr5yPVYimtvqnCmBzfF/rR
	DYDiGwjPx8r+sftNs0xqNCn+IeDq2yDqe3Wk5LCdtoLyXvAH6S85znemkPLmfq/prw82hhfOg3c
	hmMCiNBhWmUCESoA95vlouyjMWzpo=
X-Received: from wmpd26.prod.google.com ([2002:a05:600c:4c1a:b0:480:4a03:7b7d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6214:b0:480:1c53:208b
 with SMTP id 5b1f17b1804b1-482db49da0bmr129922045e9.36.1770022643392; Mon, 02
 Feb 2026 00:57:23 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:19 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-2-tabba@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Use standard seq_file iterator for idregs debugfs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-69818-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 4053CC9D5F
X-Rspamd-Action: no action

The current implementation uses `idreg_debugfs_iter` in `struct
kvm_arch` to track the sequence position. This effectively makes the
iterator shared across all open file descriptors for the VM.

This approach has significant drawbacks:
- It enforces mutual exclusion, preventing concurrent reads of the
  debugfs file (returning -EBUSY).
- It relies on storing transient iterator state in the long-lived VM
  structure (`kvm_arch`).
- The use of `u8` for the iterator index imposes an implicit limit of
  255 registers. While not currently exceeded, this is fragile against
  future architectural growth. Switching to `loff_t` eliminates this
  overflow risk.

Refactor the implementation to use the standard `seq_file` iterator.
Instead of storing state in `kvm_arch`, rely on the `pos` argument
passed to the `start` and `next` callbacks, which tracks the logical
index specific to the file descriptor.

This change enables concurrent access and eliminates the
`idreg_debugfs_iter` field from `struct kvm_arch`.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 --
 arch/arm64/kvm/sys_regs.c         | 50 +++++--------------------------
 2 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..643a199f6e9e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,9 +373,6 @@ struct kvm_arch {
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
 
-	/* Iterator for idreg debugfs */
-	u8	idreg_debugfs_iter;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..035bf049e2e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4995,7 +4995,7 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
+static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, loff_t pos)
 {
 	unsigned long i, idreg_idx = 0;
 
@@ -5005,10 +5005,8 @@ static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
 		if (!is_vm_ftr_id_reg(reg_to_encoding(r)))
 			continue;
 
-		if (idreg_idx == pos)
+		if (idreg_idx++ == pos)
 			return r;
-
-		idreg_idx++;
 	}
 
 	return NULL;
@@ -5017,23 +5015,11 @@ static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
 static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	u8 *iter;
 
-	mutex_lock(&kvm->arch.config_lock);
+	if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return NULL;
 
-	iter = &kvm->arch.idreg_debugfs_iter;
-	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags) &&
-	    *iter == (u8)~0) {
-		*iter = *pos;
-		if (!idregs_debug_find(kvm, *iter))
-			iter = NULL;
-	} else {
-		iter = ERR_PTR(-EBUSY);
-	}
-
-	mutex_unlock(&kvm->arch.config_lock);
-
-	return iter;
+	return (void *)idregs_debug_find(kvm, *pos);
 }
 
 static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
@@ -5042,37 +5028,19 @@ static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if (idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter + 1)) {
-		kvm->arch.idreg_debugfs_iter++;
-
-		return &kvm->arch.idreg_debugfs_iter;
-	}
-
-	return NULL;
+	return (void *)idregs_debug_find(kvm, *pos);
 }
 
 static void idregs_debug_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-
-	if (IS_ERR(v))
-		return;
-
-	mutex_lock(&kvm->arch.config_lock);
-
-	kvm->arch.idreg_debugfs_iter = ~0;
-
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static int idregs_debug_show(struct seq_file *s, void *v)
 {
-	const struct sys_reg_desc *desc;
+	const struct sys_reg_desc *desc = v;
 	struct kvm *kvm = s->private;
 
-	desc = idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter);
-
-	if (!desc->name)
+	if (!desc)
 		return 0;
 
 	seq_printf(s, "%20s:\t%016llx\n",
@@ -5092,8 +5060,6 @@ DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
 void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 {
-	kvm->arch.idreg_debugfs_iter = ~0;
-
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog


