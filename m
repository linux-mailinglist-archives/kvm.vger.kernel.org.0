Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31F5F06E3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfKEU36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 15:29:58 -0500
Received: from foss.arm.com ([217.140.110.172]:59886 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfKEU35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 15:29:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9213468D;
        Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0018D3FE49;
        Tue,  5 Nov 2019 03:04:02 -0800 (PST)
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH v4 1/5] KVM: x86: Move memcache allocation to GFP_PGTABLE_USER
Date:   Tue,  5 Nov 2019 12:03:53 +0100
Message-Id: <20191105110357.8607-2-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191105110357.8607-1-christoffer.dall@arm.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent commit 50f11a8a4620eee6b6831e69ab5d42456546d7d8 moved page table
allocations for both KVM and normal user page table allocations to
GFP_PGTABLE_USER in order to get __GFP_ACCOUNT for the page tables.

However, while KVM on other architectures such as arm64 were included in
this change, curiously KVM on x86 was not.

Currently, KVM on x86 uses kmem_cache_zalloc(GFP_KERNEL_ACCOUNT) for
kmem_cache-based allocations, which expands in the following way:
  kmem_cache_zalloc(..., GFP_KERNEL_ACCOUNT) =>
  kmem_cache_alloc(..., GFP_KERNEL_ACCOUNT | __GFP_ZERO) =>
  kmem_cache_alloc(..., GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)

It so happens that GFP_PGTABLE_USER expands as:
  GFP_PGTABLE_USER =>
  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT) =>
  ((GFP_KERNEL | __GFP_ZERO) | __GFP_ACCOUNT) =>
  (GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)

Which means that we can replace the current KVM on x86 call as:
-  obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
+  obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);

For the single page cache topup allocation, KVM on x86 currently uses
__get_free_page(GFP_KERNEL_ACCOUNT).  It seems to me that is equivalent
to the above, except that the allocated page is not guaranteed to be
zero (unless I missed the place where __get_free_page(!__GFP_ZERO) is
still guaranteed to be zeroed.  It seems natural (and in fact desired)
to have both topup functions implement the same expectations towards the
caller, and we therefore move to GFP_PGTABLE_USER here as well.

This will make it easier to unify the memchace implementation between
architectures.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/x86/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..540190cee3cb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -40,6 +40,7 @@
 
 #include <asm/page.h>
 #include <asm/pat.h>
+#include <asm/pgalloc.h>
 #include <asm/cmpxchg.h>
 #include <asm/e820/api.h>
 #include <asm/io.h>
@@ -1025,7 +1026,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
+		obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
 		if (!obj)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -1053,7 +1054,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		page = (void *)__get_free_page(GFP_PGTABLE_USER);
 		if (!page)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = page;
-- 
2.18.0

