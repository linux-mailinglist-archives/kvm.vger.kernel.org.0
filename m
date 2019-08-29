Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69A1A28D8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfH2VZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:25:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfH2VZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:25:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLOZG7165754;
        Thu, 29 Aug 2019 21:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=wVDqbmLrKTAkpRjeNGztEjifnnn+iGuNAymJH5EX+6I=;
 b=Q16FXCFq0kqzmQnFl11IbQ27oaTjay6BnlnLEIzlZWliszxeWLznKVKfIZMFzmx35O2P
 F9hGe4f+OWmEv8ZzswgE+wnperewQVvlMsXmMvxSqAHiMfpLYX3srwGKR621sS0tKA5a
 RZ13ok1UdXyIBKKHfHTEE9faGJWFvzvcLjJi8bli7O/V57l9guH0UW6im+ks7/EzyNNr
 +g1ob2iHOgVUi12EQstR+HQsVVl2zisNddFxOhl/crItm40ir9OBPyQqA3Ed3afmHAxq
 etuqFhI4laSzFzrgIVJUOnBY3EOpuRX63b7oXPZkOXQU8QlMJho1/QI6gVLPXa6RXKkn mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uppjc00fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE5Xo085106;
        Thu, 29 Aug 2019 21:25:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uphaub0fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLPIBF032402;
        Thu, 29 Aug 2019 21:25:18 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:25:17 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/4] KVM: nVMX: Check GUEST_DEBUGCTL on vmentry of nested guests
Date:   Thu, 29 Aug 2019 16:56:32 -0400
Message-Id: <20190829205635.20189-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=800
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=870 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    If the "load debug controls" VM-entry control is 1, bits reserved in the
    IA32_DEBUGCTL MSR must be 0 in the field for that register. The first
    processors to support the virtual-machine extensions supported only the
    1-setting of this control and thus performed this check unconditionally.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 arch/x86/kvm/x86.h        | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46af3a5e9209..0b234e95e0ed 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2677,6 +2677,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    !nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
+	    !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
 	    !kvm_pat_valid(vmcs12->guest_ia32_pat))
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0868c5..28ba6d0c359f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -354,6 +354,12 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
+static inline bool kvm_debugctl_valid(u64 data)
+{
+	/* Bits 2, 3, 4, 5, 13 and [31:16] are reserved */
+	return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
+}
+
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 
-- 
2.20.1

