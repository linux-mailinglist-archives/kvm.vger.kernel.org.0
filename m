Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A71D6127EF
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJ3GZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiJ3GYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F0F13C;
        Sat, 29 Oct 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111050; x=1698647050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XTbYY1fmIyEn8RqQg2g2IUB+pcesS3c7XzjHCDTS0FQ=;
  b=Iw+GFymTIGkx5EbISqnZrHFdmMhH9/fnUdut9U3Axbyqk4q5ud0sC9Sc
   XQXy00IpbrYaFEJ/EEZ4nvbdWezEKcZKmqqOcwxlbxwn3m9Hg8IuJzySI
   ynAS40vjzULeTaheKzwF9miog4GnbiLIu/A03UV4MT3Lcy9ijbnzkqjTF
   5h7njKv3xJZan3Q/4QgRUw/o2j0/X11eFqFqMUpKCX4xtZHAJx0oYHmBq
   ELuxLFjQYATwEtw2TxHZnUEz3xw+SWjKOpBCbkkDJIAreog2442Wx5c+/
   yc59erGK+4UrTdmSzxJl4fznTixhgT6O7ebZGNOyKcyvjWL2QyHicyaXN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037155"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037155"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392985"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392985"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 043/108] KVM: x86/mmu: Require TDP MMU for TDX
Date:   Sat, 29 Oct 2022 23:22:44 -0700
Message-Id: <82c25eec5a4c42e4b6a2038c7553bbaf56e87091.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c6be76f9849c..1bf58288ea79 100644
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

