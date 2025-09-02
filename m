Return-Path: <kvm+bounces-56551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF3AB3FB24
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D451206CDF
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D535A2EE5F0;
	Tue,  2 Sep 2025 09:49:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB912E1C63;
	Tue,  2 Sep 2025 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806596; cv=none; b=QD5QaqfC87n8Ym39IKo8Qp9PZ+m1Pb/vyxWEyxqLYKbC3RNIsOStU6efErF06uXb6Z6OUgHRJyRBELDRSzN0F6cig0VUdTjH/Pa7hX3nxs65Vd548PU5PWKA4yMKoay4domuUTAnclT34YuFKEfzHprf98iaJzj7rldoIaKVWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806596; c=relaxed/simple;
	bh=t5Jxn8Sa2bO5xHXxndFR2KqI7omi92kX7+6D8B3jBX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V9ynUYTjULcUl/O/yavzLgAMuTq46QO433sGZ6Y/B0WfIFOc6tXsMmgWkXDyQbcXjpnh62O9tuOebuaKNT2wt78W9y4bwzS4Ta3EpvS2d/SgnJ61j96bv3Jy6zVJFzaQ1S8tIhFdjNqxY+ZxtR1XrsSgjPWmT5ESoZ2vyxQ1l40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx5tC7vbZoZrwFAA--.11905S3;
	Tue, 02 Sep 2025 17:49:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8O5vbZoyLF4AA--.52017S4;
	Tue, 02 Sep 2025 17:49:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] LoongArch: KVM: Avoid use copy_from_user with lock hold in kvm_eiointc_sw_status_access
Date: Tue,  2 Sep 2025 17:49:43 +0800
Message-Id: <20250902094945.2957566-3-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJDx_8O5vbZoyLF4AA--.52017S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
funtcion calling with copy_from_user() and copy_to_user() out of function
kvm_eiointc_sw_status_access().

Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 2fb5b9c6e8ad..dd0477faf8e0 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -522,19 +522,17 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 
 static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr,
-					bool is_write)
+					bool is_write, int *data)
 {
 	int addr, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
-	void __user *data;
 	struct loongarch_eiointc *s;
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
 	addr &= 0xffff;
 
-	data = (void __user *)attr->addr;
 	switch (addr) {
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
 		if (is_write)
@@ -556,13 +554,10 @@ static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 		return -EINVAL;
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
@@ -584,7 +579,14 @@ static int kvm_eiointc_get_attr(struct kvm_device *dev,
 
 		return ret;
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
-		return kvm_eiointc_sw_status_access(dev, attr, false);
+		ret = kvm_eiointc_sw_status_access(dev, attr, false, &data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)attr->addr, &data, 4))
+			ret = -EFAULT;
+
+		return ret;
 	default:
 		return -EINVAL;
 	}
@@ -604,7 +606,10 @@ static int kvm_eiointc_set_attr(struct kvm_device *dev,
 
 		return kvm_eiointc_regs_access(dev, attr, true, &data);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
-		return kvm_eiointc_sw_status_access(dev, attr, true);
+		if (copy_from_user(&data, (void __user *)attr->addr, 4))
+			return -EFAULT;
+
+		return kvm_eiointc_sw_status_access(dev, attr, true, &data);
 	default:
 		return -EINVAL;
 	}
-- 
2.39.3


