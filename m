Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A512B4FA6
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388577AbgKPSaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:30:39 -0500
Received: from mga06.intel.com ([134.134.136.31]:20645 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbgKPS2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:11 -0500
IronPort-SDR: KeEoDG1/XRI5Ya6bLtbezkv/Sy76zeMOl3CcEFKD1dnWeShcjB7onn5+A0xwEc5fWa+cZVNpMh
 3/FkxOVEWp7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410054"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410054"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:10 -0800
IronPort-SDR: bu2bFn08Vmg/gkRfuMIFM+4MC8Z1WaU9xjW2sSXdPprtJ8MDaqAu4pvoPNFF9tOeEPIx/1em+3
 JnVesnz854aw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528150"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:10 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 39/67] KVM: x86/mmu: Refactor shadow walk in __direct_map() to reduce indentation
Date:   Mon, 16 Nov 2020 10:26:24 -0800
Message-Id: <bfd8536d1345d281e8522f724177f56e0a645c2b.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Employ a 'continue' to reduce the indentation for linking a new shadow
page during __direct_map() in preparation for linking private pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 732510ecda36..25aafac9b5de 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2953,16 +2953,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			break;
 
 		drop_large_spte(vcpu, it.sptep);
-		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = __kvm_mmu_get_page(vcpu, base_gfn,
-						gfn_stolen_bits, it.addr,
-						it.level - 1, true, ACC_ALL);
-
-			link_shadow_page(vcpu, it.sptep, sp);
-			if (is_tdp && huge_page_disallowed &&
-			    req_level >= it.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-		}
+		if (is_shadow_present_pte(*it.sptep))
+			continue;
+
+		sp = __kvm_mmu_get_page(vcpu, base_gfn, gfn_stolen_bits,
+					it.addr, it.level - 1, true, ACC_ALL);
+
+		link_shadow_page(vcpu, it.sptep, sp);
+		if (is_tdp && huge_page_disallowed && req_level >= it.level)
+			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-- 
2.17.1

