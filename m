Return-Path: <kvm+bounces-41693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5289DA6C0B2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EDCC3B3034
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648C222DFE3;
	Fri, 21 Mar 2025 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NnbjDHen"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559F22D7AD
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576059; cv=none; b=fqBApq1cIfurYUDlGxQk/3PIebxLLGTGGGZ66wjTpctItfCr+15hIzWGsX5Cq7febZPe0WAiGfwbFMyxEQvnMeg6V+VS/1UKF97nRzmIHxbKyYW5xJD3j9JwapsDi9q+ZynIFQ4+57KgMLy5334IlfLrudX21EkgwFg+35HCC1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576059; c=relaxed/simple;
	bh=mtq+uEaM31NpCw4KEGkVMWdG5F+I9RFiW1f1U8ZhqZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXF6tEhDV4eLvseKqQfCVLPtHGBL22KSHogxwqAtsXOLzn6XFgvdn4JQaB8Z3KH2yxTzvaVUxGPuhJcwSQ9aqiq4tE5kIesl/XVL3A/W7s6FQWU9NwqBKMQshap8x8pGngcRqxt35Fz/K+hbL7zODbm6lj+OoCapCZQCn7IMYgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NnbjDHen; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742576053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIolc26Z9WyQwzj190zC3vU/7vb8zQejDnHfjjlS2TY=;
	b=NnbjDHenGbSrKQVFGKgBN+CwdoxdxAfoFHK3CZWZKR0PiBVecIWj1ZLTqlBjykdDmPrHE7
	GEEoHwnBwlYMhnSqtyBequ2VItBsBxe1svNQ4bF0TLyyfn6NcEOQ2/CfwGMy30iy0ItSpM
	dbkGVD1B/QPMv0QrMAinnYfIGZxC06U=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: cleger@rivosinc.com,
	atishp@rivosinc.com,
	akshaybehl231@gmail.com
Subject: [kvm-unit-tests PATCH 3/3] riscv: sbi: Use kfail for known opensbi failures
Date: Fri, 21 Mar 2025 17:54:07 +0100
Message-ID: <20250321165403.57859-8-andrew.jones@linux.dev>
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

Use kfail for the opensbi s/SBI_ERR_DENIED/SBI_ERR_DENIED_LOCKED/
change. We expect it to be fixed in 1.7, so only kfail for opensbi
which has a version less than that. Also change the other uses of
kfail to only kfail for opensbi versions less than 1.7.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi-fwft.c | 20 +++++++++++++-------
 riscv/sbi.c      |  6 ++++--
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index 3d225997c0ec..c52fbd6e77a6 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -83,19 +83,21 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
 
 	report_prefix_push("locked");
 
+	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
+		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
+
 	for (int i = 0; i < nr_values; ++i) {
 		ret = fwft_set(feature, test_values[i], 0);
-		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
-			"Set to %lu without lock flag", test_values[i]);
+		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
+				   "Set to %lu without lock flag", test_values[i]);
 
 		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
-		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
-			"Set to %lu with lock flag", test_values[i]);
+		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
+				   "Set to %lu with lock flag", test_values[i]);
 	}
 
 	ret = fwft_get(feature);
-	sbiret_report(&ret, SBI_SUCCESS, locked_value,
-		"Get value %lu", locked_value);
+	sbiret_report(&ret, SBI_SUCCESS, locked_value, "Get value %lu", locked_value);
 
 	report_prefix_pop();
 }
@@ -103,6 +105,7 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
 static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
 {
 	unsigned long values[] = {0, 1};
+
 	fwft_feature_lock_test_values(feature, 2, values, locked_value);
 }
 
@@ -317,7 +320,10 @@ static void fwft_check_pte_ad_hw_updating(void)
 	report(ret.value == 0 || ret.value == 1, "first get value is 0/1");
 
 	enabled = ret.value;
-	report_kfail(true, !enabled, "resets to 0");
+
+	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
+		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
+	report_kfail(kfail, !enabled, "resets to 0");
 
 	install_exception_handler(EXC_LOAD_PAGE_FAULT, adue_read_handler);
 	install_exception_handler(EXC_STORE_PAGE_FAULT, adue_write_handler);
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 83bc55125d46..edb1a6bef1ac 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -515,10 +515,12 @@ end_two:
 	sbiret_report_error(&ret, SBI_SUCCESS, "no targets, hart_mask_base is 1");
 
 	/* Try the next higher hartid than the max */
+	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
+		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
 	ret = sbi_send_ipi(2, max_hartid);
-	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask got expected error (%ld)", ret.error);
+	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask");
 	ret = sbi_send_ipi(1, max_hartid + 1);
-	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base got expected error (%ld)", ret.error);
+	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask_base");
 
 	report_prefix_pop();
 
-- 
2.48.1


