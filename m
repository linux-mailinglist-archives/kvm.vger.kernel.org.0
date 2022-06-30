Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD9561722
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiF3KEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiF3KD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:03:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 136BF4338E
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DA4F1C00;
        Thu, 30 Jun 2022 03:03:57 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E227A3F5A1;
        Thu, 30 Jun 2022 03:03:55 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 06/27] devicetree: Check if fdt is NULL before returning that a DT is available
Date:   Thu, 30 Jun 2022 11:03:03 +0100
Message-Id: <20220630100324.3153655-7-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up until now, for platfroms that support DT, KUT would unconditionally
use DT to configure the system and the code made the assumption that
the fdt will always be a valid pointer.

In Arm systems that support both ACPI and DT, we plat to follow the
same convension as the Linux kernel. First, we attempt to configure
the system using the DT. If an FDT was not provided then we attempt to
configure the system using ACPI.

As a result, for Arm systems with support for ACPI the fdt pointer can
be NULL. This change modifies dt_available() to check if the fdt is a
valid pointer and return if we can use information from the DT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 78c1f6f..3ff9d16 100644
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

