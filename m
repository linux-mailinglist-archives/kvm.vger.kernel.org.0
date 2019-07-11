Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72E8658D1
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfGKO22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfGKO20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOeBP100905;
        Thu, 11 Jul 2019 14:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=fCmddW3R3yJKPuzx/XlLHeQxEVYNN8yCIHDije5QoA8=;
 b=Goc71bNby+SDwxhZAZJVL35O0KCgSN6SQ19s01XeIVYA0KpDzxqCOIh+DsMUdWnvypT6
 gGIgJRxy1708M9KVMhnYoB2ywb6qTtvwn4CXAcD7cmjlrvcJBS5+6PMDrIoeoEOtcDJK
 KW4X5dXci15RHrRtDaZcLfMFnXMXtBJVZEJjoExPc4mdpEdW63wB2JO1A+Dh4bIcTLp9
 33On0i+8xG4PIxV+nRWqZqXbmizbh6ObtA00K1qWRZ6jEfJsKpM/X75UoB221Hphl68n
 Yka3rbKbML0ZOqcFcBNFej4+/AWOTKnp/kUU6rp69SbIMOLJvaM5ku0lYaGL5zwa2anP Lg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0ceg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:27:06 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuI021444;
        Thu, 11 Jul 2019 14:27:03 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 25/26] KVM: x86/asi: Switch to KVM address space on entry to guest
Date:   Thu, 11 Jul 2019 16:25:37 +0200
Message-Id: <1562855138-19507-26-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=753 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Switch to KVM address space on entry to guest. Most of KVM #VMExit
handlers will run in KVM isolated address space and switch back to
host address space only before accessing sensitive data. Sensitive
data is defined as either host data or other VM data.

Currently, we switch back to the host address space on the following
scenarios:
1) When handling guest page-faults:
   As this will access SPTs which contains host PFNs.
2) On schedule-out of vCPU thread
3) On write to guest virtual memory
   (kvm_write_guest_virt_system() can pull in tons of pages)
4) On return to userspace (e.g. QEMU)
5) On interrupt or exception

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/mmu.c           |    2 +-
 arch/x86/kvm/vmx/isolation.c |    2 +-
 arch/x86/kvm/vmx/vmx.c       |    6 ++++++
 arch/x86/kvm/vmx/vmx.h       |   18 ++++++++++++++++++
 arch/x86/kvm/x86.c           |   34 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h           |    1 +
 6 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 98f6e4f..298f602 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4067,7 +4067,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 {
 	int r = 1;
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_may_access_sensitive_data(vcpu);
 	switch (vcpu->arch.apf.host_apf_reason) {
 	default:
 		trace_kvm_page_fault(fault_address, error_code);
diff --git a/arch/x86/kvm/vmx/isolation.c b/arch/x86/kvm/vmx/isolation.c
index d82f6b6..8f57f10 100644
--- a/arch/x86/kvm/vmx/isolation.c
+++ b/arch/x86/kvm/vmx/isolation.c
@@ -34,7 +34,7 @@
  * This is set to false by default because it incurs a performance hit
  * which some users will not want to take for security gain.
  */
-static bool __read_mostly address_space_isolation;
+bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d47f093..b5867cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6458,8 +6458,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
+	/*
+	 * Use an isolation barrier as VMExit will restore the isolation
+	 * CR3 while interrupts can abort isolation.
+	 */
+	vmx_isolation_barrier_begin(vmx);
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
+	vmx_isolation_barrier_end(vmx);
 
 	vcpu->arch.cr2 = read_cr2();
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e8de23b..b65f059 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -531,4 +531,22 @@ static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
 int vmx_isolation_init(struct vcpu_vmx *vmx);
 void vmx_isolation_uninit(struct vcpu_vmx *vmx);
 
+extern bool __read_mostly address_space_isolation;
+
+static inline void vmx_isolation_barrier_begin(struct vcpu_vmx *vmx)
+{
+	if (!address_space_isolation || !vmx->vcpu.asi)
+		return;
+
+	asi_barrier_begin();
+}
+
+static inline void vmx_isolation_barrier_end(struct vcpu_vmx *vmx)
+{
+	if (!address_space_isolation || !vmx->vcpu.asi)
+		return;
+
+	asi_barrier_end();
+}
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9857992..9458413 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3346,6 +3346,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
 	 */
 	set_debugreg(0, 6);
+
+	kvm_may_access_sensitive_data(vcpu);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -5259,7 +5261,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_may_access_sensitive_data(vcpu);
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -7744,6 +7746,32 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+static void vcpu_isolation_enter(struct kvm_vcpu *vcpu)
+{
+	int err;
+
+	if (!vcpu->asi)
+		return;
+
+	err = asi_enter(vcpu->asi);
+	if (err)
+		pr_debug("KVM isolation failed: error %d\n", err);
+}
+
+static void vcpu_isolation_exit(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->asi)
+		return;
+
+	asi_exit(vcpu->asi);
+}
+
+void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.l1tf_flush_l1d = true;
+	vcpu_isolation_exit(vcpu);
+}
+
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -7944,6 +7972,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	vcpu_isolation_enter(vcpu);
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops->request_immediate_exit(vcpu);
@@ -8130,6 +8160,8 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
+	kvm_may_access_sensitive_data(vcpu);
+
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0..69a7402 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -356,5 +356,6 @@ static inline bool kvm_pat_valid(u64 data)
 
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
+void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu);
 
 #endif
-- 
1.7.1

