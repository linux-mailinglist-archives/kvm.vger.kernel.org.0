Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1970298C17
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 12:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773768AbgJZLZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 07:25:24 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19654 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773761AbgJZLZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 07:25:24 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96b22a0001>; Mon, 26 Oct 2020 04:25:30 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 11:25:19 +0000
Received: from santosh-System-Product-Name.nvidia.com (172.20.13.39) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 11:25:15 +0000
From:   Santosh Shukla <sashukla@nvidia.com>
To:     <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>
CC:     <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <mcrossley@nvidia.com>,
        Santosh Shukla <sashukla@nvidia.com>
Subject: [PATCH v2 1/1] KVM: arm64: Correctly handle the mmio faulting
Date:   Mon, 26 Oct 2020 16:54:07 +0530
Message-ID: <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
References: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603711530; bh=yL8eU53Ye6VwNxBHiLcoNd9MJdU5fRUmThif3Tv1W5E=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:X-NVConfidentiality:MIME-Version:Content-Type;
        b=XHOm2+pIlpG4E5U3euIlDKC7pqJpjQrTdWZNwMuV5fK+D1fWDqg43ADwB1Xu2LbtP
         PcSt2zKuF67PMIt8PVUe4QY9jz3IYwOK5R9XN6PhKvscGRc7gZQ6HV1uC8cL4mPw2e
         aNGvp8U0Rf1SZtD/z4U0yyCgu5t+LPHp3tTMpGow64ZDGzDaKeW/d1r2iFvV24yyix
         R4xkNTgwHRaebjq57PGGqXjk+dH6XGfqgDwvUS6N+btaS4brB8qtNnqEb9c3vwS9Kg
         hQh1BPVujC4zSGWjH88B/aN9riXCJRJC2T6wD+KgCWgepHGZq2YgJ+op77gQmWCuEh
         6X2VPFK4B7yJA==
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

The proposition is to set force_pte=true if kvm_is_device_pfn is true.

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
Linux-5.10-rc1 tip: 3650b228

Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
---
v2:
- Per Marc's suggestion - setting force_pte=true.
- Rebased and tested for 5.10-rc1 commit: 3650b228

v1: https://lkml.org/lkml/2020/10/21/460

arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 19aacc7..d4cd253 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
+		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
-- 
2.7.4

