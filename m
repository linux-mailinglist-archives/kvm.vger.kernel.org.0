Return-Path: <kvm+bounces-50804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E46AE96E5
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C763F1886EE8
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF8425E452;
	Thu, 26 Jun 2025 07:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="R/4+JYHo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8B25C806
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923315; cv=none; b=eachfmFpYwy1GUFyOV0u07jsZ8VX3FjC2LnZwO2Q4qv5NXn90B/m3wBzM63JByVIV8B3AaD/mjLZjt74IcNkXiBnzx/xMtpuYyzvhMbtTw3HABl8jv/Kw/AImpsjvAvUBfdX0PrM8RsZ9yeM7OpSWGiFXKFQZx9VuxBFGdDbzY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923315; c=relaxed/simple;
	bh=5jHd8bdoUCMJtAeLu+5hEjyzhcgJkgx3OPGG/8ozbVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgC60qNBsRISLpCK2kwDInF5c9cYfLLW8FQNGnrkxdlmLbjB53GIftABjD9f3+Ykvoc3VcJjxORBlZdY290uicoBiKSpJrp37AKgj3CPGcgzEN0KVJEVl4chKHylBKEGvWRbvW0roiYgGSfacjv24IAPNqy+OWxsI3QnMutBxQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=R/4+JYHo; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-450ce671a08so3186235e9.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923312; x=1751528112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0i0x05sqRmHB+C1061iORXD1YqI9VTh0ywuU3oa/ARY=;
        b=R/4+JYHoT18zsghlogQSkkI2ufFLf/jj3EWC62VpbzTSzwSBYruaCPYI3jCblDETfP
         HuuGuMf3pNWioe2OPcBkHF0T0pN8li4xXH2Sbx4pUI7hgw75uJHhpyg4MtXUtb49OxD1
         vsbjssLWaoIsBKvsuIae3B9y1EZb2ZNNvD3rM0ne6skpQwgkkz3qsghCYKTUkYUfBWBN
         5sWZ7+9QVBzm28wf9qAVGjhOb0Inr3aPNxHFgvkuejronrQZ3/+PkavC/oSJSe13YqwY
         XUwHM47EvEnJWqAw0uFi1PgM5fHoTC/bNNKncR0gZKpDwUI688YuvwX+JCk1YxOCgn/Q
         wiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923312; x=1751528112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0i0x05sqRmHB+C1061iORXD1YqI9VTh0ywuU3oa/ARY=;
        b=KAoEOp2GXxRrba6roVlJdKOXOgKaiOdh+UOTn8UU4NtYEfY3CXCSGTrxSiFsyhbXR8
         Rmy3CZrXyOrq6p2Gk/6zWwL0jf72sIBSREa3hY3GK7l2DDMLvDqIQ0hbiH5AG+anul48
         0aSY/7CpLM9bbTvAm4k8isMtXzq8Z2ZsKm2wwTvOgYgQhFvaKYOtIofknvCGT+LctAYC
         nd20vyKWKqvmLvvmp0M6nHrTyFzOJSq4B7FrUYCEtRpeIlkJ/Lhuv5GdegrKEJ2qmvzF
         2JBbWjBLBkTvw/axbisAQzheLzIBfbLnHSebpr0yT4EhC3GCyvywUP9wRBQo385rVwpw
         04KA==
X-Forwarded-Encrypted: i=1; AJvYcCV8xWU2I4YE8F8qv2ZlLEmBfzGeMYug9HuiCbaWprEmRQCkp1QdkauAZEQtsz7hBhZnqEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz81Z2eq+lMTD3xQSfE5QovNxrWUFkbdF5ZS60L5gnkLf4mRJyQ
	QZW69pTlEwbqBI91E7E745pTs8JbPn3mMrA4V5ydhtd5hWdkUb9Z4NjBOyvUvSBX/+drdax7CsM
	NmRik
X-Gm-Gg: ASbGnctTWPienRHue8liDdQelQ7J9Xc693Ck+CpSV1cmowMPGwkbA5GkWD9CQPpqfrA
	XJkvrso9VvSXw/wPvSST5PEotB3WwBwJytTpCqPcPAbdFSJ0MoHRpBTUZcZR+eTP2gg8znrGwnL
	8fcWSpgnBSrslft1ktbMQKvdSkZIC7p9HW6pkbYA7krx/GeiQ+PFUETMSgG9Hk4nc5CepXcLRAP
	LTgRfsqSvPAzuKEV4ssIzUu4g9yWSg1bM9dFSW5AUiSC+7LeuX7l+z18WGPM/epfD3vDMY2vxg7
	DKPBIdxQUw1JSp1WdBJHbZAaV01ifZShHUvGmL4mYx4H2YF6usEJuprX5cEG5aIT4kEe2mi84ht
	3YKxykgRoWT5HLvKXNOhHoq2jB7pGp5coUqlJxtT/8Myjyk9jv8zhCi0=
X-Google-Smtp-Source: AGHT+IEXDZf1PzmC1u2n0NGgJtcrc/O+wKeiGMT0Uy8owvTfn7eYrW10mY3o2ysH+NGZpCCbtbDBRw==
X-Received: by 2002:a05:6000:2888:b0:3a3:7387:3078 with SMTP id ffacd0b85a97d-3a6ed61a604mr4514738f8f.4.1750923312049;
        Thu, 26 Jun 2025 00:35:12 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:11 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 11/13] x86: cet: Use symbolic values for the #CP error codes
Date: Thu, 26 Jun 2025 09:34:57 +0200
Message-ID: <20250626073459.12990-12-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use symbolic names for the #CP exception error codes.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index dfc2484cba5d..dbaecc7d74d7 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -47,6 +47,13 @@ static uint64_t cet_ibt_func(void)
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
 
@@ -87,15 +94,17 @@ int main(int ac, char **av)
 	/* Enable CET master control bit in CR4. */
 	write_cr4(read_cr4() | X86_CR4_CET);
 
-	printf("Unit test for CET user mode...\n");
+	printf("Unit tests for CET user mode...\n");
 	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
+	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
+	       "NEAR RET shadow-stack protection test");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
+	report(rvc && exception_error_code() == CP_ERR_ENDBR,
+	       "Indirect-branch tracking test");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.47.2


