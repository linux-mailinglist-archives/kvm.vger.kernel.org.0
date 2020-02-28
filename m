Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5A2174287
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgB1Wwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:52:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:64083 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgB1Wwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:52:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="439387486"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 28 Feb 2020 14:52:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/mmu: Ignore guest CR3 on fast root switch for direct MMU
Date:   Fri, 28 Feb 2020 14:52:39 -0800
Message-Id: <20200228225240.8646-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228225240.8646-1-sean.j.christopherson@intel.com>
References: <20200228225240.8646-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore the guest's CR3 when looking for a cached root for a direct MMU,
the guest's CR3 has no impact on the direct MMU's shadow pages (the
role check ensures compatibility with CR0.WP, etc...).

Zero out root_cr3 when allocating the direct roots to make it clear that
it's ignored.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c4e0b97f82ac..9d617b9dc78f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3730,7 +3730,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 	} else
 		BUG();
-	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+
+	/* root_cr3 is ignored for direct MMUs. */
+	vcpu->arch.mmu->root_cr3 = 0;
 
 	return 0;
 }
@@ -4272,8 +4274,8 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		swap(root, mmu->prev_roots[i]);
 
-		if (new_cr3 == root.cr3 && VALID_PAGE(root.hpa) &&
-		    page_header(root.hpa) != NULL &&
+		if ((new_role.direct || new_cr3 == root.cr3) &&
+		    VALID_PAGE(root.hpa) && page_header(root.hpa) &&
 		    new_role.word == page_header(root.hpa)->role.word)
 			break;
 	}
-- 
2.24.1

