Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693481878DA
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgCQExM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgCQExL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:11 -0400
IronPort-SDR: KNuHTwO4vLm5jl6GXt+dIoqJK3bDU8xvHMXjEHyULPdBreNSXhh11HvyulUS0s0Om7/1/PxMXj
 HZpbtmJKuHaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:11 -0700
IronPort-SDR: ECYl6RZ3ePBvj0NEcp3pQ1asOj/7yUM1ka/xZYqmGMmjWz9ieIdfcwB8Ti1WmiuoHoBdvg1u4V
 5CS48Qf+QALw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252748"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:10 -0700
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
Subject: [PATCH v2 05/32] KVM: x86: Export kvm_propagate_fault() (as kvm_inject_emulated_page_fault)
Date:   Mon, 16 Mar 2020 21:52:11 -0700
Message-Id: <20200317045238.30434-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export the page fault propagation helper so that VMX can use it to
correctly emulate TLB invalidation on page faults in an upcoming patch.

In the (hopefully) not-too-distant future, SGX virtualization will also
want access to the helper for injecting page faults to the correct level
(L1 vs. L2) when emulating ENCLS instructions.

Rename the function to kvm_inject_emulated_page_fault() to clarify that
it is (a) injecting a fault and (b) only for page faults.  WARN if it's
invoked with an exception other than PF_VECTOR.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9a183e9d4cb1..328b1765ff76 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1447,6 +1447,8 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
+bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				    struct x86_exception *fault);
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 access);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e54c6ad628a8..64ed6e6e2b56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -611,8 +611,11 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
-static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				    struct x86_exception *fault)
 {
+	WARN_ON_ONCE(fault->vector != PF_VECTOR);
+
 	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
 	else
@@ -620,6 +623,7 @@ static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fau
 
 	return fault->nested_page_fault;
 }
+EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
@@ -6373,7 +6377,7 @@ static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	if (ctxt->exception.vector == PF_VECTOR)
-		return kvm_propagate_fault(vcpu, &ctxt->exception);
+		return kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
 
 	if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
-- 
2.24.1

