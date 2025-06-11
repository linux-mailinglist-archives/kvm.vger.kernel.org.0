Return-Path: <kvm+bounces-48945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8E3AD4836
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFFFB189FFF4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EE21A5B88;
	Wed, 11 Jun 2025 01:47:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88E4191F95;
	Wed, 11 Jun 2025 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606431; cv=none; b=j1AIYk0MlS3UV/3sbv0JAncrjIQUyAjPRbMz+3iP6RA32NJ9epN6HZ8bU2PxLwtf+tjAckso8Ttx86anDTUcxp9sJbx//gViiftQhW4JXRhMP+ggBhPpS8FX4nVZNMNPOyFWsG6NkK/pjgFunzAoc9/o7UzkpgL/U6opR1/8WVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606431; c=relaxed/simple;
	bh=uD27TLOkmLE97SKX+m1nAjFPEUD7oQ+EyEzUgNGPZHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l9YBYNoSj00xQuUi4fesUCE+DKFEJbkHtEFTnfUh6hBhyp/O2ndG2X3C2yoqSi/pqlb6uf4OOUxviM4aQftvwyXdVWyaoTcj+PVPpBP2gT4Mzi4EnnkXqqKQCR7YcLArbvyoEckf4cLqI+hrs8VAgUrZ1JZ8Azb2rZ0ebbl4CDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxYa8a4EhoqUITAQ--.7282S3;
	Wed, 11 Jun 2025 09:47:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx7MQL4Eho0EoVAQ--.65102S5;
	Wed, 11 Jun 2025 09:47:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 3/9] LoongArch: KVM: INTC: Disable update property num_cpu and feature
Date: Wed, 11 Jun 2025 09:46:45 +0800
Message-Id: <20250611014651.3042734-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250611014651.3042734-1-maobibo@loongson.cn>
References: <20250611014651.3042734-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx7MQL4Eho0EoVAQ--.65102S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Property num_cpu and feature is read-only once eiointc is created, which
is set with KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL attr group before device
creation.

Attr group KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS is to update register
and software state for migration and reset usage, property num_cpu and
feature can not be update again if it is created already.

Here discard write operation with property num_cpu and feature in attr
group KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL.

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 0b648c56b0c3..b48511f903b5 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -910,9 +910,22 @@ static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 	data = (void __user *)attr->addr;
 	switch (addr) {
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
+		/*
+		 * Property num_cpu and feature is read-only once eiointc is
+		 * created with KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL group API
+		 *
+		 * Disable writing with KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS
+		 * group API
+		 */
+		if (is_write)
+			return ret;
+
 		p = &s->num_cpu;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE:
+		if (is_write)
+			return ret;
+
 		p = &s->features;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE:
-- 
2.39.3


