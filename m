Return-Path: <kvm+bounces-23474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE688949F6C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43234B2108E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 05:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5469F19752C;
	Wed,  7 Aug 2024 05:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWR78FMC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B1190694
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 05:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009919; cv=none; b=eBVBdtgOWjTgeE425OTzeVFouyos6ZqrZpE9JejVLT7HRM7b0f7+WAfBnQnQN2nvCztN6lorTiHOg1+APUG4tDL3Fi9otbuWjljIIPsprix2RqHPlUiChhTsVB8QEly1RmTUTqDb6kOfHIUpmbrgjMsrAvwgx6fiaPW7pnBd9gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009919; c=relaxed/simple;
	bh=P+6vYBXNvyXtGvO63Fgvl3UFdDRmHjjKAVwrqeP8Y1M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kmRjpqHpsByc2jT3qrnR8f28bnzTknKetSC3MySgGExgsNkH4mNm/bcfLZa0hUtUR8fNLC5O6fo1ZcM5CSD+Qs/kzDd+Y/HolOZ4rRw6Zlj0LBVNLdyD/n0hVQDiUid46w2S2irmiaDRd4reabku231Tm7OYl0zRI3xPba0aVmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWR78FMC; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fd78c165eeso11435245ad.2
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 22:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723009917; x=1723614717; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1/Oho0iTqPPJRoT61a5Yt6PpA0jED4M0jYCoDmrS4rI=;
        b=EWR78FMCwrX125/w6rNibXKCAMZ3O4I2oEA6PaaYqyGGrov1rdY1t+IoORrXUG03dR
         maoqIc60FC0sh/mN8eQ5AUCwdAq55eblHxBR7ymVEeGRuOlwzPRCEKk5rTNfrlXbSqI9
         Oo2WLi464vmr8qKnLR2Z6HaQwa4679IFextMGFscus9kL5g/1ZUK4E4nigwWqq9m9ouK
         OnZC+nk9dt54XvVWZ61tvOrXXywBD2gazbXoQSBJUS0VYMG2Rw48LdZ+b5y5II29MvxA
         KjvO70SGL1sTfYiH1D8wWxTr/f/eA3IxMAI8TSgKcoa1IbSfpg2nIgQBHOKcE33QWNB9
         sZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723009917; x=1723614717;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1/Oho0iTqPPJRoT61a5Yt6PpA0jED4M0jYCoDmrS4rI=;
        b=X1t1VM1oc9nTp0zn8PgJEGkkbgJVrAqRZK2IHjX0ewZLI7nKMdzBBOSy8lLhMh4K6y
         cyq6+GMPw4gt5bUOU9K1Iyig4mgr6rp/MuF+s7bKPbDP9PULyLyjb4e/sBEEzVMptnDu
         E+UIvNMcn4QSO+70KXPxXqGrW6+zgTgfFEZAlyULcltQLQOBHS73s+RN3pzobj9j7UV1
         o8aqTCpjdhhh6b+xUo3x8yD923aAQ2zzNZJeu1YguYxaGjdDpzC+jE4rupKriYwLancv
         tr1JShtOfvBLMyjFk7hbpq5zotvg1E3a3806CAFoidR+38urUfKQpXO8WekhGxRmYQdD
         JSVw==
X-Gm-Message-State: AOJu0YyfKoENB2mC/gYdH9DrhF0LnZDP7Ce/LX8xcoqbx0BdHrYI881/
	0IQ7D3Ht4Li2vr3FU0+ADtb9PHoPpuOxmMEis99l1wUe5b8KQ2Ge
X-Google-Smtp-Source: AGHT+IGS9uK48cOCO7ThOVtSIe/ls4yatHBhz3+Hqj6W7TxDPzsa1CtoE7PIs7OTraZURH0RsAU2dg==
X-Received: by 2002:a17:903:230f:b0:1fd:6766:6877 with SMTP id d9443c01a7336-1ff57254180mr235158635ad.2.1723009917122;
        Tue, 06 Aug 2024 22:51:57 -0700 (PDT)
