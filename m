Return-Path: <kvm+bounces-53394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CBAB11170
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B2CA1CE31FA
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFD3274665;
	Thu, 24 Jul 2025 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="tSf4rD1C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8DF2749ED
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384259; cv=none; b=NspifLLUULuSTralxPvclDHtTsSyryEOMCZ7tMrvab11NBDlFvc33yZe9aq5CTPPjMG+uws5B0MPyKWzQ6N22HjvjAETjoo4P/ZXPfrjuesaP3lO3Yj0BBnap31ooCqeh4MWrpdcCQ2dF1xq4DHBUieAGvjpv5klkuO8jpp0c/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384259; c=relaxed/simple;
	bh=TnKyugg3aHCLKASbC7uRBVNyGqezl2FfvfwrnPV7K+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U37lnj/Ik4RqABBMbasWsBtLOH1+SDIOcGIq05TjTiYazO5FS51oGgxFojPRrXq76zmLe2e6crH6iaFdfC2ee5hn1mc/kVSmmoP7zGnbOiQFqv5Z0PtDh/fHLhkWYXhhNGCky8gcUT7NL/idW7x5fE38voLjhb3TeUGKzoSX7UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=tSf4rD1C; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4560d176f97so15811675e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384254; x=1753989054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpuFWM4vZR08GQA+aL/b+0xC8CNAYIhegIrtM5ITN8I=;
        b=tSf4rD1CJQzRnBfQGG+ds9bEZueem3cbZ36io8UhmJui4EPX/GlHhvE64TikNgbRtN
         pOliY6Aid/fdB5D22iOP5mGuhDF2SZHilS3BmfVvtmMdYhgBrd6FcgqbMwlja1hoJ8qf
         +IjhqcqLkyFa5pNMLH+4C1bv8VKynMttQW4N7bEkauF46vpaF9UmodW3rAkLFcMSGQQO
         SnnEW4yh8rm143BDnS9oHwJbYpqpzQdjGxmzVe0O7942dPIwHav/gpXlrNamsR4mBeTq
         vQuyfjkHQXJqTLQhtDB6h5dp/6/e4b7jITheuNkXm9BSX3uxFopiWQjTh68HwpCtCXIL
         Ef3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384254; x=1753989054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpuFWM4vZR08GQA+aL/b+0xC8CNAYIhegIrtM5ITN8I=;
        b=F7/APmHqnuTU2vMZmjrAcC7oDWBW4cmjZmZKMi74j/5Gzn8bSYZQoGvtD2ZL/jH6Us
         QQoozzLx9gRGx7FUD5V4yKBKeeSp0TPRLwnN4zrdjnCCcpoMkLmSqieOJXnB3M4FA2GH
         mj4zhr7eNw2JBCenCuHz1dWdj08FH8iMXlpmFEozKbfybJ4v9gZmqog2Nanw7+PDWc1I
         QutKRzetsWSFcwfOzQISmVNDpU695Hf/BkcEbz+6bdHn8/Kzm0ryALU9mdiVIddRpoVS
         aUtoNpWXPcMeKxJgzoeZ04Mqu3IXvwVKhPXH9NVfvZfy37jdhddqJ4FQAEXVOZSN2P88
         kxrw==
X-Forwarded-Encrypted: i=1; AJvYcCXpjqwuuQz8CBKVoY/zQvDhxu9X6Ej3JBchYdd/TaVSvnTHfgLB2lj3oxSRiO9UHspn/FE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoKSAsgJYGajCbH4d13TvO+JVNIGqDdpo86q13UYP2ELHFOSim
	WdYiGYAwUU9LyG2PZ415f5xvU766V46Iymh5XAEPznwxKBudqXPyI9Fczx+0Hb7RwcU=
X-Gm-Gg: ASbGncvLfka7UEudSQ6OcED72YSvpV41v3H/wHivsxkk9BIeOBZKg9cFUngS48ITtAU
	MN06pgveqH+Bfx+e6B0eQ3WvuQJf1dLUew/3Bwv1tqjERxIlzLq1kkZ4kIkVS9hPxorBLpZYDF2
	kvG96BPlNCeAx5OpSZHOjkyOQI26bhNnpHy4zsIwuBdR3ujsFfeZsEZB+JTpqbAFXdzRFMz34T9
	3wHi+d4XVlgYY4UrM5maINPNiXvl1lXjlyvVr/fcHKNeH5SznXZnhKrtqrblzbN3Y4+lPlsSmBo
	sG0md77E3/vp48zvdUlVSTzo9v14xn4+HBo0UqI7jHeH+UeNygIoB/ILMGse+djzvaU2xM/OL2Y
	X8sPxAMKuII5VYuW8iljIVZ/WtsGHXwtax09w4GKm85RKKeaAW0/M5sbzDEBzl3bznaNe31Cli0
	ux3RR4KAzbiX5Sfl/h
X-Google-Smtp-Source: AGHT+IETLj4lqNDbzVPCelYkIZ+/ewbraiJ3xl0x7JvQIQ2uWPY4VYrf/94u1lazQP+RSPLFulswzw==
X-Received: by 2002:a05:600c:35ca:b0:453:81a:2f3f with SMTP id 5b1f17b1804b1-45868d4f48bmr83934485e9.30.1753384254404;
        Thu, 24 Jul 2025 12:10:54 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705378f4sm31118955e9.2.2025.07.24.12.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:10:53 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 1/3] x86: Don't rely on KVM's hypercall patching
Date: Thu, 24 Jul 2025 21:10:48 +0200
Message-Id: <20250724191050.1988675-2-minipli@grsecurity.net>
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

Instead of relying on KVM to patch VMCALL into VMMCALL on non-Intel
systems, use the native instruction directly.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/apic.c   | 5 ++++-
 x86/vmexit.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index b45fc9c1b72f..0a52e9a45f1c 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -641,7 +641,10 @@ static void test_pv_ipi(void)
 	if (!test_device_enabled())
 		return;
 
-	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+	if (is_intel())
+		asm volatile("vmcall"  : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+	else
+		asm volatile("vmmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	report(!ret, "PV IPIs testing");
 }
 
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 48a38f60f6d6..56c37f6215ca 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -33,7 +33,10 @@ static void vmcall(void)
 {
 	unsigned long a = 0, b, c, d;
 
-	asm volatile ("vmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
+	if (is_intel())
+		asm volatile ("vmcall"  : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
+	else
+		asm volatile ("vmmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
 }
 
 #define MSR_EFER 0xc0000080
-- 
2.30.2


