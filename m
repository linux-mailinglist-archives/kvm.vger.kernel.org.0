Return-Path: <kvm+bounces-23858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5FA94EF43
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B7AC283489
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7AD17F391;
	Mon, 12 Aug 2024 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WcKdXkOp"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A04B17F4E5
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472052; cv=none; b=qHVKq+lb2SC6nYYbvN54zLrG8bvxFeES7jAhdWB7/GLJIxnVkN8rac0WfN0EIB/FvP3asyeeUi4zJiaXxLHKocI/X0XzLCp8VmultI2KSgRI43G1RPbuWPnqbGxsmQAR9FERWXTq8mehnO6Gfw/XM1FY1FmnVwrf4ULy/lN8FOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472052; c=relaxed/simple;
	bh=mR2Z+T8XDqIIMQJEhX/2Bh4rBS3/xgaDDDrcxlV06OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXbDpsn2ebwPiXu+vu+ChX8a1qbbP5bxus6dyLe0Rfodt1vAe+jHjG2d9UnBjeau1wzj2A2r+P16bHhSCEIwQCY1Nw+o6oMeBFVJUrnXsHQYzGIg7nCF/IJ8N5XmONXr+cLI2LckF0Lm8gemV9no6uPvzAQl9CcniJ2xbbyyrz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WcKdXkOp; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9b7yuIV81EFMV6IdsZHbE23iNNqeOt+Yr7GlpQoJ2U=;
	b=WcKdXkOpLXJkYKNd+uzWDJsFq+cUddbvk+aFcGe4SaqVzs4wV72WyCKQ3FY7StzdnZFep9
	6ZUTblKd/Q0roIDQZ020HvVhLtOdWJyZx1VRMWwEg5ArEbiphCZRqV1MuTrQcqYHqbEG53
	JqZXt8ZLKOMQ7XRAFeY79fYnJQ2CSmc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/4] riscv: sbi: Use strtoul to avoid overflow
Date: Mon, 12 Aug 2024 16:13:57 +0200
Message-ID: <20240812141354.119889-8-andrew.jones@linux.dev>
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

We want to compare the expected values provided by environment
variables with signed long results, but we should parse those
values as unsigned as they may actually represent unsigned
numbers with the MSB set, and, if that's the case, then strtol
will assert when detecting the signed value overflow.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 2393929b965d..7b63a97deda6 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -85,14 +85,14 @@ static void check_base(void)
 
 	report_prefix_push("spec_version");
 	if (env_or_skip("SPEC_VERSION")) {
-		expected = strtol(getenv("SPEC_VERSION"), NULL, 0);
+		expected = (long)strtoul(getenv("SPEC_VERSION"), NULL, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("impl_id");
 	if (env_or_skip("IMPL_ID")) {
-		expected = strtol(getenv("IMPL_ID"), NULL, 0);
+		expected = (long)strtoul(getenv("IMPL_ID"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_ID, 0);
 		gen_report(&ret, 0, expected);
 	}
@@ -100,14 +100,14 @@ static void check_base(void)
 
 	report_prefix_push("impl_version");
 	if (env_or_skip("IMPL_VERSION")) {
-		expected = strtol(getenv("IMPL_VERSION"), NULL, 0);
+		expected = (long)strtoul(getenv("IMPL_VERSION"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_VERSION, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("probe_ext");
-	expected = getenv("PROBE_EXT") ? strtol(getenv("PROBE_EXT"), NULL, 0) : 1;
+	expected = getenv("PROBE_EXT") ? (long)strtoul(getenv("PROBE_EXT"), NULL, 0) : 1;
 	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_BASE);
 	gen_report(&ret, 0, expected);
 	report_prefix_push("unavailable");
@@ -118,7 +118,8 @@ static void check_base(void)
 
 	report_prefix_push("mvendorid");
 	if (env_or_skip("MVENDORID")) {
-		expected = strtol(getenv("MVENDORID"), NULL, 0);
+		expected = (long)strtoul(getenv("MVENDORID"), NULL, 0);
+		assert(__riscv_xlen == 32 || !(expected >> 32));
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MVENDORID, 0);
 		gen_report(&ret, 0, expected);
 	}
@@ -126,7 +127,7 @@ static void check_base(void)
 
 	report_prefix_push("marchid");
 	if (env_or_skip("MARCHID")) {
-		expected = strtol(getenv("MARCHID"), NULL, 0);
+		expected = (long)strtoul(getenv("MARCHID"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MARCHID, 0);
 		gen_report(&ret, 0, expected);
 	}
@@ -134,7 +135,7 @@ static void check_base(void)
 
 	report_prefix_push("mimpid");
 	if (env_or_skip("MIMPID")) {
-		expected = strtol(getenv("MIMPID"), NULL, 0);
+		expected = (long)strtoul(getenv("MIMPID"), NULL, 0);
 		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MIMPID, 0);
 		gen_report(&ret, 0, expected);
 	}
-- 
2.45.2


