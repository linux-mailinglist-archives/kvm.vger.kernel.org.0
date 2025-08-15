Return-Path: <kvm+bounces-54759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6269AB275B3
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74769AA3591
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D9E29C33E;
	Fri, 15 Aug 2025 02:26:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21285299AA0;
	Fri, 15 Aug 2025 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755224793; cv=none; b=edvlA75CHq689zMfVpnp3RAkid5RT38i9xVbFq0W4S51vJeD+tXIBV3WDCncPpMLt5xyvsdurlro9OkXddpxNUpAx4+16JDgyfx8mlr/t/xnUqSYN4ydJdvLCfsFO97H8tNexPKXenW2BVeoF5pNG7fIg2cM38JHNdZ5DiQH99U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755224793; c=relaxed/simple;
	bh=2y3ZmYKP2DQpMTLUSrPR8DMrijt1FqrsR52egAf4L44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ray3o3hr9Vr3sIL2kvs4JxITIYAD9Ap4YmV6Ai/nL11oZ6q53BvvQGDFAS/tgexVPbCr4Pw6pOE8+Abmh7leZ/2aUZtjpkOHC8siaapaw3D6s4IzOJiA2vGu2QKd7QO4oXsfrom1BA2oAzFHE4/CnrfViufpsI36cBXuymei6VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx7eLTmp5oSRpAAQ--.21080S3;
	Fri, 15 Aug 2025 10:26:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxQMLOmp5oMPRMAA--.26771S3;
	Fri, 15 Aug 2025 10:26:27 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 1/4] LoongArch: KVM: Fix stack protector issue in send_ipi_data()
Date: Fri, 15 Aug 2025 10:26:18 +0800
Message-Id: <20250815022621.508174-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250815022621.508174-1-maobibo@loongson.cn>
References: <20250815022621.508174-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxQMLOmp5oMPRMAA--.26771S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_io_bus_read() is called in function send_ipi_data(), buffer
size of parameter *val should be at least 8 bytes. Some emulation
functions like loongarch_ipi_readl() and kvm_eiointc_read() will
write buffer *val with 8 bytes signed extension regardless parameter
len.

Otherwise there will be buffer overflow issue when CONFIG_STACKPROTECTOR
is enabled. The bug report is shown as follows:
Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: send_ipi_data+0x194/0x1a0 [kvm]
CPU: 11 UID: 107 PID: 2692 Comm: CPU 0/KVM Not tainted 6.17.0-rc1+ #102 PREEMPT(full)
Stack : 9000000005901568 0000000000000000 9000000003af371c 900000013c68c000
        900000013c68f850 900000013c68f858 0000000000000000 900000013c68f998
        900000013c68f990 900000013c68f990 900000013c68f6c0 fffffffffffdb058
        fffffffffffdb0e0 900000013c68f858 911e1d4d39cf0ec2 9000000105657a00
        0000000000000001 fffffffffffffffe 0000000000000578 282049464555206e
        6f73676e6f6f4c20 0000000000000001 00000000086b4000 0000000000000000
        0000000000000000 0000000000000000 9000000005709968 90000000058f9000
        900000013c68fa68 900000013c68fab4 90000000029279f0 900000010153f940
        900000010001f360 0000000000000000 9000000003af3734 000000004390000c
        00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
        ...
Call Trace:
[<9000000003af3734>] show_stack+0x5c/0x180
[<9000000003aed168>] dump_stack_lvl+0x6c/0x9c
[<9000000003ad0ab0>] vpanic+0x108/0x2c4
[<9000000003ad0ca8>] panic+0x3c/0x40
[<9000000004eb0a1c>] __stack_chk_fail+0x14/0x18
[<ffff8000023473f8>] send_ipi_data+0x190/0x1a0 [kvm]
[<ffff8000023313e4>] __kvm_io_bus_write+0xa4/0xe8 [kvm]
[<ffff80000233147c>] kvm_io_bus_write+0x54/0x90 [kvm]
[<ffff80000233f9f8>] kvm_emu_iocsr+0x180/0x310 [kvm]
[<ffff80000233fe08>] kvm_handle_gspr+0x280/0x478 [kvm]
[<ffff8000023443e8>] kvm_handle_exit+0xc0/0x130 [kvm]

Fixes: daee2f9cae551 ("LoongArch: KVM: Add IPI read and write function")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/ipi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index e658d5b37c04..7925651d2ccf 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -99,7 +99,7 @@ static void write_mailbox(struct kvm_vcpu *vcpu, int offset, uint64_t data, int
 static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 {
 	int i, idx, ret;
-	uint32_t val = 0, mask = 0;
+	uint64_t val = 0, mask = 0;
 
 	/*
 	 * Bit 27-30 is mask for byte writing.
@@ -108,7 +108,7 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	if ((data >> 27) & 0xf) {
 		/* Read the old val */
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (unlikely(ret)) {
 			kvm_err("%s: : read data from addr %llx failed\n", __func__, addr);
@@ -124,7 +124,7 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	}
 	val |= ((uint32_t)(data >> 32) & ~mask);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (unlikely(ret))
 		kvm_err("%s: : write data to addr %llx failed\n", __func__, addr);
-- 
2.39.3


