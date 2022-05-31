Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C0539732
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347397AbiEaTmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347570AbiEaTmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:42:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F62F387;
        Tue, 31 May 2022 12:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026102; x=1685562102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LRvpKY8V/pZZVmnXiTrrOQbWEaVzxMy5EVzrOvbbdO4=;
  b=ExnB/ATzUbnYvQ6x3lutDRESEmlSsFC/Amdx8bQQDpASREqybRdXlYRS
   TpfHm1ZyvW1gZdV3ADOnUydOByzId2AV1tnH4B8n97IhtPxNKifRP+yaH
   /TZDy0ebUCQlW1srFBHpOfTYzxp1Za/lNVAUBgdmfej0NVOWs+6CVDKIh
   3Je+77xOVdy6kyNe3mFuri/pbWLRukzY2l+Czcdkd3+DWFW9Hq9M+oqsa
   SiIu5M0hkrru4uwXkPajxlDu34qtmGTYarB3FMx2YQU0w3qitxUyAt5dD
   XnSb9fXKLi69JBiH9drDzuvrhkXNQW4MGF3ZbDTrwgExHBrIBqRsS6OMQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935305"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935305"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:41:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164796"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:41:02 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 21/22] x86/virt/tdx: Support kexec()
Date:   Wed,  1 Jun 2022 07:39:44 +1200
Message-Id: <0d0f416433033db578a125d1518f0dfcafe5d2d2.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support kexec(), if the TDX module is ever initialized, the kernel
needs to flush all dirty cachelines associated with any TDX private
KeyID, otherwise they may slightly corrupt the new kernel.

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

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/process.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index dbaf12c43fe1..ff5449c23522 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -769,8 +769,15 @@ void __noreturn stop_this_cpu(void *dummy)
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
2.35.3

