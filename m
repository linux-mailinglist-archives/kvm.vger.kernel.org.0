Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2F647E22
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLIG5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiLIG4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:56:08 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70939AF4C7;
        Thu,  8 Dec 2022 22:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568871; x=1702104871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=47FUNXOBhS2NG9KMSmMIewrFFmTIx7+CnlvTMHcGc9w=;
  b=FOjc4LttxCa5ddL9CFKoKJkclr6jmi+UTDb/FzEyo1Og78qBO1NJqCBV
   kmkG6fpRZR2rj6J7SJsd+t3pWv3pQLeZvL/PBorjkZOU26a7UTrMvXFBy
   9DWcl1gkAQu2bVV5VqK/fvJ0UTSBOFpRCobdqD63Qd9UOAP9yR6keNc2/
   iEPLFtQRLrhYNbuzZdpzYeKpAQd/YHj5lxlLBjr0r0H3iXVjWSnaQIC6X
   l7gsKL0L4JYOJQVK4/EOBOt46Ba/gfiIz/CWOXwVww/Z1Qn/6GYPjuRSz
   jeFlzBmwlZXmWdj5Ag3lIPZwokYR9UN/HVKWqntKRXZ/J5ZOAl6vKK2Vv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551540"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551540"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837169"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837169"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:14 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is enabled
Date:   Fri,  9 Dec 2022 19:52:36 +1300
Message-Id: <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

1) Neither the kernel nor the TDX module has existing infrastructure to
   track which pages are TDX private pages.
2) The number of TDX private pages can be large, and converting all of
   them (cache flush + using MOVDIR64B to clear the page) in kexec() can
   be time consuming.
3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
   0 doesn't support integrity-check, so it's OK.
4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
   kernel ever supports MKTME, it can/should do MOVDIR64B to clear the
   page with the new MKTME KeyID (just like TDX does) before using it.

Therefore, this implementation just flushes cache to make sure there are
no stale dirty cachelines associated with any TDX private KeyIDs before
booting to the new kernel, otherwise they may silently corrupt the new
kernel.

Following SME support, use wbinvd() to flush cache in stop_this_cpu().
Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by BIOS instead to flush cache.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8:
 - Changelog:
   - Removed "leave TDX module open" part due to shut down patch has been
     removed.

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

