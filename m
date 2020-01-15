Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD513B76A
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 03:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAOCEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 21:04:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgAOCEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 21:04:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F24AwO128822;
        Wed, 15 Jan 2020 02:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=6H9u2kI6yMrdKSYVmi8MqUhkawKVcWvg3aeFPBpRT7Y=;
 b=B1Je07QsSyACO68IbShuP00NAJkFRyHaHm4gfAv84+B3ZQjFSLCQlWhZpC0mnXEU6agc
 2IJpOWqKe/YwI3hGLbujRl0uWmT5uZ3+CietXhSXy4ThojmuBHhIXO6KEioMUfAUZcqv
 TgrJec5jajA0h9hBA/XqWvweb95IIpjyu92yT+CaNLVCK+RMHm1Pao4AtT9PhXYyLYQ/
 ta4Y6iBXwj5U3x9meqkZgy+saJd1qn78CbMsT3U5OhTydpJ0Mqwo7ckBJqLmU5yfr9te
 /ajsRo6gw8h9WhXVVeenSOIkboGjQKScSfoylYHcYjHQ4HY6vaeTX+OCoI6a3KpbO22X EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf73yhn9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:04:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F24Acf055356;
        Wed, 15 Jan 2020 02:04:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xh8et4bep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:04:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00F22tiq031586;
        Wed, 15 Jan 2020 02:02:55 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jan 2020 18:02:55 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2 v2] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
Date:   Tue, 14 Jan 2020 20:25:40 -0500
Message-Id: <20200115012541.8904-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
References: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150017
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
    field must be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 arch/x86/kvm/x86.c        | 2 +-
 arch/x86/kvm/x86.h        | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..acde8a2f13e2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2899,6 +2899,12 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+#ifdef CONFIG_X86_64
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
+	    !kvm_dr7_valid(vmcs12->guest_dr7))
+		return -EINVAL;
+#endif
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..220f20a2f9c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1064,7 +1064,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 5:
 		/* fall through */
 	default: /* 7 */
-		if (val & 0xffffffff00000000ULL)
+		if (!kvm_dr7_valid(val))
 			return -1; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 29391af8871d..76cd389ecf60 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -369,6 +369,12 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
+static inline bool kvm_dr7_valid(u64 data)
+{
+	/* Bits [63:32] are reserved */
+	return ((data & 0xFFFFFFFF00000000ull) ? false : true);
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 
-- 
2.20.1

