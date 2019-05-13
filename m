Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE91B89C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfEMOkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730525AbfEMOkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd3dD181544;
        Mon, 13 May 2019 14:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=OxanbwcMAhQGR2MgwGG1WhL6eejs6scvJBA++WEfeAY=;
 b=sU2LVxvsJrs8djlyFSIdZHIRCpnGERg2UYPNUhkjBZS5y33p5PwL4YfHc1GeuRzDdQDc
 tI0T4yhU0dK1zriLrw7oc9ar2kWJb8ndOWDLgtO2S3p47ONlJjMT8DUNuiH6bnk/HBS8
 4pRTCY+QUM4kQQE3oKH19lJQLedFyMmlQevJV2qxd27nI0pcuQGDzWA0LWRRFA/SWQEU
 nPdKdbh2dWUUqgGbATEXLToM31SW1rDh84aMrX31dZ5ifOINbXk1GaZ1ybT260MDzhmO
 Rv/V6YNnfjMVWcuyQ7jnbONxErhqEaY2u+iG8myukAxzaJ4GJAWzjMX/sNhelawAFCXL Aw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2sdnttfejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:42 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQO022780;
        Mon, 13 May 2019 14:39:39 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 21/27] kvm/isolation: initialize the KVM page table with vmx VM data
Date:   Mon, 13 May 2019 16:38:29 +0200
Message-Id: <1557758315-12667-22-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map VM data, in particular the kvm structure data.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   17 +++++++++++++++++
 arch/x86/kvm/isolation.h |    2 ++
 arch/x86/kvm/vmx/vmx.c   |   31 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c       |   12 ++++++++++++
 include/linux/kvm_host.h |    1 +
 virt/kvm/arm/arm.c       |    4 ++++
 virt/kvm/kvm_main.c      |    2 +-
 7 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index cf5ee0d..d3ac014 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -1222,6 +1222,23 @@ static void kvm_isolation_clear_handlers(void)
 	kvm_set_isolation_exit_handler(NULL);
 }
 
+int kvm_isolation_init_vm(struct kvm *kvm)
+{
+	if (!kvm_isolation())
+		return 0;
+
+	return (kvm_copy_percpu_mapping(kvm->srcu.sda,
+		sizeof(struct srcu_data)));
+}
+
+void kvm_isolation_destroy_vm(struct kvm *kvm)
+{
+	if (!kvm_isolation())
+		return;
+
+	kvm_clear_percpu_mapping(kvm->srcu.sda);
+}
+
 int kvm_isolation_init(void)
 {
 	int r;
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 1f79e28..33e9a87 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -23,6 +23,8 @@ static inline bool kvm_isolation(void)
 
 extern int kvm_isolation_init(void);
 extern void kvm_isolation_uninit(void);
+extern int kvm_isolation_init_vm(struct kvm *kvm);
+extern void kvm_isolation_destroy_vm(struct kvm *kvm);
 extern void kvm_isolation_enter(void);
 extern void kvm_isolation_exit(void);
 extern void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f181b3c..5b52e8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6523,6 +6523,33 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 }
 
+static void vmx_unmap_vm(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (!kvm_isolation())
+		return;
+
+	pr_debug("unmapping kvm %p", kvm_vmx);
+	kvm_clear_range_mapping(kvm_vmx);
+}
+
+static int vmx_map_vm(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (!kvm_isolation())
+		return 0;
+
+	pr_debug("mapping kvm %p", kvm_vmx);
+	/*
+	 * Only copy kvm_vmx struct mapping because other
+	 * attributes (like kvm->srcu) are not initialized
+	 * yet.
+	 */
+	return kvm_copy_ptes(kvm_vmx, sizeof(struct kvm_vmx));
+}
+
 static struct kvm *vmx_vm_alloc(void)
 {
 	struct kvm_vmx *kvm_vmx = __vmalloc(sizeof(struct kvm_vmx),
@@ -6533,6 +6560,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 static void vmx_vm_free(struct kvm *kvm)
 {
+	vmx_unmap_vm(kvm);
 	vfree(to_kvm_vmx(kvm));
 }
 
@@ -6702,7 +6730,8 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	return 0;
+
+	return (vmx_map_vm(kvm));
 }
 
 static void __init vmx_check_processor_compat(void *rtn)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1db72c3..e1cc3a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9207,6 +9207,17 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
+void kvm_arch_vm_postcreate(struct kvm *kvm)
+{
+	/*
+	 * The kvm structure is mapped in vmx.c so that the full kvm_vmx
+	 * structure can be mapped. Attributes allocated in the kvm
+	 * structure (like kvm->srcu) are mapped by kvm_isolation_init_vm()
+	 * because they are not initialized when vmx.c maps the kvm structure.
+	 */
+	kvm_isolation_init_vm(kvm);
+}
+
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
@@ -9320,6 +9331,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT, 0, 0);
 		x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 	}
+	kvm_isolation_destroy_vm(kvm);
 	if (kvm_x86_ops->vm_destroy)
 		kvm_x86_ops->vm_destroy(kvm);
 	kvm_pic_destroy(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 640a036..ad24d9e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -932,6 +932,7 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
+void kvm_arch_vm_postcreate(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f412ebc..0921cb3 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -156,6 +156,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
+void kvm_arch_vm_postcreate(struct kvm *kvm)
+{
+}
+
 bool kvm_arch_has_vcpu_debugfs(void)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a704d1f..3c0c3db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3366,7 +3366,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 		return -ENOMEM;
 	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
-
+	kvm_arch_vm_postcreate(kvm);
 	fd_install(r, file);
 	return r;
 
-- 
1.7.1

