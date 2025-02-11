Return-Path: <kvm+bounces-37774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD59A30144
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5407D3A012F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7462D1D5ABA;
	Tue, 11 Feb 2025 02:01:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F305D154BE0;
	Tue, 11 Feb 2025 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239290; cv=none; b=B2BI9TCWcKBGMKQwvm/FYv0CDRLnsSP3BujKavJXWF3azog5G79J7JuGRCQmIyN/bDMOdtNWC83ulTkdFyF6sQQZsm0WhIksy8wXD5C+hppJXHRxoz6p1q6QaUPDTRP0pmOgCS35/0z5t3itfHOobcTfOPnwhyTX7jP4IKTrIBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239290; c=relaxed/simple;
	bh=02FGwJ1b4L+Qmh0mt8jK4ZSLOxYlbCsmrNC1feJZQn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LIy3X2Bss80q89FHsrSOGYDq96QhNsoAFRO+pejLhF0xH/mswAIP3AbOdAaptZgBujvhXXOWR6uPLvumnJbFwp3m/siwD1BgYheLwpPUhWS55ec19UoO7VkacbjtDpn0XbEzN18W3JZZkjd6dQihKg3kyIxo8WQDNnH4Z0OfVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxfWtwr6pnr85xAA--.1556S3;
	Tue, 11 Feb 2025 10:01:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLsdur6pnLz8LAA--.44545S4;
	Tue, 11 Feb 2025 10:01:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] LoongArch: KVM: Remove duplicated cache attribute setting
Date: Tue, 11 Feb 2025 10:01:17 +0800
Message-Id: <20250211020118.3275874-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250211020118.3275874-1-maobibo@loongson.cn>
References: <20250211020118.3275874-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsdur6pnLz8LAA--.44545S4
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


