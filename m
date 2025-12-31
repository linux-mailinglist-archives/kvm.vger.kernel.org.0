Return-Path: <kvm+bounces-66895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12122CEB056
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 03:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5CE530274CC
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 02:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFAA2E2EF2;
	Wed, 31 Dec 2025 02:02:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EC64C97;
	Wed, 31 Dec 2025 02:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767146556; cv=none; b=aVuUWpnOz5FCYHol/AGFy3cF8amcjRrl8+BBuPd/b8uxmZ5oEIyUfVEeR/r2JBI8umB7rad/L6wQExmLIyfbLvFuXGOZ4Z3oeJ2XSv245XGIcT/PpxuDuy/v4hL4on/QzQUdsix4pQyeyb0+K2GKGug5J5eVIKqFHxKni/y4sKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767146556; c=relaxed/simple;
	bh=drnsnZCelkmQkFEiAHBdIyO3q3CY+mEYiFRDgi58mJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C/P/OaaDWTbVp2nvmZdnubV+1e+5/doFu7T7CszM8dP47oQBUhjDYpEm9hZfaHS09cI5ziCNAfKCOT+zBrQFd2qG3YHbgA/a1ioW0RZFN3XtyA6aDaoBGiz4q4lVRiN3sunux1xQV5JvmGJsgYju3POQS1imbmMrPfhNLdl8/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxVvA1hFRpTo8EAA--.14867S3;
	Wed, 31 Dec 2025 10:02:29 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxLMI0hFRpaW4HAA--.16667S2;
	Wed, 31 Dec 2025 10:02:28 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add more CPUCFG mask bit
Date: Wed, 31 Dec 2025 10:02:27 +0800
Message-Id: <20251231020227.1526779-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxLMI0hFRpaW4HAA--.16667S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With LA664 CPU there are more features supported which are indicated
in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. These features do
not depend on KVM and there is no KVM exception when it is used in
VM mode.

Here add more CPUCFG mask support with LA664 if VM is configured with
host CPU model.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/loongarch.h |  7 +++++++
 arch/loongarch/kvm/vcpu.c              | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index e6b8ff61c8cc..553c4dc7a156 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -94,6 +94,12 @@
 #define  CPUCFG2_LSPW			BIT(21)
 #define  CPUCFG2_LAM			BIT(22)
 #define  CPUCFG2_PTW			BIT(24)
+#define  CPUCFG2_FRECIPE		BIT(25)
+#define  CPUCFG2_DIV32			BIT(26)
+#define  CPUCFG2_LAM_BH			BIT(27)
+#define  CPUCFG2_LAMCAS			BIT(28)
+#define  CPUCFG2_LLACQ_SCREL		BIT(29)
+#define  CPUCFG2_SCQ			BIT(30)
 
 #define LOONGARCH_CPUCFG3		0x3
 #define  CPUCFG3_CCDMA			BIT(0)
@@ -108,6 +114,7 @@
 #define  CPUCFG3_SPW_HG_HF		BIT(11)
 #define  CPUCFG3_RVA			BIT(12)
 #define  CPUCFG3_RVAMAX			GENMASK(16, 13)
+#define  CPUCFG3_DBAR_HINTS		BIT(17)
 #define  CPUCFG3_ALDORDER_CAP		BIT(18) /* All address load ordered, capability */
 #define  CPUCFG3_ASTORDER_CAP		BIT(19) /* All address store ordered, capability */
 #define  CPUCFG3_ALDORDER_STA		BIT(20) /* All address load ordered, status */
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..9d186004670c 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 
 static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
+	unsigned int config;
+
 	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
 		return -EINVAL;
 
@@ -684,9 +686,18 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		if (cpu_has_ptw)
 			*v |= CPUCFG2_PTW;
 
+		/*
+		 * Some features depends on host and they are irrelative with
+		 * KVM hypervisor
+		 */
+		config = read_cpucfg(LOONGARCH_CPUCFG2);
+		*v |= config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCFG2_LAM_BH);
+		*v |= config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | CPUCFG2_SCQ);
 		return 0;
 	case LOONGARCH_CPUCFG3:
 		*v = GENMASK(16, 0);
+		config = read_cpucfg(LOONGARCH_CPUCFG3);
+		*v |= config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDER_STA);
 		return 0;
 	case LOONGARCH_CPUCFG4:
 	case LOONGARCH_CPUCFG5:

base-commit: dbf8fe85a16a33d6b6bd01f2bc606fc017771465
-- 
2.39.3


