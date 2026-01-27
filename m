Return-Path: <kvm+bounces-69216-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KASWFdJ6eGnBqAEAu9opvQ
	(envelope-from <kvm+bounces-69216-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 09:44:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A5391333
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 09:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 662BF300D5C2
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430EE2C11E5;
	Tue, 27 Jan 2026 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TukUBUep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCEF2C08B1
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 08:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769503434; cv=none; b=ToAnbeiA4eyuI289Gk25MFFyoIz/7xLovjlNztpe8SzjGtL7Cy6iVFhWUcp05IHzXAXRGVDKewbqXJlAUnEFJcKf1AZfQhUfsfflqgjZA0TtH01029JtcpIjbOJepKrYObMJhdYkjj1dImlhVqVMCQeQxSW5QQkz6eNBrK7pj1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769503434; c=relaxed/simple;
	bh=GzvtIUis0EMsZG1slqRGy7Qecih1MuOYCpwXvRC5QNM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f9eOreDPPckCScrjOLb27y2uJc0C6KZM5XaHisxoSZbBVLXTmPvUCp4ncKlG6vxQHc3WeVMUux+d1VatJWESaSA5oNQKqhEm6Bz6/G8zKDAvK+gBT1yDI0tNCpauBs814AeL+k9u6mlo36EWyIs1XYvFJKzM9wP7G6IDNgjVU+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TukUBUep; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so57613335ad.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 00:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769503433; x=1770108233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IsvMU6ygmVPOfBtUBm6r4nNfbsjDFVMoFcdeUelLuBA=;
        b=TukUBUepEsVFjYLDivSjQGkpGP/Tnuwng5lFE3V+tb4cXb8xncY7p6gZFifcjd/KQS
         67Rspo3VTCNXSpaQyygiiInj72aKoK0YJzIYAZoeVfWrZTaYJumpWUYvR5FG8z9PNh82
         JMolMqllU28hjrAIVuNdjpzVGXA26HPhSKk8bq2MlyMn7/TnxniLvUA3oRa3rJ9xvR7J
         Y/T7SxZqEm4wKkwAr6Ny0vEbyvwKsjiwXK2gVZOzN+BmN1rdA1tFuqVXmSm3RzSf68+B
         MIdgRheJX6PPu1dijjJYOJTTKtLserAEXZeh4Sr//Uy8xH8eGR5/JzJYxeuUu8JhfSh/
         HmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769503433; x=1770108233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsvMU6ygmVPOfBtUBm6r4nNfbsjDFVMoFcdeUelLuBA=;
        b=EtkFjq/36r6/EiEg0hpHh0VoXXLWEUbKkwspo+Q4XIg3kOXclO8pSqoK+MAsMvwDUr
         u9dQIGYNAktR48NFaiXBfpkmfFOpmaOojjrPkxqFXbE5Imy2sX6z07E/XG4xEgV9nuBr
         Fq4myf02RyoNRnShvJdOMqrBEkMNPpa98Hk0rlZaKyIpjMMA/wT9YIS8dL6IoWD0digh
         SqIlaGCuXwppJ7MHvTTI9jLMTyYIpQijdBw6OLRLRGCdQxTEUZZh8PoTZg/j6B9t7X24
         emSfSoWDwQ2tJyv5k6dp6hyI+29hOujaivDQqOEw6qY2hJkQbi8qnWJkyldGk9Dg00sx
         rV+A==
X-Forwarded-Encrypted: i=1; AJvYcCXQp9NmmmJlEnf7eKUxkt9YVcHFaAicSGXXf+ctVHeVcWPfQbbuCJk1RtQdaQM7OtnDeQk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ/tXSbDRw5pWmgiywQ10ujjeXEZXIHdbgRqWtJAG7uenl8Apf
	YJ6P3eo0AHFfRyffTgqNmc9WMN2IYv1g5elUU3+7/qdYpqwK1faPCGBa
X-Gm-Gg: AZuq6aKcu1lr5C462Xn0sPIFpNqQTi4mLU4R5ms6/OX4BsSNPO16LAGhHi9CoULVHEE
	l8/cgG7UXsMaz1Od1OfsxvKLZBBU+iBTZUQprBcy9KwmMaTinDB/Z3BvfysoY704bMesF+Lz7KA
	rpVJzYkkFoaKIr3D8uRpLcCDgx29IU34wDAiGdlPHJpDyulEJL51h/MUJd5RAWoHYJLKw1JuOZ9
	Ted4Smh16pcYBE4U85GZztiL3Perk1A9ShuwOj6z2LBPhGdUgGkFHXdA8B2FdgkQ6/alo+8nlNm
	GcGGJcoKnuObIHpBEJ3ureYvYaIZSLsdk0605hoTVwlHVEqhFWUG8RD+uyQ5oJ1lyJ/2+Z9Ofgz
	oZ29DYEclmyqZ9zWIt5esVOOeQ3ECK5hPmGna/Cs+VRfwxvfruxp+taIuAg83FS3ENbTZiaj6NA
	oMyO4aRdh/PtI6xMb9vTPMrLO8wCx6wHRZcuSlZ78w
X-Received: by 2002:a17:903:2c6:b0:24b:270e:56c7 with SMTP id d9443c01a7336-2a870d7a907mr11402265ad.7.1769503432479;
        Tue, 27 Jan 2026 00:43:52 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802de5cf8sm108838235ad.42.2026.01.27.00.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 00:43:52 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH] RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initialized
Date: Tue, 27 Jan 2026 08:43:13 +0000
Message-Id: <20260127084313.3496485-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69216-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,iscas.ac.cn,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 37A5391333
X-Rspamd-Action: no action

kvm_riscv_vcpu_aia_imsic_update() assumes that the vCPU IMSIC state has
already been initialized and unconditionally accesses imsic->vsfile_lock.
However, in fuzzed ioctl sequences, the AIA device may be initialized at
the VM level while the per-vCPU IMSIC state is still NULL.

This leads to invalid access when entering the vCPU run loop before
IMSIC initialization has completed.

The crash manifests as:
  Unable to handle kernel paging request at virtual address
  dfffffff00000006
  ...
  kvm_riscv_vcpu_aia_imsic_update arch/riscv/kvm/aia_imsic.c:801
  kvm_riscv_vcpu_aia_update arch/riscv/kvm/aia_device.c:493
  kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:927
  ...

Add a guard to skip the IMSIC update path when imsic_state is NULL. This
allows the vCPU run loop to continue safely.

This issue was discovered during fuzzing of RISC-V KVM code.

Fixes: db8b7e97d6137a ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 arch/riscv/kvm/aia_imsic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e597e86491c3b..a7d387e280d49 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -797,6 +797,10 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	if (kvm->arch.aia.mode == KVM_DEV_RISCV_AIA_MODE_EMUL)
 		return 1;
 
+	/* IMSIC vCPU state may not be initialized yet */
+	if (!imsic)
+		return 1;
+
 	/* Read old IMSIC VS-file details */
 	read_lock_irqsave(&imsic->vsfile_lock, flags);
 	old_vsfile_hgei = imsic->vsfile_hgei;
-- 
2.34.1


