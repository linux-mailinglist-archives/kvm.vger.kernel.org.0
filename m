Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2681B67E515
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjA0MYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbjA0MX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:23:26 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B5167B7AA;
        Fri, 27 Jan 2023 04:21:00 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 884A41756;
        Fri, 27 Jan 2023 03:31:33 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86C463F64C;
        Fri, 27 Jan 2023 03:30:49 -0800 (PST)
From:   Steven Price <steven.price@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: [RFC PATCH 27/28] arm64: RME: Always use 4k pages for realms
Date:   Fri, 27 Jan 2023 11:29:31 +0000
Message-Id: <20230127112932.38045-28-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always split up huge pages to avoid problems managing huge pages. There
are two issues currently:

1. The uABI for the VMM allows populating memory on 4k boundaries even
   if the underlying allocator (e.g. hugetlbfs) is using a larger page
   size. Using a memfd for private allocations will push this issue onto
   the VMM as it will need to respect the granularity of the allocator.

2. The guest is able to request arbitrary ranges to be remapped as
   shared. Again with a memfd approach it will be up to the VMM to deal
   with the complexity and either overmap (need the huge mapping and add
   an additional 'overlapping' shared mapping) or reject the request as
   invalid due to the use of a huge page allocator.

For now just break everything down to 4k pages in the RMM controlled
stage 2.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 arch/arm64/kvm/rme.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5417c273861b..b5fc8d8f7049 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1278,6 +1278,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+	} else if (kvm_is_realm(kvm)) {
+		// Force PTE level mappings for realms
+		force_pte = true;
+		vma_shift = PAGE_SHIFT;
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 6ae7871aa6ed..1eb76cbee267 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -730,7 +730,9 @@ static int populate_par_region(struct kvm *kvm,
 			break;
 		}
 
-		if (is_vm_hugetlb_page(vma))
+		// FIXME: To avoid the overmapping issue (see below comment)
+		// force the use of 4k pages
+		if (is_vm_hugetlb_page(vma) && 0)
 			vma_shift = huge_page_shift(hstate_vma(vma));
 		else
 			vma_shift = PAGE_SHIFT;
-- 
2.34.1

