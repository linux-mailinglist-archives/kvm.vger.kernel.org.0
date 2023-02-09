Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3A68FD3D
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjBIClz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBIClS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:18 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E929E03
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910477; x=1707446477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=23Yc7wtEsH00jGhqwHNQ2CiHr1HEYheSIWTKz0e3nlY=;
  b=OBUXslj09ZYbfUnYEaufMU7PXad7cdC7T8EB0nHvNAo5Gs+nxGo6BP6p
   7c06A+u9/LxhTDHsO5cnW5yN+dyOzV1dooVNPEDbXm+06hkpvLOxs3hLa
   KfIvIRAOg5+ydUd0DEulFAjL7hD9BiFmMXF6+a8xaY4pr4NSF5YqQgLFV
   vLsaMv6ByWT62akS4T6Ch//Gondxzm30bkejZV3rhmzfst0gn/jNTHtGG
   m7vqbAeu36y62D5Yv56l7UNOG/9/t9hXQLO2g8bTdFtCmrnlnGXzq2+YI
   2GH8wGNcY7OXpFrge8vI4JA099U1WoEDg33MIwdMJFcdfqOfPxzUPdPz5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586673"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586673"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094450"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094450"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:14 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 7/9] KVM: x86: When guest set CR3, handle LAM bits semantics
Date:   Thu,  9 Feb 2023 10:40:20 +0800
Message-Id: <20230209024022.3371768-8-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
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

When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
will build new CR3 with LAM bits updates.
When changes on CR3's effective address bits, no matter LAM bits changes or not,
go through normal pgd update process.

Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3218f465ae71..7df6c9dd12a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1242,9 +1242,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
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
@@ -1257,6 +1257,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
 		goto handle_tlb_flush;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
+	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
+		return	1;
+
 	/*
 	 * Do not condition the GPA check on long mode, this helper is used to
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
@@ -1268,8 +1272,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
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

