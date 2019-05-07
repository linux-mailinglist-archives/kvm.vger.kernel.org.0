Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575451676F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfEGQG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:42087 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGQGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:47 -0400
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
Subject: [PATCH 07/15] KVM: nVMX: Don't reread VMCS-agnostic state when switching VMCS
Date:   Tue,  7 May 2019 09:06:32 -0700
Message-Id: <20190507160640.4812-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When switching between vmcs01 and vmcs02, there is no need to update
state tracking for values that aren't tied to any particular VMCS as
the per-vCPU values are already up-to-date (vmx_switch_vmcs() can only
be called when the vCPU is loaded).

Avoiding the update eliminates a RDMSR, and potentially a RDPKRU and
posted-interrupt updated (cmpxchg64() and more).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 18 +++++++++++++-----
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4651d3462df4..99164d054922 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -251,7 +251,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	cpu = get_cpu();
 	prev = vmx->loaded_cpu_state;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load(vcpu, cpu);
+	__vmx_vcpu_load(vcpu, cpu);
 
 	if (likely(prev)) {
 		src = &prev->host_state;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b97666731425..0c48dee4159b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1231,11 +1231,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
-/*
- * Switches to specified vcpu, until a matching vcpu_put(), but assumes
- * vcpu mutex is already taken.
- */
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void __vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
@@ -1296,8 +1292,20 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_has_tsc_control &&
 	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
 		decache_tsc_multiplier(vmx);
+}
+
+/*
+ * Switches to specified vcpu, until a matching vcpu_put(), but assumes
+ * vcpu mutex is already taken.
+ */
+static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	__vmx_vcpu_load(vcpu, cpu);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
+
 	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f81b32ae1822..f62a008c9227 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -292,7 +292,7 @@ struct kvm_vmx {
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void __vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-- 
2.21.0

