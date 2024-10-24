Return-Path: <kvm+bounces-29627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6C69AE4BD
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20D85B214BF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC1A1D5AA7;
	Thu, 24 Oct 2024 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ekd1+zEK"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0275418784C
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729772938; cv=none; b=is3FzPkD0p2nbrfWOoxLm6X3xVKlvTete2mMV3/twQ/kRhj8KEVo25zKOTqKkRTZQM+NpL5C47E5ZNf/cxq6h7lJWd7q+spOGrKDwgUwuYHBL7r7JEAmMzsR5GkpFSGaNT6ehAUVGyG8Xh7R0gJCKLHnpmrd/uMIotp6T6AUQ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729772938; c=relaxed/simple;
	bh=+3N3tPmq9Enxzcre2jV43GQ8dmZ+Ady39InNYSJ5PNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCawYtNq1dOJwebsColZa1da26uMVygbIoXY4IFUSoB/6LjU4Rqh4UFgljwL3Q2SqLF87RtJpCu0gGAm4bzKqL3Klkn+jS0SvWdbM7RC7vM5eQI+Toj42ZJE8wdVmXClbdLRH14VZXKhR134ooDV9Dbn5nArHWDfUXQ95gz6olk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ekd1+zEK; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729772932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrJKQYsqPwfe+UgIDxmj85EUMOBw0DGpaZVWjzi1Ymg=;
	b=Ekd1+zEKQDJLHGukcW5X+Va3WoHLQu4VX98H9BK4ukiC1n2JeRaXb3pgtRnrN8Ww0x32lN
	CHzACX2HJ6KyLui+rATAalHJ8tDcI7NNQXv3L8ODilKsxMpud9VgVOzWvpzxO1FV5RzXki
	JKeEQ01l7PThEB35FSxRA/ZdKcLaKFA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/2] riscv: Add sbi_send_ipi_broadcast
Date: Thu, 24 Oct 2024 14:28:41 +0200
Message-ID: <20241024122839.71753-5-andrew.jones@linux.dev>
In-Reply-To: <20241024122839.71753-4-andrew.jones@linux.dev>
References: <20241024122839.71753-4-andrew.jones@linux.dev>
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


