Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A016383C4
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKYGKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYGKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:04 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B11E1F633;
        Thu, 24 Nov 2022 22:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356603; x=1700892603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BxKmdti/F0ZDN+6HkQ50O9NI5gzI7uJBgUfpvPRf2BQ=;
  b=K160JpoaXFeFFMJCzDyATZ2n9HFdS4SNB0tT9DAGCJb20m3mZ5SfyosM
   6BKoGG3DEhI3qjdMs5t22VIMU3XQMCPWdUbcC7CFpXF+ZBbsZ5eY7A/v0
   VF3KNswHw9YqUSDvS5IuotTgXoDkyX7pB1wDCvJZRiySw2ZtBJ9bWHXdR
   hV/rvp/JzCvVandQSvhsi3UG3I2XA3iQHdyKtP/gosH9svr41+JMutWBB
   mPpSdbuwaF71eRdki/vijRArtMsfazjPYwFdTmVtcCT3nwqfcXJoj+8GK
   Vhzz0ZaX89+R4h6Tj4yWBXQgaKFK6HQPy6zbCIRZaOUqinBDOEiEr2cvR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116799"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116799"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838453"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838453"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:01 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 02/15] KVM: x86: Report XSS as an MSR to be saved if there are supported features
Date:   Thu, 24 Nov 2022 23:05:51 -0500
Message-Id: <20221125040604.5051-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add MSR_IA32_XSS to the list of MSRs reported to userspace if
supported_xss is non-zero, i.e. KVM supports at least one XSS based
feature.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f18f579ebde8..16726b44061b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1465,6 +1465,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XSS,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -7061,6 +7062,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
 				continue;
 			break;
+		case MSR_IA32_XSS:
+			if (!kvm_caps.supported_xss)
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

