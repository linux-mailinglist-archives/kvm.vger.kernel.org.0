Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0672E647A10
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLHXf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLHXfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:54 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3006BC9B;
        Thu,  8 Dec 2022 15:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542553; x=1702078553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=22ehivlpNlURKI1NMGM4Gdwtt2lvDad5mDmE/luUqYU=;
  b=nHLqefISEAH4xJb6JeKbJ/QmjQokv4GonPJmhb/rTa5ApAMz8UJemRkw
   Fdff1fRCUdA6Aj+p0/AQkEE2hmYmrcllYyMvx8Sh1c+JNMLyqBf5c1/gN
   dMP5f8R3zoHub25ZyLR7qC0aTkOlgS7N9dTSeBpsRoyPtwV/F23ycdJb2
   /Scfyl0eWMjNbXb5or8MTO3TWJ1M19CTbClUEpKH1m8NrTii9XBVnRPWE
   pxcukqGWvMQgmznap8eIItoRM+kCbvJ8zL9w18LpMV2oXpWjLodKk4v4w
   9bqVF8B/NpwcCQ/emvi0ds2Q64BFndwUeGvc53nB35lTBt7Xz31Lqcy5Z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586475"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586475"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950875"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950875"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:51 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 01/15] KVM: TDP_MMU: Go to next level if smaller private mapping exists
Date:   Thu,  8 Dec 2022 15:35:36 -0800
Message-Id: <e3677733e596a869a72d284401bc87d950cb1fbd.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 65b9af33a0eb..cb36089a40da 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1373,7 +1373,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled ||
+		    kvm_gfn_shared_mask(vcpu->kvm))
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		if (iter.level == fault->goal_level)
-- 
2.25.1

