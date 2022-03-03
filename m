Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00624CB7C5
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiCCH2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiCCH2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0973E2BFE
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292479; x=1677828479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GCl+3c8iMNpw3O28KZ9PCQxhOcMnqr996axLG6UAAro=;
  b=GOH7QwsZZ4MuUlb0kN/BeS3HN/2bUHWXz/HbTI010ioqYF33NzkLamhE
   O251L6Eia6I6FqJdEnQGuj6TulvHEmRWmaxEqfZDsbweZJiZxHeQ/KZAS
   c9CFRgcb/g403Qkx6WvBaQJMuFFMCJ0fQq0iXun+AZ1yxpesfzT1O4rmP
   HbWKgl98MeGib0SFQ++2URxUPTjo+0gFSL/u0UwIglAR5xBBYIoLIC+03
   wJpBECqa/TFLwkYgLN1SYsAmbCIyu2RamYN9Chua3EnoQAOiG94HcEpeu
   DWrklSeCC1VHTRo7zCY+rXLFAcdMVqgD4bPgG/ClmkM7p6fppDbujPfKE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177038"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177038"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:58 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631832"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:56 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 15/17] x86 TDX: bypass unsupported sub-test for TDX
Date:   Thu,  3 Mar 2022 15:19:05 +0800
Message-Id: <20220303071907.650203-16-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to TDX Module V0.931 Table 18.2: MSR Virtualization:

 1. MSR_IA32_MISC_ENABLE is reading native and #VE in writing.
 2. MSR_CSTAR is #VE in reading/writing.

MSR_CSTAR simulation is also not supported in TDX host side.

That means changing those MSRs are unsupported. So bypass related
sub-test.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 x86/msr.c     | 6 ++++++
 x86/syscall.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b233e9..3a538c9ba693 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -4,6 +4,7 @@
 #include "processor.h"
 #include "msr.h"
 #include <stdlib.h>
+#include "tdx.h"
 
 /**
  * This test allows two modes:
@@ -89,6 +90,11 @@ static void test_rdmsr_fault(struct msr_info *msr)
 
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
 {
+	/* Changing MSR_IA32_MISC_ENABLE and MSR_CSTAR is unsupported in TDX */
+	if ((msr->index == MSR_IA32_MISC_ENABLE || msr->index == MSR_CSTAR) &&
+	    is_tdx_guest())
+		return;
+
 	if (is_64bit_host || !msr->is_64bit_only) {
 		test_msr_rw(msr, msr->value);
 
diff --git a/x86/syscall.c b/x86/syscall.c
index b0df07200f50..270dfdfcce19 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -5,6 +5,7 @@
 #include "msr.h"
 #include "desc.h"
 #include "fwcfg.h"
+#include "tdx.h"
 
 static void test_syscall_lazy_load(void)
 {
@@ -106,7 +107,7 @@ int main(int ac, char **av)
 {
     test_syscall_lazy_load();
 
-    if (!no_test_device || !is_intel())
+    if ((!no_test_device || !is_intel()) && !is_tdx_guest())
         test_syscall_tf();
     else
         report_skip("syscall TF handling");
-- 
2.25.1

