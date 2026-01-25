Return-Path: <kvm+bounces-69065-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFmsBN0pdmndMgEAu9opvQ
	(envelope-from <kvm+bounces-69065-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 15:34:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 024EA80FFB
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 15:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 45F8530011BF
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 14:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665F131A7E4;
	Sun, 25 Jan 2026 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEMeSKG0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298C3C17
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769351633; cv=none; b=AJ9LfdMCpvHnsi9oC9E9/t6C/yuXd8/zqyN6G0HsDwciGf312odNs3wIGBh3E1fwb0qCuThu5+yAQQE/cZnMupC3zqWp16k3OC4y/45yFW8EqFh/hFZ6unXy/fCtB/ZiCPgrZrIh8PW9TASbEdFFbzBjjQ7/RRFwIiaoHbaVPHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769351633; c=relaxed/simple;
	bh=Q666l43IITdXRoaRDN9WaME4ByglguKOboN01FWMscU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XVB0WS1guk3HyQ2+PxxYkauvnt+8z7Dcy6jIZYvvAIKUeo0OALmNFgFa7RrX9RzlPzxlSqfCaZqXNaIkvaZV2ASCpe92s2qXVkmRhbEZWRXphFQgAlQJUCPFJcRqxLwuFnfgxlTZfEnM7TkMssCmdtYbMloaQ4oSzRcjIHJ+mco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEMeSKG0; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-352f60d6c2fso2530370a91.1
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 06:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769351632; x=1769956432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9vrpTgp19j2v2S0F0+kVV2ZQQrhahMGVY6XxldYPxCk=;
        b=DEMeSKG0WiRBHe5OXktvA0bc0Z1acAhoffx86wR5/iO/AILxT5q7ezpvr7h3Lyd5Es
         /r5pSX6DkIB699wuSXiJti5SjGZIQuPwYH0D+DE52J4ndtwsH5+12xf+xZEB3R3RGkJe
         0TrvdvWFK2ICG43KlQgOC6oRYprKe7rPwZHzqOfAByCcC8loSWqXTrEf/RhlMLvyvcyU
         JDxgJ8rVTd8Jc95KzlEY8VxvoTamPqLdjN9XbgRvrZtY1ngSYxE7Zy6W3D3lNBB3+IwQ
         CdR28TSUCwlLwyScD6nQWTA3m5kOI/Lz/1yrLLzAf2A8FiLDdcaH3oO9Y7B3wbK5Zo+C
         spVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769351632; x=1769956432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vrpTgp19j2v2S0F0+kVV2ZQQrhahMGVY6XxldYPxCk=;
        b=ow+P813Mim8JcRSDIwkiDLH8qub5bWyc2oO4gHSyioI+piGv62dItROpMLWYLg6MJB
         72+hqgx4rMCa8QL2vIKzOZN2HSVn41OIgGE8WZ+u9/UEM1zvtKOszo3M6Gt/wgcREyr6
         9/87afxpL2tsSPxMfZFxQSpKlryZtXEjeCyZMdXvuQMvB95xIp42LN9rOHavLMNJccKs
         qYEEHZeR9wIdsny+yipYqZ1UAVgi666B/ihf0u/oXZnOyJZlZrfyxyuToDXnmkbTxqLB
         BeDlkzVAjautQ7V8dYpjC6pYDxA41EO3tl1oHQxpDydga6+3D55/qfqsXUwkrVKrsgjr
         yvsg==
X-Forwarded-Encrypted: i=1; AJvYcCXRUTjyrRxl/3n/YDAMahk3o2h8Pz/btYWNM7ti3knKzEumXE9N+iTCFZ6RVH8lgj4BnyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzosIvW6bkCUeVMQH/XNdy+DuldTtyvarofjSdFaxHeB/wOcv1F
	tVkG2CQbhKnLIibEzZIsWUB6S2LYWuGQd9R4z/7i3eGFhV9FTqjQurOB
X-Gm-Gg: AZuq6aITwTgzVaul2XwdTje+YkIpH6cvir929wwLxfPeVcAxerVO2i4W2nQACNK09Yg
	gs/WGz0NXiPNqZ8f+JTy+WnOpMD+3ifnX5MljOVauAErpXGXGLFd2aLCPLANr8IG0ILLjLD6/Cw
	6US01UAH7VKyi2MBMnQNPWzx+vel4Sy/ohsjVNccOCCh+9RIJrsuH9s0wQVGdOZiE+UJT+WfYSC
	AcoecGYwCrVoPjFWgltWQPZVjvczYv8AfegIG3mr2YK8VtnKwdmnJUw81P68GokYJF3lBHXlzrB
	izPQXyepOPO4IyVbD/4RKybhCW1HVBYuXfSatmA1GwJojPj9Nt4/o3Hn04HpJ/zC+x5SwbgDyhY
	8wV9cRhsqKzJP31t1MMn/tIziqgGvHs6bOGtRbpHpQx7qKutDHXihPl4tMtVLXCB+7E047Qph4H
	tgUeAXzEJdCNYwAuSMEs8k7RoxH+C4qZjjBsPvTW4Bpcnp3Mss06A=
X-Received: by 2002:a17:90b:3d12:b0:340:b908:9665 with SMTP id 98e67ed59e1d1-353c418d276mr1450186a91.37.1769351631814;
        Sun, 25 Jan 2026 06:33:51 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353354a6b06sm9351073a91.10.2026.01.25.06.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 06:33:51 -0800 (PST)
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
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH v4] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()
Date: Sun, 25 Jan 2026 14:33:44 +0000
Message-Id: <20260125143344.2515451-1-xujiakai2025@iscas.ac.cn>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69065-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 024EA80FFB
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
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
V3 -> V4: Fix typo in Signed-off-by email address.
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


