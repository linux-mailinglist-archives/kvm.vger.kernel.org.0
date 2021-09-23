Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50DB41614A
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhIWOpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:23 -0400
Received: from foss.arm.com ([217.140.110.172]:35502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241707AbhIWOpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C992113E;
        Thu, 23 Sep 2021 07:43:51 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 077D83F718;
        Thu, 23 Sep 2021 07:43:49 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 04/10] builtin-run: Abstract argument validation into a separate function
Date:   Thu, 23 Sep 2021 15:44:59 +0100
Message-Id: <20210923144505.60776-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_cmd_run_init() is a complex function which parses the command line
arguments, configures various aspects of a VM (the size of the RAM, the
number of CPUs, the network, the active console, the kernel command line,
creates a custom rootfs, etc), and after the recent patches, also does a
few checks against mutually exclusive kvmtool arguments.

Make the function just that little bit easier to read by moving the
argument validation into a separate function.

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 6a55e34ab7f9..2a14723ba042 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -455,6 +455,19 @@ static void kvm_run_write_sandbox_cmd(struct kvm *kvm, const char **argv, int ar
 	close(fd);
 }
 
+static void kvm_run_validate_cfg(struct kvm *kvm)
+{
+	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
+		die("Only one of --kernel or --firmware can be specified");
+
+	if ((kvm->cfg.vnc && (kvm->cfg.sdl || kvm->cfg.gtk)) ||
+	    (kvm->cfg.sdl && kvm->cfg.gtk))
+		die("Only one of --vnc, --sdl or --gtk can be specified");
+
+	if (kvm->cfg.firmware_filename && kvm->cfg.initrd_filename)
+		pr_warning("Ignoring initrd file when loading a firmware image");
+}
+
 static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 {
 	static char real_cmdline[2048], default_name[20];
@@ -511,13 +524,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	}
 
-	kvm->nr_disks = kvm->cfg.image_count;
-
-	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
-		die("Only one of --kernel or --firmware can be specified");
+	kvm_run_validate_cfg(kvm);
 
-	if (kvm->cfg.firmware_filename && kvm->cfg.initrd_filename)
-		pr_warning("Ignoring initrd file when loading a firmware image");
+	kvm->nr_disks = kvm->cfg.image_count;
 
 	if (!kvm->cfg.kernel_filename && !kvm->cfg.firmware_filename) {
 		kvm->cfg.kernel_filename = find_kernel();
@@ -552,13 +561,6 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (!kvm->cfg.console)
 		kvm->cfg.console = DEFAULT_CONSOLE;
 
-	video = kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk;
-	if (video) {
-		if ((kvm->cfg.vnc && (kvm->cfg.sdl || kvm->cfg.gtk)) ||
-		    (kvm->cfg.sdl && kvm->cfg.gtk))
-			die("Only one of --vnc, --sdl or --gtk can be specified");
-	}
-
 	if (!strncmp(kvm->cfg.console, "virtio", 6))
 		kvm->cfg.active_console  = CONSOLE_VIRTIO;
 	else if (!strncmp(kvm->cfg.console, "serial", 6))
@@ -586,6 +588,8 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (!kvm->cfg.network)
                 kvm->cfg.network = DEFAULT_NETWORK;
 
+	video = kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk;
+
 	memset(real_cmdline, 0, sizeof(real_cmdline));
 	kvm__arch_set_cmdline(real_cmdline, video);
 
-- 
2.31.1

