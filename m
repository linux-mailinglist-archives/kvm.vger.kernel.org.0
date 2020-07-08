Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29705217C52
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 02:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgGHAkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 20:40:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgGHAkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 20:40:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680XL2S010826;
        Wed, 8 Jul 2020 00:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0iUB2O6X7+UYwxeAX/7qOrcotrFGN8i4A5AJlqKomiw=;
 b=aipl0ZlzIMQjF9vu5nvS2ijn7qWhbQzDKQth2BBaKMonUVOQ+U7zaU83ESMQ5W0ltlo8
 d0yZiF1boWH1IsOOemmAGe8tFxaNkFr1u6yr1lBBuW5qjQUMCCvSM5gPtFw/WIysbll2
 lFqmqriucmw0yJsWA0xFDF579rQBQK7Y52L6rBxmXZTOQalkQe7UY283CEHc8atV945a
 L+Gg4+4nMiLF2BeuvXzX0L6cutJIpReI6PB1W4V52GWGmxPk+vUcBPT+5nSpDw5/YiGJ
 04Necb/C52xxCl9LpTfqpsBC/cIBR04dCobV9IPBSBdBbkv4FD9cjglZ84/lG6GCGWR4 Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 323sxxuuqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 00:40:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680YFOS022330;
        Wed, 8 Jul 2020 00:40:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233py1sy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 00:40:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0680e5PQ007326;
        Wed, 8 Jul 2020 00:40:05 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 17:40:05 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3 v4] KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
Date:   Wed,  8 Jul 2020 00:39:55 +0000
Message-Id: <1594168797-29444-2-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of creating the mask for guest CR4 reserved bits in kvm_valid_cr4(),
do it in kvm_update_cpuid() so that it can be reused instead of creating it
each time kvm_valid_cr4() is called.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/x86.c              | 24 ++----------------------
 arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
 4 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b..06eb426 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -580,6 +580,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
+	unsigned long cr4_guest_rsvd_bits;
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9..5bec182 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -128,6 +128,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+	vcpu->arch.cr4_guest_rsvd_bits =
+	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f..f0335bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -97,6 +97,7 @@
 #endif
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __guest_cr4_reserved_bits;
 
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
@@ -931,33 +932,12 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-#define __cr4_reserved_bits(__cpu_has, __c)		\
-({							\
-	u64 __reserved_bits = CR4_RESERVED_BITS;	\
-							\
-	if (!__cpu_has(__c, X86_FEATURE_XSAVE))		\
-		__reserved_bits |= X86_CR4_OSXSAVE;	\
-	if (!__cpu_has(__c, X86_FEATURE_SMEP))		\
-		__reserved_bits |= X86_CR4_SMEP;	\
-	if (!__cpu_has(__c, X86_FEATURE_SMAP))		\
-		__reserved_bits |= X86_CR4_SMAP;	\
-	if (!__cpu_has(__c, X86_FEATURE_FSGSBASE))	\
-		__reserved_bits |= X86_CR4_FSGSBASE;	\
-	if (!__cpu_has(__c, X86_FEATURE_PKU))		\
-		__reserved_bits |= X86_CR4_PKE;		\
-	if (!__cpu_has(__c, X86_FEATURE_LA57))		\
-		__reserved_bits |= X86_CR4_LA57;	\
-	if (!__cpu_has(__c, X86_FEATURE_UMIP))		\
-		__reserved_bits |= X86_CR4_UMIP;	\
-	__reserved_bits;				\
-})
-
 static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
 
-	if (cr4 & __cr4_reserved_bits(guest_cpuid_has, vcpu))
+	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e9..bac8b30 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -366,4 +366,25 @@ static inline bool kvm_dr7_valid(u64 data)
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 
+#define __cr4_reserved_bits(__cpu_has, __c)             \
+({                                                      \
+	u64 __reserved_bits = CR4_RESERVED_BITS;        \
+                                                        \
+	if (!__cpu_has(__c, X86_FEATURE_XSAVE))         \
+		__reserved_bits |= X86_CR4_OSXSAVE;     \
+	if (!__cpu_has(__c, X86_FEATURE_SMEP))          \
+		__reserved_bits |= X86_CR4_SMEP;        \
+	if (!__cpu_has(__c, X86_FEATURE_SMAP))          \
+		__reserved_bits |= X86_CR4_SMAP;        \
+	if (!__cpu_has(__c, X86_FEATURE_FSGSBASE))      \
+		__reserved_bits |= X86_CR4_FSGSBASE;    \
+	if (!__cpu_has(__c, X86_FEATURE_PKU))           \
+		__reserved_bits |= X86_CR4_PKE;         \
+	if (!__cpu_has(__c, X86_FEATURE_LA57))          \
+		__reserved_bits |= X86_CR4_LA57;        \
+	if (!__cpu_has(__c, X86_FEATURE_UMIP))          \
+		__reserved_bits |= X86_CR4_UMIP;        \
+	__reserved_bits;                                \
+})
+
 #endif
-- 
1.8.3.1

