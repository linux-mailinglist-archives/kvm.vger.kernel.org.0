Return-Path: <kvm+bounces-21066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E798929600
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 01:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA86E2813C3
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 23:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A504E4D8CE;
	Sat,  6 Jul 2024 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7MkjlIT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49023741
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720310149; cv=none; b=K3aVjZjAtFp/Wj8KpUUyrg27D3dvA2MY/wfx0SOOJWVw0rczr2q+jMgD5NrvAPM9ME88PRRYUYtdLheFDFM3TTVqucBf/2C+uXPImD3BLaa3fjLcRQA03biwHBeC8QjqHqnx2NAQwI88XMBnysXERS8uEIyhEqDl1wJ6hIet5Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720310149; c=relaxed/simple;
	bh=Yhej9AOQlHAK+vBv3DRRHLWOzCw92V/GfHbyPix3Zo8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EyRgLM+xBuJ27Wk0kJOSX/U+LgG6f501Y8vmmM3C92ZQg54FWc9FDqz2R5pMl0GOBqSQble6O3YXXvIiyLsfDeciRj0CKA/PbpKbj3V+jNj+GZQwO0gnluKBNRttFKxvtvHAvTNiH4VB15LLV8zx6sQG1qBb/Xd9HH4it4NHLIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O7MkjlIT; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7fb008db12dso3017639f.1
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2024 16:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720310147; x=1720914947; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sFlf0L5XX0a9h/dBp7DCCe84ms07x6tR5xCf+BcEWz4=;
        b=O7MkjlITo/Hb+wALBfwBa8xcg3M/unE0JZClNtqd9LMeCLjbnb7VwAGm3b2I07vJCO
         125mYRvOcUklLEqPobIRiWsIWpYUAu+eekAS6acKRQkhq83kArVj1ailzl+VxY6UiNnr
         YwgJs9ClSm3jOWb5fsw6nfOJjqhFVlIgOx7jm8NekP/p+ZXuDt1cD0HqHdtxb3J1ELgE
         R5Z6FmWQ528w0OuULOo0BPYuET+U+057q2ftjmKUyDa0oNpaIbGGn//KaxbRAZVkz+WY
         dNf0bXesqfsXvIJQy/1pCRwiKcbX93x0RT3NqJ9fMVexsX3Kt5s6tFGub/SnhmjlPcUl
         nZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720310147; x=1720914947;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFlf0L5XX0a9h/dBp7DCCe84ms07x6tR5xCf+BcEWz4=;
        b=j9HTneUhGkZqjTIWATNyv2TuuVg5/zIb4pZjjkzNgd6JKdjidzR4MzEoP5Eo8nQVx1
         z+ce/zU5iMO/YtGB72Hmqk+v2i3sUrNWNJ5TgCnw5TNmrfbxFswZeGNz76E87QkbXMSK
         nHhhGmbCQeBpywIsizxCaEVTfBYZp7zGY23ab1N+LcuufxZaPr7TZyorqJr4GCButNS2
         gDbMOFBZM/+iJApq2SyAg8zozoz5eJF0cAHpJWWG4ZqyNvs+NHx6iLbDIjsCyvrLa9yd
         Yo2BsJFdsmZGxtSHCWNokfAebk+BpcZ8FJfckhkwNlybuRl2h8lXW63l3RYWLfLTCLRm
         qJOg==
X-Gm-Message-State: AOJu0YyGOS7QsLZaL8gfPPMdfpfbX4et5ltIATxGRtKtepDlT98c8mAX
	z7UUTyZzjUvgj6T2R2a1yz1IGKxUHqo20C37NTvBCGVbwdmBIFpN
X-Google-Smtp-Source: AGHT+IHiaX5QJ9J//GYKvGwR9qyvXoCAdoDj2aGpqvxjLw105fRjf1N532bcU4lO6i3I+pyjTJfRMw==
X-Received: by 2002:a05:6e02:144f:b0:375:be9e:34c3 with SMTP id e9e14a558f8ab-38398710698mr122037125ab.12.1720310147632;
        Sat, 06 Jul 2024 16:55:47 -0700 (PDT)
Received: from [127.0.1.1] (23-93-181-73.fiber.dynamic.sonic.net. [23.93.181.73])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb2523f6fbsm62715065ad.181.2024.07.06.16.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jul 2024 16:55:47 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
Date: Sat, 06 Jul 2024 16:55:46 -0700
Subject: [PATCH kvm-unit-tests v2] riscv: sbi: debug console write tests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240706-sbi-dbcn-write-tests-v2-1-a5dc6a749f4a@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIAIHZiWYC/4WNTQ6CMBBGr0Jm7Rha+asr72FYWDrIRAOkU6uEc
 HcrF3D5XvK9bwUhzyRwzlbwFFl4GhPoQwbdcBvvhOwSg851kdd5hWIZne1GfHsOhIEkCBZaN6Z
 XJ6PIQZrOnnr+7Nlrm3hgCZNf9peofvZPMCpUaOuyoFJVxvTNxZJ/0JOWI7kXtNu2fQEHBFh1u
 wAAAA==
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com, cade.richard@berkeley.edu, 
 jamestiotio@gmail.com
X-Mailer: b4 0.13.0



---
Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
Changes in v2:
- Added prefix pop to exit dbcn tests
- Link to v1: https://lore.kernel.org/r/20240706-sbi-dbcn-write-tests-v1-1-b754e51699f8@berkeley.edu
---
 lib/riscv/asm/sbi.h |  7 +++++++
 riscv/sbi.c         | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

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
index 762e9711..18646842 100644
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
@@ -112,6 +121,56 @@ static void check_base(void)
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
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 
@@ -122,6 +181,7 @@ int main(int argc, char **argv)
 
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


