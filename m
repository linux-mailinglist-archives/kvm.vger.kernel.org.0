Return-Path: <kvm+bounces-69064-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBTfAWAFdmmKKgEAu9opvQ
	(envelope-from <kvm+bounces-69064-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:58:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BF580719
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2FFA300B9D8
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 11:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B92131A046;
	Sun, 25 Jan 2026 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0hA1JJb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903093EBF21
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769342287; cv=none; b=pYP8bhwYTKu6/1xN0W9s+sa6JiA4AMgdj6enZLpekySFRN0YKDy+ny7bLbDnm0+nZKsVFIPOFYA2iA4oTHTXbfnC22i3h/Drknd+xbkX2USvnnlHnLYc4fvCj0OrGHqUA4MMCxJwEgCUGQlthePNSOmSlSZEpXYOmhbKJhqE9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769342287; c=relaxed/simple;
	bh=ivxz3DF061Ns2hoVLC+O3DNyOgG8pHNriUPvybXuBoc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nILgYUDoPyGa3jPe+5HB/ZeqKtEc5HUuWn8EHeRpufCQ6FheNVLQ3QMlHv/eX0wSC/s3dDdwOmN9xwJkSGaAZdVes93wCZJ1HGM1+g34dZNnu3ukV76iQJElF7eCsBH7gmxWhZZqThv+fNmIvDNezLkM+CH7Nxh3H18wWc9TpSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V0hA1JJb; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a12ed4d205so23688635ad.0
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 03:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769342286; x=1769947086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zGmrDbJpv9Mnf4OlN/zRFu5G/nsgDAKHAOEKObolTbA=;
        b=V0hA1JJbRe8hz6kpVzjhndMnhuFNVphmzUYK36k8mVS7CpKu/rrQb6X2Jh7k7O60L+
         Jemy9QK7YDfU6+/JmHLj5Vl6MyyMWPm80BPR4mjepN5wZCRP2BygYWxfa14R2zX2FEiq
         3jeh6DNqpBYel9XZrY+9AGxKlpi+OX+ojhNsyfkqX+zA44lytyrLT+r2cvrJY0Hub73X
         8Kfhzp6evNn5k8x0whpaLdE/Kljwkm3eP5mF40+lzib920H/1Hfat86lj773VAhdg6DA
         QQ6+NRXsAsH+7958c3JXGHnQuQxmEbeiSJqiGG1hfJhWnDWwZYawkNICPekMMvnGFesY
         FuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769342286; x=1769947086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGmrDbJpv9Mnf4OlN/zRFu5G/nsgDAKHAOEKObolTbA=;
        b=I8SuDTSbx/doGUxLCxzhp8rN3MS6ZitUtO/ETJLjcSB6OBtc6HPqCYJqKsikmJ44GC
         faw9k4KfHrF1sS1ZulWuNDN2MUsZgC1EfRKYdkzxe4Nbm8/DtARwnRUffTnu/yzANsV5
         BsNRR2zBABDt4p1uxgXlidHWzVGToUR5JoTrW/EC88KPicl7Ua4c7sdMxDZDMlFJZDXn
         QQ44IO2iXg9EWfbOmiHriBsUzgfUExvjwVHNX3+YdhvX25xqcJvJEHiTUkrdsdDTwqNW
         uXZvtB1L8dPh7bZA4chk8pp8FXnC0HoGEWAXTWEhKj56hDxGm1mJo8KWjFl/MPwb9HBx
         psFA==
X-Forwarded-Encrypted: i=1; AJvYcCWVzJmHGc/l+ZWIVSGkXcfKYKOLrXH/C3qVpyfzXjn+i85CMLEiJkWoNwr3ckjxzhO40Rc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuFBJxdYrSTagjBkuis/13PxxeMbB60VrF9alSVlFTpW38eXjX
	9IjBot8Yr8Mf1s9W+JmHjtYDi0BPUlz94NPzo/3dIl1VcOem1qHaLXK/
X-Gm-Gg: AZuq6aLReRTveg4MwHFMCZpUgnrqTDVu0krBt5nrWvHA3KUCG7haLNKMa2/dHMb2c2L
	i2PPNGSSbX2InvhS88T1n0Dz8MxE9Y8NxV6uc9SfQiypEWd88GwyvYa3X/c9yW6njgsQkIPSUMf
	owiM6yPZzslPGWQefswtOKmmKH0SWTLMJuGsvjXRXK1g6Fy49Bx8dLtrKavmfuM6zqviqdefeZV
	pn5vV8quNjA/DZLlnYQjDOchn5mSO2wMDLOm90V5gnTxinc3DUo5D6T/iT78XUHCzrIVYFkTuu2
	EpkyLfqCoHt0bcidG7Kxg+PACm6Nfj1MRfSGMeBeNH55kEs4RvwJZPGoGXkwgEVTrl2qQYFtQDg
	fuU9Pkd3zp5qFkwj+36LvmJmd1hS+lmc3hQK2L/Oq95Dw+remm2jmcKMB4JBojGcpMa5ihrOZen
	LsLYJkjLDRrtDE4HMdVkJa48Hmwi3bwPBdxpEm/watccCUONspUDo=
X-Received: by 2002:a17:902:ce8e:b0:295:9e4e:4090 with SMTP id d9443c01a7336-2a845307823mr12548625ad.52.1769342285789;
        Sun, 25 Jan 2026 03:58:05 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802daa675sm66792385ad.15.2026.01.25.03.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 03:58:05 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gamil.com>
Subject: [PATCH v3] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()
Date: Sun, 25 Jan 2026 11:57:58 +0000
Message-Id: <20260125115758.2486687-1-xujiakai2025@iscas.ac.cn>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-69064-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 63BF580719
X-Rspamd-Action: no action

Add a null pointer check for imsic_state before dereferencing it in
kvm_riscv_aia_imsic_has_attr(). While the function checks that the
vcpu exists, it doesn't verify that the vcpu's imsic_state has been
initialized, leading to a null pointer dereference when accessed.

This issue was discovered during fuzzing of RISC-V KVM code. The
crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
AIA IMSIC device before the IMSIC state has been fully initialized
for a vcpu.

The crash manifests as:
  Unable to handle kernel paging request at virtual address
  dfffffff00000001
  ...
  epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e
  arch/riscv/kvm/aia_imsic.c:998
  ...
  kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
  aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
  kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
  kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
  ...

The fix adds a check to return -ENODEV if imsic_state is NULL, which
is consistent with other error handling in the function and prevents
the null pointer dereference.

Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gamil.com>
---
V2 -> V3: Moved isel assignment after imsic_state NULL check.
          Placed patch version history after '---' separator.
          Added parentheses to function name in subject.
V1 -> V2: Added Fixes tag and drop external link as suggested.

 arch/riscv/kvm/aia_imsic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e597e86491c3b..cd070d83663a9 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -993,8 +993,11 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
 	if (!vcpu)
 		return -ENODEV;
 
-	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	imsic = vcpu->arch.aia_context.imsic_state;
+	if (!imsic)
+		return -ENODEV;
+
+	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	return imsic_mrif_isel_check(imsic->nr_eix, isel);
 }
 
-- 
2.34.1


