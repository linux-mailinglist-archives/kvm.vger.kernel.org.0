Return-Path: <kvm+bounces-16578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CD98BBB45
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 796DC1C21387
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6FF37140;
	Sat,  4 May 2024 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5Tdcbj/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955022EFB
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825790; cv=none; b=ptmpNPs9NKZLTNqfgvRSW5rrZsXfPs9s57pRs7m7E3a4XKRtvHErLEMM0XursA5FaTf5Zn13czODJKBdKlISOKwmL4kcZqTECEsDdrc5ObTX+8MuAR74n0kZ9F9rGJmNdRl3tiZ67mkdB/UAjR8DvOuLslmZErvAV0hMIEf13Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825790; c=relaxed/simple;
	bh=8RK9eJnJ5WuAym6YragJ1GGkd6qXv+cnx3hvPIaTKZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlfL/JMCPdvLX6fvbDh2tkO0yv+ZdMCa6D6vDyu3zkDm25EjhV5Jai25qPKOOrtM4mKKA+oMuU3fM4n3Jz7frEDMoVVAu7iTVWb/WoZzsUCx2A7bQDTpg9EYT8sgBBM4ErNXPa6LkwLuejEUKiqCWmhR3XczPidHXkqZXN+3nOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5Tdcbj/; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6f449ea8e37so516148b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825789; x=1715430589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDXzWLE/DUs3GDPPxGlpa8evNqGRj/CtlxJusPx/GlU=;
        b=e5Tdcbj/efAA+o1OklLHBEwzQjsLMZW8oCy4BOy88Pxp/2xkQiejVsARGYvk0FjZEf
         /PdMd0qsOLT0Gjwjqu351hfoTXdAt0ec1ArCttBwvfBj3h+WBT1zSFUjXvzDiwZMmMHG
         P/qYAgeoONf8gN+IV9j1hEHqgVT7DjXGiHpofYo5E+pHokeTsiiMHJPZyTgC0yUOwJ/s
         HvPuDD1Aj/tjLthNeTlYdCpGCF1+a+mv9NYOdn2+jPnDZd5ZlMr+dsrL+XKRDMiXOXn2
         qi45N6ynLBxEfKJ/f6dmUmNlRJjcp+C4hzB/PhJJ9t8g/mwcEcz8HARKvG2LFXTfYfXt
         ugjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825789; x=1715430589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDXzWLE/DUs3GDPPxGlpa8evNqGRj/CtlxJusPx/GlU=;
        b=WmvwyIY1FNLPPM+buua3lcHf5qjW4mo34y9L1kvfrlwZezMbz050eLBbWLtXGgLL8q
         wsbAmnc081AX23m2e7ahxpKQXzw0Fm3MldCCcoZk+eFJPsa3qlT2XWOm3icJiF8EK0lh
         3puuRJPHlNfguFFg+mI7VC9sv16Cr4EsypwZK2BR8Wyd2MZ+3KkWv9dXFnVyNbI7Fg9W
         IUP+CLOTH8WkV/FML5Ar3B1+u6WTssgrBlyCQVQHcYi1W24g3cO0OQ/zOhIPx0yQwvY2
         sKjEJOQUZ2VWLkwiOH+3ZQW/iABVlpF4IhYUpm96+Rit5m/fH/VHfmaScm9clpwT2SRh
         sW2w==
X-Forwarded-Encrypted: i=1; AJvYcCUUl7NAKN0+USvYNo0G9ECJ8VQpIXYkVDypN1eSxhdA+RaEx0EUgqt1v3VkcCkXeZOouak2AN5rnoBLyS8rgT6/WMRV
X-Gm-Message-State: AOJu0YxVLSTjG9YnLrOOfN6qAMsOXv/hbfO3m8n0klJ9ZzKkp6g2lyz7
	HnN6X5nOqYhSY0UaEBabxmLIqW2yPMJE7J5S/xr3QuetTP9h1GYH
X-Google-Smtp-Source: AGHT+IHnQ2zuv/B+C0SD3NBohPwkG9C/rQDC8UTekLkLibupZ9dNhnjts9LIMNCchzomoGQJps/l9g==
X-Received: by 2002:a05:6a00:4b4d:b0:6f3:ee81:13b5 with SMTP id kr13-20020a056a004b4d00b006f3ee8113b5mr7759237pfb.17.1714825788886;
        Sat, 04 May 2024 05:29:48 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:48 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 15/31] powerpc: Enable page alloc operations
Date: Sat,  4 May 2024 22:28:21 +1000
Message-ID: <20240504122841.1177683-16-npiggin@gmail.com>
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

These will be used for stack allocation for secondary CPUs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/setup.c     | 8 ++++++++
 powerpc/Makefile.common | 1 +
 2 files changed, 9 insertions(+)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 58be93f08..73ca2f931 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -15,6 +15,7 @@
 #include <devicetree.h>
 #include <alloc.h>
 #include <alloc_phys.h>
+#include <alloc_page.h>
 #include <argv.h>
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -133,6 +134,7 @@ static void mem_init(phys_addr_t freemem_start)
 		.start = (phys_addr_t)-1,
 	};
 	int nr_regs, i;
+	phys_addr_t base, top;
 
 	nr_regs = dt_get_memory_params(regs, NR_MEM_REGIONS);
 	assert(nr_regs > 0);
@@ -170,6 +172,12 @@ static void mem_init(phys_addr_t freemem_start)
 	phys_alloc_init(freemem_start, primary.end - freemem_start);
 	phys_alloc_set_minimum_alignment(__icache_bytes > __dcache_bytes
 					 ? __icache_bytes : __dcache_bytes);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top &= PAGE_MASK;
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
 }
 
 #define EXCEPTION_STACK_SIZE	SZ_64K
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 68165fc25..6374418d2 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -38,6 +38,7 @@ cflatobjs += lib/util.o
 cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc.o
+cflatobjs += lib/alloc_page.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/migrate.o
 cflatobjs += lib/powerpc/io.o
-- 
2.43.0


