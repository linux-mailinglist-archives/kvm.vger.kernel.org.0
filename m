Return-Path: <kvm+bounces-20934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 252C2926E27
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9886B1F22F35
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18241B7E4;
	Thu,  4 Jul 2024 03:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DD+TxMuV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690BE1DA32D
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720064644; cv=none; b=SIsx6s5po+pJ6II+UK7MCLvBv4+ePtzGsGqgrGFdNhoKmcUiogLv6O8EcjpVRCqzkWYTNqIc0dNWUNPM8T4idWk51Db/mStPcgTKiGyUQvptUI4JQ4n2U+vCU/vicNnWv7flcYRc654zcIvDr+ImCu/887AEn+vRe9IuOqsR5l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720064644; c=relaxed/simple;
	bh=bD+tG1AsVgTOubpjRmKNnAX+WyMxODx30lrUZaJcuH0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lz3GSSf8rgsVZeBSWnowRPaa8Ff2dYhWqCFawz6fQmsgg8RGFIaMSp8qy1bErOJI7AZKhPjKwJooGKet92ODwd+wuecc9T9ODbreqUmjtgC2Cr9XWHMEEBt0wlaE6AWI7Qnuur/fBrsqCqFIplNpssuzDtTxy3pbjkfolAB8mO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DD+TxMuV; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fa9ecfb321so1054915ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 20:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720064643; x=1720669443; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PyH1BQxw6yoYa6pWHs5e8Qa50ra95yjF0ZzBqONB0/Y=;
        b=DD+TxMuVOfC/vaXbJx3jfxhf2kmUfTMqKdGO1cXG9jzBbQXyTA7JJLqxSmOJ1OS5bP
         iY5gYefaRT1XHme2TN8SwIOTQypMzFKIJRbW4USGpgx6vaMLMYKpDZh854OTqVPYvWZX
         ZyoED2pPc3vakCC5OtNcb8hlLzrz2zQXf3A1aWUC66gzUND7ZB8+7DUPMhcIpj5m9eJS
         yTlgWjq9mzRhUmKw1kKsxBQmqPtKlMb1pJzzVynMv58UnLYz7A1mW7H0ZuR+aHemo1hR
         rn4knh0q3VaQ9c0GXg5OmXlj+65O8bz6OoweH0/pjBcLW7LybqFzjb6+YefA7EiDLzS3
         5iGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720064643; x=1720669443;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyH1BQxw6yoYa6pWHs5e8Qa50ra95yjF0ZzBqONB0/Y=;
        b=VIkroC76n+dYQkxVG5GueiCnu7bCaZB4+TeIysCERkgchB9NWPrt8N2t0R16az8Oh1
         I3PVvOZSr/OOZd6nUs0cw3Zd7cTYTR516vZMSCCp+87rIJ3yKjNRBwtIG+hF/t9ENIQx
         edJqT9E6g/zLTXr5y1NjtBxjA6a/Bv4TxR87u44eI9kgWD2odqrHEUDFqBYVX9F8oU9q
         g+QzVrjbI6hD/EOkbkxDPCnYCOABzD3gXHXYp/puxjgiJeywgDgnCDjV3becZRvlwmw2
         73HOgnhy71YfQUG9CJ/lp1+5c4yBAmn6b8pBZiET0X1mh47OvZvrcjecbVI54syeq0D0
         kxow==
X-Gm-Message-State: AOJu0YwtKltM6aF+GIjGSbZ3h/i6RNDhK/+z2k/+oWnW3FXffkfD7Zgo
	48ROOUMNklcLRZ/sNJRt3YgCrdJWOn0Kgur617FtuThOXHsU0eiB
X-Google-Smtp-Source: AGHT+IF2Xf1lfjVq58Gt/9W+fhqA7SmsG2av+7pGQvcP2CNF/UxW+n4NTxQgyewBD9fRGUtUE0eFgQ==
X-Received: by 2002:a17:902:e549:b0:1fa:a4ec:5010 with SMTP id d9443c01a7336-1fb33edfd30mr5112625ad.49.1720064642433;
        Wed, 03 Jul 2024 20:44:02 -0700 (PDT)
