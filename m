Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543DA576133
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 14:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiGOMUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 08:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiGOMUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 08:20:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330E7B7BA
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 05:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657887601; x=1689423601;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y3YXE4xFA5TH0ITt3qJCV1/2bqSp9ks+XyeFiUaZonw=;
  b=ZExOFHKxJheXP8tMe8hwUEwzA3l6tBipvvARqycxLKDbo2CWVIqBPqbi
   xFZkhTx/reEFi3SpGmpJmrstYitqeJDVK7I/NUN3HWevt+HAEOo7Rmaab
   IpstqGdCVY8bnNHnjlPppKJSyb4EiIEr56yUa+SG0XUOwcZZUKoS4JhAZ
   QYI1qJDXOhfIVAAICBKvKQWmmSXEx64sqg79fVoT5wEftbJVKtTNtDJjt
   6h5oIqsglgaFnfFmIz0/sG0bBRPS87SRemy+aDEnF77ae36+EwtBeoKTw
   UVE9el3BUY5S+noG1E0bXpp8DG9jos/OkJy4lIQ97KZoO5MEAoIcTviGu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286919178"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="286919178"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 05:19:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="654313042"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jul 2022 05:19:13 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] X86: Set up EPT before running vmx_pf_exception_test
Date:   Fri, 15 Jul 2022 19:33:34 +0800
Message-Id: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although currently vmx_pf_exception_test can succeed, its
success is actually because we are using identical mappings
in the page tables and EB.PF is not set by L1. In practice,
the #PFs shall be expected by L1, if it is using shadowing
for L2.

So just set up the EPT, and clear the EB.PT, then L1 has the
right to claim a failure if a #PF is encountered.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 x86/vmx_tests.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..cc90611 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10639,6 +10639,17 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
 
 static void vmx_pf_exception_test(void)
 {
+	u32 eb;
+
+	if (setup_ept(false)) {
+		printf("EPT not supported.\n");
+		return;
+	}
+
+	eb = vmcs_read(EXC_BITMAP);
+	eb &= ~(1 << PF_VECTOR);
+	vmcs_write(EXC_BITMAP, eb);
+
 	__vmx_pf_exception_test(NULL, NULL);
 }
 
-- 
2.25.1

