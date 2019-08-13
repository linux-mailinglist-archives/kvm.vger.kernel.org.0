Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22D8B9C6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbfHMNOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:14:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbfHMNOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:14:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DDEDFC005370
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=rQ7ZGzZta+4JepumBiOviY1wdInhUYE2cYNNLgGe0UI=;
 b=Ozi+sN3yuhDv+ylUPYojNYEvg6qm9iyRj0+XC3MSfXgmJ9PcR0Ei19QZ7yXEXHnkhjui
 PU0DcRNI7u8urIVOv/X/STVVqiyrVLcpIOOoPbhVQJWlvoU49fxb8PRyPJYu0sHWSU3N
 RjwWvsUk09WHQC7RD1DpZjLNzAycVBFHhH1jLgIZBdro14W4rCKpXtFZmzs5mAWpI7/D
 3w4cr6yj2E0e4H/4VTlVcBsg+4FtiHkC+1cxOYPfmW6Im1mFS8dOP5y/jV1hIBfMh1OP
 cV6/a1G7fu4GyqoYBAvH9daQ8GpPpZT5K3KgxGHiPcWToFstALvvk8DEXa2wH7VtFSVg Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqe4c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:14:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DD8QE2159827
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:14:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ubwrg0cgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:14:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DDE7mK010053
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:14:07 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 06:14:07 -0700
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: nVMX: Check that HLT activity state is supported
Date:   Tue, 13 Aug 2019 16:13:03 +0300
Message-Id: <20190813131303.137684-1-nikita.leshchenko@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fail VM entry if GUEST_ACTIVITY_HLT is unsupported. According to "SDM A.6 -
Miscellaneous Data", VM entry should fail if the HLT activity is not marked as
supported on IA32_VMX_MISC MSR.

Usermode might disable GUEST_ACTIVITY_HLT support in the vCPU with
vmx_restore_vmx_misc(). Before this commit VM entries would have succeeded
anyway.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 16 ++++++++++++----
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46af3a5e9209..3165e2f7992f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2656,11 +2656,19 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 /*
  * Checks related to Guest Non-register State
  */
-static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
+static int nested_check_guest_non_reg_state(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
-	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
-	    vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT)
+	switch (vmcs12->guest_activity_state) {
+	case GUEST_ACTIVITY_ACTIVE:
+		/* Always supported */
+		break;
+	case GUEST_ACTIVITY_HLT:
+		if (!nested_cpu_has_activity_state_hlt(vcpu))
+			return -EINVAL;
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -2710,7 +2718,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
 		return -EINVAL;
 
-	if (nested_check_guest_non_reg_state(vmcs12))
+	if (nested_check_guest_non_reg_state(vcpu, vmcs12))
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..4a294d3ff820 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -123,6 +123,11 @@ static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.msrs.misc_low & VMX_MISC_ZERO_LEN_INS;
 }
 
+static inline bool nested_cpu_has_activity_state_hlt(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->nested.msrs.misc_low & VMX_MISC_ACTIVITY_HLT;
+}
+
 static inline bool nested_cpu_supports_monitor_trap_flag(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.msrs.procbased_ctls_high &
-- 
2.20.1

