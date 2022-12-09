Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC32647D05
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLIEqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLIEqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A85D7B559
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561175; x=1702097175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cKC8IXINwJ1ilcy4Kpzn6vcJdJOyTypmtAbBOvdtsO8=;
  b=OpAwftaPJgxD059/OVZxR0mRdQYz577lnzkfwOT2EEj9uQam3toS/jaY
   CpL9FjfJYznEYJiRRfJEqLKFoN310YEfKSB8CeKfPRnCCrskfnN8Nrwo5
   Q0cfjOfm0to4gPmeIQmG67WSrCBGseiNKtXO7NzkNFf8ZWCHFUQajhCjd
   BZa/YZ9tOrxn0OMnj8QDpnReFrNs6sVvhf5VNHhNgP2hnUwXiR9dwz7mu
   yRD4w/58cnjIOmnrANbCRhygwJTK5awLRhJsMqKaGzIP2DQx1s1QUzsTL
   eN1+7773Yiuj/6/0vXZGk6mVVLqYo15jTIWDfM0sSKfVEyOsCHmEO30LD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530861"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530861"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524463"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524463"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:13 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Date:   Fri,  9 Dec 2022 12:45:54 +0800
Message-Id: <20221209044557.1496580-7-robert.hu@linux.intel.com>
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

Define kvm_untagged_addr() per LAM feature spec: Address high bits are sign
extended, from highest effective address bit.
Note that LAM_U48 and LA57 has some effective bits overlap. This patch
gives a WARN() on that case.

Now the only applicable possible case that addresses passed down from VM
with LAM bits is those for MPX MSRs.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c |  3 +++
 arch/x86/kvm/x86.c     |  5 +++++
 arch/x86/kvm/x86.h     | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9985dbb63e7b..16ddd3fcd3cb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (!msr_info->host_initiated &&
 		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
+
+		data = kvm_untagged_addr(data, vcpu);
+
 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb1f2c20e19e..0a446b45e3d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1812,6 +1812,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
+		/*
+		 * LAM applies only addresses used for data accesses.
+		 * Tagged address should never reach here.
+		 * Strict canonical check still applies here.
+		 */
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6c1fbe27616f..f5a2a15783c6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -195,11 +195,48 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
+static inline u64 get_canonical(u64 la, u8 vaddr_bits)
+{
+	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+}
+
 static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 {
 	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
 }
 
+#ifdef CONFIG_X86_64
+/* untag addr for guest, according to vCPU CR3 and CR4 settings */
+static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
+{
+	if (addr >> 63 == 0) {
+		/* User pointers */
+		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
+			addr = get_canonical(addr, 57);
+		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
+			/*
+			 * If guest enabled 5-level paging and LAM_U48,
+			 * bit 47 should be 0, bit 48:56 contains meta data
+			 * although bit 47:56 are valid 5-level address
+			 * bits.
+			 * If LAM_U48 and 4-level paging, bit47 is 0.
+			 */
+			WARN_ON(addr & _BITUL(47));
+			addr = get_canonical(addr, 48);
+		}
+	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
+		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
+			addr = get_canonical(addr, 57);
+		else
+			addr = get_canonical(addr, 48);
+	}
+
+	return addr;
+}
+#else
+#define kvm_untagged_addr(addr, vcpu)	(addr)
+#endif
+
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-- 
2.31.1

