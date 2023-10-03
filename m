Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969617B616D
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbjJCGzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbjJCGyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84354DA;
        Mon,  2 Oct 2023 23:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316083; x=1727852083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aQdiRWsnt6AKxUkiRSvWlc5kg1W+wRYx8vYlgG3sGOg=;
  b=HAnkFzOLjW/W+y3rwOp9u/XEe/TbgKJey2/vNwyJBRBxkrG+ZnRlLMj5
   8DayFkXleC0xGUNGtbzF90IbxWtam5YpUG0518Q2mg3RGk6IjldAN9XVS
   vvYB/2l2EdLGFbigzuIlWqvis+VTLvEHknLAAHAc4kWmL+yqeTRi5eht6
   Ng2S826YlMvvNgsxNiIVEF93poHoXERtTfn87TOnEk9ZMumWLHkl3TRIY
   lZKVPrGzW8jHKeNEcS5DX93+dPLkAMuHDrlPbt6KFttH0FQDsg/byHduu
   x3+ETyAXZ+DDa18RAxS48kQZkLsXysjYd1hFYE/1kJakve2gBxS1yFKUN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858015"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858015"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900925"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900925"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:39 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v12 10/37] x86/fred: Disable FRED by default in its early stage
Date:   Mon,  2 Oct 2023 23:24:31 -0700
Message-Id: <20231003062458.23552-11-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To enable FRED, a new kernel command line option "fred" needs to be added.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 arch/x86/kernel/cpu/common.c                    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 45e34be4ed56..ee939ea00458 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1525,6 +1525,9 @@
 			Warning: use of this parameter will taint the kernel
 			and may cause unknown problems.
 
+	fred		[X86-64]
+			Enable flexible return and event delivery
+
 	ftrace=[tracer]
 			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7131074433f9..736d38abfc5a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1502,6 +1502,9 @@ static void __init cpu_parse_early_param(void)
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

