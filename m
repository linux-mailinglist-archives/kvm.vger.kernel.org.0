Return-Path: <kvm+bounces-23820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CAC94E554
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 05:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9384B1C20FFA
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 03:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D532495E5;
	Mon, 12 Aug 2024 03:02:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B5455C29;
	Mon, 12 Aug 2024 03:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723431737; cv=none; b=g7xoGqd7MgAyyf8EfD8vKcxBK2ren0cDc8v8kDV6lEyN2ZdwnqnBHhFqnFTWzmFweUpFKXGno9UFdWRYiuQYZKiB+2bBz+BvfT0GYXY1G/UWJzE33E06ApIcEtxKTrUxT6xTcpH7cfUs758RGJ70nt/OUAnicAjBL0PQ8wk+4Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723431737; c=relaxed/simple;
	bh=MKI/sWHIyLgpfqJt/N3sHA/FKOoAGPohHnYGV6nLDQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pGjPsJ4aVYBnNBMcxGRlbrXhXSbV45F4JoxPBvodVoRGXTH8+oQkW+WqlI7hgdORvUbi44owCwbLtNmur9D50NqwbRX3EveQL2bWUDNq1w8k9LTZJrhDxxFzL78avi/9Aqr/f8dN0X8EDKWb4esA2Qt50cyHhyk0jWdsUUuKbAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx25o1e7lmn1AQAA--.5370S3;
	Mon, 12 Aug 2024 11:02:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxvmcze7lmTagPAA--.59431S4;
	Mon, 12 Aug 2024 11:02:12 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org,
	Song Gao <gaosong@loongson.cn>
Subject: [PATCH v6 2/3] LoongArch: KVM: Implement function kvm_para_has_feature
Date: Mon, 12 Aug 2024 11:02:09 +0800
Message-Id: <20240812030210.500240-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240812030210.500240-1-maobibo@loongson.cn>
References: <20240812030210.500240-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxvmcze7lmTagPAA--.59431S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_para_has_feature() is to detect supported paravirt features,
it can be used by device driver to detect and enable paravirt features,
such as extioi irqchip driver can detect KVM_FEATURE_VIRT_EXTIOI and do
some optimization.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_para.h | 10 +++++++++
 arch/loongarch/kernel/paravirt.c      | 31 ++++++++++++++-------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 39d7483ab8fd..2174fb53c2e7 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -155,10 +155,20 @@ static __always_inline long kvm_hypercall5(u64 fid,
 	return ret;
 }
 
+#ifdef CONFIG_PARAVIRT
+bool kvm_para_available(void);
+unsigned int kvm_arch_para_features(void);
+#else
+static inline bool kvm_para_available(void)
+{
+	return false;
+}
+
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return 0;
 }
+#endif
 
 static inline unsigned int kvm_arch_para_hints(void)
 {
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index cc6bf096cb88..dc3cebcb550a 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -151,11 +151,14 @@ static void pv_init_ipi(void)
 }
 #endif
 
-static bool kvm_para_available(void)
+bool kvm_para_available(void)
 {
 	int config;
 	static int hypervisor_type;
 
+	if (!cpu_has_hypervisor)
+		return false;
+
 	if (!hypervisor_type) {
 		config = read_cpucfg(CPUCFG_KVM_SIG);
 		if (!memcmp(&config, KVM_SIGNATURE, 4))
@@ -165,17 +168,21 @@ static bool kvm_para_available(void)
 	return hypervisor_type == HYPERVISOR_KVM;
 }
 
-int __init pv_ipi_init(void)
+unsigned int kvm_arch_para_features(void)
 {
-	int feature;
+	static int feature;
 
-	if (!cpu_has_hypervisor)
-		return 0;
 	if (!kvm_para_available())
 		return 0;
 
-	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
-	if (!(feature & BIT(KVM_FEATURE_IPI)))
+	if (!feature)
+		feature = read_cpucfg(CPUCFG_KVM_FEATURE);
+	return feature;
+}
+
+int __init pv_ipi_init(void)
+{
+	if (!kvm_para_has_feature(KVM_FEATURE_IPI))
 		return 0;
 
 #ifdef CONFIG_SMP
@@ -258,15 +265,9 @@ static struct notifier_block pv_reboot_nb = {
 
 int __init pv_time_init(void)
 {
-	int r, feature;
-
-	if (!cpu_has_hypervisor)
-		return 0;
-	if (!kvm_para_available())
-		return 0;
+	int r;
 
-	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
-	if (!(feature & BIT(KVM_FEATURE_STEAL_TIME)))
+	if (!kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
 		return 0;
 
 	has_steal_clock = 1;
-- 
2.39.3


