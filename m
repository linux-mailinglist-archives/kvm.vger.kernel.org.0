Return-Path: <kvm+bounces-60009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF947BD8982
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A26975430F3
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B192F5322;
	Tue, 14 Oct 2025 09:51:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0172D9492;
	Tue, 14 Oct 2025 09:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760435462; cv=none; b=peH7ttZi+ll8Zr3v0cgNe0C/eD5kQ/oBech37qxUNR9tJDPCwNSTNDQfwifPTdqODh73l+KECiJtde0tqBjujLbMaCngNfZuMOxCXuNUUtLIpBBzlm4o/moMkgLK6Pk3xRM9ZFr8jdQatliKZEqUBu/9/6Y7yXtMQLpwHx4Y0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760435462; c=relaxed/simple;
	bh=KHz1B1HQJgmAT3g5P4keVtakO0U0qrIOmzuBpaoJnlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jT3GbjwiFVB2iLQ+zHUXw2JKY0ZVfJ7Q8UBl+nyTY+mRcuQNRon3sjSeQgQmceP9d/UVxui+Mi8K4jDmvgdAp8Ccn/hdQ0JgMqW9sDL0iidzfnmMN0s2i70pOe0cgXpFHEy0HhufjfYIkYZ42/L+fjBm/Z6iPwV4HXTmqAUXcRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cxbb8BHe5oyfYVAA--.46014S3;
	Tue, 14 Oct 2025 17:50:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxTMEBHe5o+V3hAA--.48048S2;
	Tue, 14 Oct 2025 17:50:57 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Fix max supported vCPUs set with eiointc
Date: Tue, 14 Oct 2025 17:50:55 +0800
Message-Id: <20251014095055.1159534-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxTMEBHe5o+V3hAA--.48048S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

VM fails to boot with 256 vCPUs, the detailed command is
qemu-system-loongarch64 -smp 256 and there is error reported as follows:
  KVM_LOONGARCH_EXTIOI_INIT_NUM_CPU failed: Invalid argument

There is typo issue in function kvm_eiointc_ctrl_access() when set
max supported vCPUs.

Cc: stable@vger.kernel.org
Fixes: 47256c4c8b1b ("LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_ctrl_access()")

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index c32333695381..a1cc116b4dac 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -439,7 +439,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 	spin_lock_irqsave(&s->lock, flags);
 	switch (type) {
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
-		if (val >= EIOINTC_ROUTE_MAX_VCPUS)
+		if (val > EIOINTC_ROUTE_MAX_VCPUS)
 			ret = -EINVAL;
 		else
 			s->num_cpu = val;

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.39.3


