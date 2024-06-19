Return-Path: <kvm+bounces-19938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE90E90E545
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ACABB22871
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5FF78C83;
	Wed, 19 Jun 2024 08:09:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1174763FD;
	Wed, 19 Jun 2024 08:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784593; cv=none; b=KcvRXVa6EVJwl5xGP9nKPq3zIkgAAD31lCaaTCosiq7BePFAVRkG9UAR/2wPRr6kdYJZHEdaSNZP4X8tROyUKSUl8e5GXTGnaFOhJBi2/NA0uK+qsubS+Ymm2WHqd/RBDyvA53k6OJTxQ6FHoMpAmGJRPhFyzD5bD2wUXPaIE54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784593; c=relaxed/simple;
	bh=ucv3KYT8GmcqLA6tPY2/YUBms/UIyzv/AoH2wW1Qt9w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r7DHAcRLmigjFd8ea+3G1fnR2J+3LPE26j8IuS+zd9M19p7mqXNer2+xIN2kSj5ihEorTDUpH9xxQiw0Q9WdSGAGIUpVIvV3+nOCQZTLPdJAHTulZdjClQpqJD8jBwaRpa7V16bNOm7wVvKanTp3JcTAUeTpmDt/AAqk7Pag1Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrOpFknJm3S4IAA--.32924S3;
	Wed, 19 Jun 2024 16:09:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjsdEknJmFeMoAA--.32907S2;
	Wed, 19 Jun 2024 16:09:40 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] LoongArch: KVM: Fix some issues relative with mmu
Date: Wed, 19 Jun 2024 16:09:34 +0800
Message-Id: <20240619080940.2690756-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxjsdEknJmFeMoAA--.32907S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patchset is mmu relative, it fixes potential issue about tlb flush 
of secondary mmu and huge page selection etc. Also it hardens LoongArch
kvm mmu module.

With this patchset, VM migration is stabler than before.

Bibo Mao (6):
  LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
  LoongArch: KVM: Select huge page only if secondary mmu supports it
  LoongArch: KVM: Discard dirty page tracking on readonly memslot
  LoongArch: KVM: Add memory barrier before update pmd entry
  LoongArch: KVM: Add dirty bitmap initially all set support
  LoongArch: KVM: Mark page accessed and dirty with page ref added

 arch/loongarch/include/asm/kvm_host.h |  5 ++
 arch/loongarch/include/asm/kvm_mmu.h  |  2 +-
 arch/loongarch/kvm/main.c             |  1 +
 arch/loongarch/kvm/mmu.c              | 67 ++++++++++++++++++++-------
 arch/loongarch/kvm/tlb.c              |  5 +-
 arch/loongarch/kvm/vcpu.c             | 18 +++++++
 6 files changed, 75 insertions(+), 23 deletions(-)


base-commit: 92e5605a199efbaee59fb19e15d6cc2103a04ec2
-- 
2.39.3


