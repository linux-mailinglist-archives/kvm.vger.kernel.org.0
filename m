Return-Path: <kvm+bounces-41586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E9CA6AC1E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CED7880F68
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE226224B0D;
	Thu, 20 Mar 2025 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfJcrxV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD529CE6
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742491970; cv=none; b=Cyvz4PBVDLVEPFy/TlU7mRKYWX/7kgLNIQh+KpEHi3ls4zbZX/VGvS/GUOlcZCFydmv3xUh61kZV7/65uKz+o3w7wLDQ3AskrisuSebNsmaSGnm6fPzAe051cshmbN5+7PYhBV0rWGMKiRt7gWS4uuwq4WntyMh2PMCcXgl+d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742491970; c=relaxed/simple;
	bh=hhw2XMt/Xt3m7bIXcHg1ZNAaXYw2Ukjbl1hFv2V357Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qXrAR6enxhBJctVhY+gwY7TRCrej8+NygGOfvZmftt9t0FuDbq2S3rA5pKEajkTmU+T4g6M/dTlvXCauFna22JZw8LJGELiXpSAgW492NJOqWjCu6xERTvchWuKxx7q9fulDQ1buq4xRyp0tkfAGVTFI2tbstWHz6WN+rXdBrf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfJcrxV7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22409077c06so28530415ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 10:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742491967; x=1743096767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MBqMRzJiIEZd4asK9FF0NAPE+No9dC9gk+9VIxCj4CI=;
        b=CfJcrxV78QlvkP67EXTA5bMPULxdtSRabHr64WsB1F0LfPkOMUXs3THaPNYJY2EA3z
         Nxg9hA0RdzT27+W4fzmQIt8GeiRQHQEXHPVEV0Bh+JqiAzr/c7NpxXqenOFRVRaKGbpG
         Aif2otvtVyoEtiWkXv7YRX6/7PZjGK4S7OmkIf4cov0ncMYzqD6x8aJCQuNjl+wdIens
         xIqQ1cJnjLuP52ascPYe7DS4JWdoq9i72CZSSV5xevyF0orVfnMje4m6uglZpPXVJWbU
         +0jH0HWct5DWRWodJKJrJfqkCuu110pdSMa6Keg6TNhImW6p3cZM0gHN+JOUoAK3UXWJ
         h07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742491967; x=1743096767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBqMRzJiIEZd4asK9FF0NAPE+No9dC9gk+9VIxCj4CI=;
        b=lkLspjipZh2ykdDMBqBSZH84McQZ8Xzgut31brU2tlEylxJKYmOxzuhvEKp0YebtEp
         GdKoXpyCn0904Et89hb6MyhETZRj1bI+7xMDQ4dmpaNzI/iapISlNccg+Wa646yyQXgw
         b2bOAv6TlST/AHJl5kw5yjV7Ai10qcmOEAf/pZ52ja076qSL5lCo6dsKVvpIOTTMmwaM
         suiPSlxnI6j4maXjJAUrFwupZf6202zLKpjYJsHLv29rK4wceF+ouBJ5WA6xR/bCmnwf
         mKzcIj+FVr6g2ualk/FgZK+KtP1ZwIV+Sz510RjmmFUvIrCyFlbiBWl2lAZ2gnDq4tcT
         RF0Q==
X-Gm-Message-State: AOJu0YyVJNWVgiabSFeLKZ3rtIt3s0b/kyH6Vf3UnOk05T73nlFeluDH
	hagrgDt4l887lg+bBtz1dP6ImfEVtje/15fGP2HEoPZzjb+6QIP20kVeqAjEFhkTWagi
