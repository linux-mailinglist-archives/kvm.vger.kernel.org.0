Return-Path: <kvm+bounces-25505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B75965FE3
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E59CD1F239C1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA48E199942;
	Fri, 30 Aug 2024 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qOJOf9FH"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6711D19992C
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015703; cv=none; b=mYfDKW2I5m5XHfRgI8D/tKNG+wBgl/73rzMKC0fpJeOCol5twwn3OZUUhV6QlU/W9r2CitTvfRZEzzWRXs/K524txkF+N82dI+VWp9lgtuJ7TM6TqMVUwJoUiHthZSyaxdaJ9YbZZqXBvCxjI/zZZ9mEq9s887VvjiHozCanZXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015703; c=relaxed/simple;
	bh=OU3ZD/tINDeCZzbqkPivzNhufEb02y3r9eN2e0aJmwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5fseCZeBhRE6LkGzEZ76sk9jWz9K4W52ZXo3LyD+bqERUsinLNaW15a9+UKjX2OSGuUhBW4xwf4nUBX9MnF2cHnjey+kbO9utmTh13rpCG1aFvdmBxHjWVrAXASfYNdcsySgbigZgu5MmAgFKldreKSBToHer2Kbotcw38jPEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qOJOf9FH; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725015699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N909z69GYkPeqBou+7oKeymfZidniJoL6acPvqa0aHg=;
	b=qOJOf9FHZ51yqmsKwBUFLrW9jQ6a/Qlimn0+rylZLssY5oqmaFSuXZw0Gw6ZvQtRdW5xq9
	Ep1c/gALxnv/rM0zbfdWs2NS66eh+PD0g8mi5pVOvw/jClEAaKnPMFmHwrUH6P6Hijdy9K
	M2FJ1q4k1vTj2uo3RWaVA8SQ39oBW+8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 4/3] riscv: Provide helpers for IPIs
Date: Fri, 30 Aug 2024 13:01:36 +0200
Message-ID: <20240830110135.2232665-2-andrew.jones@linux.dev>
In-Reply-To: <20240830101221.2202707-5-andrew.jones@linux.dev>
References: <20240830101221.2202707-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Provide a few functions to enable/disable/acknowledge IPIs.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/csr.h       |  3 ++-
 lib/riscv/asm/processor.h | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 24b333e02589..16f5ddd762de 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -51,7 +51,8 @@
 #define IRQ_S_GEXT		12
 #define IRQ_PMU_OVF		13
 
-#define IE_TIE			(_AC(0x1, UL) << IRQ_S_TIMER)
+#define IE_SSIE			(_AC(1, UL) << IRQ_S_SOFT)
+#define IE_TIE			(_AC(1, UL) << IRQ_S_TIMER)
 
 #define IP_TIP			IE_TIE
 
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 4c9ad968460d..8989d8d686f9 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -32,6 +32,21 @@ static inline void local_irq_disable(void)
 	csr_clear(CSR_SSTATUS, SR_SIE);
 }
 
+static inline void local_ipi_enable(void)
+{
+	csr_set(CSR_SIE, IE_SSIE);
+}
+
+static inline void local_ipi_disable(void)
+{
+	csr_clear(CSR_SIE, IE_SSIE);
+}
+
+static inline void ipi_ack(void)
+{
+	csr_clear(CSR_SIP, IE_SSIE);
+}
+
 void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
 void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
 void do_handle_exception(struct pt_regs *regs);
-- 
2.45.2


