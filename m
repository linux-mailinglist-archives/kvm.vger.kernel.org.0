Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3D6FC8A4
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbjEIOQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbjEIOQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:16:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F87530D6;
        Tue,  9 May 2023 07:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641802; x=1715177802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=CFYbkufDbUcvakbzS3v4+C+2rYDU17Dc/1vzYarICt0=;
  b=GhfN7zDZG0Q8lRzwApqCz3NqHUDv6C01Qa+6ZQrdSXeO0q+55no/sm01
   32sMiBIm9f8JKojvWevsaHYBkto21MuycZ8zCE6nckKRtk9EqhI2Bh/VK
   xaaBWq9kFCL2Tsvw7Bdu1lKaIplZ9LPDM2lpV7XxgQBS4u9Zb9DUz95XK
   x6YVWMHvJHUtKAvM1KqbH9rGBu8sIw96Cx1HfHAv7VVhg2SUkfUB//Sxv
   NhM5DBAMXaF36QB/Ex4J+GPD6xyVFwgui8Ot3ncCCoDSi2OYfM2yAPocx
   SYb6UL6mb3lDRaXn8L0y/a2F2XaJqI977rKI4sAeVfN6ekQBDpDYm4KNI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="349971876"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="349971876"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:16:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="945298429"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="945298429"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:16:40 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Date:   Tue,  9 May 2023 21:51:43 +0800
Message-Id: <20230509135143.1721-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509134825.1523-1-yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call new helper kvm_zap_gfn_for_memtype() to skip zap mmu if EPT is not
enabled.

When guest MTRR changes and it's desired to zap TDP entries to remove
stale mappings, only do it when EPT is enabled, because only memory type
of EPT leaf is affected by guest MTRR with noncoherent DMA present.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 9fac1ec03463..62ebb9978156 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -330,7 +330,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 		var_mtrr_range(&mtrr_state->var_ranges[index], &start, &end);
 	}
 
-	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
+	kvm_zap_gfn_for_memtype(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
 }
 
 static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
-- 
2.17.1

