Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE415298C13
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773753AbgJZLZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 07:25:08 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2725 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769366AbgJZLZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 07:25:08 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96b2180001>; Mon, 26 Oct 2020 04:25:12 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 11:25:06 +0000
Received: from santosh-System-Product-Name.nvidia.com (172.20.13.39) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 11:25:02 +0000
From:   Santosh Shukla <sashukla@nvidia.com>
To:     <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>
CC:     <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <mcrossley@nvidia.com>,
        Santosh Shukla <sashukla@nvidia.com>
Subject: [PATCH v2 0/1] KVM: arm64: fix the mmio faulting
Date:   Mon, 26 Oct 2020 16:54:06 +0530
Message-ID: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603711512; bh=gagsFxX9VGPMNvFi2BG28Wch0bVOveZzbh0HO/8H9CA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:X-NVConfidentiality:
         MIME-Version:Content-Type;
        b=lk7lfG8/4mni/IbMkJqKv4GIOWNPMoFoyGhpQfQBPFzg85CBQm80fncS9pL4dK2SN
         a4c5fhbKrr9ZKORJRO/K1DdiIGsb9bShiFawX8dW/DPtlNTdbqPLLApoxtZp6vPjt6
         Cqsjtt7C0BRHg074aEop7IPORvZy3hGPMzzPEh7ho3Fz2DMGyW8a0H1BFPWcCm75ey
         Nav4xluGxFSrbmI9uKu202j012m3FBVTonWWpiP32j4wbMYuasuEuDESVLGWSN5+yg
         2y0VZgu9hq4uve9etidKRCGWflJ0SemmWbzGcTXwEbnOLIYf4GVYNBWauRd8e5EE02
         iToRoZmVOD18Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Description of the Reproducer scenario as asked in the thread [1].

Tried to create the reproducer scenario with vfio-pci driver using
nvidia GPU in PT mode, As because vfio-pci driver now supports
vma faulting (/vfio_pci_mmap_fault) so could create a crude reproducer
situation with that.

To create the repro - I did an ugly hack into arm64/kvm/mmu.c.
The hack is to make sure that stage2 mapping are not created
at the time of vm_init by unsetting VM_PFNMAP flag. This `unsetting` flag
needed because vfio-pci's mmap func(/vfio_pci_mmap) by-default
sets the VM_PFNMAP flag for the MMIO region but I want
the remap_pfn_range() func to set the _PFNMAP flag via vfio's fault
handler func vfio_pci_mmap_fault().

So with above, when guest access the MMIO region, this will
trigger the mmio fault path at arm64-kvm hypervisor layer like below:
user_mem_abort() {->...
    --> Check the VM_PFNMAP flag, since not set so marks force_pte=false
    ....
    __gfn_to_pfn_memslot()-->
    ...
    handle_mm_fault()-->
    do_fault()-->
    vfio_pci_mmio_fault()-->
    remap_pfn_range()--> Now will set the VM_PFNMAP flag.
}

Since the force_pte flag is set to false so will lead to THP oops.
By setting the force_pte=true will avoid the THP Oops which was
mentioned in the [2] and patch proposition [1/1] fixes that.

hackish change to reproduce scenario:
--->
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d4cd25334610..b0a999aa6a95 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1318,6 +1318,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		vm_start = max(hva, vma->vm_start);
 		vm_end = min(reg_end, vma->vm_end);
 
+		/* Hack to make sure stage2 mapping not present, thus trigger
+		 * user_mem_abort for stage2 mapping
+		 */
+		if (vma->vm_flags & VM_PFNMAP) {
+			vma->vm_flags = vma->vm_flags & (~VM_PFNMAP);
+		}
 		if (vma->vm_flags & VM_PFNMAP) {
 			gpa_t gpa = mem->guest_phys_addr +
 				    (vm_start - mem->userspace_addr);


Thanks.
Santosh

[1] https://lkml.org/lkml/2020/10/23/310
[2] https://lkml.org/lkml/2020/10/21/460


Santosh Shukla (1):
  KVM: arm64: Correctly handle the mmio faulting

 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.7.4

