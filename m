Return-Path: <kvm+bounces-26503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8949750E7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10D37B25F1F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7705518BBA4;
	Wed, 11 Sep 2024 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qJxVdPHL"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE6188599
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726054432; cv=none; b=tnZ72sY72mf+RJnZlRBSEQihD9peqH8T2Mr0Dv6TpNC1/nEGA3vSNiNH0wSpLjDMBArbHGktVyRmMSODEmXwS2pkPFrIwQrCrfRlBhnVGC7jpRWOFpg+OuD/s6s7jSCnf4IG2ktGr7i50EhLle7OFkdHs1+92/Yay4n+n4X3KXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726054432; c=relaxed/simple;
	bh=/QzG2vGxXI8pxu2o7WbDktWTen/2b5iMkHZG59SyQO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm3kl2dUKqVRa7ue7hlwe13bmCJUhDmb32YFmOZFA1F10Ka8oboMwbC+5OXspkU/IpNUA9phOAXTU4VmiCSKUjlhNiWosYPCIvpjSSXZEd6rxurS1tcWEt0bhc1sgZiOvr0fFNMVuZCDYPwgCJaMkDmEUd85sD1hbIBLoujqG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qJxVdPHL; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726054428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b7ix4KMbxRc+JMeF5CRb97eBA/z83HaJRk00C+aiWJA=;
	b=qJxVdPHL7XoqLqAjEhQCCGhnCbCSj9qaertpl3Jod8JnrwyUgAFsKPc4F9IfQg76z0dzwe
	ixfLgPCBswpvFWUTFdX1Wn9eQuNbcX61zM0LJxpW/aslN3THaIpJCVFq47XZ5U+SnnksGY
	74DbWXq5wpLYj9dOYG0bA9lDG9vuxl8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/2] riscv: sbi: Improve spec version test
Date: Wed, 11 Sep 2024 13:33:41 +0200
Message-ID: <20240911113338.156844-6-andrew.jones@linux.dev>
In-Reply-To: <20240911113338.156844-4-andrew.jones@linux.dev>
References: <20240911113338.156844-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

SBI spec version states that bit 31 must be zero and doesn't say
anything about bits greater than 31 (for rv64). Check that bit
31 is zero and assume all other bits are UNKNOWN, so mask them
off before testing.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/sbi.c |  2 +-
 riscv/sbi.c     | 15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index ecc63acdebb7..f8ed873c2eee 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -97,7 +97,7 @@ long sbi_probe(int ext)
 	struct sbiret ret;
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-	assert(!ret.error && ret.value >= 2);
+	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
 	assert(!ret.error);
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 300d5ae63084..f6d62c5644ae 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -105,18 +105,25 @@ static void check_base(void)
 	report_prefix_push("base");
 
 	ret = sbi_base(SBI_EXT_BASE_GET_SPEC_VERSION, 0);
-	if (ret.error || ret.value < 2) {
-		report_skip("SBI spec version 0.2 or higher required");
-		return;
-	}
+	if (!ret.error)
+		ret.value &= 0xfffffffful;
 
 	report_prefix_push("spec_version");
 	if (env_or_skip("SBI_SPEC_VERSION")) {
 		expected = (long)strtoul(getenv("SBI_SPEC_VERSION"), NULL, 0);
+		assert_msg(!(expected & BIT(31)), "SBI spec version bit 31 must be zero");
+		assert_msg(__riscv_xlen == 32 || !(expected >> 32), "SBI spec version bits greater than 31 are UNKNOWN");
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
+	ret.value &= 0x7ffffffful;
+
+	if (ret.error || ret.value < 2) {
+		report_skip("SBI spec version 0.2 or higher required");
+		return;
+	}
+
 	report_prefix_push("impl_id");
 	if (env_or_skip("SBI_IMPL_ID")) {
 		expected = (long)strtoul(getenv("SBI_IMPL_ID"), NULL, 0);
-- 
2.46.0


