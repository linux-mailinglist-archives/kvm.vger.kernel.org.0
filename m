Return-Path: <kvm+bounces-44075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C14A9A285
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 893C444049E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83E31E7C11;
	Thu, 24 Apr 2025 06:46:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5C74A29;
	Thu, 24 Apr 2025 06:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477191; cv=none; b=r2lnQ0eTp+4Rc78y9+W0IbEpGZ2A1Kk0pzTXMPfG8YpXemXeG5v05JJYnvoFlKbRqBKB5zdyeFmi8BWqUEHP3UT6ayjXcJW3TZwZBteJK7+w2vzNQt2+BAOhQICWpZQ5HmJlTuhuXYyLmiqKh++q6ON3VEGDVBbcEbHN+naMBkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477191; c=relaxed/simple;
	bh=V5PXF6w8St5Paxz9hyNzBo921xWGoUUg1XW8O7Zmiuo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hBQ+TpPJNTdVU/t3/1cSZeimpwMESo5lfxr8wp5ccPhsLYSKM3ZI2/a+PrahQnJXzGbiAoBRCiv/8Sv6aUfjJXHtPgPm7uKoePXqx6PrIH/xBbydcdn/buEexZYnvCXI71t3dXhNt1h1ss6kn63gmg/flv0tPgaXuoYRWsdC19o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxaeBC3gloih_FAA--.533S3;
	Thu, 24 Apr 2025 14:46:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVB3gloABqTAA--.39186S2;
	Thu, 24 Apr 2025 14:46:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] LoongArch: KVM: Do not flush tlb if HW PTW supported
Date: Thu, 24 Apr 2025 14:46:23 +0800
Message-Id: <20250424064625.3928278-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVB3gloABqTAA--.39186S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With HW PTW supported, stale TLB is not added if page fault happens. With
EXCCODE_TLBM exception, stale TLB may exist because last read access, tlb
flush operation is necessary with EXCCODE_TLBM exception, and not necessary
with other memory page fault exceptions.

With SW PTW supported, invalid TLB is added in TLB refill exception.
TLB flush operation is necessary with all page fault exceptions.

Bibo Mao (2):
  LoongArch: KVM: Add parameter exception code with exception handler
  LoongArch: KVM: Do not flush tlb if HW PTW supported

 arch/loongarch/include/asm/kvm_host.h |  2 +-
 arch/loongarch/include/asm/kvm_vcpu.h |  2 +-
 arch/loongarch/kvm/exit.c             | 34 +++++++++++++--------------
 arch/loongarch/kvm/mmu.c              | 17 ++++++++++----
 4 files changed, 31 insertions(+), 24 deletions(-)


base-commit: 9d7a0577c9db35c4cc52db90bc415ea248446472
-- 
2.39.3


