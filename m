Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD87CB08D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbjJPQzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjJPQzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:55:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A280C8260;
        Mon, 16 Oct 2023 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bH4TweNwAW5PDjRc4LuWzqFQTxFArgLwB4OYW4yKw2M=;
  b=K4wdlT7FQZqbDahzMoGqS3+xQL/CiW2/HTUE6etAe85A0tiklLvtnKJ9
   ZS8cSe6tlAFkuIg4hmsVO1K5k4LiVlwdvSrvddpOpqZUFepOBHtje6BI/
   Ar7TdvCPWAt3Cy3ctFjejrhjgz945BMMGSvb6o4EWzpbL+o0Fjnnx3SyL
   ptKcoXgFxkxbZl9ZduoZGS7q/X1o0Vo9QfTyfLIXMFcIJyOYfKQTLSV/k
   Q0CR4w9rFSV0oja8XgJ20O+Q3jOn/zqiWXqJOC3/6iNq1+1a7BzznkiTF
   qqOklVWNsyyH0jzjH/ixoV2nUDoYJsd8IzZ+eEZodPE/3KPwvNXENhQLS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793165"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793165"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569238"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569238"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:15 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 08/16] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date:   Mon, 16 Oct 2023 09:20:59 -0700
Message-Id: <b55979d6935944f5e8ea5045feb16d90d53731d2.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/vmx/tdx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c37b66f9a52a..0558faee5b19 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1435,7 +1435,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
 	int i;
 
@@ -1457,7 +1458,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EAGAIN;
 	}
 	if (unlikely(err == (TDX_EPT_ENTRY_NOT_FREE | TDX_OPERAND_ID_RCX))) {
@@ -1473,7 +1474,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 					 &tmpout);
 		if (KVM_BUG_ON(tmp, kvm)) {
 			pr_tdx_error(TDH_MEM_SEPT_RD, tmp, &tmpout);
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			return -EIO;
 		}
 		pr_debug_ratelimited("gfn 0x%llx pg_level %d pfn 0x%llx entry 0x%llx level_stat 0x%llx\n",
@@ -1484,7 +1485,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 		if (level_state.level == tdx_level &&
 		    level_state.state == TDX_SEPT_PENDING &&
 		    entry.leaf && entry.pfn == pfn && entry.sve) {
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
 				       TDX_TD_ATTR_SEPT_VE_DISABLE));
 			return -EAGAIN;
@@ -1492,7 +1493,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	}
 
@@ -1528,7 +1529,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1546,7 +1547,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1599,7 +1600,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return 0;
 	}
 
@@ -1632,7 +1633,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 			r = -EIO;
 		} else {
 			tdx_clear_page(hpa, PAGE_SIZE);
-			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
 		}
 		hpa += PAGE_SIZE;
 	}
-- 
2.25.1

