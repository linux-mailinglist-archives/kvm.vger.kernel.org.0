Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE214221AF7
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGPDmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:42:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:4816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgGPDl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:26 -0400
IronPort-SDR: KBzR0Y0lEgz1aiCquMKEMqdMRbMJJR67MX0HwtgL1a9YNIcvu3EkDGlsVxE6Sw2+KeTda2ZdtL
 5J4/EDHCwcTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137442918"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="137442918"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:25 -0700
IronPort-SDR: CbvKX32DWYuILUC4AMNPiYJervepMLVCWi+vLMdAyidnQvm8N3s1mSrZjMGzSCETd9E+eLo/OP
 wYnsjHvvFR2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905493"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 Jul 2020 20:41:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] KVM: x86/mmu: Rename max_page_level to max_huge_page_level
Date:   Wed, 15 Jul 2020 20:41:21 -0700
Message-Id: <20200716034122.5998-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename max_page_level to explicitly call out that it tracks the max huge
page level so as to avoid confusion when a future patch moves the max
TDP level, i.e. max root level, into the MMU and kvm_configure_mmu().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 559b4b92b5e27..c867b35759ab5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -92,7 +92,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
-static int max_page_level __read_mostly;
+static int max_huge_page_level __read_mostly;
 
 enum {
 	AUDIT_PRE_PAGE_FAULT,
@@ -3256,7 +3256,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PG_LEVEL_4K;
 
-	max_level = min(max_level, max_page_level);
+	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
 		if (!linfo->disallow_lpage)
@@ -5580,23 +5580,23 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
+void kvm_configure_mmu(bool enable_tdp, int tdp_huge_page_level)
 {
 	tdp_enabled = enable_tdp;
 
 	/*
-	 * max_page_level reflects the capabilities of KVM's MMU irrespective
+	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
 	 * of kernel support, e.g. KVM may be capable of using 1GB pages when
 	 * the kernel is not.  But, KVM never creates a page size greater than
 	 * what is used by the kernel for any given HVA, i.e. the kernel's
 	 * capabilities are ultimately consulted by kvm_mmu_hugepage_adjust().
 	 */
 	if (tdp_enabled)
-		max_page_level = tdp_page_level;
+		max_huge_page_level = tdp_huge_page_level;
 	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
-		max_page_level = PG_LEVEL_1G;
+		max_huge_page_level = PG_LEVEL_1G;
 	else
-		max_page_level = PG_LEVEL_2M;
+		max_huge_page_level = PG_LEVEL_2M;
 }
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
-- 
2.26.0

