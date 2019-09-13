Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F04B175A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfIMCqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfIMCqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159507"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 02/11] KVM: x86/mmu: Treat invalid shadow pages as obsolete
Date:   Thu, 12 Sep 2019 19:46:03 -0700
Message-Id: <20190913024612.28392-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat invalid shadow pages as obsolete to fix a bug where an obsolete
and invalid page with a non-zero root count could become non-obsolete
due to mmu_valid_gen wrapping.  The bug is largely theoretical with the
current code base, as an unsigned long will effectively never wrap on
64-bit KVM, and userspace would have to deliberately stall a vCPU in
order to keep an obsolete invalid page on the active list while
simultaneously modifying memslots billions of times to trigger a wrap.

The obvious alternative is to use a 64-bit value for mmu_valid_gen,
but it's actually desirable to go in the opposite direction, i.e. using
a smaller 8-bit value to reduce KVM's memory footprint by 8 bytes per
shadow page, and relying on proper treatment of invalid pages instead of
preventing the generation from wrapping.

Note, "Fixes" points at a commit that was at one point reverted, but has
since been restored.

Fixes: 5304b8d37c2a5 ("KVM: MMU: fast invalidate all pages")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5ac5e3f50f92..373e6f052f9f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2252,7 +2252,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 #define for_each_valid_sp(_kvm, _sp, _gfn)				\
 	hlist_for_each_entry(_sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
-		if (is_obsolete_sp((_kvm), (_sp)) || (_sp)->role.invalid) {    \
+		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
@@ -2311,7 +2311,8 @@ static void mmu_audit_disable(void) { }
 
 static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+	return sp->role.invalid ||
+	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-- 
2.22.0

