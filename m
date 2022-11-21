Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072066317A2
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKUA1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiKUA1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782212D1EE;
        Sun, 20 Nov 2022 16:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990430; x=1700526430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t7sPVkm/3UzeLP7VuUIOn/LR0Yeq7hatZzy8/VrnZkk=;
  b=hOxGimbe+IYDLQhr3uwKE5IFxlMBAttn9lWKxIlxaWliRhP2NxShVRvG
   gUUrmpMEsCy5fYVzeyrIh7ld9JrHQUCOAZDqfr1TtUviWAk73oWdj/JRd
   8mr/iWYeNYlTd25FBXC3Ea3E/ZLtcEISYZnCRB7NtLzAoQaHLQ8YgwyuC
   8ZjIQCaCj7CC9g08BBQZvjZfVV91p+JRmH8gOhRUEJUa+Anmt2+qG7O+4
   ga/rHeXKuQMWD9hLgNWB0vzoJSyzKJ2xaHO4hHGBJrUrBT9Bdwh74Q1vf
   vlCnert/OlAyogkM2hPDV1uEKrVrkz88mEgeeoC4G+FbGFyh/vTQJftmo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732287"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732287"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825206"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825206"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:04 -0800
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
Subject: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not enabled
Date:   Mon, 21 Nov 2022 13:26:25 +1300
Message-Id: <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
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

The MMIO/xAPIC interface has some problems, most notably the APIC LEAK
[1].  This bug allows an attacker to use the APIC MMIO interface to
extract data from the SGX enclave.

TDX is not immune from this either.  Early check X2APIC and disable TDX
if X2APIC is not enabled, and make INTEL_TDX_HOST depend on X86_X2APIC.

[1]: https://aepicleak.com/aepicleak.pdf

Link: https://lore.kernel.org/lkml/d6ffb489-7024-ff74-bd2f-d1e06573bb82@intel.com/
Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - Changed to use "Link" for the two lore links to get rid of checkpatch
   warning.

---
 arch/x86/Kconfig            |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cced4ef3bfb2..dd333b46fafb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1958,6 +1958,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on X86_X2APIC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 982d9c453b6b..8d943bdc8335 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -12,6 +12,7 @@
 #include <linux/printk.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/apic.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -81,6 +82,16 @@ static int __init tdx_init(void)
 		goto no_tdx;
 	}
 
+	/*
+	 * TDX requires X2APIC being enabled to prevent potential data
+	 * leak via APIC MMIO registers.  Just disable TDX if not using
+	 * X2APIC.
+	 */
+	if (!x2apic_enabled()) {
+		pr_info("Disable TDX as X2APIC is not enabled.\n");
+		goto no_tdx;
+	}
+
 	return 0;
 no_tdx:
 	clear_tdx();
-- 
2.38.1

