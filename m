Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34145FEF4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfD3Rg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 13:36:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:32358 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfD3RgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 13:36:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 10:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="166341329"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2019 10:36:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 3/3] KVM: VMX: Use accessors for GPRs outside of dedicated caching logic
Date:   Tue, 30 Apr 2019 10:36:19 -0700
Message-Id: <20190430173619.15774-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430173619.15774-1-sean.j.christopherson@intel.com>
References: <20190430173619.15774-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... now that there is no overhead when using dedicated accessors.

Opportunistically remove a bogus "FIXME" in handle_rdmsr() regarding
the upper 32 bits of RAX and RDX.  Zeroing the upper 32 bits is
architecturally correct as 32-bit writes in 64-bit mode unconditionally
clear the upper 32 bits.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  6 +++---
 arch/x86/kvm/vmx/vmx.c    | 12 +++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 35d92f5ab2de..449cf878d9df 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4808,7 +4808,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 				     struct vmcs12 *vmcs12)
 {
-	u32 index = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 index = kvm_rcx_read(vcpu);
 	u64 address;
 	bool accessed_dirty;
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -4854,7 +4854,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12;
-	u32 function = vcpu->arch.regs[VCPU_REGS_RAX];
+	u32 function = kvm_rax_read(vcpu);
 
 	/*
 	 * VMFUNC is only supported for nested guests, but we always enable the
@@ -4940,7 +4940,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, u32 exit_reason)
 {
-	u32 msr_index = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 msr_index = kvm_rcx_read(vcpu);
 	gpa_t bitmap;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5880c5c7388a..553068867c62 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4832,7 +4832,7 @@ static int handle_cpuid(struct kvm_vcpu *vcpu)
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 ecx = kvm_rcx_read(vcpu);
 	struct msr_data msr_info;
 
 	msr_info.index = ecx;
@@ -4845,18 +4845,16 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu)
 
 	trace_kvm_msr_read(ecx, msr_info.data);
 
-	/* FIXME: handling of bits 32:63 of rax, rdx */
-	vcpu->arch.regs[VCPU_REGS_RAX] = msr_info.data & -1u;
-	vcpu->arch.regs[VCPU_REGS_RDX] = (msr_info.data >> 32) & -1u;
+	kvm_rax_write(vcpu, msr_info.data & -1u);
+	kvm_rdx_write(vcpu, (msr_info.data >> 32) & -1u);
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu)
 {
 	struct msr_data msr;
-	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
-	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
-		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
+	u32 ecx = kvm_rcx_read(vcpu);
+	u64 data = kvm_read_edx_eax(vcpu);
 
 	msr.data = data;
 	msr.index = ecx;
-- 
2.21.0

