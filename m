Return-Path: <kvm+bounces-56553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E34FCB3FB2A
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72FDE1B2393E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52CA2F068F;
	Tue,  2 Sep 2025 09:49:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CF62ED868;
	Tue,  2 Sep 2025 09:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806597; cv=none; b=Kpx8AGSetYA8wV5yseBuIcSBOmThN1Yf0mx6CtCzHQNt13ZUg2vzdZ5WyNg/kVG/hplOd+Eag3Vy3UUh5Vrmf/s+GvT9MlAXPnIF/GpDKsKeEzH1TyHUi92+qh1jRwdd9m8M0AEP+dk8H37fn4sRd7WZa5WynNHVFaIDMBHADoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806597; c=relaxed/simple;
	bh=z5uZYXhvEjiGR7QHSxTlRcst1/kJMJa9LioZmKuZe6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GLVCabTo6cAzPcld8oc5W+tvgl3//99pba9wicrPob77DEKmQnLFMfaX1XU3VkAeWAh9pFhIs/4gXnBaL3+wHcs/euda1QnrRf45i1cYDDvDCrXQ8IensVMW/DoecXuenAZpD0H5TjK2bYCf+RRMkD1oYUQwZ27h9sRiequhBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxHvC7vbZoa7wFAA--.11905S3;
	Tue, 02 Sep 2025 17:49:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8O5vbZoyLF4AA--.52017S5;
	Tue, 02 Sep 2025 17:49:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] LoongArch: KVM: Avoid use copy_from_user with lock hold in kvm_eiointc_ctrl_access
Date: Tue,  2 Sep 2025 17:49:44 +0800
Message-Id: <20250902094945.2957566-4-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJDx_8O5vbZoyLF4AA--.52017S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
function calling with copy_from_user() and copy_to_user() before spinlock
context in function kvm_eiointc_ctrl_access().

Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index dd0477faf8e0..c32333695381 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -426,21 +426,26 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 	struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
 
 	data = (void __user *)attr->addr;
-	spin_lock_irqsave(&s->lock, flags);
 	switch (type) {
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
 		if (copy_from_user(&val, data, 4))
-			ret = -EFAULT;
-		else {
-			if (val >= EIOINTC_ROUTE_MAX_VCPUS)
-				ret = -EINVAL;
-			else
-				s->num_cpu = val;
-		}
+			return -EFAULT;
+		break;
+	default:
+		break;
+	}
+
+	spin_lock_irqsave(&s->lock, flags);
+	switch (type) {
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
+		if (val >= EIOINTC_ROUTE_MAX_VCPUS)
+			ret = -EINVAL;
+		else
+			s->num_cpu = val;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
-		if (copy_from_user(&s->features, data, 4))
-			ret = -EFAULT;
+		s->features = val;
 		if (!(s->features & BIT(EIOINTC_HAS_VIRT_EXTENSION)))
 			s->status |= BIT(EIOINTC_ENABLE);
 		break;
-- 
2.39.3