Received: from [127.0.1.1] (135-180-162-235.fiber.dynamic.sonic.net. [135.180.162.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac11d9685sm111473265ad.111.2024.07.03.20.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 20:44:02 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
Date: Wed, 03 Jul 2024 20:43:44 -0700
Subject: [PATCH kvm-unit-tests] This patch adds a unit test for the debug
 console write() and write_byte() functions. It also fixes the
 virt_to_phys() function to return the offset address, not the PTE aligned
 address.
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240703-sbi-dbcn-write-v1-1-13f08380d768@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIAG8ahmYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcwNj3eKkTN2UpOQ83fKizJJUXQtLE2NjE0NTszSzNCWgpoKi1LTMCrC
 B0bG1tQAbm6BWYAAAAA==
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
 jamestiotio@gmail.com
X-Mailer: b4 0.13.0



---
Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 riscv/run           |  1 +
 lib/riscv/asm/sbi.h |  5 ++++
 riscv/sbi.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/riscv/run b/riscv/run
index 73f2bf54..e4e39d74 100755
--- a/riscv/run
+++ b/riscv/run
@@ -30,6 +30,7 @@ fi
 mach='-machine virt'
 
 command="$qemu -nodefaults -nographic -serial mon:stdio"
+
 command+=" $mach $acc $firmware -cpu $processor "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..4ae15879 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -12,6 +12,11 @@
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
 
+#define DBCN_WRITE_TEST_STRING "DBCN_WRITE_TEST_STRING\n"
+#define DBCN_READ_TEST_STRING "DBCN_READ_TEST_STRING\n"
+#define DBCN_WRITE_BYTE_TEST_BYTE 'a'
+#define DBCN_WRITE_TEST_BYTE_FLAG "DBCN_WRITE_TEST_CHAR: "
+
 #ifndef __ASSEMBLY__
 
 enum sbi_ext_id {
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 762e9711..0fb7a300 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -7,6 +7,11 @@
 #include <libcflat.h>
 #include <stdlib.h>
 #include <asm/sbi.h>
+#include <asm/csr.h>
+#include <asm/io.h>
+#include <asm/sbi.h>
+
+#define INVALID_RW_ADDR 0x0000000002000000;
 
 static void help(void)
 {
@@ -112,6 +117,72 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_dbcn(void)
+{
+	
+	struct sbiret ret;
+	unsigned long num_bytes, base_addr_lo, base_addr_hi;
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
+	report_prefix_pop();
+
+	report_prefix_push("write");
+	
+	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
+	base_addr_hi = 0x0;
+	base_addr_lo = virt_to_phys((void *) &DBCN_WRITE_TEST_STRING);
+
+	do {
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+	} while (ret.value != num_bytes || ret.error != SBI_SUCCESS) ;
+	report(SBI_SUCCESS == ret.error, "write success");
+    report(ret.value == num_bytes, "correct number of bytes written");
+
+	base_addr_lo = INVALID_RW_ADDR;
+	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+    report(SBI_ERR_INVALID_PARAM == ret.error, "invalid parameter: address");
+
+	report_prefix_pop();
+	
+	report_prefix_push("read");
+
+/*	num_bytes = strlen(DBCN_READ_TEST_STRING);
+	char *actual = malloc(num_bytes);
+	base_addr_hi = 0x0;
+	base_addr_lo = virt_to_phys(( void *) actual);
+
+	do {
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_READ, num_bytes, base_addr_lo, base_addr_hi);
+	} while (ret.value != num_bytes || ret.error != SBI_SUCCESS) ;
+	report(SBI_SUCCESS == ret.error, "read success");
+    report(ret.value == num_bytes, "correct number of bytes read");
+	report(strcmp(actual,DBCN_READ_TEST_STRING) == 0, "correct bytes read");
+*/
+	base_addr_lo = INVALID_RW_ADDR;
+    ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_READ, num_bytes, base_addr_lo, base_addr_hi);
+    report(SBI_ERR_INVALID_PARAM == ret.error, "invalid parameter: address");
+
+	report_prefix_pop();
+	
+	report_prefix_push("write_byte");
+
+	puts(DBCN_WRITE_TEST_BYTE_FLAG);
+	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8) DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
+	puts("\n");
+    report(SBI_SUCCESS == ret.error, "write success");
+    report(0 == ret.value, "expected ret.value");
+
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 

---
base-commit: a68956b3fb6f5f308822b20ce0ff8e02db1f7375
change-id: 20240703-sbi-dbcn-write-894334156f6f

Best regards,
-- 
Cade Richard <cade.richard@berkeley.edu>


