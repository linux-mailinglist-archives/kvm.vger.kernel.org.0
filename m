Return-Path: <kvm+bounces-41980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 868E3A70612
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74CBF3A4C16
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2E925D1EA;
	Tue, 25 Mar 2025 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="js5X00Bc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DFE1F4CB7
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918875; cv=none; b=hJ/z9cMMyLS/F9k1r22hxkFE8yhC+nY6BdFgOr781NTGHlJCP6dhlHFV34rl2DG8EyiVql/axdpPIsEKm0Q6Ldu1vADMc6/N5dO7Q2+QiR4seO2stV2onqfIbpv/w4J6/IVNpWk6MKyfoI/yDgoWpIo13ZpRsvDp+Y/0gYtsw/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918875; c=relaxed/simple;
	bh=deGWWrRabN2BUuESzK6sCMhIniOcxImAkRg9Tz3X9gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU7MzrzrcF6Rt3E8+EAqJ+6SRKPkqS4g8eGjSipDYYorVT+ykZu2c49S4pdmYmRabBeF8MAqWPR7fLgYfw6nk9HGcYWJ8Tq98e9GjDLh5qrFcIFAG/2lzS407yEY/GcypQ9i1/DL/tcsfI9vYF4ecKZo14cGgfRAGtLlrznlYpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=js5X00Bc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf680d351so40766835e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918872; x=1743523672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6v4oWjxs3w2OXtl8okLU3CaHVHPFgAaN27M8fJJ3JPw=;
        b=js5X00BcA5WSrR4SDEqoco5On0k7LTWnZBdzDg5Bxa7PUT8G+nf89Vc8TFspvol75h
         w/CLF2b6bZSi48Aoo3fCBp9PklgRKegrACGkvsrG3fBg7bD4fmlGyHxLUxfVpjnwqUNs
         x4OOU+oR9J0uuwEA1CFgs7xkg1b2Fod8inINBO15YuZR9iPCFkc+AohMVut4VFHOW9aN
         TyAEbjXFljisF7Ty9LunJ2X1+uPn16zpnVUDWFMz5AiSj9IrKOZ0H/B6sUtS0oEvvhJR
         Cf9PqiPtk9zJ+kEZyNN7LKxOiBJF2yXwxEVcKEt9b+r2VBn2riRhZ9YC4+Y9yTrktTWa
         Ey6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918872; x=1743523672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6v4oWjxs3w2OXtl8okLU3CaHVHPFgAaN27M8fJJ3JPw=;
        b=DWNtQrjYiebbswCLISfxpP0hlged4N822UNuHOV3JMPXiAaVx2vTSCSwd+rbrILbRN
         0h8oDTnMc81o+bBdo1LFeYSAiyvx0lcLJX4xu5suey6+/iJevOO0oeqVuLHgevz06p+f
         Bveq9eMdchSG7khhutFW/AHbCXfj2J0ftx+z0c5oM1j7usQzDrcPcbJmxym2xFc/lhEy
         HQgX+s/+CT0IPlC2co1rGKNZmPuZ6jQyFxRLD+iUJxm8F+Fwaagnr6JOGMOC6L7S8rIJ
         7ifAU/5J5g94xFCDdlzFsYVGir/4mZ68gJudZlshscCx0MD6icmMpBBMfQ1f73dEIP0C
         FOug==
X-Forwarded-Encrypted: i=1; AJvYcCWeFWYP1kZrJD6uy3No3A092cZjrmZjK4IcN6YwrXtpXRqsvt1kbR0IlqvXGjfoynKcEk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YybOkmA0irI6l6FTRFzHF5p4ozE2gUolSfTcoJ79LHpH5VMzuIL
	vyzmFoUtjI61VK7YiHWRdv7LE5A/2R04QIbWYZcX7caqH7EvC/r4OeOE5ny2A7g=
X-Gm-Gg: ASbGncsLEHRJTGi7Hba4mfjwyxwk7t2YCFDJgLgCbu21tzu5qQmfDvCOeNn6iIgWNR7
	yv017mnm8GJktou4hni2QHxe4ozYv8E1ibJ7/ZrV/AHx2v/Et9Vbd8yu9mfKrOKQ97P+0ZIou6E
	QhtGGom0ggeb0nw39x4JlqQny4vXD4oW0A5I6mhPXlUzYLZ9EK48a9c15Vkl6Lky0fMngGCzadt
	s4JqW+hTMGKW7aFptyt3Qb3uK9sy3s78hpojWNGce3bUenHuKTqZJkYl1q8wBW0Z9yyPPbh+6r2
	znlfbLjMFM4uzuBjGVHOmy+Ncr43xovu9/yrtFNXcnwLE6eao1mjWt0Q0xMyGkL/7eQnek1sYQ=
	=
X-Google-Smtp-Source: AGHT+IHMqhvbDDmS/MsUebAwQrnmnrLCj1L6a/nkr+ekAH/NHss4lv/QGFSzm78I2k54eI/LtzmFrw==
X-Received: by 2002:a05:600c:1d01:b0:439:8878:5029 with SMTP id 5b1f17b1804b1-43d77547ecbmr3550045e9.2.1742918871939;
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 4/5] configure: Add --qemu-cpu option
Date: Tue, 25 Mar 2025 16:00:32 +0000
Message-ID: <20250325160031.2390504-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the --qemu-cpu option to let users set the CPU type to run on.
At the moment --processor allows to set both GCC -mcpu flag and QEMU
-cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
the TCG features by default, and it could also be nice to let users
modify the CPU capabilities by setting extra -cpu options.  Since GCC
-mcpu doesn't accept "max" or "host", separate the compiler and QEMU
arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $QEMU_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 +++++++++------
 riscv/run               |  8 ++++----
 configure               | 24 ++++++++++++++++++++++++
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..9b4f983d 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,8 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export QEMU_CPU
+	config_export DEFAULT_QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..4675398f 100755
--- a/arm/run
+++ b/arm/run
@@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source config.mak
 	source scripts/arch-run.bash
 fi
-processor="$PROCESSOR"
+qemu_cpu="$QEMU_CPU"
 
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
index e2f5a922..02fcf0c0 100755
--- a/riscv/run
+++ b/riscv/run
@@ -11,12 +11,12 @@ fi
 
 # Allow user overrides of some config.mak variables
 mach=$MACHINE_OVERRIDE
-processor=$PROCESSOR_OVERRIDE
+qemu_cpu=$QEMU_CPU_OVERRIDE
 firmware=$FIRMWARE_OVERRIDE
 
-[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
+[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
 : "${mach:=virt}"
-: "${processor:=$PROCESSOR}"
+: "${qemu_cpu:=$QEMU_CPU}"
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
index b4875ef3..b79145a5 100755
--- a/configure
+++ b/configure
@@ -23,6 +23,21 @@ function get_default_processor()
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
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -52,6 +67,7 @@ earlycon=
 console=
 efi=
 efi_direct=
+qemu_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -70,6 +86,9 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --qemu-cpu=CPU         the CPU model to run on. If left unset, the run script
+	                           selects the best value based on the host system and the
+	                           test configuration.
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -146,6 +165,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--qemu-cpu)
+	    qemu_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -471,6 +493,8 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+QEMU_CPU=$qemu_cpu
+DEFAULT_QEMU_CPU=$(get_default_qemu_cpu $arch)
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.49.0