X-Gm-Gg: ASbGncs1yOcZnmyGXgtdVGoUooDpXMtvnXBAXUy4H/Zq1Dra48M+2TQk/wg2E9H/VHQ
	mR6L1gNBU3tSlCzwrVLrbr4tDzfio0fj6PzKqOfOr5sdZS+QDdJPG0TfJTlPgrLvfmuBQ/6ZCpg
	TM0uHiaJpC/glCLf4dFCJg1HLMLj4wbgTayH+BaM0A/F9KmaNksOQk6QTqkJXHJk6YCBrOva6CW
	bwM6e97g5JUA/j/FoDtEU9cWX2kX0zemlQGRjCNZ5RydtwgBPnOC59SPoYZgfgUdXe+lnVToNEB
	9WPttKH1QOdYKgsHiDswF5UTgEuY987mBOSk8hH1dUtUSUWqFA==
X-Google-Smtp-Source: AGHT+IFPt/2mD0dvZcBX0Kouwfwq9EuWtCj3JiFO5+a4gSed/nPUJpPykS9hsOdvVHGwN32uiDWO5w==
X-Received: by 2002:a17:90b:4fc6:b0:2ee:45fd:34f2 with SMTP id 98e67ed59e1d1-3030fe5a096mr108563a91.6.1742491967254;
        Thu, 20 Mar 2025 10:32:47 -0700 (PDT)
Received: from pop-os.. ([2401:4900:55bb:fb61:ccdf:a03a:de26:69bb])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f60b919sm116234a91.27.2025.03.20.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 10:32:46 -0700 (PDT)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: andrew.jones@linux.dev,
	cleger@rivosinc.com,
	atishp@rivosinc.com,
	Akshay Behl <akshaybehl231@gmail.com>
Subject: [kvm-unit-tests PATCH v3] riscv: Refactor SBI FWFT lock tests
Date: Thu, 20 Mar 2025 23:02:35 +0530
Message-Id: <20250320173235.16547-1-akshaybehl231@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a generic function for lock tests for all
the sbi fwft features. It expects the feature is already
locked before being called and tests the locked feature.

Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
---
v3:
 - Fixed indentation.
 - Removed unnecessary comments.
 - Added locked prefix.

v2:
 - Made changes to handel non boolean feature tests.

riscv/sbi-fwft.c | 50 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index 581cbf6b..c4d0b170 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -74,6 +74,37 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
 	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
 }
 
+/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
+static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
+	unsigned long test_values[], unsigned long locked_value)
+{
+	struct sbiret ret;
+
+	report_prefix_push("locked");
+
+	for (int i = 0; i < nr_values; ++i) {
+		ret = fwft_set(feature, test_values[i], 0);
+		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			"Set to %lu without lock flag", test_values[i]);
+
+		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
+		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			"Set to %lu with lock flag", test_values[i]);
+	}
+
+	ret = fwft_get(feature);
+	sbiret_report(&ret, SBI_SUCCESS, locked_value,
+		"Get value %lu", locked_value);
+
+	report_prefix_pop();
+}
+
+static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
+{
+	unsigned long values[] = {0, 1};
+	fwft_feature_lock_test_values(feature, 2, values, locked_value);
+}
+
 static void fwft_check_base(void)
 {
 	report_prefix_push("base");
@@ -181,11 +212,8 @@ static void fwft_check_misaligned_exc_deleg(void)
 	/* Lock the feature */
 	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
 	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0 and lock");
-	ret = fwft_misaligned_exc_set(1, 0);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
-			    "Set locked misaligned deleg feature to new value");
-	ret = fwft_misaligned_exc_get();
-	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg locked value 0");
+
+	fwft_feature_lock_test(SBI_FWFT_MISALIGNED_EXC_DELEG, 0);
 
 	report_prefix_pop();
 }
@@ -326,17 +354,7 @@ adue_inval_tests:
 	else
 		enabled = !enabled;
 
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 0);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", !enabled);
-
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 1);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", !enabled);
-
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 0);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", enabled);
-
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 1);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", enabled);
+	fwft_feature_lock_test(SBI_FWFT_PTE_AD_HW_UPDATING, enabled);
 
 adue_done:
 	install_exception_handler(EXC_LOAD_PAGE_FAULT, NULL);
-- 
2.34.1


