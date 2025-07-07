Return-Path: <kvm+bounces-51639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F913AFAA63
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A4011897B55
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE66725A320;
	Mon,  7 Jul 2025 03:51:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD191BD9F0;
	Mon,  7 Jul 2025 03:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860314; cv=none; b=XNjUj2q53SiExEUg9SlLzILw51kSIT4/yFFxmaM2eU1QGnR4qhyWth4HGALWMC/EG3bJ45swdzQc1zoCINp+bSSxzEDRIznz5z2Iaj6KENCRt3G5oq/uI5WJK3uHBN1FZ2o+ILsgqoG3UjpXOYSqJV0L7QxLU4/jWT4W3Xk1418=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860314; c=relaxed/simple;
	bh=Y5A6Iyc032Pc2f/tiQhfEjDTEEYWG84EtKu1fDLhGIg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gCRKthNjJIzgdmniD6JLwhOVV1vAZlJMKtLYYIEP7qSU2xjM3+TVHZFtmJ/abKO68rvfSilE5Jkb8HzxgJax5jcSFjJQiao2tKbI3bNhwD6cFJ2cd16GmzweqWF8k5xAy7JeOAHZzQUdUj2tH4lBzhtuWRjakNwimjNtXzq8yV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxbKxURGtoZEkjAQ--.10962S3;
	Mon, 07 Jul 2025 11:51:48 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxM+RPRGtoZlsMAA--.6231S2;
	Mon, 07 Jul 2025 11:51:44 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add some feature detection on host with 3C6000
Date: Mon,  7 Jul 2025 11:51:43 +0800
Message-Id: <20250707035143.1979013-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxM+RPRGtoZlsMAA--.6231S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With 3C6000 hardware platform, hardware page table walking and avec
features are supported on host. Here add these two feature detection
on KVM host.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h | 2 ++
 arch/loongarch/kvm/vm.c               | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 5f354f5c6847..0b9feb6c0d53 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -103,6 +103,8 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PMU		5
 #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
+#define  KVM_LOONGARCH_VM_FEAT_PTW		8
+#define  KVM_LOONGARCH_VM_FEAT_AVEC		9
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index edccfc8c9cd8..728b24a62f1e 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -146,6 +146,14 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 		if (kvm_pvtime_supported())
 			return 0;
 		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_PTW:
+		if (cpu_has_ptw)
+			return 0;
+		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_AVEC:
+		if (cpu_has_avecint)
+			return 0;
+		return -ENXIO;
 	default:
 		return -ENXIO;
 	}
-- 
2.39.3


