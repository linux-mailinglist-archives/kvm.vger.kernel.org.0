Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6462433C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiKJN32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiKJN3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:29:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4D773761
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668086959; x=1699622959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANvf/+DuZdNP+k0tyUr4KncUf13m/TMY5kMB8zUMcX8=;
  b=NnlvVX2q9gWTh/lfTuOvA81jNEABCE70LPs2/S8AAtMx5k/MBhk+gujt
   AWaebejnGmPFCxcbb0NXjV7VtvA5LCaC6+QRm9AUX4Kql2OXesLlyXElJ
   pNtuAIDjb2RRWDNE9XQI3A3veYxpzWgnCDspXvMwT+V3o0HlH49E8zNuc
   6BsI5EGMb3Dl/5qc2/UJ9F2of9uFsHNZU2eicOJsAN33FxT7LZij5j/fB
   AlZjkNBxB4eN1xPlVo9JCJDcZcRMblyOtFR4Slss+jdCmdsvBAo9c2FVo
   RcFGhiFksV04vCkyGnfxJnPrKMnVIjR152Fu57PvuxYM/Bgh+73UYx0u3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311306369"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="311306369"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:29:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="812038354"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="812038354"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 05:29:17 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v2 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
Date:   Thu, 10 Nov 2022 21:28:48 +0800
Message-Id: <20221110132848.330793-10-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110132848.330793-1-robert.hu@linux.intel.com>
References: <20221110132848.330793-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 02baeb936974..49592c699272 100644
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

