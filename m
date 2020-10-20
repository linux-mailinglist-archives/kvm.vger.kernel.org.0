Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E564B2944C4
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438825AbgJTV4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:61050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438807AbgJTV4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:15 -0400
IronPort-SDR: DgidWhlLCBLF7+k4p74s2OuFdrhjW+Fjzs2QHeYgewr7HTDRoxPsgoP3ujbuYcy4Wy9aXHLhvl
 PqfSfoQdNLaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576323"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576323"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:15 -0700
IronPort-SDR: cOUZ6k3xd/1OjjHJci/Y239nTI5oJaJQAJtOg4YdcQ8HxkLyBG5dpNAkcRKdqlPn7A/hDxiCts
 LKO/gnnJGhRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827717"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/10] KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
Date:   Tue, 20 Oct 2020 14:56:04 -0700
Message-Id: <20201020215613.8972-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly track the EPTP that is common to all vCPUs instead of
grabbing vCPU0's EPTP when invoking Hyper-V's paravirt TLB flush.
Tracking the EPTP will allow optimizing the checks when loading a new
EPTP and will also allow dropping ept_pointer_match, e.g. by marking
the common EPTP as invalid.

This also technically fixes a bug where KVM could theoretically flush an
invalid GPA if all vCPUs have an invalid root.  In practice, it's likely
impossible to trigger a remote TLB flush in such a scenario.  In any
case, the superfluous flush is completely benign.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++-----------
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcc097bb8321..6d53bcc4a1a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -486,6 +486,7 @@ static void check_ept_pointer_match(struct kvm *kvm)
 		}
 	}
 
+	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
 	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
 }
 
@@ -498,21 +499,18 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 			range->pages);
 }
 
-static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
+static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
 {
-	u64 ept_pointer = to_vmx(vcpu)->ept_pointer;
-
 	/*
 	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
 	 * of the base of EPT PML4 table, strip off EPT configuration
 	 * information.
 	 */
 	if (range)
-		return hyperv_flush_guest_mapping_range(ept_pointer & PAGE_MASK,
+		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
 				kvm_fill_hv_flush_list_func, (void *)range);
 	else
-		return hyperv_flush_guest_mapping(ept_pointer & PAGE_MASK);
+		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -530,12 +528,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			/* If ept_pointer is invalid pointer, bypass flush request. */
 			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= __hv_remote_flush_tlb_with_range(
-					kvm, vcpu, range);
+				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
+							    range);
 		}
-	} else {
-		ret = __hv_remote_flush_tlb_with_range(kvm,
-				kvm_get_vcpu(kvm, 0), range);
+	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
+		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);
 	}
 
 	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 5961cb897125..3d557a065c01 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -301,6 +301,7 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+	hpa_t hv_tlb_eptp;
 	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
 };
-- 
2.28.0

