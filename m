Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA874CB7BD
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiCCH2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiCCH2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E967E5FE9
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292452; x=1677828452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGbVvnH0+tW0IVP4OvryXS4dM2QPA9H1YCBKoJmLM34=;
  b=fB5P5kReeOunY2KtJ7Wt4vwZnMB/nvokAUYqxCe5QFgj43XBgYUPCVKC
   jaLrhq1+LPv6rLfGc7e04N+olHkTy/7q8wwzsbnlqM4bCJ6GvEjf+zVR0
   LnVHhBSgow42wsbmode4wH4fNGjUqfjnjShz384pjuZcyrTKz0z7S6QRL
   xhftsolHaEOde4B8lX87CboZtA6f+ya2dzJD/DYdX1EaLYn0UVFp9fqPS
   KOqmad7fOgX61RBQWJ3UDasojjVDHuIAmRYOG1lKzLSJ1bRJvpFBcwrQz
   y9R4SuFKZyRKLdn9ttxk+22ObDGD18FGAniMwACfq0RNCvrYJIscSTyA5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="252427533"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="252427533"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631561"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:27 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 05/17] x86 TDX: bypass wrmsr simulation on some specific MSRs
Date:   Thu,  3 Mar 2022 15:18:55 +0800
Message-Id: <20220303071907.650203-6-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In TDX scenario, some MSRs are initialized with expected value
and not expected to be changed in TD-guest.

Writing to MSR_IA32_TSC, MSR_IA32_APICBASE, MSR_EFER in TD-guest
triggers #VE. In #VE handler these MSR access are simulated with
tdvmcall. But in current TDX host side implementation, they are
bypassed and return failure.

In order to let test cases touching those MSRs run smoothly, bypass
writing to those MSRs in #VE handler just like writing succeed.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/tdx.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 62e0e2842822..1fc8030c34fa 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -311,6 +311,18 @@ static bool tdx_get_ve_info(struct ve_info *ve)
 	return true;
 }
 
+static bool tdx_is_bypassed_msr(u32 index)
+{
+	switch (index) {
+	case MSR_IA32_TSC:
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
 		struct ve_info *ve)
 {
@@ -338,7 +350,8 @@ static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
 		}
 		break;
 	case EXIT_REASON_MSR_WRITE:
-		ret = tdx_write_msr(regs->rcx, regs->rax, regs->rdx);
+		if (!tdx_is_bypassed_msr(regs->rcx))
+			ret = tdx_write_msr(regs->rcx, regs->rax, regs->rdx);
 		break;
 	case EXIT_REASON_CPUID:
 		ret = tdx_handle_cpuid(regs);
-- 
2.25.1

