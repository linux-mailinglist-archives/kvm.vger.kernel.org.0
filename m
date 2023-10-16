Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB87CB08A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjJPQzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjJPQze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:55:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3827EF7;
        Mon, 16 Oct 2023 09:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473391; x=1729009391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3eY264RkIk2rIxUpnKkNG2x5Y8gzvyqjfJuV3d5wUs=;
  b=chEkuZW4X8hN0GA26GY1G9Or4c/8yGuT5Bn1s/wX90eCba2vh390y0XV
   W0jHJYkj6Shw6WOTtHMXtF8s6AVPWL2Jo3ACkwnRGcat/05AoJGqQt5Z2
   impATT9P76us5sCmuIu0tcu0KtyYIeXmEhOuApZHn9wfi/9hsjquF8YD7
   LeS9eXuAkwvJgP1XUPDksIJa3igoByTEEjrEPKBjPEH84/5NEzUz6UO0/
   bkOOww8leFqc48nR50BVv91A8HZNihnQwJgClAoWX3RfzRAhQYRkrXtb0
   tjmiiqQcFIZJpNbaQlM75pO3LzRjTV/EcUQejR1rJire89uwSkTyGHmX0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793109"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793109"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569212"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569212"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:11 -0700
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
Subject: [RFC PATCH v5 01/16] KVM: TDP_MMU: Go to next level if smaller private mapping exists
Date:   Mon, 16 Oct 2023 09:20:52 -0700
Message-Id: <efea6398dd9cbbd7388d6a20e9b136f1a1c3f61e.1697473009.git.isaku.yamahata@intel.com>
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

Cannot map a private page as large page if any smaller mapping exists.

It has to wait for all the not-mapped smaller page to be mapped and
promote it to larger mapping.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4f58edbb8c06..012f270cfb6f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1414,7 +1414,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled ||
+		    kvm_gfn_shared_mask(vcpu->kvm))
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		/*
-- 
2.25.1

