Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30F9651B3C
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiLTHDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiLTHBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661B0164B3;
        Mon, 19 Dec 2022 23:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519703; x=1703055703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dG+PmrxecS8Zp0V+8AcHi6OKB+U1bLaxzvtp836DcuY=;
  b=JZkPLpFGoEmHdbTgHrNgwx1CUPms/OqPSC8Xihf6b/8ZGC1BwZ/L4dnV
   wQpyDnwJ1vSVnsNMmjJl7WpHWTi3ghhfmT51aTiMS0xyGPLCLa/IWeLss
   +o60EHLsellGZR4lO7eKfcxLHmQcloP2QEbfnqAquSFGMM6zl3nF14kAc
   p9YKn9PYJV/maB6O71WiLgNo+xMpFm9WXv1znVS4LPtoXPalK/y+hZrYu
   UF1TF47Zft1iFEb5eSmEtm1+vRYAT2qbcafpxMeP53/60doRizMbgbiNG
   iXvtlMP9Mx3wspWXWXq9hbYDO9Jfmr7zQDU5sWGPHJoAYmdInellKWEqT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972194"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972194"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326571"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326571"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:20 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 32/32] x86/fred: disable FRED by default in its early stage
Date:   Mon, 19 Dec 2022 22:36:58 -0800
Message-Id: <20221220063658.19271-33-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220063658.19271-1-xin3.li@intel.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable FRED by default in its early stage.

To enable FRED, a new kernel command line option "fred" needs to be added.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 arch/x86/kernel/cpu/common.c                    | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 42af9ca0127e..0bc76d926dd4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1506,6 +1506,10 @@
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
index 5de68356fe62..1a160337ad41 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1434,6 +1434,9 @@ static void __init cpu_parse_early_param(void)
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

