Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6CB18DA26
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgCTV3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:37248 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgCTV3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:29:00 -0400
IronPort-SDR: WMZlB4YdnvF3TfxTwJyi7aMY5UV0qkABwkKb412w+dWrnK8vtGJGC7S4Gk9yk4Zzex9KNPRbYF
 lMA89y5ycpeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:59 -0700
IronPort-SDR: /1oWUYtsLwZuN0ce5+LqHg2F5Sbv0xKWpsRQ/h18+JNu9jBdCOiSgfnhy9kIJJDV7HZ7qlLnss
 tya41tqf0HLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224523"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 33/37] KVM: nVMX: Skip MMU sync on nested VMX transition when possible
Date:   Fri, 20 Mar 2020 14:28:29 -0700
Message-Id: <20200320212833.3507-34-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the MMU sync when reusing a cached root if EPT is enabled or L1
enabled VPID for L2.

If EPT is enabled, guest-physical mappings aren't flushed even if VPID
is disabled, i.e. L1 can't expect stale TLB entries to be flushed if it
has enabled EPT and L0 isn't shadowing PTEs (for L1 or L2) if L1 has
EPT disabled.

If VPID is enabled (and EPT is disabled), then L1 can't expect stale TLB
entries to be flushed (for itself or L2).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c    |  2 +-
 arch/x86/kvm/vmx/nested.c | 44 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6a986b66c867..84e1e748c2b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5038,7 +5038,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false, false);
+	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false, true);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dd58563ee793..db3ce8f297c2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1095,6 +1095,44 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	return (val & invalid_mask) == 0;
 }
 
+/*
+ * Returns true if the MMU needs to be sync'd on nested VM-Enter/VM-Exit.  The
+ * MMU needs to be sync if L0 is using shadow paging (EPT disabled) and L1
+ * didn't enable VPID for L2, i.e. L1 expects a TLB flush on VMX transitions.
+ *
+ * If EPT is enabled by L0 but disabled by L1, then L0 is not shadowing L1 or
+ * L2 PTEs, there cannot be unsync'd SPTEs for either L1 or L2.
+ *
+ * If EPT is enabled by L1 (and therefore L0), then L0 doesn't need to sync on
+ * VM-Enter as VM-Enter isn't required to invalidate guest-physical mappings
+ * (irrespective of VPID), i.e. L1 can't rely on the (virtual) CPU to flush
+ * stale GPA->HPA translations for L2 from the TLB.  And as above, L0 isn't
+ * shadowing L1 PTEs so there are no unsync'd SPTEs to sync on VM-Exit.
+ *
+ * If VPID is enabled by L1 (for L2), then L0 doesn't need to sync as VM-Enter
+ * and VM-Exit aren't required to invaliate linear mappings (EPT is disabled so
+ * there are no combined or guest-physical mappings), i.e. L1 can't rely on the
+ * (virtual) CPU to flush stale VA->PA mappings for either L2 or itself (L1).
+ *
+ * If EPT is disabled (by L0 and therefore L1) and VPID is disabled by L1, then
+ * a sync is needed as L1 expects all VA->PA mappings to be flushed on both
+ * VM-Enter and VM-Exit.
+ *
+ * Note, this logic is subtly different than nested_has_guest_tlb_tag(), which
+ * additionally checks that L2 has been assigned a VPID (when EPT is disabled).
+ * Whether or not L2 has been assigned a VPID by L0 is irrelevant with respect
+ * to L1's expectations, e.g. L0 needs to invalidate hardware TLB entries if L2
+ * doesn't have a unique VPID to prevent reusing L1's entries (assuming L1 has
+ * been assigned a VPID), but L0 doesn't need to do a MMU sync because L1
+ * doesn't expect stale (virtual) TLB entries to be flushed, i.e. L1 doesn't
+ * know that L0 will flush the TLB and so L1 will do INVVPID as needed to flush
+ * stale TLB entries, at which point L0 will sync L2's MMU.
+ */
+static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
+{
+	return !enable_ept && !nested_cpu_has_vpid(get_vmcs12(vcpu));
+}
+
 /*
  * Load guest's/host's cr3 at nested entry/exit.  @nested_ept is true if we are
  * emulating VM-Entry into a guest with EPT enabled.  On failure, the expected
@@ -1122,8 +1160,12 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		}
 	}
 
+	/*
+	 * See nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
+	 */
 	if (!nested_ept)
-		kvm_mmu_new_cr3(vcpu, cr3, false, false);
+		kvm_mmu_new_cr3(vcpu, cr3, false,
+				!nested_vmx_transition_mmu_sync(vcpu));
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-- 
2.24.1

