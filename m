Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08879ED67
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjIMPkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjIMPkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9974526B7;
        Wed, 13 Sep 2023 08:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619609; x=1726155609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p6l7122MK9yxRk3UJK/JXAHUlvxeoFHxVBOhOu6KrlI=;
  b=fK1xXTeMMTptkCW6zg+txXq/rd8NPMHvRDp/5F4kdf0nUy3jTNcSgZRS
   cnJNzCrRpaFHJ0c8BJ/zvQCIFPX1TkWTyqyPLaFoR5htvva8bQr5Ja29H
   pcTQL7f+n2nL9sQW4T5J5mxDtCuaceqDQN1GV96m3N/bTNLCUeYY4ePIp
   OwFaxQx/FqkH21+Uddk0okSEwyrn0X+2dB+FAsuC5n+plLF5kgTM0JzwC
   r8ecOVzxiClZ1s+kIW08/uMWqL8/cCny2yiLpeRJHJd8wE60iIogh2B32
   B5TjKbEDntLaJ+kZnkLv6HbQNs/Fxq1Aeep8JK0XrbLSfw7vTHKTlfUbB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030247"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030247"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852205"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852205"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:06 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 10/16] KVM: x86: Virtualize LAM for supervisor pointer
Date:   Wed, 13 Sep 2023 20:42:21 +0800
Message-Id: <20230913124227.12574-11-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add support to allow guests to set the new CR4 control bit for LAM and add
implementation to get untagged address for supervisor pointers.

LAM modifies the canonicality check applied to 64-bit linear addresses for
data accesses, allowing software to use of the untranslated address bits for
metadata and masks the metadata bits before using them as linear addresses
to access memory. LAM uses CR4.LAM_SUP (bit 28) to configure and enable LAM
for supervisor pointers. It also changes VMENTER to allow the bit to be set
in VMCS's HOST_CR4 and GUEST_CR4 to support virtualization. Note CR4.LAM_SUP
is allowed to be set even not in 64-bit mode, but it will not take effect
since LAM only applies to 64-bit linear addresses.

Move CR4.LAM_SUP out of CR4_RESERVED_BITS, its reservation depends on vcpu
supporting LAM or not. Leave it intercepted to prevent guest from setting
the bit if LAM is not exposed to guest as well as to avoid vmread every time
when KVM fetches its value, with the expectation that guest won't toggle the
bit frequently.

Set CR4.LAM_SUP bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests to
allow guests to enable LAM for supervisor pointers in nested VMX operation.

Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, KVM doesn't
need to emulate TLB flush based on it.
There's no other features/vmx_exec_controls connection, no other code needed
in {kvm,vmx}_set_cr4().

Skip address untag for instruction fetch, branch target and operand of INVLPG,
which LAM doesn't apply to.  Skip address untag for implicit system accesses
since LAM doesn't apply to the loading of base addresses of memory management
registers and segment registers, their values still need to be canonical (for
now, get_untagged_addr() interface is not called for implicit system accesses,
just for future proof).

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/vmx/vmx.c          | 40 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h              |  2 ++
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 08e94f30d376..d4e3657b840a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,7 +125,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_LAM_SUP))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b572cfe27342..ee35a91aa584 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7677,6 +7677,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+
 #undef cr4_fixed1_update
 }
 
@@ -8209,9 +8212,44 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+/*
+ * Note, the SDM states that the linear address is masked *after* the modified
+ * canonicality check, whereas KVM masks (untags) the address and then performs
+ * a "normal" canonicality check.  Functionally, the two methods are identical,
+ * and when the masking occurs relative to the canonicality check isn't visible
+ * to software, i.e. KVM's behavior doesn't violate the SDM.
+ */
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
 {
-	return gva;
+	int lam_bit;
+
+	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH | X86EMUL_F_IMPLICIT |
+	             X86EMUL_F_INVLPG))
+		return gva;
+
+	if (!is_64_bit_mode(vcpu))
+		return gva;
+
+	/*
+	 * Bit 63 determines if the address should be treated as user address
+	 * or a supervisor address.
+	 */
+	if (!(gva & BIT_ULL(63))) {
+		/* KVM doesn't yet virtualize LAM_U{48,57}. */
+		return gva;
+	} else {
+		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP))
+			return gva;
+
+		lam_bit = kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 56 : 47;
+	}
+
+	/*
+	 * Untag the address by sign-extending the lam_bit, but NOT to bit 63.
+	 * Bit 63 is retained from the raw virtual address so that untagging
+	 * doesn't change a user access to a supervisor access, and vice versa.
+	 */
+	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..53e883721e71 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -529,6 +529,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
+		__reserved_bits |= X86_CR4_LAM_SUP;     \
 	__reserved_bits;                                \
 })
 
-- 
2.25.1

