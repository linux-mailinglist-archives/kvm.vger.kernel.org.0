Return-Path: <kvm+bounces-41150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EB3A635A0
	for <lists+kvm@lfdr.de>; Sun, 16 Mar 2025 13:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 519D03A6712
	for <lists+kvm@lfdr.de>; Sun, 16 Mar 2025 12:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196E31A3162;
	Sun, 16 Mar 2025 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VY/2MVD6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7094C80
	for <kvm@vger.kernel.org>; Sun, 16 Mar 2025 12:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742128342; cv=none; b=VCgwfYyohrj9oYONzcsvHaflZVyLQ2o8aMT/N1UGvUCIhMQ3Nws3qmkshEJDhkFIIpey0s8Tc4wN9/2UWCshBbXtnCIt4ESEw0f8pLMpZ/0MaLNr19eTIAYX0YZBUTgPX0EhEh4hSxMDXFEMoKideDSlx2F73vgF6+AKuCD8UC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742128342; c=relaxed/simple;
	bh=CUVNu0g2BZiohMpaaAh9Dc8yr2IRcp76y3bUeOZFquY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LA+VPokJAt0aDUDRcc/Aw6KyZSTrbAPUKRq2wohe7r0sOay3fFp+pdLnqmaiZ4z0q/Ao5uQoS4N5YeGi4Ht36YL4GCtw7/wrf80nheNXWopNGXN4FQayLr3BsFUMHKP1Nwz0dnJFbGrJTx5qA8z+N6yqwSMnw8AGVVVzZRY3ulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VY/2MVD6; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2232aead377so77463915ad.0
        for <kvm@vger.kernel.org>; Sun, 16 Mar 2025 05:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742128340; x=1742733140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8gXkoweNZfvd6vggmfwAo2x61nHzo2G44/su8xJiRE8=;
        b=VY/2MVD6z5t80bJA7Tw3ScMLKDb9sGmI27wsZqfOSMHLgSsB8sw+gWa17qsyAkkNSX
         H1jZFE3H5afk6GiZTlITwe5okVrMyQ3j+wpU+mcvvl9Sx/+i0T5jgVshCec+ImsLOEk2
         /7vTVmt3bKhXa1a35TLwIFtDi/0OqASM4VggNSaNz27Qb3IAgai/7njTSJBF0GQskB7B
         t3ZlUr9Y2im9zt3Vzsb0UqgEI/frjhUJIycHZscURc1jdtz/crYAFlkSGYMUa2cjEsOs
         BBRPhjv9++mZnhGUTTnbLNkdUzzeYrk0SZvt2+hrK8jjsHfR0E36Ezb9ZuMr5FwuIvJF
         B18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742128340; x=1742733140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8gXkoweNZfvd6vggmfwAo2x61nHzo2G44/su8xJiRE8=;
        b=UeriYn2i6hsoGZNoU8PvsK1v82hcDOdOB2NntT8NduGZQs7y4890NK8oH9xIkFHLqK
         NTWQewQCU/OkAI7LpSHg6ovo1f5J6fqrCGrYTHP7LSut0dt5Lw5APq3bTaZrEvwwwMSz
         PcylxSiTdirdH9QkLKl1MCyVGm7Rdz8taM9v3SYrBTtHK7pSWswduubUX6nTX5GrodPt
         0/z5wcL4/HYQXmDP1K63P62k+y/Mvj3P6XTt+DxnNZCg5tQcf5lpgYg2W9BNsFri4hjo
         43Rr0E9QoZI+aPcEX2iPYRSQA8foE8T8U2FNpznNMHhsgSdMeuOsrGuSfzzZMphR/Xq3
         jOew==
X-Gm-Message-State: AOJu0Yz90NWE63tSLNvCkaWkzl6ko4HYMf234aOYj8qks6CZ+TwXFMPx
	aXx20/wHhNXKcapt03BGeEEqUvo80LiRfUXgKyb2jJ+W0J4riJSaxGwPwthALmAA2g==
