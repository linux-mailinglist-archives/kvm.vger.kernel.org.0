Return-Path: <kvm+bounces-42941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D74F6A80C22
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9063B1BC462B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D3E18CC15;
	Tue,  8 Apr 2025 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q1tP3FZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3066A009
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118469; cv=none; b=t8uheJzPkwJmXqjfKiI+JSeW0KdWze8O8UK/aTBs9KmNRW2Fo3RTcX4TOFNn2oW4v5fB9nsyFflV7eKH9AYoCRAHV5c9Ilz5ii3492o/cuGMD7pArErB/PSIvl3o4tlzsA9SHi5dGuSRRQtwOg5Tkc54+1dk4cABR8+ZJwoYvRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118469; c=relaxed/simple;
	bh=IN7VS19lwIj4mFtoPVwDHThAtfSDM5hBoBnjzalsMKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0kU3KpVF8k4LDKqhwVyegO4xPgxkdA8UU6RE9ysy9BICOn9gR4CSGF6OW00JPz1ztpHpff/ADKXMeB5A4pdvsvaOgNnxAHnEv+WmFS30E8TjUEq3uVFaBeBlhJPBlVikAYRXqoQ2MAM40wkR6kzvzv9xMZT9zzlww/uhoOXkrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q1tP3FZ1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so36077825e9.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118465; x=1744723265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOPA2fmXPhp0g7ThkLsi+uZYdZ8vnNqs5fSRtuJQXEs=;
        b=Q1tP3FZ1kiihFA24tLyWoVd89s7E0fkrJL6xFPAwTxcU7QLZ4dhNffYAoog7iFoPLc
         5s5RohNOL30+BZtOe5Ra7eD5LNEkubrpEmAyKHhcXSjbMJnKIdTZGCVnGIXbi4H81B7Q
         j191zGTENrefDESLwXPwLnN49dyDopl7/5ZL20Nm0h16p2Y/rRLZer3N28Cecob9BnpY
         AOcr1m+hPJPxZ7c4v91ui/HuGrZiIaTAigRGyw4OM2HOuShk5TJDoe9X4Hpv7bB3V/Bl
         86QAgY2YwSLX1PJWCQUTrBiMysrb11lXbbZ3O+opEOk6rJezpiBSR1w8wUxybWAYJ8uh
         oGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118465; x=1744723265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOPA2fmXPhp0g7ThkLsi+uZYdZ8vnNqs5fSRtuJQXEs=;
        b=unOYHI8gl0WQ2qHsHXPcVXwJwNPfkq2mtYnUJoJ5HjjndgmbFCYUR9TOUhLowtJb4G
         oxWDAIVPXOv3SRV1eHpJNuZnLdglEngfvWH/gPzsprvw1EY2OkKKya7qoCdR4w3FFUKh
         Cu7oUTFyMh7+5gIl0sV0v2aVorVwBrXqpmXgMyO3wu7HYBLAR3D+0iDP89C49eg40uaL
         2jvWOIsZ+h9KJCXib+PQBcrMV3X7VISijNfAahDUiIfWI1NssSO3EE4aTXnkGr+GONGA
         EeQFunI3ITTN/zaN0bpU0pc3WUYc+d5JE8jSylnB2nb8JVp1aVWcXcgyKMJf1Sxn96tc
         nKIA==
X-Forwarded-Encrypted: i=1; AJvYcCXxayRyLkV0ny1IGRQb0UqoTujaI93yNpkZVOXZwWycTYcLtcYar59qeliIQzXpJOgnkCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNLMnN8/WJMTyJndFOCWRJG7uFmoIaGBycEYZduR1urEr8pqXS
	r9AqEY7sfxM1cehQfBe+MHdKwYAXTiuZs7THZ2VKbU95U+wJA5y/Ya5dL6L50f4=
X-Gm-Gg: ASbGncu6nHXndEqjUBPSbNpSFfgzT/AI0LAMyLR6vD4v4Pj6og8Uy2gbT+/cV9vqUrm
	JxFLAq/rX8a0S2qRd3K2xKGGiXLqrjj+40iXaEiNOM6BRkA0cK2utbjMpO/a5RsxWII5zqn7IKt
	sTmmms7td5mcjVdHSoITZQd7p9pbWPxflbOZBdNB9pKmukf2yjUAPCdbE2O5LVNBCZ7z1xRvxiC
	+70mkw+PZCAwAsZssXgIFgB6qlfW6Oq7OM9sYHSO2VLM1jiuEWt48E8gN+o949901iqGCxDNAer
	JY1yNmrUT40K6XM+mL5lsHt9uDfPcgxTT77626CZmMlUaQfj0Tn3FYol3eYU6MU=
