Return-Path: <kvm+bounces-57586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E28C8B580E1
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17CD43A13BE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 15:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FBFC237180;
	Mon, 15 Sep 2025 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QfjXwgF9"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08861F03EF;
	Mon, 15 Sep 2025 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757950305; cv=none; b=FLuokYeBEW3gqvTcRey2YSdSkrI/NEwHYaoUWA5mJrmNf4TH2109vq1jE2SV32m4kDvhy1MsfGyyU6UY6/hljiwez7L5+Qv6/HBEsg0EcFWVDZWzzMFym0U3tUPwbtmDODBfIXKj5VZ6YlIIxq6wduhvpQnzpuuaHJNkhFWU1eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757950305; c=relaxed/simple;
	bh=xFf6IpUiT4a68YU9TMKvTme9+9mDoF2kUiQ1yGFEmEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aSGun2uJzEzEyCWA5zSOj4nQpw3DlgtWoz+KhzTJzsOoWD0jVtY22a7NUOWCMBdGqaOOFFjqd9ix6ysRjeuhAgbBmXuG1el2kefhnXa4Nn9Oxdl8JTV3qNvyXOcz28HJ6n6YUG+uP8E6kWTJ9GvPDnKMp3ZcRGy6EoqXr5KY39c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QfjXwgF9; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2Z
	MhoW1DNs7CX4cb16cWpeKngS2s2Gd2rkB8a0nMfaU=; b=QfjXwgF9hRiVp/8zHs
	1XR7KqjVOiZ52kFXVwRkLoh5NBsTzbaFxcjZFvTyMw7unAu6olB4TBKRg7N0T8Nq
	ce7iCLX51qU6LDSmTD0YQqx+3t3jdxs/l17WyQURh4NlydJLSwbSXqvUuYiEfSvB
	d3d5Rs0zve3upTjVJBjlxlJ9w=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCnk+BnMMho_C9hDA--.18834S2;
	Mon, 15 Sep 2025 23:27:36 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Radim Krcmar <rkrcmar@ventanamicro.com>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>,
	Tianshun Sun <stsmail163@163.com>
Subject: [RFC PATCH] kvm/riscv: Add ctxsstatus and ctxhstatus for migration
Date: Mon, 15 Sep 2025 23:27:31 +0800
Message-ID: <20250915152731.1371067-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCnk+BnMMho_C9hDA--.18834S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAryxJw4ruw47ZF4DZF17Awb_yoW5uFy7pF
	ZakwsY9rW0qrWSka42kF4qgry5W3s5G34akr92qry5ZF4UtF4rZrs5K3y5AFyDJFWrXFn2
	kFyrtF18Can0q37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiTg3JeGjIGXU-ywAEsO

When migrating a VM which guest running in user mode 
(e.g., executing a while(1) application), the target 
VM fails to run because it loses the information of 
guest_context.hstatus and guest_context.sstatus. The 
VM uses the initialized values instead of the correct ones.

This patch adds two new context registers (ctxsstatus and 
ctxhstatus) to the kvm_vcpu_csr structure and implements 
the necessary KVM get and set logic to preserve these values 
during migration.

QEMU needs to be updated to support these new registers.
See https://github.com/tjy-zhu/qemu
for the corresponding QEMU changes.

I'm not sure if adding these CSR registers is a right way. RISCV
KVM doesn't have API to save these two context csrs now. I will
submit the corresponding QEMU patch to the QEMU community if
KVM has API to get and set them.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
Tested-by: Tianshun Sun <stsmail163@163.com>
---
 arch/riscv/include/asm/kvm_host.h |  2 ++
 arch/riscv/include/uapi/asm/kvm.h |  2 ++
 arch/riscv/kvm/vcpu_onereg.c      | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d71d3299a..55604b075 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -161,6 +161,8 @@ struct kvm_vcpu_csr {
 	unsigned long vsatp;
 	unsigned long scounteren;
 	unsigned long senvcfg;
+	unsigned long ctxsstatus;
+	unsigned long ctxhstatus;
 };
 
 struct kvm_vcpu_config {
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index ef27d4289..cd7d7087f 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -81,6 +81,8 @@ struct kvm_riscv_csr {
 	unsigned long satp;
 	unsigned long scounteren;
 	unsigned long senvcfg;
+	unsigned long ctxsstatus;
+	unsigned long ctxhstatus;
 };
 
 /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index cce6a38ea..284ee6e81 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -489,6 +489,12 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
 		return -ENOENT;
 
+	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxsstatus))
+		csr->ctxsstatus = vcpu->arch.guest_context.sstatus;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxhstatus))
+		csr->ctxhstatus = vcpu->arch.guest_context.hstatus;
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
 		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
@@ -515,6 +521,16 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 
 	((unsigned long *)csr)[reg_num] = reg_val;
 
+	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxsstatus)) {
+		if (csr->ctxsstatus != 0)
+			vcpu->arch.guest_context.sstatus = csr->ctxsstatus;
+	}
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxhstatus)) {
+		if (csr->ctxhstatus != 0)
+			vcpu->arch.guest_context.hstatus = csr->ctxhstatus;
+	}
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
 		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
 
-- 
2.43.0


