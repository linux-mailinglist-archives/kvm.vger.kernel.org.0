Return-Path: <kvm+bounces-50109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4509AE1F01
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19CB5189E2C0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85A0283FE1;
	Fri, 20 Jun 2025 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="pCD4SngJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6C92D5414
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433963; cv=none; b=HfpowQX7MTyiwSwd5LhbBi5uNI/V8nN6dLXRUyFtgavQDAqXIhv6YRHEbEQhlI9CZHeOXvSpqtk2lxzOKEetNt5x7BDYKEEk7HAIT7NDetOFLdKcNFQSnZnsOgaE9WXSUoCn6Z1Nsmh7nS/snNiBO7hgwR//h3F0FPSd17p6Ofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433963; c=relaxed/simple;
	bh=aDZ0OPcJIHCZ2JRZ0SBXGUOswXOi243CaZVpDow7HeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvl+6ZZWzplleNOmklpXLMZ/+JOeAVq/T3PPEcCxQhiYqy1kdywNSAyjiR0/Egvz3752vVm3T8IjlwIlUgyayJ29tq8xtxbq7dlIRUCWn4lnKUhK2fN2Ur+kH1kVXacXkScRFFmskIF2db8u6gScxBhw/1Q+XfYHnNDyXLRfWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=pCD4SngJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a6cdc27438so1689596f8f.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433960; x=1751038760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jkq4LQnr+Y2/EJEvbFvT4V6WjMr6/3PTsCxXFVap2yU=;
        b=pCD4SngJaQt4lQZS+Tdht0wndnNifqrHAezWv0WbuYav8PYRdtb12w3x8fMatOwvG9
         v2KIrbQmQyzyuTzpvt29wEmN+QR230ql7difwDNeqAo/TKHzQtmkDCxqm7OIh7CpZhda
         +RZSaTyH/u+Ml68YicyMmFmIiEOWvLIf3GXZQDCXCuN1TWjfZFZUzkzzptrB+uz8z3gB
         K2KMJ12gOERUu3DmYTBFZTmeINBhtCy2vy6AiO3jyVJscjiDHIHIWHH6SbzinCuiMle6
         1eVZnMpVZmLFBY/J+nWw/lmxwBobn9do18Smbr3qthK1Vhv7ggJBkoShbyN/79r+L4vx
         7Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433960; x=1751038760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jkq4LQnr+Y2/EJEvbFvT4V6WjMr6/3PTsCxXFVap2yU=;
        b=BhlRrK9NMuDl4osPtBeKxrDaMFTpZLbLq5oGWjfdV2iB4QXNiPo6E/cnX0bU1/2MkM
         Q4fHoJtLDvFamtDdWBXw6dTFRlI2pVRxgVFTh4OFDhj6xzuN/pSIlpWlxhx2BrvVUJrw
         PeXt8+/eGydsdpWQfVO+tvPvr6TgjOyS+1AxemCnQ6kvUwEAW8u/tW9LaRMMfShL0WoO
         pgBoUi6EWOkH5c8NerPG4C8Q4pYGMgfn/InPYdsOhk/0m4ZqTCFUhkQXH0QuaIBROBAE
         3NaCtTgPgg6uzK7h52VSaHW0Q0sJ5DygHNzJiNBxXETUcEMfFawV+oD2KHDM2kbUyM9R
         Vztg==
X-Forwarded-Encrypted: i=1; AJvYcCXdKI2p5hkTfaoraGPmHg+iszetFLVdgKbJFgsJO5EctUDpK9dUhps8pSqUJGs5cog48yE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKrnZkrd3ec1YtRZGgRbdwTjF+Ji0KlD+SEECTz08vFLGE+zMz
	3DHuLGBju6BOLO6IjUXG3PJvSN/yQwJUOgiVfPY8ZVJiopPu8Y1sxXY0HLx6Zpe6X+Q=
X-Gm-Gg: ASbGncu715F+Ax4/iA/QQs+sk3a0d/KYV50D106UqZQqil0Fl09xMy7fQmBGny+ZRBz
	dSUp2rqn2iGQ7yEgUbAzg3HtCquVb8h4fbhvK3hKMDZrPMBzuD0nRvjuRAyx+vdG/9E215TTlFX
	ShljlsOUAf8IgnM2hIjY6MvEbu588uQtXNTYcikqPJq1PxUGoU5j2n29bN1R0v09Ucg0xgL3/Nm
	hvlz9yZAdQmnEkO7WTknt1qmpM54i/fWIqbu84rEK/BGVVCP7u+s4CzKU77xr5NDOple1Y7FG4v
	omcFM6e29KmVkJk19j9Gx+2tD0WW4xT2lVT3bfHTC6zzNKD/RxcMUd9lrqbCbCvyKp8Pz0JNIqO
	aXWpH0KKRZ6l+OJgv0aNqeRTlm2nF/hrQ1p/GgnlB26msFmX3s8h16HQ=
X-Google-Smtp-Source: AGHT+IFCaMbKr101A3MiCdt2nxYT/Ig8s46p9qEFAFn9DuIRbRir5h/IBkhq46Hsv3+42GUsc0kvFA==
X-Received: by 2002:a05:6000:2282:b0:3a4:d79a:35a6 with SMTP id ffacd0b85a97d-3a6d12e34b9mr3364390f8f.14.1750433960467;
        Fri, 20 Jun 2025 08:39:20 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:20 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 5/8] x86/cet: Avoid unnecessary function pointer casts
Date: Fri, 20 Jun 2025 17:39:09 +0200
Message-ID: <20250620153912.214600-6-minipli@grsecurity.net>
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

Change the types of cet_shstk_func() and cet_ibt_func() to align with
what run_in_user() expects instead of casting them to a non-matching
type.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 8bfa1e057112..fbfcf7d1ab23 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -11,7 +11,7 @@
 static int cp_count;
 static unsigned long invalid_offset = NONCANONICAL;
 
-static u64 cet_shstk_func(void)
+static uint64_t cet_shstk_func(void)
 {
 	unsigned long *ret_addr = __builtin_frame_address(0) + sizeof(void *);
 	unsigned long *ssp;
@@ -34,7 +34,7 @@ static u64 cet_shstk_func(void)
 	return 0;
 }
 
-static u64 cet_ibt_func(void)
+static uint64_t cet_ibt_func(void)
 {
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
@@ -112,14 +112,14 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
 	cp_count = 0;
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.47.2


