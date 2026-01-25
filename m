Return-Path: <kvm+bounces-69059-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AlE0J8PZdWmbJAEAu9opvQ
	(envelope-from <kvm+bounces-69059-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 09:52:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1791F80099
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 09:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAADB300C59D
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6413168E1;
	Sun, 25 Jan 2026 08:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6Lxv7+7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD7171C9
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769331126; cv=none; b=hQME5Kd6Zf434p/tVB1gE3VLhcDsUIH1J+xVJj9Qd9umqrLV8NalAicCQauycpl8qk7imAHEAIIbBv6bo46OnHKwThEB70jJHHIbERuUbmrPtVh1iGMsuMrltAfD/3SsOXdIpB4C2PHyf+341RCkq9z/z+LTGcAkCVDvXCA1cB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769331126; c=relaxed/simple;
	bh=7GIpaZcPG0qpaUGgCkh2hKi4S2JRE+KitID/fdVMKPk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y4daEknA3N2fytWhmljtzrltkoLNLGcznegeNMgOUHCT6oVWMI0RjL5e/3TD+0RrA9cALU5vPoMsa8IZICsQzKEyE33GblbqqKWFeZ4fGyIZWF/Mtsi5LMEhK+Rbt8/zeGhN8XKHEcxMM7y+sGGjRR8qZytrxInJOthbLZVwTTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6Lxv7+7; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81dab89f286so1766704b3a.2
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 00:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769331125; x=1769935925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iT5OFvQeF8zMVf/PxrofZtaIbAS6SSbifWcBi3L0Yu0=;
        b=Q6Lxv7+7hfziCoiGwRhPiBLnRO4D24jmkTkQR2+PPOIOaxyWOD8UOucH6ERbhMzTM7
         mb4GDfSHXULp1lqS3lA+Cksi+1pdc462c+zGxF1mSEJoo5fLDJjV4jINQVf34/HUYiww
         perjxQPMtmCexFuGHgo6eAoa6WwsrGHFl6oOt2ka6rBUoF+reibKo0Ir3R3EVEg+fg4P
         CfaGzKHlwPGfPdgNe9oWqR510g75OIF17IjNUSTM+RZ9zi1T+sxtctvuRZtSEBs/IzYH
         j5/tBKu6z5b1F3/nMZh66xfTTOe/gTBiqo+aYho5gir9jEkepuBtRWDjU9dlMrbNt0Da
         t0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769331125; x=1769935925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iT5OFvQeF8zMVf/PxrofZtaIbAS6SSbifWcBi3L0Yu0=;
        b=nGUpf02Hk/WUHpLSgwxTDpjrmDBNxV8u3TyvAOesfmxXS+MXyxhY/WG6Uz5UHKf8nT
         1r9zay0UZr9puInoyjhfvxeGNWR+hoy4HemEzbpwN0Gohr6rW1hkG90QLuMRQ9V86XQg
         VuLUT4vaHWgany+Nhp8noLtgO9KnQQj+Mgh0qAXFX3oc0wym1gkb77ermzRyVl9DsU9t
         2nhMTurizxuqN8L+MhS8vhNpF21fxzn6IDBzKyyDAaHqK912Y2XS1c4BwqPxZENNxwfI
         WWd/4inkQ8kkFJR5do2fwwztPPyEy6QPCPRKX5buBzGp0xrbQd/XcruM82vjF1fz9X25
         MMVA==
X-Forwarded-Encrypted: i=1; AJvYcCWIPVu+a0sCJc/PJ9ON/MTv9B/hqiFNk9vcTlUSMxaG7VnP/LQUzONfi8SBNnV+I6z70GU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6yjLqYQrLwleRrcewT9KPIRCUK2RcdQ4D9SN22+6RiARJnPKy
	0xVGHhHdcLbro8FcibIu+NZM/eU7Qa9FQGzgDkgPTMxcHyQV7/h+leTs84z9m9zzFVA=
X-Gm-Gg: AZuq6aKnU7ZraRfKEpmK/1e4hv1iWQGNT4hGh0zq3yhr7xJomocnKDSAUHWoQSKWAqU
	ZIxv0I7o2zBFLZ53VP6dyN4EbA9XFG79XUeIdBdyEscZfR/rn/x2ygg6ioqD62MqDYAsL1d020B
	mL6u9hpEFkQFdQ04CG/5evYY8LGko13SYHi0moUbTelM/1l4kJj67mz4u5SqDtwQnWj1keYTV6f
	PHFsPb1CAO2QARLda47fFmQYexEYszOMQSbivtxVKqqaR/+yT4zBuuIWArXkwRwM8CkuzaNaFgI
	Tv3c2OeRJPLM1mloN3Pk4ARo5yLVbDseXahQXjAVgcMVjEPPs+66NPuCaNeiUUxrnNClpeRU+FW
	IAijAm9t7mFfTR0tZt8rdzeWzPKfw/iGoYD6OKNdyNLHzRkFfoleizVWDEaiKH0sHzWbd1MLGFg
	YLcusCiT+wFk8Y4ZVuCWNmKDvBwZhEdz9dn0LKUTwdYOtkpjwr0Mc=
X-Received: by 2002:a05:6a00:3d48:b0:81f:44bb:8aa with SMTP id d2e1a72fcca58-823411dba60mr877844b3a.8.1769331125018;
        Sun, 25 Jan 2026 00:52:05 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e5d0sm6442072b3a.61.2026.01.25.00.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 00:52:04 -0800 (PST)
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
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr
Date: Sun, 25 Jan 2026 08:51:57 +0000
Message-Id: <20260125085157.2462296-1-xujiakai2025@iscas.ac.cn>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69059-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 1791F80099
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

v2: add Fixes tag and drop external link as suggested.

Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
---
 arch/riscv/kvm/aia_imsic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e597e86491c3b..9c58a66068447 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -995,6 +995,9 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
 
 	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	imsic = vcpu->arch.aia_context.imsic_state;
+	if (!imsic)
+		return -ENODEV;
+
 	return imsic_mrif_isel_check(imsic->nr_eix, isel);
 }
 
-- 
2.34.1


