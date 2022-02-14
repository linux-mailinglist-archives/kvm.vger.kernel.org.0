Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050C64B5788
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356756AbiBNQ6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:58:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBNQ6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:58:32 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5574865155
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:58:24 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2497C1476;
        Mon, 14 Feb 2022 08:58:24 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB4203F70D;
        Mon, 14 Feb 2022 08:58:22 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, pierre.gondois@arm.com
Subject: [PATCH kvmtool 1/3] Remove initrd magic check
Date:   Mon, 14 Feb 2022 16:58:28 +0000
Message-Id: <20220214165830.69207-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux, besides CPIO, supports 7 different compressed formats for the initrd
(gzip, bzip2, LZMA, XZ, LZO, LZ4, ZSTD), but kvmtool only recognizes one of
them.

Remove the initrd magic check because:

1. It doesn't bring much to the end user, as the Linux kernel still
   complains if the initrd is in an unknown format.

2. --kernel can be used to load something that is not a Linux kernel (like
   a kvm-unit-tests test), in which case a format which is not supported by
   a Linux kernel can still be perfectly valid. For example, kvm-unit-tests
   load the test environment as an initrd in plain ASCII format.

3. It cuts down on the maintenance effort when new formats are added to
   the Linux kernel. Not a big deal, since that doesn't happen very often,
   but it's still an effort with very little gain (see point #1 above).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 kvm.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/kvm.c b/kvm.c
index 5bc66c8be82a..952ef1fbb41c 100644
--- a/kvm.c
+++ b/kvm.c
@@ -512,25 +512,6 @@ err:
 }
 core_init(kvm__init);
 
-/* RFC 1952 */
-#define GZIP_ID1		0x1f
-#define GZIP_ID2		0x8b
-#define CPIO_MAGIC		"0707"
-/* initrd may be gzipped, or a plain cpio */
-static bool initrd_check(int fd)
-{
-	unsigned char id[4];
-
-	if (read_in_full(fd, id, ARRAY_SIZE(id)) < 0)
-		return false;
-
-	if (lseek(fd, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
-	return (id[0] == GZIP_ID1 && id[1] == GZIP_ID2) ||
-		!memcmp(id, CPIO_MAGIC, 4);
-}
-
 bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 		const char *initrd_filename, const char *kernel_cmdline)
 {
@@ -545,9 +526,6 @@ bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
 		fd_initrd = open(initrd_filename, O_RDONLY);
 		if (fd_initrd < 0)
 			die("Unable to open initrd %s", initrd_filename);
-
-		if (!initrd_check(fd_initrd))
-			die("%s is not an initrd", initrd_filename);
 	}
 
 	ret = kvm__arch_load_kernel_image(kvm, fd_kernel, fd_initrd,
-- 
2.31.1

