Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D579F79FBE7
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbjING2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjING2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103BF9;
        Wed, 13 Sep 2023 23:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672922; x=1726208922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0H4/DsmRdq6ZAqAGPRiCyRQ3eI7Btuj1gad9cmvRYIo=;
  b=Erj7Y+SGRTMfMtKFj4T5JjoATZ8yWnkb50Dqtua6w0ULPbXekPebMXT5
   lIa9msZG797l2eubx0d/SzRQ7bt6RCCJ6pmxZo3i8npMTcGbzD+fwoBs4
   sBCzheKjV10UGqH9FlX07wQ7hLNCG8qAHqPfWfMZNtrlOCwLiVw1RcCI8
   13M3QatZBpcm5Tk9KougOrZylOsAMFwmmzu0ItoMwCdKWRCVab9RjOb8x
   nQ9HlOO9NQJMh754lShr9erzOA3l7ovD5JDERynaYWkarl5op6/jEm74c
   jJbOjSDvkw4CCcYsnQGPCoAjfqFfYTZhdqHf8Y7+H2Zg29e39rk1YniQy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672437"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672437"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937978"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937978"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 1/8] x86/fpu/xstate: Manually check and add XFEATURE_CET_USER xstate bit
Date:   Wed, 13 Sep 2023 23:23:27 -0400
Message-Id: <20230914032334.75212-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
reflect true dependency between CET features and the xstate bit, instead
manually check and add the bit back if either SHSTK or IBT is supported.

Both user mode shadow stack and indirect branch tracking features depend
on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.

Although in real world a platform with IBT but no SHSTK is rare, but in
virtualization world it's common, guest SHSTK and IBT can be controlled
independently via userspace app.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index cadf68737e6b..12c8cb278346 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
-	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
 	}
 
+	/*
+	 * Manually add CET user mode xstate bit if either SHSTK or IBT is
+	 * available. Both features depend on the xstate bit to save/restore
+	 * CET user mode state.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
+		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
+
 	if (!cpu_feature_enabled(X86_FEATURE_XFD))
 		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
-- 
2.27.0

