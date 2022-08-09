Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A6358D614
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiHIJPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbiHIJPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB0EB13D74
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C02C143D;
        Tue,  9 Aug 2022 02:15:30 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ABD03F67D;
        Tue,  9 Aug 2022 02:15:28 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 02/19] lib/alloc_phys: Initialize align_min
Date:   Tue,  9 Aug 2022 10:15:41 +0100
Message-Id: <20220809091558.14379-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 11c4715fbf87 ("alloc: implement free") changed align_min from a
static variable to a field for the alloc_ops struct and carried over the
initializer value of DEFAULT_MINIMUM_ALIGNMENT.

Commit 7e3e823b78c0 ("lib/alloc.h: remove align_min from struct
alloc_ops") removed the align_min field and changed it back to a static
variable, but missed initializing it.

Initialize align_min to DEFAULT_MINIMUM_ALIGNMENT, as it was intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 7 +++----
 lib/alloc_phys.h | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index a4d2bf23c1bc..3a78d0acd718 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -13,8 +13,6 @@
 
 #define PHYS_ALLOC_NR_REGIONS	256
 
-#define DEFAULT_MINIMUM_ALIGNMENT	32
-
 struct phys_alloc_region {
 	phys_addr_t base;
 	phys_addr_t size;
@@ -26,12 +24,13 @@ static int nr_regions;
 static struct spinlock lock;
 static phys_addr_t base, top;
 
+#define DEFAULT_MINIMUM_ALIGNMENT	32
+static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
+
 static void *early_memalign(size_t alignment, size_t size);
 static struct alloc_ops early_alloc_ops = {
 	.memalign = early_memalign,
 };
-static size_t align_min;
-
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
 void phys_alloc_show(void)
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 611aa70d2041..8049c340818d 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,8 +15,6 @@
  */
 #include "libcflat.h"
 
-#define DEFAULT_MINIMUM_ALIGNMENT 32
-
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
-- 
2.37.1