X-Gm-Gg: ASbGncubom0fODa6BVImawRMRoaG7g5lwQya33fLzRJH24AgPiyQ6Y7DTDH0p6Y0yuM
	faNJUZIV0c5gwPJnQslUY3YmcpAro9jVNJIhDKOLPtCEmLXE5BePQabEWbHW/97PC1ujiyMSIM/
	5wP7yIvQ4zFqc2owJKUBhcAesSafDOSgF8Gr50jDuYhIdP5D0G4aQAbUoHNs4YtIharK+K43vPS
	6hW1lnrfjhVVn49cH6RX+XI3vmoioprhT3aC5NlX7h3h8CtdiK9+RFfYM/x33+BBkGXZv4gJVNQ
	3DF1o6BEoNRebcDTGS3ZqH7lZ0f5tbllZPA3zgxEgooioCYvmg==
X-Google-Smtp-Source: AGHT+IGerUc53YZzXXblJZ3QvRzovokoF0kYUEsfoBla5jR0HQhfMb3ZZ1HBEU0X1MwTJjgg8NsmiQ==
X-Received: by 2002:a17:902:cecd:b0:21f:164d:93fe with SMTP id d9443c01a7336-225e0b49ed6mr119837485ad.53.1742128339421;
        Sun, 16 Mar 2025 05:32:19 -0700 (PDT)
Received: from pop-os.. ([2401:4900:8380:12ae:c6ae:aee9:6221:d820])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68a8106sm57290995ad.89.2025.03.16.05.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Mar 2025 05:32:18 -0700 (PDT)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: andrew.jones@linux.dev,
	cleger@rivosinc.com,
	atishp@rivosinc.com,
	Akshay Behl <akshaybehl231@gmail.com>
Subject: [kvm-unit-tests PATCH] riscv: Refactor SBI FWFT lock tests
Date: Sun, 16 Mar 2025 18:02:09 +0530
Message-Id: <20250316123209.100561-1-akshaybehl231@gmail.com>
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
 riscv/sbi-fwft.c | 48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index 581cbf6b..5c0a7f6f 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -74,6 +74,33 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
 	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
 }
 
+/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
+static void fwft_feature_lock_test(int32_t feature, unsigned long locked_value)
+{
+    struct sbiret ret;
+    unsigned long alt_value = locked_value ? 0 : 1;
+
+    ret = fwft_set(feature, locked_value, 0);
+    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+        "Set locked feature to %lu without lock", locked_value);
+
+    ret = fwft_set(feature, locked_value, SBI_FWFT_SET_FLAG_LOCK);
+    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+        "Set locked feature to %lu with lock", locked_value);
+
+    ret = fwft_set(feature, alt_value, 0);
+    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+        "Set locked feature to %lu without lock", alt_value);
+
+    ret = fwft_set(feature, alt_value, SBI_FWFT_SET_FLAG_LOCK);
+    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+        "Set locked feature to %lu with lock", alt_value);
+
+    ret = fwft_get(feature);
+    sbiret_report(&ret, SBI_SUCCESS, locked_value,
+        "Get locked feature value %lu", locked_value);
+}
+
 static void fwft_check_base(void)
 {
 	report_prefix_push("base");
@@ -181,11 +208,9 @@ static void fwft_check_misaligned_exc_deleg(void)
 	/* Lock the feature */
 	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
 	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0 and lock");
-	ret = fwft_misaligned_exc_set(1, 0);
-	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
-			    "Set locked misaligned deleg feature to new value");
-	ret = fwft_misaligned_exc_get();
-	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg locked value 0");
+
+	/* Test feature lock */
+	fwft_feature_lock_test(SBI_FWFT_MISALIGNED_EXC_DELEG, 0);
 
 	report_prefix_pop();
 }
@@ -326,17 +351,8 @@ adue_inval_tests:
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
+	/* Test the feature lock */
+	fwft_feature_lock_test(SBI_FWFT_PTE_AD_HW_UPDATING, enabled);
 
 adue_done:
 	install_exception_handler(EXC_LOAD_PAGE_FAULT, NULL);
-- 
2.34.1


