Return-Path: <kvm+bounces-51934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A51AFEAA0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED21117EF5F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96ED52E265E;
	Wed,  9 Jul 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="x04yMWtK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A6B2D9EFE
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068833; cv=none; b=bP5bSYmUqepF3isJaWs4V5mIAp5o7t4P/iRJQA2YaBAz3CkSuMt4sEuByr3DPvskmAQ28qoagxcID0Vq+bds1LgP0bNw893xB0PGEK0c+Q0gR/NYTQ5KXHpFCa//E5oxKkfoax+PP/w14xJYiAGXx4+QpiO74I4ggVapv7D/UqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068833; c=relaxed/simple;
	bh=FIanCaFnhH61IsjdDniSv32kh4AxVhWk7Ms3D8V9sgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCWKRVCW0VSCqviguK5sLk9EkJKviQfdpFXbaQ+21eloG2UjVWlgdWBv9NAXrevELrez88Ny37mqyLO7sJ+rq16kS6sGAb4pRAEzCPwlLgTy4nnLfxHPeiWyIdIyS3SFO0MWdpWz3aCuIRVbGGM7E2/IE/bixPUFrN1F3kKmW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=x04yMWtK; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7da6ca0f1acso192377585a.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1752068830; x=1752673630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkQL/QnW0HIaHElVDSrszmZZE65FaoB07Pptz0kqcu0=;
        b=x04yMWtKFM8qNoCoSCy2vKrib3RJptjSUidYtXG6Dv9VFsY1MEPUbjfaE5oJJeyNJT
         VhzDYiKF6J4rCeONhzOFaSgXOTkSvq+tssxgVaDgC2p7SGoVKYFv+bjY7rpx3b2WJEa6
         f0/S4kW+RUTGHxF5cnLsYm2TEPiPzum22be0PWMG+DH9VW8q5BEy3z30tmtPupErsLdq
         3gO++9MuPEI3gpD1Mcjyi/q2zZBDXt1wLJGkYHPcFn31gm8Hz05HPprybP/QGBVcIfF8
         1aZ+kshi2sl7Vyg0qlA+ZIRFljaJAbf9aReINoe97OrqmIVls+MvDjKC4MyEDgeocQEg
         L1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752068830; x=1752673630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkQL/QnW0HIaHElVDSrszmZZE65FaoB07Pptz0kqcu0=;
        b=D82OheScG/tLWIX8pd3H9E4qS4a2noUHpyeI8zM59ouSUkp2zpkytAdeGMOw/D0afl
         OtdCqBbZU8ktPOebD/vdgzlzKZ+tE0nFTsOVLMj0U4z72OFsLU6Hhqjl/C7CFoaudCaJ
         9E2GQqW2bVW21Z/lLAaDN6WGS71MykUkhZGAqUjKvITs81Dey7aJronk3SkG2tg/jOG4
         aGYdOeBSU7TktI093VaiazUidYT8Riq3s1DOY3U8Neqf89izVm/lu5lESKM4oniTJo8n
         tAwTvHJyaY+4i33HKCM0y9nwKlgKqrXvFWXCHRq5QPVIzT6OhEFdWcHqVtsip7dt2k2V
         L4hw==
X-Gm-Message-State: AOJu0YzyM7HL7oWIimdVxQjSFm+u0oiAlqhPFWh6lR6YHwzsfjAFa17B
	um0R+zDkzHhzBdlMA07vUS49/QQNUVdqYSV54DvAIEyvz9hz7cNo+17vC2zAKGtU0w4984fE8Wu
	1P6xT
X-Gm-Gg: ASbGnctsHfcXt/4BKU5GJLhrQdj45WnP4BT5gQgBetlnlN9Sd3heFl9lJx1/bTZP9Xh
	NzbYMGi25gHjHOpa7x1py4qY4ZCBI318iXCZEXZGmElnQxkiRKLsC60mXGoPKiL5HtRYBpzbAO4
	3mcqNhLp/83oYLbomXqAcLCkh3OBlOpcyuQyfNzN1WeEp6wwnBMvDPOff9KbS2oAjWukktMWeIE
	W06vkMdj/GVh5SJ6aqwUUZ8eE+SzpC0Rbwe/ixvMO1LCzYaQgIoh5oMaE2RunDVIZZF/hCieNfT
	aLNVpjDL/JGfaO9TcGRBPtUGd81e0YXlibUlbh85HFUfJl5qLCEImyLxZqYSOo1Y2t4mw4IUCg9
	RmJwyWCOMXwe01pN8IV1z4eZwNxKNGLEvzNFFrcPvv/D5BuT3un4=
X-Google-Smtp-Source: AGHT+IF6EabVBfNj9TyCGaqSVgiR7S7smfJ0nR0CAviq3h0164unEH7TrL4vBL/kFHbWctB/IwCQcA==
X-Received: by 2002:a05:620a:2544:b0:7d5:d0a1:c907 with SMTP id af79cd13be357-7db7cfa32f5mr370206385a.30.1752068829670;
        Wed, 09 Jul 2025 06:47:09 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d5dbdb5088sm937846285a.25.2025.07.09.06.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 06:47:09 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 2/2] riscv: lib: Add sbi-exit-code to configure and environment
Date: Wed,  9 Jul 2025 06:47:07 -0700
Message-ID: <20250709134707.1931882-2-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250709134707.1931882-1-jesse@rivosinc.com>
References: <20250709134707.1931882-1-jesse@rivosinc.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
V1 -> V2:
 - Factor out commonly used macros to new commit
 - Use ternary operator over if
V2 -> V3:
 - No changes
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


