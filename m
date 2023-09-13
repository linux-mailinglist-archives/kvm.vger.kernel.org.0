Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B949079ED5F
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjIMPk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjIMPkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40AC1998;
        Wed, 13 Sep 2023 08:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619601; x=1726155601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=67P2iLxdV87t35mWNljMwrzWvImeQnpC9+86T3M9PiA=;
  b=esNBrkouJ56Rd+D/y9y//ajdluY99st1Rld8HqSj0aehWezBxFQt7BuF
   w6yaxidEkWImtVTtaff2+kv9sBgHclyK7RbFfwRwypA3WjLHK/gyfD3e4
   VIU72b3hyxv72mivx8+11KQRuYXWmkSa6a8NPPD16n6wsOvtO4Lj+M4SG
   E47PDj3jIrAqCSRK8hjqNJwWE+PoXkOcvm5/cCCpekAtV3DQXknUK5MM5
   Cq8ZcJQtar/lhgZ0o3Uwf9/Yy/0wIO9JVJPcHVzfnlXrDA30jmWZQLe/4
   VW08ZDMMpVPTFCk5bhbRvfetJVvmmDf6pKEH8SFmA0iRzYm1f35T55uWp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030203"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030203"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852107"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852107"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:58 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 07/16] KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
Date:   Wed, 13 Sep 2023 20:42:18 +0800
Message-Id: <20230913124227.12574-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_vcpu_is_illegal_gpa() and use !kvm_vcpu_is_legal_gpa() instead.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.h      | 5 -----
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index ca1fdab31d1e..31b7def60282 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -47,11 +47,6 @@ static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return !(gpa & vcpu->arch.reserved_gpa_bits);
 }
 
-static inline bool kvm_vcpu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
-{
-	return !kvm_vcpu_is_legal_gpa(vcpu, gpa);
-}
-
 static inline bool kvm_vcpu_is_legal_aligned_gpa(struct kvm_vcpu *vcpu,
 						 gpa_t gpa, gpa_t alignment)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index db61cf8e3128..51622878d6e4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2717,7 +2717,7 @@ static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 	}
 
 	/* Reserved bits should not be set */
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, new_eptp) || ((new_eptp >> 7) & 0x1f)))
+	if (CC(!kvm_vcpu_is_legal_gpa(vcpu, new_eptp) || ((new_eptp >> 7) & 0x1f)))
 		return false;
 
 	/* AD, if set, should be supported */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..6eba8c08eff6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5782,7 +5782,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * would also use advanced VM-exit information for EPT violations to
 	 * reconstruct the page fault error code.
 	 */
-	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
+	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
-- 
2.25.1

