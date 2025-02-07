Return-Path: <kvm+bounces-37555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C171A2B9B7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CC0A18899B6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD3818DB02;
	Fri,  7 Feb 2025 03:26:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985EE17AE1D;
	Fri,  7 Feb 2025 03:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738898806; cv=none; b=P9Bt5O6aE0Z6ftiYLE9GUAXh2iNsUtpmbs7qrbJV4xVGjeILv8glmi7A543ZuqvjqexaPQ1e7gOjHjfWnTGOXimvbwc2P9qVgFUXOCOWizlg7ehQ5yYTKc6/Q6ZH7Fyzr7hLQ0WcJk46E7UihEmQ7A+7ckB2p5pAWFdSo2O63Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738898806; c=relaxed/simple;
	bh=02FGwJ1b4L+Qmh0mt8jK4ZSLOxYlbCsmrNC1feJZQn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mo5RkZo2QDjq8oZhwKwnx4TzpVsRsjfw21dsZw2XoVnILVnSBTxEbqqdiwdKFoKug9mo7hE4mdT5EsZRajooz7PHFHpKezMz4Xk0qXvF8un+Uw0vA/TmJFGnJIJfgPtqDPTDRCIBi8Y99hd5DQ2nErwc/zqLVf6/rv4wUk7+KK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dxfa9rfaVnPjFuAA--.59786S3;
	Fri, 07 Feb 2025 11:26:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx_MRqfaVn0JsDAA--.12326S4;
	Fri, 07 Feb 2025 11:26:35 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] LoongArch: KVM: Remove duplicated cache attribute setting
Date: Fri,  7 Feb 2025 11:26:33 +0800
Message-Id: <20250207032634.2333300-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250207032634.2333300-1-maobibo@loongson.cn>
References: <20250207032634.2333300-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx_MRqfaVn0JsDAA--.12326S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Cache attribute comes from GPA->HPA secondary mmu page table and is
configured when kvm is enabled. It is the same for all VMs, remove
duplicated cache attribute setting on vCPU context switch.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index fb72095c8077..20f941af3e9e 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1548,9 +1548,6 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Restore timer state regardless */
 	kvm_restore_timer(vcpu);
-
-	/* Control guest page CCA attribute */
-	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 	/* Restore hardware PMU CSRs */
-- 
2.39.3


