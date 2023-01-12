Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331CF667B74
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbjALQmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240173AbjALQi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC11A83E;
        Thu, 12 Jan 2023 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541242; x=1705077242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kf558c4eCLwp5ypIKzt7alAtawhZgod3QvZLUM8K0+8=;
  b=m8a0iLpBrlUoLmcOo79tq6tGJjxxUjDtw84/P6csgfCmBE3eWhOUMMrU
   4R7ezXZKDZbdKldq9+6hHL8V08x4JECNPvB5UL5hsbB6FBfzrbsX7cUUy
   KFowVsJRaPtFD4sYGHTHFpNiM4MZ8Um8H5n+fFQdNP6LpO/EvtYD7LTXb
   hp0lPnRIk7cYpt0uVHXFpz2uj2Nmpi8OTEsRt13VGtpN+zJicKHwU+Y6B
   CSf4wOhwenPXnyi95QEyml5GB3sfT7ZQMSA9ZhmzDMZAmK2qavRQupEfc
   lKhj82Gtt/WGmXMHwHSKDU6m/7/BmxXo29Nf8NTF9LZ5VwoW+6thzdUgh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811837"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811837"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151765"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151765"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:26 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 039/113] KVM: x86/mmu: Require TDP MMU for TDX
Date:   Thu, 12 Jan 2023 08:31:47 -0800
Message-Id: <c67b3702c8721d4164eaf5f56474747aeeefd426.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Require the TDP MMU for guest TDs, the so called "shadow" MMU does not
support mapping guest private memory, i.e. does not support Secure-EPT.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fdcff390ebc2..6c3ce4121a46 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -27,6 +27,13 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	if (kvm->arch.vm_type == KVM_X86_TDX_VM && !enable_mmio_caching)
 		return -EOPNOTSUPP;
 
+	/*
+	 * Because only the TDP MMU supports TDX, require the TDP MMU for guest
+	 * TDs.
+	 */
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM && !tdp_enabled)
+		return -EOPNOTSUPP;
+
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
 		return 0;
 
-- 
2.25.1

