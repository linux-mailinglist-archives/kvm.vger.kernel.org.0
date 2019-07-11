Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39A6658CA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfGKO2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbfGKO2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO8MS001456;
        Thu, 11 Jul 2019 14:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=0gU3+EHAnLmrdQwDq6KHZSyy6MdJI7eVGdpzzFAPgXk=;
 b=iiyyes3p413lD4tawJspczGrP6E0lodllk7rkaTrmsT9/Hc2gRBbnS6pJ51rtyC6w6oK
 s0zXzPmMoMMZfu+NfOM5wgMpW+ZwZb5dNJIjL1sOQ2wAe8I6VnoBZVNNsVBlEfHguvjZ
 UWzv4mgQ5Z/QbJM2eHak92dK2mAAiscm2gFOv4AEAAm/6hM07TfZIH/hBOE3puhP7Woq
 7qMIQ3AxCkBa3FdCnuUeCDTF3Vl7BFaFDKI8v0ZHZA9v/ppmgWW2qg65hjSCEFqy4KMB
 vWZ/Kr+eO2oRgHWyu5lBLP3blCrBHPO1SGFrwvoYGRq8pBU17+caS24D540bGjrkqGJ+ fA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:27:05 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuG021444;
        Thu, 11 Jul 2019 14:26:57 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 23/26] KVM: x86/asi: Introduce KVM address space isolation
Date:   Thu, 11 Jul 2019 16:25:35 +0200
Message-Id: <1562855138-19507-24-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Create a separate address space for KVM that will be active when
KVM #VMExit handlers run. Up until the point which we architectully
need to access host (or other VM) sensitive data.

This patch just create the address space using address space
isolation (asi) but never makes it active yet. This will be done
by next commits.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/vmx/isolation.c |   58 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c       |    7 ++++-
 arch/x86/kvm/vmx/vmx.h       |    3 ++
 include/linux/kvm_host.h     |    5 +++
 4 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx/isolation.c b/arch/x86/kvm/vmx/isolation.c
index e25f663..644d8d3 100644
--- a/arch/x86/kvm/vmx/isolation.c
+++ b/arch/x86/kvm/vmx/isolation.c
@@ -7,6 +7,15 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/printk.h>
+#include <asm/asi.h>
+#include <asm/vmx.h>
+
+#include "vmx.h"
+#include "x86.h"
+
+#define VMX_ASI_MAP_FLAGS	\
+	(ASI_MAP_STACK_CANARY | ASI_MAP_CPU_PTR | ASI_MAP_CURRENT_TASK)
 
 /*
  * When set to true, KVM #VMExit handlers run in isolated address space
@@ -24,3 +33,52 @@
  */
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
+
+static int vmx_isolation_init_mapping(struct asi *asi, struct vcpu_vmx *vmx)
+{
+	/* TODO: Populate the KVM ASI page-table */
+
+	return 0;
+}
+
+int vmx_isolation_init(struct vcpu_vmx *vmx)
+{
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct asi *asi;
+	int err;
+
+	if (!address_space_isolation) {
+		vcpu->asi = NULL;
+		return 0;
+	}
+
+	asi = asi_create(VMX_ASI_MAP_FLAGS);
+	if (!asi) {
+		pr_debug("KVM: x86: Failed to create address space isolation\n");
+		return -ENXIO;
+	}
+
+	err = vmx_isolation_init_mapping(asi, vmx);
+	if (err) {
+		vcpu->asi = NULL;
+		return err;
+	}
+
+	vcpu->asi = asi;
+
+	pr_info("KVM: x86: Running with isolated address space\n");
+
+	return 0;
+}
+
+void vmx_isolation_uninit(struct vcpu_vmx *vmx)
+{
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+
+	if (!address_space_isolation || !vcpu->asi)
+		return;
+
+	asi_destroy(vcpu->asi);
+	vcpu->asi = NULL;
+	pr_info("KVM: x86: End of isolated address space\n");
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac3..9b92467 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -202,7 +202,7 @@
 };
 
 #define L1D_CACHE_ORDER 4
-static void *vmx_l1d_flush_pages;
+void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
@@ -6561,6 +6561,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	vmx_isolation_uninit(vmx);
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
 	free_vpid(vmx->vpid);
@@ -6672,6 +6673,10 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 
 	vmx->ept_pointer = INVALID_PAGE;
 
+	err = vmx_isolation_init(vmx);
+	if (err)
+		goto free_vmcs;
+
 	return &vmx->vcpu;
 
 free_vmcs:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b4..09c1593 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -525,4 +525,7 @@ static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
 
 void dump_vmcs(void);
 
+int vmx_isolation_init(struct vcpu_vmx *vmx);
+void vmx_isolation_uninit(struct vcpu_vmx *vmx);
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d1ad38a..2a9d073 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #include <linux/kvm_types.h>
 
 #include <asm/kvm_host.h>
+#include <asm/asi.h>
 
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
@@ -320,6 +321,10 @@ struct kvm_vcpu {
 	bool preempted;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	struct asi *asi;
+#endif
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
-- 
1.7.1

