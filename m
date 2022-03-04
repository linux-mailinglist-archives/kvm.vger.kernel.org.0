Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18F4CDF0D
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiCDUc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiCDUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDB1E6973;
        Fri,  4 Mar 2022 12:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425889; x=1677961889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5EvB3Qsy41TV5MUlOD9BImze2W58q8VkU72+5iJ26d8=;
  b=WgJZnfh85gas4G2hbFxozpeWHM+sDKgZPafvRqKs8eywCoy2QoSLOARE
   d968+9ZE1+tWGAVRGdi/0kGOZZ0G639nS1p2jbbQx+CwXz51f9ka2wWy/
   gXl8L07Eyy/QTkjE9mid6vSV8bMgQL0nUUWyMGDF5qJz7cG0drudd22mj
   MpieFxA5SGaYrCqZgDb6mg03G4sOSNTTyX/5BfJw8wcIjwq97FEBFoUrE
   zDKY5vN6vIY8M5IBt2gnAcc09lAaTRc56BcFoeRrDcnpopwnQh1zvvnft
   X4CML3TX7of6qHjWxnW7vc8calLxArJaMYB7e7f5iWLmhEY4kvPmjBUMj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624230"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624230"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:29 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344417"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:29 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 058/104] KVM: x86/mmu: Focibly use TDP MMU for TDX
Date:   Fri,  4 Mar 2022 11:49:14 -0800
Message-Id: <047e05425ffed2b5de321dba6679cb4d1c388f4e.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

At this point, TDX supports TDP MMU and doesn't support legacy MMU.
Forcibly use TDP MMU for TDX irrelevant of kernel parameter to disable
TDP MMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b33ace3d4456..9df6aa4da202 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -16,7 +16,12 @@ module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 /* Initializes the TDP MMU for the VM, if enabled. */
 bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
-	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
+	/*
+	 *  Because TDX supports only TDP MMU, forcibly use TDP MMU in the case
+	 *  of TDX.
+	 */
+	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
+		(!tdp_enabled || !READ_ONCE(tdp_mmu_enabled)))
 		return false;
 
 	/* This should not be changed for the lifetime of the VM. */
-- 
2.25.1

