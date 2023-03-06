Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB86AC2E5
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCFOSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCFORp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:17:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F632C66C;
        Mon,  6 Mar 2023 06:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112219; x=1709648219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dSuzXAdQmayBHAPr3LIj7u4EPJ2EUXayNvd7wuACrRk=;
  b=NLJRQRhLIXuhZvWKNoNiR/PJ03ZU9l9+R+v3PbuZt5I/P8DdfBH91+mj
   BqGSiam4Ugp7AjlEDozuhk0OQbWfXlo8hI5Ll8RLzCGPRGx11WtLG3GX/
   IpwPnjnqmRwM/MLy24n2vb+ga+nJ3MrWJ/KMWd1TOjBrMQNG+pAeP0/tj
   Z52tCysyA7TZTeOx1bxoqak1ugI+ULfZWovFVTXQytSEdEM0PelKef8jd
   1tOFxBJRnWmSpntL+V8yBg1mQlN+43kDJPL7UYcpMPeQJrPfLo4Li4iGO
   ImcQT4KRQaD5h0i7hVDfdWaL4fLWGTrKT4aCvCtkjeMPfVXO8GCO2Bpp+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080038"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080038"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232059"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232059"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:39 -0800
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
Subject: [PATCH v10 03/16] x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
Date:   Tue,  7 Mar 2023 03:13:48 +1300
Message-Id: <d1e1295070bf6b34180978748e2d4be337c24e57.1678111292.git.kai.huang@intel.com>
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

TDX capable platforms are locked to X2APIC mode and cannot fall back to
the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.

Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
---

v9 -> v10:
 - No change.

v8 -> v9:
 - Added Dave's Reviewed-by.

v7 -> v8: (Dave)
 - Only make INTEL_TDX_HOST depend on X86_X2APIC but removed other code
 - Rewrote the changelog.

v6 -> v7:
 - Changed to use "Link" for the two lore links to get rid of checkpatch
   warning.

---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fc010973a6ff..6dd5d5586099 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1957,6 +1957,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on X86_X2APIC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
-- 
2.39.2

