Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC774A28D9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfH2VZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:25:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfH2VZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:25:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLOCbH165604;
        Thu, 29 Aug 2019 21:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=CjsTvUqr/aEL36sSx5xNLBb6eDa8TipRoEZi0oanNi8=;
 b=l6XpE3hCdaP9WnWHje45VW4qE/QSJbv43EoCAiR7IVBmLKmAub+TqihY4zSRlrLY3OOO
 8IRqu/8JDbjCgj9MkQqH/T5NCPQdKijzZhXCctbRYoGh2aNRimg8pzYbB08bS7RqtjLK
 KncJs2pknGXtjj7dS+QQUXDWjpmG2dKtiK5+WzLC7Mx1v7N13jpiw4iqAoV9ZQp0kCZJ
 DKIAYT78t6m6WkPFYHpdAdsJkCbY49zvdxC633dw6PF9fV3Nk7efDCvC1kwWV2Wk7Pzq
 KH+e6crN42iyQqPT68fX7Hak2OeMO8LzC2v6Xwf8XhbFnXoe22qEnzkWPXJnJjPZ98Mt TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uppjc00fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE3Xw187002;
        Thu, 29 Aug 2019 21:25:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2upkrfft1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLPIuF027460;
        Thu, 29 Aug 2019 21:25:18 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:25:18 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
Date:   Thu, 29 Aug 2019 16:56:33 -0400
Message-Id: <20190829205635.20189-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
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
index 0b234e95e0ed..f04619daf906 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2681,6 +2681,12 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
 		return -EINVAL;
 
+#ifdef CONFIG_X86_64
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
+	    !kvm_dr7_valid(vmcs12->guest_dr7))
+		return -EINVAL;
+#endif
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    !kvm_pat_valid(vmcs12->guest_ia32_pat))
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fafd81d2c9ea..423a7a573608 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1051,7 +1051,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 5:
 		/* fall through */
 	default: /* 7 */
-		if (val & 0xffffffff00000000ULL)
+		if (!kvm_dr7_valid(val))
 			return -1; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 28ba6d0c359f..4e55851fc3fb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -360,6 +360,12 @@ static inline bool kvm_debugctl_valid(u64 data)
 	return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
 }
 
+static inline bool kvm_dr7_valid(u64 data)
+{
+	/* Bits [63:32] are reserved */
+	return ((data & 0xFFFFFFFF00000000ull) ? false : true);
+}
+
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 
-- 
2.20.1

