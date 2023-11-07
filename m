Return-Path: <kvm+bounces-996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB627E42C6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D4121C21283
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA083A297;
	Tue,  7 Nov 2023 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DvBd7RgG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353838DCF
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:08 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634D25FF2;
	Tue,  7 Nov 2023 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369320; x=1730905320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+LUQ4SRp+zcV29CpWhNabpshgVToAyo4Mcjem4Bu5Zc=;
  b=DvBd7RgGYAIJFDgxMlaQX4eQpD1nP06Xq2wxlAmsZMZvuimxJo75THx9
   jiodh6u4a6/c5//g5oujZCkinXs0FWgDGG75L2UFZ9Bths/2PZMxmJLOb
   nek/m2oDCR/CZJ/IOUMqhjeOPLzxJ0MA2+PLG8lYuHpjSph1hl7LAFjWn
   wda6e6qOuAEPyCzZGIMPHFH51/flO1BbHwNYpM1PjE9d1bdvxuj5q6amV
   IzD09wBKnQEiwWVFFYF3isqC4Ru5kzhTfVRBOb+wTcUZnj6BJ1k58lna3
   QG1cP8Mq03JSJVAGwQz9M/dazJfidA9qMbvQ18jZOe0nRIrfkNQLFXcUk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397591"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397591"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446814"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:57 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 08/16] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date: Tue,  7 Nov 2023 07:00:35 -0800
Message-Id: <c8d8b880963cc6799b681f7905a956022e47f16f.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368363.git.isaku.yamahata@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

When kvm_faultin_pfn(), it doesn't have the info regarding which page level
will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
2M page.

Move the guest private pages pinning logic right before
TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e4167f08b58b..7b81811eb404 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1454,7 +1454,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
 	int i;
 
@@ -1476,7 +1477,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EAGAIN;
 	}
 	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
@@ -1493,7 +1494,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	}
 
@@ -1529,7 +1530,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1547,7 +1548,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1600,7 +1601,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return 0;
 	}
 
@@ -1633,7 +1634,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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


