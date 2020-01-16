Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3CB13D18A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgAPBbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 20:31:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgAPBbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 20:31:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1UkNb051201;
        Thu, 16 Jan 2020 01:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=h6hKM2858almYGlayqdY4gPzaV9oHrE0gFn9bFNB5O8=;
 b=SOhhfxqcYP/T31b1aVJXLUIwjKWmQ5BPO2/oh9sKU84fNbsy0jjKb8uOHCEkLTHpPHo1
 4KioxiUbhcGiocn0hRwSBKvZkk3vmXzTkFBUlIjvUmu+w3NtEAPnhislYE5cZP11yXUZ
 o9N/9pq5nJkYxxuFCY0DccqHob7nDSXwU9LiU6tEe4fbTfbdXnhowp7W/r02CvTXigoO
 KWZmgS393+t9QNldg1UwApEpMKe6fPAFCLgZGrHuCh1zWKCq8RTP5V7B143lB3usg4e6
 6G0DhsrE69OfqrVIzDNSLo3nokQtO48fV7/QdSZqUDwBiPLiJA8Lp4r3bSjP9KQhFET0 fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sfnkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:31:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1UgmU015692;
        Thu, 16 Jan 2020 01:31:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xj1as85yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:31:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G1VWuh019780;
        Thu, 16 Jan 2020 01:31:32 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 17:31:32 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2 v3] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
Date:   Wed, 15 Jan 2020 19:54:32 -0500
Message-Id: <20200116005433.5242-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116005433.5242-1-krish.sadhukhan@oracle.com>
References: <20200116005433.5242-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
    field must be 0.

In KVM, GUEST_DR7 is set prior to the vmcs02 VM-entry by kvm_set_dr() and the
latter synthesizes a #GP if any bit in the high dword in the former is set.
Hence this field needs to be checked in software.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 arch/x86/kvm/x86.c        | 2 +-
 arch/x86/kvm/x86.h        | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..a5ee49ab75d5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2899,6 +2899,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
+	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
+		return -EINVAL;
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
index 29391af8871d..db42692bb209 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -369,6 +369,12 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
+static inline bool kvm_dr7_valid(unsigned long data)
+{
+	/* Bits [63:32] are reserved */
+	return !(data >> 32);
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 
-- 
2.20.1

