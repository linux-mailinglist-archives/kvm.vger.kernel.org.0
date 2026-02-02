Return-Path: <kvm+bounces-69828-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uG1yDQd1gGnU8QIAu9opvQ
	(envelope-from <kvm+bounces-69828-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:57:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0CCCA571
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 985093017249
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 09:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02299302CC0;
	Mon,  2 Feb 2026 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTGYiiSz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89192BDC32
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026238; cv=none; b=XStL6alF+Gqlyx2aI4b5B1gxeNGMeS19Oeb9q6L+0zKkESgIS9f81IH1Ooux5xbmki7N5OQfIB3vnb8PJ1i4MaNChv66QH35fDoPCrqsA7kQeDg9sRNSiy0/VsINSRh1xQi2canRr6FVPuu7rRrvkxj91iPnwRW0aes2O6dS+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026238; c=relaxed/simple;
	bh=McpcEFSPeqGeTz+B+AL6xVCJrRgiZy4Kf/HoS29sO+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PJ49SkkvSkCap6s6118u6DpgSBhjq3LjcZSD2y+gOzZvHhgIgpYpGfVsls4IUAq61IKzWZ/6Op48lXSVzdQRArRJVUNvDdElPFM9H8Ryb8QO/3XhyzGhNRAHBeZJ2G2PTM/vqyL92QUMYWzwa09oxCTGmw0Tjq8DfGhHMnJiVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FTGYiiSz; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806fce5ab1so25593205e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 01:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770026235; x=1770631035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENzMwMoZWO8vLhCKa/do6yK+Nqm+qfwsFu4e8Q1TWrM=;
        b=FTGYiiSzgUr/FZMOIFl4Ht6nUAFOsq2c6oIGODIw1bF0sXM58s82KIFFESRsovpbtQ
         uiabt/IEbtILanygzDxYsYzUP0lokzRKsaismrIFFysUTx8gPHNCRVMH/KHkQdswcCbl
         t+6X+IGkLp09TQokGCCwWulQRt9Nqw0XIE1ttXdJsDVkLyVJXEBjucCTLQlASgUHJpVA
         c2CqHJUf0hvqjeWBcKBkNzrqO8dZPEy06inbBecU3htRb72RPIGJ26bwzRt1juHZtl8D
         kRFfv01uHY7h+Kte1tGlGRFJDnID9ZxzsvlByG3FpsLAf1673Q8XoDRkV0m599HcxKqO
         TuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770026235; x=1770631035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENzMwMoZWO8vLhCKa/do6yK+Nqm+qfwsFu4e8Q1TWrM=;
        b=i/T30UR0HhVnsuEfZoiHU/wmQZjshdD/rPbcNyxz2MfCkrVVijZIhW8J+JMOeNv0ZI
         RkO98ohozM39FpZrCv8ntVwRhrQ3rj9epVe/Qb7aS/R2y5SNA0LxQFfF9XfxvKCTIdvN
         2z2yDrh8T/L24wuAGmbZ80HjT5DJAQiBggSaXsHmITGJdP2mpeypZi4m7LWNKH61hqrK
         ePSWZn1KSZhb6gMSAVeXAHwduaZDZrzzqUQNmP7SeM8rRFYwhVcshYI7Hnxzys94yCHw
         41u6MisOBTwfQT5YBNPXn4dm8qCY3u/oZRaoasEmqjcwTv78xixETXqnhhGtSwP2oW5J
         m+Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWfRoMr7vKAIS7qiM9DSuMOFjSYGv5IEw33uKufWYnnlPwe8s3QXMUjpNw2Rj6AvkyGSQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMyYS5ahbUnK5lVccG0mX/Ie2SPWEtIm/4Udp4ll8PE9RqxRUd
	IDFdJKfCDrh48uI0zEMxTQIM5Ph0aIsWrxWIIVfciBqyEFDBJpf1I5aC6QOuRz3DcKFJcsnvSJm
	l9A==
X-Received: from wmbdn5.prod.google.com ([2002:a05:600c:6545:b0:480:69c2:3949])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:82cd:b0:482:ef72:5787
 with SMTP id 5b1f17b1804b1-482ef725dc0mr51293805e9.1.1770026235054; Mon, 02
 Feb 2026 01:57:15 -0800 (PST)
Date: Mon,  2 Feb 2026 09:57:14 +0000
In-Reply-To: <86wm0va4ni.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <86wm0va4ni.wl-maz@kernel.org>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202095714.4038391-1-tabba@google.com>
Subject: Re: [PATCH 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, 
	catalin.marinas@arm.com, tabba@google.com
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
	TAGGED_FROM(0.00)[bounces-69828-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: BE0CCCA571
X-Rspamd-Action: no action

...

>
> Yes please. We might as well do the right thing, and I can fold that
> into my current series with you as a co-author.
>
> Thanks,

Here you go.

Cheers,
/fuad

---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/sys_regs.c         | 42 +++++--------------------------
 2 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 54072f6ec9d4..c82b071ade2a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,7 +375,6 @@ struct kvm_arch {
 
 	/* Iterator for idreg debugfs */
 	u8	idreg_debugfs_iter;
-	u16	sr_resx_iter;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f3f92b489b58..d33c39ea8fad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5090,7 +5090,7 @@ static const struct seq_operations idregs_debug_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
-static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
+static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, loff_t pos)
 {
 	unsigned long i, sr_idx = 0;
 
@@ -5100,10 +5100,8 @@ static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
 		if (r->reg < __SANITISED_REG_START__)
 			continue;
 
-		if (sr_idx == pos)
+		if (sr_idx++ == pos)
 			return r;
-
-		sr_idx++;
 	}
 
 	return NULL;
@@ -5112,22 +5110,11 @@ static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
 static void *sr_resx_start(struct seq_file *s, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	u16 *iter;
-
-	guard(mutex)(&kvm->arch.config_lock);
 
 	if (!kvm->arch.sysreg_masks)
 		return NULL;
 
-	iter = &kvm->arch.sr_resx_iter;
-	if (*iter != (u16)~0)
-		return ERR_PTR(-EBUSY);
-
-	*iter = *pos;
-	if (!sr_resx_find(kvm, *iter))
-		iter = NULL;
-
-	return iter;
+	return (void *)sr_resx_find(kvm, *pos);
 }
 
 static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
@@ -5136,36 +5123,20 @@ static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if (sr_resx_find(kvm, kvm->arch.sr_resx_iter + 1)) {
-		kvm->arch.sr_resx_iter++;
-
-		return &kvm->arch.sr_resx_iter;
-	}
-
-	return NULL;
+	return (void *)sr_resx_find(kvm, *pos);
 }
 
 static void sr_resx_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-
-	if (IS_ERR(v))
-		return;
-
-	guard(mutex)(&kvm->arch.config_lock);
-
-	kvm->arch.sr_resx_iter = ~0;
 }
 
 static int sr_resx_show(struct seq_file *s, void *v)
 {
-	const struct sys_reg_desc *desc;
+	const struct sys_reg_desc *desc = v;
 	struct kvm *kvm = s->private;
 	struct resx resx;
 
-	desc = sr_resx_find(kvm, kvm->arch.sr_resx_iter);
-
-	if (!desc->name)
+	if (!desc)
 		return 0;
 
 	resx = kvm_get_sysreg_resx(kvm, desc->reg);
@@ -5188,7 +5159,6 @@ DEFINE_SEQ_ATTRIBUTE(sr_resx);
 void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 {
 	kvm->arch.idreg_debugfs_iter = ~0;
-	kvm->arch.sr_resx_iter = ~0;
 
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
-- 
2.53.0.rc1.225.gd81095ad13-goog


