Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDEA58D637
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiHIJQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbiHIJPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 963AF1C113
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 128E623A;
        Tue,  9 Aug 2022 02:15:49 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 319B03F67D;
        Tue,  9 Aug 2022 02:15:47 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 15/19] lib/alloc_phys: Add callback to perform cache maintenance
Date:   Tue,  9 Aug 2022 10:15:54 +0100
Message-Id: <20220809091558.14379-16-alexandru.elisei@arm.com>
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

Some architectures, like arm and arm64, require explicit cache
maintenance to maintain the caches in sync with memory when toggling the
caches. Add the function to do the required maintenance on the internal
structures that the allocator maintains.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 8 ++++++++
 lib/alloc_phys.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 1e1fc179f108..5872d2c6e38f 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -45,6 +45,14 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	align_min = align;
 }
 
+void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn)
+{
+	maint_fn((unsigned long)&base);
+	maint_fn((unsigned long)&used);
+	maint_fn((unsigned long)&top);
+	maint_fn((unsigned long)&align_min);
+}
+
 static void *memalign_early(size_t alignment, size_t sz)
 {
 	phys_addr_t align = (phys_addr_t)alignment;
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 4d350f010031..86b3d0215d49 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,6 +15,8 @@
  */
 #include "libcflat.h"
 
+typedef void (*cache_maint_fn)(unsigned long addr);
+
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
@@ -27,6 +29,12 @@ extern void phys_alloc_init(phys_addr_t base, phys_addr_t size);
  */
 extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
+/*
+ * Perform cache maintenance on the internal structures that the physical
+ * allocator maintains.
+ */
+extern void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn);
+
 /*
  * phys_alloc_show outputs all currently allocated regions with the
  * following format, where <end_addr> is non-inclusive:
-- 
2.37.1

