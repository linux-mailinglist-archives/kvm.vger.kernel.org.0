Return-Path: <kvm+bounces-21065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A45E79295FA
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 01:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D6A41F21933
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 23:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F144C3C3;
	Sat,  6 Jul 2024 23:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqXxEd4X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D69610953
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720309728; cv=none; b=R+NDpenhQvM4TLxRISqKwkMrEx94qXS3W8lwGyJefFr+smCNWTWHdZHzZQFPMlhv275N87jeU3tHSVDPGUtonOw6f8WfBc5e4bCWII+35Yd3wu3wYM3TTnht+oeSkGh8nXN64caErRgbcFxPBzUxy7uE6ZH0Hlh6yDanly6DZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720309728; c=relaxed/simple;
	bh=Py6fKWN58Bt5jMXoTOKJbk+lC0IzpHmNWyT8hAKrfx0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SYMrGBcyvb6OE7RCQysOicFPwj54vgAJn4zaN76QMQ5R23jTwrToEOwZupNn3kKIvbeOnTIqDYDHNdMbW5M+6iwHeFTV1sOGlyGomccvIyCueQ1uJFZfrzleGlbU2g4G0rTvEvKo9tCqBFRWYpQd+5GEPulQhs3wUb5B+YfSeM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqXxEd4X; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70b03ffbb3aso2069427b3a.0
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2024 16:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720309726; x=1720914526; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mghg7f2ee8jgMSe4q+5emCfOCWip+frGRaZu05S8tC4=;
        b=MqXxEd4Xre7PFZ4U79RRD6s9bX2V405MY7I2TPj+/IaxdWcmr5BZmaqZvMYMvcUf/h
         Z12TBwB3cnHoOA9HlR7AuqpdBb0NjEYb2JY0MknAMbL2mDcn2xoNPrzWGdqPYknhQ74U
         q5TImJPcoYs2L1xYIc1OJyZqe1StBUG4/inn8uU7nio7XPvXwXjQLIQXP78pShJY7urU
         XgLyWu75JWKWPw1TjrRciYCqlVt1x9SRz+keTFZD9rec4tWRjMC2woUirasQD5Hou8Sq
         ssB5XJMzGXgNinHxQTfUlytphsbiQ7UUXnufZ05JMHHS+GcgYY9Wr1I5YpGtIEL2EyqK
         oThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720309726; x=1720914526;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mghg7f2ee8jgMSe4q+5emCfOCWip+frGRaZu05S8tC4=;
        b=XqOH5sSaQDJTJJUfIGVtnQB5G0OLQqOIkDuB2d/o1Su14I/MdoCjA56hYw0FFqXbYk
         VOwqDSZvEkYP/4eyatvpBkqfgUH1SKjc3Gmrsg1Xo5jsjwhlC5vA6/LLwbw6C/rLbafQ
         UdlWa1Zz6EbxNcgQ/jvOpRus9qi8D45FiTsYPl3fSSKFKh8pp0nF7OLEQb6QZdhaYF4q
         rzROkyOtfJ+vTift32r9YaFlF7qYszSJtc4LQocOCcfmq0/H8aNPaIXgItcMg1oJILCK
         8uwjoDjMQDYmHsHj3fJgvE27WccbO5O0XButisRVbG/u9pDulCLcl2X1KX2GIKcTheE6
         OVOw==
X-Gm-Message-State: AOJu0YwWaWuaqH/ITg9xFg5/YDrkEOXnAK678ED2dyYSn9N7DPZ6dSgz
	XksZemejVoaWRv9YFrJ3wwmnJaU/gDYt/PfDqt9i0wsm34Ql0gyQ
X-Google-Smtp-Source: AGHT+IEbxO/7OSoMR/865Iu//yNuzmE9aWo6vQZK/9xlvhxqZKXVIQLIRRXEQarmSizmYZkTV5a04g==
X-Received: by 2002:a05:6a20:2446:b0:1be:ca24:964c with SMTP id adf61e73a8af0-1c0cc8784e7mr12075064637.16.1720309725765;
        Sat, 06 Jul 2024 16:48:45 -0700 (PDT)
Received: from [127.0.1.1] (23-93-181-73.fiber.dynamic.sonic.net. [23.93.181.73])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99aa0ae28sm5531726a91.45.2024.07.06.16.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jul 2024 16:48:45 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
Date: Sat, 06 Jul 2024 16:48:44 -0700
Subject: [PATCH kvm-unit-tests] riscv: sbi: debug console write tests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240706-sbi-dbcn-write-tests-v1-1-b754e51699f8@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIANvXiWYC/x3MQQ5AMBBA0avIrE3SlqCuIhbolNmUdBok4u4ay
 7f4/wGhyCTQFw9EOll4Dxm6LGDZprASsssGo0ytWtWgzIxuXgJekRNhIkmCtTGd9bqymhzk9Ij
 k+f63w/i+H/fb7N9mAAAA
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
 jamestiotio@gmail.com
X-Mailer: b4 0.13.0



---
Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 lib/riscv/asm/sbi.h |  7 +++++++
 riscv/sbi.c         | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..c5fa84ae 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,7 @@ enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
+	SBI_EXT_DBCN = 0x4442434E,
 };
 
 enum sbi_ext_base_fid {
@@ -37,6 +38,12 @@ enum sbi_ext_hsm_fid {
 	SBI_EXT_HSM_HART_SUSPEND,
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
index 762e9711..b93ef5d8 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -7,6 +7,10 @@
 #include <libcflat.h>
 #include <stdlib.h>
 #include <asm/sbi.h>
+#include <asm/io.h>
+
+#define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
+#define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
 
 static void help(void)
 {
@@ -19,6 +23,11 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
+{
+	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +121,55 @@ static void check_base(void)
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
+	report_prefix_push("write");
+
+	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
+	base_addr_hi = 0x0;
+	base_addr_lo = virt_to_phys((void *) &DBCN_WRITE_TEST_STRING);
+
+	do {
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+		num_bytes -= ret.value;
+		base_addr_lo += ret.value;
+	} while (num_bytes != 0 && ret.error == SBI_SUCCESS) ;
+	report(SBI_SUCCESS == ret.error, "write success");
+	report(ret.value == num_bytes, "correct number of bytes written");
+
+	// Bytes are read from memory and written to the console
+	if (env_or_skip("INVALID_READ_ADDR")) {
+		base_addr_lo = strtol(getenv("INVALID_READ_ADDR"), NULL, 0);
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
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
 
@@ -122,6 +180,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_dbcn();
 
 	return report_summary();
 }

---
base-commit: 40e1fd76ffc80b1d43214e31a023aaf087ece987
change-id: 20240706-sbi-dbcn-write-tests-42289f1391ed

Best regards,
-- 
Cade Richard <cade.richard@berkeley.edu>


