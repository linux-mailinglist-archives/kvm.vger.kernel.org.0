Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F35647D01
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLIEqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLIEqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA73B6591
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561168; x=1702097168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PtbatE5TlDJbQkm27ycDn3h5a8WrR0zrBrk/IVZSriA=;
  b=Wu7UBv96brNKh53wpmui0KMelxw1jkaybo1w7ph+/3xmRQWMw3yVZxaL
   pvocTu9fsdqUYXvfdQbpOPRO5NfjcuSneqK4RVdY8riUBPNqYXQXZkxFP
   1vr0RGHhoTCcacY0LTO5UKrWW/uWNxQc0U3G8udTPCDvgETg4OkP4+1D+
   Lj5ZMVU6mmvJq/lotSg2mbk5mcgDjegInQq2G6pYlhXm3ya/7JdZZ2GRX
   P1AYPoOlV7eDV4ygf1bGHbJ5avAmpK8JK+DfROvJHJ1kvXxPUgq9zbp++
   MUBzagFxXOTQGIkqGOV9Drl1mE61Vk9K2b9ybkp5Ff+LrP/oB/slR9U+9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530827"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530827"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524432"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524432"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:06 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
Date:   Fri,  9 Dec 2022 12:45:50 +0800
Message-Id: <20221209044557.1496580-3-robert.hu@linux.intel.com>
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

If LAM enabled, CR4.LAM_SUP is owned by guest; otherwise, reserved.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/kvm_cache_regs.h   | 3 ++-
 arch/x86/kvm/x86.h              | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3c736e00b6b1..275a6b2337b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -120,7 +120,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_LAM_SUP))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3febc342360c..917f1b770839 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,8 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
+	 | X86_CR4_LAM_SUP)
 
 #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
 #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d92e580768e5..6c1fbe27616f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -474,6 +474,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
+		__reserved_bits |= X86_CR4_LAM_SUP;	\
 	__reserved_bits;                                \
 })
 
-- 
2.31.1

