Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C29954C3EA
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346561AbiFOIrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 04:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiFOIrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 04:47:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656624BB83
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 01:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282838; x=1686818838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jKHgq0kkMCLkfupw9AvxnnB3qkvxmFYmvXXo2UL+jXc=;
  b=IKvCestjOdVtd8F7Jm094IDuaBKb4eU/CurPWw0fE0G0SSWJls5UKjJP
   eY1oiOlkJWZbumrCBoa9R9IRjPJcJeYlOJX2krEdrX56Ajf9UgPcwUA+D
   bBLeabpEVD8pFyJ+cYOhr+U9aDgTQNWdvH1oCiDhtK3yCfNtAwhRVtExa
   6LOJdP45xKFRnB0ZPckzg3idr46stj4him8pb/Dy7wPEWcj4mR9aXAIVA
   r76F7de2xbWpsZp/RYfL27F2yZ69vCeeSGDcnC669+QS7prtS877Zkd01
   nvo0at/XJAZqQnU7/95b7T5OnqVF1omX3RcL5mqXIWF5tOBUNCz9hR2kK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="342848609"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="342848609"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="558944459"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     like.xu.linux@gmail.com, jmattson@google.com, kvm@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 1/3] x86: Remove perf enable bit from default config
Date:   Wed, 15 Jun 2022 04:46:39 -0400
Message-Id: <20220615084641.6977-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220615084641.6977-1-weijiang.yang@intel.com>
References: <20220615084641.6977-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

