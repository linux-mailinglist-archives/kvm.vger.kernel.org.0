Return-Path: <kvm+bounces-61977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A66B0C30D0F
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 12:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 05D874E315D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 11:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8891E2EB857;
	Tue,  4 Nov 2025 11:47:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0EA2DCBFC;
	Tue,  4 Nov 2025 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762256829; cv=none; b=XVOPQZtaheUfDwSMH/yFXJbFI+/AXYtIA2Vj7tO6/OY8/PFWO7YfvCE4oU09Vw44W1wRwhcY96dFmwMStsb0yBz4NPqhQLaM2ucBnAQ+sWm1tG2V3lZ47J9M5FQilf2SVX3K0Ix3saFOSQ3voMYZGZ2aNR9IXvdnr9f49IEdTBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762256829; c=relaxed/simple;
	bh=lvS0akj3jwhum+640i2yy985glN9eEOQqYjI1B5pOMc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NKhCDfTIQDJ8cq4LBv/SPExMEESgtcNq/2+M6swudu1obFJamldEPZ1IAnerETBZJKdVdnspA86HFQp+Ob2uHglzYtK4uR+qMR5AXMECTD1Fg00xZorfhj0Kq7qeoTl5tEGlD+aBQNaeI6jfojEGUHEYfE4Xyb3sozaUXIhtUbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxztK25wlp6rUeAA--.577S3;
	Tue, 04 Nov 2025 19:47:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxmcC15wlp0jQmAQ--.29563S2;
	Tue, 04 Nov 2025 19:47:01 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add delay until timer interrupt injected
Date: Tue,  4 Nov 2025 19:46:58 +0800
Message-Id: <20251104114659.1562404-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxmcC15wlp0jQmAQ--.29563S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

When timer is fired in oneshot mode, CSR TVAL will stop with value -1
rather than 0. However when register CSR TVAL is restored, it will
continue to count down rather than stop there.

Now the method is to write 0 to CSR TVAL, wait to count down for 1
cycle at least, which is 10ns with timer freq 100MHZ, and retore timer
interrupt status. Here add 2 cycles delay to assure that timer interrupt
is injected.

With this patch, timer selftest case passes to run always.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 32dc213374be..daf1b60a8d47 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
  */
 
+#include <asm/delay.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_csr.h>
 #include <asm/kvm_vcpu.h>
@@ -95,6 +96,8 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
 		 * and set CSR TVAL with -1
 		 */
 		write_gcsr_timertick(0);
+		/* wait more than 1 cycle until timer interrupt injected */
+		__delay(2);
 
 		/*
 		 * Writing CSR_TINTCLR_TI to LOONGARCH_CSR_TINTCLR will clear

base-commit: ec0b62ccc986c06552c57f54116171cfd186ef92
-- 
2.39.3


