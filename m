Return-Path: <kvm+bounces-69312-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DHsFp18eWldxQEAu9opvQ
	(envelope-from <kvm+bounces-69312-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:03:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4349C773
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F6053018432
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC7C2D1911;
	Wed, 28 Jan 2026 03:03:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BB72C21FC;
	Wed, 28 Jan 2026 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769569423; cv=none; b=ZvWoEEmieSTOrWNONxlhjjl4+dN9maoEdKW2aw0QBx+kPeVoUnRGBg5MrBMZ8G17nqujBjOwPjyRYzdiqq038YsfkKvfQpogg9SKtSV+5mfxNzqnf8c83b7k+k8F6YKv5/ud2rNCVEgzvJPKMNa1DgDTg1R91fSXM1r/sKKyAUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769569423; c=relaxed/simple;
	bh=gAwny8OZzvfnbjPD3B86e6aAZqp3ru61Y/0DFJxWgm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=goCvC5qP+8oPiBeKDlHYtDiYCQ/WOpTAnrmXszPVHDK2RdEt9KhdB5o/vds8tBpp2JX6lnlvvfqT1RXQyZEfgLgdhekDUbaqwzFtLSM5wpleyXYU3Wk9mQJXJWgBoJckmLKD3ogM1+xX6GkM+jGbM8GJmf8aUHYshL9ted9DI6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx58GEfHlp_mINAA--.31763S3;
	Wed, 28 Jan 2026 11:03:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxaeB_fHlpfUg2AA--.40601S4;
	Wed, 28 Jan 2026 11:03:31 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/4] LoongArch: KVM: Add msgint registers in function kvm_init_gcsr_flag
Date: Wed, 28 Jan 2026 11:03:24 +0800
Message-Id: <20260128030326.3377462-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260128030326.3377462-1-maobibo@loongson.cn>
References: <20260128030326.3377462-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxaeB_fHlpfUg2AA--.40601S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69312-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D4349C773
X-Rspamd-Action: no action

Add flag HW_GCSR with msgint registers in function kvm_init_gcsr_flag().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/loongarch.h | 2 +-
 arch/loongarch/kvm/main.c              | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 553c4dc7a156..9ca18af11d25 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -688,8 +688,8 @@
 #define LOONGARCH_CSR_ISR1		0xa1
 #define LOONGARCH_CSR_ISR2		0xa2
 #define LOONGARCH_CSR_ISR3		0xa3
-
 #define LOONGARCH_CSR_IRR		0xa4
+#define LOONGARCH_CSR_IPR		0xa5
 
 #define LOONGARCH_CSR_PRID		0xc0
 
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..3ecd7de110d7 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -192,6 +192,14 @@ static void kvm_init_gcsr_flag(void)
 	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR2);
 	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL3);
 	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
+
+	if (cpu_has_msgint) {
+		set_gcsr_hw_flag(LOONGARCH_CSR_ISR0);
+		set_gcsr_hw_flag(LOONGARCH_CSR_ISR1);
+		set_gcsr_hw_flag(LOONGARCH_CSR_ISR2);
+		set_gcsr_hw_flag(LOONGARCH_CSR_ISR3);
+		set_gcsr_hw_flag(LOONGARCH_CSR_IPR);
+	}
 }
 
 static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
-- 
2.39.3


