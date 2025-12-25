Return-Path: <kvm+bounces-66687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F276CDD9A0
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 10:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A78533056C79
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 09:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C7131985D;
	Thu, 25 Dec 2025 09:37:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1553126A9;
	Thu, 25 Dec 2025 09:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766655428; cv=none; b=hsvRZ0zvzNYoOPJXYfCSnU9Zuyb9diEJnHIG5A8TSvqpmEq5XPMeACz8sD3sfKqPUutOFPydXaVRR2tocfdYmfq0gD7dFrVkVCGr6/0CtpYtC7wNH12l3Iyq/bmEaLIE61O8GwfOx8A+ToEEMKlqZ+ufG/bo5Sz3xVaZSp0ymdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766655428; c=relaxed/simple;
	bh=FDYqg2PsBfTofa8n2ARwt1vXoj22N3p8YFeutE0D174=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L8SmISUbpDmyt3jeozdFhPl4bGeSYSlIdByaM1YTHyCTZgic7DTAhSx37AVjLADvif4ldAQTl+PZmDPGxBe/AenKQCx9Sk9Wto+dixq10g2MMenEDVzJGV8jry3EpLdmyKd5d2wADqF3Wu5ThP0WodFOkbpsgcAKCUgbFciT5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxOMK7BU1pmhoDAA--.9736S3;
	Thu, 25 Dec 2025 17:36:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJAx38K4BU1p0rEEAA--.13879S2;
	Thu, 25 Dec 2025 17:36:57 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] LongArch: KVM: Add DMSINTC support irqchip in kernel
Date: Thu, 25 Dec 2025 17:12:22 +0800
Message-Id: <20251225091224.2893389-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx38K4BU1p0rEEAA--.13879S2
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

v5:
  Combine patch2 and patch3
  Add check msgint feature when register DMSINT device. 

V4: Rebase and R-b; 
   replace DINTC to DMSINTC.

V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)

V2:
https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/

Thanks.
Song Gao


Song Gao (2):
  LongArch: KVM: Add DMSINTC device support
  LongArch: KVM: Add dmsintc inject msi to the dest vcpu

 arch/loongarch/include/asm/kvm_dmsintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h    |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   4 +
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/dmsintc.c        | 116 +++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c           |   1 +
 arch/loongarch/kvm/irqfd.c               |  42 +++++++-
 arch/loongarch/kvm/main.c                |   6 ++
 arch/loongarch/kvm/vcpu.c                |  58 ++++++++++++
 include/uapi/linux/kvm.h                 |   2 +
 10 files changed, 256 insertions(+), 4 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
 create mode 100644 arch/loongarch/kvm/intc/dmsintc.c

-- 
2.39.3


