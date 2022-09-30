Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8665F089A
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiI3KVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiI3KTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9109F1822E9;
        Fri, 30 Sep 2022 03:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533145; x=1696069145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ETYhmV4ggDyJkx64nnGBESEDJmnFJiUzMUdZ17hT8mE=;
  b=F2SUyS7foBvFRIQp4hjuPZsnEAZ7q98WCVkHjQc4DlybZcE47jTTlRZd
   GkH5PuYqvkF1PuLCLrt2ls9kI+dReGLAWIoMZwMaaM6vH0V6WbwHyNVe0
   WZTZu9l1L6pXIbE+rd7DzmRYf/APlntoPxlAJRoKMTUH4R6JBZcOu23d+
   t+rBjoE6EkRH2Q/7c0dYJkbAgjx7AdnmZNLY05ub+0ZzL2pjUTRENXVvc
   PUYbBtDAjCKT/9qrP1Y0IgLkrQLosWQQmclDa4zjcwUuVNjdX3FHUxRdf
   X12zGRK8E4XIjVoe/oOc0LolLSh5nr0N1sf0p/mhXMbnWvMVaM6amlaDG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870099"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870099"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807637"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807637"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 042/105] KVM: x86/mmu: Require TDP MMU for TDX
Date:   Fri, 30 Sep 2022 03:17:36 -0700
Message-Id: <aad7dfdebe3c10e5dd7c7e46de6cb539beb7f8f7.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ef8b0c929944..8f20c3857397 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -18,8 +18,12 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
+	/*
+	 * Because only the TDP MMU supports TDX, require the TDP MMU for guest
+	 * TDs.
+	 */
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return 0;
+		return kvm->arch.vm_type == KVM_X86_TDX_VM ? -EOPNOTSUPP : 0;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
-- 
2.25.1

