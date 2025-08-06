Return-Path: <kvm+bounces-54097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A12EB1C2A2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 11:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B8307A1B30
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4013028A1D9;
	Wed,  6 Aug 2025 09:00:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D44289371;
	Wed,  6 Aug 2025 09:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754470853; cv=none; b=RQTeyDhaHOQKcdEK/hXfD/oJH3Mf/tUgfzUjbZPGijTdbVLicQ632aDpUJGIp/QxC/UMWsI9shbscz1Zm5+9SKz1XcBx/rNuIsJG4PKVALXFRQFPiT/OZZ5ywWm9GEAwo71tkBMuLFKsBD4t2Yzhxdm4F7peUHMxTQNjCgZZJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754470853; c=relaxed/simple;
	bh=KIcw3ORhJZhhiF5OhW7almcs41TmKKIO/mtjrFKeYxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jjdeahNK4vZy6VdVtQhdYeSUTOozs7wvR5ja4n5EcPxYpG5qPs7mnRQvaly5QCxtej2xnfQ9dAS9M03KZHldRirOwRZtF9gO/8UwGo9r/E1U1FvHg3JFrgBJevp4MwDD352N3ed/ezAB25IDBDxfDI1uaJYUbrHavpxq10chmJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxQK_BGZNoiJs5AQ--.13182S3;
	Wed, 06 Aug 2025 17:00:49 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxzsG+GZNoe6k4AA--.54411S4;
	Wed, 06 Aug 2025 17:00:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] LoongArch: KVM: Add implementation with IOCSR_IPI_SET
Date: Wed,  6 Aug 2025 17:00:45 +0800
Message-Id: <20250806090046.2028785-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250806090046.2028785-1-maobibo@loongson.cn>
References: <20250806090046.2028785-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxzsG+GZNoe6k4AA--.54411S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

IPI IOCSR register IOCSR_IPI_SET can send ipi interrupt to other vCPUs,
also it can send interrupt to vCPU itself. Instead there is such
operation on Linux such as arch_irq_work_raise(), it will send ipi
message to vCPU itself.

Here add implementation of write operation with IOCSR_IPI_SET register.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/ipi.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 6bbbf5df3957..d0457a198847 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -7,13 +7,26 @@
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_vcpu.h>
 
-static void ipi_send(struct kvm *kvm, uint64_t data)
+static void ipi_set(struct kvm_vcpu *vcpu, uint32_t data)
 {
-	int cpu, action;
 	uint32_t status;
-	struct kvm_vcpu *vcpu;
 	struct kvm_interrupt irq;
 
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	status = vcpu->arch.ipi_state.status;
+	vcpu->arch.ipi_state.status |= data;
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+	if ((status == 0) && data) {
+		irq.irq = LARCH_INT_IPI;
+		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+}
+
+static void ipi_send(struct kvm *kvm, uint64_t data)
+{
+	int cpu;
+	struct kvm_vcpu *vcpu;
+
 	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
@@ -21,15 +34,7 @@ static void ipi_send(struct kvm *kvm, uint64_t data)
 		return;
 	}
 
-	action = BIT(data & 0x1f);
-	spin_lock(&vcpu->arch.ipi_state.lock);
-	status = vcpu->arch.ipi_state.status;
-	vcpu->arch.ipi_state.status |= action;
-	spin_unlock(&vcpu->arch.ipi_state.lock);
-	if (status == 0) {
-		irq.irq = LARCH_INT_IPI;
-		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
-	}
+	ipi_set(vcpu, BIT(data & 0x1f));
 }
 
 static void ipi_clear(struct kvm_vcpu *vcpu, uint64_t data)
@@ -241,7 +246,7 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		spin_unlock(&vcpu->arch.ipi_state.lock);
 		break;
 	case IOCSR_IPI_SET:
-		ret = -EINVAL;
+		ipi_set(vcpu, data);
 		break;
 	case IOCSR_IPI_CLEAR:
 		/* Just clear the status of the current vcpu */
@@ -260,10 +265,10 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		ipi_send(vcpu->kvm, data);
 		break;
 	case IOCSR_MAIL_SEND:
-		ret = mail_send(vcpu->kvm, *(uint64_t *)val);
+		ret = mail_send(vcpu->kvm, data);
 		break;
 	case IOCSR_ANY_SEND:
-		ret = any_send(vcpu->kvm, *(uint64_t *)val);
+		ret = any_send(vcpu->kvm, data);
 		break;
 	default:
 		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
-- 
2.39.3


