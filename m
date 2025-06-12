Return-Path: <kvm+bounces-49272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BA5AD73BB
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 16:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 256D31888773
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DE423C8A1;
	Thu, 12 Jun 2025 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="dOI4lOF1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E672E149C4D
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749737822; cv=none; b=gIzvy3uBkffU1LsJegoPvENOdPi1vYeRY5Ztzh/sagjUuyLixfqsxWv8nR2U79upC5B0i+WULPtn6iDy0LiGRiqqRwDI76qp+MGE6kQ9gyHUGVBvOfTl27kCFGimtSQtdnY+pmyOT1qeCXi5n+mF2Kt2w7dec9oXO+cUdtggouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749737822; c=relaxed/simple;
	bh=d7VBfmhbDpsmKiOGX/ldN3DPv9ez9U3K2i2Ztppcl+M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fDG+kV3beUAFCzFwnRlF+Mp87mdssMbVGYOTbU/1eDbiEOImzGQXaRzmj/BaANI55m+YEnepq2BtFxhSYAJ/eRae+W1xZ2GoOPSvp4RbAWuHQUaWPbVGQssysseI0LKi/ntE3NsMBDNOJOw2qdy6hZZIiS8+XHpycjcjWxFH+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=dOI4lOF1; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so1578248f8f.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1749737819; x=1750342619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C6E7EzF5woM+zQqsJQ3arM6v7PvlMDD/avhtrC6dK0A=;
        b=dOI4lOF13uAx/fl2kCNUPCUwxmKWuiidk5NxYiyYWLHxHrfR8wA6NHmMYbDmoL7cBS
         M5PSg4RvJOT4kTLDz+qUWSdb7nIO4jmp2uzxjhNd97VExwnAA/qpANOV47q7c0H4LTS2
         udiLeaZ+uc291dQjIABIM+/uDLUug8I7Jo4VRDXdgsRn5EySiQuROeeS+yvJzQEJpv9p
         r3dufSTbkTDT61jOXJrkk6tfiuzC09bReyfiRHHIsaO+eNn9ZW45/LkD52ivPc2Kdd3T
         sbv6ZmieX7ct+g6AkC5NVLuIxe6E0E6mKkvqoIcLH5xy3DcAXijlPmkzlKmC79ybj8Mj
         DpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749737819; x=1750342619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6E7EzF5woM+zQqsJQ3arM6v7PvlMDD/avhtrC6dK0A=;
        b=WAp9Xh68YzkojzM9zP4ZJs15jAxBMorpqCx59wrCxEJfMEUhvkYhbCsaXixN27BzE0
         K1WXV51E98LHW08tdrnuNSNsjLadWJ6WS6pPm+fCaVfJAhDW7C39dgmULazXCbBLNMSO
         OvXa5YemdBOiJMniCYZA1ZghW+jWKcOkxDVYDepsT66jBLmK9L6MSJfhg6medbEa+g+i
         OQuxX1UBM8hJuupi+a+smgAN8xUdoC9OfeY8QJR9F4AwtaIfDuHU6VW7p5TgkO5IdrQC
         aNz8dydMhgzq3S7RG/tfcf1YJpXfrf7oeKaY5NZQ4pAy+GgLjnZnyyF0kX/tZ5s4xUEJ
         xFvQ==
X-Gm-Message-State: AOJu0YzGpm90Ubybp2iWP9pnxTrVDn9Uks5PjZGJcKuOFlogNT0xgiZx
	G5LgI05finTDD9Y2UWoV1xic2s2QbuV04IksiLH0C+PiD3PMYGbDzbNiruEsSADbY7M=
X-Gm-Gg: ASbGncudBMuT28LfJRx02QXt6x16FwvnK1QHgdzqCVgZgE0r4ydupemfegbE0AxiTMq
	Tj3F39rjSl+p9I3ARio8RKNKvKKhA6t6TJ8Inr0M2yHSe1jPQcs3NxEWmKfgEEcIp7t55svm7ag
	CTJMWnfMS8KBxF9RWHdcSL0TmAcMw6Qm8bxwtzKsma8CiOtOCT9qrpYqJOOybSAQUXpnd2amJ+E
	iLDL0fMZi2Pe7FPTQc6B7s5wHIirKf0htX4fM4hROnv6+uXWJ1VayFDezh2M73akM6S4uzQIvSD
	qPA+skJ4V2dvAeixjyklEU7e1/9kkQzUDbUpk0CxlKblBnX0Tv/xWcoa13ikY+wG3yBJDi6ksm+
	j9uqIzOdiz7vb1betw/iLa/U=
