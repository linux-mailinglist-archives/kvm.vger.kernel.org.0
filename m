Return-Path: <kvm+bounces-54320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F5DB1E676
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 12:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D94F5172C0A
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 10:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDC2274FD9;
	Fri,  8 Aug 2025 10:30:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B08274B3D;
	Fri,  8 Aug 2025 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754649048; cv=none; b=XkNKLKgHTUqJbQladkOaTVBU0iohI7HNDeWHqtDRmGdr2S6Ekv4ZJeydDyPJFy2pFE1EqUWfCHszlYDBSrlIfPpms0/bnPnruKBTnsqcH/hjomIxwmfOZlbslbn/3Sc/KWMubUJepoNBrOeeu6QidiIEGSqQrLVjLO4GoLoUnGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754649048; c=relaxed/simple;
	bh=XT4j7KoMca7xMFwBJBn30/Ai2KGbPVZDSFYVvbAwtPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrX6Hlz7I9YqJwm79uGyKbPACq3TH2ET1AocsEWvm0htixkooo1EJzi5zCEZ4YZaZTw825W1VY1qPmd6tfxLMgp8VqQeBLEH0f494YGVARu+iHyA3ynRRvNZHSNFzCUhNH5p5L8/ExcAnKlRh3tJzaLJnafc4JPwjsMwgWdXA94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.92.164])
	by APP-03 (Coremail) with SMTP id rQCowAB3DH6s0ZVo1RpQCg--.7060S2;
	Fri, 08 Aug 2025 18:30:04 +0800 (CST)
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
Subject: [PATCH v2 2/6] RISC-V: KVM: Provide UAPI for Zicbop block size
Date: Fri,  8 Aug 2025 18:18:34 +0800
Message-Id: <befd8403cd76d7adb97231ac993eaeb86bf2582c.1754646071.git.zhouquan@iscas.ac.cn>
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
X-CM-TRANSID:rQCowAB3DH6s0ZVo1RpQCg--.7060S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1DtryUXr45ZFy3XFyxZrb_yoW5GrWDpF
	sxCrsY9r409ryS9rZ7ArykWr4Ygwn8Gws3trZ293y8JF9rtFWrGr4kKr9xAFW0qFW8XF4I
	93Z5Gry09an8tw7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8tw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUDcTdUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCQ4IBmiVopSTXQABsN

From: Quan Zhou <zhouquan@iscas.ac.cn>

We're about to allow guests to use the Zicbop extension.
KVM userspace needs to know the cache block size in order to
properly advertise it to the guest. Provide a virtual config
register for userspace to get it with the GET_ONE_REG API, but
setting it cannot be supported, so disallow SET_ONE_REG.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu_onereg.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index ef27d4289da1..bb200f82d08e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -56,6 +56,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 6bd64ae17b80..cf5003eb2e41 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -286,6 +286,11 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 		reg_val = riscv_cboz_block_size;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
+		if (!riscv_isa_extension_available(NULL, ZICBOP))
+			return -ENOENT;
+		reg_val = riscv_cbop_block_size;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		reg_val = vcpu->arch.mvendorid;
 		break;
@@ -377,6 +382,12 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		if (reg_val != riscv_cboz_block_size)
 			return -EINVAL;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
+		if (!riscv_isa_extension_available(NULL, ZICBOP))
+			return -ENOENT;
+		if (reg_val != riscv_cbop_block_size)
+			return -EINVAL;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		if (reg_val == vcpu->arch.mvendorid)
 			break;
@@ -822,6 +833,9 @@ static int copy_config_reg_indices(const struct kvm_vcpu *vcpu,
 		else if (i == KVM_REG_RISCV_CONFIG_REG(zicboz_block_size) &&
 			!riscv_isa_extension_available(NULL, ZICBOZ))
 			continue;
+		else if (i == KVM_REG_RISCV_CONFIG_REG(zicbop_block_size) &&
+			!riscv_isa_extension_available(NULL, ZICBOP))
+			continue;
 
 		size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
 		reg = KVM_REG_RISCV | size | KVM_REG_RISCV_CONFIG | i;
-- 
2.34.1


