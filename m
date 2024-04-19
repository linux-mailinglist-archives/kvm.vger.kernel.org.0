Return-Path: <kvm+bounces-15333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C80B18AB325
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D7C1C229E5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6602132806;
	Fri, 19 Apr 2024 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arb7ORdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB712130AF4
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543397; cv=none; b=CY7t+vdyXKn6C3wR6TYECcuBG6I0FDpj7mI5QDjKmiC+EyXBPAWgM1Bje687uB2DQpinx8GzYj43VyA+7v507D1gb6mPdovTzxDaf+fqBpcOpjMSl9Xgrgw5kBzI+FAM7G6GqO1U4whKfrHTG+NSZvSc9FVW8XOcRVPkcJIs1T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543397; c=relaxed/simple;
	bh=MpmAFJIdUDUmyZX6ssESNp8lCaFimhUztgev8k291ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YUjBOJC5hiXrbmiRmT+w8EEhpfcBIHhRy5C11U+OTMiWDVaypensGu8RuqPUYWC9VT8iHI0NKlI5EpeoWNaw+8ZeU2g89vUIoXTrvpgXMY8BLnRh59IBQRmmDMH9mA6GzVlkxore9Z3uaXagWiioyVKjieSqEt7byhTxt2ZsXnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=arb7ORdr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41551500a7eso15574095e9.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543392; x=1714148192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8WSdV+XPd4kPmSOlQjvtsKQnLM79YA3yJXgIa1yDz8=;
        b=arb7ORdr0byhymSVeJPQOGGfjnnrYu4OGsAZBSReMVski3UDNukP0wViwxY+mq25wK
         2FsXIma/HEgr+Bnl//kxqddx48Ns1Zgj1fIoOSLH3jR0R1ofnWg9uxxm9rYy9Hdb4ySx
         NqlF0+MbdGeTU/sndctAlVoI5LogxDQDVFhN2YXNekvYFnwXHWgX61r3Iqm5TQGXRQO4
         X3TWtunnxS/NY8QlWL1cPilUhXVZC6Aw2KLWUe/+gUWByMwswtBPAIEy+n+nMa6eIrwL
         d2Ql0kHSEdN2mZnW0Xwm8pfRqaGqNo5U4v8WdEUS0eId39RuwgabhtNlGe7wcp9sXRLH
         sDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543392; x=1714148192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8WSdV+XPd4kPmSOlQjvtsKQnLM79YA3yJXgIa1yDz8=;
        b=NupSZIffMO4v7qoR18N8X6eOQIDQiUMAyUie0a7LmcsVZF1YXG6s/J1QENMsQK6hn5
         61mD/Gz+/Y7/pv47Sy4WmR4wI3rmR4ocwtWsE9TOrazXVGOadfwqSXJ42rvMKg4nhxNO
         XguQsH8XQJfGpPHD1rR5dLxX36ySlC/gRWVzljngwaUvMBYlBq/f9gH/UXsl1G97Tdtn
         Qxez7rgduoaA30RZjVGO1saHXpPn5zDkVHDr442XS9418uhzo5jUPvLIgASjXfaHn/oW
         kNLSzNDY3Zjx6tanwTd8smqd6sk/JxgKAjzje4WkE9fiwKrl7RxOIyDiwKxrQa0E2Ow0
         HbFQ==
X-Gm-Message-State: AOJu0YzNFv0ypM2HqqAdhYiJDgHxYML0mF7etU06sV373KHaotYAiyxa
	yTMCJQ/yUQeokexMG5xWb3ixDwOnNJfJrB1GvZPKlZckIoMwYlqmeXy7CqNM
X-Google-Smtp-Source: AGHT+IFYpar+QPDAKEcTqP5RgexChBskv4WtGrImjKhheU20lLd4fHaZjPxTAa/VMBwk03SPpNvDnQ==
X-Received: by 2002:a05:600c:1554:b0:418:a620:15a1 with SMTP id f20-20020a05600c155400b00418a62015a1mr1778822wmg.30.1713543391646;
        Fri, 19 Apr 2024 09:16:31 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:31 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v7 03/11] lib: Define unlikely()/likely() macros in compiler.h
Date: Fri, 19 Apr 2024 18:16:15 +0200
Message-Id: <20240419161623.45842-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

So that they can be shared across testcases and lib/.
Linux's x86 instruction decoder refrences them.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/linux/compiler.h | 3 +++
 x86/kvmclock.c       | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index bf3313bd..9f4ef162 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -121,5 +121,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 	__u.__val;					\
 })

+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#define likely(x)	__builtin_expect(!!(x), 1)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* !__LINUX_COMPILER_H */
diff --git a/x86/kvmclock.c b/x86/kvmclock.c
index f9f21032..487c12af 100644
--- a/x86/kvmclock.c
+++ b/x86/kvmclock.c
@@ -5,10 +5,6 @@
 #include "kvmclock.h"
 #include "asm/barrier.h"

-#define unlikely(x)	__builtin_expect(!!(x), 0)
-#define likely(x)	__builtin_expect(!!(x), 1)
-
-
 struct pvclock_vcpu_time_info __attribute__((aligned(4))) hv_clock[MAX_CPU];
 struct pvclock_wall_clock wall_clock;
 static unsigned char valid_flags = 0;
--
2.34.1


