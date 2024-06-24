Return-Path: <kvm+bounces-20365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A79914356
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C691C22C46
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3DB4087C;
	Mon, 24 Jun 2024 07:14:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2FC3BBEA;
	Mon, 24 Jun 2024 07:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213268; cv=none; b=Add+48Uf3Wu+a2EsLZnt++2Q9w3HpDV76QapCMPhrudS2HuseHKosaitMvjM1CF1NmvBueWLL+seVBDBzvJw+klN5VnChz4Jy93VewFR8iFgkDYtcmQhbhMNdo8L2BgYuEemo/ZqhEnf+tbZExDPpQQHyEUkvfRHNFVuoxQzcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213268; c=relaxed/simple;
	bh=lsOu06EhnFac7DNeBexi+TfRtaEYDp5kQfCX+utdo6E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R7yTLXWAZU6R00OQqOAP+lPqnwNlbNVmB1ah6DcLPCg7kKY05KcV+Sd/vYZPApmp76w5MaO7hjyLKiBtv6BfvS/TXytkIw7Leboltqg2EWyrKX1CKRtI+IAxAHRqVFC+4wIO3ELXLYIrRqxHFecS9ot0iHHqKxD9J3o9MHRmAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxW+rPHHlmAnEJAA--.38419S3;
	Mon, 24 Jun 2024 15:14:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S2;
	Mon, 24 Jun 2024 15:14:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 0/7] LoongArch: KVM: VM migration enhancement
Date: Mon, 24 Jun 2024 15:14:15 +0800
Message-Id: <20240624071422.3473789-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patchset is to solve VM migration issues, the first six patches are
mmu relative, the last patch is relative with vcpu interrupt status.

It fixes potential issue about tlb flush of secondary mmu and huge page
selection etc. Also it hardens LoongArch kvm mmu module.

With this patchset, VM successfully migrates on my 3C5000 Dual-Way
machine with 32 cores.
 1. Pass to migrate when unixbench workload runs with 32 vcpus, for
some unixbench testcases there is much IPI sending.
 2. Pass to migrate with kernel compiling with 8 vcpus in VM
 3. Fail to migrate with kernel compiling with 32 vcpus in VM, since
there is to much memory writing operation, also there will be file
system inode inconsistent error after migration.

---
v2 ... v3:
 1. Merge patch 7 into this patchset since it is relative with VM
migration bugfix.
 2. Sync pending interrupt when getting ESTAT register, SW ESTAT
register is read after vcpu_put().
 3. Add notation about smp_wmb() when update pmd entry, to elimate
checkpatch warning.
 4. Remove unnecessary modification about function kvm_pte_huge()
in patch 2.
 5. Add notation about secondary mmu tlb since it is firstly used here.

v1 ... v2:
 1. Combine seperate patches into one patchset, all are relative with
migration.
 2. Mark page accessed without mmu_lock still, however with page ref
added
---
Bibo Mao (7):
  LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
  LoongArch: KVM: Select huge page only if secondary mmu supports it
  LoongArch: KVM: Discard dirty page tracking on readonly memslot
  LoongArch: KVM: Add memory barrier before update pmd entry
  LoongArch: KVM: Add dirty bitmap initially all set support
  LoongArch: KVM: Mark page accessed and dirty with page ref added
  LoongArch: KVM: Sync pending interrupt when getting ESTAT from user
    mode

 arch/loongarch/include/asm/kvm_host.h |  5 ++
 arch/loongarch/include/asm/kvm_mmu.h  |  2 +-
 arch/loongarch/kvm/main.c             |  1 +
 arch/loongarch/kvm/mmu.c              | 67 ++++++++++++++++++++-------
 arch/loongarch/kvm/tlb.c              |  5 +-
 arch/loongarch/kvm/vcpu.c             | 29 ++++++++++++
 6 files changed, 86 insertions(+), 23 deletions(-)


base-commit: 50736169ecc8387247fe6a00932852ce7b057083
-- 
2.39.3


