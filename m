Return-Path: <kvm+bounces-36045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC89A1707D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29378188A478
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08391EE7A7;
	Mon, 20 Jan 2025 16:44:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5BE1EC00C;
	Mon, 20 Jan 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391456; cv=none; b=Ebw+5oodMU3BJpmJVNjQ/JWVQGoOk1kzOrjwJKdNPF1FtQO4Z7evHC/X7cMWPanfpMWkN9oqI1hQYAflkpKtqxeKtNPjPIUH+PJ1/sEUmR9Li0RoMBTSqVXJpU1PP00fVxZECt4EcXlMjmrOlKJbTrYQrpCbPFUPj0Wk2/pIM58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391456; c=relaxed/simple;
	bh=5hc11jVUYcRqIGXyoCokB29PqbSsKoLTBuLj1/HgG7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWoG95tb00CEmXub7QzX9uSYDiOXBEjLWcul97hL4HjBSaUrraBYfppN/PXcKFaMa/CPtrVRMWEwrUqjE/i83LtOg9wF2LgnNyK6tVcjn4H/TUS9JNLPJ1VoXzBxx3sIzrBVYjBmGUfdl59oEjrlwJvOcEFUqtUvrr21N7l/m74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FDAE1063;
	Mon, 20 Jan 2025 08:44:42 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E59EC3F5A1;
	Mon, 20 Jan 2025 08:44:10 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 12/18] scripts/runtime: Add default arguments for kvmtool
Date: Mon, 20 Jan 2025 16:43:10 +0000
Message-ID: <20250120164316.31473-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvmtool, unless told otherwise, will do its best to make sure that a kernel
successfully boots in a virtual machine. Among things like automatically
creating a rootfs, it also adds extra parameters to the kernel command
line. This is actively harmful to kvm-unit-tests, because some tests parse
the kernel command line and they will fail if they encounter the options
added by kvmtool.

Fortunately for us, kvmtool commit 5613ae26b998 ("Add --nodefaults command
line argument") addded the --nodefaults kvmtool parameter which disables
all the implicit virtual machine configuration that cannot be disabled by
using other parameters, like modifying the kernel command line. Always use
--nodefaults to allow a test to run.

kvmtool can be too verbose when running a virtual machine, and this is
controlled with parameters. Add those to the default kvmtool command line
to reduce this verbosity to a minimum.

Before:

$ vm run arm/selftest.flat --cpus 2 --mem 256 --params "setup smp=2 mem=256"
  Info: # lkvm run -k arm/selftest.flat -m 256 -c 2 --name guest-5035
Unknown subtest

EXIT: STATUS=127
  Warning: KVM compatibility warning.
	virtio-9p device was not detected.
	While you have requested a virtio-9p device, the guest kernel did not initialize it.
	Please make sure that the guest kernel was compiled with CONFIG_NET_9P_VIRTIO=y enabled in .config.
  Warning: KVM compatibility warning.
	virtio-net device was not detected.
	While you have requested a virtio-net device, the guest kernel did not initialize it.
	Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.
  Info: KVM session ended normally.

After:

$ vm run arm/selftest.flat --nodefaults --network mode=none --loglevel=warning --cpus 2 --mem 256 --params "setup smp=2 mem=256"
PASS: selftest: setup: smp: number of CPUs matches expectation
INFO: selftest: setup: smp: found 2 CPUs
PASS: selftest: setup: mem: memory size matches expectation
INFO: selftest: setup: mem: found 256 MB
SUMMARY: 2 tests

EXIT: STATUS=1

Note that KVMTOOL_DEFAULT_OPTS can be overwritten by an environment
variable with the same name, but it's not documented in the help string for
run_tests.sh. This has been done on purpose, since overwritting
KVMTOOL_DEFAULT_OPTS should only be necessary for debugging or development
purposes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/runtime.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 55d58eef9c7c..abfd1e67b2ef 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -2,6 +2,17 @@
 : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
 : "${TIMEOUT:=90s}"
 
+# The following parameters are enabled by default when running a test with
+# kvmtool:
+# --nodefaults: suppress VM configuration that cannot be disabled otherwise
+#               (like modifying the supplied kernel command line). Tests that
+#               use the command line will fail without this parameter.
+# --network mode=none: do not create a network device. kvmtool tries to help the
+#                user by automatically create one, and then prints a warning
+#                when the VM terminates if the device hasn't been initialized.
+# --loglevel=warning: reduce verbosity
+: "${KVMTOOL_DEFAULT_OPTS:="--nodefaults --network mode=none --loglevel=warning"}"
+
 PASS() { echo -ne "\e[32mPASS\e[0m"; }
 SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
 FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
@@ -103,7 +114,7 @@ function run()
         opts="-smp $smp $qemu_opts"
         ;;
     kvmtool)
-        opts="--cpus $smp $kvmtool_opts"
+        opts="$KVMTOOL_DEFAULT_OPTS --cpus $smp $kvmtool_opts"
         ;;
     esac
 
-- 
2.47.1


