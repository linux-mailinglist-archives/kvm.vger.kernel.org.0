Return-Path: <kvm+bounces-20370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1442C914368
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75166B20E91
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBE34503C;
	Mon, 24 Jun 2024 07:15:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017F23D393;
	Mon, 24 Jun 2024 07:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213331; cv=none; b=i6TGR1BRJeyRAKso3GuO5xaSZscJknjDkJNTQGF9Yil9D/0/DgvRs4OVJ17nLpbv+oNkVI379kArk5hF9CFeEJ3Ji1NDlKhiiA6shhj7SRBcl7WbyaVBVJ1dOxAdiwp8Z0Qtk8B42TrvNgw5Zoy1cFkWVXlKjffPG5MVw//hy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213331; c=relaxed/simple;
	bh=tMij1kigYbysiBVjoK1zx02otlNc/5BcBakZSzod/Sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZwEDr14GrPtlFXRdpVda3Zki6af2tCVKi+MkF+oUassSJ9xGPX6zy19FzObHqgw6sQB1pqo79pZC082WgzuJ8wHRLNLdqwpWV1v30ezMZRh47XeHmqlIQL2O8RuyoK0UNs8ENQRqNgkG/Dn81rXPHkSUANEUmImQGC9tTiBoEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOrSHHlmJnEJAA--.37961S3;
	Mon, 24 Jun 2024 15:14:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S9;
	Mon, 24 Jun 2024 15:14:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 7/7] LoongArch: KVM: Sync pending interrupt when getting ESTAT from user mode
Date: Mon, 24 Jun 2024 15:14:22 +0800
Message-Id: <20240624071422.3473789-8-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
References: <20240624071422.3473789-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S9
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Currently interrupt is posted and cleared with asynchronous mode, and it
is saved in SW state vcpu::arch::irq_pending and vcpu::arch::irq_clear.
When vcpu is ready to run, pending interrupt is written back to ESTAT
CSR register from SW state vcpu::arch::irq_pending at guest entrance.

During VM migration stage, vcpu is put into stopped state, however
pending interrupt is not synced to ESTAT CSR register. So there will be
interrupt lost when VCPU is migrated to other host machines.

Here when ESTAT CSR register is read from VMM user mode, pending
interrupt is synchronized to ESTAT also. So that vcpu can get correct
pending interrupt.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b747bd8bc037..6b612b8390f7 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -371,6 +371,17 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
 		return -EINVAL;
 
 	if (id == LOONGARCH_CSR_ESTAT) {
+		preempt_disable();
+		vcpu_load(vcpu);
+		/*
+		 * Sync pending interrupt into estat so that interrupt
+		 * remains during migration stage
+		 */
+		kvm_deliver_intr(vcpu);
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
+		vcpu_put(vcpu);
+		preempt_enable();
+
 		/* ESTAT IP0~IP7 get from GINTC */
 		gintc = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
 		*val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT) | (gintc << 2);
-- 
2.39.3


