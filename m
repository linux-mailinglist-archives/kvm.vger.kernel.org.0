Return-Path: <kvm+bounces-64981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 382E1C9587E
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6558D3422CC
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CB813B584;
	Mon,  1 Dec 2025 01:46:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E722AE70;
	Mon,  1 Dec 2025 01:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553574; cv=none; b=S+BZvqbKjZT6ZiJwCCt727PX7Xsj8gBV1Nm47eGgIW4ByROJEwWAEB+J2Y6zGV1Xwai3T+XLt8PbcuAf97756nYov0FyrJUSvly9qXZCUUFlP3p/EHJlqdcvDDUiAgAEKzJjCq2ty87HeMVK/z+CrSbwt6FqmtW9qoEp+Z0G5ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553574; c=relaxed/simple;
	bh=ufARmrDL39O3fxYBKzzivZ4J1hmQfaubI2PiI7f0BTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QIafEVvbxt68sWCUFx8JGhRmdd3V4C7yW6UTawA3PajgQxJ+6rE4K4vGni1a+5ChcwCopGWg/Z3ripUbLxT9Jb5tmrxcFWNtYWmFjiqTHmwPPvgyODxRWKUDiJyyD4wk7wyIUI+zfLEZxRnYT1ab25DghJdfgmbLF4iQJatbD7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.244.238])
	by APP-01 (Coremail) with SMTP id qwCowABn_cxZ8yxpqd6vAg--.25095S2;
	Mon, 01 Dec 2025 09:46:03 +0800 (CST)
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
Subject: [PATCH 1/4] RISC-V: KVM: Allow zicfiss/zicfilp exts for Guest/VM
Date: Mon,  1 Dec 2025 09:28:25 +0800
Message-Id: <103e156ea1f2201db52034e370a907f46edafb83.1764509485.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1764509485.git.zhouquan@iscas.ac.cn>
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABn_cxZ8yxpqd6vAg--.25095S2
X-Coremail-Antispam: 1UD129KBjvJXoWxArW8Ww47AryxCF17Jr1fZwb_yoW5GryDpr
	sxCF9akr45C34fua4xtr4kWr48u3y5WwsIgw18u34fXFy2krW8Jr1vya43Ja4DJa10grWv
	9F18Wry8Zws8AwUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
	4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6w
	4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42
	IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYPfHDUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBg0DBmks7HsaLgAAso

From: Quan Zhou <zhouquan@iscas.ac.cn>

Extend the KVM ISA extension ONE_REG interface to allow KVM user
space to detect and enable zicfiss/zicfilp exts for Guest/VM,
the rules defined in the spec [1] are as follows:
---
1) Zicfiss extension introduces the SSE field (bit 3) in henvcfg.
If the SSE field is set to 1, the Zicfiss extension is activated
in VS-mode. When the SSE field is 0, the Zicfiss extension remains
inactive in VS-mode.

2) Zicfilp extension introduces the LPE field (bit 2) in henvcfg.
When the LPE field is set to 1, the Zicfilp extension is enabled
in VS-mode. When the LPE field is 0, the Zicfilp extension is not
enabled in VS-mode.

[1] - https://github.com/riscv/riscv-cfi

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/uapi/asm/kvm.h | 2 ++
 arch/riscv/kvm/vcpu.c             | 6 ++++++
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 759a4852c09a..7ca087848a43 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -190,6 +190,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFBFMIN,
 	KVM_RISCV_ISA_EXT_ZVFBFMIN,
 	KVM_RISCV_ISA_EXT_ZVFBFWMA,
+	KVM_RISCV_ISA_EXT_ZICFILP,
+	KVM_RISCV_ISA_EXT_ZICFISS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 5ce35aba6069..098d77f9a886 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -557,6 +557,12 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	if (riscv_isa_extension_available(isa, ZICBOZ))
 		cfg->henvcfg |= ENVCFG_CBZE;
 
+	if (riscv_isa_extension_available(isa, ZICFILP))
+		cfg->henvcfg |= ENVCFG_LPE;
+
+	if (riscv_isa_extension_available(isa, ZICFISS))
+		cfg->henvcfg |= ENVCFG_SSE;
+
 	if (riscv_isa_extension_available(isa, SVADU) &&
 	    !riscv_isa_extension_available(isa, SVADE))
 		cfg->henvcfg |= ENVCFG_ADUE;
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 865dae903aa0..3d05a4bafd9b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -72,6 +72,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZICBOP),
 	KVM_ISA_EXT_ARR(ZICBOZ),
 	KVM_ISA_EXT_ARR(ZICCRSE),
+	KVM_ISA_EXT_ARR(ZICFILP),
+	KVM_ISA_EXT_ARR(ZICFISS),
 	KVM_ISA_EXT_ARR(ZICNTR),
 	KVM_ISA_EXT_ARR(ZICOND),
 	KVM_ISA_EXT_ARR(ZICSR),
-- 
2.34.1


