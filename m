Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E278876E1BF
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbjHCHhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjHCHgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:09 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7012949DD;
        Thu,  3 Aug 2023 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047940; x=1722583940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vNllE2Y9ire4AWHQOg7xEw0xLKtvwfNzPjWKsewbPlk=;
  b=aPF1Pwb5si9DWTtNIhp5GcTbCkLo2iekEPk1enMjMxC48gJTT3/VDn+v
   0AjY2Wq9rEvOhqW8udK+oIB6iqef345xHemgJEsyzjtKUHCDyw9okNe6O
   ZsyUnt3XruwnJOq/tt7JeNW3bGptip2nHuVHzrd1TDRJvzcHrcPd2xgKJ
   W/PxgK/Azf8tAChGChz1Fb0n0qIWYgumBb5EsiX9/y5NQo+xB9ng/VPr8
   RS4ltY0IUevqyUOPv9Y7Xvde0Ea72RVYQKdHTE310Ve9AT2z4peCz9DFd
   kkRnwJ0KhYkvPH5Th/SK5B6qklXX4Ic4qUGfHuAhYg9E7314NOYkRGyhC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708139"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708139"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888502"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888502"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 12/19] KVM:x86: Save and reload SSP to/from SMRAM
Date:   Thu,  3 Aug 2023 00:27:25 -0400
Message-Id: <20230803042732.88515-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save CET SSP to SMRAM on SMI and reload it on RSM.
KVM emulates architectural behavior when guest enters/leaves SMM
mode, i.e., save registers to SMRAM at the entry of SMM and reload
them at the exit of SMM. Per SDM, SSP is defined as one of
the fields in SMRAM for 64-bit mode, so handle the state accordingly.

Check is_smm() to determine whether kvm_cet_is_msr_accessible()
is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/smm.c | 11 +++++++++++
 arch/x86/kvm/smm.h |  2 +-
 arch/x86/kvm/x86.c | 11 ++++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index b42111a24cc2..e0b62d211306 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -309,6 +309,12 @@ void enter_smm(struct kvm_vcpu *vcpu)
 
 	kvm_smm_changed(vcpu, true);
 
+#ifdef CONFIG_X86_64
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
+		goto error;
+#endif
+
 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
 		goto error;
 
@@ -586,6 +592,11 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
 
+#ifdef CONFIG_X86_64
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, smram.smram64.ssp))
+		return X86EMUL_UNHANDLEABLE;
+#endif
 	kvm_smm_changed(vcpu, false);
 
 	/*
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..1e2a3e18207f 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
+	/* svm_* fields below are not implemented by KVM */
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
 	u64 svm_host_cr4;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98f3ff6078e6..56aa5a3d3913 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3644,8 +3644,17 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return false;
 
-		if (msr->index == MSR_KVM_GUEST_SSP)
+		/*
+		 * This MSR is synthesized mainly for userspace access during
+		 * Live Migration, it also can be accessed in SMM mode by VMM.
+		 * Guest is not allowed to access this MSR.
+		 */
+		if (msr->index == MSR_KVM_GUEST_SSP) {
+			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
+				return true;
+
 			return msr->host_initiated;
+		}
 
 		return msr->host_initiated ||
 			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
-- 
2.27.0

