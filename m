Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E3914DB94
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgA3N0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgA3N0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:26:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6313C2253D;
        Thu, 30 Jan 2020 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390776;
        bh=sU3BN8Mr1a6hHJBH+fD0D7nFUL2EjE2fR14sj2cpogk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQE5L7PHLSJdraQXk9r6p2fkp+0+sjJEipYB0nxWtgDIDuWzS+cx1b6b9rlmAsLMK
         8o3AY8vMkLO8R5LKEc4U7L0oAPIwP9WmCIpSVGRJK/CtEuyWFdqvvhf4GQhJKjphmm
         0k6rSKZrjeaw9totwXTrFkvBIjMGl+fjDMrMUtEc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9pm-002BmW-N0; Thu, 30 Jan 2020 13:26:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 07/23] KVM: arm/arm64: Re-check VMA on detecting a poisoned page
Date:   Thu, 30 Jan 2020 13:25:42 +0000
Message-Id: <20200130132558.10201-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com, wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org, mark.rutland@arm.com, rmk+kernel@armlinux.org.uk, shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

When we check for a poisoned page, we use the VMA to tell userspace
about the looming disaster. But we pass a pointer to this VMA
after having released the mmap_sem, which isn't a good idea.

Instead, stash the shift value that goes with this pfn while
we are holding the mmap_sem.

Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Link: https://lore.kernel.org/r/20191211165651.7889-3-maz@kernel.org
Link: https://lore.kernel.org/r/20191217123809.197392-1-james.morse@arm.com
---
 virt/kvm/arm/mmu.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..e3ad95013192 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1596,16 +1596,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
 	__invalidate_icache_guest_page(pfn, size);
 }
 
-static void kvm_send_hwpoison_signal(unsigned long address,
-				     struct vm_area_struct *vma)
+static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
-	short lsb;
-
-	if (is_vm_hugetlb_page(vma))
-		lsb = huge_page_shift(hstate_vma(vma));
-	else
-		lsb = PAGE_SHIFT;
-
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
@@ -1678,6 +1670,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
+	short vma_shift;
 	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
@@ -1701,7 +1694,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	vma_pagesize = vma_kernel_pagesize(vma);
+	if (is_vm_hugetlb_page(vma))
+		vma_shift = huge_page_shift(hstate_vma(vma));
+	else
+		vma_shift = PAGE_SHIFT;
+
+	vma_pagesize = 1ULL << vma_shift;
 	if (logging_active ||
 	    (vma->vm_flags & VM_PFNMAP) ||
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
@@ -1741,7 +1739,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma);
+		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
 	if (is_error_noslot_pfn(pfn))
-- 
2.20.1

