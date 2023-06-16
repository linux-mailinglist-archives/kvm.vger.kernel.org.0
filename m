Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8340F732596
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbjFPDED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjFPDD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:03:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30AC2D47;
        Thu, 15 Jun 2023 20:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884638; x=1718420638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tApTo48fmEWmOt000/vMI+RpIzA2pYKklHGoAN2lprc=;
  b=DCilRLKjlPcbjNYarsrjYWgkn934h+4jjB88EP+z5vlvBftB7ok9v1Mw
   HydxmHlgzrXTb4w/ksrTd3wuhEQD82n4fYODyBb+Gfzg+dRxDruGSv4Mu
   AQ2z+cZx38yCvX3J201s/CbEzHU+/iLY/Dy+4msQDelUQHLNy3DkYHzOY
   HhzjGxgyZr8H6kHLauEC3MMQ3ZZY+zkyJCd1hlkvk0y3Ip9gS0j1F9CKz
   9qjCRhwtjgNtwfVkgKfIzH8dGFiORlBjWWSDVy5EBQH63I4JWJh1tdSo8
   Fef0qiupUYibaur28516osfkm0nqtAo4xPgYqSSVKJhVf4qFiSm8T9Enl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="357976726"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="357976726"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782724568"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="782724568"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:03:34 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
Date:   Fri, 16 Jun 2023 10:38:15 +0800
Message-Id: <20230616023815.7439-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
types when cache is disabled and non-coherent DMA are present.

With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
EPT memory type when guest cache is disabled before this patch.
Removing the IPAT bit in this patch will allow effective memory type to
honor PAT values as well, which will make the effective memory type
stronger than WB as WB is the weakest memtype. However, this change is
acceptable as it doesn't make the memory type weaker, consider without
this quirk, the original memtype for cache disabled is UC + IPAT.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..c1e93678cea4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7548,8 +7548,6 @@ static int vmx_vm_init(struct kvm *kvm)
 
 static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
-	u8 cache;
-
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
 	 * We have to be careful as to what are honored and when.
@@ -7576,11 +7574,10 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-			cache = MTRR_TYPE_WRBACK;
+			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
 		else
-			cache = MTRR_TYPE_UNCACHABLE;
-
-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
+				VMX_EPT_IPAT_BIT;
 	}
 
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
-- 
2.17.1

