Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7215141614D
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhIWOp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:27 -0400
Received: from foss.arm.com ([217.140.110.172]:35520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241757AbhIWOpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BFE5113E;
        Thu, 23 Sep 2021 07:43:53 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96A253F718;
        Thu, 23 Sep 2021 07:43:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 06/10] builtin-run: Move kernel command line generation to a separate function
Date:   Thu, 23 Sep 2021 15:45:01 +0100
Message-Id: <20210923144505.60776-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The real kernel command line is gradually generated in kvm_cmd_run_init()
and it is interspersed with the initialization code. This means that both
the code that generates the command line and the rest of the code is
unnecessarily difficult to follow and to modify. Move the code that
generates the command line to one function, to make it easier to
understand, and to declutter kvm_cmd_run_init().

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 100 +++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 6822c321883e..478b5a95b726 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -455,6 +455,54 @@ static void kvm_run_write_sandbox_cmd(struct kvm *kvm, const char **argv, int ar
 	close(fd);
 }
 
+static void kvm_run_set_real_cmdline(struct kvm *kvm)
+{
+	static char real_cmdline[2048];
+	bool video;
+
+	video = kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk;
+
+	memset(real_cmdline, 0, sizeof(real_cmdline));
+	kvm__arch_set_cmdline(real_cmdline, video);
+
+	if (video) {
+		strcat(real_cmdline, " console=tty0");
+	} else {
+		switch (kvm->cfg.active_console) {
+		case CONSOLE_HV:
+			/* Fallthrough */
+		case CONSOLE_VIRTIO:
+			strcat(real_cmdline, " console=hvc0");
+			break;
+		case CONSOLE_8250:
+			strcat(real_cmdline, " console=ttyS0");
+			break;
+		}
+	}
+
+	if (kvm->cfg.using_rootfs) {
+		strcat(real_cmdline, " rw rootflags=trans=virtio,version=9p2000.L,cache=loose rootfstype=9p");
+		if (kvm->cfg.custom_rootfs) {
+#ifdef CONFIG_GUEST_PRE_INIT
+			strcat(real_cmdline, " init=/virt/pre_init");
+#else
+			strcat(real_cmdline, " init=/virt/init");
+#endif
+			if (!kvm->cfg.no_dhcp)
+				strcat(real_cmdline, "  ip=dhcp");
+		}
+	} else if (!kvm->cfg.kernel_cmdline || !strstr(kvm->cfg.kernel_cmdline, "root=")) {
+		strlcat(real_cmdline, " root=/dev/vda rw ", sizeof(real_cmdline));
+	}
+
+	if (kvm->cfg.kernel_cmdline) {
+		strcat(real_cmdline, " ");
+		strlcat(real_cmdline, kvm->cfg.kernel_cmdline, sizeof(real_cmdline));
+	}
+
+	kvm->cfg.real_cmdline = real_cmdline;
+}
+
 static void kvm_run_validate_cfg(struct kvm *kvm)
 {
 	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
@@ -470,10 +518,9 @@ static void kvm_run_validate_cfg(struct kvm *kvm)
 
 static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 {
-	static char real_cmdline[2048], default_name[20];
+	static char default_name[20];
 	unsigned int nr_online_cpus;
 	struct kvm *kvm = kvm__new();
-	bool video;
 
 	if (IS_ERR(kvm))
 		return kvm;
@@ -586,26 +633,6 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (!kvm->cfg.network)
                 kvm->cfg.network = DEFAULT_NETWORK;
 
-	video = kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk;
-
-	memset(real_cmdline, 0, sizeof(real_cmdline));
-	kvm__arch_set_cmdline(real_cmdline, video);
-
-	if (video) {
-		strcat(real_cmdline, " console=tty0");
-	} else {
-		switch (kvm->cfg.active_console) {
-		case CONSOLE_HV:
-			/* Fallthrough */
-		case CONSOLE_VIRTIO:
-			strcat(real_cmdline, " console=hvc0");
-			break;
-		case CONSOLE_8250:
-			strcat(real_cmdline, " console=ttyS0");
-			break;
-		}
-	}
-
 	if (!kvm->cfg.guest_name) {
 		if (kvm->cfg.custom_rootfs) {
 			kvm->cfg.guest_name = kvm->cfg.custom_rootfs_name;
@@ -629,32 +656,13 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 		kvm->cfg.using_rootfs = kvm->cfg.custom_rootfs = 1;
 	}
 
-	if (kvm->cfg.using_rootfs) {
-		strcat(real_cmdline, " rw rootflags=trans=virtio,version=9p2000.L,cache=loose rootfstype=9p");
-		if (kvm->cfg.custom_rootfs) {
-			kvm_run_set_sandbox(kvm);
-
-#ifdef CONFIG_GUEST_PRE_INIT
-			strcat(real_cmdline, " init=/virt/pre_init");
-#else
-			strcat(real_cmdline, " init=/virt/init");
-#endif
-
-			if (!kvm->cfg.no_dhcp)
-				strcat(real_cmdline, "  ip=dhcp");
-			if (kvm_setup_guest_init(kvm->cfg.custom_rootfs_name))
-				die("Failed to setup init for guest.");
-		}
-	} else if (!kvm->cfg.kernel_cmdline || !strstr(kvm->cfg.kernel_cmdline, "root=")) {
-		strlcat(real_cmdline, " root=/dev/vda rw ", sizeof(real_cmdline));
-	}
-
-	if (kvm->cfg.kernel_cmdline) {
-		strcat(real_cmdline, " ");
-		strlcat(real_cmdline, kvm->cfg.kernel_cmdline, sizeof(real_cmdline));
+	if (kvm->cfg.custom_rootfs) {
+		kvm_run_set_sandbox(kvm);
+		if (kvm_setup_guest_init(kvm->cfg.custom_rootfs_name))
+			die("Failed to setup init for guest.");
 	}
 
-	kvm->cfg.real_cmdline = real_cmdline;
+	kvm_run_set_real_cmdline(kvm);
 
 	if (kvm->cfg.kernel_filename) {
 		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
-- 
2.31.1