X-Google-Smtp-Source: AGHT+IHz1Rk9owizgBNMpEzoUrOt7ttoKA9V1V1G94O/ZoRyTiXvcJnp8uvrhDtyDKYa+5j5tkdZBg==
X-Received: by 2002:a05:6000:178d:b0:3a4:da0e:517a with SMTP id ffacd0b85a97d-3a5608135aemr3301284f8f.23.1749737819070;
        Thu, 12 Jun 2025 07:16:59 -0700 (PDT)
Received: from bell.fritz.box (pd95ed419.dip0.t-ipconnect.de. [217.94.212.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a561a3ce6bsm2104297f8f.49.2025.06.12.07.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 07:16:58 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH] x86/emulator64: Extend non-canonical memory access tests with CR2 coverage
Date: Thu, 12 Jun 2025 16:16:37 +0200
Message-Id: <20250612141637.131314-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the non-canonical memory access tests to verify CR2 stays
unchanged.

There's currently a bug in QEMU/TCG that breaks that assumption.

Link: https://gitlab.com/qemu-project/qemu/-/issues/928
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 5d1bb0f06d4f..abef2bda29f1 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -325,16 +325,39 @@ static void test_mmx_movq_mf(uint64_t *mem)
 	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
 }
 
+#define CR2_REF_VALUE	0xdecafbadUL
+
+static void setup_cr2(void)
+{
+	write_cr2(CR2_REF_VALUE);
+}
+
+static void check_cr2(void)
+{
+	unsigned long cr2 = read_cr2();
+
+	if (cr2 == CR2_REF_VALUE) {
+		report(true, "CR2 unchanged");
+	} else {
+		report(false, "CR2 changed from %#lx to %#lx", CR2_REF_VALUE, cr2);
+		setup_cr2();
+	}
+}
+
 static void test_jmp_noncanonical(uint64_t *mem)
 {
+	setup_cr2();
 	*mem = NONCANONICAL;
 	asm volatile (ASM_TRY("1f") "jmp *%0; 1:" : : "m"(*mem));
 	report(exception_vector() == GP_VECTOR,
 	       "jump to non-canonical address");
+	check_cr2();
 }
 
 static void test_reg_noncanonical(void)
 {
+	setup_cr2();
+
 	/* RAX based, should #GP(0) */
 	asm volatile(ASM_TRY("1f") "orq $0, (%[noncanonical]); 1:"
 		     : : [noncanonical]"a"(NONCANONICAL));
@@ -342,6 +365,7 @@ static void test_reg_noncanonical(void)
 	       "non-canonical memory access, should %s(0), got %s(%u)",
 	       exception_mnemonic(GP_VECTOR),
 	       exception_mnemonic(exception_vector()), exception_error_code());
+	check_cr2();
 
 	/* RSP based, should #SS(0) */
 	asm volatile(ASM_TRY("1f") "orq $0, (%%rsp,%[noncanonical],1); 1:"
@@ -350,6 +374,7 @@ static void test_reg_noncanonical(void)
 	       "non-canonical rsp-based access, should %s(0), got %s(%u)",
 	       exception_mnemonic(SS_VECTOR),
 	       exception_mnemonic(exception_vector()), exception_error_code());
+	check_cr2();
 
 	/* RBP based, should #SS(0) */
 	asm volatile(ASM_TRY("1f") "orq $0, (%%rbp,%[noncanonical],1); 1:"
@@ -358,6 +383,7 @@ static void test_reg_noncanonical(void)
 	       "non-canonical rbp-based access, should %s(0), got %s(%u)",
 	       exception_mnemonic(SS_VECTOR),
 	       exception_mnemonic(exception_vector()), exception_error_code());
+	check_cr2();
 }
 
 static void test_movabs(uint64_t *mem)
-- 
2.30.2


