Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3A47CC084
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbjJQKSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343832AbjJQKRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98D410B;
        Tue, 17 Oct 2023 03:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537833; x=1729073833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8M6A/iAWwAdbCNObEOw+xUv3oHPvF8QdJDksd9FDpGU=;
  b=HXmiJjrO63ELc702bmvc8VqG2763zg4jIRXDuGhejZIjAm+q8Zv2UJ5V
   z1CWWDaEZ8Sa8UvwedRbt9PgEVGL4ORhoH6gH7RVKR5Sq4r7q+LKh9Q4/
   AO0E2LuyhAS637GR8oBblzonM7+k7RN9+q24ZYLyCRIkdu986BdZcH/RQ
   dBnhhUa7bJjkdj9BjQFm2CC8rXVkzAxzwWpMAFi4WHKSlaQHSUnDmw2jr
   t/yWEX4KUAzTykmEoGKOhXJwLyXQ4L++iboJMSC5aZHQ+EBrrlBycp5J4
   +B7na4JUqNIAflIHrSxwBWvxuQBRREHsnxnJUBJGvrtzT0o/QhTkERX78
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972644"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972644"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503999"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503999"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:17:06 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI S3 and deeper states
Date:   Tue, 17 Oct 2023 23:14:45 +1300
Message-ID: <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
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

TDX cannot survive from S3 and deeper states.  The hardware resets and
disables TDX completely when platform goes to S3 and deeper.  Both TDX
guests and the TDX module get destroyed permanently.

The kernel uses S3 to support suspend-to-ram, and S4 or deeper states to
support hibernation.  The kernel also maintains TDX states to track
whether it has been initialized and its metadata resource, etc.  After
resuming from S3 or hibernation, these TDX states won't be correct
anymore.

Theoretically, the kernel can do more complicated things like resetting
TDX internal states and TDX module metadata before going to S3 or
deeper, and re-initialize TDX module after resuming, etc, but there is
no way to save/restore TDX guests for now.

Until TDX supports full save and restore of TDX guests, there is no big
value to handle TDX module in suspend and hibernation alone.  To make
things simple, just choose to make TDX mutually exclusive with S3 and
hibernation.

Note the TDX module is initialized at runtime.  To avoid having to deal
with the fuss of determining TDX state at runtime, just choose TDX vs S3
and hibernation at kernel early boot.  It's a bad user experience if the
choice of TDX and S3/hibernation is done at runtime anyway, i.e., the
user can experience being able to do S3/hibernation but later becoming
unable to due to TDX being enabled.

Disable TDX in kernel early boot when hibernation is available, and give
a message telling the user to disable hibernation via kernel command
line in order to use TDX.  Currently there's no mechanism exposed by the
hibernation code to allow other kernel code to disable hibernation once
for all.

Disable ACPI S3 by setting acpi_suspend_lowlevel function pointer to
NULL when TDX is enabled by the BIOS.  This avoids having to modify the
ACPI code to disable ACPI S3 in other ways.

Also give a message telling the user to disable TDX in the BIOS in order
to use ACPI S3.  A new kernel command line can be added in the future if
there's a need to let user disable TDX host via kernel command line.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v13 -> v14:
 - New patch

---
 arch/x86/virt/vmx/tdx/tdx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e82f0adeea4d..1d0f1045dd33 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,10 +28,12 @@
 #include <linux/sort.h>
 #include <linux/log2.h>
 #include <linux/reboot.h>
+#include <linux/suspend.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
+#include <asm/acpi.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -1427,6 +1429,22 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+#define HIBERNATION_MSG		\
+	"Disable TDX due to hibernation is available. Use 'nohibernate' command line to disable hibernation."
+	/*
+	 * Note hibernation_available() can vary when it is called at
+	 * runtime as it checks secretmem_active() and cxl_mem_active()
+	 * which can both vary at runtime.  But here at early_init() they
+	 * both cannot return true, thus when hibernation_available()
+	 * returns false here, hibernation is disabled by either
+	 * 'nohibernate' or LOCKDOWN_HIBERNATION security lockdown,
+	 * which are both permanent.
+	 */
+	if (hibernation_available()) {
+		pr_err("initialization failed: %s\n", HIBERNATION_MSG);
+		return -ENODEV;
+	}
+
 	err = register_memory_notifier(&tdx_memory_nb);
 	if (err) {
 		pr_err("initialization failed: register_memory_notifier() failed (%d)\n",
@@ -1442,6 +1460,11 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_ACPI
+	pr_info("Disable ACPI S3 suspend. Turn off TDX in the BIOS to use ACPI S3.\n");
+	acpi_suspend_lowlevel = NULL;
+#endif
+
 	/*
 	 * Just use the first TDX KeyID as the 'global KeyID' and
 	 * leave the rest for TDX guests.
-- 
2.41.0

