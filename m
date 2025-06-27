Return-Path: <kvm+bounces-50967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03996AEB213
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3433B32A6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710A4293C48;
	Fri, 27 Jun 2025 09:05:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2F429A9CB;
	Fri, 27 Jun 2025 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015123; cv=none; b=Rokrx3+geMUHF+uuEy7/iqubqaCI1W4k8jxEPE72DmsCabkxwjxZDVB22HI0OYoo7Peuf6BHK28cZxxHHjT7nHel8KMjY7M6DNA9RIvsJX/6qATpWELL6LSMJwXgxuS8Mz2Rykhky1OuTOuJn5VU57EjkaGhL8uGztrZWx3DMrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015123; c=relaxed/simple;
	bh=Yumj2jjL7iMEr2PCocQWVhhCzYR+wpPVl0HIRFGclQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oS7LTaZB/AMCGtsx7jgDW0MXGJedDuBkcFkbBva8I4zjzkodM8DSwORuRvZYiY0a/dvlVaH3773l9s2OA6K6qW3PYMX2H22SCfAwAcgTQFrFH2yvYOsGdIG++HNoeHQS7fMVn0cGmLM/OuCeYGVZwmyAsBxW4x78cT8flipA6s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Ax3eLJXl5oUDIeAQ--.28658S3;
	Fri, 27 Jun 2025 17:05:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxM+TEXl5ovCsAAA--.1247S6;
	Fri, 27 Jun 2025 17:05:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4 4/6] LoongArch: KVM: Check validation of num_cpu from user space
Date: Fri, 27 Jun 2025 17:05:05 +0800
Message-Id: <20250627090507.808319-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250627090507.808319-1-maobibo@loongson.cn>
References: <20250627090507.808319-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxM+TEXl5ovCsAAA--.1247S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
irqchip eiointc, here add validation about cpu number to avoid array
pointer overflow.

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index b48511f903b5..169fe1de2c92 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 	int ret = 0;
 	unsigned long flags;
 	unsigned long type = (unsigned long)attr->attr;
-	u32 i, start_irq;
+	u32 i, start_irq, val;
 	void __user *data;
 	struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
 
@@ -806,8 +806,14 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 	spin_lock_irqsave(&s->lock, flags);
 	switch (type) {
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
-		if (copy_from_user(&s->num_cpu, data, 4))
+		if (copy_from_user(&val, data, 4))
 			ret = -EFAULT;
+		else {
+			if (val < EIOINTC_ROUTE_MAX_VCPUS)
+				s->num_cpu = val;
+			else
+				ret = -EINVAL;
+		}
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
 		if (copy_from_user(&s->features, data, 4))
@@ -835,7 +841,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr,
 					bool is_write)
 {
-	int addr, cpuid, offset, ret = 0;
+	int addr, cpu, offset, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
 	void __user *data;
@@ -843,7 +849,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
-	cpuid = addr >> 16;
+	cpu = addr >> 16;
 	addr &= 0xffff;
 	data = (void __user *)attr->addr;
 	switch (addr) {
@@ -868,8 +874,11 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 		p = &s->isr.reg_u32[offset];
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		if (cpu >= s->num_cpu)
+			return -EINVAL;
+
 		offset = (addr - EIOINTC_COREISR_START) / 4;
-		p = &s->coreisr.reg_u32[cpuid][offset];
+		p = &s->coreisr.reg_u32[cpu][offset];
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
 		offset = (addr - EIOINTC_COREMAP_START) / 4;
-- 
2.39.3


