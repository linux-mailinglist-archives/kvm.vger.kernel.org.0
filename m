Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3D221AF8
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgGPDl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:41:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:49384 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgGPDlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:25 -0400
IronPort-SDR: p6tTeAIB66487vYL/c2gZtKT35KJRJiDZ76M9ltXX52YVj7FWbf6xyg5XGqw+vXyjxQHjDnbkJ
 TrEfv+xAFYNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="147310949"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="147310949"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:25 -0700
IronPort-SDR: DR3TEtVdjfqxbJL2HGPnu+ac5DYClBHXt7BesmxtEopHKQW9vPCliDNnOCfKw4ME8gG9JydNMR
 WSakA7ipG0vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905473"
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
Subject: [PATCH 2/9] KVM: x86/mmu: Add separate helper for shadow NPT root page role calc
Date:   Wed, 15 Jul 2020 20:41:15 -0700
Message-Id: <20200716034122.5998-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the shadow NPT role calculation into a separate helper to
better differentiate it from the non-nested shadow MMU, e.g. the NPT
variant is never direct and derives its root level from the TDP level.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 678b6209dad50..0fb033ce6cc57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4908,7 +4908,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
+kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu, bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
 
@@ -4916,9 +4916,19 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 		!is_write_protection(vcpu);
 	role.base.smap_andnot_wp = role.ext.cr4_smap &&
 		!is_write_protection(vcpu);
-	role.base.direct = !is_paging(vcpu);
 	role.base.gpte_is_8_bytes = !!is_pae(vcpu);
 
+	return role;
+}
+
+static union kvm_mmu_role
+kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
+{
+	union kvm_mmu_role role =
+		kvm_calc_shadow_root_page_role_common(vcpu, base_only);
+
+	role.base.direct = !is_paging(vcpu);
+
 	if (!is_long_mode(vcpu))
 		role.base.level = PT32E_ROOT_LEVEL;
 	else if (is_la57_mode(vcpu))
@@ -4956,14 +4966,24 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efe
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
 
+static union kvm_mmu_role
+kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu)
+{
+	union kvm_mmu_role role =
+		kvm_calc_shadow_root_page_role_common(vcpu, false);
+
+	role.base.direct = false;
+	role.base.level = vcpu->arch.tdp_level;
+
+	return role;
+}
+
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 			     gpa_t nested_cr3)
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
-	union kvm_mmu_role new_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
+	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
-	new_role.base.level = vcpu->arch.tdp_level;
 	context->shadow_root_level = new_role.base.level;
 
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
-- 
2.26.0

