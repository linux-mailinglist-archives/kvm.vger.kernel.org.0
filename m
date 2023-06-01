Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB371A1F6
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbjFAPFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbjFAPF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:05:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BA810E9;
        Thu,  1 Jun 2023 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631874; x=1717167874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Qobfjghbe5gi6AIkAjOe1SXmoivnNVnCI+24keSLXNs=;
  b=ahgAhLOD/8SwtU/IAVU21c2CbVTj02Be++UwKkW0PFxjGhsvipBbRzOc
   xsfTu8THe0sQ+ofqkGOVuoEwI3p3uoYUuGS82WVLpmzHsdAvCWVDXzrCq
   8yAZNaJl8vWGrOA/xpOOd+386aShwmnsRLsCQuwd0ymMwEeNOv0/uvkke
   43vQbHw8weCxf2UInOeWM09mqSuyJ9+efP6kwVLTI+tGdIR8qBdCxFWvH
   P1S0zFBq0HcCZhvJPDKVH7m91EvtMfdauxdJHnMxVt8BD33D2dcLqVdIe
   Lm2Bs52CBnSEtsoM04GxH4rUB/I9WsLwbicctXqXR3SGBu2U8TwBprnVS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853504"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853504"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828278"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828278"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:54 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v1 6/6] KVM: x86: Advertise LASS CPUID to user space
Date:   Thu,  1 Jun 2023 22:23:09 +0800
Message-Id: <20230601142309.6307-7-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a07b23..a7fafe99ffe4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -646,9 +646,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
-		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(LASS) | F(CMPCCXADD) |
+		F(FZRM) | F(FSRS) | F(FSRC) | F(AMX_FP16) | F(AVX_IFMA)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.27.0

