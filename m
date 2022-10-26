Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BCF60EC18
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiJZXRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiJZXRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D094AA37B;
        Wed, 26 Oct 2022 16:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826233; x=1698362233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gCs+bklvRvx+/oJnSDDhQ3+lEN01mwryoaDcV9wKDLo=;
  b=ncAlVYmFBro1W8NSD366TI/M/1WxMDdzXb4PhWnFbx6TX/W1FluwNI9E
   v7RF3bzZ26z9cD8PaQi4W97RHfojQZED+QMeHrqZYUxD1dGfI5ripnzxC
   gj2jHkEZUizjizYqlhN4V295LSsDODEFfv4+7YPkcUzFs2qRsLYs0y2/y
   DOyLPa9cPVHT3zqq5F9cQuGuri6mVjdTAROGryW3KlTZC4ckwzzJP8+7t
   kticLOeASaUqVQ6nMNYkKu0MpCQ6r9pFn/UGDaBQnI3WIcWEzgmAbycHY
   1AH9Vi4hYdHFg5SKkoE59l7LUItXbjwcp6wyFqT7rragu+7LfYaVdPfvt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306814212"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306814212"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:13 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446235"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446235"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:09 -0700
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
Subject: [PATCH v6 03/21] x86/virt/tdx: Disable TDX if X2APIC is not enabled
Date:   Thu, 27 Oct 2022 12:16:02 +1300
Message-Id: <1e2e7a498a5459d5427d18819010901dc46ea748.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

More info:

https://lore.kernel.org/lkml/d6ffb489-7024-ff74-bd2f-d1e06573bb82@intel.com/
https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/

[1]: https://aepicleak.com/aepicleak.pdf

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig            |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b9bd5d994ba7..f6f5e4f7a760 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1960,6 +1960,7 @@ config INTEL_TDX_HOST
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
2.37.3

