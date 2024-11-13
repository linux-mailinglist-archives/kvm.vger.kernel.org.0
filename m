Return-Path: <kvm+bounces-31702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6339C67B1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 028D22855EF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C8916DEB4;
	Wed, 13 Nov 2024 03:17:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B8A166315;
	Wed, 13 Nov 2024 03:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467854; cv=none; b=OrZJ4wIX7V99Cr0fuNe//wKlXT2/F6ZwHxm9LV1mZzZ13v3ksVw2nQLUsNJOKI9nq7m5hm6nY/S/yIRYsSDh/qrKmRSr5hif1YXlbQnlDfloePKcWWnnZw69hxhaJ3bhkj5c6aAgQ+04v1ajyPToNZdY9+OlEDHbaqVYCdXL2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467854; c=relaxed/simple;
	bh=Y10iws7rqTNQnqtfaUlBdQa01hwc1hbZvYAFYzuAgos=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fgx3EnMOlKOcPcZYwrqj64oK6BlytiPIrbS+jqzHplTiISpNeLctk9nHm78Nx4SOfvo7RbpWNDlUFZrEJe+wfu4vb/LmwgUFQUwqI+6OhQFMnNE+txrx5QVgy+gmIn6GoYCGQzhzMW3FRO8qgGZyI1yu2TPfYi4ZPExEOhUJ7hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxquBIGjRnSn08AA--.54259S3;
	Wed, 13 Nov 2024 11:17:28 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDEdHGjRnX4VTAA--.14727S2;
	Wed, 13 Nov 2024 11:17:28 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 0/5] LoongArch: KVM: Add separate vmid support
Date: Wed, 13 Nov 2024 11:17:22 +0800
Message-Id: <20241113031727.2815628-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxDEdHGjRnX4VTAA--.14727S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

LoongArch KVM hypervisor supports two-level MMU, vpid index is used
for stage1 MMU and vmid index is used for stage2 MMU.

On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
may separate from vpid. There are such advantages if separate vpid
is supported.
  1. One VM uses one vmid, vCPUs on the same VM can share the same vmid.
  2. If one vCPU switch between different physical CPU, old vmid can be
     still usefil if old vmid is not expired
  3. For remote tlb flush, only vmid need update and vpid need not
update.

Here add separate vmid feature support, vmid feature detecting method
is not implemented since it depends on HW implementation, detecting
method will be added when HW is ready.

---
Bibo Mao (5):
  LoongArch: KVM: Add vmid support for stage2 MMU
  LoongArch: KVM: Add separate vmid feature support
  LoongArch: KVM: implement vmid updating logic
  LoongArch: KVM: Add remote tlb flushing support
  LoongArch: KVM: Enable separate vmid feature

 arch/loongarch/include/asm/kvm_host.h  | 10 ++++
 arch/loongarch/include/asm/loongarch.h |  2 +
 arch/loongarch/kernel/asm-offsets.c    |  1 +
 arch/loongarch/kvm/main.c              | 76 ++++++++++++++++++++++++--
 arch/loongarch/kvm/mmu.c               | 17 ++++++
 arch/loongarch/kvm/switch.S            |  5 +-
 arch/loongarch/kvm/tlb.c               | 19 ++++++-
 arch/loongarch/kvm/vcpu.c              |  7 ++-
 8 files changed, 128 insertions(+), 9 deletions(-)


base-commit: 2d5404caa8c7bb5c4e0435f94b28834ae5456623
-- 
2.39.3


