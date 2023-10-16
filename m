Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA37CAED6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjJPQRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjJPQRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:17:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BC8D5A;
        Mon, 16 Oct 2023 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473022; x=1729009022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8T6zLvlaAzAFwyaBg/0GChxfVbg0Fq6wwYkBsoq3oNs=;
  b=GRk8xEnOD4ru75vCy2o4PoRnfi4pty9s76wxZRUhRPDIhfjKjhJib//N
   lc0rzgkeDZq91aH+Jh2Njy0dLVc2zS8269r/DHN9XW6QJeB16uR6ZhriH
   KBQ4HHEJQlLjoDXd7nZV/Fan4CM6coFdbp+aG4/tWINsyICYPWCtTSYcw
   bpUxxU3UGny+h0oDNuxMepwiIkssmG5B+f7lnUFg84Ruh6u4MhAX6iQ03
   V73SDS1pFKz+h/FMdoNStbYkzTWQv2ciJmKJMApcg3yxemW15q2uTyqAG
   HDPHHsV2bqwrVbqC/SB2wmlA0VjpD/09STb6WGF1DMOR9LszKBZ0GJBEs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921814"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921814"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448144"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448144"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:46 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 054/116] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date:   Mon, 16 Oct 2023 09:14:06 -0700
Message-Id: <e94aec518e1dbb53cd9a6f871edfa7fc0634e172.1697471314.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.  TDX requires KVM mmio caching.  Disable
TDX support when TDP MMU or mmio caching aren't supported.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c  |  1 +
 arch/x86/kvm/vmx/main.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1f42fdcd248..91250b2a7081 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -104,6 +104,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * If the hardware supports that we don't need to do shadow paging.
  */
 bool tdp_enabled = false;
+EXPORT_SYMBOL_GPL(tdp_enabled);
 
 static bool __ro_after_init tdp_mmu_allowed;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 17d119f3c4a8..fda13fd37cae 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -58,6 +58,17 @@ static __init int vt_hardware_setup(void)
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
 				      cpu_has_vmx_ept_execute_only());
+	/* TDX requires KVM TDP MMU. */
+	if (enable_tdx && !tdp_enabled) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");
+	}
+
+	/* TDX requires MMIO caching. */
+	if (enable_tdx && !enable_mmio_caching) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
+	}
 
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
-- 
2.25.1

