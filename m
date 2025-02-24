Return-Path: <kvm+bounces-38984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE8BA419CD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3268172920
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F862505A3;
	Mon, 24 Feb 2025 09:56:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D946A24A05C;
	Mon, 24 Feb 2025 09:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390985; cv=none; b=oUmd4s+84dghaSPNAXHZ+d5XjNkIHZ52+0oP94iRNK3WF0VqlE9vrynsmdJQ3EKpM/GGb3aw6CASSC/JuxUVaDoQubh6YBpTDiNxlOrXXCupXAXXaG/+mN6mzKN0+bBaEP0ecM62xG6ueM0HXi1wXw+xv0KCjOfqZUtxu4iKN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390985; c=relaxed/simple;
	bh=ELUSK/HZUHvCwY6+pKfb6g9xX5U5riy1F+LdY6xt/HE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JksmWV+X2/Lun5XwesyvteQOc6UhrPSJaYobee3Xm7r3nM9vJB8lINN4d4Tb/M3O0xHADa0eEYaTB3TMV612NXjEgKuSGQPjLmLs/IT/e3YEf8B4UzL91OhW95IFSnf2iq2z09Lrnz+L7bhOQxTOFe9e5PYfR+o8vRuWujzxNVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxbKxEQrxnMK+AAA--.24412S3;
	Mon, 24 Feb 2025 17:56:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVCQrxnRBkmAA--.9703S5;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] LoongArch: KVM: Register perf callback for guest
Date: Mon, 24 Feb 2025 17:56:18 +0800
Message-Id: <20250224095618.1436016-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250224095618.1436016-1-maobibo@loongson.cn>
References: <20250224095618.1436016-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVCQrxnRBkmAA--.9703S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add selection for GUEST_PERF_EVENTS if KVM is enabled, also add perf
callback register when KVM module is loading.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/Kconfig | 1 +
 arch/loongarch/kvm/main.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 97a811077ac3..40eea6da7c25 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select KVM_MMIO
 	select KVM_XFER_TO_GUEST_WORK
 	select SCHED_INFO
+	select GUEST_PERF_EVENTS if PERF_EVENTS
 	help
 	  Support hosting virtualized guest machines using
 	  hardware virtualization extensions. You will need
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f6d3242b9234..4c5af4718182 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -387,6 +387,7 @@ static int kvm_loongarch_env_init(void)
 	}
 
 	kvm_init_gcsr_flag();
+	kvm_register_perf_callbacks(NULL);
 
 	/* Register LoongArch IPI interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
@@ -408,6 +409,7 @@ static void kvm_loongarch_env_exit(void)
 {
 	unsigned long addr;
 
+	kvm_unregister_perf_callbacks();
 	if (vmcs)
 		free_percpu(vmcs);
 
-- 
2.39.3


