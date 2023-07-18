Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9F757EE3
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjGROBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjGROA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932AE1BCD;
        Tue, 18 Jul 2023 07:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688840; x=1721224840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=m7F+bfcxslqE8nz+gTY6bLsLBtHdYH/TwQh4VN2/phU=;
  b=a7Kd2CchCOKP65+qJTCKzfzpD0zqZ9gT8L3reqGMPzhj69T0DeKTEy3p
   az+/m5K8UeVr6ZIzB23ShZA6YBnw+KDQIOptty6tovheB3yrLH7fN1JIB
   DnNKY1ca7ytSyL6g3QUQSodsaCCSKvlS+kwREfTIzi+lfmTm4iocYoB3c
   V3M0mLGK7Qz/wjEG6cZqN1asaE5W2bUcXpjmHMX9NCevBRTIkjBAQ0R3Y
   bwW15ZebLst4ivfK9+GsxOhXxmAjiBSbuBk88UdEEnBZ0U6KKXnmWfwYo
   9Jt8gIIRi5U+uRyoAaN7eVZanxLDRZs0ZrQrl5ckLabJUGxALjHp9kfFR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676209"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676209"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:59:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291208"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291208"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:59:02 -0700
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
Date:   Tue, 18 Jul 2023 21:18:44 +0800
Message-Id: <20230718131844.5706-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230718131844.5706-1-guang.zeng@intel.com>
References: <20230718131844.5706-1-guang.zeng@intel.com>
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

