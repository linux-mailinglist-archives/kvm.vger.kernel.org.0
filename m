Return-Path: <kvm+bounces-41418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B23E3A67B3B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09FB0176A7F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA02211A1E;
	Tue, 18 Mar 2025 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iycGJODf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5255E21171B
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742319843; cv=none; b=NXyCtSUcATgjXB1rz9E0Y2kA4tOH5tLQk8KOStogjfBKDLDt0psJF1R2QsZfzufedQR7CSd/w65HjbUAcRIWvHr2St6Bs6p5kste48p0RDiHyGZ8aWtlrZcIWbwiz+lRNUJeCgRP6R2WW2W8pDWCocfJlsYbqjvU5nWEZLivdzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742319843; c=relaxed/simple;
	bh=epaCrFfbWUsA8XnaTnYrPEUbLzZ78QMnV7ml61VmCiA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QsCxdyFv+ZrJ7UavuqlGb5x8wBxYsDX6/RsIo+o5C8tkPzo9mtERvF9ySDIbUnJgM5sgrJ8LXxsYHdKUVPSOTv/L8vzjZ6Js9l93w8As2vT0sV+fBoreLHuyP4Wljv2a9c6FtyjckFhfX3tV5NvGQknrum2JPll9kZ8m1ahLStM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iycGJODf; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-223f4c06e9fso101090515ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742319840; x=1742924640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gzd/AWXu2d300Kr8/Og94+uidnchSMYyagQ2b7TSLcE=;
        b=iycGJODfOpzSB8mDPXj4BMsn4Do9Eeha9DTmHmDJVaPv/H9wfgvN6FfzEEMAOjRPfb
         4lmKMVV7GW+nLwzZCrkPRqub7BNoZ9ixOPppWRihu1uA9PBoFzzUmcFPjU5rrEPg03TO
         5aQb0CnCxT8f/dUReq40yJEoUUdCnQC8rFuPDNyOLPAkseFf+IsNt4hEazR/BlJ3dTU1
         lKWaFRD/Jgbf53KQc71LSpzMiC41y9Zd8RZLGROEEIxmoyaSNekDgIBnYiCaDRWg+VkB
         yukHLA9PKBYWej5w6yeU5PqbAo1Z3p20oMaFq0OvX8MuYtUBs2Eaktr8LzqGaZSQ6G5k
         Q2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742319840; x=1742924640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gzd/AWXu2d300Kr8/Og94+uidnchSMYyagQ2b7TSLcE=;
        b=n/zxJ56FPi8tce6ux5ZXZ+ifcwf4GnUN+oj0ZuiUyVF3mUwDE/L35uYeZCajHd6UZe
         hhoUDrPve25KpfxRyyKguDhswxeA+pLAUVw0J9gHvWBPdTbMJKF9oYefgNwJ7G0gq9B3
         ZSacNt2YQItyL6dtG9jAIwnt5mun54vJp46mxuySQeJ8tmLTzWWf1JGzGimWd1K3fX34
         hwq/aiKp8CP9KgRB7bJ5cFKTXlfcsxrBMJbY1ZfF15h7bRqBLAdDwKopLlVRRLAptN73
         6Ee1M3KC52UuZkiQPfHYepLE5XlkPeWJNe7+DqtC3PW6Zfkc1H2/Q9jjx/9MXDq3OBFN
         Z9tw==
X-Gm-Message-State: AOJu0Yxl4NtM9Vz/BFejU9DLv6smhZzt9vuByVZK8XADmKRARzY6yu+p
	UyAzvctow+4+IpqfXwQnlD2nbrLVwDTWtRUEkX2xN1xUVCE2EYfqu3z/f5ovaRn4H/77
X-Gm-Gg: ASbGncuXBgVSVUTNVHrI5lvjPQ1n+fmR9EnPhNKjLstXuGzFqWbVKSfnyafFMIoZbly
	9Rx5FbhkXztzWrK9tHCZ+ZWTglKxT4+zoKchD38DHgFhrx0+qGPQDrp4Bjl4Sw71y0YpQXPNUBb
	NjIJSEKn3ZokvjD1iWBEI/ULjVpmgkA523vXQ1L/L3EBQB66CIZa0Q/IWe2ZnO+eEDnT8lOj0o+
	tSbTDcIpzkLEwhgLXY89BlXj83RrTiY5smUfsgP9cjmWXRxYlPlF94zL1IBmoOBFV23TTzSHaRh
	yX2/Hc16Wq+MHe/h+vhXPIJ7NGVII0OulMXhmUvS0SDUeK24hZWhXnJqrizJ
X-Google-Smtp-Source: AGHT+IHTpMEOqE+5z19dql/ZsbkUd3JWrA0xKMNihIuEhUxeHsbLJB/FOrPLhQ+XNLNeWovnRBNcEA==
X-Received: by 2002:a17:902:e743:b0:226:3392:3704 with SMTP id d9443c01a7336-226339237e9mr48967805ad.12.1742319840012;
        Tue, 18 Mar 2025 10:44:00 -0700 (PDT)
Received: from pop-os.. ([2401:4900:51e3:9f29:521c:e54f:4b71:5fa3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68aa837sm98065385ad.103.2025.03.18.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 10:43:59 -0700 (PDT)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: andrew.jones@linux.dev,
	cleger@rivosinc.com,
	atishp@rivosinc.com,
	Akshay Behl <akshaybehl231@gmail.com>
Subject: [kvm-unit-tests PATCH v2] riscv: Refactor SBI FWFT lock tests
Date: Tue, 18 Mar 2025 23:13:49 +0530
Message-Id: <20250318174349.178646-1-akshaybehl231@gmail.com>
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
v2:
 - Made changes to handel non boolean feature tests.
 riscv/sbi-fwft.c | 49 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index 581cbf6b..7d9735d7 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -74,6 +74,34 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
 	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
 }
 
+/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
+static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
+										unsigned long test_values[], unsigned long locked_value)
+{
+	struct sbiret ret;
+
+	for (int i = 0; i < nr_values; ++i) {
+		ret = fwft_set(feature, test_values[i], 0);
+		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			"Set locked feature to %lu without lock", test_values[i]);
+
+		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
+		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
+			"Set locked feature to %lu with lock", test_values[i]);
+	}
+
+	ret = fwft_get(feature);
+	sbiret_report(&ret, SBI_SUCCESS, locked_value,
+		"Get locked feature value %lu", locked_value);
+}
+
+static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
+{
+	unsigned long values[] = {0, 1};
+
+	fwft_feature_lock_test_values(feature, 2 , values, locked_value);
+}
+
 static void fwft_check_base(void)
 {
 	report_prefix_push("base");
@@ -181,11 +209,9 @@ static void fwft_check_misaligned_exc_deleg(void)
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
@@ -326,17 +352,8 @@ adue_inval_tests:
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


