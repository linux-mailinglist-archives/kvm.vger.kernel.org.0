Return-Path: <kvm+bounces-27356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0846F984420
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 807EEB253FB
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C771A4F06;
	Tue, 24 Sep 2024 11:04:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDAF19B3F3
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727175846; cv=none; b=fAhB9vkV3Wq8IE1Spwf8sZfC7zLbYxPob7Zs6hcuKDLZ7hmP3RX1MbOoT2GBMuAVTQyugJDSvublrnu+cKsuJnqNRCt2Fm85HlTKONPHpQvkT9Uc81IsxX3vAYcZtD5+M8X1VMVm36NRe+lr8bQIxE/KtYPRPZD+0ArOBB6JObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727175846; c=relaxed/simple;
	bh=Xm+pDKX9QApoZdN44n0igXyHCenHjPcvQVoDQ00VSJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vAhRGcHWjaymBa8bcyjZEE/tcgAzFMkqUzAQz+CptYP8mykj6XHDXEZJMbRcZjCT7EGRPHClx7J6y86ruBvlFJv4QUQ5y9xIjLMgEAGvmp+yHh3JpxgxPV3+w/SfyJyitK4VBQaQ1lfdlZ5irs87kdpOH2uOPyy5jDuD2mrMOnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.111.100.113])
	by APP-03 (Coremail) with SMTP id rQCowACnrKyZnPJmGWmlAA--.936S2;
	Tue, 24 Sep 2024 19:03:54 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	pbonzini@redhat.com,
	anup@brainfault.org,
	ajones@ventanamicro.com,
	zhouquan@iscas.ac.cn
Subject: [kvmtool PATCH 2/2] riscv: Add Zc*/Zimop/Zcmop/Zawrs exts support
Date: Tue, 24 Sep 2024 19:03:53 +0800
Message-Id: <2b02ee03d0a952ff876d8423cf66031436dfaadf.1727174321.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1727174321.git.zhouquan@iscas.ac.cn>
References: <cover.1727174321.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnrKyZnPJmGWmlAA--.936S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFy3uFykuF15tF43tF1fWFg_yoW5CryDpr
	n2y343KrZ8XasI9ayxtr98Cw15XrW5Z393Gw429rs3try3AryfJF95G3ZxW3WDJa4F9F9I
	vF4kXr1Ivr4Fyr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xx
	MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7VU1x9NDUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBwwKBmbyg6BWdwAAsR

From: Quan Zhou <zhouquan@iscas.ac.cn>

When the Zc*/Zimop/Zcmop/Zawrs extensions are available
expose them to the guest via device tree so that guest can use it.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 riscv/fdt.c                         |  7 +++++++
 riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index e331f80..6af639f 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -24,6 +24,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
+	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
@@ -31,6 +32,12 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zca", KVM_RISCV_ISA_EXT_ZCA},
+	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
+	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
+	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
+	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP},
+	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 3fbc4f7..ed9b9e5 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -49,6 +49,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zawrs",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZAWRS],	\
+		    "Disable Zawrs Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zba",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBA],	\
 		    "Disable Zba Extension"),				\
@@ -70,6 +73,24 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zca",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCA],	\
+		    "Disable Zca Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCB],	\
+		    "Disable Zcb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcd",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCD],	\
+		    "Disable Zcd Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcf",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCF],	\
+		    "Disable Zcf Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcmop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCMOP],	\
+		    "Disable Zcmop Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zimop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIMOP],	\
+		    "Disable Zimop Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.34.1


