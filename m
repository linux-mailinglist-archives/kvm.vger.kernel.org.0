Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D396A7B1E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCBFxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjCBFwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:52:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7BA5678B;
        Wed,  1 Mar 2023 21:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736302; x=1709272302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nd37h2vxkhLXg5jhh870M6BiFI8TxVn0dDXlR1ukIGo=;
  b=nswFl751pmmLDFyP37e7gHeibQgkZqHHeplFyVdpc8IzvD5JgDaDPUEf
   Pk5JBq47p8Z+OPAdgLQ+vwuJ2Y61jmBwDlqQt5Pz2t4ft+9Sv5A+hRPZe
   l6vNsNq/mqb0EGS/xU9T3Tip9a6BiejlNwIx6DqlP+zfOGa8hGH4n9MGo
   ldkv4Qgaqs56/O04gRJjR0rUX8ykBzRz1qsXEU62UujgqyA/XdxH5IlZ9
   eq5sdiec2qscph1OZ0h8+e0SZq7yIkzvaSU2JVdpRAQniNsGiqD1BoOi6
   0Z4vvYtfG91rRYzrUEmXJSgRMLTo9b6ZHLmTHCRYCSZQkiSe+GUAvZuhA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887327"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887327"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530980"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530980"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:52 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 32/34] x86/fred: disable FRED by default in its early stage
Date:   Wed,  1 Mar 2023 21:25:09 -0800
Message-Id: <20230302052511.1918-33-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230302052511.1918-1-xin3.li@intel.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
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

Disable FRED by default in its early stage.

To enable FRED, a new kernel command line option "fred" needs to be added.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 arch/x86/kernel/cpu/common.c                    | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6221a1d057dd..c55ea60e1a0c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1498,6 +1498,10 @@
 			Warning: use of this parameter will taint the kernel
 			and may cause unknown problems.
 
+	fred
+			Forcefully enable flexible return and event delivery,
+			which is otherwise disabled by default.
+
 	ftrace=[tracer]
 			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index eea41cb8722e..4db5e619fc97 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1467,6 +1467,9 @@ static void __init cpu_parse_early_param(void)
 	char *argptr = arg, *opt;
 	int arglen, taint = 0;
 
+	if (!cmdline_find_option_bool(boot_command_line, "fred"))
+		setup_clear_cpu_cap(X86_FEATURE_FRED);
+
 #ifdef CONFIG_X86_32
 	if (cmdline_find_option_bool(boot_command_line, "no387"))
 #ifdef CONFIG_MATH_EMULATION
-- 
2.34.1

