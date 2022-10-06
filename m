Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9505F64F5
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiJFLL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiJFLLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:11:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9347A15707
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:11:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 594FE1042;
        Thu,  6 Oct 2022 04:11:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B36713F73B;
        Thu,  6 Oct 2022 04:11:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 1/3] lib/vmalloc: Treat virt_to_pte_phys() as returning a physical address
Date:   Thu,  6 Oct 2022 12:12:39 +0100
Message-Id: <20221006111241.15083-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221006111241.15083-1-alexandru.elisei@arm.com>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All architectures that implements virt_to_pte_phys() (s390x, x86, arm and
arm64) return a physical address from the function. Teach vmalloc to treat
it as such, instead of confusing the return value with a page table entry.
Changing things the other way around (having the function return a page
table entry instead) is not feasible, because it is possible for an
architecture to use the upper bits of the table entry to store metadata
about the page.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 572682576cc3..0696b5da8190 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -169,7 +169,7 @@ static void vm_free(void *mem)
 	/* the pointer is not page-aligned, it was a single-page allocation */
 	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
 		assert(GET_MAGIC(mem) == VM_MAGIC);
-		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
+		page = virt_to_pte_phys(page_root, mem);
 		assert(page);
 		free_page(phys_to_virt(page));
 		return;
@@ -183,7 +183,7 @@ static void vm_free(void *mem)
 	/* free all the pages including the metadata page */
 	ptr = (uintptr_t)m & PAGE_MASK;
 	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
-		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
+		page = virt_to_pte_phys(page_root, (void *)ptr);
 		assert(page);
 		free_page(phys_to_virt(page));
 	}
-- 
2.37.0

