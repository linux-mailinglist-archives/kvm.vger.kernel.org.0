Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE35647D06
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLIEqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLIEqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD1E7B571
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561177; x=1702097177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8u4BXpnTVqMlHKPtiXBh9V+mtk3HxnkAKkRjdiyc09Q=;
  b=mKDZUfQdVGaA3f271TOcfkMrguXAdY5KER6jvc7jua+SixQtOSOPSk/H
   SpxwfCg/dLCp9iDRaSY/SCK+bUenbMiItswbpzRUStObUJGd4yET8P33X
   fivoh8PHcdQr5o7N+edXrsP/n3RWVbnsznwf7+1XeOzGA6tO87N3Kwl1D
   noKjk5+1TLibHoA389BH+xZ3SiYyWpvLkXX7z8gepmTs8daM2Jh5PZ09n
   Ndmak72lSt45hj+Vxq2EtsYSP8ykldEgDbQHCvOU0i1mCMJJaW4khHAwy
   opCnm8dznrvhsXsuRTzQYDiLvvowDGJlPj8/SUJJQA1f//msgFBdEvevS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530864"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530864"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524469"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524469"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:15 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3 7/9] KVM: x86: When judging setting CR3 valid or not, consider LAM bits
Date:   Fri,  9 Dec 2022 12:45:55 +0800
Message-Id: <20221209044557.1496580-8-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before apply to kvm_vcpu_is_illegal_gpa(), clear LAM bits if it's valid.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/x86.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a446b45e3d6..48a2ad1e4cd6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1237,6 +1237,14 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
 }
 
+static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+
+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
+}
+
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
@@ -1260,7 +1268,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_is_valid_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
-- 
2.31.1

