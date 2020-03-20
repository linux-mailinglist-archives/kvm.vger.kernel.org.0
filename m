Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37718DA55
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgCTV2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:48429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgCTV2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:51 -0400
IronPort-SDR: JQuG/ElzuO2EPHbOFDu6FnMZ9HxVR1eSjdoOCcvt7IQr7twyz9B0pzaolsMirxQXZPQbh9c5Ja
 Qt1jdzb2PhTg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:45 -0700
IronPort-SDR: 72X7pdlMpSoI9nSyIFcS6fqfL4dgVBE08NbX3XJlqooJGUZNM2XIy9X/JfQoUh1Uu7RbGytBfB
 IJk3l2Wnbv+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224415"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:45 -0700
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
Subject: [PATCH v3 06/37] KVM: x86: Consolidate logic for injecting page faults to L1
Date:   Fri, 20 Mar 2020 14:28:02 -0700
Message-Id: <20200320212833.3507-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the MMU's inject_page_fault(), which is used to inject page faults
encountered when walking L1's page tables, to x86.c and use it to handle
the non-nested path of kvm_inject_emulated_page_fault().  Using a common
helper will reduce duplicate code in a future patch to sync SPTEs on
emulated page faults, and also eliminates the rather confusing function
name "inject_page_fault", which collides with struct kvm_mmu's hook.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu/mmu.c          | 6 ------
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 arch/x86/kvm/x86.c              | 8 +++++++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 328b1765ff76..cdbf822c5c8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1447,6 +1447,8 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
+void kvm_inject_l1_page_fault(struct kvm_vcpu *vcpu,
+			      struct x86_exception *fault);
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 560e85ebdf22..5ae620881bbc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4357,12 +4357,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 	return kvm_read_cr3(vcpu);
 }
 
-static void inject_page_fault(struct kvm_vcpu *vcpu,
-			      struct x86_exception *fault)
-{
-	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
-}
-
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access, int *nr_present)
 {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1ddbfff64ccc..ac613f2fae01 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -812,7 +812,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
 		if (!prefault)
-			inject_page_fault(vcpu, &walker.fault);
+			kvm_inject_l1_page_fault(vcpu, &walker.fault);
 
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64ed6e6e2b56..fcad522f221e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -611,6 +611,12 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
+void kvm_inject_l1_page_fault(struct kvm_vcpu *vcpu,
+			      struct x86_exception *fault)
+{
+	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
+}
+
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
@@ -619,7 +625,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
 	else
-		vcpu->arch.mmu->inject_page_fault(vcpu, fault);
+		kvm_inject_l1_page_fault(vcpu, fault);
 
 	return fault->nested_page_fault;
 }
-- 
2.24.1

