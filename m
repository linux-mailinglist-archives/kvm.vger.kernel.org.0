Return-Path: <kvm+bounces-54324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63632B1E67E
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 12:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0EBF1AA6911
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 10:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A777526A08D;
	Fri,  8 Aug 2025 10:31:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED75274B31;
	Fri,  8 Aug 2025 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754649073; cv=none; b=es57H4ImTfvHB91qx/U2ikqi4CJyUj4bQd+bHJx9Dss6lWFC33wZsCiXvVLi0InX0q90Ud16W+6Eq+Hmuuk9bhO7wfTI5Myd7xktAEifmoPaH6ARDFivePKA3c3Vyk8JsK8t0fNfeFZG30+PgHe7utyDUFyA5RilvoykikV5f8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754649073; c=relaxed/simple;
	bh=psk0oEkhimanl84EGsqyVdkEo3Ui5EXSywnjKYo345U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OrIO2T4Ir5b7I9Z6pCWywGd+fl2bA1FNrWgQR7rAJo+hPVujuhaC1rZHPVzYFx1yFPygOBBz4EixP1n27Nn8QzXV1pB7s7wprY2pTXGfgYqXOJQkC/QPSTXDgYoXGgAaR9X7ovkhKeZHgHNORuNNiLQcLfIPuzYPS0Tsct8qYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.92.164])
	by APP-03 (Coremail) with SMTP id rQCowACH4YLG0ZVoPyBQCg--.7105S2;
	Fri, 08 Aug 2025 18:30:31 +0800 (CST)
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
Subject: [PATCH v2 5/6] KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
Date: Fri,  8 Aug 2025 18:19:00 +0800
Message-Id: <076908690c15070f907f43d2ff81ba7e95582ec7.1754646071.git.zhouquan@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACH4YLG0ZVoPyBQCg--.7105S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1DAF15Jw47Aw1fGw1rWFg_yoWrWw45pr
	1kAanxGr18Z3s3Z392kF98Gw4xXr4UJw4kCw4xur1fZFyjy34xJw1qya43Gr4Dta4Fqr4S
	vF4rWr42ya1FyrUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8tw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42
	IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUeXo2DUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCREIBmiVopSTyQAAsH

From: Quan Zhou <zhouquan@iscas.ac.cn>

The KVM RISC-V allows Zicbop extension for Guest/VM
so add them to get-reg-list test.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index a0b7dabb5040..e60e1975095b 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -83,6 +83,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICCRSE:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICNTR:
@@ -255,6 +256,8 @@ static const char *config_id_to_str(const char *prefix, __u64 id)
 		return "KVM_REG_RISCV_CONFIG_REG(zicbom_block_size)";
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
 		return "KVM_REG_RISCV_CONFIG_REG(zicboz_block_size)";
+	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
+		return "KVM_REG_RISCV_CONFIG_REG(zicbop_block_size)";
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		return "KVM_REG_RISCV_CONFIG_REG(mvendorid)";
 	case KVM_REG_RISCV_CONFIG_REG(marchid):
@@ -535,6 +538,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZFH),
 		KVM_ISA_EXT_ARR(ZFHMIN),
 		KVM_ISA_EXT_ARR(ZICBOM),
+		KVM_ISA_EXT_ARR(ZICBOP),
 		KVM_ISA_EXT_ARR(ZICBOZ),
 		KVM_ISA_EXT_ARR(ZICCRSE),
 		KVM_ISA_EXT_ARR(ZICNTR),
@@ -864,6 +868,11 @@ static __u64 zicbom_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM,
 };
 
+static __u64 zicbop_regs[] = {
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicbop_block_size),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP,
+};
+
 static __u64 zicboz_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicboz_block_size),
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ,
@@ -1012,6 +1021,8 @@ static __u64 vector_regs[] = {
 	 .regs = sbi_sta_regs, .regs_n = ARRAY_SIZE(sbi_sta_regs),}
 #define SUBLIST_ZICBOM \
 	{"zicbom", .feature = KVM_RISCV_ISA_EXT_ZICBOM, .regs = zicbom_regs, .regs_n = ARRAY_SIZE(zicbom_regs),}
+#define SUBLIST_ZICBOP \
+	{"zicbop", .feature = KVM_RISCV_ISA_EXT_ZICBOP, .regs = zicbop_regs, .regs_n = ARRAY_SIZE(zicbop_regs),}
 #define SUBLIST_ZICBOZ \
 	{"zicboz", .feature = KVM_RISCV_ISA_EXT_ZICBOZ, .regs = zicboz_regs, .regs_n = ARRAY_SIZE(zicboz_regs),}
 #define SUBLIST_AIA \
@@ -1130,6 +1141,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
 KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
+KVM_ISA_EXT_SUBLIST_CONFIG(zicbop, ZICBOP);
 KVM_ISA_EXT_SUBLIST_CONFIG(zicboz, ZICBOZ);
 KVM_ISA_EXT_SIMPLE_CONFIG(ziccrse, ZICCRSE);
 KVM_ISA_EXT_SIMPLE_CONFIG(zicntr, ZICNTR);
@@ -1204,6 +1216,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zfh,
 	&config_zfhmin,
 	&config_zicbom,
+	&config_zicbop,
 	&config_zicboz,
 	&config_ziccrse,
 	&config_zicntr,
-- 
2.34.1


