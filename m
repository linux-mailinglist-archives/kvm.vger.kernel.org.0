Return-Path: <kvm+bounces-56552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1052FB3FB26
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E021B236D8
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25952EE29D;
	Tue,  2 Sep 2025 09:49:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC96C26C3BC;
	Tue,  2 Sep 2025 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806596; cv=none; b=HNjRIQ4Mr5PBrZBmTXgnIL+BYHWrC/Zeu5isnkZ7JHNXNFPGAA/DRfymVvBH+O/vq4vn5pXFYf5L+rlmUldFnds2uNgdxGcBs270C/F/Td1/cpSONZpD8GYNSYWJw49dmSK8RMPQP/IKmtPDSmiAAJW6HNV8nTS0XTkgeITaXGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806596; c=relaxed/simple;
	bh=qDBmOcP+XOuVrP1ygysuiCgilhmxVMQXhVk+di7eWqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tz4ULYcWm2/kvksNdd00L9SpXiP+DRnHJkQWYkIFSZ5BZV3+H4gVTbUDhPZHRhLqz/WPDMj4hpGRCvV8HJVNVCy3XdQzhO1m0OMyZZRf0NqNXNBNVlMyqFTLRq0k7TwtEr8y7CERO+9IRUVlIFI4hXG7/T3NFwqnFgyD7yNHqHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxvdK6vbZoY7wFAA--.11804S3;
	Tue, 02 Sep 2025 17:49:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8O5vbZoyLF4AA--.52017S3;
	Tue, 02 Sep 2025 17:49:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] LoongArch: KVM: Avoid use copy_from_user with lock hold in kvm_eiointc_regs_access
Date: Tue,  2 Sep 2025 17:49:42 +0800
Message-Id: <20250902094945.2957566-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250902094945.2957566-1-maobibo@loongson.cn>
References: <20250902094945.2957566-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8O5vbZoyLF4AA--.52017S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Otherwise there
will be possible warning such as:

BUG: sleeping function called from invalid context at include/linux/uaccess.h:192
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6292, name: qemu-system-loo
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
softirqs last  enabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 41 UID: 0 PID: 6292 Comm: qemu-system-loo Tainted: G W 6.17.0-rc3+ #31 PREEMPT(full)
Tainted: [W]=WARN
Stack : 0000000000000076 0000000000000000 9000000004c28264 9000100092ff4000
        9000100092ff7b80 9000100092ff7b88 0000000000000000 9000100092ff7cc8
        9000100092ff7cc0 9000100092ff7cc0 9000100092ff7a00 0000000000000001
        0000000000000001 9000100092ff7b88 947d2f9216a5e8b9 900010008773d880
        00000000ffff8b9f fffffffffffffffe 0000000000000ba1 fffffffffffffffe
        000000000000003e 900000000825a15b 000010007ad38000 9000100092ff7ec0
        0000000000000000 0000000000000000 9000000006f3ac60 9000000007252000
        0000000000000000 00007ff746ff2230 0000000000000053 9000200088a021b0
        0000555556c9d190 0000000000000000 9000000004c2827c 000055556cfb5f40
        00000000000000b0 0000000000000007 0000000000000007 0000000000071c1d
Call Trace:
[<9000000004c2827c>] show_stack+0x5c/0x180
[<9000000004c20fac>] dump_stack_lvl+0x94/0xe4
[<9000000004c99c7c>] __might_resched+0x26c/0x290
[<9000000004f68968>] __might_fault+0x20/0x88
[<ffff800002311de0>] kvm_eiointc_regs_access.isra.0+0x88/0x380 [kvm]
[<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
[<900000000506b0d8>] sys_ioctl+0x388/0x1010
[<90000000063ed210>] do_syscall+0xb0/0x2d8
[<9000000004c25ef8>] handle_syscall+0xb8/0x158

Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 33 ++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 026b139dcff2..2fb5b9c6e8ad 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -462,19 +462,17 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 
 static int kvm_eiointc_regs_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr,
-					bool is_write)
+					bool is_write, int *data)
 {
 	int addr, cpu, offset, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
-	void __user *data;
 	struct loongarch_eiointc *s;
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
 	cpu = addr >> 16;
 	addr &= 0xffff;
-	data = (void __user *)attr->addr;
 	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		offset = (addr - EIOINTC_NODETYPE_START) / 4;
@@ -513,13 +511,10 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 	}
 
 	spin_lock_irqsave(&s->lock, flags);
-	if (is_write) {
-		if (copy_from_user(p, data, 4))
-			ret = -EFAULT;
-	} else {
-		if (copy_to_user(data, p, 4))
-			ret = -EFAULT;
-	}
+	if (is_write)
+		memcpy(p, data, 4);
+	else
+		memcpy(data, p, 4);
 	spin_unlock_irqrestore(&s->lock, flags);
 
 	return ret;
@@ -576,9 +571,18 @@ static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 static int kvm_eiointc_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
+	int ret, data;
+
 	switch (attr->group) {
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
-		return kvm_eiointc_regs_access(dev, attr, false);
+		ret = kvm_eiointc_regs_access(dev, attr, false, &data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)attr->addr, &data, 4))
+			ret = -EFAULT;
+
+		return ret;
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
 		return kvm_eiointc_sw_status_access(dev, attr, false);
 	default:
@@ -589,11 +593,16 @@ static int kvm_eiointc_get_attr(struct kvm_device *dev,
 static int kvm_eiointc_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
+	int data;
+
 	switch (attr->group) {
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
 		return kvm_eiointc_ctrl_access(dev, attr);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
-		return kvm_eiointc_regs_access(dev, attr, true);
+		if (copy_from_user(&data, (void __user *)attr->addr, 4))
+			return -EFAULT;
+
+		return kvm_eiointc_regs_access(dev, attr, true, &data);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
 		return kvm_eiointc_sw_status_access(dev, attr, true);
 	default:
-- 
2.39.3


