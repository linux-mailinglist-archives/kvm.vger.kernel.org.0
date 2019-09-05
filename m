Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF129AADC5
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbfIEVW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 17:22:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:37535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389773AbfIEVW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 17:22:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 14:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="383038930"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 05 Sep 2019 14:22:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Add kvm_emulate_{rd,wr}msr() to consolidate VXM/SVM code
Date:   Thu,  5 Sep 2019 14:22:55 -0700
Message-Id: <20190905212255.26549-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190905212255.26549-1-sean.j.christopherson@intel.com>
References: <20190905212255.26549-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move RDMSR and WRMSR emulation into common x86 code to consolidate
nearly identical SVM and VMX code.

Note, consolidating RDMSR introduces an extra indirect call, i.e.
retpoline, due to reaching {svm,vmx}_get_msr() via kvm_x86_ops, but a
guest kernel likely has bigger problems if increasing the latency of
RDMSR VM-Exits by ~70 cycles has a measurable impact on overall VM
performance.  E.g. the only recurring RDMSR VM-Exits (after booting) on
my system running Linux 5.2 in the guest are for MSR_IA32_TSC_ADJUST via
arch_cpu_idle_enter().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 29 ++-------------------------
 arch/x86/kvm/vmx/vmx.c          | 29 ++-------------------------
 arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 649d80b5cd6f..003c1cc8e28b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1328,6 +1328,8 @@ void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
+int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
 
 struct x86_emulate_ctxt;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 030bc9f7b7a7..b033aebbcd30 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4220,22 +4220,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static int rdmsr_interception(struct vcpu_svm *svm)
 {
-	u32 ecx = kvm_rcx_read(&svm->vcpu);
-	struct msr_data msr_info;
-
-	msr_info.index = ecx;
-	msr_info.host_initiated = false;
-	if (svm_get_msr(&svm->vcpu, &msr_info)) {
-		trace_kvm_msr_read_ex(ecx);
-		kvm_inject_gp(&svm->vcpu, 0);
-		return 1;
-	} else {
-		trace_kvm_msr_read(ecx, msr_info.data);
-
-		kvm_rax_write(&svm->vcpu, msr_info.data & 0xffffffff);
-		kvm_rdx_write(&svm->vcpu, msr_info.data >> 32);
-		return kvm_skip_emulated_instruction(&svm->vcpu);
-	}
+	return kvm_emulate_rdmsr(&svm->vcpu);
 }
 
 static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
@@ -4425,17 +4410,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 static int wrmsr_interception(struct vcpu_svm *svm)
 {
-	u32 ecx = kvm_rcx_read(&svm->vcpu);
-	u64 data = kvm_read_edx_eax(&svm->vcpu);
-
-	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
-		trace_kvm_msr_write_ex(ecx, data);
-		kvm_inject_gp(&svm->vcpu, 0);
-		return 1;
-	} else {
-		trace_kvm_msr_write(ecx, data);
-		return kvm_skip_emulated_instruction(&svm->vcpu);
-	}
+	return kvm_emulate_wrmsr(&svm->vcpu);
 }
 
 static int msr_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f4f4114e756f..b98a88dc8ca6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4866,37 +4866,12 @@ static int handle_cpuid(struct kvm_vcpu *vcpu)
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
-	struct msr_data msr_info;
-
-	msr_info.index = ecx;
-	msr_info.host_initiated = false;
-	if (vmx_get_msr(vcpu, &msr_info)) {
-		trace_kvm_msr_read_ex(ecx);
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	trace_kvm_msr_read(ecx, msr_info.data);
-
-	kvm_rax_write(vcpu, msr_info.data & -1u);
-	kvm_rdx_write(vcpu, (msr_info.data >> 32) & -1u);
-	return kvm_skip_emulated_instruction(vcpu);
+	return kvm_emulate_rdmsr(vcpu);
 }
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
-	u64 data = kvm_read_edx_eax(vcpu);
-
-	if (kvm_set_msr(vcpu, ecx, data) != 0) {
-		trace_kvm_msr_write_ex(ecx, data);
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	trace_kvm_msr_write(ecx, data);
-	return kvm_skip_emulated_instruction(vcpu);
+	return kvm_emulate_wrmsr(vcpu);
 }
 
 static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a67730600803..7cd578d52611 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1434,6 +1434,41 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
+int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
+{
+	u32 ecx = kvm_rcx_read(vcpu);
+	u64 data;
+
+	if (kvm_get_msr(vcpu, ecx, &data)) {
+		trace_kvm_msr_read_ex(ecx);
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	trace_kvm_msr_read(ecx, data);
+
+	kvm_rax_write(vcpu, data & -1u);
+	kvm_rdx_write(vcpu, (data >> 32) & -1u);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
+
+int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
+{
+	u32 ecx = kvm_rcx_read(vcpu);
+	u64 data = kvm_read_edx_eax(vcpu);
+
+	if (kvm_set_msr(vcpu, ecx, data)) {
+		trace_kvm_msr_write_ex(ecx, data);
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	trace_kvm_msr_write(ecx, data);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
+
 /*
  * Adapt set_msr() to msr_io()'s calling convention
  */
-- 
2.22.0

