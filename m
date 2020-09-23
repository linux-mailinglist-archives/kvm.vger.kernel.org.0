Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8B275D81
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIWQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:33:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:27783 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgIWQdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:33:15 -0400
IronPort-SDR: vyjTp+K7jFAtj1NxaWM0ujy+bqotUWvunx88KoRjEZRQysh1O/OhMs4CK0LRNLYXmweeBnbPhV
 eFa1B/tJTp2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140413544"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140413544"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:33:14 -0700
IronPort-SDR: qAOAGD9cR6U9BamXE2pPCcOnr6pygIUmJ1axxJv3JnIoo+SX3OaBXZZcIPzNOLx0ImDAzhjAlO
 JqtGTlpPmC5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="348938302"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 09:33:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Move individual kvm_mmu initialization into common helper
Date:   Wed, 23 Sep 2020 09:33:14 -0700
Message-Id: <20200923163314.8181-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move initialization of 'struct kvm_mmu' fields into alloc_mmu_pages() to
consolidate code, and rename the helper to __kvm_mmu_create().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..a2c4c71ce5f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5682,11 +5682,17 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	free_page((unsigned long)mmu->lm_root);
 }
 
-static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
 	struct page *page;
 	int i;
 
+	mmu->root_hpa = INVALID_PAGE;
+	mmu->root_pgd = 0;
+	mmu->translate_gpa = translate_gpa;
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
+
 	/*
 	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
 	 * while the PDP table is a per-vCPU construct that's allocated at MMU
@@ -5712,7 +5718,6 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	uint i;
 	int ret;
 
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
@@ -5726,25 +5731,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-	vcpu->arch.root_mmu.root_hpa = INVALID_PAGE;
-	vcpu->arch.root_mmu.root_pgd = 0;
-	vcpu->arch.root_mmu.translate_gpa = translate_gpa;
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-		vcpu->arch.root_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-
-	vcpu->arch.guest_mmu.root_hpa = INVALID_PAGE;
-	vcpu->arch.guest_mmu.root_pgd = 0;
-	vcpu->arch.guest_mmu.translate_gpa = translate_gpa;
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-
 	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
 
-	ret = alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
+	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
 	if (ret)
 		return ret;
 
-	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
+	ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
 	if (ret)
 		goto fail_allocate_root;
 
-- 
2.28.0

