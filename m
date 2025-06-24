Return-Path: <kvm+bounces-50536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1680AAE6F6A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7B67189CAAE
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECCA2E88B3;
	Tue, 24 Jun 2025 19:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wFwAuPUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F72E88A2
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750793002; cv=none; b=nKVTAmV3CKdrh6f4jV+XDH8SECtE/hqQFZ3WpoqUnbIfmnJmFre7nMUnVpVfGSN2ifuA/9D/kinC0zmgdssWg1PLfyrI4Vt+VbwrNRz+l6XpwAkYDN9bQr0pmyBv/0VbmkTI+igkmfnjhkKaXhY3ECvftffHcxWIJGdrscIpRF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750793002; c=relaxed/simple;
	bh=9U4gP041/MBbOTyBnMrQj8uf5fyw66YvwyJHfSvr1lo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cUwDjaY4RjyXFHPSpba6/64kJdHRXCNCmHoDm5gpuqrB0K8dG/b5+K8XEubaoT8O5BqWj6pi96G5oRhRmSmPkfmkGS8kMVVpRtn67eD523zIAAqNjRm3UN7gM2xm/xfe7kgdHZ3b86h6uC4SzJgPErh7eA6M6EnVehhXy1y2hZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wFwAuPUk; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7d0a0bcd3f3so24176785a.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750792999; x=1751397799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gJEHC7W7QNUQcjlQadx2lMB+Voeeq/w833ndZR1fDN0=;
        b=wFwAuPUk8HCVuLgyNoNigOc9g2ri9HZ4IlRC3RRJjAXIKIvzro3TkOcjY41ntQyvjL
         ETlpSS8w0Jx+uMCCvj/L6+nc2Issld8axDy098cs0vmb2K+jbVbsLfXrbBNy5ryaKzv2
         0lekaJAsgHJKxIJzYSV2b0R4Vnhjn1THa4v61SoJT+Am5nPGZshnsvrKlHiHTkUiWsrx
         3UxCnYifd/NvkYiO52n99/EgYAyo7nb7MostApvMOrgh/Vkrf/o5xq1V4c0abw8KL2DM
         x+J3lB+aq8ObMfTc+R8NN44kxA5+xeIkCTeskrtYlc2FV4uW6PRi/PCsM4o+r/Z9izMp
         Mwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750792999; x=1751397799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJEHC7W7QNUQcjlQadx2lMB+Voeeq/w833ndZR1fDN0=;
        b=T1f/c+3tBbkrKnH9V8SFDvMlv2LpjH0EVasBMz7cWZcnoSwY55K3Y1UqtU5Z5A6fHo
         oo8jwipyCZwPy3k1bEO4Limf00dhSzwVSEa69HB0IFMVQjJ+xq2iC4S7Evb9ov9F/32h
         pOIhb7q9Zw92E7xs4vxl6zfW+IWHQOSiWaR3M0tKYLHyUX6qA3/LAjatqvkqUMkjez6a
         Oh6IqobJvz7Tr4LjOBDisFxvaTpmS9X1at9SI7/M2HM2CFnn6Dk00XpQ4vyvSVUAULtS
         SEq3lJFfqB+f0pq8qopKcraUcE7dHQyFrjyheHIN4AnbaaxbNLGVEvl7H+EYJUFtDlVu
         Q2CQ==
X-Gm-Message-State: AOJu0Yyn2rrAZFP44OQcKfmuGBk+Q/RwIXh0fawySNtpzY8y3fDiKOxA
	eCVVIvOHjhARAvPtK2mObqv872qs60SI0E09XQ7VDvwJsje1U26G9P7mUjCWdX9W/cjrPoPzmw9
	EiWhG
X-Gm-Gg: ASbGncuu4A8hF3GAs6AaxcDEoyr/fdLsA/bGTyazdOHlvt/rt1u89SegWG/Xt5lQ/is
	dvJqaFvNokKX2pgSDwFJKJmfh9GqPWk70Mpz96f8iB10+51dMytK/NBlWN/GaeGGMQYnjErRWfD
	4kXwoEIl35VMl9U79FQy0eVbUdtMB08P+xcvlXc+c5IGOmUyqOTIHKRmi7Lm3a5lJqDy8NOSnAl
	uhsDTILVfk8BWpg0rgXC2pALPpoEAFOMDJT/GTcNU2LMt05UYBWJx51qHldjubn5SPplU2EVHoN
	dISo+rPjYpFSXNuDvowEUHbDYArB/Pcc2gt9qXtKJGOINSzNhzftg9Ibs+UWl6vKTqzhySaii6I
	byzyU43e8ewNLN7psMxxsCAQya4niYr3XgsqnKN6a3ayTDqQRxunuTSloxcqpdA==
X-Google-Smtp-Source: AGHT+IEpWt8zHh5hqZ66ViGmfWYuDSGLX7ZbSUGK79B47Y9xlyE9QioC0WusRzyQfrYBkVZ91oshfg==
X-Received: by 2002:a05:620a:1708:b0:7d3:a4fa:ee06 with SMTP id af79cd13be357-7d41ec6e85dmr607952985a.29.1750792999362;
        Tue, 24 Jun 2025 12:23:19 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f99eed41sm534292085a.69.2025.06.24.12.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 12:23:19 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Cade Richard <cade.richard@gmail.com>
Subject: [kvm-unit-tests PATCH v2] riscv: lib: sbi_shutdown add pass/fail exit code.
Date: Tue, 24 Jun 2025 12:23:17 -0700
Message-ID: <20250624192317.278437-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When exiting it may be useful for the sbi implementation to know if
kvm-unit-tests passed or failed.
Add exit code to sbi_shutdown, and use it in exit() to pass
success/failure (0/1) to sbi.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 2 +-
 lib/riscv/io.c      | 2 +-
 lib/riscv/sbi.c     | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index a5738a5c..de11c109 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -250,7 +250,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg3, unsigned long arg4,
 			unsigned long arg5);
 
-void sbi_shutdown(void);
+void sbi_shutdown(unsigned int code);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
 struct sbiret sbi_hart_stop(void);
 struct sbiret sbi_hart_get_status(unsigned long hartid);
diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index fb40adb7..0bde25d4 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -150,7 +150,7 @@ void halt(int code);
 void exit(int code)
 {
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
-	sbi_shutdown();
+	sbi_shutdown(!!code);
 	halt(code);
 	__builtin_unreachable();
 }
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 2959378f..9dd11e9d 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,9 +107,9 @@ struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
 	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
 }
 
-void sbi_shutdown(void)
+void sbi_shutdown(unsigned int code)
 {
-	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
+	sbi_ecall(SBI_EXT_SRST, 0, 0, code, 0, 0, 0, 0);
 	puts("SBI shutdown failed!\n");
 }
 
-- 
2.43.0


