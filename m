Return-Path: <kvm+bounces-21708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EF09326E3
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF0C61F21712
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D965819AD5B;
	Tue, 16 Jul 2024 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="JWE1B26Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE819AA7C
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134262; cv=none; b=AAM/XIWdGDIeEywehzJt2VcTbG0MAgLN1qTQ+dBR+56P1p6SQCk+R4iTySQM/QCDLfvLIy9zY5swC5HytQwQIgHHr2r5w9HXVgHoVAug3oAval+QTciHR7K4Z0ppd7yYin8/8iCuXL1hiy0kj1L3sqe8rOnqgD86uO7LGTqHar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134262; c=relaxed/simple;
	bh=9lTDVpADOLYai7PoYQ9Q1hRn+SGfy2DohTXDydo8Rjo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WJ7XjvKhDSjlam9KqcgQamOF8AYPxyT57jz3xYjofEQAMhD0lQFQ/WnZJaCGqaXy1cX15tVewjPtN2MB22Dht6QFmkBWnMu0aD+ExxxahCD0mKnKYNOeQ9ACgOgcuHF2q9W0o1964NfOU8/uKLR7ey6slmUXV3qdYrTCubvycMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=JWE1B26Q; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fb3cf78fa6so33595835ad.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721134260; x=1721739060; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjSJhOxndUTwoLpjqK0yxNqbOlPYxQqUKSKd9L15YsQ=;
        b=JWE1B26QZBIkLAgnge33IW+l/Y+9wpPfahyD9GWcPrYSQU+N69U59+DHRrDO6Zn6fo
         jLO/LjCTTqOhCDFOlYMjRuiStJSe+DUZCwQcNqpjF41wzE5Hd7NHqZ311eHGtzz2r7vk
         2NGegRlG/rnRsDn7N2SraZZIx1JXSwlxeI1ki28pWELf0l1NCtjAWXzqfvP259QexwPk
         Og4uv7rqOnt2aCi7WLEP99Q3F5U4s9IgWIhMcKTaikCO1g3VsYLfX0BVzXUbi7C97JEa
         qMo8kevwYKifqPACn1q4FAp3xim0JCGFTyJ8AjlNWhSHCiHMcfFD00dK+Z2jYb+0ON24
         J3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134260; x=1721739060;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjSJhOxndUTwoLpjqK0yxNqbOlPYxQqUKSKd9L15YsQ=;
        b=METG7XrNQaIajXWKYiVsSTiU9TodFGx7pfZuyF35q67Tp1r4ohdGtrp/fNWMqz9Yh0
         mvRaCqzD+fRGChD0ZQlL5QxHRtLsnCtBqh1p41wZLiG01mruRT6ac7tWwaZ1AfWTT1mV
         m8l9/yCDVT8DB4eq2Iaj7K1quw+NTptXP5rnEJVx9VFyNMdIEnnYvqOXDl6Mh3QRQ54h
         nuB8UNPWOi9NX7hsQfMLpIZ+cWfWs9wF4ZlFBNQkIl8MiJ2ex6mOJ3Gu1aMTFxIY2dmo
         0WJa91exP2iPA+VlZ+VzZkcU1tHZSbplAPitL4bVp7CXYSj5m3m/wwWvySD6uMf50Fxm
         dAXg==
X-Forwarded-Encrypted: i=1; AJvYcCXfHyEG8+Xb6gP0ceuGYQw3UhSCvjb07djwnecmyMPxzsI6jRfSQug3ifSyL4MyFMrr79KJFnU7omPVvKy4k+xKQDuQ
X-Gm-Message-State: AOJu0Yzf5rTZcUYYG9CjOnC1ZWm6ir2g1sqjC+ufBmFrFCCMiTD8LTpb
	Ts662fduahGCf3xbO8B2Ze1J2CB2tbHzXRm0NzSdUU1rj/TIkDG9qxSMdboTzMs=
X-Google-Smtp-Source: AGHT+IGgcKegqUs568FNJ+2uzBaWczfapraF6MVhNCtN2VRAYUITEj5Hc21cmEbXS/e5G1SoNrN+kA==
X-Received: by 2002:a17:902:d2ce:b0:1fb:67f4:1b72 with SMTP id d9443c01a7336-1fc3d9c526fmr13149915ad.54.1721134259665;
        Tue, 16 Jul 2024 05:50:59 -0700 (PDT)
Received: from localhost ([157.82.202.230])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0bc273b3sm57465755ad.130.2024.07.16.05.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 05:50:59 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 21:50:33 +0900
Subject: [PATCH v3 4/5] hvf: arm: Do not advance PC when raising an
 exception
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v3-4-8c7c1858a227@daynix.com>
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

hvf did not advance PC when raising an exception for most unhandled
system registers, but it mistakenly advanced PC when raising an
exception for GICv3 registers.

Fixes: a2260983c655 ("hvf: arm: Add support for GICv3")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/hvf/hvf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index ef9bc42738d0..eb090e67a2f8 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1278,6 +1278,7 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
         /* Call the TCG sysreg handler. This is only safe for GICv3 regs. */
         if (!hvf_sysreg_read_cp(cpu, reg, &val)) {
             hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+            return 1;
         }
         break;
     case SYSREG_DBGBVR0_EL1:

-- 
2.45.2


