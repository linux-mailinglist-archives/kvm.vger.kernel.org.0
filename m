Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3394E16765
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfEGQGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:42085 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbfEGQGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 09:06:44 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 09:06:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 06/15] KVM: nVMX: Don't "put" vCPU or host state when switching VMCS
Date:   Tue,  7 May 2019 09:06:31 -0700
Message-Id: <20190507160640.4812-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When switching between vmcs01 and vmcs02, KVM isn't actually switching
between guest and host.  If guest state is already loaded (the likely,
if not guaranteed, case), keep the guest state loaded and manually swap
the loaded_cpu_state pointer after propagating saved host state to the
new vmcs0{1,2}.

Avoiding the switch between guest and host reduces the latency of
switching between vmcs01 and vmcs02 by several hundred cycles, and
reduces the roundtrip time of a nested VM by upwards of 1000 cycles.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 18 +++++++++++++-
 arch/x86/kvm/vmx/vmx.c    | 52 ++++++++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h    |  3 ++-
 3 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a30d53823b2e..4651d3462df4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -241,15 +241,31 @@ static void free_nested(struct kvm_vcpu *vcpu)
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs_host_state *src;
+	struct loaded_vmcs *prev;
 	int cpu;
 
 	if (vmx->loaded_vmcs == vmcs)
 		return;
 
 	cpu = get_cpu();
-	vmx_vcpu_put(vcpu);
+	prev = vmx->loaded_cpu_state;
 	vmx->loaded_vmcs = vmcs;
 	vmx_vcpu_load(vcpu, cpu);
+
+	if (likely(prev)) {
+		src = &prev->host_state;
+
+		vmx_set_host_fs_gs(&vmcs->host_state, src->fs_sel, src->gs_sel,
+				   src->fs_base, src->gs_base);
+
+		vmcs->host_state.ldt_sel = src->ldt_sel;
+#ifdef CONFIG_X86_64
+		vmcs->host_state.ds_sel = src->ds_sel;
+		vmcs->host_state.es_sel = src->es_sel;
+#endif
+		vmx->loaded_cpu_state = vmcs;
+	}
 	put_cpu();
 
 	vm_entry_controls_reset_shadow(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f3b0f4445af7..b97666731425 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1035,6 +1035,33 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base)
+{
+	if (unlikely(fs_sel != host->fs_sel)) {
+		if (!(fs_sel & 7))
+			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
+		else
+			vmcs_write16(HOST_FS_SELECTOR, 0);
+		host->fs_sel = fs_sel;
+	}
+	if (unlikely(gs_sel != host->gs_sel)) {
+		if (!(gs_sel & 7))
+			vmcs_write16(HOST_GS_SELECTOR, gs_sel);
+		else
+			vmcs_write16(HOST_GS_SELECTOR, 0);
+		host->gs_sel = gs_sel;
+	}
+	if (unlikely(fs_base != host->fs_base)) {
+		vmcs_writel(HOST_FS_BASE, fs_base);
+		host->fs_base = fs_base;
+	}
+	if (unlikely(gs_base != host->gs_base)) {
+		vmcs_writel(HOST_GS_BASE, gs_base);
+		host->gs_base = gs_base;
+	}
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1100,28 +1127,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	gs_base = segment_base(gs_sel);
 #endif
 
-	if (unlikely(fs_sel != host_state->fs_sel)) {
-		if (!(fs_sel & 7))
-			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
-		else
-			vmcs_write16(HOST_FS_SELECTOR, 0);
-		host_state->fs_sel = fs_sel;
-	}
-	if (unlikely(gs_sel != host_state->gs_sel)) {
-		if (!(gs_sel & 7))
-			vmcs_write16(HOST_GS_SELECTOR, gs_sel);
-		else
-			vmcs_write16(HOST_GS_SELECTOR, 0);
-		host_state->gs_sel = gs_sel;
-	}
-	if (unlikely(fs_base != host_state->fs_base)) {
-		vmcs_writel(HOST_FS_BASE, fs_base);
-		host_state->fs_base = fs_base;
-	}
-	if (unlikely(gs_base != host_state->gs_base)) {
-		vmcs_writel(HOST_GS_BASE, gs_base);
-		host_state->gs_base = gs_base;
-	}
+	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
 }
 
 static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
@@ -1310,7 +1316,7 @@ static void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 		pi_set_sn(pi_desc);
 }
 
-void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63d37ccce3dc..f81b32ae1822 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -293,11 +293,12 @@ struct kvm_vmx {
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void vmx_vcpu_put(struct kvm_vcpu *vcpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
-- 
2.21.0

