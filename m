Return-Path: <kvm+bounces-54319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F22E8B1E674
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 12:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E2BD74E374C
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 10:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F117D2749F4;
	Fri,  8 Aug 2025 10:30:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601D526E705;
	Fri,  8 Aug 2025 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754649044; cv=none; b=MrMfa6S360DussKbMYNNbvx9cRL4P7XEV+SzknV8hBztOgAheGEYBaiWavDYANBt1vUJ7VUfdknJarn+f7MnwXomH8CfIwqknY0qKtuFrfRHza0UuyiPND4MpDcS+rYD9xSpuAzLcRxCUUVNYH5hvHNiVilda88ZFh0uVM4Yhc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754649044; c=relaxed/simple;
	bh=TEa5Q6FtlTfiBDId8+eikeIvByA1fjnz5Tg7kjVAcAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jOj+VY0EjEA2fBZMmgj8MAEclAoDCFGkd3GbypRxeVul+P3YDgkIaFvpGGSTptfNT6si/2tZRaimBNhZZCvfazoykevqRqLo/EJNLmwwQEy8Zk/x0MyC1SAUBhj5t385c6Srfig1dcrFpo1Vph77DQkAW7xKSs+drU9DHziKBpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.92.164])
	by APP-03 (Coremail) with SMTP id rQCowACnPX+f0ZVo0RdQCg--.29185S2;
	Fri, 08 Aug 2025 18:29:52 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH v2 1/6] RISC-V: KVM: Change zicbom/zicboz block size to depend on the host isa
Date: Fri,  8 Aug 2025 18:18:21 +0800
Message-Id: <fef5907425455ecd41b224e0093f1b6bc4067138.1754646071.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1754646071.git.zhouquan@iscas.ac.cn>
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnPX+f0ZVo0RdQCg--.29185S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy8Wr13Xr13Ar13KF4DJwb_yoW5Jr43pr
	43CrWF9Fy8AFy2qrZ7JrWkWFn5uw1qgrs5Gw4kWa48Zry7trWrGrnYkryUAFn2yFyfZrs2
	93Wvkryj9Fs8Ka7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6r4DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbfWFUUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBg0IBmiVokWUdwAAs8

From: Quan Zhou <zhouquan@iscas.ac.cn>

The zicbom/zicboz block size registers should depend on the host's isa,
the reason is that we otherwise create an ioctl order dependency on the VMM.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/vcpu_onereg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index cce6a38ea54f..6bd64ae17b80 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -277,12 +277,12 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		reg_val = vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+		if (!riscv_isa_extension_available(NULL, ZICBOM))
 			return -ENOENT;
 		reg_val = riscv_cbom_block_size;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
+		if (!riscv_isa_extension_available(NULL, ZICBOZ))
 			return -ENOENT;
 		reg_val = riscv_cboz_block_size;
 		break;
@@ -366,13 +366,13 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+		if (!riscv_isa_extension_available(NULL, ZICBOM))
 			return -ENOENT;
 		if (reg_val != riscv_cbom_block_size)
 			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
+		if (!riscv_isa_extension_available(NULL, ZICBOZ))
 			return -ENOENT;
 		if (reg_val != riscv_cboz_block_size)
 			return -EINVAL;
@@ -817,10 +817,10 @@ static int copy_config_reg_indices(const struct kvm_vcpu *vcpu,
 		 * was not available.
 		 */
 		if (i == KVM_REG_RISCV_CONFIG_REG(zicbom_block_size) &&
-			!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+			!riscv_isa_extension_available(NULL, ZICBOM))
 			continue;
 		else if (i == KVM_REG_RISCV_CONFIG_REG(zicboz_block_size) &&
-			!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
+			!riscv_isa_extension_available(NULL, ZICBOZ))
 			continue;
 
 		size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
-- 
2.34.1


