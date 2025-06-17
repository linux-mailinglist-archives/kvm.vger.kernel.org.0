Return-Path: <kvm+bounces-49701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A80ADCCE1
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 117E57A3CE6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4FF2DF3D1;
	Tue, 17 Jun 2025 13:19:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E752E716F;
	Tue, 17 Jun 2025 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750166357; cv=none; b=CBzZCXJvwSR3wlXsYXZOJznz6GawwPXZUvf+fspzvWVAaZX6Zkeqe3pYeRUp6dDAjWV54Q9RlTIBnKsmN5YscM+QhvTWtrHjyri+pNCNVhGG+7jvs1SkRGsynyqkgU1Hu6iK4R3408D/r8pvE+YU24yhFYeExzd1UIPl+A92wlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750166357; c=relaxed/simple;
	bh=5AlUbQmSVuAO+B0HWf04mTkShgYkI6MwN02eS3CLk/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ciFt2C761UZVxQMYxzCwIzqVQIYHLKdW0PKYLfNOdorcWcZXeyfzb+wYhRlQ27/E0hTornBmRS0kusJh8NgJDZXRwKphgSqMWNkMcBAvRRwzwpP5Sv60AMZrYODXOt7wlt8RqtUA4uzYeVE7HX/AIm81w4aCAm1OiJfP5EVVUH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.110.114.155])
	by APP-05 (Coremail) with SMTP id zQCowADXXQxJa1FoFic9Bw--.11018S2;
	Tue, 17 Jun 2025 21:19:06 +0800 (CST)
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
Subject: [PATCH 1/5] RISC-V: KVM: Provide UAPI for Zicbop block size
Date: Tue, 17 Jun 2025 21:10:22 +0800
Message-Id: <553bacc4f66e815975bb8ee0e4696397407b0a82.1750164414.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1750164414.git.zhouquan@iscas.ac.cn>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXXQxJa1FoFic9Bw--.11018S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4UXr4DGF45WrW5GFW5trb_yoW8uF45pF
	sxCrs5ur48ur93W397Crykur4Yg34DGws8trWI93y5ZFy3trWrCrn5Kr9xZFWkXFW8ZFs2
	9F1rCryruFs8Jr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbH5l5UUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBg0QBmhRLE-QtgABsg

From: Quan Zhou <zhouquan@iscas.ac.cn>

We're about to allow guests to use the Zicbop extension.
KVM userspace needs to know the cache block size in order to
properly advertise it to the guest. Provide a virtual config
register for userspace to get it with the GET_ONE_REG API, but
setting it cannot be supported, so disallow SET_ONE_REG.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu_onereg.c      | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 5f59fd226cc5..0863ca178066 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -55,6 +55,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 2e1b646f0d61..b08a22eaa7a7 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -256,6 +256,11 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 		reg_val = riscv_cboz_block_size;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))
+			return -ENOENT;
+		reg_val = riscv_cbop_block_size;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		reg_val = vcpu->arch.mvendorid;
 		break;
@@ -347,6 +352,12 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		if (reg_val != riscv_cboz_block_size)
 			return -EINVAL;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))
+			return -ENOENT;
+		if (reg_val != riscv_cbop_block_size)
+			return -EINVAL;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		if (reg_val == vcpu->arch.mvendorid)
 			break;
-- 
2.34.1


