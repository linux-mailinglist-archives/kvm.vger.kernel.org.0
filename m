Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB236317C3
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKUAbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiKUAa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:30:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6822E1E3F2;
        Sun, 20 Nov 2022 16:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990537; x=1700526537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B4X5vcXsxt6uAK36/XCY9Qp+zNxFIBT0eQmTkgHAVxg=;
  b=SzzD6Q46Q4FD3NF7YWB6fd0YbJTjY0CHQ3HvPkv2bH8XNUftTY5gaSMV
   MagRbX4pNvR3qNLUDpmE6n/0w0hbfwXyX0F8lNDkMZXwOT8f7p3Y9XKvE
   OMOHNSSpvjtquVaHHE2x48bxkq/9ODmqHVicFR92manNvDpe72B5aUEbQ
   Lo76wGTUdHo9d5Hj6hmtwW+RxagQKI8ZMX8qg9Dvx+1J7N0z+0dRKT0lo
   Oo8RsH5mrmUGdSrcyp3ZoAxABdhb0iCdR5VWI7TfJQIRAuO5zezIiBV77
   c4N1AqrSSAgec4FIvIeTzvjCsuvzgwQLcpIMGziFtZClPx4awmfoSAMhD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705768"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705768"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825557"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825557"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:13 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 19/20] x86/virt/tdx: Flush cache in kexec() when TDX is enabled
Date:   Mon, 21 Nov 2022 13:26:41 +1300
Message-Id: <a8a097dfa03704b95f0169b8e84f385a8dd3dc30.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
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

There are two problems in terms of using kexec() to boot to a new kernel
when the old kernel has enabled TDX: 1) Part of the memory pages are
still TDX private pages (i.e. metadata used by the TDX module, and any
TDX guest memory if kexec() happens when there's any TDX guest alive).
2) There might be dirty cachelines associated with TDX private pages.

Because the hardware doesn't guarantee cache coherency among different
KeyIDs, the old kernel needs to flush cache (of those TDX private pages)
before booting to the new kernel.  Also, reading TDX private page using
any shared non-TDX KeyID with integrity-check enabled can trigger #MC.
Therefore ideally, the kernel should convert all TDX private pages back
to normal before booting to the new kernel.

However, this implementation doesn't convert TDX private pages back to
normal in kexec() because of below considerations:

1) The kernel doesn't have existing infrastructure to track which pages
   are TDX private pages.
2) The number of TDX private pages can be large, and converting all of
   them (cache flush + using MOVDIR64B to clear the page) in kexec() can
   be time consuming.
3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
   0 doesn't support integrity-check, so it's OK.
4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
   kernel ever supports MKTME, it should do MOVDIR64B to clear the page
   with the new MKTME KeyID (just like TDX does) before using it.

Therefore, this implementation just flushes cache to make sure there are
no stale dirty cachelines associated with any TDX private KeyIDs before
booting to the new kernel, otherwise they may silently corrupt the new
kernel.

Following SME support, use wbinvd() to flush cache in stop_this_cpu().
Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by BIOS instead to flush cache.

Also, the current TDX module doesn't play nicely with kexec().  The TDX
module can only be initialized once during its lifetime, and there is no
ABI to reset the module to give a new clean slate to the new kernel.
Therefore ideally, if the TDX module is ever initialized, it's better
to shut it down.  The new kernel won't be able to use TDX anyway (as it
needs to go through the TDX module initialization process which will
fail immediately at the first step).

However, shutting down the TDX module requires all CPUs being in VMX
operation, but there's no such guarantee as kexec() can happen at any
time (i.e. when KVM is not even loaded).  So just do nothing but leave
leave the TDX module open.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - Improved changelog to explain why don't convert TDX private pages back
   to normal.

---
 arch/x86/kernel/process.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c21b7347a26d..0cc84977dc62 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -765,8 +765,14 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * Similar to SME, if the TDX module is ever initialized, the
+	 * cachelines associated with any TDX private KeyID must be flushed
+	 * before transiting to the new kernel.  The TDX module is initialized
+	 * on demand, and it takes the mutex to read its status.  Just check
+	 * whether TDX is enabled by BIOS instead to flush cache.
 	 */
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if (cpuid_eax(0x8000001f) & BIT(0) || platform_tdx_enabled())
 		native_wbinvd();
 	for (;;) {
 		/*
-- 
2.38.1

