Return-Path: <kvm+bounces-55720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DBEB3523B
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 05:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EFA31A85FC6
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 03:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E752A2D3237;
	Tue, 26 Aug 2025 03:35:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDD28488;
	Tue, 26 Aug 2025 03:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756179327; cv=none; b=EBjxaPnlPO41EHUWYmY1mDSoHz17pUCbdy2wI6aemnG+GdjlgAHH3cbx7r+hDzETfDC7Dw2s5vCXVrYzwm1ody7+7r2RlemviTDZc8AGbQ8aBeXX/aJ3sih3n7tSSQUm50cRDWYZ1itxZmydPr68jVWwRO9pwiQu/mhXfN0kMuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756179327; c=relaxed/simple;
	bh=sDhlohnrPL8I0WbEhOXUdn5nk2jOSqoE8tewhBzI8OA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lYy3Hfn5jL40yUUXlCAd7KgapCJiXU7vXMeQhqFlCB6etd4FXx+bTMttVYEObcb8winbL59u2XVIW/17vfi5//LtazVnghhMn158sZ+kluUl06cAioJLjIzNNzodu3plY2+S/Ghd54apnOfslzNN/TUEgygHP/jHnM2oY85Tmc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dxfb9zK61oszQDAA--.5086S3;
	Tue, 26 Aug 2025 11:35:15 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxvsFzK61oLh9pAA--.21747S2;
	Tue, 26 Aug 2025 11:35:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add PTW feature detection on 3C6000 host
Date: Tue, 26 Aug 2025 11:35:14 +0800
Message-Id: <20250826033514.972480-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxvsFzK61oLh9pAA--.21747S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With 3C6000 hardware platform, hardware page table walking(PTW) features
is supported on host. Here add this feature detection on KVM host.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h | 1 +
 arch/loongarch/kvm/vcpu.c             | 2 ++
 arch/loongarch/kvm/vm.c               | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 5f354f5c6847..57ba1a563bb1 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -103,6 +103,7 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PMU		5
 #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
+#define  KVM_LOONGARCH_VM_FEAT_PTW		8
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index ce478151466c..9c802f7103c6 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -680,6 +680,8 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 			*v |= CPUCFG2_ARMBT;
 		if (cpu_has_lbt_mips)
 			*v |= CPUCFG2_MIPSBT;
+		if (cpu_has_ptw)
+			*v |= CPUCFG2_PTW;
 
 		return 0;
 	case LOONGARCH_CPUCFG3:
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index edccfc8c9cd8..a49b1c1a3dd1 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -146,6 +146,10 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 		if (kvm_pvtime_supported())
 			return 0;
 		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_PTW:
+		if (cpu_has_ptw)
+			return 0;
+		return -ENXIO;
 	default:
 		return -ENXIO;
 	}
-- 
2.39.3


