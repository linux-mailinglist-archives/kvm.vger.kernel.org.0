Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1616D6C8B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfJOAlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:41:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfJOAlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:41:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0dAGt191753;
        Tue, 15 Oct 2019 00:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0I2k6FB3uBHFdpui75oVdPHRK9NH6HqLle1VdcfJBPQ=;
 b=MGLaNfCvwqGXULL1hjQ12Mz37w2e4n3bdUuVGUadTvOIcGkTnPaQatOqD+JiuVVBtN3j
 zZk9DHE6kHWExTnVkUk6C3+Mqjt68T+wJeeFOGuPnh2FbDzCzmuxJ8MT5MQK0WFwD69E
 HP5fGU7GKuDl6v+/yBt+w1HbI1B87oy2/WiDuApTg7OANs9QKz7OiXj9NaKBqlpOBytq
 oKh+OW3vcUGlkqHM4E6DYCzJALk53Wr7dbW4t1auIpR4xN/VTcQFhPUs8jGJphN3Etj6
 QQCtQkj/vhk7v/iQLjmsejBYEaITH9CpdGw/Gq4kWYzoaIjkwKjnJK61HS+YPSSzBbE0 Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vk7fr4559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0bZL4057087;
        Tue, 15 Oct 2019 00:40:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vks07sehs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F0emHV031333;
        Tue, 15 Oct 2019 00:40:48 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:40:48 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 2/2 v2] KVM: nVMX: Rollback MSR-load if VM-entry fails due to VM-entry MSR-loading
Date:   Mon, 14 Oct 2019 20:04:46 -0400
Message-Id: <20191015000446.8099-3-krish.sadhukhan@oracle.com>
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

If VM-entry fails due to VM-entry MSR-loading, the MSRs of the nested guests
need to be rolled back to their previous state in order for the guest to not
be in an inconsistent state.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 50 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/nested.h | 26 +++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h    |  8 +++++++
 3 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cebdcb105ea8..bd8e7af5c1e5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -191,7 +191,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
+void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
 {
 	/* TODO: not to reset guest simply here. */
 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -894,11 +894,13 @@ static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
  * as possible, process all valid entries before failing rather than precheck
  * for a capacity violation.
  */
-static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
+static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count,
+			       bool save)
 {
 	u32 i;
 	struct vmx_msr_entry e;
 	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	for (i = 0; i < count; i++) {
 		if (unlikely(i >= max_msr_list_size))
@@ -917,6 +919,16 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
+		if (save) {
+			vmx->nested.vm_entry_msr_load_backup[i].index = e.index;
+			if (kvm_get_msr(vcpu, e.index,
+			    &(vmx->nested.vm_entry_msr_load_backup[i].data))) {
+				pr_debug_ratelimited(
+					"%s cannot read MSR (%u, 0x%x)\n",
+					__func__, i, e.index);
+				goto fail;
+			}
+		}
 		if (kvm_set_msr(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
@@ -926,6 +938,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	}
 	return 0;
 fail:
+	kfree(vmx->nested.vm_entry_msr_load_backup);
 	return i + 1;
 }
 
@@ -973,6 +986,26 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return 0;
 }
 
+int nested_vmx_rollback_msr(struct kvm_vcpu *vcpu, u32 count)
+{
+	u32 i;
+	struct msr_data msr;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	for (i = 0; i < count; i++) {
+		msr.host_initiated = false;
+		msr.index = vmx->nested.vm_entry_msr_load_backup[i].index;
+		msr.data = vmx->nested.vm_entry_msr_load_backup[i].data;
+		if (kvm_set_msr(vcpu, msr.index, msr.data)) {
+			pr_debug_ratelimited(
+					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
+					__func__, i, msr.index, msr.data);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	unsigned long invalid_mask;
@@ -3102,9 +3135,18 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
+		u32 count = vmcs12->vm_entry_msr_load_count;
+
+		/* Save guest MSRs before we load them */
+		vmx->nested.vm_entry_msr_load_backup =
+		    kcalloc(count, sizeof(struct msr_data), GFP_KERNEL_ACCOUNT);
+		if (!vmx->nested.vm_entry_msr_load_backup)
+			goto vmentry_fail_vmexit_guest_mode;
+
 		exit_qual = nested_vmx_load_msr(vcpu,
 						vmcs12->vm_entry_msr_load_addr,
-						vmcs12->vm_entry_msr_load_count);
+						vmcs12->vm_entry_msr_load_count,
+						true);
 		if (exit_qual) {
 			/*
 			 * According to section “VM Entries” in Intel SDM
@@ -3940,7 +3982,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmx_update_msr_bitmap(vcpu);
 
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
-				vmcs12->vm_exit_msr_load_count))
+				vmcs12->vm_exit_msr_load_count, false))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
 }
 
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index bb51ec8cf7da..f951b2b338d2 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,6 +17,8 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
+void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator);
+int nested_vmx_rollback_msr(struct kvm_vcpu *vcpu, u32 count);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
@@ -66,7 +68,6 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 {
 	u32 exit_qual;
 	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	struct vmx_msr_entry *addr;
 
 	/*
 	 * At this point, the exit interruption info in exit_intr_info
@@ -85,11 +86,24 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 
 	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
 
-	addr = __va(vmcs_read64(VM_ENTRY_MSR_LOAD_ADDR));
-	if (addr && addr->index == MSR_FS_BASE &&
-	    (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
-			    EXIT_REASON_MSR_LOAD_FAIL))) {
-		exit_qual = (to_vmx(vcpu))->nested.invalid_msr_load_exit_qual;
+	if (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
+			    EXIT_REASON_MSR_LOAD_FAIL)) {
+
+		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+		struct vmx_msr_entry *addr;
+
+		if (nested_vmx_rollback_msr(vcpu,
+					    vmcs12->vm_entry_msr_load_count)) {
+			nested_vmx_abort(vcpu,
+					VMX_ABORT_SAVE_GUEST_MSR_FAIL);
+
+			kfree(to_vmx(vcpu)->nested.vm_entry_msr_load_backup);
+		}
+
+		addr = __va(vmcs_read64(VM_ENTRY_MSR_LOAD_ADDR));
+		if (addr && addr->index == MSR_FS_BASE)
+			exit_qual =
+			    (to_vmx(vcpu))->nested.invalid_msr_load_exit_qual;
 	}
 
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ee7f40abd199..9a7c118036be 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -189,6 +189,14 @@ struct nested_vmx {
 	 * due to invalid VM-entry MSR-load area in vmcs12.
 	 */
 	u32 invalid_msr_load_exit_qual;
+
+	/*
+	 * This is used for backing up the MSRs of nested guests when
+	 * those MSRs are loaded from VM-entry MSR-load area on VM-entry.
+	 * If VM-entry fails due to VM-entry MSR-loading, we roll back
+	 * the MSRs to the values saved here.
+	 */
+	struct msr_data *vm_entry_msr_load_backup;
 };
 
 struct vcpu_vmx {
-- 
2.20.1

