Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FA460073E
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiJQHFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJQHFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F845982
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990342; x=1697526342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e56Kd/zuQTaQ0xl1PtcJww/ZVN+6cSPiBumJ7fLIzTg=;
  b=Dfb94HT6mdfZG5+KBeCZaaZiGKXIfbwz619nWPa++qLSeu3+mXdQEeWj
   y8wf2jHeIYRVAW+mEI9j3UVvJlm1uKi1JTWOo7YZbkw0JdXD5unOHWgAf
   eOmpZYbUKKssRdwd6NjUFoKgXc+4AzdZ/ADCck6R3MnlNYF/oZf1StMpV
   Anqo2Fwul93HxYb16dzW9hYCgTi0OWepC0axpZg3hH8pY3Uoj7tIVUS0N
   4iu2Y4HVTvwjkCUHqVrGBT3aTNGzvYIBYvzfWF/IbKJFeCZo7rZTikZB3
   67qFFNHrxfFaQiooGZeswhbp1+8WXoBvkxtI5w6rppEfZ0Wnxn1tCK+mf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="392031202"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="392031202"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271401"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271401"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:22 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH 6/9] KVM: x86: Untag LAM bits when applicable
Date:   Mon, 17 Oct 2022 15:04:47 +0800
Message-Id: <20221017070450.23031-7-robert.hu@linux.intel.com>
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
index ffb82daee1d3..76c9f4b8b340 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2116,6 +2116,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 05a40ab7cda2..3fa532cd1911 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1780,6 +1780,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
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
index c55d9e517d01..f01a2ed9d3c0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -187,11 +187,48 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
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

