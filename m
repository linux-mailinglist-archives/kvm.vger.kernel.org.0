Return-Path: <kvm+bounces-50115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8DBAE1F83
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4B806A6249
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92672DFF13;
	Fri, 20 Jun 2025 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2UMQDN77"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DB12D5410
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750434657; cv=none; b=uXBRgsN+17nG8LQz2z9P0xYpL64gDomsfrxDOabhc/OUIo7gq636zh0G24rN0/b7azcR7oV1vFCcy7PRsDDBS9MdNGx0x4jcDXLmUtmTXfsB272lWh7oztxi3mdCshO/aN8ZpVBcGqOWgHtEtvC2Uljm8cu9dfC7gRFK3V0ozIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750434657; c=relaxed/simple;
	bh=gCSRjdYqG3EEUY1fJd8dcZBC+dlFimBQ3bHa5DO8oTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qFnFZF38BNVWc/n6EiYyNqWjl5PAo/TxkObUTcBbmVOgBzhyRUYlwEA8JHlMw8rp024upR2q+U28nfdIxEfjdiQToucn5TB1wklPuTEpQ7XLp+VnhWIppPpO8Akl1iCgwrSoEyr8lQOnYukQ7HYCrT747oqdiAs91zhwmllQGjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2UMQDN77; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fad4a1dc33so21405296d6.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750434653; x=1751039453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lb0bY/htYmIjhjl7e6qeommZ2woeWEYXNTEbvyaBVDI=;
        b=2UMQDN7768OqyERSRvGPilqJ002j+DhWB4IRULjbhRWhMhjCbi9QHyFXcoqr9u8gFy
         2vZ3Bb26eaWQUCblm5KxO1srNyCtNsZqZJ0CF/9Z9I71JywcxTYmPLPFwUu1UccGtLtL
         QYhVpdgMWGEAKkvF//eI09yLlcSN4TouxKyo1fDtU+fXgqIBd23W0HpXN5p6TEZGhg3p
         5mTRDpjeCvWuL4ZKMMWC4VPCKOgOZLYoU9QXYkvOtPar9thvJ9qzYbi5Ae5NcHUMCM1a
         qB2xkdG+r2k9oZco7WR+Vkx97qM6y5BItpXLLhedA3ToL7P2Rdqo9wg8Z2qPJX9AEfIO
         fiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750434653; x=1751039453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lb0bY/htYmIjhjl7e6qeommZ2woeWEYXNTEbvyaBVDI=;
        b=rwGa/JEcW9I4QiF0nOu8MqrE3GB7s63emfkoszGGOoRFq0cPcvLlUF9xHrXS3Id1e6
         ntOhJ/MCvaCDLSIhP1N+I4jKi5AJ+/3IQ7/e3xtHiiLIKDJtQNb6JLr6dsiF+bhu/LHv
         gw2aQWN3egpBjFA23TLN+tU7/yvzRcUGI6VEr5lDtzoLV6+WrDGnQuGgAL/wmxuvYKU4
         +j1Hm+vlWFA/vzp8U1cDmC1gv8RglukDGYtiMJ3dpQGU9zST8N6NaI503LhVZsJUEfYG
         S+67DEu9jlu4d10R7PtxYcFgzeGikhWr90zTkQG/ku6lI0urdVRTzj3ddaoEv2F4kdCt
         JfpA==
X-Gm-Message-State: AOJu0YyfmRkRwnpvur6EvxPCH7c/+wPCqi4RIFq/keKhU67Y2lCCnObz
	l0WytlstmOs8lEYjj0KJ+QJtTBM+fCd757/guCqVvdqHwlhQxYza3JKwMqjQc5bvrf3B6AywkNq
	ARGA7
X-Gm-Gg: ASbGncsN/KXOeL7rOoVxJ347m14mlGDvLvotI57WtkjZ0l2/CXi3MK0iVlIfjpegnMx
	BgW0iHlnD4Dcet5Gp0woEsHZ8RiAT7yANohW0rZWAx8LHdgn8MyGD2TlYTsB4IVcQFVc8G00OuD
	cNO7Q1VD2rmHLjCT/yGKweSW7+UOP5mAXYwUC5guIP1hFyEdMwFT+0GXEAdJ3dNDS7ySAQxBv2Z
	TVM0GkUyoT5nMZzg4mkacteeuXT8oxeMku8/xD63Z2bpaYVO4VOYlGtpDMoeeM9ieCGPzP77egc
	GVvEpUk4UmVbA3XgIg0bj7NULD40Ufn/YS7ZxFZay+Y9mp0TT178xhpxe483oviBInrGpmCMHa9
	upRti9bAPal4MBIyPIex6+AzIwV+z4iLJHU6a+qDcxLHBTiw9O9U=
X-Google-Smtp-Source: AGHT+IETUJGmBTkpbC46zTXbh4bGWkFtIlbC6e1CPw3xSSEKzKZ4d32RaY3VpeK/E5rx0MhnNTQd5A==
X-Received: by 2002:ad4:5c66:0:b0:6fa:faf9:aabb with SMTP id 6a1803df08f44-6fd0a59692bmr61494516d6.38.1750434652753;
        Fri, 20 Jun 2025 08:50:52 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd095c8ccbsm13317606d6.122.2025.06.20.08.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:50:52 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH] riscv: lib: sbi_shutdown add exit code.
Date: Fri, 20 Jun 2025 08:50:51 -0700
Message-ID: <20250620155051.68377-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When exiting it may be useful for the sbi implementation to know the
exit code.
Add exit code to sbi_shutdown, and use it in exit().

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
index fb40adb7..02231268 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -150,7 +150,7 @@ void halt(int code);
 void exit(int code)
 {
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
-	sbi_shutdown();
+	sbi_shutdown(code & 1);
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


