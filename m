Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F12667C4E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbjALRN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjALRNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:13:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D347DE37;
        Thu, 12 Jan 2023 08:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542149; x=1705078149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H/nxuouj18bYRqF828XvaIlfCKsR/L23rNhgJlNwdfo=;
  b=P6myxIpSVEp2KVzZQUl10a6eoh3rRlEny7PIgBhqdQzQ0MhzmJPLLmg/
   VmxVY9eYEdEeZFebO9UqibpvQ6XtDJoNOvXTueZDZ/7VHCz/HgCdZ5Trb
   EQxxfbHEangkhcXo414dXJL35kasJ+uSFjr0EtC1borIugbyKxZjCu6dn
   P9pvSR5wIFQ+9K7/YRARTaL5Pp8QmMBp3DwnCt+J6J6gHqbLgYlAQ/SNA
   moRgv70u7Vc+5tllctFCVpC0KAfekKOadgNdy3cDeQLy11u2bR0M8E7Vb
   UE5xpPy/5U1nZKB4OJWEmU27ceRBon0jwAkA1f0y79cgbCgUHEPyK/2OX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816312"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816312"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658344"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658344"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 08/16] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date:   Thu, 12 Jan 2023 08:44:00 -0800
Message-Id: <49633539246692ba834c812952dcaf8fecc7600b.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

When kvm_faultin_pfn(), it doesn't have the info regarding which page level
will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
2M page.

Move the guest private pages pinning logic right before
TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66a1f8534461..177f98f7c9c2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1322,7 +1322,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
 	int i;
 
@@ -1358,12 +1359,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx))) {
 		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			return -EAGAIN;
 		}
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			return -EIO;
 		}
 		return 0;
@@ -1386,7 +1387,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1404,7 +1405,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (err == TDX_ERROR_SEPT_BUSY);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1433,7 +1434,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return 0;
 	}
 
@@ -1465,7 +1466,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 			r = -EIO;
 		} else
-			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
 		hpa += PAGE_SIZE;
 	}
 	return r;
-- 
2.25.1

