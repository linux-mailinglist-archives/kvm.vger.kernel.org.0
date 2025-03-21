Return-Path: <kvm+bounces-41690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94FB2A6C0AC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C30513B2938
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEFB422D7BE;
	Fri, 21 Mar 2025 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DzV+ddJu"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28322D786
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576055; cv=none; b=ltKzLU7Se12a9OaXN1bBdrTimaR+jXfZzEg1h/i7zGDHtfI3f7jmVpiPQg/GirWJHYaKwqXOqkanEihgG+umxdLP7ndzIKuEMYmhCmmF4Fp/zBLlnDwa4HXfvMG6b3Jle9iVnP2YvcguQ3Ndvkqony/eGS4ZEojrvUwU3Ki/EF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576055; c=relaxed/simple;
	bh=sxgvp/HlbbMAhjzZBi4WoFmdngeoDetQ93BR65bG61E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaI3e+VmR7Z9zWIaljHG3agE8VKAdRZyWr8YUKR0eBrMVz+QMm4Te8UVjVlO2mvNGR+2FCFUCjrmd+tAWKD84sgx9mNYEbEcTOGeuMZk/jHyqz+jTXlP67xfbvatq8wO1ycdf8C93swGZfAXqGrWkDP5pBi9WSxML7+RBgNs/ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DzV+ddJu; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742576049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9zKZEdfQYZeghDcnUUsQR01GtR2H7Xuam0AVo+Vzx0=;
	b=DzV+ddJu0d7wt8hCmpHLUTZn0Jgcfy5vaXvNYtiEoXyOkAoIfE1oEiZ5an96GxNgoXf1aN
	H0jyEm4J6YrP8XbtY6T/FwFPDtQpybRRKykQv/xLAOty5mBhqCPzofFBq/CE2P1TLT1IuV
	tsF4wVQnnnV3wWG19aK0KJjxeZqJk04=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: cleger@rivosinc.com,
	atishp@rivosinc.com,
	akshaybehl231@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] lib/riscv: Also provide sbiret impl functions
Date: Fri, 21 Mar 2025 17:54:05 +0100
Message-ID: <20250321165403.57859-6-andrew.jones@linux.dev>
In-Reply-To: <20250321165403.57859-5-andrew.jones@linux.dev>
References: <20250321165403.57859-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We almost always return sbiret from sbi wrapper functions so
do that for sbi_get_imp_version() and sbi_get_imp_id(), but
asserting no error and returning the value is also useful,
so continue to provide those functions too, just with a slightly
different name.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h |  6 ++++--
 lib/riscv/sbi.c     | 18 ++++++++++++++----
 riscv/sbi-sse.c     |  4 ++--
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index edaee462c3fa..a5738a5ce209 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -260,9 +260,11 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
 struct sbiret sbi_get_spec_version(void);
-unsigned long sbi_get_imp_version(void);
-unsigned long sbi_get_imp_id(void);
+struct sbiret sbi_get_imp_version(void);
+struct sbiret sbi_get_imp_id(void);
 long sbi_probe(int ext);
+unsigned long __sbi_get_imp_version(void);
+unsigned long __sbi_get_imp_id(void);
 
 typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
 
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 53d25489f905..2959378f64bb 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -183,21 +183,31 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
-unsigned long sbi_get_imp_version(void)
+struct sbiret sbi_get_imp_version(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_get_imp_id(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
+}
+
+unsigned long __sbi_get_imp_version(void)
 {
 	struct sbiret ret;
 
-	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
+	ret = sbi_get_imp_version();
 	assert(!ret.error);
 
 	return ret.value;
 }
 
-unsigned long sbi_get_imp_id(void)
+unsigned long __sbi_get_imp_id(void)
 {
 	struct sbiret ret;
 
-	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
+	ret = sbi_get_imp_id();
 	assert(!ret.error);
 
 	return ret.value;
diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index 97e07725c359..bc6afaf5481e 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -1232,8 +1232,8 @@ void check_sse(void)
 		return;
 	}
 
-	if (sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
-	    sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
+	if (__sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
+	    __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
 		report_skip("OpenSBI < v1.7 detected, skipping tests");
 		report_prefix_pop();
 		return;
-- 
2.48.1


