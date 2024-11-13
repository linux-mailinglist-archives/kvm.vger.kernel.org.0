Return-Path: <kvm+bounces-31705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D888F9C67B8
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CEB8285685
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A1E175D46;
	Wed, 13 Nov 2024 03:17:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B40166F23;
	Wed, 13 Nov 2024 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467855; cv=none; b=iXO6SgmHxRpPE1kBpFaWtcUAIUt3T+TY92zS4anTOql84ZDlHUrYgw7X4wwMU1fgbfJau67Wm/T+2pA6Ra09wSti5sk+qf6oH5YY96s1SiM62sxxoHES+OtsFVt9OJ3a/GetW+iLn9/tzRIwGU0LYRWVXKkW3z+isaX0N6uyOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467855; c=relaxed/simple;
	bh=6lEKy1RfUWoR2IORPrrqQmixVxn3B4fAvLaywOrL9bU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EsJxwwLl6NAxkEOzIjDJeCUBvdc7iKlJpbOkqY5tV2ob4WUPON1XhPSc86HkwCsC3sP66DHIQ83MXAYdsXBeqV5Jyfpy2tqf6+oHgA6ZN54oqim3wwDe1LO5EDOdTxCRXdGhlHFRbnHByQnutKBqZcRO0dnEt/rLStRvmmCUFbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxEK9LGjRnXn08AA--.15146S3;
	Wed, 13 Nov 2024 11:17:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDEdHGjRnX4VTAA--.14727S7;
	Wed, 13 Nov 2024 11:17:31 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 5/5] LoongArch: KVM: Enable separate vmid feature
Date: Wed, 13 Nov 2024 11:17:27 +0800
Message-Id: <20241113031727.2815628-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20241113031727.2815628-1-maobibo@loongson.cn>
References: <20241113031727.2815628-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxDEdHGjRnX4VTAA--.14727S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With CSR GTLBC shortname for Guest TLB Control Register, separate vmid
feature will be enabled if bit 14 CSR_GTLBC_USEVMID is set. Enable
this feature if cpu_has_guestid is true when KVM module is loaded.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/loongarch.h | 2 ++
 arch/loongarch/kvm/main.c              | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 64ad277e096e..5fee5db3bea0 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -326,6 +326,8 @@
 #define  CSR_GTLBC_TGID_WIDTH		8
 #define  CSR_GTLBC_TGID_SHIFT_END	(CSR_GTLBC_TGID_SHIFT + CSR_GTLBC_TGID_WIDTH - 1)
 #define  CSR_GTLBC_TGID			(_ULCAST_(0xff) << CSR_GTLBC_TGID_SHIFT)
+#define  CSR_GTLBC_USEVMID_SHIFT	14
+#define  CSR_GTLBC_USEVMID		(_ULCAST_(0x1) << CSR_GTLBC_USEVMID_SHIFT)
 #define  CSR_GTLBC_TOTI_SHIFT		13
 #define  CSR_GTLBC_TOTI			(_ULCAST_(0x1) << CSR_GTLBC_TOTI_SHIFT)
 #define  CSR_GTLBC_USETGID_SHIFT	12
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f89d1df885d7..50c977d8b414 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -336,7 +336,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 	write_csr_gcfg(0);
 	write_csr_gstat(0);
 	write_csr_gintc(0);
-	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
+	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI | CSR_GTLBC_USEVMID);
 
 	/*
 	 * Enable virtualization features granting guest direct control of
@@ -359,6 +359,8 @@ int kvm_arch_enable_virtualization_cpu(void)
 
 	/* Enable using TGID  */
 	set_csr_gtlbc(CSR_GTLBC_USETGID);
+	if (cpu_has_guestid)
+		set_csr_gtlbc(CSR_GTLBC_USEVMID);
 	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
 		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
 
-- 
2.39.3


