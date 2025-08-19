Return-Path: <kvm+bounces-54982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80071B2C37B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0352562238A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55888305044;
	Tue, 19 Aug 2025 12:17:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CBE3043AE;
	Tue, 19 Aug 2025 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755605854; cv=none; b=TaQTODIJRUWeNy/cNAJp0QP3qaWwn1Wi4dXAN2t2d16z5Dz9C2cUDp0pkiwNFs59mitpI42nOzNHqkrDb213F3rsm/IYSxF/zTlbciBDEQzLABtoeKW3bMT7LzRg18galzV1cQUtNmNraHKgRm2WeiO7PaGylUKg91sDpOE2O1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755605854; c=relaxed/simple;
	bh=jQcJukW1CMycA32bM3dXcv/X8VZZZgaakFfxVBaYYxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ljD0f/KWSvX5816fw8/le1BfEDyZzwvkAQt3DGkn/t9Qqxjn5U7l1elXesc9CKYam0kb1eFMQ2+cWMue4JMgtbOg3qdb+Q3U2+b+EvIejU9z54tUsLRiZxHgf0u52W5vjqoMcOvOLwM6dfLI+qp33tMC14qFtWh+akcTkX7M388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxWNFXa6Ros2IAAA--.736S3;
	Tue, 19 Aug 2025 20:17:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxfcFWa6Ro2DtYAA--.19719S4;
	Tue, 19 Aug 2025 20:17:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] LoongArch: KVM: Add sign extension with kernel IOCSR read emulation
Date: Tue, 19 Aug 2025 20:17:25 +0800
Message-Id: <20250819121725.2423941-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250819121725.2423941-1-maobibo@loongson.cn>
References: <20250819121725.2423941-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxfcFWa6Ro2DtYAA--.19719S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_complete_iocsr_read() is to add sign extension with IOCSR
read emulation, it is used in user space IOCSR read return now. Also
it can be used in kernel IOCSR read emulation.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 6fee1b8c35eb..e4ad2d4acdf1 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -218,16 +218,17 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 		}
 		trace_kvm_iocsr(KVM_TRACE_IOCSR_WRITE, run->iocsr_io.len, addr, val);
 	} else {
+		/* Save register id for iocsr read completion */
+		vcpu->arch.io_gpr = rd;
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val);
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len,
+					run->iocsr_io.data);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
-		if (ret == 0)
+		if (ret == 0) {
+			kvm_complete_iocsr_read(vcpu, run);
 			ret = EMULATE_DONE;
-		else {
+		} else
 			ret = EMULATE_DO_IOCSR;
-			/* Save register id for iocsr read completion */
-			vcpu->arch.io_gpr = rd;
-		}
 		trace_kvm_iocsr(KVM_TRACE_IOCSR_READ, run->iocsr_io.len, addr, NULL);
 	}
 
-- 
2.39.3


