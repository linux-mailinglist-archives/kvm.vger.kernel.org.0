Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D232F73E5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKKMbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:31:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKMbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:31:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCTIo6001066;
        Mon, 11 Nov 2019 12:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=y5IbTY0zPQAGPlQkmYbHFi2WMLbgX2KQDZ2dnldOKpU=;
 b=CeyJjVJNNma6+gvYLYxSB3YpkDFDGedaIlh+jwjhkjbVdh8mdy+aYn/wUe1bgpIa6sI9
 dLGBjgOkktYM2LGMLaSleS1xpV+eYl70m4BzPOUMtazeC1FzaCkGxTKlw2TWxgpFYD6f
 w+eevSdmx/TNBNCd7uJmd+G16arP1Itc0QwxKJ6qaPypPUtjZz6ken9ySpo+6nATc3Gg
 zMUF7ROVnrtkCQ9/cJtkosl/Lyh1hBVzMWywo0cvy/7KU+7KbixlYwfhb56pkB94M+l2
 SkaiP4lhODSiUKfDCGkcPFRK52d+6fYSlpFwxXP9UNo+qSAQ5Ll4mmQz9hDmvJMvn8f+ yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qencd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCSF9P015097;
        Mon, 11 Nov 2019 12:31:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66yx82ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:10 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCV9Xc026864;
        Mon, 11 Nov 2019 12:31:09 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 04:31:08 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed L1 TPR
Date:   Mon, 11 Nov 2019 14:30:55 +0200
Message-Id: <20191111123055.93270-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191111123055.93270-1-liran.alon@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=743
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=812 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L1 don't use TPR-Shadow to run L2, L0 configures vmcs02 without
TPR-Shadow and install intercepts on CR8 access (load and store).

If L1 do not intercept L2 CR8 access, L0 intercepts on those accesses
will emulate load/store on L1's LAPIC TPR. If in this case L2 lowers
TPR such that there is now an injectable interrupt to L1,
apic_update_ppr() will request a KVM_REQ_EVENT which will trigger a call
to update_cr8_intercept() to update TPR-Threshold to highest pending IRR
priority.

However, this update to TPR-Threshold is done while active vmcs is
vmcs02 instead of vmcs01. Thus, when later at some point L0 will
emulate an exit from L2 to L1, L1 will still run with high
TPR-Threshold. This will result in every VMEntry to L1 to immediately
exit on TPR_BELOW_THRESHOLD and continue to do so infinitely until
some condition will cause KVM_REQ_EVENT to be set.
(Note that TPR_BELOW_THRESHOLD exit handler do not set KVM_REQ_EVENT
until apic_update_ppr() will notice a new injectable interrupt for PPR)

To fix this issue, change update_cr8_intercept() such that if L2 lowers
L1's TPR in a way that requires to lower L1's TPR-Threshold, save update
to TPR-Threshold and apply it to vmcs01 when L0 emulates an exit from
L2 to L1.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 arch/x86/kvm/vmx/vmx.c    | 6 +++++-
 arch/x86/kvm/vmx/vmx.h    | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2c4336ac7576..9197f6631c02 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2075,11 +2075,13 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 	if (exec_control & CPU_BASED_TPR_SHADOW)
 		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
+	else {
+		vmx->nested.l1_tpr_threshold = -1;
 #ifdef CONFIG_X86_64
-	else
 		exec_control |= CPU_BASED_CR8_LOAD_EXITING |
 				CPU_BASED_CR8_STORE_EXITING;
 #endif
+	}
 
 	/*
 	 * A vmexit (to either L1 hypervisor or L0 userspace) is always needed
@@ -4113,6 +4115,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
+	if (vmx->nested.l1_tpr_threshold != -1)
+		vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
 
 	if (kvm_has_tsc_control)
 		decache_tsc_multiplier(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d5742378d031..c4667631a14f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6020,7 +6020,11 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		return;
 
 	tpr_threshold = ((irr == -1) || (tpr < irr)) ? 0 : irr;
-	vmcs_write32(TPR_THRESHOLD, tpr_threshold);
+
+	if (is_guest_mode(vcpu))
+		to_vmx(vcpu)->nested.l1_tpr_threshold = tpr_threshold;
+	else
+		vmcs_write32(TPR_THRESHOLD, tpr_threshold);
 }
 
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..43331dfafffe 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -167,6 +167,9 @@ struct nested_vmx {
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
 
+	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
+	int l1_tpr_threshold;
+
 	u16 vpid02;
 	u16 last_vpid;
 
-- 
2.20.1

