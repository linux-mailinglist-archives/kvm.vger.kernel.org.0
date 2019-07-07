Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC5D61440
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfGGHjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:39:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGGHjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:39:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cbs8175027;
        Sun, 7 Jul 2019 07:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cmpnBUUR9fTIcWJWfDUVCDGF8nPUL3TsnNBkRK367Ok=;
 b=XNYHC/A1FBd0uwsO+RDQNOyB3r8cZRb/D3I3Cm1kNDFy+tQxfS9nNYuCZtcqXssR9rJo
 Lzz8bEH1dbXoDoqrWdPffGWSkn6H4cCyHmFwwtMiNMD/O4BAkffywfXQI0tb53Lcsm6R
 D37+YYgg2nqosUoLo3TDXm7t52JOcRubqwwy62sTjSII5IodiWrYUgV0Sdveoaj+Gu1x
 jFdrBdPPTBKM9PCjywv9MJkBLO9aQEWAOPsSi/1tfQUpPZDZ+trgYDrOEs9cbCdgvBTK
 /YjlYVljxhNritCB9viPS2dzy8zC78++kVdAOHIbRlV1U84hY0AMCr2KnbMJoob+9SDh 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qa8ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677c367119210;
        Sun, 7 Jul 2019 07:39:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tjjyjt993-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x677dMvR012633;
        Sun, 7 Jul 2019 07:39:23 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:22 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 4/5] KVM: nVMX: Skip Host State Area vmentry checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:46 -0400
Message-Id: <20190707071147.11651-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=933
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=993 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..so that every nested vmentry is not slowed down by those checks.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 48 ++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ffeeeb5ff520..b610f389a01b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2630,18 +2630,16 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
-				       struct vmcs12 *vmcs12)
+static int nested_vmx_check_host_state_full(struct kvm_vcpu *vcpu,
+					    struct vmcs12 *vmcs12)
 {
 	bool ia32e;
 
-	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0) ||
-	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
+	if (!nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
 	    !nested_cr3_valid(vcpu, vmcs12->host_cr3))
 		return -EINVAL;
 
-	if (is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu))
+	if (is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu))
 		return -EINVAL;
 
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) &&
@@ -2655,8 +2653,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
 	    vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
 	    vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
 	    vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
 	    vmcs12->host_cs_selector == 0 ||
 	    vmcs12->host_tr_selector == 0 ||
@@ -2664,11 +2660,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 #ifdef CONFIG_X86_64
-	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
+	if (is_noncanonical_address(vmcs12->host_idtr_base, vcpu))
 		return -EINVAL;
 #endif
 
@@ -2688,6 +2680,36 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if ((vmx->nested.dirty_vmcs12) &&
+	    nested_vmx_check_host_state_full(vcpu, vmcs12))
+		return -EINVAL;
+
+	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0))
+		return -EINVAL;
+
+	if (is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu))
+		return -EINVAL;
+
+	if (vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK))
+		return -EINVAL;
+
+#ifdef CONFIG_X86_64
+	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
 static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
-- 
2.20.1

