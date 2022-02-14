Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A454B5785
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356759AbiBNQ6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:58:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBNQ6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:58:33 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 227CD65155
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:58:26 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6CCF13D5;
        Mon, 14 Feb 2022 08:58:25 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6809D3F70D;
        Mon, 14 Feb 2022 08:58:24 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, pierre.gondois@arm.com
Subject: [PATCH kvmtool 2/3] arm: Use pr_debug() to print memory layout when loading a firmware image
Date:   Mon, 14 Feb 2022 16:58:29 +0000
Message-Id: <20220214165830.69207-3-alexandru.elisei@arm.com>
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

When loading a kernel image, kvmtool is nice enough to print a message
informing the user where the file was loaded in guest memory, which is very
useful for debugging. Do the same for the firmware image.

Commit e1c7c62afc7b ("arm: turn pr_info() into pr_debug() messages")
changed various pr_info() into pr_debug() messages to stop kvmtool from
cluttering stdout. Do the same when printing where the FDT has been copied
when loading a firmware image.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 5aea18fedc3e..80d233f13d0b 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -218,6 +218,8 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	/* Kernel isn't loaded by kvm, point start address to firmware */
 	kvm->arch.kern_guest_start = fw_addr;
+	pr_debug("Loaded firmware to 0x%llx (%zd bytes)",
+		 kvm->arch.kern_guest_start, fw_sz);
 
 	/* Load dtb just after the firmware image*/
 	host_pos += fw_sz;
@@ -226,9 +228,9 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	kvm->arch.dtb_guest_start = ALIGN(host_to_guest_flat(kvm, host_pos),
 					  FDT_ALIGN);
-	pr_info("Placing fdt at 0x%llx - 0x%llx",
-		kvm->arch.dtb_guest_start,
-		kvm->arch.dtb_guest_start + FDT_MAX_SIZE);
+	pr_debug("Placing fdt at 0x%llx - 0x%llx",
+		 kvm->arch.dtb_guest_start,
+		 kvm->arch.dtb_guest_start + FDT_MAX_SIZE);
 
 	return true;
 }
-- 
2.31.1

