Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E207579ED6F
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjIMPl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjIMPkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698531BE4;
        Wed, 13 Sep 2023 08:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619626; x=1726155626;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aFM3zDu49yerMd0myGuj4WSkYy3hmOJ/G+i4h2Pdn1k=;
  b=JTSU3LpLXQkZih1l9A7e0m1vMi5A70qT3GqcPE8GWzVwSiPx1ZfbfaVF
   xleR7R2n/UTqcxApmem35ztrMQ6hDEf8EYk2XdINPv62tyng/b+d9ljHU
   mgTili5s3hrtQu7+0G9lY6E6ejNugnOPRQklHC7zqh+wWoN8YACxP6uSi
   +STP1hPCRxaOBlRfKQrCRTHd7CGhCRqDA8jNrhkZ3tHfUfkJ+pSRO+812
   XMUajGTzFz4Wa5sW8OrFSnAP6Ei9D4PP06RDbzRz9dRY7+Pz8rqEh7p+k
   60LQ1gLmcNHuIkEimo3RT+1tPkXV9xvrx1RkRwswMxN6ex3Hc/nwanBn6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030312"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030312"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852277"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852277"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:23 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 16/16] KVM: x86: Advertise LASS CPUID to user space
Date:   Wed, 13 Sep 2023 20:42:27 +0800
Message-Id: <20230913124227.12574-17-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zeng Guang <guang.zeng@intel.com>

Linear address space separation (LASS) is an independent mechanism
to enforce the mode-based protection that can prevent user-mode
accesses to supervisor-mode addresses, and vice versa. Because the
LASS protections are applied before paging, malicious software can
not acquire any paging-based timing information to compromise the
security of system.

The CPUID bit definition to support LASS:
CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6]

Advertise LASS to user space to support LASS virtualization.

Note: KVM LASS feature exposure also depends on cpuid capability
held by host kernel. It will be masked to guest if host vsyscall
is in emulate mode which actually disables LASS.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a0db266bab73..81a52218c20f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -675,7 +675,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
+		F(AVX_VNNI) | F(AVX512_BF16) | F(LASS) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
-- 
2.25.1

