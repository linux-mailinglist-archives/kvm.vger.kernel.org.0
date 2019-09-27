Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8777AC0D95
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfI0VqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:46:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:45951 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbfI0VpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852057"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 1/8] KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
Date:   Fri, 27 Sep 2019 14:45:16 -0700
Message-Id: <20190927214523.3376-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested VM-Enter
instead of deferring the VMWRITE until vmx_set_cr3().  If the VMWRITE
is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the emulated
VM-Exit occurs without actually entering L2, e.g. if the nested run
is squashed because nested VM-Enter (from L1) is putting L2 into HLT.

Note, the above scenario can occur regardless of whether L1 is
intercepting HLT, e.g. L1 can intercept HLT and then re-enter L2 with
vmcs.GUEST_ACTIVITY_STATE=HALTED.  But practically speaking, a VMM will
likely put a guest into HALTED if and only if it's not intercepting HLT.

In an ideal world where EPT *requires* unrestricted guest (and vice
versa), VMX could handle CR3 similar to how it handles RSP and RIP,
e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  But
the unrestricted guest silliness complicates the dirty tracking logic
to the point that explicitly handling vmcs02.GUEST_CR3 during nested
VM-Enter is a simpler overall implementation.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Reto Buerki <reet@codelabs.ch>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c    | 10 +++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41abc62c9a8a..b72a00b53e4a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2418,6 +2418,16 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 				entry_failure_code))
 		return -EINVAL;
 
+	/*
+	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
+	 * on nested VM-Exit, which can occur without actually running L2 and
+	 * thus without hitting vmx_set_cr3(), e.g. if L1 is entering L2 with
+	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept the
+	 * transition to HLT instead of running L2.
+	 */
+	if (enable_ept)
+		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
+
 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
 	    is_pae_paging(vcpu)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4575ffb3cec..7679c2a05a50 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2984,6 +2984,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
 void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	struct kvm *kvm = vcpu->kvm;
+	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
 
@@ -3000,15 +3001,18 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
-		if (enable_unrestricted_guest || is_paging(vcpu) ||
-		    is_guest_mode(vcpu))
+		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
+		if (is_guest_mode(vcpu))
+			update_guest_cr3 = false;
+		else if (enable_unrestricted_guest || is_paging(vcpu))
 			guest_cr3 = kvm_read_cr3(vcpu);
 		else
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		ept_load_pdptrs(vcpu);
 	}
 
-	vmcs_writel(GUEST_CR3, guest_cr3);
+	if (update_guest_cr3)
+		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-- 
2.22.0

