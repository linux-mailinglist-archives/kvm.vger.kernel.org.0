Return-Path: <kvm+bounces-38983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C62BA419CA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16A051739AB
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19ADA24E4CA;
	Mon, 24 Feb 2025 09:56:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD60224A05B;
	Mon, 24 Feb 2025 09:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390985; cv=none; b=GXheKnPI0RU7vxsAlOCMseaNZFkUu091/KxXJW4Y4A5vVP7OErt13gIKx66k3Qx4URqvhyS/upXbaaBlJpV0jkVGC4LlHcRZGS1XUwyiWc7d0VTciuMporpitL+H97WQSI/ceQmL1XW/01UGLf5t0oF0Lh+ksgFaBmt8LwG6gl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390985; c=relaxed/simple;
	bh=NUpup4TJeKNS+74UwtNoKP/hHdEekNejv7N+QbJBI2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s/MYOVPVvwBiCDrZFFdoh6dCnAspWomn7ZOIOQzlgzJVGG7p1mBtB9PpjGHN7aDoJeiUch+x9BQ35EZ6MJJfmZ9AIjjr+WgD7pzKKXacnhruqYYnDXTrpZ/Hre/RmswJJFeAfLR9LDPO+sRTTdPU0M3fuzCjg2f5E13iOxD13ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxLGtDQrxnIq+AAA--.24313S3;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVCQrxnRBkmAA--.9703S2;
	Mon, 24 Feb 2025 17:56:18 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add perf event support for guest VM
Date: Mon, 24 Feb 2025 17:56:15 +0800
Message-Id: <20250224095618.1436016-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVCQrxnRBkmAA--.9703S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

From perf pmu interrupt is normal IRQ rather than NMI, so code cannot be
profiled if interrupt is disabled. However it is possible to profile
guest kernel in this situation from host side, profile result is more
accurate from host than that from guest.

Perf event support for guest VM is added here, and the below is the
example:
perf kvm --host --guest --guestkallsyms=guest-kallsyms
     --guestmodules=guest-modules  top

Overhead  Shared Object               Symbol
  20.02%  [guest.kernel]              [g] __arch_cpu_idle
  16.74%  [guest.kernel]              [g] queued_spin_lock_slowpath
  10.05%  [kernel]                    [k] __arch_cpu_idle
   2.00%  [guest.kernel]              [g] clear_page
   1.62%  [guest.kernel]              [g] copy_page
   1.50%  [guest.kernel]              [g] next_uptodate_folio
   1.41%  [guest.kernel]              [g] queued_write_lock_slowpath
   1.41%  [guest.kernel]              [g] unmap_page_range
   1.36%  [guest.kernel]              [g] mod_objcg_state
   1.30%  [guest.kernel]              [g] osq_lock
   1.28%  [guest.kernel]              [g] __slab_free
   0.98%  [guest.kernel]              [g] copy_page_range

Bibo Mao (3):
  LoongArch: KVM: Add stub for kvm_arch_vcpu_preempted_in_kernel
  LoongArch: KVM: Implement arch specified functions for guest perf
  LoongArch: KVM: Register perf callback for guest

 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/Kconfig            |  1 +
 arch/loongarch/kvm/main.c             |  2 ++
 arch/loongarch/kvm/vcpu.c             | 31 +++++++++++++++++++++++++++
 4 files changed, 36 insertions(+)


base-commit: 2408a807bfc3f738850ef5ad5e3fd59d66168996
-- 
2.39.3


