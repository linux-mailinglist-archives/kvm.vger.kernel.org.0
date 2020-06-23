Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28713205BF7
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbgFWTke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:40:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:64955 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387552AbgFWTkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:40:33 -0400
IronPort-SDR: 27dcbfEWvyUzYxD4UFoVGk5IKvgbvh7wqDC35wVAumvwtn18OxQZ+4ltKrgFfaSA8Uf/UPxGve
 MduHO7sn2CFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="205705218"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="205705218"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:40:29 -0700
IronPort-SDR: OxkCl1QTw9cXQdRJkueRV54wYK/yDLffHc0VHjfGjWwC06tlKrUIWsWCVA3h4m+jYwlKg79+T0
 /92R18hTihhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="319249372"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jun 2020 12:40:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Jon Cargille <jcargill@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Optimize MMU page cache lookup for fully direct MMUs
Date:   Tue, 23 Jun 2020 12:40:27 -0700
Message-Id: <20200623194027.23135-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623194027.23135-1-sean.j.christopherson@intel.com>
References: <20200623194027.23135-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the unsync checks and the write flooding clearing for fully direct
MMUs, which are guaranteed to not have unsync'd or indirect pages (write
flooding detection only applies to indirect pages).  For TDP, this
avoids unnecessary memory reads and writes, and for the write flooding
count will also avoid dirtying a cache line (unsync_child_bitmap itself
consumes a cache line, i.e. write_flooding_count is guaranteed to be in
a different cache line than parent_ptes).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 67f8f82e9783..c568a5c55276 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2475,6 +2475,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
+	bool direct_mmu = vcpu->arch.mmu->direct_map;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2490,8 +2491,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (role.direct)
 		role.gpte_is_8_bytes = true;
 	role.access = access;
-	if (!vcpu->arch.mmu->direct_map
-	    && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
+	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -2510,6 +2510,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (sp->role.word != role.word)
 			continue;
 
+		if (direct_mmu)
+			goto trace_get_page;
+
 		if (sp->unsync) {
 			/* The page is good, but __kvm_sync_page might still end
 			 * up zapping it.  If so, break in order to rebuild it.
@@ -2525,6 +2528,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 
 		__clear_sp_write_flooding_count(sp);
+
+trace_get_page:
 		trace_kvm_mmu_get_page(sp, false);
 		goto out;
 	}
-- 
2.26.0

