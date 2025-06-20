Return-Path: <kvm+bounces-50111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3765AAE1EE2
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DF43163E71
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3A92DFA2D;
	Fri, 20 Jun 2025 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="OmJBpI30"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7F82DFF22
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433965; cv=none; b=ZOFEY+wjZRkCHC/B0bLJQUYiFw+DasUJQ7bQMVHnVpfHZMc/+NqJrn5mu2k1x2kqT+wfU9OTBxdSgqCi4jwl/AR23iVkq3nAHzHe8rj9Ht/jezHrtpAa0/v+zh0YnX2403ucrdDgGr204RX77AMtu/GlUpXZaIyV/P821h0J36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433965; c=relaxed/simple;
	bh=3UBTrMkmqmE7v/N1K4ZX1jlgstDA9UKQBzzgQ96bzLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYb1Iaw/SmbkQd7ntZyWu7xKPfB0DzVn32zpT4tUqZ/9cMqjNJcFB+azW7TsbB5npksT2wAfwXSOB3aoZB7Toi4Y3axm6P78sN7OAGLdw2FUnVoS3VaS0iE9E55VCMXFWUr73bJxIZi1mSMH8/j+3mAtKC0KD7GxW85pILoE6Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=OmJBpI30; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a589d99963so1985890f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433962; x=1751038762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2oYkJkNkSrTQXtr7rMIM+C3jXsevJlDlNxhnjbjLSU=;
        b=OmJBpI30YIqZo/jje2n1QxN+ZB0fMezr8zRv7ad/MTG6S/MZn6WinbVGkT1aiC4wku
         0di0COxoSwDs256Y/B0f7NkmslBuBmYkHjtgPubTM6PUR7sD43Hsg7AVC/vBduX1Tlyv
         mjUt5IsFhYiSIwZeu3U0m+4xnUg0ZhFwB19tdyCw6h7l3lP7CiPOhIxVFZ5rkjMQi+gu
         RNlRvVCGpOkAUDS2+SC+U39U4zXn2/yZ4IfjG3PDhiq8jAoXk9bzCaHQVP7CjSDnHHRA
         HnDA+OqYYY9Bk8ogGg3fUAjaNu9rcvZrYy83cfL79LAvoqbhu/xNdzoy6sIy4hCRiaTJ
         W/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433962; x=1751038762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2oYkJkNkSrTQXtr7rMIM+C3jXsevJlDlNxhnjbjLSU=;
        b=GThkkdie3ilHjf81g5mMqNk/9enHt5xj6L6cP76Wb2/AOyWoiq5iKyafcwbW0dhFgT
         JJ7cRJcAUmb8MzCTFfoLlYKLvLqK/XOaOoxb9L68u2JDomMEBJgzylL4tZVw1L5i58I1
         jmejvukeG4f9DYawXUVkDxApSNHZC3c8YKSVVvQ3jPOIQK6fxZrj9c1C/FV1ohDnUsGW
         q4iHt7LeUHBWq8KcgdRNr/iQaml9n9HIccTqqSn8kV0hJO2+/pLvKDZ7Zkrcm5jauLQ0
         GaaoC/rFb61Yc07j6qizniVOXXPyks8b6O2CgCtr/P+/Gqjbg0LT+zI77RdqCX1rzxjT
         NDTw==
X-Forwarded-Encrypted: i=1; AJvYcCXAMXmJMXKFsZB/lGnG2GEsN++XNfHlV2eKNXlxwBtxxNwJj/rx1nD1HjNoOxAi5CZUb5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YziXz/V5WQqWlN5RYe4OazrmcyFSZIwwwikrKLDyuwowxTHXfpu
	dnbqB53LMQZscZhUv1Gz4vBGmN6Qrv6zZV+Q04Og2OvQKiFf460rerpfL79AbGmyFgq0CiR9bed
	CCo2zMr0=
X-Gm-Gg: ASbGncuHrcyJB56DhVuC538bHA7SpFHSo6TmoKslKAftBSQhR2uNdEh2SVXOJz5czLb
	RHZpDz0YirNwrYAdnT14+PH4EvsQ0W3H0vefqGfMwbaKYQHzS6/5hsGUvwWVtEo4YBhHYbzHPgl
	wwV44S7IWSdmS1HX5emyO4PWFY9fNnSnwXK5zqZ4ftyRCQjAV19E4teR1c5h+wn663WDpdqHY4o
	/hiD7CxgrD/RMVx6vpGwKA4crI92y7zIOWaXXFng0dM6VP1ybi5dla+uHGuKYYBntTwBY5+JkhS
	4/y20A+KrGgC7nHZqaGtlB8+gEzSPzGyFduhJgesWOW2g24O3gbH6h+KhEh5YaZ/bNQMC7Lqu/p
	AI76VnSD+NruB7nIpZUq3XzAArfS1hLreYf8IABeUsFqTjqXE/BRfNao=
X-Google-Smtp-Source: AGHT+IH5VA/L/sP6UDTUfcMTRtZCMpxp9Hp+5EdD77ygy6OG9Je/ImrU0eG9mhu/Y+KVXTi2z4xGzw==
X-Received: by 2002:a05:6000:3112:b0:3a3:6595:9209 with SMTP id ffacd0b85a97d-3a6d12de9bemr2939865f8f.36.1750433962428;
        Fri, 20 Jun 2025 08:39:22 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:22 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 7/8] x86/cet: Track and verify #CP error code
Date: Fri, 20 Jun 2025 17:39:11 +0200
Message-ID: <20250620153912.214600-8-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that the #CP error code matches what we expect.

Also shorten the reported test summary to omit the test status (it'll be
prepended by report()) and just output what was tested.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index b41443c1e67d..c99458af2eab 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -9,6 +9,7 @@
 #include "fault_test.h"
 
 static int cp_count;
+static unsigned long cp_err;
 static unsigned long invalid_offset = NONCANONICAL;
 
 static uint64_t cet_shstk_func(void)
@@ -50,12 +51,20 @@ static uint64_t cet_ibt_func(void)
 	return 0;
 }
 
+#define CP_ERR_NEAR_RET	0x0001
+#define CP_ERR_FAR_RET	0x0002
+#define CP_ERR_ENDBR	0x0003
+#define CP_ERR_RSTORSSP	0x0004
+#define CP_ERR_SETSSBSY	0x0005
+#define CP_ERR_ENCL		BIT(15)
+
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
 static void handle_cp(struct ex_regs *regs)
 {
 	cp_count++;
+	cp_err = regs->error_code;
 	printf("In #CP exception handler, error_code = 0x%lx\n",
 		regs->error_code);
 	/* Below jmp is expected to trigger #GP */
@@ -110,16 +119,18 @@ int main(int ac, char **av)
 	/* Enable CET master control bit in CR4. */
 	write_cr4(read_cr4() | X86_CR4_CET);
 
-	printf("Unit test for CET user mode...\n");
+	printf("Unit tests for CET user mode...\n");
 	run_in_user(cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
+	report(cp_count == 1 && cp_err == CP_ERR_NEAR_RET,
+	       "NEAR RET shadow-stack protection test");
 	cp_count = 0;
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user(cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
+	report(cp_count == 1 && cp_err == CP_ERR_ENDBR,
+	       "Indirect-branch tracking test");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.47.2


