Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68361768D2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgCBX7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:59:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:17170 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384814"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 63/66] KVM: x86: Move VMX's host_efer to common x86 code
Date:   Mon,  2 Mar 2020 15:57:06 -0800
Message-Id: <20200302235709.27467-64-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move host_efer to common x86 code and use it for CPUID's is_efer_nx() to
avoid constantly re-reading the MSR.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/cpuid.c            | 5 +----
 arch/x86/kvm/vmx/vmx.c          | 3 ---
 arch/x86/kvm/vmx/vmx.h          | 1 -
 arch/x86/kvm/x86.c              | 5 +++++
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0f5607c66b5..27983e5895d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1263,6 +1263,8 @@ struct kvm_arch_async_pf {
 	bool direct_map;
 };
 
+extern u64 __read_mostly host_efer;
+
 extern struct kvm_x86_ops *kvm_x86_ops;
 extern struct kmem_cache *x86_fpu_cache;
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f879fcbd6fb2..f0c4ad04d4dc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -134,10 +134,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 static int is_efer_nx(void)
 {
-	unsigned long long efer = 0;
-
-	rdmsrl_safe(MSR_EFER, &efer);
-	return efer & EFER_NX;
+	return host_efer & EFER_NX;
 }
 
 static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1fbe54dc3263..180aeebd029a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -433,7 +433,6 @@ static const struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
-u64 host_efer;
 static unsigned long host_idt_base;
 
 /*
@@ -7642,8 +7641,6 @@ static __init int hardware_setup(void)
 	struct desc_ptr dt;
 	int r, i, ept_lpage_level;
 
-	rdmsrl_safe(MSR_EFER, &host_efer);
-
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9a51a3a77233..fc45bdb5a62f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -12,7 +12,6 @@
 #include "vmcs.h"
 
 extern const u32 vmx_msr_index[];
-extern u64 host_efer;
 
 extern u32 get_umwait_control_msr(void);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc9b543d210b..aa2a085f115c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -185,6 +185,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+u64 __read_mostly host_efer;
+EXPORT_SYMBOL_GPL(host_efer);
+
 static u64 __read_mostly host_xss;
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
@@ -9559,6 +9562,8 @@ int kvm_arch_hardware_setup(void)
 {
 	int r;
 
+	rdmsrl_safe(MSR_EFER, &host_efer);
+
 	kvm_set_cpu_caps();
 
 	r = kvm_x86_ops->hardware_setup();
-- 
2.24.1

