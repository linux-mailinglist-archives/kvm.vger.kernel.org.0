Return-Path: <kvm+bounces-45719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6ABBAAE40F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCC7F1C057C2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B7E28A3EF;
	Wed,  7 May 2025 15:13:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C1628A407;
	Wed,  7 May 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630806; cv=none; b=m4fTgmFmg40kvilQ1csRuHqmUgCWVAA4T+QzJwVGRl2MIZqFLk4ZEGL+/Ar+9/vFR2Q9/mLy5H2XXEn4Zs3XCxV9gP5ySHSWnex6WLuRaOKSjcdtHsET5dUQ1r0uvtf7qQZ0vIfGU3Ew60DtbXX5w8PapEhBKi/oJmT+Z/0BogA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630806; c=relaxed/simple;
	bh=ISlXdwP1cjI+rEHEuN7EKhsNePmU54r3Si9TtE2Fs0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7JwHf3EYb6mN0f4GYL+1uJXVAyDfvgmEYE6ZPtjtsqmsiMHl8fXoURpxBo1JRpwyyDwEn/VWr9+uQc5YP42j1rjpzQsYviavkAQ/f4C0754EJS8rz8kd/XpWBM68RUBUzKGmmoGApuVP8glGyoX4aMruBJZArhjPUOEikYBb7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 035DE204C;
	Wed,  7 May 2025 08:13:14 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9D4C3F58B;
	Wed,  7 May 2025 08:13:20 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 03/16] configure: Export TARGET unconditionally
Date: Wed,  7 May 2025 16:12:43 +0100
Message-ID: <20250507151256.167769-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only arm and arm64 are allowed to set --target to kvmtool; the rest of the
architectures can only set --target to 'qemu', which is also the default.

Needed to make the changes necessary to add support for kvmtool to the test
runner.

kvmtool also supports running the riscv tests, so it's not outside of the
realm of the possibily for the riscv tests to get support for kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/configure b/configure
index 20bf5042cb9e..8c4400db42bc 100755
--- a/configure
+++ b/configure
@@ -38,6 +38,21 @@ function get_default_qemu_cpu()
     esac
 }
 
+# Return the targets that the architecture supports
+function get_supported_targets()
+{
+    local arch=$1
+
+    case "$arch" in
+    "arm" | "arm64" | "aarch64")
+        echo "qemu kvmtool"
+	;;
+    *)
+        echo "qemu"
+	;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -79,6 +94,7 @@ fi
 usage() {
     [ "$arch" = "aarch64" ] && arch="arm64"
     [ -z "$processor" ] && processor=$(get_default_processor $arch)
+    [ -z $target ] && target=qemu
     cat <<-EOF
 	Usage: $0 [options]
 
@@ -89,8 +105,8 @@ usage() {
 	    --target-cpu=CPU       the CPU model to run on. If left unset, the run script
 	                           selects the best value based on the host system and the
 	                           test configuration.
-	    --target=TARGET        target platform that the tests will be running on (qemu or
-	                           kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on ($target).
+	                           Supported targets: $(get_supported_targets $arch)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC                c compiler to use ($cc)
 	    --cflags=FLAGS         extra options to be passed to the c compiler
@@ -281,13 +297,11 @@ if [ "$arch" = "riscv" ]; then
     exit 1
 fi
 
-if [ -z "$target" ]; then
-    target="qemu"
-else
-    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
-        echo "--target is not supported for $arch"
-        usage
-    fi
+if [ -z $target ]; then
+    target=qemu
+elif ! grep -Fq " $target " <<< " $(get_supported_targets $arch) "; then
+    echo "Target $target is not supported for $arch"
+    usage
 fi
 
 if [ "$efi" ] && [ "$arch" != "x86_64" ] &&
@@ -519,10 +533,8 @@ CONFIG_EFI=$efi
 EFI_DIRECT=$efi_direct
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
+TARGET=$target
 EOF
-if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
-    echo "TARGET=$target" >> config.mak
-fi
 
 cat <<EOF > lib/config.h
 #ifndef _CONFIG_H_
-- 
2.49.0


