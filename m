Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7FD7886E3
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbjHYMQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244566AbjHYMPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:15:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2556DE6B;
        Fri, 25 Aug 2023 05:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965746; x=1724501746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yDAjKLQ83t75qGDtwIl/2F+N+cVZIFAf+7dSk9Dwsfg=;
  b=m+itVjq58IeXPNEw8uIajQIYtCC/5dFNaTQkXTvBOkt6/lsFLXzrpDbw
   xFGu/w4OqadqvK8oLBdXSGCIzaG6s2SSGz0E/5ct4o93lGudlhWsJu6dl
   ObKwvNehJXcWvD9PoQordUBPbutaHjwliywQywb6y56mzRbOzU8uIYQIJ
   OiXfa8o+GoIW+31oSwwePkFSe8uRehmv4JA7a09aaVaHQKM8sZ+fBztpQ
   XD95EMUJSRM6keu6DiGKX12ndqpWZgCBcckEFsii7tfp3yWcfD8L5sQIm
   UiY6EiNBS2JMNCwfT15ArnP+BztdKXFedTDKZhupwj+rBvjK9tV+K7oLm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639205"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639205"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158083"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:25 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 05/22] x86/virt/tdx: Handle SEAMCALL no entropy error in common code
Date:   Sat, 26 Aug 2023 00:14:24 +1200
Message-ID: <c945c9a8db98b7a304c404a7ef18aa2f7770ffaf.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
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

Some SEAMCALLs use the RDRAND hardware and can fail for the same reasons
as RDRAND.  Use the kernel RDRAND retry logic for them.

There are three __seamcall*() variants.  Add a macro to do the SEAMCALL
retry in the common code and define a wrapper for each __seamcall*()
variant.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v12 -> v13:
 - New implementation due to TDCALL assembly series.

---
 arch/x86/include/asm/tdx.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a252328734c7..cfae8b31a2e9 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -24,6 +24,11 @@
 #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
 #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
 
+/*
+ * TDX module SEAMCALL leaf function error codes
+ */
+#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -82,6 +87,28 @@ u64 __seamcall(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 
+#include <asm/archrandom.h>
+
+#define SEAMCALL_NO_ENTROPY_RETRY(__seamcall_func, __fn, __args)	\
+({									\
+	int ___retry = RDRAND_RETRY_LOOPS;				\
+	u64 ___sret;							\
+									\
+	do {								\
+		___sret = __seamcall_func((__fn), (__args));		\
+	} while (___sret == TDX_RND_NO_ENTROPY && --___retry);		\
+	___sret;							\
+})
+
+#define seamcall(__fn, __args)						\
+	SEAMCALL_NO_ENTROPY_RETRY(__seamcall, (__fn), (__args))
+
+#define seamcall_ret(__fn, __args)					\
+	SEAMCALL_NO_ENTROPY_RETRY(__seamcall_ret, (__fn), (__args))
+
+#define seamcall_saved_ret(__fn, __args)				\
+	SEAMCALL_NO_ENTROPY_RETRY(__seamcall_saved_ret, (__fn), (__args))
+
 bool platform_tdx_enabled(void);
 #else
 static inline bool platform_tdx_enabled(void) { return false; }
-- 
2.41.0

