Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE7E647D08
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLIEq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLIEqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5790D7D08B
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561180; x=1702097180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IomsSGrJshpyZeGMJa1RixcPcuVZZpmDUTNciq4wUeg=;
  b=PwS07cjKScrPApUjzetWMsT1VQMcglT+ExiW1tfXSctM3dsnvCqsKs+P
   IgTkuzK7Z2pNznPQDHPdz5RsY1CN77NIVrESwkAR4WCSA+XOH9ayHbiSX
   IW7LFCF9j3NcGONdm5Z21jzsW9VKfqvxi/QlZa/tcsFDuzSLCwqq/um0k
   AaDQ1IUMQ8B8KdpqPaArUG1499JHNy50R6nTYedcT4sbBc837pWb07FDv
   IUz5/S4c+g3/qtgiVw93St7c5FRyLl4Dmna/OqHmiJoGNW4MNYs5Ee42p
   cMmsf1LrJVB0Lh3HsWRm6sh7pqeKJi4RrrQD58chXTAZlNqMQLXyUmxd8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530875"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530875"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524491"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524491"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:18 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
Date:   Fri,  9 Dec 2022 12:45:57 +0800
Message-Id: <20221209044557.1496580-10-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LAM feature is enumerated by (EAX=07H, ECX=01H):EAX.LAM[bit26].

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 01e2b93ef563..1e7c7f9d756b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,7 +657,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(LAM)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.31.1

