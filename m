Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8B27CAEB6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjJPQQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPQQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:16:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1CEEE;
        Mon, 16 Oct 2023 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697472993; x=1729008993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i1nXNTgbx5yU2YQigLMbiNkBsRCdyOP6ibBVXR58JR4=;
  b=he+W/zGinw/bS9oFF6XT+6kLXEqgaHFWlL9xvK9I/GyEOEB9d7A9B3n8
   ZKgIdQ0V+EcvXbp/4rcMLdm7/NdmoCXPDyXwqUP6PncckX09IXDGCvoRq
   rZFbCIlfsTb18Jg98p+28+JmI84AhtvtcYAb9ACEwJxhq8pcTEmsglk9C
   G70gTQDJBBrxOmSPBRXz56CKOTIR73P/6H/1blaqJmka8ztHJmdXxyG+k
   oyfF/YotPC0uQmeAE56babLI7hwk0CdGQ+d48QymIWuQosCHfojUbia9H
   wG2ddytj3vRqKjK4ypNLWtAG3TZX/kyxz+GEbR9d7IB2D6SHIGunOfLbU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921731"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921731"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448091"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448091"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:40 -0700
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
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v16 040/116] KVM: x86/mmu: Assume guest MMIOs are shared
Date:   Mon, 16 Oct 2023 09:13:52 -0700
Message-Id: <4a2f5e6d6b1892f6f745685ed436fb5746db8c24.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
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

From: Chao Gao <chao.gao@intel.com>

Guest TD doesn't necessarily invoke MAP_GPA to convert the virtual MMIO
range to shared before accessing it.  When TD tries to access the virtual
device's MMIO as shared, an EPT violation is raised first.
kvm_mem_is_private() checks whether the GFN is shared or private.  If
MAP_GPA is not called for the GPA, KVM thinks the GPA is private and
refuses shared access, and doesn't set up shared EPT entry.  The guest
can't make progress.

Instead of requiring the guest to invoke MAP_GPA for regions of virtual
MMIOs assume regions of virtual MMIOs are shared in KVM as well (i.e., GPAs
either have no kvm_memory_slot or are backed by host MMIOs). So that guests
can access those MMIO regions.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eee5a46f5ce3..4ac34a0cc33e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4367,7 +4367,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	/*
+	 * !fault->slot means MMIO.  Don't require explicit GPA conversion for
+	 * MMIO because MMIO is assigned at the boot time.
+	 */
+	if (fault->slot &&
+	    fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
 		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
 			return RET_PF_RETRY;
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-- 
2.25.1

