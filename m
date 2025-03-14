Return-Path: <kvm+bounces-41081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2152A6154D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E457A7AD1F5
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE0B202992;
	Fri, 14 Mar 2025 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r10WKUZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63F2202C2D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967481; cv=none; b=g9Oa6fuanapOFFAZyq63vK0KbxFiKFJPy/q/PUufRWXBftppMm4g+pGa8sGYUpYgXCyvr9w9se31QvJAxAjPR5iOi3UDBfURgRFjpRDcAvqSCMea++bXsmd+seYrUVjN6q8maOTUFlxwl922A08x+TV9znTLHBZwbailScHmNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967481; c=relaxed/simple;
	bh=EkpO5sHjJ3k0w3GcR85plkff9xr8C3dB7U2UpNDrtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKZouMvp+CcoolguNnZzf7fUZwEpbDdE9kC0Y3Pi7tpRI+O/lHygTFj/Wp7Wl8KnCX6VDo6l20dmmB3xLs3cwrtam3RRbGHGmAnE0Wjeydxi0PsZ7A8wVMQ0znG7PsmeLowPQWMM3KHtmKNMlvscbH2lKMzp+8Lq5tz5xpN/AWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r10WKUZ4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso21222385e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967477; x=1742572277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0zGO9xjg0JJPs4PFAX2msz/3yAP4xRZn7yO7s54uDo=;
        b=r10WKUZ4HKNqn5LbljXd80ZVRg0YklkL02nv+YnZyLTneQVH2rwjWI5npwlzunL00k
         bQl3XpiM+Bz5BM0+yH8MCJs1cVg+TR5lH6R3ySJJVjYqfvmHx3lzx7tMc+txCQT3fHaK
         w4TlrMajz9YHBCOPPWvGlIA/5WODZ+NkMDtSADzVLQAyarH5Q09njytb8cE0zK3Y0MON
         x/mEQVkk8zN7HnJhEcI33NyjES/OFxOYajZZrf5SmojKHNwrmAJcYgbn7qF4jT0hCshx
         50szhzeeDIi6wX/vWEwuRuukH0hUzeB0MHG2KtYnEB3XDL9RFDiG57nIRDx2p/d4eUIy
         TjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967477; x=1742572277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0zGO9xjg0JJPs4PFAX2msz/3yAP4xRZn7yO7s54uDo=;
        b=SB84CgxVscGJ2pNwuIfQUSRvaeZkU0nYT4FRGsGE++u2+bji8wjUeqzoe4+ixTodKX
         a0fohyohP7YuceVHBWDNN7KKRY6fWUhNdNzDv7ie98bXbKj3hPoITNZ0Mvl6Pi0DIRST
         7c/zh/5aG1H+wqGKonD8Cnopxn1VO5LO2MDItGwC3RO1U3zP55K32INWaXkgYgVP5KDc
         pQqS39UT3kMPfYgJuuoiHMsiDnEtikz/C733QiwMBabnJLsmcR8zkrzYcijTL8qsN9sH
         AASUDaVis9Vw+qN8NbYzHBHNBPwIjUSb/m6qtDQDnf4G1Yh1RilcFUZPBlXjdvSJ0FHn
         ciQA==
X-Forwarded-Encrypted: i=1; AJvYcCWvsynpt3CO6yQ6/2rcyJMOB3v4NAE0RiIQ2RlTkkk4ifPmJFq//6xtMJWVZlUnJ6GrWSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZpDCeUOmtrAdMzpcmCjNwf/vZZ5id4JWrUo22mqF3z+iMGJES
	rzmrN3d/z4kzBEt10mc+Uzf8Fb4yNAPMM1Bnd7eGYWyb67gKed1x1sLRoBTW4uiApHeoWdIDDUI
	szIo=
X-Gm-Gg: ASbGncsP3BHIXLvXilyUzOeaza9w/2fqt/E9tipLnowwq0yzmhNbPiIq9+a3gFwIZ5V
	swstfRus24buwtJrh+AZdHrK1vNvYMEiJ/x1XBN9/NgHBZShc3GfO5pa9eBKPmfI2qQvkB5h3mL
	oJk7Cm7+Ijfj1gX+arP9lBMCUAYvp/QmLxUyiYhSdBI+LEZ2YyK7eJAMdxHo3dJyHuAZZeYRuO6
	Btc7+AYDL+k96FWdgzL/Lc5yUhNfrQ1MD+dwG1RN4swgYqvjFhgZv1lUKdpu7Dzq1Bc6txhgGau
	d2V74nlik8fpqiKN7Bmpnffevcp84KobL9KRuEYe8dmsDMXlNaaIEI7TEYyVJMw=
X-Google-Smtp-Source: AGHT+IECh7v7OK/v5EHEcUY4C0dtwmYasbITKNCuGAGjy0H2BYksZDgS5IwiyYO2BbZMuCf+xK8yVw==
X-Received: by 2002:a5d:6481:0:b0:38d:ca55:76c3 with SMTP id ffacd0b85a97d-3971cd57ed1mr4057887f8f.11.1741967476931;
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Date: Fri, 14 Mar 2025 15:49:04 +0000
Message-ID: <20250314154904.3946484-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
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
modify the CPU capabilities by setting extra -cpu options.
Since GCC -mcpu doesn't accept "max" or "host", separate the compiler
and QEMU arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $QEMU_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  2 +-
 arm/run                 | 17 +++++++++++------
 riscv/run               |  8 ++++----
 configure               |  7 +++++++
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..6b5f725d 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,7 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..561bafab 100755
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
@@ -37,12 +37,17 @@ if [ "$ACCEL" = "kvm" ]; then
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
+	elif [ "$ARCH" = "arm64" ]; then
+		qemu_cpu="cortex-a57"
+	else
+		qemu_cpu="cortex-a15"
 	fi
 fi
 
@@ -71,7 +76,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
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
index 5306bad3..d25bd23e 100755
--- a/configure
+++ b/configure
@@ -52,6 +52,7 @@ page_size=
 earlycon=
 efi=
 efi_direct=
+qemu_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -69,6 +70,8 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
+	                           the configuration, usually it is "host" or "max".
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -142,6 +145,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--qemu-cpu)
+	    qemu_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -464,6 +470,7 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+QEMU_CPU=$qemu_cpu
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.48.1


