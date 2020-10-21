Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7E295090
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 18:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444399AbgJUQRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 12:17:20 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15283 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408854AbgJUQRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 12:17:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f905ee00001>; Wed, 21 Oct 2020 09:16:32 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 21 Oct
 2020 16:17:17 +0000
Received: from santosh-System-Product-Name.nvidia.com (10.124.1.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 21 Oct 2020 16:17:13 +0000
From:   Santosh Shukla <sashukla@nvidia.com>
To:     <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>
CC:     <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <cjia@nvidia.com>, Santosh Shukla <sashukla@nvidia.com>
Subject: [PATCH] KVM: arm64: Correctly handle the mmio faulting
Date:   Wed, 21 Oct 2020 21:46:50 +0530
Message-ID: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603296992; bh=/pCPC1opPh5gWz/GYqPevuPPTN8cDasp68thhdStyhk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=Ye4yQZfVInpCS04DCvMYTSXJpuahcba6/U6nidiQxMqNQssOMZ4g2VJEwQroKxvqQ
         Yf2nDIGV9EivhJ8ySh9oQj3ftFP1xLtMEkYltiFs0AcRGtmDVhXZhKMJGfYYKiJqC7
         QsFZY63fdcNO4HdLlWW8rlE7rZSbCrxpiLc90tb9jzWauzHT8lx4QIUFUzzddIbTvV
         5eywN+ChvIu7lfUACARqOxZhxyVlcGPpzJ7B/CG4lScZLgkDU8TS0aIWEqxhPrewLE
         01j7i219Z64zo7BaP7DM6krxjAm21dTya5l2q63zF2ur7l1K3VxIEeEIhe+4jn9tTT
         YWmH+jNo3/byw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Commit:6d674e28 introduces a notion to detect and handle the
device mapping. The commit checks for the VM_PFNMAP flag is set
in vma->flags and if set then marks force_pte to true such that
if force_pte is true then ignore the THP function check
(/transparent_hugepage_adjust()).

There could be an issue with the VM_PFNMAP flag setting and checking.
For example consider a case where the mdev vendor driver register's
the vma_fault handler named vma_mmio_fault(), which maps the
host MMIO region in-turn calls remap_pfn_range() and maps
the MMIO's vma space. Where, remap_pfn_range implicitly sets
the VM_PFNMAP flag into vma->flags.

Now lets assume a mmio fault handing flow where guest first access
the MMIO region whose 2nd stage translation is not present.
So that results to arm64-kvm hypervisor executing guest abort handler,
like below:

kvm_handle_guest_abort() -->
 user_mem_abort()--> {

    ...
    0. checks the vma->flags for the VM_PFNMAP.
    1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
    2. gfn_to_pfn_prot() -->
        __gfn_to_pfn_memslot() -->
            fixup_user_fault() -->
                handle_mm_fault()-->
                    __do_fault() -->
                       vma_mmio_fault() --> // vendor's mdev fault handler
                        remap_pfn_range()--> // Here sets the VM_PFNMAP
						flag into vma->flags.
    3. Now that force_pte is set to false in step-2),
       will execute transparent_hugepage_adjust() func and
       that lead to Oops [4].
 }

The proposition is to check is_iomap flag before executing the THP
function transparent_hugepage_adjust().

[4] THP Oops:
> pc: kvm_is_transparent_hugepage+0x18/0xb0
> ...
> ...
> user_mem_abort+0x340/0x9b8
> kvm_handle_guest_abort+0x248/0x468
> handle_exit+0x150/0x1b0
> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
> kvm_vcpu_ioctl+0x3c0/0x858
> ksys_ioctl+0x84/0xb8
> __arm64_sys_ioctl+0x28/0x38

Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev device.
Linux tip: 583090b1

Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3d26b47..ff15357 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1947,7 +1947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !force_pte)
+	if (vma_pagesize == PAGE_SIZE && !force_pte && !is_iomap(flags))
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
 							   &pfn, &fault_ipa);
 	if (writable)
-- 
2.7.4

