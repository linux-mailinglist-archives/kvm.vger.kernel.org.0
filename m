Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96CA7CAFF6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjJPQkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343569AbjJPQjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:39:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9948255;
        Mon, 16 Oct 2023 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yRWbSVt3B/Gex4+EgIb9aWYiPKxKJtDXPk/HN1H82fE=;
  b=ncosRVKfHbHSV9DFV5dX/q5qGdowDuYe/dQQzRcOuCO/IEcOnHtlzWeB
   /VNszo3DLaNC+KPG7em0Koe1EnP/gzgKP+jpnMudWPgKDCEM6GuVzxbib
   fVBb4PJDWGIQ07GBXWqzia+V7u+6IBeK/0k/brhBbfaAWyxs9da8gp0cM
   deinIIqRGER21hVfR7uZT7hPMCIUwKk5UFEMZVQU7KAYbtDZAy91i6r+L
   FRyA/ewmjwVDXi3A+cN0KIP6pEXWJsxe+p2TeBqgUCY2Yh2X+jQlTIznQ
   JyyFAvL7S/XTTkLkMkS4YCXOKJruEq7zE3wFGzB8aD9o8aFor9485/Ulf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793127"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793127"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569223"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569223"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:12 -0700
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
Subject: [RFC PATCH v5 04/16] KVM: TDX: Pass size to tdx_measure_page()
Date:   Mon, 16 Oct 2023 09:20:55 -0700
Message-Id: <8c0aa0968cb1f995cbd4552e1f2cf79ac443475b.1697473009.git.isaku.yamahata@intel.com>
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

Extend tdx_measure_page() to pass size info so that it can measure
large page as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 471128946e63..bda2c8fa895c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1415,13 +1415,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
-static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 {
 	struct tdx_module_args out;
 	u64 err;
 	int i;
 
-	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+	WARN_ON_ONCE(size % TDX_EXTENDMR_CHUNKSIZE);
+
+	for (i = 0; i < size; i += TDX_EXTENDMR_CHUNKSIZE) {
 		err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
 		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
 			pr_tdx_error(TDH_MR_EXTEND, err, &out);
@@ -1543,7 +1545,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 		tdx_unpin(kvm, pfn);
 		return -EIO;
 	} else if (measure)
-		tdx_measure_page(kvm_tdx, gpa);
+		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
 
 	return 0;
 
-- 
2.25.1

