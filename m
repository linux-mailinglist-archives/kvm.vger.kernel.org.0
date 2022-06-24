Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DA8559618
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiFXJJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 05:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiFXJJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 05:09:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A06E4EF74
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 02:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656061761; x=1687597761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZKZs43CHcT22X/6Y5MnTtOwktTXOynRraWEPmaAvKg0=;
  b=KuDcNRgqIWsRuJWwrPlts1KTU1A3XMytUW1m/+rbkENAarEo9JBafg/J
   pxZPUC68PrsnSE2yvTcYmYm8S+y5LMktAK1y5pY/JEfpf1a2eCUxAkUI+
   zKec0K3m/2gIWLzPeWgNqRWWFHrmxVZSJhyqKlfwlHh0Ot7zSE6LR9CuE
   mdZKvEVu/zNlLAMw/s8g8cAvF2V6YPuMk7zptjey/EHZxHjFLRqn2Mhru
   MbVDaAQkzM3MQ4oQQb+sksfbKozMWsq1VjY3ogR0Lx2qbL0lRi8j1DiKF
   4N5ayT8wlp3+lTM8fGbvnVB+elr8Fx6wBKH9uopmkC79lKdc4DZl776TZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="278509307"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="278509307"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="539222082"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 1/3] x86: Don't overwrite bits 11 and 12 of MSR_IA32_MISC_ENABLE
Date:   Fri, 24 Jun 2022 05:08:26 -0400
Message-Id: <20220624090828.62191-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220624090828.62191-1-weijiang.yang@intel.com>
References: <20220624090828.62191-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Bits 11 and 12 of MSR_IA32_MISC_ENABLE represent the configuration
of the vPMU, and latest KVM does not allow the guest to modify them.
Adjust kvm-unit-tests to avoid failures.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/msr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b..8bf38ef 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -19,6 +19,7 @@ struct msr_info {
 	bool is_64bit_only;
 	const char *name;
 	unsigned long long value;
+	unsigned long long keep;
 };
 
 
@@ -27,6 +28,8 @@ struct msr_info {
 
 #define MSR_TEST(msr, val, only64)	\
 	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
+#define MSR_TEST_RO_BITS(msr, val, only64, ro)	\
+	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64, .keep = ro }
 
 struct msr_info msr_info[] =
 {
@@ -34,7 +37,8 @@ struct msr_info msr_info[] =
 	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
 	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
+	// read-only: 11, 12
+	MSR_TEST_RO_BITS(MSR_IA32_MISC_ENABLE, 0x400c50009, false, 0x1800),
 	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
 	MSR_TEST(MSR_FS_BASE, addr_64, true),
 	MSR_TEST(MSR_GS_BASE, addr_64, true),
@@ -59,6 +63,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 	 */
 	if (msr->index == MSR_EFER)
 		val |= orig;
+	else
+		val = (val & ~msr->keep) | (orig & msr->keep);
 	wrmsr(msr->index, val);
 	r = rdmsr(msr->index);
 	wrmsr(msr->index, orig);
-- 
2.27.0

