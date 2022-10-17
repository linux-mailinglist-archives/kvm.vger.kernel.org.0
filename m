Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E061600740
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiJQHFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJQHFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E9F4DF3B
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990344; x=1697526344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ifg6/sc+fwSQXD/jV2lw/ufITayAG1Yn/Gno+7xKRw=;
  b=UfsWQJo2KuCNr1EtNbJB1Hk0rvJrS8ZUyTlMKOMVBLIOVdsN/RhphMVQ
   AN0WdG1doSxKEyIuL/oM6efug917cZw6V1/mXcaG4xuLF2bvw4CXGwjgu
   wwMf3d46ceVzyp7BOnETn9kyB7if8EdMQZoqVNB/2gSz6yt2yVZhiwfS3
   h++phhL8YH9ZOsW9qXlxcjsNEdxIbm25dGjsVqS819HYFiD6KaQNrh07U
   Lb3LSEWzQnXZHlwWMf7MQi+9U8PWS+8m7peaf/0Mjp8rBNlSWw6MfvSYW
   z59p3a/hfLLuJzfbDY1Z91U/bXXqV3gldgjCuj6QslW6Fqh/W3rDEQMzA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="392031205"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="392031205"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271416"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271416"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:26 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits semantics
Date:   Mon, 17 Oct 2022 15:04:49 +0800
Message-Id: <20221017070450.23031-9-robert.hu@linux.intel.com>
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

When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
will build new CR3 with LAM bits updates. No TLB flush needed on this case.
When changes on effective addresses, no matter LAM bits changes or not, go
through normal pgd update process.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9b465bff8d3..fb779f88ae88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1228,9 +1228,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
-	unsigned long pcid = 0;
+	unsigned long pcid = 0, old_cr3;
 #ifdef CONFIG_X86_64
-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
@@ -1243,6 +1243,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
 		goto handle_tlb_flush;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
+	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
+		return	1;
+
 	/*
 	 * Do not condition the GPA check on long mode, this helper is used to
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
@@ -1254,8 +1258,22 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
 		return 1;
 
-	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3);
+	old_cr3 = kvm_read_cr3(vcpu);
+	if (cr3 != old_cr3) {
+		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
+			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
+					X86_CR3_LAM_U57));
+		} else {
+			/* Only LAM conf changes, no tlb flush needed */
+			skip_tlb_flush = true;
+			/*
+			 * Though effective addr no change, mark the
+			 * request so that LAM bits will take effect
+			 * when enter guest.
+			 */
+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+		}
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
-- 
2.31.1

