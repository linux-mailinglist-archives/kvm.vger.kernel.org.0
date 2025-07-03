Return-Path: <kvm+bounces-51487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2103EAF75DA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA72567FE0
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DC82E62C4;
	Thu,  3 Jul 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BXXym7vD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA652E6D11
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 13:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751549765; cv=none; b=IhRYbW2B8UDh7evLl+dzgCM1H1LJi0YUzpsA3+7WNUfIkBfexgpEf1pcLRlgn7R22FJXeRtmNTwDX0CSZR33RqixlFVzacPnKAqEJGpW+An95034R44nYVG3uYi7X6/B1Sf/eyQfHXTOYBSBFzw63aBUX8qxfWzlai1D7pq/O/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751549765; c=relaxed/simple;
	bh=+dsfzHxe0IqbWFfgpaAcazrKyDDLjdeZxVUS3CU2vD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tO4wEFa64ibaiT/BCp51otFcGzD8EOhuDQBJi/ZDd5O/wJ3fCuDXo6t394zqCgAGvWFpLEwMGruRRKqHBS9EF3301xKfD+vbK2OHocLnZhKhAtI9n5eXwRfS+3EIrUs9Zgbek546Ip8sDIYT8Z0voJ5EZ2PZOoy55jHc0Lxtdes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BXXym7vD; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6fafdd322d3so63658006d6.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 06:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751549762; x=1752154562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AybLdMIaTX7u240+QRHcmMiae8oJPe3j6zxp6xpwSS4=;
        b=BXXym7vDGBzlHPwl9cnp2rbQNM8N7755SktX/GJxNXXv559gOhVTUE99ypNG90td1Z
         nYP2CIxPt2/l5V4RhEEvLrSGI+HT3l45dvLLqHrrefMleg47Qc3K0IEmQ9TAjT8irb9h
         4U8v20noJ4d03M8f+7lYD+dlJ8aewvLA2CeLDGAWcDse2GdZTf373N/L+fS4cHYwyT+Z
         868O5PQCKAdT4B7+2a24qDUTuqs2HLdPLJP0hGDulFhVsWVdorTm0T5/QgHgB4QECYj2
         yM+QSZbXiM47lydQuGOEUa9hPKGCwSYNjSUamW0x+UPWmg6EKsxzuOxZqWpzeOZBN6gZ
         xaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751549762; x=1752154562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AybLdMIaTX7u240+QRHcmMiae8oJPe3j6zxp6xpwSS4=;
        b=fG7k8hhgg6ncItZVqkYR2PYezYq3lK0SGBLOrFRVfEfMdCf+61St/8r9/ILPALNxRR
         1ncMQYX+3X6Fo0D80GpbobptozZrAwtpUiA6Lp7vMY3VDhyddAoG3B9KW+EPxAH+UQec
         PTXT+qwzzwx+34CceHnzlnqgV5PXRLIGoBAlB/Rh0I3tKXdrmfi/+JeZTgHnWdYMj6vp
         5qzwpIouNFIngYa+BPIUm1Z6n4u6tIzKpePLBGVNVUQjCkmU9E5C8jz3tHnLLUzYVP+s
         BtEjpjTW2cn+/1UT467d9Qvrfbfj9L5RtGPMMdIQV8lj2pJ0TpcsQTK4sQIzUeh2ft4N
         qPoQ==
X-Gm-Message-State: AOJu0Yy+VPpluxlViIGzsC9rQI29PP9lAFnOJVNtoIRyDqB/IdT4OWib
	VgzXZdjeUF67O9/oEWqKJTvxgSFm1jb/PjcPzVFfLSmHr9FlJRoy3bp/B0ibc2cl2RoOO740SVy
	4SYtO
X-Gm-Gg: ASbGncsl4lsIzBKOQZYXX2qkRL7w5mt8raRkGZZ+3ZRiKDQPne1s1pwbPvmo8HKePy0
	VsWiUnCJp5wcAc7bWVx7HtsNA0v5iZv48/0/gJzEC9/3PjJ1+4vSE1Jt+fYOrDA8HJTwx7jxXPo
	Vej/7m3O+EcS/SAsM+5ikj63K9vgDOFK1/lRp6qFAhbWoKGEcY3s/+55AWHOEnizYdq20K6hbff
	u0BBwzUN5x3pAKY9l4LdSGVbPcTqTza7IhPNgGg557MpBUE+zeiENPvk56bn1avNtUd9e18PCg6
	2nedz7OtoKeIsqGEAdadYAZZUWPhrqJBIKAHvDLqgBn2+ahGHxAo0q/lk4hWVtNaZtLaR+LaTn0
	=
X-Google-Smtp-Source: AGHT+IGHeqWTScI42ieZ9hlCd88aWLNR5bd/wuHidBIbPxL/tKCuhIsA4xmBVc4nHMWIIMW8e4W9lA==
X-Received: by 2002:a05:6214:5a0c:b0:6f5:106a:270e with SMTP id 6a1803df08f44-702b1c118e8mr103093756d6.44.1751549762212;
        Thu, 03 Jul 2025 06:36:02 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com ([96.224.57.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd7730af00sm118166016d6.113.2025.07.03.06.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 06:36:01 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH] riscv: lib: Add sbi-exit-code to configure and environment
Date: Thu,  3 Jul 2025 06:36:00 -0700
Message-ID: <20250703133601.1396848-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add --[enable|disable]-sbi-exit-code to configure script.
With the default value disabled.
Add a check for SBI_PASS_EXIT_CODE in the environment, so that passing
of the test status is configurable from both the
environment and the configure script

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 configure      | 11 +++++++++++
 lib/riscv/io.c | 12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

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
index b1163404..0e666009 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -162,8 +162,18 @@ void halt(int code);
 
 void exit(int code)
 {
+	char *s = getenv("SBI_PASS_EXIT_CODE");
+	bool pass_exit = CONFIG_SBI_EXIT_CODE;
+
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
-	sbi_shutdown(code == 0);
+
+	if (s)
+		pass_exit = (*s == '1' || *s == 'y' || *s == 'Y');
+
+	if (pass_exit)
+		sbi_shutdown(code == 0);
+	else
+		sbi_shutdown(true);
 	halt(code);
 	__builtin_unreachable();
 }
-- 
2.43.0


