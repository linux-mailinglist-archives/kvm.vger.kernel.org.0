Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2E7598B1
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjGSOmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjGSOly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:41:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654B1711;
        Wed, 19 Jul 2023 07:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777710; x=1721313710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KEiFv9rHqDDTUcEB4undqVNq+pEX+/iESrmouGuKjcQ=;
  b=gwFmcMfb3ySCvgbijYObHmMLUX8gl/7h5/V/RgH5zm2bsfJ1o/c90rS8
   Pd03SS/yL3Slr6oJ1TkWAIm4MdTHbRdWtDJdF+QDCxZUOIPD4Kp7y7emm
   e8YZXs8e7DrjRqJjNyGfZdHREv520/s8ZTewEeYVAHJXeKoBL0XfqXQ+G
   Lsk04lIEp/H6Bvf0PKBOHlU1qxdB9BrD6tgrLuu0aJtCt+ZJCX9IsWyh+
   RQbPMqC8X8ZwijqSuPxgSpW6ekumCYo9uRZ4sU/glJcVmLZH7U6fLD48g
   6ObS/VDAM4YnLWK1r0pSr8+HVDA4HzjDxsnMeo1T6Zqev6akl9/yFIsj/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788174"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788174"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503292"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:48 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 5/9] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Date:   Wed, 19 Jul 2023 22:41:27 +0800
Message-Id: <20230719144131.29052-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to allow guests to set two new CR3 non-address control bits for
guests to enable the new Intel CPU feature Linear Address Masking (LAM) on user
pointers.

LAM modifies the checking that is applied to 64-bit linear addresses, allowing
software to use of the untranslated address bits for metadata and masks the
metadata bits before using them as linear addresses to access memory. LAM uses
two new CR3 non-address bits LAM_U48 (bit 62) and AM_U57 (bit 61) to configure
LAM for user pointers. LAM also changes VMENTER to allow both bits to be set in
VMCS's HOST_CR3 and GUEST_CR3 for virtualization.

When EPT is on, CR3 is not trapped by KVM and it's up to the guest to set any of
the two LAM control bits. However, when EPT is off, the actual CR3 used by the
guest is generated from the shadow MMU root which is different from the CR3 that
is *set* by the guest, and KVM needs to manually apply any active control bits
to VMCS's GUEST_CR3 based on the cached CR3 *seen* by the guest.

KVM manually checks guest's CR3 to make sure it points to a valid guest physical
address (i.e. to support smaller MAXPHYSADDR in the guest). Extend this check
to allow the two LAM control bits to be set. After check, LAM bits of guest CR3
will be stripped off to extract guest physical address.

In case of nested, for a guest which supports LAM, both VMCS12's HOST_CR3 and
GUEST_CR3 are allowed to have the new LAM control bits set, i.e. when L0 enters
L1 to emulate a VMEXIT from L2 to L1 or when L0 enters L2 directly. KVM also
manually checks VMCS12's HOST_CR3 and GUEST_CR3 being valid physical address.
Extend such check to allow the new LAM control bits too.

Note, LAM doesn't have a global control bit to turn on/off LAM completely, but
purely depends on hardware's CPUID to determine it can be enabled or not. That
means, when EPT is on, even when KVM doesn't expose LAM to guest, the guest can
still set LAM control bits in CR3 w/o causing problem. This is an unfortunate
virtualization hole. KVM could choose to intercept CR3 in this case and inject
fault but this would hurt performance when running a normal VM w/o LAM support.
This is undesirable. Just choose to let the guest do such illegal thing as the
worst case is guest being killed when KVM eventually find out such illegal
behaviour and that is the guest to blame.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/cpuid.h   | 3 +++
 arch/x86/kvm/mmu.h     | 8 ++++++++
 arch/x86/kvm/mmu/mmu.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8b26d946f3e3..274f41d2250b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -285,6 +285,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
 
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	if (guest_can_use(vcpu, X86_FEATURE_LAM))
+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+
 	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
 }
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..e92395e6b876 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -144,6 +144,14 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline unsigned long kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
+{
+	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
+		return 0;
+
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..0285536346c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3819,7 +3819,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 
 	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
-	root_gfn = root_pgd >> PAGE_SHIFT;
+	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0d6ea87a2d0..bcee5dc3dd0b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3358,7 +3358,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+		            kvm_get_active_cr3_lam_bits(vcpu);
 	}
 
 	if (update_guest_cr3)
-- 
2.25.1

