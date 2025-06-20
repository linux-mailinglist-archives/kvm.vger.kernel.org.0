Return-Path: <kvm+bounces-50110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDD2AE1F04
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D5DA188B729
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55E32E54B4;
	Fri, 20 Jun 2025 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="XLz5T/tG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126D2DFA2D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433965; cv=none; b=WSy+eDsVJWNlxzKybsFo4/giWvxsnrkRVzRG0pjBD/g4g/q45qrENY3c5ubfLPj5d6ZJjggDLZA/26drYE0bbg9wJVOfe/BFTA/KgNAL+HFeuQQhTeXuG5HriP8WpNeEapqLgE5ijD+O6kRtNmcItJ/CxJodERLcD3GGE/45Jko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433965; c=relaxed/simple;
	bh=kWOw11gIE9ntCMj/14rpfK2lPx/8UZ/2J+nftwmEwQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmoSy8u66sCojttLY8Gvkd/XbftpLJfCfu+fYT5JVfzEg02h8cDojzrkkIO1tGWHiasKy2yyOJS06f+3fsraiFoppTfCsdyStztugTDLq3D40ZMXwiH84NnUsByVj/Rdcdu2Vzetw4DtmfNininAEqPL2Da5OKt9T+X1quSuons=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=XLz5T/tG; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso1733616f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433961; x=1751038761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNkcWfBc4CyOuGzqbji6ASRhc6/CP+IwMFuuIDZWKuc=;
        b=XLz5T/tG9iM2inu+evuO8P0wKTHnjEg58kzqtg67M1/qd4CEwuRQ/H9pndRyt7F/4m
         2dRAW1s9AKxsGAQstFlVdBMDWjb0XMIequLDxHWrC60b6lzqTJL4JReBdwvgdIPniiGt
         B4gLtEYITnmErNd/WsRSCSDPUFryax3Qa8UIDld1MY/ns7h5lYVZIvVodvB7GwFj4Xg5
         Cc8km1pd1+FpWgxy6+MS1c1V3G3pC38eEqvKjc6yZ0F8CRGq+zpEZGZ3khVa7vIudK3V
         PLdAQpOWmuvCEbqNsfDqz2cRwTzJBkUpgNsw7bbd/1CMuEpVu6NseH3yIgHPX0mfjx2u
         4LCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433961; x=1751038761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNkcWfBc4CyOuGzqbji6ASRhc6/CP+IwMFuuIDZWKuc=;
        b=Ixhxu7vB1bz3SefTHswAkhFu9nQxcN2wHJ8p3cZMtT7IdlZg3r3YXvPnT3hTeYZHmd
         c9MaD5kZWLtFrMbI8X/l6dYsFkN1ttrpU4yUExOTEI0Im5RXnxr0Y+w7lxuAPqgNni+J
         rkf/HLmxwP8VzsvmW01+5pYEVIewbwE4o7d2mR5U35O4k7U7I3Vt1Qkt5HESkesXQrfr
         nQkyDm151J1WBJbw3QE3dCJZ19MhNmzaMxOQagzzkScaEWzKXmH1hZtONEMxsXmrIQYI
         hbGyUKk7YUKwrQKgcujjj4U6JTemzwaek+PgleG/1MAMbZdx7RmMKrH4st0zEFd3MSIN
         DwPA==
X-Forwarded-Encrypted: i=1; AJvYcCXp0uZukM9U8nSxxeQ+lYxgEJ9ybAG3873inxDf+eEe/+23xOkCER5m7QYr+iN36sMyfig=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRNi3rBDnM15Qpl99AJYbEWAljOQN459J86mW80snyOIXf3Abn
	XVUsHLuVy2/zzHq0l1w4fxUMWO1FX1XHtYHkedlRe6/Gf4fXWiw4ZiKj+uSaCjWiZK8=
X-Gm-Gg: ASbGncuAfyR/xGsxZvg+QSQMA+5SZR9ylk6ajGYgfrQ3pCV+JUmHszZgkdhvCtcZjVh
	bBQMKnkY6HDENYG9NILpmyo4qHh2wdnU9bBm+klCuBiQ62SsU1SzvcPEaxCBrUTvBZMdfZfi6sF
	WIvDd//G5XIu7zidmIYBmV2Ph2gBw17KdIdLagalRTD5u6pQZONU/SV+WT57VC8erMx6dj31gO+
	hkSn1NZ3pZq5wknzQC0FUQX901IFpIukxn2ogofAPEUpDDZeyBxI3ly0vRpB5o1oya7tEFOHxOv
	aZxF+YvDTfUZ4cdk++h52qq9W021oX7dZyo6Jm7DBcyb2DEpqFFBYLDUVJgqJ0owBUmCpNumuOR
	8OPSpu+Ar+Hgqh4KB9ZRfSyg2uEjO1mzKJ9lD8F5mshU54/BgKhi4COw=
X-Google-Smtp-Source: AGHT+IFIPyrMn8TFc5WnTE5r3GgYrJxLExAgwWQYIKTqSjQrYeqwwNL8+Uht9aG1A63Npfrif6dUhw==
X-Received: by 2002:a05:6000:288d:b0:3a4:e706:530f with SMTP id ffacd0b85a97d-3a6d1325008mr2481408f8f.42.1750433961421;
        Fri, 20 Jun 2025 08:39:21 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:21 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 6/8] x86/cet: Simplify IBT test
Date: Fri, 20 Jun 2025 17:39:10 +0200
Message-ID: <20250620153912.214600-7-minipli@grsecurity.net>
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

The inline assembly of cet_ibt_func() does unnecessary things and
doesn't mention the clobbered registers.

Fix that by reducing the code to what's needed (an indirect jump to a
target lacking the ENDBR instruction) and passing and output register
variable for it.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index fbfcf7d1ab23..b41443c1e67d 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -36,18 +36,17 @@ static uint64_t cet_shstk_func(void)
 
 static uint64_t cet_ibt_func(void)
 {
+	unsigned long tmp;
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
 	 * is terminated when HW detects the violation.
 	 */
 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
-	asm volatile ("movq $2, %rcx\n"
-		      "dec %rcx\n"
-		      "leaq 2f(%rip), %rax\n"
-		      "jmp *%rax \n"
-		      "2:\n"
-		      "dec %rcx\n");
+	asm volatile ("leaq 2f(%%rip), %0\n\t"
+		      "jmpq *%0\n\t"
+		      "2:"
+		      : "=r"(tmp));
 	return 0;
 }
 
-- 
2.47.2


