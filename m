Return-Path: <kvm+bounces-64926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90804C9178E
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597173AEA35
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33AA3043DD;
	Fri, 28 Nov 2025 09:35:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BD22E7658;
	Fri, 28 Nov 2025 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322555; cv=none; b=UOv7vEw90e4CerwGFwqX1WmOks5I5CyqQH2wLG5b9eOWFaqTk3W9zshX3CdCdKqkCOBFgI8uzyqgvCgHJuUmpqUJRvXtgZMkFKNSARGIQ8uDAn8BJUImNdG8GZKwZbD8xG7x1InZMALcS4uWhK8fPttYHr5t1dTsDtbxpSH00/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322555; c=relaxed/simple;
	bh=mHsyXzuWwIQSR7QTAslKBLwI9uUX03W4VLfzvQMcDzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZeGFZWsXcCVUdO68IA8cbcVqh14JuenjIqSYDuR6Zb6lwkrlPc2QE0Zs5VdiVhhbaVg9oCgVpd9g65dNXl6/l5d+7He0goEgZNA6nsi1DlqsSlAGazUc2Si8Qd/Pbri3akRqTEjmEudTvql1L8aCwuappeSlwTvWtKkUH2PDmdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cx6tHubClpPA8pAA--.23434S3;
	Fri, 28 Nov 2025 17:35:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sDtbClpo+xBAQ--.23356S2;
	Fri, 28 Nov 2025 17:35:41 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] LongArch: KVM: Add AVEC support irqchip in kernel
Date: Fri, 28 Nov 2025 17:11:21 +0800
Message-Id: <20251128091125.2720148-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sDtbClpo+xBAQ--.23356S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Hi,

This series adds AVEC-related macros, implements the DINTC in-kernel irqchip device,
enables irqfd to deliver MSI to DINTC, and supports injecting MSI interrupts
to the target vCPU.

Thanks.
Song Gao

Song Gao (4):
  LongArch: KVM: Add some maccros for AVEC
  LongArch: KVM: Add DINTC device support
  LongArch: KVM: Add irqfd set dintc msi
  LongArch: KVM: Add dintc inject msi to the dest vcpu

 arch/loongarch/include/asm/irq.h       |   8 ++
 arch/loongarch/include/asm/kvm_dintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h  |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/Makefile            |   1 +
 arch/loongarch/kvm/intc/dintc.c        | 118 +++++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c         |   1 +
 arch/loongarch/kvm/irqfd.c             |  28 +++++-
 arch/loongarch/kvm/main.c              |   5 ++
 arch/loongarch/kvm/vcpu.c              |  55 ++++++++++++
 drivers/irqchip/irq-loongarch-avec.c   |   5 +-
 include/uapi/linux/kvm.h               |   2 +
 12 files changed, 254 insertions(+), 3 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
 create mode 100644 arch/loongarch/kvm/intc/dintc.c

-- 
2.39.3


