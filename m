Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB62667C38
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbjALRJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbjALRJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:09:09 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312FF27183;
        Thu, 12 Jan 2023 08:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542039; x=1705078039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lN2sQKQJw+fvb4BXvuf9J5Yol5hJrcIFcz4ejYm1oT4=;
  b=ngXnomQlVKnBsNdwhxKf++UkUySDbW6mcS+d/kUgROxSgv5VaBJGcIzF
   994Cmw4MnXz+oNNbuRzP/AWj7MUP+drSQCaaBHDGw72DNRAO9av+RLLXM
   ZJvNIYdavP+WJnpmQ+LlQtz2SHAzbZ3+gs0npCzcxDSYDTlPcgG25HnXW
   Ir9JLWLwKhk5iuHT7WR7jjm47noXXj+sXnGipmFZAnkBn8pHc51c9APn1
   2LZ4JnuwHzQbrlcGnRqpj6apw3+iZqDBthO9k0StF72Ami7dPZaFAPDiU
   gB7yuTq2gPLH6qFK/OBiHaLM6+BeCwwJkb8iqy79+4CzH3+vxLVieCK18
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816274"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816274"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658318"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658318"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 01/16] KVM: TDP_MMU: Go to next level if smaller private mapping exists
Date:   Thu, 12 Jan 2023 08:43:53 -0800
Message-Id: <588de42a732a068bdcff46494865c0345d289bb2.1673541292.git.isaku.yamahata@intel.com>
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

Cannot map a private page as large page if any smaller mapping exists.

It has to wait for all the not-mapped smaller page to be mapped and
promote it to larger mapping.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 69e202bd1897..5c2c7e8ea62e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1394,7 +1394,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled ||
+		    kvm_gfn_shared_mask(vcpu->kvm))
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		/*
-- 
2.25.1

