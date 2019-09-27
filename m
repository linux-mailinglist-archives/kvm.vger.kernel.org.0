Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38542C0D89
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfI0Vp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:45953 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfI0Vp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852066"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:25 -0700
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
Subject: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
Date:   Fri, 27 Sep 2019 14:45:19 -0700
Message-Id: <20190927214523.3376-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework vmx_set_rflags() to avoid the extra code need to handle emulation
of real mode and invalid state when unrestricted guest is disabled.  The
primary reason for doing so is to avoid the call to vmx_get_rflags(),
which will incur a VMREAD when RFLAGS is not already available.  When
running nested VMs, the majority of calls to vmx_set_rflags() will occur
without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
during transitions between vmcs01 and vmcs02.

Note, vmx_get_rflags() guarantees RFLAGS is marked available.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 83fe8b02b732..814d3e6d0264 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1426,18 +1426,26 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long old_rflags = vmx_get_rflags(vcpu);
+	unsigned long old_rflags;
 
-	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
-	vmx->rflags = rflags;
-	if (vmx->rmode.vm86_active) {
-		vmx->rmode.save_rflags = rflags;
-		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+	if (enable_unrestricted_guest) {
+		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
+
+		vmx->rflags = rflags;
+		vmcs_writel(GUEST_RFLAGS, rflags);
+	} else {
+		old_rflags = vmx_get_rflags(vcpu);
+
+		vmx->rflags = rflags;
+		if (vmx->rmode.vm86_active) {
+			vmx->rmode.save_rflags = rflags;
+			rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+		}
+		vmcs_writel(GUEST_RFLAGS, rflags);
+
+		if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
+			vmx->emulation_required = emulation_required(vcpu);
 	}
-	vmcs_writel(GUEST_RFLAGS, rflags);
-
-	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
-		vmx->emulation_required = emulation_required(vcpu);
 }
 
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
-- 
2.22.0

