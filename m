Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66D60EC42
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiJZXUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiJZXTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:19:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E18D18E6;
        Wed, 26 Oct 2022 16:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826303; x=1698362303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MPNELNYfmCBpeNJA9LZsp7KToRLiYMVpcYL0jENfSoA=;
  b=KuHL3St2bl1Lc32RkVWcSo8TGgIdulowaVzp6TKylXSIkiOQ3cRlaDW/
   jb8tGlxzd4hhrC0P+BnIjaVsuWbnFuu42bM7OrFDY/eevs/07ZuuqEZ26
   BNBd055pf0xUjaKHVk8yqulfdc6Bwih8NBXjlYqw7M3Q3LpBLnlXJsfch
   OKHxgBXSfebU8oc0ssfUff9k/gW5MyFvnNiKPVG3Cese1kTdr5HrkdONQ
   nsmrLGjJcXADEBhJAN8H/BQmjGBmXV2OQrSYFFuZt9sewNuUTyiBV22eA
   W4au8S4E65/T3+XNsDqOEwG2LXH74oAVW/agrtoZK2LOOYD+cOzY2BagY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175664"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175664"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:23 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446567"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446567"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:19 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 20/21] x86/virt/tdx: Flush cache in kexec() when TDX is enabled
Date:   Thu, 27 Oct 2022 12:16:19 +1300
Message-Id: <fd759cce9818d0627c97210bf492fa892eb244b4.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support kexec(), if the TDX module is initialized, the kernel needs
to flush all dirty cachelines associated with any TDX private KeyID,
otherwise they may silently corrupt the new kernel.

Following SME support, use wbinvd() to flush cache in stop_this_cpu().
Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by BIOS instead to flush cache.

The current TDX module architecture doesn't play nicely with kexec().
The TDX module can only be initialized once during its lifetime, and
there is no SEAMCALL to reset the module to give a new clean slate to
the new kernel.  Therefore, ideally, if the module is ever initialized,
it's better to shut down the module.  The new kernel won't be able to
use TDX anyway (as it needs to go through the TDX module initialization
process which will fail immediately at the first step).

However, there's no guarantee CPU is in VMX operation during kexec().
This means it's impractical to shut down the module.  Just do nothing
but leave the module open.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/process.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c21b7347a26d..a8f482c6e600 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -765,8 +765,15 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * Similar to SME, if the TDX module is ever initialized, the
+	 * cachelines associated with any TDX private KeyID must be
+	 * flushed before transiting to the new kernel.  The TDX module
+	 * is initialized on demand, and it takes the mutex to read it's
+	 * status.  Just check whether TDX is enabled by BIOS instead to
+	 * flush cache.
 	 */
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if (cpuid_eax(0x8000001f) & BIT(0) || platform_tdx_enabled())
 		native_wbinvd();
 	for (;;) {
 		/*
-- 
2.37.3

