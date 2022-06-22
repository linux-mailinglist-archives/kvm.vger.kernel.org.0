Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C45548C5
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357349AbiFVLTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357202AbiFVLTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:19:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE5E3BA79;
        Wed, 22 Jun 2022 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896685; x=1687432685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ntftiSqWbOB47rbOkwNsaejfB8DACjOwmAgRAleuan0=;
  b=eqr2QxU9910XUNTcB5dwMU9i+4GYvmx28hNpNglSTM8FvEM2TmEaeCrA
   MGrVkmI24lckxiHtcGyFuk7oEoXKH0Y2/Beon6dckMLoQoE6lLHEZGKNK
   wsDZjFHuhb/YHTOagfG5CrsjfF6lZm5gFcHk0y2ZMo4jB+XuonQNn9PMo
   KTmI9Q57YHIlV4Mn0mpKpa5hxqlb3lc1uvr1S8ZYNCCxVQUbKBi8yPlX7
   FGjTaacF4ctrrgBokWYTGRH9Vp1zxBLWI5edaFXLfNpNr6XHtTvOisRGD
   bLUSCQ+372Gcfz2BYpCpr0OV6AsbkhTImI/K5UBkRGJzprxGOXWUiMQ5N
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="366713436"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="366713436"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:18:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="834065936"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:18:01 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 21/22] x86/virt/tdx: Support kexec()
Date:   Wed, 22 Jun 2022 23:17:49 +1200
Message-Id: <9c0c25cbe70969e2aa3e68505cc7a7021a47a7ee.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
2.36.1

