Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4246811B953
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 17:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfLKQ5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 11:57:08 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:40525 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbfLKQ5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 11:57:07 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1if5IP-00076q-7X; Wed, 11 Dec 2019 17:57:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned page
Date:   Wed, 11 Dec 2019 16:56:49 +0000
Message-Id: <20191211165651.7889-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211165651.7889-1-maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, Christoffer.Dall@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we check for a poisoned page, we use the VMA to tell userspace
about the looming disaster. But we pass a pointer to this VMA
after having released the mmap_sem, which isn't a good idea.

Instead, re-check that we have still have a VMA, and that this
VMA still points to a poisoned page. If the VMA isn't there,
userspace is playing with our nerves, so lety's give it a -EFAULT
(it deserves it). If the PFN isn't poisoned anymore, let's restart
from the top and handle the fault again.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..f73393f5ddb7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1741,9 +1741,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma);
-		return 0;
+		/*
+		 * Search for the VMA again, as it may have been
+		 * removed in the interval...
+		 */
+		down_read(&current->mm->mmap_sem);
+		vma = find_vma_intersection(current->mm, hva, hva + 1);
+		if (vma) {
+			/*
+			 * Recheck for a poisoned page. If something changed
+			 * behind our back, don't do a thing and take the
+			 * fault again.
+			 */
+			pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+			if (pfn == KVM_PFN_ERR_HWPOISON)
+				kvm_send_hwpoison_signal(hva, vma);
+
+			ret = 0;
+		} else {
+			ret = -EFAULT;
+		}
+		up_read(&current->mm->mmap_sem);
+		return ret;
 	}
+
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-- 
2.20.1