Received: from [127.0.1.1] (c-73-185-75-144.hsd1.ca.comcast.net. [73.185.75.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f5a47esm97155345ad.110.2024.08.06.22.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 22:51:56 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
Date: Tue, 06 Aug 2024 22:51:54 -0700
Subject: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIAHkLs2YC/x3MPQqAMAxA4atIZgOp/3gVcdA2apYqTVFBvLvF8
 Rvee0A5CCv02QOBT1HZfYLJM7Db5FdGcclQUFFRRw3qLOhm6/EKEhkja8SWXEm1q42xC6TyCLz
 I/V+H8X0/uERI5mUAAAA=
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
 jamestiotio@gmail.com
X-Mailer: b4 0.13.0



---
Added a unit test for the RISC-V SBI debug console write() and write_byte() functions. The output of the tests must be inspected manually to verify that the correct bytes are written. For write(), the expected output is 'DBCN_WRITE_TEST_STRING'. For write_byte(), the expected output is 'a'.

Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 lib/riscv/asm/sbi.h |  7 ++++++
 riscv/sbi.c         | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 73ab5438..47e91025 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -19,6 +19,7 @@ enum sbi_ext_id {
 	SBI_EXT_TIME = 0x54494d45,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
+	SBI_EXT_DBCN = 0x4442434E,
 };
 
 enum sbi_ext_base_fid {
@@ -42,6 +43,12 @@ enum sbi_ext_time_fid {
 	SBI_EXT_TIME_SET_TIMER = 0,
 };
 
+enum sbi_ext_dbcn_fid {
+	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
+	SBI_EXT_DBCN_CONSOLE_READ,
+	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
+};
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 2438c497..61993f08 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -15,6 +15,10 @@
 #include <asm/sbi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <asm/io.h>
+
+#define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
+#define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
 
 static void help(void)
 {
@@ -32,6 +36,11 @@ static struct sbiret __time_sbi_ecall(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
+{
+	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -248,6 +257,62 @@ static void check_time(void)
 	report_prefix_pop();
 }
 
+static void check_dbcn(void)
+{
+	
+	struct sbiret ret;
+	unsigned long num_bytes, base_addr_lo, base_addr_hi;
+	int num_calls = 0;
+	
+	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
+	phys_addr_t p = virt_to_phys((void *)&DBCN_WRITE_TEST_STRING);
+	base_addr_lo = (unsigned long)p;
+	base_addr_hi = (unsigned long)(p >> __riscv_xlen);
+
+	report_prefix_push("dbcn");
+	
+	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_DBCN);
+	if (!ret.value) {
+		report_skip("DBCN extension unavailable");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("write");
+
+	do {
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+		num_bytes -= ret.value;
+		base_addr_lo += ret.value;
+		num_calls++;
+	} while (num_bytes != 0 && ret.error == SBI_SUCCESS) ;
+	report(ret.error == SBI_SUCCESS, "write success");
+	report_info("%d sbi calls made", num_calls);
+	
+	/*
+		Bytes are read from memory and written to the console
+	*/
+	if (env_or_skip("INVALID_READ_ADDR")) {
+		phys_addr_t p = strtoull(getenv("INVALID_READ_ADDR"), NULL, 0);
+		base_addr_lo = (unsigned long)p;
+		base_addr_hi = (unsigned long)(p >> __riscv_xlen);
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
+		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address");
+	};
+
+	report_prefix_pop();
+	
+	report_prefix_push("write_byte");
+
+	puts("DBCN_WRITE TEST CHAR: ");
+	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
+	puts("\n");
+	report(ret.error == SBI_SUCCESS, "write success");
+	report(ret.value == 0, "expected ret.value");
+
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 
@@ -259,6 +324,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_dbcn();
 
 	return report_summary();
 }

---
base-commit: 1878b4b663fd50b87de7ba2b1c90614e2703542f
change-id: 20240806-sbi-dbcn-write-test-70d305d511cf

Best regards,
-- 
Cade Richard <cade.richard@berkeley.edu>


