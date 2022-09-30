Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA25F088E
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiI3KVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiI3KTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4C916EABD;
        Fri, 30 Sep 2022 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533144; x=1696069144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wamxAOh4thSrU2qmpuymJBKWtZQH6fNwm0ilxwILaF4=;
  b=h1ZvlFpS2Q2jqVnndUlKB5m3bkyjUj+vXFfutP2sN/DnDYapf6XCviH5
   RvbZYipdk+2p2P6LPu2ATUNTc1Pblo5dBNcYyjz008f8k3yL5FamMXpV2
   ExJ7K5NjvYsylVtTJqgggb7wqsc3qPmEOvfIzmpMXPfUhoeEZBWFY+aKw
   FFCL2LxOY+nbUqQwniEmVzDNj3HiP4ABjEgL2C9ignG4fwyTHqM2/3v03
   9LSp1aas6ZRDlBlWKDYZJPVX1VhvEHRCeKo7guCrunNIOuVPI6WcTTmIj
   GisVQ2QjaQTlE6yC91QLDIGnAr0UZgHOimmYrj0T7H/XrOBimO6hEMnqD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870097"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870097"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807631"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807631"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 040/105] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Date:   Fri, 30 Sep 2022 03:17:34 -0700
Message-Id: <6dbf687ab23f696fa5591818769ee90b0201fe3f.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
hypercall needs to populate non-leaf SPTE to record which GPA, private or
shared, is allowed in the leaf EPT entry.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5ecb976ed954..9e7b18c3f3e3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1145,6 +1145,24 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter,
+				    bool account_nx)
+{
+	struct kvm_mmu_page *sp;
+	int ret;
+
+	KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), vcpu->kvm);
+	KVM_BUG_ON(is_removed_spte(iter->old_spte), vcpu->kvm);
+
+	sp = tdp_mmu_alloc_sp(vcpu);
+	tdp_mmu_init_child_sp(sp, iter);
+
+	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
+	if (ret)
+		tdp_mmu_free_sp(sp);
+	return ret;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1153,7 +1171,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1199,13 +1216,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = tdp_mmu_alloc_sp(vcpu);
-			tdp_mmu_init_child_sp(sp, &iter);
-
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
-				tdp_mmu_free_sp(sp);
+			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
 				break;
-			}
 		}
 	}
 
-- 
2.25.1

