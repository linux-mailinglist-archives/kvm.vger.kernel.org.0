Return-Path: <kvm+bounces-51534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D0AAF855F
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 03:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E76AE7A1C45
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DFA1DCB09;
	Fri,  4 Jul 2025 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="E8s9xIPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9237C33DF
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 01:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751594322; cv=none; b=YvpMDn5CFS1YbLDoxJokUeuwHf/HaSJwqHcuCCAVAjeJ/J+bNjmkEhprWg7PIOWdsKFzgWo9I3dHgU7mkUd2cARcsVbgyiMd+Atj/Vcushcq3evgb0GltpU27Uh8O08vL+c9rT85TtVOMpe6tyCTZF3P9RtBWZTxvAwm6zBGR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751594322; c=relaxed/simple;
	bh=MEYakmUKLHnF3WCekXxwTM657RRlyZwoI6/HTrtAUdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CrWSbhSlWAirlFw9yS8RUKPhRcxmdbyidwI1aDgBDYFZlHJ/tujUBGeEqNydQQz4C2Oy3XHpLXBkpxJx/u5+H0VnspMy6+SeO2eWwUWkMFVfWG/Ckh1KdY0ietvDxQjxHHdwcpMeZA7nQpGRWxz3LT8Armz2oO/Abihm70OT2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=E8s9xIPa; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6fae04a3795so6183386d6.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 18:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751594318; x=1752199118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QnLXVWExKoNZiJLIxtursHY+uAzhVs7mpFreujfZRkc=;
        b=E8s9xIPaszufggYHV2jiN0GUc++dd6QdoQzdYE/f6WMIvjo22mPILkUR8rNYPITyqI
         l7w+beXVgJvBwxRBQpFdQrl5eBKN8t9l7S7QH9/EOVg8wXR3BE1S7pslneppQqP2+Zyt
         BxVCi4LgBqaQWFrAyYMGKIPrDzxQ3W+2g98goZN5XXpGVNR1v97+gZrcCDDZTQM/t+xj
         /PMD2rBD1GanOh9+5U1ZW+MpxkO4JX4Mk/EVp3e9JGsIkQag0PiiRZOLbYY2O/PVVatG
         OTRo/JEsVZvykAnYEFfeeiuMaKkQ13/BmtdlAaLdvOmrb+27fczyj6P+NXl6ZQte9pb+
         v+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751594318; x=1752199118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QnLXVWExKoNZiJLIxtursHY+uAzhVs7mpFreujfZRkc=;
        b=Z8XW+veMOA9PmfJtv0nvMyff08spv4iXmHkr2i1ARdm9bjg7A8rOOC2Ol4OvhQfAkZ
         jGwOvZnVi1ga5bX1YL8yMKtoRD9w964L0ugVp6C76ATTKbc+gJZGNFZa72djBmFkW2LX
         jg/TSO7GNUEJgPi9VI79LaEXlhFtg4rK+2h9SZG8L2NFrnZeyIVlVQFcf0vYa/0uKXUV
         HFFfslC5tZgF0p0HoOXVUEyPh0I2yflEHtCuvW204UVPcb9GihD4sL+o4NZ1BKWJN0oV
         TQsM0P/D314cE4f4bfcr4LusFq+uDL1N/PyN+Q8aNg8jQyF8ihpA6c8Gx2q5y0LXslfD
         RPhw==
X-Gm-Message-State: AOJu0YwsbNl0n19q/2ITpE0E0N2Pds870ybdBJk5uWzrJEpHiV2TMaiV
	AdusD4JFo+uLx1CPtDRbqMTOPQPuNpViW9dsKck0Ja1Rlihvu7aFFk1F/3V8klbTON0py7YJdDO
	12kMZ
X-Gm-Gg: ASbGncvs4AnXV5aOuWew7tO5Xcqh3DPyctTkAOllZk7r8LQ7GvJQz9crBRVr5ntl25h
	oHabSHgK6Cisa2Tq4ndl6Ux2cs41n8K2wcmN6lhVkL5REnNY2gmJyfuqFS//ewLJKOcx7dOLfjJ
	YzNgf72A7GqatC6ysMeUokzbJKGguQjapYcYdf0dTjx+p4p6aG5Q/50GBddVxrwH9YT1K7P8qxL
	oOQSuqXrGX0fFMyCue6abz9tdo8mxu/nOpQA64nppjoyxhtvI8LwFr9m/a+89uVYRxpjTu0TsnP
	XCIrQej/hAENLpUtlk8YCS/SVvup7FCoRRGEu0aSBm9Rd3dxagnxXH6ZactkztW6AdVM9Vtn/Ap
	C390nO9vZHw==
X-Google-Smtp-Source: AGHT+IFjxkaBEImztNDgLRUCPF9Hxz9tbtkMiO4rL8Aov5ucKBXPKeNdTk/a5C14X/9WkJXb6dZhzw==
X-Received: by 2002:a05:6214:4291:b0:6e8:fcde:58d5 with SMTP id 6a1803df08f44-702c6dedfa8mr10308586d6.42.1751594318341;
        Thu, 03 Jul 2025 18:58:38 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com ([96.224.57.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d601a7sm5842446d6.107.2025.07.03.18.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 18:58:38 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] riscv: Use norvc over arch, -c
Date: Thu,  3 Jul 2025 18:58:37 -0700
Message-ID: <20250704015837.1700249-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Linux kernel main tree uses "norvc" over
"arch, -c" change to match this.

GCC 15 started to add _zca_zcd to the assembler flags causing a bug
which made "arch, -c" generate a compressed instruction.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=33128
Cc: Clément Léger <cleger@rivosinc.com>
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 riscv/isa-dbltrp.c | 2 +-
 riscv/sbi-dbtr.c   | 2 +-
 riscv/sbi-fwft.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
index b7e21589..af12860c 100644
--- a/riscv/isa-dbltrp.c
+++ b/riscv/isa-dbltrp.c
@@ -26,7 +26,7 @@ do {										\
 	unsigned long value = 0;						\
 	asm volatile(								\
 	"	.option push\n"							\
-	"	.option arch,-c\n"						\
+	"	.option norvc\n"						\
 	"	sw %0, 0(%1)\n"							\
 	"	.option pop\n"							\
 	: : "r" (value), "r" (ptr) : "memory");					\
diff --git a/riscv/sbi-dbtr.c b/riscv/sbi-dbtr.c
index c4ccd81d..129f79b8 100644
--- a/riscv/sbi-dbtr.c
+++ b/riscv/sbi-dbtr.c
@@ -134,7 +134,7 @@ static __attribute__((naked)) void exec_call(void)
 {
 	/* skip over nop when triggered instead of ret. */
 	asm volatile (".option push\n"
-		      ".option arch, -c\n"
+		      ".option norvc\n"
 		      "nop\n"
 		      "ret\n"
 		      ".option pop\n");
diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index 8920bcb5..fda7eb52 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -174,7 +174,7 @@ static void fwft_check_misaligned_exc_deleg(void)
 		 * Disable compression so the lw takes exactly 4 bytes and thus
 		 * can be skipped reliably from the exception handler.
 		 */
-		".option arch,-c\n"
+		".option norvc\n"
 		"lw %[val], 1(%[val_addr])\n"
 		".option pop\n"
 		: [val] "+r" (ret.value)
-- 
2.43.0


