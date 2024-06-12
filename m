Return-Path: <kvm+bounces-19455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB3090558B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB02EB21D01
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3647017F501;
	Wed, 12 Jun 2024 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODqIPSOC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D546F17F4ED
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203553; cv=none; b=edgzf+TwF/4dixJmgvetgzNFCAvOj0oaUz7seafJQ6nQ4TVpdWrKmMZsm9CpwQa0p6uTdyFSwO5xFlBR7K+Q+kg28WjM2P4hA3m3XlPQQ3OZm11Tu/boZKeYSQfLMpjOSB7j3GI76pBQtfIHkO0g+QyXMYFd1au6wWOGKZI/eus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203553; c=relaxed/simple;
	bh=prygXyc2CjFiGgmw21MZ2CoC1VKsVtXn642Jr7lv5N4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IyRl3L/oVUtk9MdCXzGAmNj73WypeORaDx3P+lR6SVGcQUrp37r/cdrZ1tArY5xtpFsjXfjuAv1UT1gFsYW7HT8MI7lb3kkMRe0u736MCb7zMeobZke3m6gfWN9Q7xZHmSnPN+1ZA2bEfayqdUXNf5wzKjEHY1NkFokdYVuIsa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ODqIPSOC; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57ca81533d0so1605714a12.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203550; x=1718808350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W39EJR6BkfNLyaz3oo06mjRwnSViVBqQpmbUWo8omS0=;
        b=ODqIPSOCRg9ALV0R7coFFkpFMj3lZTQAAv8+Lw3QetXxwWZaFV+5kGAMW6Eh85feLe
         n2ZGQetl2EGACh7DaYVMocZCiLrIIua3SWMzFDc3gTtxI42ayZRHJwVSGQMAa8mupnV4
         5PLNcubk5IcJlBWtadgZC5UMK42O+Am5SCArkHC8QJcIxxWvS/sLtYPJGrRX8ejnSkIm
         Xec/QAhd9bxGKVcfSkah7fZhlXWpZib+HpN3BinLZw4R3Rr8vsfrPdRu+egXlXWaBqeH
         pk6REYs0b681Kd3mBpLPn+xIR8FZC8pRlGngIutrWiocc9rdaKgK72u8jMPk+mkzkv32
         1+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203550; x=1718808350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W39EJR6BkfNLyaz3oo06mjRwnSViVBqQpmbUWo8omS0=;
        b=SpfqUCjlxmBRd0XLbxgBQcg6p3Y00i/yHHUTMGmMQcgnuRmPpC1BANDpcdC7gaLX41
         3IAnt7bmgm4YxA/IKoKMMensnLycaRctUva6EMljuQRLfjfIqF30VsHsTt8EfoxrsX69
         M0Pm0bMmOd4YTpH6twMOkpPEps6pw3gVDH+BjgAzQKSseQHfG37WnlDSP1H8A/oj/bBR
         5VcAowEjd92XyvsrEwImGBel/aeqEDGXpAiQUTLm7YoWA8Ys5kl+7HEUi1c3+XTLaQ8H
         jBH0yah8Kr+vSfxBCkiOUZ72M+B4s0VS0ISUsIWQHetnh1pL19EZe1JUGSLA9axkMCxg
         DU2g==
X-Gm-Message-State: AOJu0YzRdwmToH1ZLJ4gtmQr1wN273npH71jQljggRynIvdWJzRCEI9L
	SvdKCEBif6R1esxYnv9fuELfh/SoVc6RBpeR96SOo991bFLrqHagQIzb1/AQ
X-Google-Smtp-Source: AGHT+IFS5OM9ZCk3tGmg6Nzwlqe2nkzS/IDogU1CDjyPVmobpgy6ZNGBeqBEsJqMh+A+giFIwp7XdA==
X-Received: by 2002:a17:906:b895:b0:a6f:386f:6835 with SMTP id a640c23a62f3a-a6f386f6e10mr354792066b.4.1718203549315;
        Wed, 12 Jun 2024 07:45:49 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:48 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 03/12] lib: Define unlikely()/likely() macros in compiler.h
Date: Wed, 12 Jun 2024 16:45:30 +0200
Message-Id: <20240612144539.16147-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
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


