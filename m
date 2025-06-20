Return-Path: <kvm+bounces-50108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5011FAE1F00
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 728FA189DAC1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A102DFF33;
	Fri, 20 Jun 2025 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="DmWKsfKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697F283FE1
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433963; cv=none; b=gyoYoYc7WziLhvVPB8MS0MNKeRz/P2xjryPeETV9lClbQwvKx8DBhLFbNYaf9JEcQw7hUBcfWbYLH0Kkrme1eeLXD728CivZn0kxrPaibfFCLqaqIR8yM2RNYxXoA5XsYaRJ1EMjsV96bRGcstg2qHatLQRgkzFFlcOro4IsN1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433963; c=relaxed/simple;
	bh=Mn59SK3Tl5PdzlRi75S+lU7ZXf51b4jlQEQV+amE91I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOdUhURsc75cYOdYqXt5mkqbYj3ErilisV/ccmQw6XsGUzRdQWb2vW7Ybp+cZLf4Sr+4+rQumSGLbz8JsC4EIkpCH0WvZ8wP77aXX/8X+xT4wKHNz+9j/NrDoa26Fojzuk/wb0KkAgpEGJGUIuB2I5aT8AUysyU2j8s6ze788lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=DmWKsfKJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-451d6ade159so16113765e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433960; x=1751038760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QExsDJQX2Gfu3HozTv58QYoR9KdVkhc0P6uwZQdEKpk=;
        b=DmWKsfKJIRo0cEI8XgQJXoDOZBw0MneM/3uvI94KLn0BAzmOGKCQQXsROeuqKrt3o/
         t2aHDyp7D/n2Gh5pwgPe+ttXpCf6uNmhroUFmlj70HGKCEqRupPGSZd/oCvPzKlXKrIx
         g80iT12lNFATOoE1sOQV98/4xMwdsmwU9FCYRPmzTiOU/zFzqkKWq8sMnX063vrb8K6R
         XoRA0eRE5vgajAsjZiR2N9kiLgMojFdE6jgSdroRJDYxJEY0ja5YJ075JfbqYU7v6OpN
         pguvrOYx0pomkLHBYGzo+P88FUsQ5Rn0nrHW4yqj4S7X4Rj7lxU0hQlsLJNIM6/hakKf
         inew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433960; x=1751038760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QExsDJQX2Gfu3HozTv58QYoR9KdVkhc0P6uwZQdEKpk=;
        b=RgfX4YDnHm/HZwRL/teCa+LD/0LrIP3az5kx3QxgsIKgaqJyETOWIJGSgAqbhcMsHr
         zC7Xz+GVshlG26RFcfuEFOKSeKTtxFZ4B5c5JM7HOb1ulnxU+HAVwakhdzfrL+HvCfit
         Qekc1syLYduiki7AmZ8ZwMdMLRG7dYdQE+d3NBtNavjhRrk3ybdQ3xHT6mTlwQoVSPD0
         Jhn4562Z4u9q1SWvrUpUDQUN+MDlENbaGg/WAa0C4W0xrQExH+TMUYOaCAVtSEOGU0zm
         M4yyqsjyjBob4RdQlKE5GrpsWFTjMGuSlL9ZbOxnySSRSEJtBxUrespSp5TqFCXspIsU
         NW1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUM4byqZt/C3zMRTA2DiE7fT+mExLfIC6EgC5I6zDK4imJB6etPd/QFmoZYZaUUkdgVZ6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YykKX8zCFsITlCExRoY0SIHoBDIHzZDVD+UjwbvM1N2FCe1DRQP
	uCnfQ/+pIDAK/8fAJjXMP9fjjix8XJjIK+cnGVaxx4xvRDkN7PwYZSWaJcXImTguVDo=
X-Gm-Gg: ASbGncvFxUDwZlyzPxWa7dAYAuwFJQGZOqs0l2PIgI8l/T9GbUtNkAB7aWSJj8SxG9W
	VRMiIy9dXDKK662KbGv6te46BCEaMNT9OFAtA7Rv4Qs08qZJYySw4vjVJ4AcAQCZZYnkHLt1Sjl
	F/HGnLMYSeyM7lU1plwZQ2aQvoYi0OjnX968lvr1Di49xlL6N9OGe25MdCQWhRQCihOZH7LJK1u
	xjc6oxOTSklIRcbF/wY1NgUhFy/LH75wcvjFtxtR6o97CdWYkjoFrOCopQEDyvFN7owOadWgxPZ
	WfGD9iZ5Ovw1zrQIKPQi5zJf5XI8y2mf/89pgYat7i7J/u2QwjDhaaEvcHsxhZmCdW3G5WK0zqD
	loeThBRpa9ZXNZsRRmQcVCVwz1Hk25G3+MwEc+gNu5ySuS12JM5WuZw0=
X-Google-Smtp-Source: AGHT+IHEC1O8qepP+dMoQL4xXDNxkwrwvqeJJrdSQJMJBlSBVjp41NCDBJxcgrTBgt6+iWGhzSES9w==
X-Received: by 2002:a05:600c:548a:b0:442:e03b:589d with SMTP id 5b1f17b1804b1-453656c2b8emr33242425e9.24.1750433959582;
        Fri, 20 Jun 2025 08:39:19 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:19 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 4/8] x86/cet: Make shadow stack less fragile
Date: Fri, 20 Jun 2025 17:39:08 +0200
Message-ID: <20250620153912.214600-5-minipli@grsecurity.net>
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

The CET shadow stack test has certain assumptions about the code, namely
that it was compiled with frame pointers enabled and the return address
won't be 0xdeaddead.

Make the code less fragile by actually lifting these assumptions to (1)
explicitly mention the dependency to the frame pointer by making us of
__builtin_frame_address(0) and (2) modify the return address by toggling
bits instead of writing a fixed value. Also ensure that write will
actually be generated by the compiler by making it a 'volatile' write.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 83371240018a..8bfa1e057112 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -13,14 +13,14 @@ static unsigned long invalid_offset = NONCANONICAL;
 
 static u64 cet_shstk_func(void)
 {
-	unsigned long *ret_addr, *ssp;
+	unsigned long *ret_addr = __builtin_frame_address(0) + sizeof(void *);
+	unsigned long *ssp;
 
 	/* rdsspq %rax */
 	asm volatile (".byte 0xf3, 0x48, 0x0f, 0x1e, 0xc8" : "=a"(ssp));
 
-	asm("movq %%rbp,%0" : "=r"(ret_addr));
 	printf("The return-address in shadow-stack = 0x%lx, in normal stack = 0x%lx\n",
-	       *ssp, *(ret_addr + 1));
+	       *ssp, *ret_addr);
 
 	/*
 	 * In below line, it modifies the return address, it'll trigger #CP
@@ -29,7 +29,7 @@ static u64 cet_shstk_func(void)
 	 * when HW detects the violation.
 	 */
 	printf("Try to temper the return-address, this causes #CP on returning...\n");
-	*(ret_addr + 1) = 0xdeaddead;
+	*(volatile unsigned long *)ret_addr ^= 0xdeaddead;
 
 	return 0;
 }
-- 
2.47.2


