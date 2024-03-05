Return-Path: <kvm+bounces-10972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A6E871DEA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FBA7284AC9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F026E1B94A;
	Tue,  5 Mar 2024 11:33:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6B710A1B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 11:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638428; cv=none; b=UP93FoKgT6nOwv3u21xnQhHOe2cFRy9CIvVSd2oivIoetB/v7Zx6gmukl/kOUyV6TLWaN7bO1m+XMmbyeqSaWmV9f0QLl4M2WDCR+ikZGh1ooN4qIDToC+aohnOyBhePTEbX4ZADHfMfcAUlCFoDQQ4PWCcD3YpT1YPT4vvl8s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638428; c=relaxed/simple;
	bh=Dob+dauGojVOH765x0xny+31pEVfg1FQeksdsGbh874=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bapErYvDm1zUCPjgHpM15XEUhwHRNSptlSueZu4xyimxPYvW6Odk/Y7yNv2TeeS1B44H9a0uDBteL8ihkq7KiMpgCZMq9nwA8N1tcCUj/CncnS9sDWuazZQ/Yd7APm126SR77KUDsd7sXCrZjtaXDok/TfZPLV4Ewr1nGnyvcAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxafAYA+dlgr8UAA--.52208S3;
	Tue, 05 Mar 2024 19:33:44 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHBMXA+dlHIdOAA--.12290S2;
	Tue, 05 Mar 2024 19:33:43 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: [PATCH] LoongArch: KVM: Set reserved bit as zero about cpucfg
Date: Tue,  5 Mar 2024 19:33:43 +0800
Message-Id: <20240305113343.1667480-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHBMXA+dlHIdOAA--.12290S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kw4xtFWrGF1xJr4xZrWfCrX_yoW8Zr4kpr
	4Uurs5WryrKr1Iq3ZYqryv9r45Gr4xCrW7AFyFyayq9r1DWry7XrWrKFZxtF1rW34fuFyx
	uws5Aa1Y9a1DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU

Supported cpucfg information comes from function _kvm_get_cpucfg_mask().
It should be zero if it is reserved by HW or if it is not supported
by KVM.

Also LoongArch software page table walk feature defined in CPUCFG2_PTW
is supported by KVM, it should be enabled by default.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 36106922b5d7..fc25c406021c 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -304,11 +304,15 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		return -EINVAL;
 
 	switch (id) {
-	case 2:
+	case LOONGARCH_CPUCFG1:
+		/* CPUCFG1_MSGINT is not supported by KVM */
+		*v = GENMASK(25, 0);
+		return 0;
+	case LOONGARCH_CPUCFG2:
 		/* CPUCFG2 features unconditionally supported by KVM */
 		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
 		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
-		     CPUCFG2_LAM;
+		     CPUCFG2_LSPW | CPUCFG2_LAM;
 		/*
 		 * For the ISA extensions listed below, if one is supported
 		 * by the host, then it is also supported by KVM.
@@ -318,6 +322,21 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
+		return 0;
+	case LOONGARCH_CPUCFG3:
+		*v = GENMASK(16, 0);
+		return 0;
+	case LOONGARCH_CPUCFG6:
+		/* PMU is not supported by KVM now */
+	case LOONGARCH_CPUCFG6 + 1 ... LOONGARCH_CPUCFG16 - 1:
+		/* Not used by HW now, need be zero */
+		*v = 0;
+		return 0;
+	case LOONGARCH_CPUCFG16:
+		*v = GENMASK(16, 0);
+		return 0;
+	case LOONGARCH_CPUCFG17 ... LOONGARCH_CPUCFG20:
+		*v = GENMASK(30, 0);
 		return 0;
 	default:
 		/*
@@ -344,7 +363,7 @@ static int kvm_check_cpucfg(int id, u64 val)
 		return -EINVAL;
 
 	switch (id) {
-	case 2:
+	case LOONGARCH_CPUCFG2:
 		if (!(val & CPUCFG2_LLFTP))
 			/* Guests must have a constant timer */
 			return -EINVAL;
-- 
2.39.3


