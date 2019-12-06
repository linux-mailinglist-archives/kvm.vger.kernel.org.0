Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9D1159DA
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLFX5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:55585 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfLFX5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530346"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] KVM: x86/mmu: Incorporate guest's page level into max level for shadow MMU
Date:   Fri,  6 Dec 2019 15:57:21 -0800
Message-Id: <20191206235729.29263-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict the max level for a shadow page based on the guest's level
instead of capping the level after the fact for host-mapped huge pages,
e.g. hugetlbfs pages.  Explicitly capping the max level using the guest
mapping level also eliminates FNAME(page_fault)'s subtle dependency on
THP only supporting 2mb pages.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1938a6e4e631..7d57ec576df0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -773,7 +773,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
-	int level = PT_PAGE_TABLE_LEVEL;
+	int level;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
 	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
@@ -818,18 +818,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
 	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
 
-	max_level = lpage_disallowed ? PT_PAGE_TABLE_LEVEL :
-				       PT_MAX_HUGEPAGE_LEVEL;
-
-	if (walker.level >= PT_DIRECTORY_LEVEL && !is_self_change_mapping) {
-		level = mapping_level(vcpu, walker.gfn, &max_level);
-		if (likely(max_level > PT_DIRECTORY_LEVEL)) {
-			level = min(walker.level, level);
-			walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
-		}
-	} else {
+	if (lpage_disallowed || is_self_change_mapping)
 		max_level = PT_PAGE_TABLE_LEVEL;
-	}
+	else
+		max_level = walker.level;
+
+	level = mapping_level(vcpu, walker.gfn, &max_level);
+	if (level > PT_PAGE_TABLE_LEVEL)
+		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-- 
2.24.0

