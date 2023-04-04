Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2CF6D5731
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjDDDZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDDDZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:25:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF151981
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680578709; x=1712114709;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oUVSLusm5Nf5rqxo9lIyFw/dKiWFbkoqgeayB7pOnvA=;
  b=nup2hD7LVt56ZwAVRY/uQPU4ISttaGVvTIPy2VaojciFdT8pwH5RiK8f
   1wUsuQUv6Uj9TFtXEc0COuFXBkf5xjSCW0wMxgnlWM+GW8aRWF9VHMt6t
   dasvTvkXJWxbtzic143cI/UTakHLIc/gNiJaquTI0wvPXaQ7rxz32H8qJ
   NV5RbiKIas4D7s18w8lbqy20vSXl6CuGdCYPeJ/I9wSn7YngDV+NQTN/e
   7qc9CBWjFsXOIWl/FhSKRcCgcYWaPVW6A7/8/GZC/Hdq6n5I7f9Zxfqiv
   A1LGKA7ygCBBBbs9xjPw/XpB0fUy3QESm3x92AvbTNZGknPVL9s7Ajfzy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407138993"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="407138993"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688727974"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688727974"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.215.140])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:25:06 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, kai.huang@intel.com
Subject: [PATCH] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in SGX handler
Date:   Tue,  4 Apr 2023 11:25:02 +0800
Message-Id: <20230404032502.27798-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sgx_get_encls_gva() uses is_long_mode() to check 64-bit mode, however,
SGX system leaf instructions are valid in compatibility mode, should
use is_64_bit_mode() instead.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/sgx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index aa53c98034bf..0574030b071f 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -29,14 +29,14 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 
 	/* Skip vmcs.GUEST_DS retrieval for 64-bit mode to avoid VMREADs. */
 	*gva = offset;
-	if (!is_long_mode(vcpu)) {
+	if (!is_64_bit_mode(vcpu)) {
 		vmx_get_segment(vcpu, &s, VCPU_SREG_DS);
 		*gva += s.base;
 	}
 
 	if (!IS_ALIGNED(*gva, alignment)) {
 		fault = true;
-	} else if (likely(is_long_mode(vcpu))) {
+	} else if (likely(is_64_bit_mode(vcpu))) {
 		fault = is_noncanonical_address(*gva, vcpu);
 	} else {
 		*gva &= 0xffffffff;

base-commit: 99b30869804ea59d9596cdbefa5cc3aabd588521
-- 
2.25.1

