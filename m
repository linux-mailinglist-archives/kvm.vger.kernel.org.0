Return-Path: <kvm+bounces-54981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4515FB2C372
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 625171C207E8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183E933EAEE;
	Tue, 19 Aug 2025 12:17:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AA33043B7;
	Tue, 19 Aug 2025 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755605854; cv=none; b=YlwmywIkSwuWK8XpIHZRUR/dI8pG/u846+cOwPGgtWjTfynr05v5cZ/S/Y2NHAKVSPJzCvJ1sigokgED+28lvk/84UUCKlcyWduIt/lXO7H3H64ilvMwh/Wqn0dkhiwrFy52zUGAUbPf+CsynHA0vCc0NtwMYfMGpN0DYQ/BRGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755605854; c=relaxed/simple;
	bh=b3fKtEESFkXGwU1UZUwDMOpfDptvGhUa48h3ZbMe7vw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G1gHGbkpccOETNKKTMA0I+LlIorKL1PvcEyeFxPff8vaWFUrSLQMg2F6NE14KuAX9/LbzUaJyVgkkcreXmAxPA5GLODj/2ducx7jeej0AzJ6j5z2Be3AlAjy9i3AVVQ8NVQ3edYnvmBVCMABlGeTCcQWttzaybWo/YzPPf7dVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxO9JWa6Ror2IAAA--.748S3;
	Tue, 19 Aug 2025 20:17:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxfcFWa6Ro2DtYAA--.19719S3;
	Tue, 19 Aug 2025 20:17:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: Add sign extension with kernel MMIO read emulation
Date: Tue, 19 Aug 2025 20:17:24 +0800
Message-Id: <20250819121725.2423941-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJAxfcFWa6Ro2DtYAA--.19719S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_complete_mmio_read() is to add sign extension with MMIO
read emulation, it is used in user space MMIO read return now. Also
it can be used in kernel MMIO read emulation.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 2ce41f93b2a4..6fee1b8c35eb 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -468,6 +468,9 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 	if (ret == EMULATE_DO_MMIO) {
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, run->mmio.len, run->mmio.phys_addr, NULL);
 
+		/* Set for kvm_complete_mmio_read() use */
+		vcpu->arch.io_gpr = rd;
+
 		/*
 		 * If mmio device such as PCH-PIC is emulated in KVM,
 		 * it need not return to user space to handle the mmio
@@ -475,16 +478,15 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 		 */
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
-				      run->mmio.len, &vcpu->arch.gprs[rd]);
+				      run->mmio.len, run->mmio.data);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (!ret) {
+			kvm_complete_mmio_read(vcpu, run);
 			update_pc(&vcpu->arch);
 			vcpu->mmio_needed = 0;
 			return EMULATE_DONE;
 		}
 
-		/* Set for kvm_complete_mmio_read() use */
-		vcpu->arch.io_gpr = rd;
 		run->mmio.is_write = 0;
 		vcpu->mmio_is_write = 0;
 		return EMULATE_DO_MMIO;
-- 
2.39.3


