Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B5745022B
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 11:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhKOKR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 05:17:28 -0500
Received: from foss.arm.com ([217.140.110.172]:53330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237407AbhKOKRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 05:17:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5728811B3;
        Mon, 15 Nov 2021 02:14:22 -0800 (PST)
Received: from e120937-lin.home (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB4013F70D;
        Mon, 15 Nov 2021 02:14:20 -0800 (PST)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     andre.przywara@arm.com, sudeep.holla@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        Cristian Marussi <cristian.marussi@arm.com>
Subject: [RFC PATCH kvmtool 2/2] arm/fdt: Add FDT overlay support
Date:   Mon, 15 Nov 2021 10:14:01 +0000
Message-Id: <20211115101401.21685-3-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115101401.21685-1-cristian.marussi@arm.com>
References: <20211115101401.21685-1-cristian.marussi@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add --fdt-overlay option to provide an overlay blob file to be merged at
initialization time into the base FDT already usually generated at boot
by kvmtool.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
---
 arm/fdt.c                                | 34 ++++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h |  4 +++
 2 files changed, 38 insertions(+)

diff --git a/arm/fdt.c b/arm/fdt.c
index c2dfdae..aad719d 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -231,6 +231,40 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_finish(fdt));
 
 	_FDT(fdt_open_into(fdt, fdt_dest, FDT_MAX_SIZE));
+
+	/*
+	 * NOTE THAT only 'target-path' directive is supported in the overlay
+	 * DTS as a mean to specify where to 'hook' the additions: 'target' is
+	 * not supported since it could not work anyway in kvmtool context,
+	 * since it is supposed to be used to specify a label as a hook, but
+	 * labels are stripped out from a binary DTB file and, in fact, kvmtool
+	 * generates an FDT blob that contains no labels.
+	 * (and indeed libfdt had no support for labels neither)
+	 */
+	if (kvm->cfg.arch.fdt_overlay) {
+		int fd;
+
+		pr_debug("Applying FDT Overlay: %s", kvm->cfg.arch.fdt_overlay);
+		fd = open(kvm->cfg.arch.fdt_overlay, O_RDONLY);
+		if (fd >= 0) {
+			struct stat sta;
+
+			if (!fstat(fd, &sta)) {
+				void *fdto;
+
+				fdto = mmap(NULL, sta.st_size,
+					    PROT_READ | PROT_WRITE,
+					    MAP_PRIVATE, fd, 0);
+				if (fdto) {
+					_FDT(fdt_overlay_apply(fdt_dest, fdto));
+					pr_debug("FDT Overlay applied: %s",
+						 kvm->cfg.arch.fdt_overlay);
+					munmap(fdto, sta.st_size);
+				}
+			}
+			close(fd);
+		}
+	}
 	_FDT(fdt_pack(fdt_dest));
 
 	if (kvm->cfg.arch.dump_dtb_filename)
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index b850c01..46137eb 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -5,6 +5,7 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	const char	*fdt_overlay;
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
@@ -26,6 +27,9 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 	ARM_OPT_ARCH_RUN(cfg)							\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,			\
 		   ".dtb file", "Dump generated .dtb to specified file"),	\
+	OPT_STRING('\0', "fdt-overlay", &(cfg)->fdt_overlay,			\
+		   ".dtb overlay file",						\
+		   "Use provided DTB file (compiled with -@) as overlay"),	\
 	OPT_UINTEGER('\0', "override-bad-firmware-cntfrq", &(cfg)->force_cntfrq,\
 		     "Specify Generic Timer frequency in guest DT to "		\
 		     "work around buggy secure firmware *Firmware should be "	\
-- 
2.17.1

