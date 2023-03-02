Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD66A7B14
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCBFw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCBFwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:52:22 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F64532AE;
        Wed,  1 Mar 2023 21:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736285; x=1709272285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCKu4lASdy4fofKGHW4gy5ePwfNi7YQxHJ13+kwlv3k=;
  b=ka5ay/5TeN2UCtOgI6Y2fZeGibJS4uC1tORRFgivbbhHh3rTbb9+VdQH
   LkceHnsNJhODN6WvYOVhAkzgUPZVnQZfF119eMr55J7dJokQS7jotg4nN
   8uebwA21T/7Q7T1bxfKjmbY3Bmk/Pbd6xblY5zzYikdqVtzCwLM1YO3nJ
   jz7qazwr3AxK8b83OIjNQUB13HW+HuvKZX1JPZ1gsJovv5LhNP7H+tP/Z
   auMVvLqm5ZYC2HZslxQM9K6qUw0s+UXnnbb8+GP+13bCOluSoDmgiSL07
   88neN2qZzArMxT0KmTN28w+9fPABmaL8ZFN5uBcChuWcoa4yANAuGVad6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887283"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887283"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530956"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530956"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:50 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 25/34] x86/fred: disallow the swapgs instruction when FRED is enabled
Date:   Wed,  1 Mar 2023 21:25:02 -0800
Message-Id: <20230302052511.1918-26-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

The FRED architecture establishes the full supervisor/user through:
1) FRED event delivery swaps the value of the GS base address and
   that of the IA32_KERNEL_GS_BASE MSR.
2) ERETU swaps the value of the GS base address and that of the
   IA32_KERNEL_GS_BASE MSR.
Thus, the swapgs instruction is disallowed when FRED is enabled,
otherwise it cauess #UD.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
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

