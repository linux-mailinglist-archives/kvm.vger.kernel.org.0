Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D401154C3E9
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 10:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346566AbiFOIrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 04:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345197AbiFOIrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 04:47:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5FD4B1FE
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282839; x=1686818839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OmN8Ws7S3OEuPkjP7bzIf9JYo0r6bM0go8y96r+IWbQ=;
  b=i+ntQodP52ulQ2auD+JdlzfPDSUXXm1O2gDoddEmdzBw1orDlnQuz/5K
   zHzMZPwDLWQFHzryZcVwHjJbwfy49oUncdDnHTM7scN9vDEb100TEMEB9
   eNBwn3guFNBu0XPc+xyZ2rCBLr78b4XzjDvzXHMq8rlm1W6JlguWFoeP8
   6QOI2FP5RhqCNRBEyAQbl6aE7lzUGnaRuB7r1+3LVt/9K0jNHIWYeoWDs
   SXrZlEs8TxWg+D9CxG0h4F9kAIDGh02y1RnGEn7ZaP5Od5LQjQ6LhfM5o
   t9Gup8jZLf7UPHxMou8Ak6RBZPCVJMHkQZr1/rzMVEfuc3FouBde+VnQf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="342848611"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="342848611"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="558944466"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     like.xu.linux@gmail.com, jmattson@google.com, kvm@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 3/3] x86: Skip perf related tests when pmu is disabled
Date:   Wed, 15 Jun 2022 04:46:41 -0400
Message-Id: <20220615084641.6977-4-weijiang.yang@intel.com>
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

When pmu is disabled in KVM, reading MSR_CORE_PERF_GLOBAL_CTRL
or executing rdpmc leads to #GP, so skip related tests in this case.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx_tests.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..dd6fc13 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -944,6 +944,16 @@ static void insn_intercept_main(void)
 			continue;
 		}
 
+		if (insn_table[cur_insn].flag == CPU_RDPMC) {
+			struct cpuid id = cpuid(10);
+
+			if (!(id.a & 0xff)) {
+				printf("\tFeature required for %s is not supported.\n",
+				       insn_table[cur_insn].name);
+				continue;
+			}
+		}
+
 		if (insn_table[cur_insn].disabled) {
 			printf("\tFeature required for %s is not supported.\n",
 			       insn_table[cur_insn].name);
@@ -7490,6 +7500,13 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 
 static void test_load_host_perf_global_ctrl(void)
 {
+	struct cpuid id = cpuid(10);
+
+	if (!(id.a & 0xff)) {
+		report_skip("test_load_host_perf_global_ctrl");
+		return;
+	}
+
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
 		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
 		return;
@@ -7502,6 +7519,13 @@ static void test_load_host_perf_global_ctrl(void)
 
 static void test_load_guest_perf_global_ctrl(void)
 {
+	struct cpuid id = cpuid(10);
+
+	if (!(id.a & 0xff)) {
+		report_skip("test_load_guest_perf_global_ctrl");
+		return;
+	}
+
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
 		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
 		return;
-- 
2.31.1

