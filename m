Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6F51DA04
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442040AbiEFONG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442021AbiEFONA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:13:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 924CE66F93
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 07:09:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6100815A1;
        Fri,  6 May 2022 07:09:17 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71AEB3F885;
        Fri,  6 May 2022 07:09:16 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     jade.alglave@arm.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 13/23] arm/arm64: Rename etext to _etext
Date:   Fri,  6 May 2022 15:08:45 +0100
Message-Id: <20220506140855.353337-14-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Rename etext to the more popular _etext allowing different linker
scripts to more easily be used.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm/setup.c | 4 ++--
 arm/flat.lds    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 3c24c75..2d67292 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -34,7 +34,7 @@
 #define NR_EXTRA_MEM_REGIONS	16
 #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
-extern unsigned long etext;
+extern unsigned long _etext;
 
 char *initrd;
 u32 initrd_size;
@@ -140,7 +140,7 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
 
 static void mem_regions_add_assumed(void)
 {
-	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
+	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
 	struct mem_region *r;
 
 	r = mem_region_find(code_end - 1);
diff --git a/arm/flat.lds b/arm/flat.lds
index 47fcb64..9016ac9 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -27,7 +27,7 @@ SECTIONS
     PROVIDE(_text = .);
     .text : { *(.init) *(.text) *(.text.*) }
     . = ALIGN(64K);
-    PROVIDE(etext = .);
+    PROVIDE(_etext = .);
 
     PROVIDE(reloc_start = .);
     .rela.dyn : { *(.rela.dyn) }
-- 
2.25.1

