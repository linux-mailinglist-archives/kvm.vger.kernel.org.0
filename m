Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A482560073F
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJQHFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiJQHFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1689122B1C
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990344; x=1697526344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Zz77OkhNZKF8tBU8sPdCcTsGxcasRZTz3tmsxf8znk=;
  b=Y3PyokIIJYhhK3Ab4ONsdkwjraGHdbe3kw/F4rg79otN3PBY/msDETfo
   5T8q8pnZTcnC/jF+995tGz+3tsBzT8yo+w7Pqzs+wZnAIFhvjCF6B+1bX
   FvkH0nCCyu9nlY3JLQ2WBAkWecmI7sgrZqvf4JNeXGWnH6X+apGH2SZSM
   uRD7P03Wh7JpRGGRJwdCu3lkqkVIBM2DRW3KJFwzW/V6uY5wyNPqBWFeF
   Qu4c2gIovEyZ0NAJujkzaKS3lehifGIH0+/tMaUbKZbGJsgSpmwKxmGYn
   how50YWHMqYUGRlHy7Y1CRe8GzXmv8aUcLkJwn59qFqygrYtmjWsQ3wYj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="392031203"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="392031203"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271413"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271413"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:24 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH 7/9] KVM: x86: When judging setting CR3 valid or not, consider LAM bits
Date:   Mon, 17 Oct 2022 15:04:48 +0800
Message-Id: <20221017070450.23031-8-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017070450.23031-1-robert.hu@linux.intel.com>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 3fa532cd1911..e9b465bff8d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1217,6 +1217,14 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
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
@@ -1240,7 +1248,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_is_valid_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
-- 
2.31.1

