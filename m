Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0C416152
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241781AbhIWOpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:32 -0400
Received: from foss.arm.com ([217.140.110.172]:35552 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241780AbhIWOp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8192211FB;
        Thu, 23 Sep 2021 07:43:57 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CF383F718;
        Thu, 23 Sep 2021 07:43:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 09/10] arm64: Use the default offset when the kernel image magic is not found
Date:   Thu, 23 Sep 2021 15:45:04 +0100
Message-Id: <20210923144505.60776-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit fd0a05bd27dd ("arm64: Obtain text offset from kernel image") added
support for getting the kernel offset from the kernel header. The code
checks for the kernel header magic number, and if not found, prints a
warning and continues searching for the kernel offset in the image.

The -k/--kernel option can be used to load things which are not a Linux
kernel, but behave like one, like a kvm-unit-tests test. The tests don't
have a valid kernel header, and because kvmtool insists on searching for
the offset, creating a virtual machine can fail with this message:

$ ./vm run -c2 -m256 -k ../kvm-unit-tests/arm/cache.flat
  # lkvm run -k ../kvm-unit-tests/arm/cache.flat -m 256 -c 2 --name guest-7529
  Warning: Kernel image magic not matching
  Warning: unable to translate host address 0x910100a502a00085 to guest
  Fatal: kernel image too big to contain in guest memory.

The host address is a random number read from the test binary from the
location where text_offset is found in the kernel header. Before the
commit, the test was executing just fine:

$ ./vm run -c2 -m256 -k ../kvm-unit-tests/arm/cache.flat
  # lkvm run -k ../kvm-unit-tests/arm/cache.flat -m 256 -c 2 --name guest-8105
INFO: IDC-DIC: dcache clean to PoU required
INFO: IDC-DIC: icache invalidation to PoU required
PASS: IDC-DIC: code generation
SUMMARY: 1 tests

Change kvm__arch_get_kern_offset() so it returns the default text_offset
value if the kernel image magic number is not found, making it possible
again to use something other than a Linux kernel with --kernel.

Reported-by: Vivek Kumar Gautam <vivek.gautam@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/kvm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 4e66a22ec06d..b38365fb7156 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -35,8 +35,10 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 
 	lseek(fd, cur_offset, SEEK_SET);
 
-	if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic)))
-		pr_warning("Kernel image magic not matching");
+	if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic))) {
+		warn_str = "Kernel image magic not matching";
+		goto fail;
+	}
 
 	if (le64_to_cpu(header.image_size))
 		return le64_to_cpu(header.text_offset);
-- 
2.31.1

