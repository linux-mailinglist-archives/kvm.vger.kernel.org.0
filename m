Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB03041614E
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbhIWOp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:29 -0400
Received: from foss.arm.com ([217.140.110.172]:35528 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241773AbhIWOp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E45BCD6E;
        Thu, 23 Sep 2021 07:43:54 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DECCD3F718;
        Thu, 23 Sep 2021 07:43:53 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 07/10] Add --nodefaults command line argument
Date:   Thu, 23 Sep 2021 15:45:02 +0100
Message-Id: <20210923144505.60776-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool attempts to make it as easier as possible on the user to run a VM
by doing a few different things: it tries to create a rootfs filesystem in
a directory if not disk or initrd is set by the user, and it adds various
parameters to the kernel command line based on the VM configuration
options.

While this is generally very useful, today there isn't any way for the user
to prohibit this behaviour, even though there are situations where this
might not be desirable, like, for example: loading something which is not a
kernel (kvm-unit-tests comes to mind, which expects test parameters on the
kernel command line); the kernel has a built-in initramfs and there is no
need to generate the root filesystem, or it not possible; and what is
probably the most important use case, when the user is actively trying to
break things for testing purposes.

Add a --nodefaults command line argument which disables everything that
cannot be disabled via another command line switch. The purpose of this
knob is not to disable the default options for arguments that can be set
via the kvmtool command line, but rather to inhibit behaviour that cannot
be disabled otherwise.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/fdt.c                |  3 ++-
 builtin-run.c            | 13 +++++++++++--
 include/kvm/kvm-config.h |  1 +
 mips/kvm.c               |  3 ++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 7032985e99a3..635de7f27fa5 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -136,9 +136,10 @@ static int setup_fdt(struct kvm *kvm)
 		if (kvm->cfg.kernel_cmdline)
 			_FDT(fdt_property_string(fdt, "bootargs",
 						 kvm->cfg.kernel_cmdline));
-	} else
+	} else if (kvm->cfg.real_cmdline) {
 		_FDT(fdt_property_string(fdt, "bootargs",
 					 kvm->cfg.real_cmdline));
+	}
 
 	_FDT(fdt_property_u64(fdt, "kaslr-seed", kvm->cfg.arch.kaslr_seed));
 	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
diff --git a/builtin-run.c b/builtin-run.c
index 478b5a95b726..9a1a0c1fa6fb 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -108,6 +108,9 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_BOOLEAN('\0', "sdl", &(cfg)->sdl, "Enable SDL framebuffer"),\
 	OPT_BOOLEAN('\0', "rng", &(cfg)->virtio_rng, "Enable virtio"	\
 			" Random Number Generator"),			\
+	OPT_BOOLEAN('\0', "nodefaults", &(cfg)->nodefaults, "Disable"   \
+			" implicit configuration that cannot be"	\
+			" disabled otherwise"),				\
 	OPT_CALLBACK('\0', "9p", NULL, "dir_to_share,tag_name",		\
 		     "Enable virtio 9p to share files between host and"	\
 		     " guest", virtio_9p_rootdir_parser, kvm),		\
@@ -642,7 +645,10 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 		}
 	}
 
-	if (!kvm->cfg.using_rootfs && !kvm->cfg.disk_image[0].filename && !kvm->cfg.initrd_filename) {
+	if (!kvm->cfg.nodefaults &&
+	    !kvm->cfg.using_rootfs &&
+	    !kvm->cfg.disk_image[0].filename &&
+	    !kvm->cfg.initrd_filename) {
 		char tmp[PATH_MAX];
 
 		kvm_setup_create_new(kvm->cfg.custom_rootfs_name);
@@ -662,7 +668,10 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 			die("Failed to setup init for guest.");
 	}
 
-	kvm_run_set_real_cmdline(kvm);
+	if (kvm->cfg.nodefaults)
+		kvm->cfg.real_cmdline = kvm->cfg.kernel_cmdline;
+	else
+		kvm_run_set_real_cmdline(kvm);
 
 	if (kvm->cfg.kernel_filename) {
 		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 35d45c0f7ab1..6a5720c4c7d4 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -27,6 +27,7 @@ struct kvm_config {
 	u8 num_vfio_devices;
 	u64 vsock_cid;
 	bool virtio_rng;
+	bool nodefaults;
 	int active_console;
 	int debug_iodelay;
 	int nrcpus;
diff --git a/mips/kvm.c b/mips/kvm.c
index e110e5d5de8a..3470dbb2e433 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -131,7 +131,8 @@ static void kvm__mips_install_cmdline(struct kvm *kvm)
 			(unsigned long long)kvm->ram_size - KVM_MMIO_START,
 			(unsigned long long)(KVM_MMIO_START + KVM_MMIO_SIZE));
 
-	strcat(p + cmdline_offset, kvm->cfg.real_cmdline); /* maximum size is 2K */
+	if (kvm->cfg.real_cmdline)
+		strcat(p + cmdline_offset, kvm->cfg.real_cmdline); /* maximum size is 2K */
 
 	while (p[cmdline_offset]) {
 		if (!isspace(p[cmdline_offset])) {
-- 
2.31.1

