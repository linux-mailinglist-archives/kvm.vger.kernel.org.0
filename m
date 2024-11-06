Return-Path: <kvm+bounces-30923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8641F9BE5C2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A59B28504D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CEB1DED44;
	Wed,  6 Nov 2024 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DAvbv7zs"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A591DF25D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893110; cv=none; b=aitwN6qcn9NZW6rgRj71Bw8VBA5s5UGIIs0RNQElyX1fE4JMv323Fx5HCi7UfY1p2pHux2MlJoIay9cl+H1fJt9+vdsj3pbPE2ZggTKUKxfXorAHKqemwadv/hr4lePk0Wnm148I//Sq2UIJiRk3q1BCtlf/Vt17x8xOAWNJez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893110; c=relaxed/simple;
	bh=+3N3tPmq9Enxzcre2jV43GQ8dmZ+Ady39InNYSJ5PNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSYXk9ChrPr3MIRnc5M7TWZ4L9V19w12TZi2dq+Ns0XLmooIB4Bv+TKZ4sQ8igMaOYEqkOZfmogCxXhkDi60LXCHheWwnwibp4sl/S1aD4P+WQb9uFLB8VP1DAu5iqjxSz0PgsSDYtweg7jYgyWhpvMFYMC7b0H1oleoQTcvwYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DAvbv7zs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730893103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrJKQYsqPwfe+UgIDxmj85EUMOBw0DGpaZVWjzi1Ymg=;
	b=DAvbv7zs/SfPNk1LVBFE5rQsOlzAM2Bk+0rhx8Az5ssH2roZPbYm6nFYOHhF69DqjkdbXI
	aiAf9LTeVb3O/P+Bn372MgeGFRTK+SoVpy371ifF9X0TKPIXy6YUnwGOtv+RFafcp+9kvC
	+NcFHtIvH0HG9DsYCG4Par8HRE1Ca9U=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 1/3] riscv: Add sbi_send_ipi_broadcast
Date: Wed,  6 Nov 2024 12:38:16 +0100
Message-ID: <20241106113814.42992-6-andrew.jones@linux.dev>
In-Reply-To: <20241106113814.42992-5-andrew.jones@linux.dev>
References: <20241106113814.42992-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Coming SBI IPI tests will use this, but as it could be useful for
other tests too, add it to the library.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h | 1 +
 lib/riscv/sbi.c     | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 1319439b7118..102486c00de3 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -87,6 +87,7 @@ struct sbiret sbi_hart_get_status(unsigned long hartid);
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
 struct sbiret sbi_send_ipi_cpu(int cpu);
 struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
+struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
 long sbi_probe(int ext);
 
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index f25bde169490..02dd338c1915 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -62,13 +62,18 @@ struct sbiret sbi_send_ipi_cpu(int cpu)
 	return sbi_send_ipi(1UL, cpus[cpu].hartid);
 }
 
+struct sbiret sbi_send_ipi_broadcast(void)
+{
+	return sbi_send_ipi(0, -1UL);
+}
+
 struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask)
 {
 	struct sbiret ret;
 	cpumask_t tmp;
 
 	if (cpumask_full(mask))
-		return sbi_send_ipi(0, -1UL);
+		return sbi_send_ipi_broadcast();
 
 	cpumask_copy(&tmp, mask);
 
-- 
2.47.0


