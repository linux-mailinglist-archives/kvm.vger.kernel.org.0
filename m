Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7068C723D06
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbjFFJTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbjFFJTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:19:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940610D8;
        Tue,  6 Jun 2023 02:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043145; x=1717579145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tljvh4yk2BfW48Qd4w7WVwvTLp8P4EvXXQwqfZqkoXQ=;
  b=WciaHB8WkaJgELMVju9YZvFq/zc7M+dFhgQbrfIlL9hHW1KLs3sttRsr
   uu1VfKUUr4sV2eBx85gsM9ihtGySp0FLB3ajvyPW77mzhbcdmhFLPgza7
   Ob00ouKgT+0WIZiZ+zwWzQD/tINBEVKYNKFTQAxjsWtDMpWcYQKMM0TNK
   gY+bFZKxJHbhflT0wBfmwSNo6eQdkYIyBZ1xv9ip4UA+BayhsLfUbBjZe
   10D5oouS91t6OrKok3JTbCQw0vl+dZDnHZYYFWSgbrd8E6MFqk6gPIyjC
   RdJCIeWxp66M9Fqr4P01TLQIHx+S5uiIZcMj73oE5AO01+N/wQPbfIRoR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252873"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252873"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:19:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263694"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263694"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:19:01 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 6/6] KVM: x86: Expose LAM feature to userspace VMM
Date:   Tue,  6 Jun 2023 17:18:42 +0800
Message-Id: <20230606091842.13123-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606091842.13123-1-binbin.wu@linux.intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
Expose the feature to userspace as the final step after the following
supports:
- CR4.LAM_SUP virtualization
- CR3.LAM_U48 and CR3.LAM_U57 virtualization
- Check and untag 64-bit linear address when LAM applies in instruction
  emulations and VMExit handlers.

LAM support in SGX enclave mode needs additional enabling and is not
included in this patch series.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 241f554f1764..166243fb5705 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -643,7 +643,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA)
+		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.25.1

