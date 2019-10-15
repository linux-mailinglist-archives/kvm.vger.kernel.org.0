Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41965D6C8E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfJOAlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:41:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfJOAlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:41:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0djo9007608;
        Tue, 15 Oct 2019 00:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vecuqv4EPetue9qcGGpXFHUK3lYI74uuK8qDduzgvjg=;
 b=Z3+RF4ryN4qUDXCFRx06T0NGLSGF0Ag+TBWjeEcghnJgiSwjfzODz4RCecu19cT0qsFV
 lDq0e6buExdk3B5PjyWv32P7JaBoIpRN9iZZs/fP32wFZfCltk9UfSG3ZcollLeV1L0I
 7CMMkaOTCgUvTJBkQYR5bX19/y7J2lbcrsab3PCoNEZ7ABfWPsbF3SzJciqlJRwwL9Zt
 EJ+8nloYHduNxdVkJCmgiF17FyrmvbJRh8dtuzFk81rFA3lPlKXMkFHZKsj/Kgiea49o
 iDbkrBXtcP49oLQpmfV8y3lwjZQCEkttPpzL8T7ezLOnzTOUx/hNCvOxKcrQcblAB42C Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vk68uc9sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0cKIi081021;
        Tue, 15 Oct 2019 00:40:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vkrbkvg2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9F0emD4010621;
        Tue, 15 Oct 2019 00:40:48 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:40:47 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 1/2 v2] KVM: nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area
Date:   Mon, 14 Oct 2019 20:04:45 -0400
Message-Id: <20191015000446.8099-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015000446.8099-1-krish.sadhukhan@oracle.com>
References: <20191015000446.8099-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section “VM Entries” in Intel SDM vol 3C, VM-entry checks are
performed in a certain order. Checks on MSRs that are loaded on VM-entry
from VM-entry MSR-load area, should be done after verifying VMCS controls,
host-state area and guest-state area. As KVM relies on CPU hardware to
perform some of these checks, we need to defer VM-exit due to invalid
VM-entry MSR-load area to until after CPU hardware completes the earlier
checks and is ready to do VMLAUNCH/VMRESUME.

In order to defer errors arising from invalid VM-entry MSR-load area in
vmcs12, we set up a single invalid entry, which is illegal according to
section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area of
vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry failure
due to MSR loading" after it completes checks on VMCS controls, host-state
area and guest-state area. We reflect a synthesized Exit Qualification to
our guest.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h | 15 +++++++++++++--
 arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  6 ++++++
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e76eb4f07f6c..cebdcb105ea8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3029,6 +3029,8 @@ static u8 vmx_has_apicv_interrupt(struct kvm_vcpu *vcpu)
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12);
 
+extern struct vmx_msr_entry *vmcs12_invalid_msr_load_area;
+
 /*
  * If from_vmentry is false, this is being called from state restore (either RSM
  * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
@@ -3100,12 +3102,38 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
-		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
 		exit_qual = nested_vmx_load_msr(vcpu,
 						vmcs12->vm_entry_msr_load_addr,
 						vmcs12->vm_entry_msr_load_count);
-		if (exit_qual)
-			goto vmentry_fail_vmexit_guest_mode;
+		if (exit_qual) {
+			/*
+			 * According to section “VM Entries” in Intel SDM
+			 * vol 3C, VM-entry checks are performed in a certain
+			 * order. Checks on MSRs that are loaded on VM-entry
+			 * from VM-entry MSR-load area, should be done after
+			 * verifying VMCS controls, host-state area and
+			 * guest-state area. As KVM relies on CPU hardware to
+			 * perform some of these checks, we need to defer
+			 * VM-exit due to invalid VM-entry MSR-load area to
+			 * until after CPU hardware completes the earlier
+			 * checks and is ready to do VMLAUNCH/VMRESUME.
+			 *
+			 * In order to defer errors arising from invalid
+			 * VM-entry MSR-load area in vmcs12, we set up a
+			 * single invalid entry, which is illegal according
+			 * to section "Loading MSRs in Intel SDM vol 3C, in
+			 * VM-entry MSR-load area of vmcs02. This will cause
+			 * the CPU hardware to VM-exit with "VM-entry
+			 * failure due to MSR loading" after it completes
+			 * checks on VMCS controls, host-state area and
+			 * guest-state area.
+			 */
+			vmx->nested.invalid_msr_load_exit_qual = exit_qual;
+			vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
+			vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
+			    __pa(vmcs12_invalid_msr_load_area));
+			vmx->nested.dirty_vmcs12 = true;
+		}
 	} else {
 		/*
 		 * The MMU is not initialized to point at the right entities yet and
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..bb51ec8cf7da 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 					    u32 exit_reason)
 {
+	u32 exit_qual;
 	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	struct vmx_msr_entry *addr;
 
 	/*
 	 * At this point, the exit interruption info in exit_intr_info
@@ -81,8 +83,17 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
 
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
-			  vmcs_readl(EXIT_QUALIFICATION));
+	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
+
+	addr = __va(vmcs_read64(VM_ENTRY_MSR_LOAD_ADDR));
+	if (addr && addr->index == MSR_FS_BASE &&
+	    (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
+			    EXIT_REASON_MSR_LOAD_FAIL))) {
+		exit_qual = (to_vmx(vcpu))->nested.invalid_msr_load_exit_qual;
+	}
+
+	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..7ece11322430 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7914,6 +7914,13 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
+/*
+ * This is used to set up an invalid VM-entry MSR-load area for vmcs02
+ * if an error is detected while processing the entries in VM-entry
+ * MSR-load area of vmcs12.
+ */
+struct vmx_msr_entry *vmcs12_invalid_msr_load_area = NULL;
+
 static void vmx_exit(void)
 {
 #ifdef CONFIG_KEXEC_CORE
@@ -7947,6 +7954,9 @@ static void vmx_exit(void)
 	}
 #endif
 	vmx_cleanup_l1d_flush();
+
+	if (vmcs12_invalid_msr_load_area)
+		kfree(vmcs12_invalid_msr_load_area);
 }
 module_exit(vmx_exit);
 
@@ -8012,6 +8022,14 @@ static int __init vmx_init(void)
 #endif
 	vmx_check_vmcs12_offsets();
 
+	vmcs12_invalid_msr_load_area =
+	kzalloc(sizeof(struct vmx_msr_entry), GFP_KERNEL_ACCOUNT);
+	if (!vmcs12_invalid_msr_load_area) {
+		vmx_exit();
+		return 15;
+	}
+	vmcs12_invalid_msr_load_area->index = MSR_FS_BASE;
+
 	return 0;
 }
 module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..ee7f40abd199 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -183,6 +183,12 @@ struct nested_vmx {
 	gpa_t hv_evmcs_vmptr;
 	struct kvm_host_map hv_evmcs_map;
 	struct hv_enlightened_vmcs *hv_evmcs;
+
+	/*
+	 * This field is used for Exit Qualification when VM-entry fails
+	 * due to invalid VM-entry MSR-load area in vmcs12.
+	 */
+	u32 invalid_msr_load_exit_qual;
 };
 
 struct vcpu_vmx {
-- 
2.20.1

