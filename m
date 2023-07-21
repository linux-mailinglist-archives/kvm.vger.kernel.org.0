Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE6C75BE63
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjGUGJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjGUGI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EE610F3;
        Thu, 20 Jul 2023 23:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919737; x=1721455737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RHa2LwonmPJL/W+28Rw5xERcqDGr/QwBrpN8d1H9ufA=;
  b=TK1fBbV7gUDtFxIcrP8GOI42bWzIdyfSEjtJ8Dn4/4SLj6SXRO+CoHpI
   ecn+GieOg4lu9YBYcpfl9G/Ujx+hcYOgDEcE800F5DBuKE7r34JH8Lkvq
   s9Tsn6oEqvn/CrzFLF5Eu3CG1bb3Vf8Yb3sSi2lHrQ6mpWzoVTwDdqSIi
   UdQ4cK90bPUK1ssBivnbEx9JYucQZAhpawm0qS85zTVhRV/0ChWeyP8zc
   7rYOCmD9gaKbmWLfkxW7yeI2fMbpuo2NhzaneyTI78hoznoiwzLpYs+06
   M7N3wYErdVpWSWOJctt1LEmPxAFhD1XxJDFtJNHQhLE4p0KGyTFKg+j7s
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547577"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547577"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721974"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721974"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 11/20] KVM:x86: Save and reload GUEST_SSP to/from SMRAM
Date:   Thu, 20 Jul 2023 23:03:43 -0400
Message-Id: <20230721030352.72414-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save GUEST_SSP to SMRAM on SMI and reload it on RSM.
KVM emulates architectural behavior when guest enters/leaves SMM
mode, i.e., save registers to SMRAM at the entry of SMM and reload
them at the exit of SMM. Per SDM, GUEST_SSP is defined as one of
the fields in SMRAM for 64-bit mode, so handle the state accordingly.

Check HF_SMM_MASK to determine whether kvm_cet_is_msr_accessible()
is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/smm.c | 17 +++++++++++++++++
 arch/x86/kvm/smm.h |  2 +-
 arch/x86/kvm/x86.c | 12 +++++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index b42111a24cc2..a4e19d72224f 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -309,6 +309,15 @@ void enter_smm(struct kvm_vcpu *vcpu)
 
 	kvm_smm_changed(vcpu, true);
 
+#ifdef CONFIG_X86_64
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
+		u64 data;
+
+		if (!kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &data))
+			smram.smram64.ssp = data;
+	}
+#endif
+
 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
 		goto error;
 
@@ -586,6 +595,14 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
 
+#ifdef CONFIG_X86_64
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
+		u64 data = smram.smram64.ssp;
+
+		if (is_noncanonical_address(data, vcpu) && IS_ALIGNED(data, 4))
+			kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, data);
+	}
+#endif
 	kvm_smm_changed(vcpu, false);
 
 	/*
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..b3efef7cb1dc 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,7 +116,7 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
+	/* svm_* fields below are not implemented by KVM */
 	u64 ssp;
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7558f0f6fc0..70d7c80889d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3653,8 +3653,18 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return false;
 
-		if (msr->index == MSR_KVM_GUEST_SSP)
+		/*
+		 * This MSR is synthesized mainly for userspace access during
+		 * Live Migration, it also can be accessed in SMM mode by VMM.
+		 * Guest is not allowed to access this MSR.
+		 */
+		if (msr->index == MSR_KVM_GUEST_SSP) {
+			if (IS_ENABLED(CONFIG_X86_64) &&
+			    !!(vcpu->arch.hflags & HF_SMM_MASK))
+				return true;
+
 			return msr->host_initiated;
+		}
 
 		return msr->host_initiated ||
 			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
-- 
2.27.0

