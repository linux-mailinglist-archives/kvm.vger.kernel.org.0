Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D575B5A71B
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 00:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfF1Wmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 18:42:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1Wmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 18:42:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMZdZR191382;
        Fri, 28 Jun 2019 22:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=ikiiUCMnRLkkMtQKbWZaLO5TTicWlc1Rzs7QIAUVo8w=;
 b=evOz1Wfpi3Le+qBknFzpVwU8wObX8s5om09f4P5pMg96fbnWCDm5235zxMgDg+QILfaI
 Fzj0NqlEypW5Wyv119JIhd4RZ650V4+adQR7B32/J764yXiTSjDiobsJhdoyPOZYpQl4
 sJ2y27YnUShJxFUPQiFEiwpMqXwmx0R9dxfdIryb91mmWwzVC490+eUyv/qZWk6sMY65
 z0dJcljNbJ3MtHJuzKcKfSbbW8yXqNV6bA2zxC2vRj5tb37CtVOYIr4mslMR8vrRuGhW
 HWJnDiqYK4VH4ABNAq6S8eMLImm4acWR02f9ITiHehHQ9Thss+eINf0E9UGyJ8NL2toP 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t9c9q7rfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:42:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMgVMq117908;
        Fri, 28 Jun 2019 22:42:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7e68ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:42:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SMgfhw001272;
        Fri, 28 Jun 2019 22:42:41 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 15:42:41 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] KVM nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests
Date:   Fri, 28 Jun 2019 18:14:46 -0400
Message-Id: <20190628221447.23498-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
References: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=683
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=736 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280259
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Host Segment and Descriptor-Table
Registers" in Intel SDM vol 3C, the following checks are performed on
vmentry of nested guests:

   - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
     RPL (bits 1:0) and the TI flag (bit 2) must be 0.
   - The selector fields for CS and TR cannot be 0000H.
   - The selector field for SS cannot be 0000H if the "host address-space
     size" VM-exit control is 0.
   - On processors that support Intel 64 architecture, the base-address
     fields for FS, GS and TR must contain canonical addresses.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..856a83aa42f5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2609,6 +2609,30 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    !kvm_pat_valid(vmcs12->host_ia32_pat))
 		return -EINVAL;
 
+	ia32e = (vmcs12->vm_exit_controls &
+		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
+
+	if (vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
+	    vmcs12->host_cs_selector == 0 ||
+	    vmcs12->host_tr_selector == 0 ||
+	    (vmcs12->host_ss_selector == 0 && !ia32e))
+		return -EINVAL;
+
+#ifdef CONFIG_X86_64
+	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
+	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
+		return -EINVAL;
+#endif
+
 	/*
 	 * If the load IA32_EFER VM-exit control is 1, bits reserved in the
 	 * IA32_EFER MSR must be 0 in the field for that register. In addition,
@@ -2616,8 +2640,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	 * the host address-space size VM-exit control.
 	 */
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER) {
-		ia32e = (vmcs12->vm_exit_controls &
-			 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
 		if (!kvm_valid_efer(vcpu, vmcs12->host_ia32_efer) ||
 		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LMA) ||
 		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LME))
-- 
2.20.1

