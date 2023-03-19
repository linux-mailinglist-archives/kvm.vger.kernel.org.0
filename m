Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836266C0028
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCSItn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCSItl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:49:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C391A496
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215780; x=1710751780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xNrunTdo0vvnnwWCoVCBRwV5lHAA0UcXRvs5A3f4bu8=;
  b=SH6ZguCi/q0MpA9m68z39itENCOAAVQgwq6upgHO+sT+Kq0oN1KLAlQM
   xPb5K6LHmE9bsiM6Kj2EW6S0AhD1uh8cQnIpO16X/25l1U//GztuTj/3H
   Vlk5t1XW754bmBc0bhWd82LSjYfWEo+0nIumHdz7FcdM1bVxIGEnq2qsW
   SGNXy8hdhKxxM7BuM5loALVr2Mh2gSLAfoZW56YuRjiz7p4UTAVdU75tC
   XGdTNet4bkWji6uoTyaiwoZz8popL0/GZY8u0b7agZAAflVcAbyEbR9Z+
   eLABbY50mEq/JIkIXg+R0sF78TthTjSpuTSy6ujkMKlfl3wgBvpJV98sI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767844"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767844"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="683146273"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="683146273"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:38 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode
Date:   Sun, 19 Mar 2023 16:49:22 +0800
Message-Id: <20230319084927.29607-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319084927.29607-1-binbin.wu@linux.intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
to check 64-bit mode. Should use is_64_bit_mode() instead.

Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/sgx.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..0f84cc05f57c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4959,7 +4959,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 
 	/* Checks for #GP/#SS exceptions. */
 	exn = false;
-	if (is_long_mode(vcpu)) {
+	if (is_64_bit_mode(vcpu)) {
 		/*
 		 * The virtual/linear address is never truncated in 64-bit
 		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
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
-- 
2.25.1

