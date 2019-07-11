Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08854658CF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfGKO20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbfGKO2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO8ft001446;
        Thu, 11 Jul 2019 14:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=44bGpNhDn4CQMJWfcA7dlBtv4lKR0GVNyXSLf3OmODU=;
 b=sYC68pAgGYMeZCzOFkUOuj4EApQvKlshFt7mE2WAdPKV4oXjKlwvx1k4YJanPkydZ+Rn
 nhL5rnoahTfhc8IS1gDxcvz2TkFDuiQbUpBXbrUM3d7hA1hqNT1LXCfxGliFZOD6TdOF
 /3LBjw+5bGaWzvBtKCMuwVIUzbBatm/N7BwPJzQJCnQfj9Csi3AeniX/ps6uYP+y0BkL
 obw32Tp/dAVmexQz4kk3ptW1s2ArR2RXMrCD7YlTDm2ZoFxL1jsctlJFVVEs2mdJMt1K
 kWQize+PYuE3+4ce/ZZAOApqTAW4neDTZZCWGAKbNKb/yPwlRIT1dU+LMDkfey1//U/x dQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:27:03 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuH021444;
        Thu, 11 Jul 2019 14:27:00 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 24/26] KVM: x86/asi: Populate the KVM ASI page-table
Date:   Thu, 11 Jul 2019 16:25:36 +0200
Message-Id: <1562855138-19507-25-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add mappings to the KVM ASI page-table so that KVM can run with its
address space isolation without faulting too much.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/vmx/isolation.c |  155 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |    1 -
 arch/x86/kvm/vmx/vmx.h       |    3 +
 3 files changed, 154 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/isolation.c b/arch/x86/kvm/vmx/isolation.c
index 644d8d3..d82f6b6 100644
--- a/arch/x86/kvm/vmx/isolation.c
+++ b/arch/x86/kvm/vmx/isolation.c
@@ -5,7 +5,7 @@
  * KVM Address Space Isolation
  */
 
-#include <linux/module.h>
+#include <linux/kvm_host.h>
 #include <linux/moduleparam.h>
 #include <linux/printk.h>
 #include <asm/asi.h>
@@ -14,8 +14,11 @@
 #include "vmx.h"
 #include "x86.h"
 
-#define VMX_ASI_MAP_FLAGS	\
-	(ASI_MAP_STACK_CANARY | ASI_MAP_CPU_PTR | ASI_MAP_CURRENT_TASK)
+#define VMX_ASI_MAP_FLAGS (ASI_MAP_STACK_CANARY |	\
+			   ASI_MAP_CPU_PTR |		\
+			   ASI_MAP_CURRENT_TASK |	\
+			   ASI_MAP_RCU_DATA |		\
+			   ASI_MAP_CPU_HW_EVENTS)
 
 /*
  * When set to true, KVM #VMExit handlers run in isolated address space
@@ -34,9 +37,153 @@
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
 
+/*
+ * Map various kernel data.
+ */
+static int vmx_isolation_map_kernel_data(struct asi *asi)
+{
+	int err;
+
+	/* map context_tracking, used by guest_enter_irqoff() */
+	err = ASI_MAP_CPUVAR(asi, context_tracking);
+	if (err)
+		return err;
+
+	/* map irq_stat, used by kvm_*_cpu_l1tf_flush_l1d */
+	err = ASI_MAP_CPUVAR(asi, irq_stat);
+	if (err)
+		return err;
+	return 0;
+}
+
+/*
+ * Map kvm module and data from that module.
+ */
+static int vmx_isolation_map_kvm_data(struct asi *asi, struct kvm *kvm)
+{
+	int err;
+
+	/* map kvm module */
+	err = asi_map_module(asi, "kvm");
+	if (err)
+		return err;
+
+	err = asi_map_percpu(asi, kvm->srcu.sda,
+			     sizeof(struct srcu_data));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/*
+ * Map kvm-intel module and generic x86 data.
+ */
+static int vmx_isolation_map_kvm_x86_data(struct asi *asi)
+{
+	int err;
+
+	/* map current module (kvm-intel) */
+	err = ASI_MAP_THIS_MODULE(asi);
+	if (err)
+		return err;
+
+	/* map current_vcpu, used by vcpu_enter_guest() */
+	err = ASI_MAP_CPUVAR(asi, current_vcpu);
+	if (err)
+		return (err);
+
+	return 0;
+}
+
+/*
+ * Map vmx data.
+ */
+static int vmx_isolation_map_kvm_vmx_data(struct asi *asi, struct vcpu_vmx *vmx)
+{
+	struct kvm_vmx *kvm_vmx;
+	struct kvm_vcpu *vcpu;
+	struct kvm *kvm;
+	int err;
+
+	vcpu = &vmx->vcpu;
+	kvm = vcpu->kvm;
+	kvm_vmx = to_kvm_vmx(kvm);
+
+	/* map kvm_vmx (this also maps kvm) */
+	err = asi_map(asi, kvm_vmx, sizeof(*kvm_vmx));
+	if (err)
+		return err;
+
+	/* map vmx (this also maps vcpu) */
+	err = asi_map(asi, vmx, sizeof(*vmx));
+	if (err)
+		return err;
+
+	/* map vcpu data */
+	err = asi_map(asi, vcpu->run, PAGE_SIZE);
+	if (err)
+		return err;
+
+	err = asi_map(asi, vcpu->arch.apic, sizeof(struct kvm_lapic));
+	if (err)
+		return err;
+
+	/*
+	 * Map additional vmx data.
+	 */
+
+	if (vmx_l1d_flush_pages) {
+		err = asi_map(asi, vmx_l1d_flush_pages,
+			      PAGE_SIZE << L1D_CACHE_ORDER);
+		if (err)
+			return err;
+	}
+
+	if (enable_pml) {
+		err = asi_map(asi, vmx->pml_pg, sizeof(struct page));
+		if (err)
+			return err;
+	}
+
+	err = asi_map(asi, vmx->guest_msrs, PAGE_SIZE);
+	if (err)
+		return err;
+
+	err = asi_map(asi, vmx->vmcs01.vmcs, PAGE_SIZE << vmcs_config.order);
+	if (err)
+		return err;
+
+	err = asi_map(asi, vmx->vmcs01.msr_bitmap, PAGE_SIZE);
+	if (err)
+		return err;
+
+	err = asi_map(asi, vmx->vcpu.arch.pio_data, PAGE_SIZE);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int vmx_isolation_init_mapping(struct asi *asi, struct vcpu_vmx *vmx)
 {
-	/* TODO: Populate the KVM ASI page-table */
+	int err;
+
+	err = vmx_isolation_map_kernel_data(asi);
+	if (err)
+		return err;
+
+	err = vmx_isolation_map_kvm_data(asi, vmx->vcpu.kvm);
+	if (err)
+		return err;
+
+	err = vmx_isolation_map_kvm_x86_data(asi);
+	if (err)
+		return err;
+
+	err = vmx_isolation_map_kvm_vmx_data(asi, vmx);
+	if (err)
+		return err;
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b92467..d47f093 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -201,7 +201,6 @@
 	[VMENTER_L1D_FLUSH_NOT_REQUIRED] = {"not required", false},
 };
 
-#define L1D_CACHE_ORDER 4
 void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 09c1593..e8de23b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,9 @@
 #include "ops.h"
 #include "vmcs.h"
 
+#define L1D_CACHE_ORDER 4
+extern void *vmx_l1d_flush_pages;
+
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
 
-- 
1.7.1

