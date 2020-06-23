Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D03205BFD
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbgFWTkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:40:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:64955 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387442AbgFWTk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:40:29 -0400
IronPort-SDR: TH3lobsh+GvUDkEROc0lXs4Fq2FespYfmuwIo7dCgZirFAAjTZJh4MVsqlmFSMwgJWR8V7XwTd
 M++HcgeRIgQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="205705217"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="205705217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:40:29 -0700
IronPort-SDR: 05tE0GLhuyI3F46Oq3sOoMHZmyc2D5d7erJVwrsYJ7Kd25vOwzaSSq73I+4JcjGsSHVmBV3BPy
 PcejMBCW+zAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="319249367"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jun 2020 12:40:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Jon Cargille <jcargill@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Avoid multiple hash lookups in kvm_get_mmu_page()
Date:   Tue, 23 Jun 2020 12:40:26 -0700
Message-Id: <20200623194027.23135-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623194027.23135-1-sean.j.christopherson@intel.com>
References: <20200623194027.23135-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor for_each_valid_sp() to take the list of shadow pages instead of
retrieving it from a gfn to avoid doing the gfn->list hash and lookup
multiple times during kvm_get_mmu_page().

Cc: Peter Feiner <pfeiner@google.com>
Cc: Jon Cargille <jcargill@google.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3dd0af7e7515..67f8f82e9783 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2258,15 +2258,14 @@ static bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
-
-#define for_each_valid_sp(_kvm, _sp, _gfn)				\
-	hlist_for_each_entry(_sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
+#define for_each_valid_sp(_kvm, _sp, _list)				\
+	hlist_for_each_entry(_sp, _list, hash_link)			\
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
-	for_each_valid_sp(_kvm, _sp, _gfn)				\
+	for_each_valid_sp(_kvm, _sp,					\
+	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
 static inline bool is_ept_sp(struct kvm_mmu_page *sp)
@@ -2477,6 +2476,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
+	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
 	bool need_sync = false;
@@ -2496,7 +2496,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_valid_sp(vcpu->kvm, sp, gfn) {
+
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
@@ -2533,8 +2535,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	sp->gfn = gfn;
 	sp->role = role;
-	hlist_add_head(&sp->hash_link,
-		&vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)]);
+	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		/*
 		 * we should do write protection before syncing pages
-- 
2.26.0

