Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC5055481F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357175AbiFVLQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357168AbiFVLQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:16:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572653C49F;
        Wed, 22 Jun 2022 04:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896580; x=1687432580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DffF+09fSeGG1bAiwSOs2ml2pvVNDElZJnScEzjWCIg=;
  b=Eah4tEqnLa3/Q9690ZSeut0LQj2IUrw9VPvLCycXWYGoJ6+UA9h2oKVu
   N+1gRFY1n1OHHHNTf0DzJe4WISElqk7vBsSxtYsomcuTmu1han8C8csQi
   hcWBkdpkH4JdPsMsYMaG2zFICNALZTimH04ydrZrTn7AhtozKjOjBzvX2
   ovFs13qHInDokpLx3+ID8P9N0qNWtSeUZGPbOgkVdJMyCyVDzIKb1aSx7
   p/5DaOFsjeHmp/osTF34+Kx2KGU75nB0FVzJA1v9xKStP5Weo+1W6IlBh
   D/0cdh4K/mKsUsw3uwGMq9TkBc0fpjH5eJf62gWahHWrFAvCuhJfIg1ju
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="279157309"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="279157309"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677489181"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:15 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, kai.huang@intel.com
Subject: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI memory hotplug
Date:   Wed, 22 Jun 2022 23:16:07 +1200
Message-Id: <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
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

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  To guarantee the security, TDX
imposes additional requirements on both CPU and memory.

TDX doesn't work with ACPI CPU hotplug.  During platform boot, MCHECK
verifies all logical CPUs on all packages are TDX compatible.  Any
hot-added CPU at runtime is not verified thus cannot support TDX.  And
TDX requires all boot-time verified CPUs being present during machine's
runtime, so TDX doesn't support ACPI CPU hot-removal either.

TDX doesn't work with ACPI memory hotplug either.  TDX also provides
increased levels of memory confidentiality and integrity.  During
platform boot, MCHECK also verifies all TDX-capable memory regions are
physically present and meet TDX's security requirements.  Any hot-added
memory is not verified thus cannot work with TDX.  TDX also assumes all
TDX-capable memory regions are present during machine's runtime thus it
doesn't support ACPI memory removal either.

Select ARCH_HAS_CC_PLATFORM when CONFIG_INTEL_TDX_HOST is on.  Set CC
vendor to CC_VENDOR_INTEL if TDX is enabled by BIOS, and report ACPI CPU
hotplug and ACPI memory hotplug attributes as disabled to prevent them.

Note TDX does allow CPU to go offline and then to be brought up again, so
software CPU hotplug attribute is not reported.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig            |  1 +
 arch/x86/coco/core.c        | 32 +++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c |  4 ++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 23f21aa3a5c4..efa830853e98 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	select ARCH_HAS_CC_PLATFORM
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 1bde1af75296..e4c9e34c452f 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -12,11 +12,14 @@
 
 #include <asm/coco.h>
 #include <asm/processor.h>
+#include <asm/cpufeature.h>
+#include <asm/tdx.h>
 
 static enum cc_vendor vendor __ro_after_init;
 static u64 cc_mask __ro_after_init;
 
-static bool intel_cc_platform_has(enum cc_attr attr)
+#ifdef CONFIG_INTEL_TDX_GUEST
+static bool intel_tdx_guest_has(enum cc_attr attr)
 {
 	switch (attr) {
 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
@@ -28,6 +31,33 @@ static bool intel_cc_platform_has(enum cc_attr attr)
 		return false;
 	}
 }
+#endif
+
+#ifdef CONFIG_INTEL_TDX_HOST
+static bool intel_tdx_host_has(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
+	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
+		return true;
+	default:
+		return false;
+	}
+}
+#endif
+
+static bool intel_cc_platform_has(enum cc_attr attr)
+{
+#ifdef CONFIG_INTEL_TDX_GUEST
+	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
+		return intel_tdx_guest_has(attr);
+#endif
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (platform_tdx_enabled())
+		return intel_tdx_host_has(attr);
+#endif
+	return false;
+}
 
 /*
  * SME and SEV are very similar but they are not the same, so there are
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8275007702e6..eb3294bf1b0a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,7 @@
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
+#include <asm/coco.h>
 #include "tdx.h"
 
 static u32 tdx_keyid_start __ro_after_init;
@@ -92,6 +93,9 @@ static int __init tdx_early_detect(void)
 	if (ret)
 		return ret;
 
+	/* Set TDX enabled platform as confidential computing platform */
+	cc_set_vendor(CC_VENDOR_INTEL);
+
 	pr_info("TDX enabled by BIOS.\n");
 	return 0;
 }
-- 
2.36.1

