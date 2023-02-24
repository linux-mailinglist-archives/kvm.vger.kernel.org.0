Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0926A174A
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBXH3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBXH3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:29:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243CA93C9;
        Thu, 23 Feb 2023 23:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223697; x=1708759697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IYVs/dNGzaWmYDt7WgVNUnSvBB8Ri3wL5GZJW6QmAc8=;
  b=dF19NyBlwnjYt1fISsvRlKjJE2K/srB3R6aGGkXaFTq0CkkQHzBimVc8
   LErz/Vwsld5FxdVlm+B7negN6kvOVOqliErTqzMWa1o6ZLYtELMTdG4wy
   jyuy+2IGuTq9U5d1jr5SAhcKd/sUOIB99McZzJeF2DnblyVjzYHOb0k3l
   6v0YzigsCBFHRhl6F1fBhT4JvdTjoCgzUjNPW0KLqePzlj6nkyfuYk1vp
   m5QsXHESJCN6ctfxU1o3PiCoyGtMJ5PuR+w0LBS3OteWIYTJMaeDOxJpT
   FiPP+DccddIFUm9YK+yf8FcMKhAIoMkuXZGPUq0dX6eHLpzNZKbZsz957
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836126"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836126"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639268"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639268"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:25 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 25/32] x86/fred: disallow the swapgs instruction when FRED is enabled
Date:   Thu, 23 Feb 2023 23:01:38 -0800
Message-Id: <20230224070145.3572-26-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

The FRED architecture establishes the full supervisor/user through:
1) FRED event delivery swaps the value of the GS base address and
   that of the IA32_KERNEL_GS_BASE MSR.
2) ERETU swaps the value of the GS base address and that of the
   IA32_KERNEL_GS_BASE MSR.
Thus, the swapgs instruction is disallowed when FRED is enabled,
otherwise it cauess #UD.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/process_64.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 57de166dc61c..ff6594dbea4a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -165,7 +165,8 @@ static noinstr unsigned long __rdgsbase_inactive(void)
 
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !cpu_feature_enabled(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		gsbase = rdgsbase();
 		native_swapgs();
@@ -190,7 +191,8 @@ static noinstr void __wrgsbase_inactive(unsigned long gsbase)
 {
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !cpu_feature_enabled(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		wrgsbase(gsbase);
 		native_swapgs();
-- 
2.34.1

