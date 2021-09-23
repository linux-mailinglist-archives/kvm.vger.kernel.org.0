Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AEF416153
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbhIWOpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:32 -0400
Received: from foss.arm.com ([217.140.110.172]:35558 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241761AbhIWOpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C91F6D6E;
        Thu, 23 Sep 2021 07:43:58 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C40FD3F718;
        Thu, 23 Sep 2021 07:43:57 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 10/10] arm64: Be more permissive when parsing the kernel header
Date:   Thu, 23 Sep 2021 15:45:05 +0100
Message-Id: <20210923144505.60776-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool complains loudly when it parses the kernel header and doesn't find
what it expects, but unless it outright fails to read the kernel image, it
will copy the image in the guest memory at the default offset of 0x80000.

There's no technical reason to stop the user from loading payloads other
than a Linux kernel with the --kernel option. These payloads can behave
just like a kernel and can use an initrd (which is not possible with
--firmware), but don't have the kernel header (like kvm-unit-tests), and
the warnings kvmtool emites can be confusing for this type of payloads.

Change the warnings to debug statements, which can be enabled via the
--debug kvmtool command line option, to make them disappear for these cases
where they aren't really relevant.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/kvm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index b38365fb7156..56a0aedc263d 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -16,7 +16,7 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 	struct arm64_image_header header;
 	off_t cur_offset;
 	ssize_t size;
-	const char *warn_str;
+	const char *debug_str;
 
 	/* the 32bit kernel offset is a well known value */
 	if (kvm->cfg.arch.aarch32_guest)
@@ -25,8 +25,8 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 	cur_offset = lseek(fd, 0, SEEK_CUR);
 	if (cur_offset == (off_t)-1 ||
 	    lseek(fd, 0, SEEK_SET) == (off_t)-1) {
-		warn_str = "Failed to seek in kernel image file";
-		goto fail;
+		debug_str = "Failed to seek in kernel image file";
+		goto default_offset;
 	}
 
 	size = xread(fd, &header, sizeof(header));
@@ -36,16 +36,16 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 	lseek(fd, cur_offset, SEEK_SET);
 
 	if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic))) {
-		warn_str = "Kernel image magic not matching";
-		goto fail;
+		debug_str = "Kernel image magic not matching";
+		goto default_offset;
 	}
 
 	if (le64_to_cpu(header.image_size))
 		return le64_to_cpu(header.text_offset);
 
-	warn_str = "Image size is 0";
-fail:
-	pr_warning("%s, assuming TEXT_OFFSET to be 0x80000", warn_str);
+	debug_str = "Image size is 0";
+default_offset:
+	pr_debug("%s, assuming TEXT_OFFSET to be 0x80000", debug_str);
 	return 0x80000;
 }
 
-- 
2.31.1

