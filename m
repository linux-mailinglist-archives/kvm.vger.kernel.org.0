Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD902544657
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbiFIIoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241923AbiFIIlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:41:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CBC11458
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654763999; x=1686299999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jKHgq0kkMCLkfupw9AvxnnB3qkvxmFYmvXXo2UL+jXc=;
  b=bvRWRzv6PtxcL/byDRAKlvrXCY8wvXBOb5kTnad39i80sxXno/WFyHQm
   2/SfHHrxHZp8j+kmf13v3hEZMy7FCPXCcNq6qAEjXvic9buofyKzpXXRl
   QFszfsi32JChxoZg8olayzqTqOhUGnbL3FUEK/rC0unnxa/ufnTAcSnu5
   ol8NBJnxntSQR6hAfQrGc0kgRmhqJqKFpwuBtKyKZBKcgrp+GopBKQSZ+
   cDZZTlrRCrlh2USZgqPrz5KBLIa0ae2J3/3ekXT8X4ul2c/ZUalIuJ8az
   D33JwQV4L3xp1jYdI2JLJI1KYQVUSrpFtBUgp12OA5Srvr+LtM60yCEIA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="278355517"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278355517"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="580475514"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:56 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Remove perf enable bit from default config
Date:   Thu,  9 Jun 2022 04:39:14 -0400
Message-Id: <20220609083916.36658-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220609083916.36658-1-weijiang.yang@intel.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When pmu is disabled in KVM by enable_pmu=0, bit 7 of guest
MSR_IA32_MISC_ENABLE is cleared, but the default value of
the MSR assumes pmu is always available, this leads to test
failure. Change the logic to make it aligned with KVM config.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/msr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b..fc05d6c 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -34,7 +34,7 @@ struct msr_info msr_info[] =
 	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
 	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
+	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51809, false),
 	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
 	MSR_TEST(MSR_FS_BASE, addr_64, true),
 	MSR_TEST(MSR_GS_BASE, addr_64, true),
@@ -59,6 +59,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 	 */
 	if (msr->index == MSR_EFER)
 		val |= orig;
+	if (msr->index == MSR_IA32_MISC_ENABLE)
+		val |= MSR_IA32_MISC_ENABLE_EMON & orig;
 	wrmsr(msr->index, val);
 	r = rdmsr(msr->index);
 	wrmsr(msr->index, orig);
-- 
2.31.1

