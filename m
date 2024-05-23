Return-Path: <kvm+bounces-18009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4BF8CCAA2
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 04:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3045A1F21F17
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 02:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A492F524F;
	Thu, 23 May 2024 02:13:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C199529AB;
	Thu, 23 May 2024 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716430438; cv=none; b=jmTQpuZM0jFIJmvU7BYvwPpgG7S1xZCBy98O9/u4SA6w3Z3ByZsfJbP3vqTTs070/5k80rmsDfK3IEQUwHuLMFDDG/uZOkKHYyveDw1O9Hmj8vZhSXhzdVzSNad69gKysFb+ZO8YVnKhlkN6wPdZuYYTKBuVXHY0gzhzuw0/Yiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716430438; c=relaxed/simple;
	bh=JjfbM2SI2LLXpy0ta+dthuEvJcDGyZY7PJLCvNklKio=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q02X+NjDrwPvuKKcU2lvVTY8p3nIAqzezJq9aMHgKQUyTBSCr81I57HnLl/fC4BJNDh8/gaXtMP7hOvanuCi84sWxQA4CgncMVWXepxHq45JJHnKQFFnkdNvZEUPoMsJkq0prUjInXZY6jdzVGu3UNQkqvjDO4ODyeVqy2MemcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [121.237.92.18])
	by APP-05 (Coremail) with SMTP id zQCowAA3PeVQpk5msp_mDA--.32642S2;
	Thu, 23 May 2024 10:13:37 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	atishp@atishpatra.org
Cc: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH] RISC-V: KVM: Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext function
Date: Thu, 23 May 2024 10:13:34 +0800
Message-Id: <ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3PeVQpk5msp_mDA--.32642S2
X-Coremail-Antispam: 1UD129KBjvJXoW7try8WrykGryrtr15CrWkCrg_yoW8GF48pr
	4DCrsYyrs5CFZ7Ca97ZrZ5Wr4Y9rs0gws5C3yI93yrJr45trWrXF1rtay7WF98GFyxXrWS
	9FW8tF1FvF4Yva7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
	xVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9Z2fUUUUU
	=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBg0GBmZOWhzPuQABsS

From: Quan Zhou <zhouquan@iscas.ac.cn>

In the function kvm_riscv_vcpu_set_reg_isa_ext, the original code
used incorrect reg_subtype labels KVM_REG_RISCV_SBI_MULTI_EN/DIS.
These have been corrected to KVM_REG_RISCV_ISA_MULTI_EN/DIS respectively.
Although they are numerically equivalent, the actual processing
will not result in errors, but it may lead to ambiguous code semantics.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index c676275ea0a0..62874fbca29f 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -724,9 +724,9 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 	switch (reg_subtype) {
 	case KVM_REG_RISCV_ISA_SINGLE:
 		return riscv_vcpu_set_isa_ext_single(vcpu, reg_num, reg_val);
-	case KVM_REG_RISCV_SBI_MULTI_EN:
+	case KVM_REG_RISCV_ISA_MULTI_EN:
 		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, true);
-	case KVM_REG_RISCV_SBI_MULTI_DIS:
+	case KVM_REG_RISCV_ISA_MULTI_DIS:
 		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, false);
 	default:
 		return -ENOENT;

base-commit: 29c73fc794c83505066ee6db893b2a83ac5fac63
-- 
2.34.1


