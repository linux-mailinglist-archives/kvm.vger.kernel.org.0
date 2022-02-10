Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306044B096D
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiBJJZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:25:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiBJJZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:25:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB781089
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644485117; x=1676021117;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HnuANNfNcEZqDQj8+4XOgEpgRlsPsP9HBWkE3rnhch0=;
  b=RVk4rvBklGeUyCDvP5d4gMe5WcNjBXpbyK1/kfaQBtB4bKYEYN+apw2s
   3JN5Ul62SFxHStvbvre9kVG1BwPbw/JWV4JATtL9jXZEVpGrWKm9Xpfri
   27lhF/tT8BHQeYk0gQbzfCRdc+2D24pV65mlw696LvQYSjlpgGixzxoWx
   hB+HT/DlbcohFIcJ/lF9un+z+ILsySZFPNCJXUPct9M5zF1nMjaAvTg5x
   myKvUVR9j6+hA1i6tP1zU0i90GYoc7YQceUykD/tNe7EJAVmdOEaPEXX3
   CmkFrhy15GlIwqt7CIOhnuW1qZTy89sRtJ0ZYQd7AxSZEGDTyp9lGerL6
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249658689"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="249658689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 01:25:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541530932"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 01:25:16 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com
Subject: [PATCH] x86 UEFI: Fix broken build for UEFI
Date:   Thu, 10 Feb 2022 17:20:44 +0800
Message-Id: <20220210092044.18808-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UEFI loads EFI applications to dynamic runtime addresses, so it requires
all applications to be compiled as PIC (position independent code).

The new introduced single-step #DB tests series bring some compile time
absolute address, fixed it with RIP relative address.

Fixes: 9734b4236294 ("x86/debug: Add framework for single-step #DB tests")
Fixes: 6bfb9572ec04 ("x86/debug: Test IN instead of RDMSR for single-step #DB emulation test")
Fixes: bc0dd8bdc627 ("x86/debug: Add single-step #DB + STI/MOVSS blocking tests")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 x86/debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 20ff8ebacc16..13d1f9629e1d 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -145,7 +145,7 @@ static unsigned long singlestep_basic(void)
 		"and $~(1<<8),%%rax\n\t"
 		"1:push %%rax\n\t"
 		"popf\n\t"
-		"lea 1b, %0\n\t"
+		"lea 1b(%%rip), %0\n\t"
 		: "=r" (start) : : "rax"
 	);
 	return start;
@@ -186,7 +186,7 @@ static unsigned long singlestep_emulated_instructions(void)
 		"movl $0x3fd, %%edx\n\t"
 		"inb %%dx, %%al\n\t"
 		"popf\n\t"
-		"lea 1b,%0\n\t"
+		"lea 1b(%%rip),%0\n\t"
 		: "=r" (start) : : "rax", "ebx", "ecx", "edx"
 	);
 	return start;
@@ -223,7 +223,7 @@ static unsigned long singlestep_with_sti_blocking(void)
 		"1:and $~(1<<8),%%rax\n\t"
 		"push %%rax\n\t"
 		"popf\n\t"
-		"lea 1b,%0\n\t"
+		"lea 1b(%%rip),%0\n\t"
 		: "=r" (start_rip) : : "rax"
 	);
 	return start_rip;
@@ -259,7 +259,7 @@ static unsigned long singlestep_with_movss_blocking(void)
 		"and $~(1<<8),%%rax\n\t"
 		"1: push %%rax\n\t"
 		"popf\n\t"
-		"lea 1b,%0\n\t"
+		"lea 1b(%%rip),%0\n\t"
 		: "=r" (start_rip) : : "rax"
 	);
 	return start_rip;
@@ -302,7 +302,7 @@ static unsigned long singlestep_with_movss_blocking_and_icebp(void)
 		"1:and $~(1<<8),%%rax\n\t"
 		"push %%rax\n\t"
 		"popf\n\t"
-		"lea 1b,%0\n\t"
+		"lea 1b(%%rip),%0\n\t"
 		: "=r" (start) : : "rax"
 	);
 	return start;
@@ -346,7 +346,7 @@ static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
 		"and $~(1<<8),%%rax\n\t"
 		"push %%rax\n\t"
 		"popf\n\t"
-		"lea 1b,%0\n\t"
+		"lea 1b(%%rip),%0\n\t"
 		: "=r" (start_rip) : : "rax"
 	);
 	return start_rip;
-- 
2.25.1

