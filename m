Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4260600741
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJQHFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiJQHFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985EA45062
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990346; x=1697526346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=99ZJJ5HzQnjNx0/bsTWN33j47deBGn1IFbZmaJKs6hQ=;
  b=bJsFEmq/ZO63MCDJ8xf3kdQu8kCNOjS71HThKTBGPfQkH5dgzMQnL3UK
   N9ElPJQvdkegBAl1KEc0b22zdQVXps/ozXlt2pFylKl0Urt/PfxtQOKHN
   nbKLkz3IgDbjMJ60ORpGpWHP7PVvs6ZIhyhHWZHgf5hvfjV2rmH6E+9MB
   0i4ADlIIM03dqvw23wWLdZ1X6C/HMYM2ik5uD779HqPlIuxXK7QvwqVCq
   PMXIs1OCxZZsFPlLRHAt4fpiBEe5sjueGgztz6tIWBVPZ6HhgCVu+0iCB
   WU0kLx6NaPQb/OdZwKGOtgQ0lRQQ2BVttqYZi1+WlR1cjRx9hCreogIgq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="392031207"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="392031207"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271491"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271491"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:27 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
Date:   Mon, 17 Oct 2022 15:04:50 +0800
Message-Id: <20221017070450.23031-10-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017070450.23031-1-robert.hu@linux.intel.com>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index b935b3b04a7e..89bcac3e4ac4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -636,7 +636,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(LAM)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.31.1

