Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E16544633
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiFIInZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiFIIlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:41:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E9A10FF2
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654763998; x=1686299998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OmN8Ws7S3OEuPkjP7bzIf9JYo0r6bM0go8y96r+IWbQ=;
  b=T2df3RR7F6AIsrLz4mtjLKWelHlxVlXtDn3k9+RckFehwdddUXa/Jokj
   nj9QdmdZ+ha7NjsBHKr8qds6jiukBSW5sEM+n5KY7wGJmYryCMbt8HRQC
   uXadiSJSttYKM5fU4EvRSAJuw8YbaQGtO0I5fIvKs1J2JkowWPe6JfCGm
   R7I6s6EpfIN6NvY9MKonDo+xgFxdY8GKKFNX6FbrTWlbvyomUhEShxuJh
   fx14Qx/xoGxzY+oIpWg/c2nKaW6z8s5E9y2b9UC7LeSSUPssTOKG/aAVR
   UEZKRd0T0vOVeB3KOoNb+2SVvD7yE4sSZNeYruZtVwgfNkXTwGPSdGwJ0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="274727185"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="274727185"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="580475520"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:56 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu is disabled
Date:   Thu,  9 Jun 2022 04:39:16 -0400
Message-Id: <20220609083916.36658-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220609083916.36658-1-weijiang.yang@intel.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

