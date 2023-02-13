Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580FA694297
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBMKS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBMKSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:18 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9954A13D4C
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:17 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE9291D15;
        Mon, 13 Feb 2023 02:18:59 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A8EE3F703;
        Mon, 13 Feb 2023 02:18:16 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 11/30] devicetree: Check that fdt is not NULL in dt_available()
Date:   Mon, 13 Feb 2023 10:17:40 +0000
Message-Id: <20230213101759.2577077-12-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up until now, for platforms that support DT, kvm-unit-tests would
unconditionally use DT to configure the system and the code made the
assumption that the fdt will always be a valid pointer.

On Arm systems that support both ACPI and DT, kvm-unit-tests plans to
follow the same convension as the Linux kernel: attempt to configure the
system using the DT first, then fallback to ACPI.

As a result, the fdt pointer can be NULL. Check for that in dt_available().

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
[ Alex E: Minor changes to the commit message ]
---
 lib/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 78c1f6fb..3ff9d164 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -16,7 +16,7 @@ const void *dt_fdt(void)
 
 bool dt_available(void)
 {
-	return fdt_check_header(fdt) == 0;
+	return fdt && fdt_check_header(fdt) == 0;
 }
 
 int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
-- 
2.25.1

