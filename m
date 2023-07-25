Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8485762612
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjGYWSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjGYWQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE1935BD;
        Tue, 25 Jul 2023 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323355; x=1721859355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CoQnqLun9XBJdTIBa8S7YePe8TwiMfxkj+IV5w5Hkm4=;
  b=VvjjkI4yYQQWEGtLjOcINVEiRtKRQGIxMYFIaR/3vvfe+LG4Emd0Rj0Q
   xSqa/DLHyemMFEnZ8jY33BViMXjlAwOowHa1a50pM8MFEw62Yr68SbeZq
   T5iSozfutT5tFNac/0JBMM7EJHki7QDWiyzCALO7NdawlBw6Z6kfbfVyJ
   amN+x4kbZtRUIGwJCoKDwzB5/Ktad2UROonb4OyNvigoVoh42bridXFPe
   2/M9NFPmNFMPghXu+p4NmuvkBWRx94sjiVZ3h3TmoVfs+U8Cr/omw4rgM
   ufSlGHfhiRO3/2jMtXZpLIdubZb8BgISx1o5MtC4yrwBAVNY2PUpfZiYU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863217"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863217"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938892"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938892"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v15 033/115] KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
Date:   Tue, 25 Jul 2023 15:13:44 -0700
Message-Id: <6369eb0081da9d9b3b6b71a0a1b5ece669586785.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
is not able to access the private memory of TD guest and do the emulation.
Instead, TD guest expects to receive #VE when it accesses the MMIO and then
it can explicitly make hypercall to KVM to get the expected information.

To achieve this, the TDX module always enables "EPT-violation #VE" in the
VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
the #VE instead of EPT misconfigration unlike VMX case.  For the shared GPA
that is not populated yet, EPT violation need to be triggered when TD guest
accesses such shared GPA.  The non-present SPTE value for shared GPA should
set "suppress #VE" bit.

Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
present bit is off; 2) for normal VMX guest, KVM never enables the
"EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
hardware.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a99eb7d4ae5d..a57667810344 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -148,7 +148,20 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+/*
+ * Non-present SPTE value for both VMX and SVM for TDP MMU.
+ * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
+ * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
+ *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
+ * For TDX:
+ *   TDX module sets EPT_VIOLATION_VE for Secure-EPT and conventional EPT
+ */
+#ifdef CONFIG_X86_64
+#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
+static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
+#else
 #define SHADOW_NONPRESENT_VALUE	0ULL
+#endif
 
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
@@ -195,7 +208,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE	0x5a0ULL
+#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
-- 
2.25.1

