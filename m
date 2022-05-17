Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0381152A72C
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350375AbiEQPm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350485AbiEQPlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892FF41300;
        Tue, 17 May 2022 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802096; x=1684338096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCcEV/p27oXy+SVtfRE3Ssp6Itei+XlgrjZFi0lR+dc=;
  b=FbyuM+PYJoEw9nm+pXAEB/ZrvJ9g+o+5tDH2F+GtQklvVLNfDpcQS0Vt
   SwLgdOFsyDgO1BDfsfCTuBO6s5y3cj+JkVi503swpxwpdJg6xxRvb7v4i
   Y4OOIVArclOoh5oWE6lN0qH9C4Fm2gV/PN8BH+1TOXP4qKIDfHQ9Q74fD
   sFFwNCdOC0alEObdA4Jd9I/ue5bd92MKt21R7t3RvdOyPBUKJPPZBiyb4
   7u4QgBB9HvC6hEnCzjE4yaSr40XcY4TFCiYKO+yWnEH0kercbfRVdXs+g
   E+y8h5ee7ONn2LLmJzFK2DRZR4oeSoAi7lGlwh1ohjfHQJKHEDQh3p04i
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632100"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632100"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533568"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:33 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 05/16] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
Date:   Tue, 17 May 2022 11:40:49 -0400
Message-Id: <20220517154100.29983-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are queried by
userspace application before it wants to {save|restore} the Arch LBR
data. Other LBR related data MSRs are omitted here intentionally due
to lengthy list(32*3). Userspace can still use KVM_{GET|SET}_MSRS to
access them if necessary.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 247c58f5c8af..93b027aed2f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1458,6 +1458,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6741,6 +6742,11 @@ static void kvm_init_msr_list(void)
 			if (!supported_xss)
 				continue;
 			break;
+		case MSR_ARCH_LBR_DEPTH:
+		case MSR_ARCH_LBR_CTL:
+			if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

