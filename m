Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB3A6FC8A2
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbjEIOQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjEIOQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:16:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF653580;
        Tue,  9 May 2023 07:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641772; x=1715177772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0dNyFxF2R8H8nDmO1BfaeIPx4OHrZOLpuoFOx9cABLg=;
  b=DKuL0WsZAyO7UmgBUucgIO3XP3RYGkdZ4SwioPiX0AeSD7/UmGJjkKI1
   Z/ufS5RdlpnLt/ddHe6ksBPkfOYeK05OshSR8V0jLIMeQMESnNfVh41jc
   PIiRZsVUT+X67ltuT9CZmCS3wqJXx2Lxmwiht+6l79ug9sGXAe7XIBFpK
   GE6IZXAaNkwNFe4tAbV6b+t4d3nhlIeqvbTNAdW5ggqHqXMFZ2dnBcGtV
   tS3RedgqgYUsuEDGoxBud5+2phH8U540ICoQJXoxGtsXXsYy2cOmGoBVw
   5PqU79Qw+/kSevWjk8Unsutm7wuM3WypL0Zc6Zw81CiFIWGyXBqkFWlcy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="349971732"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="349971732"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="945298305"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="945298305"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:16:10 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/6] KVM: x86/mmu: only zap EPT when guest CR0_CD changes
Date:   Tue,  9 May 2023 21:51:10 +0800
Message-Id: <20230509135110.1664-1-yan.y.zhao@intel.com>
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

Guest CR0_CD value will affect memory type of EPT leaf entry with
noncoherent DMA present. But mmu zap is not necessary if EPT is not
enabled.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7f78fe79b32..ed1e3939bd05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -942,7 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
 	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+		kvm_zap_gfn_for_memtype(vcpu->kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 
-- 
2.17.1

