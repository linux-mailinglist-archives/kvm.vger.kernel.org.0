Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9B6C41C3
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCVE6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCVE6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:58:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1E932CF2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 21:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679461114; x=1710997114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PenoVWGwbLPipDBWuAwK5jD89K6uC19uUmHnFyzng+Q=;
  b=d4jr7Hskw7cPQfmfR5FXe06LnYIWIhf/95MB+wIbRPJcEDnTXlLxvwA+
   howNIk9/EPOMGNCUMvmIgGy9wfid2wA5yN+tpROXzKls8nS/uIMbJ+tOM
   SJFEH8wWcnmNNtWv4xDnmqfHCVhhbUV9g7qNYDHR4wr8zXupHzIpPP8gd
   okct8d8wSKIg3xeKzcH5t+YSq4axOkq3pOj1OaEsog0b/Idgg21DIVZPN
   WiFRaUAyxrFl8GJjl49RK1bhDmalPCyzwPKN3XPYEurU4TIBP9GuD4jHP
   5y7R05k7eJB7YilyK7RCLykpQwT+ZlmyGU9aPNfh/7u9Pdn22JPKfvlqF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="327507204"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="327507204"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750908547"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="750908547"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:32 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, robert.hu@linux.intel.com
Subject: [PATCH 3/4] KVM: SVM: Remove implicit cast from ulong to bool in svm_can_emulate_instruction()
Date:   Wed, 22 Mar 2023 12:58:23 +0800
Message-Id: <20230322045824.22970-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322045824.22970-1-binbin.wu@linux.intel.com>
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove implicit cast from ulong to bool in svm_can_emulate_instruction().

Drop the local var smep and smap, which are used only once.
Instead, use kvm_is_cr4_bit_set() directly.
It should be OK to call kvm_is_cr4_bit_set() twice since X86_CR4_SMAP and
X86_CR4_SMEP are intercepted and the values are read from cache instead of
VMCS field.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 70183d2271b5..a5b9278f0052 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4544,8 +4544,7 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 					void *insn, int insn_len)
 {
-	bool smep, smap, is_user;
-	unsigned long cr4;
+	bool is_user;
 	u64 error_code;
 
 	/* Emulation is always possible when KVM has access to all guest state. */
@@ -4637,11 +4636,9 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	if (error_code & (PFERR_GUEST_PAGE_MASK | PFERR_FETCH_MASK))
 		goto resume_guest;
 
-	cr4 = kvm_read_cr4(vcpu);
-	smep = cr4 & X86_CR4_SMEP;
-	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
-	if (smap && (!smep || is_user)) {
+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) &&
+	    (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMEP) || is_user)) {
 		pr_err_ratelimited("SEV Guest triggered AMD Erratum 1096\n");
 
 		/*
-- 
2.25.1

