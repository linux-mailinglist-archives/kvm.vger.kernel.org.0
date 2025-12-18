Return-Path: <kvm+bounces-66250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0B4CCBA8E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 12:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A354D3026B27
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 11:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D815532824E;
	Thu, 18 Dec 2025 11:40:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DF8327C13;
	Thu, 18 Dec 2025 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766058059; cv=none; b=E+4BE4QNQTBZJlLuKDAEWk04eMrSO2U3XpAXDh89jy0bEPZdgWE7daHP8cTzQFoKO5QKxvYEpuXTnv6zvGVbkSF2Si3EVU55EWGPG31F7ELlvnq6vIWcEj0Rz3R+6gyYWp2RKQC6c4UP+7gt0fWf05HJlAcmXM/IuF0r0PXfafY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766058059; c=relaxed/simple;
	bh=E90tS5qRdLPTsVJzU/STMPSm4ZBUijrXmJV9t86LYmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N6ymMMWaMnXCZHFMzRYNJgZWiuwZSV1EDnWACDj4bsJYHirSZSH/RLqUuJkK2n5pGgbAQQ2s/pc/sZE01MZ04J0UMPx588jdh/dK7UXJkiQ64UVvH7fYctCMwowx34VxxtyyOMuSuv5fd61a14FrLTqZXwP3cTU3/ugEzqLiiTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxHvBE6ENpOnQAAA--.2145S3;
	Thu, 18 Dec 2025 19:40:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJBxbcJD6ENpjFABAA--.2563S2;
	Thu, 18 Dec 2025 19:40:51 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] LongArch: KVM: Add DMSINTC support irqchip in kernel
Date: Thu, 18 Dec 2025 19:16:20 +0800
Message-Id: <20251218111623.975327-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxbcJD6ENpjFABAA--.2563S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Hi,

This series  implements the DMSINTC in-kernel irqchip device,
enables irqfd to deliver MSI to DMSINTC, and supports injecting MSI interrupts
to the target vCPU.
applied this series.  use netperf test.
VM with one CPU and start netserver, host run netperf.
disable dmsintc
taskset 0x2f  netperf -H 192.168.122.204 -t UDP_RR  -l 36000
Local /Remote           
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

212992 212992 1        1       36000.00   27107.36   

enable dmsintc
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

212992 212992 1        1       36000.00   28831.14  (+6.3%)

V4: Rebase and R-b; 
   replace DINTC to DMSINTC.

V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)

V2:
https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/

Thanks.
Song Gao



Song Gao (3):
  LongArch: KVM: Add DMSINTC device support
  LongArch: KVM: Add irqfd set dmsintc msg irq
  LongArch: KVM: Add dmsintc inject msi to the dest vcpu

 arch/loongarch/include/asm/kvm_dmsintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h    |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   4 +
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/dmsintc.c        | 116 +++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c           |   1 +
 arch/loongarch/kvm/irqfd.c               |  45 +++++++--
 arch/loongarch/kvm/main.c                |   5 +
 arch/loongarch/kvm/vcpu.c                |  58 ++++++++++++
 include/uapi/linux/kvm.h                 |   2 +
 10 files changed, 255 insertions(+), 7 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
 create mode 100644 arch/loongarch/kvm/intc/dmsintc.c

-- 
2.39.3


