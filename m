Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31177561730
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiF3KD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbiF3KD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:03:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD7D2443D2
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 865941BF7;
        Thu, 30 Jun 2022 03:03:52 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583623F5A1;
        Thu, 30 Jun 2022 03:03:51 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 02/27] x86: Avoid references to fields of ACPI tables
Date:   Thu, 30 Jun 2022 11:02:59 +0100
Message-Id: <20220630100324.3153655-3-nikos.nikoleris@arm.com>
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

ACPI table definitions in <acpi.h> have to be packed.  However, once
we do that, direct references to members of the packed struct might
result in unaligned pointers and gcc complains about them. This change
modifies the code to avoid such references in preparation for making
the APCI table definitions packed.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 x86/s3.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/x86/s3.c b/x86/s3.c
index 378d37a..0bcbe18 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -2,15 +2,6 @@
 #include "acpi.h"
 #include "asm/io.h"
 
-static u32* find_resume_vector_addr(void)
-{
-    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
-    if (!facs)
-        return 0;
-    printf("FACS is at %p\n", facs);
-    return &facs->firmware_waking_vector;
-}
-
 #define RTC_SECONDS_ALARM       1
 #define RTC_MINUTES_ALARM       3
 #define RTC_HOURS_ALARM         5
@@ -40,12 +31,14 @@ extern char resume_start, resume_end;
 int main(int argc, char **argv)
 {
 	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
-	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
+	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
 	char *addr, *resume_vec = (void*)0x1000;
 
-	*resume_vector_ptr = (u32)(ulong)resume_vec;
+	assert(facs);
+	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
 
-	printf("resume vector addr is %p\n", resume_vector_ptr);
+	printf("FACS is at %p\n", facs);
+	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
 	for (addr = &resume_start; addr < &resume_end; addr++)
 		*resume_vec++ = *addr;
 	printf("copy resume code from %p\n", &resume_start);
-- 
2.25.1