X-Google-Smtp-Source: AGHT+IEEYzGOKHN6r46LzVByJFbW7i8YbDNKMzXqurwCu8CRJ0JfLsDForarjYS/wFNxfVFVo9a5Nw==
X-Received: by 2002:a05:600c:524c:b0:43c:e70d:44f0 with SMTP id 5b1f17b1804b1-43f1890857emr9390535e9.19.1744118464779;
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 4/5] configure: Add --target-cpu option
Date: Tue,  8 Apr 2025 14:20:53 +0100
Message-ID: <20250408132053.2397018-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the --target-cpu option to let users set the CPU type to run on.
At the moment --processor allows to set both GCC -mcpu flag and QEMU
-cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
the TCG features by default, and it could also be nice to let users
modify the CPU capabilities by setting extra -cpu options. Since GCC
-mcpu doesn't accept "max" or "host", separate the compiler and QEMU
arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $TARGET_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 +++++++++------
 riscv/run               |  8 ++++----
 configure               | 27 +++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..c4ba81f1 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,8 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export TARGET_CPU
+	config_export DEFAULT_QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..ef585582 100755
--- a/arm/run
+++ b/arm/run
@@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source config.mak
 	source scripts/arch-run.bash
 fi
-processor="$PROCESSOR"
+qemu_cpu="$TARGET_CPU"
 
 if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
    [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
@@ -37,12 +37,15 @@ if [ "$ACCEL" = "kvm" ]; then
 	fi
 fi
 
-if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
-	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
-		processor="host"
+if [ -z "$qemu_cpu" ]; then
+	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
+	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
+		qemu_cpu="host"
 		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
-			processor+=",aarch64=off"
+			qemu_cpu+=",aarch64=off"
 		fi
+	else
+		qemu_cpu="$DEFAULT_QEMU_CPU"
 	fi
 fi
 
@@ -71,7 +74,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
 fi
 
 A="-accel $ACCEL$ACCEL_PROPS"
-command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
+command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
diff --git a/riscv/run b/riscv/run
index e2f5a922..2bd42ad8 100755
--- a/riscv/run
+++ b/riscv/run
@@ -11,12 +11,12 @@ fi
 
 # Allow user overrides of some config.mak variables
 mach=$MACHINE_OVERRIDE
-processor=$PROCESSOR_OVERRIDE
+qemu_cpu=$QEMU_CPU_OVERRIDE
 firmware=$FIRMWARE_OVERRIDE
 
-[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
 : "${mach:=virt}"
-: "${processor:=$PROCESSOR}"
+: "${qemu_cpu:=$TARGET_CPU}"
+: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
 : "${firmware:=$FIRMWARE}"
 [ "$firmware" ] && firmware="-bios $firmware"
 
@@ -32,7 +32,7 @@ fi
 mach="-machine $mach"
 
 command="$qemu -nodefaults -nographic -serial mon:stdio"
-command+=" $mach $acc $firmware -cpu $processor "
+command+=" $mach $acc $firmware -cpu $qemu_cpu "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
diff --git a/configure b/configure
index b4875ef3..63367bbc 100755
--- a/configure
+++ b/configure
@@ -23,6 +23,24 @@ function get_default_processor()
     esac
 }
 
+# Return the default CPU type to run on
+function get_default_qemu_cpu()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        echo "cortex-a15"
+        ;;
+    "arm64")
+        echo "cortex-a57"
+        ;;
+    "riscv32" | "riscv64")
+        echo "max"
+        ;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -52,6 +70,7 @@ earlycon=
 console=
 efi=
 efi_direct=
+target_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -70,6 +89,9 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --target-cpu=CPU       the CPU model to run on. If left unset, the run script
+	                           selects the best value based on the host system and the
+	                           test configuration.
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -146,6 +168,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--target-cpu)
+	    target_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -471,6 +496,8 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+TARGET_CPU=$target_cpu
+DEFAULT_QEMU_CPU=$(get_default_qemu_cpu $arch)
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.49.0


