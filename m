Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F776758C12
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 05:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjGSD1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 23:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjGSD0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 23:26:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3BA2690;
        Tue, 18 Jul 2023 20:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689737167; x=1721273167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=m7F+bfcxslqE8nz+gTY6bLsLBtHdYH/TwQh4VN2/phU=;
  b=lyWDkJqlf+4Py1HbNsJvZGid17t+6CMp/z0wOFKv80PI9DrDpJWajSFo
   UiYYv8VCoUUzeBXVOwAaNNfoO2aHKBau4DBRYBsAE1KxPmOCGNPfAB1kS
   DoNsX+GkDW9TNI3gsOrzmeJ92UbHrCo6TMZW5fd5GsoWNdoUzJki/SmBY
   uOvKQH8AqLAF36EyndG5cEqCnit0k0OLQhAq7SnMgkAOz8o8bhxRsGsfx
   +cbD65Rl3OcmP6DKGdPIoxBAGegUGvtVCvz6ch9gjr34FpLzjAAILyWxm
   BugxqO3uNCedslogV3RlJcJL0vx0ZOLyXyEe+bA/9qraR87K5QRKXKt/Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="346665883"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="346665883"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 20:26:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="813980304"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="813980304"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 20:26:03 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 8/8] KVM: x86: Advertise LASS CPUID to user space
Date:   Wed, 19 Jul 2023 10:45:58 +0800
Message-Id: <20230719024558.8539-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719024558.8539-1-guang.zeng@intel.com>
References: <20230719024558.8539-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linear address space separation (LASS) is an independent mechanism
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

