Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6347598BB
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjGSOml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjGSOmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:42:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145E26B2;
        Wed, 19 Jul 2023 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777722; x=1721313722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BFqvAUutJF9pxnmNohwquM/IhtEy7DIeB7KfVhQeILE=;
  b=W/baeReAr6k6NZUod7P0FRBNfj9TiITw5BCRQKe7pXwbZpJtBnG4tRV7
   M8NLQ5LO0OOU4fOM4zo9+EjnpbNtPwpLMeff5YbhXdMXxksaOo759qOvd
   jeZXuJld6wpzVm8EX2gChF3X4MfJResSnlPhp/st84NPfemIZUvN5fGu+
   9Ws+MAqkyZrY0i+7BJsYx6WLNjgz6zbJ76hya9v042VCJgQM1xNCDYG7Y
   W2yB5l+1PpNTwE9Rx/hCs23LMrlmorZSMD3ZOPX0OAeEGMeMiXCXOSS2Q
   V/T/E/pY8Fak7dYHCq+rPgUTHZsI7wMKM5t5Q5XlCr+JhMG5TIKEvkgAs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788223"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788223"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:42:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503358"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:58 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 9/9] KVM: x86: Expose LAM feature to userspace VMM
Date:   Wed, 19 Jul 2023 22:41:31 +0800
Message-Id: <20230719144131.29052-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

Exposing SGX LAM support is not supported yet. SGX LAM support is enumerated
in SGX's own CPUID and there's no hard requirement that it must be supported
when LAM is reported in CPUID leaf 0x7.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7ebf3ce1bb5f..21d525b01d45 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -645,7 +645,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA)
+		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.25.1

