Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0233E1B8B5
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfEMOjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45408 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbfEMOjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd6qH181584;
        Mon, 13 May 2019 14:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=wqdeci0HyBGB7YKvZMkvhcTkiB8MUENeuIRahUviMQQ=;
 b=qAq8bRmqjLI4ZmGhxqxLQzFJ+Y7ZGe9B4tzqFa4rSPttIDYPwO8CyJSVFyohA4WGqJmF
 PiEooyxx92pLb5i0rofSV4dZw0lAf84hAXIH/yxG0GncuXG6InmO4dJUyzjA+ryXZa3+
 kpAk+nls/3Op+xDAehiDEtWmVkdLl1RWyWJ2r/dqXCkn+On4KPyzKvKpd3t0q+Al/+8t
 OnREbE+Cqw+DpqL4613DUOyPi8UvLz/4anaHm7nytPek57wpfSd6QSOe3Wz14bi6e5IO
 vMHSdlEGcaFkmj7ADxMP0X19oYbCmNWG6TEextjbaF9y0FnEIo95HqGb3w9D+rgQ3QCW PQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2sdnttfeff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:07 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQA022780;
        Mon, 13 May 2019 14:38:59 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 07/27] KVM: x86: Switch to host address space when may access sensitive data
Date:   Mon, 13 May 2019 16:38:15 +0200
Message-Id: <1557758315-12667-8-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=851 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Before this patch, we exited from KVM isolated address space to
host address space as soon as we exit guest.

Change code such that most of KVM #VMExit handlers will run in KVM
isolated address space and switch back to host address space
only before accessing sensitive data. Sensitive data is defined
as either host data or other VM data.

Currently, we switch from kvm_mm to host_mm on the following scenarios:
1) When handling guest page-faults:
   As this will access SPTs which contains host PFNs.
2) On schedule-out of vCPU thread
3) On write to guest virtual memory
   (kvm_write_guest_virt_system() can pull in tons of pages)
4) On return to userspace (e.g. QEMU)
5) On prelog of IRQ handlers

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |    7 ++++++-
 arch/x86/kvm/isolation.h |    3 +++
 arch/x86/kvm/mmu.c       |    3 ++-
 arch/x86/kvm/x86.c       |   12 +++++-------
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 22ff9c2..eeb60c4 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -5,7 +5,6 @@
  * KVM Address Space Isolation
  */
 
-#include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/printk.h>
@@ -133,6 +132,12 @@ void kvm_isolation_uninit(void)
 	pr_info("KVM: x86: End of isolated address space\n");
 }
 
+void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_isolation_exit();
+}
+
 void kvm_isolation_enter(void)
 {
 	if (address_space_isolation) {
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 595f62c..1290d32 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -2,9 +2,12 @@
 #ifndef ARCH_X86_KVM_ISOLATION_H
 #define ARCH_X86_KVM_ISOLATION_H
 
+#include <linux/kvm_host.h>
+
 extern int kvm_isolation_init(void);
 extern void kvm_isolation_uninit(void);
 extern void kvm_isolation_enter(void);
 extern void kvm_isolation_exit(void);
+extern void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d9c7b45..a2b38de 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -23,6 +23,7 @@
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
+#include "isolation.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -4059,7 +4060,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 {
 	int r = 1;
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_may_access_sensitive_data(vcpu);
 	switch (vcpu->arch.apf.host_apf_reason) {
 	default:
 		trace_kvm_page_fault(fault_address, error_code);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85700e0..1db72c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3307,6 +3307,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
 	 */
 	set_debugreg(0, 6);
+
+	kvm_may_access_sensitive_data(vcpu);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -5220,7 +5222,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_may_access_sensitive_data(vcpu);
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -7948,12 +7950,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
-	/*
-	 * TODO: Move this to where we architectually need to access
-	 * host (or other VM) sensitive data
-	 */
-	kvm_isolation_exit();
-
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
@@ -8086,6 +8082,8 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
+	kvm_may_access_sensitive_data(vcpu);
+
 	return r;
 }
 
-- 
1.7.1

