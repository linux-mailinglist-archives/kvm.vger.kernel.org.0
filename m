Return-Path: <kvm+bounces-16580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB9B8BBB47
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 881341F21F7F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015F722EE9;
	Sat,  4 May 2024 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3slfOf7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120525776
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825798; cv=none; b=Eu/wqMCKTUGAcp7RSCE1KgDNmw2YSb2KtO2wZ2OOnvInpK+ERXlwB06yyT8uqot/EFPS8oStJGJ20R14l0mmKc5zRTBJWL4y9jD4lrYuqhuZl34dj543hJAnLjvPN1IolSzohTAUXRIHdnF1j8b3Eu00cCmmwuCMnjYCj5L3Wb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825798; c=relaxed/simple;
	bh=mvaR/g+xToQdO6qGdFp3DZzUGc4V0LhrYi90lfzaX6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQvuKu09e+CalapgSYwQBEJgsV7uH+ES46Fzu2/LsO1usIKjW6dPTE2ckewIE5GVA7WNqoXJ3OnWES4Iec9Jzj6wrpTcVLJK6cwZNDbUMt9g4Ru2vCID1utooBgVe7fRhE6aVEYdiTBhLCfnobjnNYNSwqq7AIn+0Sj2BrK6ClQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3slfOf7; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f44b5e7f07so392223b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825796; x=1715430596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FibUaZR7a7YpmE3r8aur9Iczi126UDYou5egcERbaPU=;
        b=A3slfOf7pN4kHR0C9k12/LEK1rLe6lJ3ClaV2PNqfKUPRMxKNV1Wjf4OYSqoRU8Xfn
         HCdpC87K5OsVLEaTHlZoN+lOO9yHuWBMJE+EzySALxSaFNVs/W8hTolXYUpbXp1RdWWP
         GLskdIXnr9Q5FZHE4PJ5kr2KcjlfZrKMfIxyMVgaIv16jhYvioWA/kk4t7v42jA4qP8F
         1FkVyCNeXP1BZjZBHWvN71GwRTciBc9xw1+Ki4QONbm/fJhxBd5WbzWv4MZfBmLu7yxU
         H4gvYG33F/bmkIDo0E7LSkAtG5p9JPcYFJQBJ9kT01zLalZJLIPZ8ZkWjKOHt0EU4fG6
         Irrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825796; x=1715430596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FibUaZR7a7YpmE3r8aur9Iczi126UDYou5egcERbaPU=;
        b=J3lZpTHUiUXKNgjj2UczsP2JQhFW4yJeQGCSU7pxLMKIkCc7KR3duOJeSOW7CWx8IT
         +LBNIXVWMW4cYMOxbei5IZAox5H7DOdWmvamG70RvTBJC/ItQ/T0JBUNuGGjn/awkjov
         sgp2Nwe3TM66jAw1bXTTEucdl8eDdCJdgdNhNsO+1Ohy2KtT471bDRAxpEGP/PBF3Q7k
         71U9txuOLsOG6fMmYRZoOXwjn9B9WhTPaoPDN/uvcP3OfyLpJLKMaJjs9q6zuUUikb4T
         0PUGC40G3fpAcCQ88aeQu+HkAu60pIE1tGIJ0eNjG2Few1jSbkTIiGp/bf7V8K//K0Os
         AgXw==
X-Forwarded-Encrypted: i=1; AJvYcCUWeG2xIKrK2yvfKA2hHuCZXavLvJFZ29AWhXa90F6G94MdXhqa6brnMRp94+BjJl6HSDPxyc/32sNqDDnvDF+df7HA
X-Gm-Message-State: AOJu0Yy3+OTkfXqEEeNsDuDlwXlfYEcHQZUoHoSexGgaZm4+CS9Qp5GN
	n+dNLTjtdguKJHFIJ7Kv+/B9jJRPMOmYojJ55JdUk6hYyjExBFdm
X-Google-Smtp-Source: AGHT+IFg9G2Bb7q3NP5uRAnJ4+QwVnW2uvirGMpGnluQF6UbjZr9y1Mkv1rM0MtalmE/Lrd9dZQD6g==
X-Received: by 2002:a05:6a00:4b4d:b0:6f4:4723:98ad with SMTP id kr13-20020a056a004b4d00b006f4472398admr6462655pfb.16.1714825796206;
        Sat, 04 May 2024 05:29:56 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:55 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 17/31] powerpc: Add cpu_relax
Date: Sat,  4 May 2024 22:28:23 +1000
Message-ID: <20240504122841.1177683-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a cpu_relax variant that uses SMT priority nop instructions like
Linux. This was split out of the SMP patch because it affects the sprs
test case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/ppc64/asm/barrier.h | 1 +
 powerpc/sprs.c          | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/ppc64/asm/barrier.h b/lib/ppc64/asm/barrier.h
index d2df29520..475434b6a 100644
--- a/lib/ppc64/asm/barrier.h
+++ b/lib/ppc64/asm/barrier.h
@@ -1,6 +1,7 @@
 #ifndef _ASMPPC64_BARRIER_H_
 #define _ASMPPC64_BARRIER_H_
 
+#define cpu_relax() asm volatile("or 1,1,1 ; or 2,2,2" ::: "memory")
 #define pause_short() asm volatile(".long 0x7c40003c" ::: "memory")
 
 #define mb() asm volatile("sync":::"memory")
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index de9e87a21..c5844985a 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -228,8 +228,8 @@ static const struct spr sprs_power_common[1024] = {
 [815] = { "TAR",	64,	RW, },
 [848] = { "IC",		64,	HV_RW | OS_RO,	SPR_ASYNC, },
 [849] = { "VTB",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
-[896] = { "PPR",	64,	RW, },
-[898] = { "PPR32",	32,	RW, },
+[896] = { "PPR",	64,	RW,		SPR_ASYNC, }, /* PPR(32) is changed by cpu_relax(), appears to be async */
+[898] = { "PPR32",	32,	RW,		SPR_ASYNC, },
 [1023]= { "PIR",	32,	OS_RO,		SPR_ASYNC, }, /* Can't be virtualised, appears to be async */
 };
 
-- 
2.43.0


