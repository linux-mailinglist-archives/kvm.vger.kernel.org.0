Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993DF6E96C8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjDTOQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjDTOQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967FE5594;
        Thu, 20 Apr 2023 07:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000180; x=1713536180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/9rOO3Vbv54KntD8O0wgn+L44l9VgaKRnztR0QPc7F0=;
  b=FGLh1XN6L0CmuLbhgRPOwS0kpy2wfbadqE3Vrb+pdgG60Jx9yNssS98X
   TKHqfr5a4AwcdCr/ljmidxJ8209H29UESkdaNwNmzvCTSo092PF8PoOEz
   nWjmNf9I8JCLeBT9avg8JBQKSXr3whtGJXIxBqsfdkamiFbab2exkapZK
   GLRZhXykzXToKbj5/lBDTxlybZFUqY/1WxlHWHYuDHRxcYdUI12bV97Fp
   sjnoNBpc/cz3+XQ2RT1vqEJMVukI6OTJZ4Mcf0sclr0+Hc/FmXUKtex6E
   QklRIumkp76Ks6MjLrw/t+rDsEy3DA9m1Ufn8GFNg5W1D/mPHU9uGail6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343217863"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343217863"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816028909"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="816028909"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:13 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 5/6] KVM: x86: Advertise LASS CPUID to user space
Date:   Thu, 20 Apr 2023 21:37:23 +0800
Message-Id: <20230420133724.11398-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420133724.11398-1-guang.zeng@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LASS (Linear-address space separation) is an independent mechanism
to enforce the mode-based protection that can prevent user-mode
accesses to supervisor-mode addresses, and vice versa. Because the
LASS protections are applied before paging, malicious software can
not acquire any paging-based timing information to compromise the
security of system.

The CPUID bit definition to support LASS:
CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6]

Advertise LASS to user space to support LASS virtualization.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ba7f7abc8964..5facb8037140 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -663,8 +663,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
-		F(AVX_IFMA)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(LASS) | F(CMPCCXADD) |
+		F(AMX_FP16) | F(AVX_IFMA)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.27.0

