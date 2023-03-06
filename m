Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217E06AC315
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCFOVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCFOVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:21:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB731E3D;
        Mon,  6 Mar 2023 06:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112397; x=1709648397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GQvfu8vV/36Z9osC0CkzO5uRKQGb//01eRTjqXMgXtA=;
  b=OOk5QguOB/JZR1VG4gwKulAar/vbH94OVT4I4n+u3oQhEMsw9xYxMekx
   h1TL9o2oqQflWBP7eZrr8v/K6dhXfllutixvcAT+dC7pzZP2shHPakXWF
   sChJlW9UoYExjzTdSjlL8hNVH1FQ1VCcJNl23CEe9UmV1rbrKPzh1TNlA
   bZdpIS6yMsFUsJ+u5wDG4JBRWHBb03RfEW2C+L7rcinH5knVKBvEr6FUo
   xiCO21vDYPNNzUafUpgyhOE0IDr6gThttBgCT3WCZlUAksLijzC+K1W9w
   37zxfrGl56Epn/IWZ4/UWumPDm8NYPLwXom0+DHXK0PIkl2mFu7B9MNz2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080333"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080333"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232550"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232550"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:38 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v10 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is enabled
Date:   Tue,  7 Mar 2023 03:14:00 +1300
Message-Id: <95a37c2f09cbca9d91a858067d309279c714626a.1678111292.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
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
still TDX private pages; 2) There might be dirty cachelines associated
with TDX private pages.

The first problem doesn't matter.  KeyID 0 doesn't have integrity check.
Even the new kernel wants to use any non-zero KeyID, it needs to convert
the memory to that KeyID and such conversion would work from any KeyID.

However the old kernel needs to guarantee there's no dirty cacheline
left behind before booting to the new kernel to avoid silent corruption
from later cacheline writeback (Intel hardware doesn't guarantee cache
coherency across different KeyIDs).

There are two things that the old kernel needs to do to achieve that:

1) Stop accessing TDX private memory mappings:
   a. Stop making TDX module SEAMCALLs (TDX global KeyID);
   b. Stop TDX guests from running (per-guest TDX KeyID).
2) Flush any cachelines from previous TDX private KeyID writes.

For 2), use wbinvd() to flush cache in stop_this_cpu(), following SME
support.  And in this way 1) happens for free as there's no TDX activity
between wbinvd() and the native_halt().

Theoretically, cache flush is only needed when the TDX module has been
initialized.  However initializing the TDX module is done on demand at
runtime, and it takes a mutex to read the module status.  Just check
whether TDX is enabled by the BIOS instead to flush cache.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v9 -> v10:
 - No change.

v8 -> v9:
 - Various changelog enhancement and fix (Dave).
 - Improved comment (Dave).

v7 -> v8:
 - Changelog:
   - Removed "leave TDX module open" part due to shut down patch has been
     removed.

v6 -> v7:
 - Improved changelog to explain why don't convert TDX private pages back
   to normal.

---
 arch/x86/kernel/process.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 40d156a31676..5876dda412c7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -765,8 +765,13 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
+	 *
+	 * The TDX module or guests might have left dirty cachelines
+	 * behind.  Flush them to avoid corruption from later writeback.
+	 * Note that this flushes on all systems where TDX is possible,
+	 * but does not actually check that TDX was in use.
 	 */
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if (cpuid_eax(0x8000001f) & BIT(0) || platform_tdx_enabled())
 		native_wbinvd();
 	for (;;) {
 		/*
-- 
2.39.2

