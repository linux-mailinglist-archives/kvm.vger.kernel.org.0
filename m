Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2A544636
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbiFIIoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241929AbiFIIk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:40:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659B6F5A5
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654763997; x=1686299997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O3rw8dE6tlhL/guKrMkUuSDSNCpnH53kklEO6xcf8wg=;
  b=LwLuL23siblyPEMqsyaiH7hbgU3dq1haQwSwqhj4n7g9NvriDgFt9mxq
   f6cHSeUW/8jAUyqsl/CFSAtup6CB1jzTG+KGkGd/ydFF1quQs11NFyPwZ
   bSSzRywsOwkJN8XWJsYfqR6rGFpMqe3IgrvOC2prEDUAv+rz7MzYaNFFX
   Vzi4prNtxBaH9ieR0Orz1c783E3pBnLuq3YuHh5seUwLKtvpl2YHzNdGe
   QNKIv0hQUMB4/JCDCiaoAiwuy+xA7UZxf8Pld5RhMC+TxyNyxXpKNiK5A
   pWIeaOUjdZENqLE+nHc9aOOCqT0MpfOmWU3UHSpvxVi7rmfOxL9bNybFR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="274727182"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="274727182"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="580475518"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:56 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 2/3] x86: Skip running test when pmu is disabled
Date:   Thu,  9 Jun 2022 04:39:15 -0400
Message-Id: <20220609083916.36658-3-weijiang.yang@intel.com>
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

Read MSR_IA32_PERF_CAPABILITIES triggers #GP when pmu is disabled
by enable_pmu=0 in KVM. Let's check whether pmu is available before
issue msr reading to avoid the #GP.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/pmu_lbr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 688634d..835a7bb 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -74,13 +74,15 @@ int main(int ac, char **av)
 		return 0;
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	eax.full = id.a;
 
 	if (!eax.split.version_id) {
 		printf("No pmu is detected!\n");
 		return report_summary();
 	}
+
+	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
 		printf("No LBR is detected!\n");
 		return report_summary();
-- 
2.31.1

