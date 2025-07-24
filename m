Return-Path: <kvm+bounces-53393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D49CAB1116F
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D65571CE302D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869DA2ECEA0;
	Thu, 24 Jul 2025 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="qWWz9y6M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096901EF39F
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384258; cv=none; b=OrHUjoWNI3M+mlDgOKMfWodjCWocZAJ6BCvJXdPeqybfAVEe4+eniOWUButP42Iv7NYv4Oedr2Y0it6DHwWZsRGKyd/TUrB5m4ec/+A4A5d6IlrNQupF6yYND7rm5HL1kXFCkTJwK+EhJMcI8AMn9BbwqVRopvXUvXf+DzU3DZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384258; c=relaxed/simple;
	bh=nbx+z+1/gugYC+DAfFucpGlxr4wMtIRSyTJdNk5rL0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T6IoHcx5DT/UiDLnn2CTe36IWKPHQpML45Di4jlVED3oClinkHEBJZcXGsl4HtwEwNQpL9VOXmgfFQFpqHvu8F7LbX7z9PJcoybYiZt4nYxQYbb8v715fT/BRhCie6Z9SgxwIihJ4cohZUZgue75YTdyLGBepei58K0zksnL6tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=qWWz9y6M; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so14670985e9.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384255; x=1753989055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LK+1VoyMLw8WJX2L4vhct5pIoiz04dcym0yqQANFP4s=;
        b=qWWz9y6MJUqXB/mm0vZTIZeQL8b4i+10YKs/sfLXcBJDZ3zkU9PodVLhPwGrzIQgXd
         kDW7XC2ZZJ6WCphpBwMdpKBzi3GX3pjtIBQB2EHGLAkf719POo184t2jfZliUjGaqNXk
         isZeTIL65flH8mKeSh6Xr8efARApQvtp4Y6gNcw0xAPFwaxNt7EMiZuDM3sr+ZLv3BbT
         HuSImlPhflRjzB1yk8F4AmUgETWkRfegsJL1ZLG+HWZvxf+2I7a7TXNBz8jJ647k/W40
         OjrpEr3NfmzSVCkaEKzaJTyq/TSxd6E4PQPxFnpCj9rk9aAYibzVALcseHRCt/T0i8X6
         eV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384255; x=1753989055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LK+1VoyMLw8WJX2L4vhct5pIoiz04dcym0yqQANFP4s=;
        b=WMOIPmOvtS1kF4DzgKeKOfNf5mklQrtm7fnjjTLqqr6WX7QFaV1RYSkLXh3QUXJQNQ
         R7cJakjg50AIM+vTKXztGzmJXyOvL63HVzl8b4i3leaO+FHAvZ/MhHyAxYSZ7G+MK3yp
         V50x7kfiFVJJicXzkKEu6dWdPSHzx63CFpxCnebwlKa2iPpAGH4SgJJGgA7QCUh5vm1E
         pcCbtIMI5C0Wqcxb7CuSRx3drv5Cnnlgd10/wtxLHH0HRnyCMKygofk8X8xBe7rUA+LB
         ozcu7zPn1LESVuwszbqmvC1pRiNG37eTu3TmFcTfapEgbI72yB39HeE0hnu8AllEPsdk
         5yVw==
X-Forwarded-Encrypted: i=1; AJvYcCWUTmxnA3Pl9O9QDO5WrR0KdFxXh5DAhJectFaz5OT8NeQKeD5e2mZAorivzHjNhlQXoS0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjntx04nJa7jjJeV2El5H7zSgRDsZh/diC7ZBxfkBEuwcNHTTO
	AaBAQBR0nmfKZpP3UUWvEsOQUyHQj+ggkIyDUJUuZ4s9UG0l7PwEN3JEXaQN+LlKDhw=
X-Gm-Gg: ASbGncvVb9OH30nHsE5J8waI2BnnnHwFBaigx8ZneRpdj61nIoMHkjxc4NSWijXUOnL
	UdXXZA0WXWdGX1axsh+ZL3QFuNlU68bZYH0mb2Z2d5ixfZ4Bh+IhdGgdniwR0ZzKLrVy1IBtgG3
	J/W4zLsTLC4E2pEV25tCMrbrdiKP+IssGnB79mlSesVcTSuKSvKu6zvXztWsXIHGEIiEFoZ5o7N
	16Uo77C7f/1M6i+2BcebCQ3OhGMZzD1z2HePrixLNLxA5e09qfwrBeIhigp61co3HxqzHvBiaA9
	nRrq7S8OVRDvY/FZo99yzW4YzMdX7bBXzj3qLJ/kwj4lF8XwxlGjQgtVBpv0lqPQOpt8sA034Xl
	+d4sg10zQhhlOgYakrkI4RKfFH0/w/liliWoXwAbaZhj2Z3s/vaxwlgXyeqF5HS+DJbTX5ucFea
	FMI9pZu3wznu3aFqCT
X-Google-Smtp-Source: AGHT+IGYJ43DT+RTl2jB+3TkJMK6K+1uCA5es/hJnz42gQTbmyyJpwWEghWPQvIt53Y1CsKmdH66mw==
X-Received: by 2002:a05:600c:1c99:b0:456:1611:ce85 with SMTP id 5b1f17b1804b1-45868d47969mr68073925e9.21.1753384255071;
        Thu, 24 Jul 2025 12:10:55 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705378f4sm31118955e9.2.2025.07.24.12.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:10:54 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 2/3] x86: Provide a macro for extable handling
Date: Thu, 24 Jul 2025 21:10:49 +0200
Message-Id: <20250724191050.1988675-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250724191050.1988675-1-minipli@grsecurity.net>
References: <20250724191050.1988675-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a macro to emit exception table entries that can be used in
asm() statements.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/desc.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 68f38f3d7533..21e0ae8dd028 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -150,11 +150,14 @@ typedef struct  __attribute__((packed)) {
 	u16 iomap_base;
 } tss64_t;
 
+#define ASM_EX_ENTRY(src, dst) \
+	".pushsection .data.ex\n\t"			\
+	__ASM_SEL(.long, .quad) src ", " dst "\n\t"	\
+	".popsection \n\t"
+
 #define __ASM_TRY(prefix, catch)				\
 	"movl $0, %%gs:4\n\t"					\
-	".pushsection .data.ex\n\t"				\
-	__ASM_SEL(.long, .quad) " 1111f,  " catch "\n\t"	\
-	".popsection \n\t"					\
+	ASM_EX_ENTRY("1111f", catch)				\
 	prefix "\n\t"						\
 	"1111:"
 
-- 
2.30.2


