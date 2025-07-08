Return-Path: <kvm+bounces-51792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6297BAFCFA9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DE5566D4B
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613A92E2EEC;
	Tue,  8 Jul 2025 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AaV51Lfe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8AD2E1C5C
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751989697; cv=none; b=kgqKw/HX8pY60LkakA7hx67LdfYS0rtnu3iHdk0rcpaUsJrS0HI+bhHl0WuYhx9jx0sDoJlAJ0pI+9lfVu4y2AYvUsiI54ROVrpEdXfQ9/eUu3ve7CFvlpjv/i4RB+kUq6PzGq80m3YkeTwuJDgogaqhv43HSuQdHkUHkjQ+xd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751989697; c=relaxed/simple;
	bh=ds5SN/ud6IreyNpgodB7PP6useD2H+9ogieo60SRHek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF/fGLwuktwka0v9S9ec3/6jTAJdrsEdknbMMHXYxHn7xKANhftYTo5bvkv8EW/hpETN1GZ1ElZlcJSfiTxsN2UIS9fLwyJos25orcrLAr3q28XRCXNkVWFExvNgXroVK2DZ1NpAmVn6oTZ48EI9LPvSzRB2e4wg8BdhqISX0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AaV51Lfe; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-700fee04941so43698756d6.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751989693; x=1752594493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iH04xoC4HJJjcr3JF880EHmqHS1N+xsYoFSsuwlbdaQ=;
        b=AaV51Lfev6Qp8tdyZv2g7NRGgMs+qZodiXVapmdyH8iFqJ+iIDC+s+LzViHZwizJzx
         k/WNcT5UxTnQKCFgAfTjnYG8pUlYWmm2le122Hy98pXgFkShftt5SuM1F61jvdXFS1GK
         NvT04frwRN4DtwjIffQhsWvb0Vqh2gQ+VmxGFAjx5+kWMSWRotNdQj66IsQsujsxyf3C
         wzxpwbsgiayNBU2f6qm0s9EhS/3ACCJRbp/q4GCkWy275yTVz2PTAmWtN2jHrkdF11xX
         UaXRjpdi8cVcG8yLJ8/Qj8cuKDwKSIxuKotnPi8T1kZw9+agVv2GY2p9duPkjoACNgFn
         XCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751989693; x=1752594493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iH04xoC4HJJjcr3JF880EHmqHS1N+xsYoFSsuwlbdaQ=;
        b=S64VLGqi0v6Xa0jxITOUYTAE336zFY6PS/izzm/3lvVEklDUgSEbBeOLyj2jmt3w+Q
         LWUik6EFBZNSAg/XvycvX9VHnxZ8NrHu7Oz3XvBPBD8+29sOjsv27Km0GBpgV1UbrtI2
         5XVsxBqF6vug1NBo4P2eUpAx0eiY6TFKN3tpWqv9eZn5EjxcT6/XCftRCxVdwBxfO6tV
         Szv/gArq0NVU/bCgph4qzbZpjKrxI1l9kO8FFdnU22lqLCQCe6Vy7nxFDB4t7nVVIS7D
         zJhsOuyr5E/dS0jKm6yfSb8EMxUU0b5hE3oMxPdwPqfd2+fqEkUHoT543o9PfpHCkzh0
         ROAA==
X-Gm-Message-State: AOJu0YwDeWxtaKP3bG1s29g3fgLAPJkZjxE0VNAyRSJUGZ2DXkNfhi8a
	yTNSZ+R6d28kRXgZGmYIHJQIlt72+a3SB3MJj+HCxr3IdDhuSSmfvxq3hUF39vC3DO0+n7BZ/+9
	ARtSF
