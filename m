Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E36958D638
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbiHIJQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbiHIJPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8874220CB
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72131143D;
        Tue,  9 Aug 2022 02:15:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 925CF3F67D;
        Tue,  9 Aug 2022 02:15:48 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 16/19] arm/arm64: Allocate secondaries' stack using the page allocator
Date:   Tue,  9 Aug 2022 10:15:55 +0100
Message-Id: <20220809091558.14379-17-alexandru.elisei@arm.com>
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

The vmalloc allocator returns non-id mapped addresses, where the virtual
address is different than the physical address. This makes it impossible
to access the stack of the secondary CPUs while the MMU is disabled.

On arm, THREAD_SIZE is 16K and PAGE_SIZE is 4K, which makes THREAD_SIZE
a power of two multiple of PAGE_SIZE. On arm64, THREAD_SIZE is 16 when
PAGE_SIZE is 4K or 16K, and 64K when PAGE_SIZE is 64K. In all cases,
THREAD_SIZE is a power of two multiple of PAGE_SIZE. As a result, using
memalign_pages() for the stack won't lead to wasted memory.

memalign_pages() allocates memory in chunks of power of two number of
pages, aligned to the allocation size, which makes it a drop-in
replacement for vm_memalign (which is the value for alloc_ops->memalign
when the stack is allocated).

Using memalign_pages() has two distinct benefits:

1. The secondary CPUs' stack can be used with the MMU off.

2. The secondary CPUs' stack is identify mapped similar to the stack for
the primary CPU, which makes the configuration of the CPUs consistent.

memalign_pages_flags() has been used instead of memalign_pages() to
instruct the allocator not to zero the stack, as it's already zeroed in the
entry code.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index eaa72582af86..190e082cbba0 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -25,6 +25,7 @@
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
 #include <alloc.h>
+#include <alloc_page.h>
 
 #ifdef __arm__
 #include <asm/ptrace.h>
@@ -40,7 +41,7 @@
 
 static inline void *thread_stack_alloc(void)
 {
-	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
+	void *sp = memalign_pages_flags(THREAD_ALIGNMENT, THREAD_SIZE, FLAG_DONTZERO);
 	return sp + THREAD_START_SP;
 }
 
-- 
2.37.1

