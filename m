Return-Path: <kvm+bounces-23859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7624C94EF44
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331542834CA
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74BB180056;
	Mon, 12 Aug 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rpKSyQ3F"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079A217E47A
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472053; cv=none; b=QR0Q2g/GNu9xZ1Et9oooA6Ma8DAoUtszNF0OmRHXDrkKjBRjxmBX4Ay1VHwmbtL4X3sSdoQc48j08GSPCl9pLEzRHUY2maM9NB5dtzfpXsgJ9aDrg01ZMNsTEIJTvEzwv/SYuwPU7Zyg3qiZRzxY2jiIG4PTM5wV8RUEfPC6ke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472053; c=relaxed/simple;
	bh=6r69o0zE75H6qw4cYsnPPRHWY+q/RRQce7FwlyNhs5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXvX1XLd+GLoQHQupOw3o/ve0W/cv+i5sxQcJyRGIERstg9Mu+mBwZ0752wneqrxmaFSDwpZoj575JYSA9e/xRQNmaflN4IMhAEeGEJ+NUk+yExcacLVjUqzwjVoNJ127c84zcGMYNrxym91C9gtF6wKDpudCP/icdHhdFPlQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rpKSyQ3F; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+e3Q8KOZHypd1yOxyWSLWdeBIgtLiWk/Fp9jlVyymY=;
	b=rpKSyQ3FTDFuqrhN9P85IbxO3DCJeflCl5eY89sAc8XOADDnqMGrD2KlcIwWKevSdR6iUo
	f55sl8gMENhjuYLmR1wUvvgE3u2ADH7SvRlkZztQr8gR9+22z39/i/ZrRCqMmlKul1jrlZ
	qciR8NBE1mswWpy7ogzIejTobxoXVl4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/4] riscv: sbi: Prefix several environment variables with SBI
Date: Mon, 12 Aug 2024 16:13:58 +0200
Message-ID: <20240812141354.119889-9-andrew.jones@linux.dev>
In-Reply-To: <20240812141354.119889-6-andrew.jones@linux.dev>
References: <20240812141354.119889-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unit tests will likely share the environ so prefix variables that
are specific to specific tests to avoid polluting the name space.
We don't prefix generic stuff since they could be used by any test.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 7b63a97deda6..3f7ca6a78cfc 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -84,30 +84,30 @@ static void check_base(void)
 	}
 
 	report_prefix_push("spec_version");
-	if (env_or_skip("SPEC_VERSION")) {
-		expected = (long)strtoul(getenv("SPEC_VERSION"), NULL, 0);
+	if (env_or_skip("SBI_SPEC_VERSION")) {
+		expected = (long)strtoul(getenv("SBI_SPEC_VERSION"), NULL, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("impl_id");
-	if (env_or_skip("IMPL_ID")) {
-		expected = (long)strtoul(getenv("IMPL_ID"), NULL, 0);
+	if (env_or_skip("SBI_IMPL_ID")) {
+		expected = (long)strtoul(getenv("SBI_IMPL_ID"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_ID, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("impl_version");
-	if (env_or_skip("IMPL_VERSION")) {
-		expected = (long)strtoul(getenv("IMPL_VERSION"), NULL, 0);
+	if (env_or_skip("SBI_IMPL_VERSION")) {
+		expected = (long)strtoul(getenv("SBI_IMPL_VERSION"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_VERSION, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("probe_ext");
-	expected = getenv("PROBE_EXT") ? (long)strtoul(getenv("PROBE_EXT"), NULL, 0) : 1;
+	expected = getenv("SBI_PROBE_EXT") ? (long)strtoul(getenv("SBI_PROBE_EXT"), NULL, 0) : 1;
 	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_BASE);
 	gen_report(&ret, 0, expected);
 	report_prefix_push("unavailable");
@@ -183,8 +183,8 @@ static void timer_check_set_timer(bool mask_timer_irq)
 	struct sbiret ret;
 	unsigned long begin, end, duration;
 	const char *mask_test_str = mask_timer_irq ? " for mask irq test" : "";
-	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0) : 200000;
-	unsigned long margin = getenv("TIMER_MARGIN") ? strtol(getenv("TIMER_MARGIN"), NULL, 0) : 200000;
+	unsigned long d = getenv("SBI_TIMER_DELAY") ? strtol(getenv("SBI_TIMER_DELAY"), NULL, 0) : 200000;
+	unsigned long margin = getenv("SBI_TIMER_MARGIN") ? strtol(getenv("SBI_TIMER_MARGIN"), NULL, 0) : 200000;
 
 	d = usec_to_cycles(d);
 	margin = usec_to_cycles(margin);
-- 
2.45.2