X-Gm-Gg: ASbGnctLkp01OtJOmo1L6u6vgphJL0QHQuLrUG8fhUmlNpNBs3Rqr2XjpftIBpY9/+i
	T+8Rkk80+ZREf9LqBHRnpG8RG0Ls55znMZbKiKMnxmtyvKIwh4CuP5xagJtT7sWFshR9FU7ScqR
	eP9FUodNwjeenDB7ejC8WKUO8q+ypDYe4oaZSklume9XnqbWhVYCYEWWnLgglY6AJoVh5Q+f9FU
	ymkDF4WV5ExsH7Z+lE264uDSOZskmsfgA/XTxA6D2J4f2zYJUv763g+KZe2YR4aJnhJNUT4vzeT
	hGIPHXgNvaKZKjOfX1jamd4nrAn3JXDSL+WCjxSdEqa926oG0ww5ejoOgVsfxaZyc2jfX2X51CE
	aOt4aPrSYYBzquEkJCkq2YUsz4YtkVwqfd0n9ALyYEONAFoLtI7bOs6T+nxAkTg==
X-Google-Smtp-Source: AGHT+IGUQo5EBx/tNY5n3ZATmL3uaoM4iK61VNEuctuQHFnVd7lY/jZGvovGvruOSz6T58HuyGkltw==
X-Received: by 2002:a05:6214:5b81:b0:6fb:3d7:71bb with SMTP id 6a1803df08f44-7047d931790mr46736666d6.1.1751989693532;
        Tue, 08 Jul 2025 08:48:13 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d5ab9csm78453346d6.87.2025.07.08.08.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:48:13 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Cade Richard <cade.richard@gmail.com>
Subject: [kvm-unit-tests PATCH v2 2/2] riscv: lib: Add sbi-exit-code to configure and environment
Date: Tue,  8 Jul 2025 08:48:11 -0700
Message-ID: <20250708154811.1888319-2-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250708154811.1888319-1-jesse@rivosinc.com>
References: <20250708154811.1888319-1-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add --[enable|disable]-sbi-exit-code to configure script.
With the default value as disabled.
Add a check for SBI_EXIT_CODE in the environment, so that passing
of the test status is configurable from both the
environment and the configure script

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 configure      | 11 +++++++++++
 lib/riscv/io.c |  4 +++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 20bf5042..7c949bdc 100755
--- a/configure
+++ b/configure
@@ -67,6 +67,7 @@ earlycon=
 console=
 efi=
 efi_direct=
+sbi_exit_code=0
 target_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
@@ -141,6 +142,9 @@ usage() {
 	                           system and run from the UEFI shell. Ignored when efi isn't enabled
 	                           and defaults to enabled when efi is enabled for riscv64.
 	                           (arm64 and riscv64 only)
+	    --[enable|disable]-sbi-exit-code
+	                           Enable or disable sending pass/fail exit code to SBI SRST.
+	                           (disabled by default, riscv only)
 EOF
     exit 1
 }
@@ -236,6 +240,12 @@ while [[ $optno -le $argc ]]; do
 	--disable-efi-direct)
 	    efi_direct=n
 	    ;;
+	--enable-sbi-exit-code)
+	    sbi_exit_code=1
+	    ;;
+	--disable-sbi-exit-code)
+	    sbi_exit_code=0
+	    ;;
 	--enable-werror)
 	    werror=-Werror
 	    ;;
@@ -551,6 +561,7 @@ EOF
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     echo "#define CONFIG_UART_EARLY_BASE ${uart_early_addr}" >> lib/config.h
     [ "$console" = "sbi" ] && echo "#define CONFIG_SBI_CONSOLE" >> lib/config.h
+    echo "#define CONFIG_SBI_EXIT_CODE ${sbi_exit_code}" >> lib/config.h
     echo >> lib/config.h
 fi
 echo "#endif" >> lib/config.h
diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index b1163404..c46845de 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <argv.h>
 #include <bitops.h>
 #include <config.h>
 #include <devicetree.h>
@@ -163,7 +164,8 @@ void halt(int code);
 void exit(int code)
 {
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
-	sbi_shutdown(code == 0);
+
+	sbi_shutdown(GET_CONFIG_OR_ENV(SBI_EXIT_CODE) ? code == 0 : true);
 	halt(code);
 	__builtin_unreachable();
 }
-- 
2.43.0


