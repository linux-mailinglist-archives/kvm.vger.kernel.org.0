Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A51CBC11
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 03:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgEIBR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 21:17:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51026 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgEIBR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 21:17:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0491DlLB179111;
        Sat, 9 May 2020 01:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=P5OT0dElPxTY+wegEjp0z6l3XfLXM2labOkeNgvtY64=;
 b=BY/Ft8PZW1z0RzTZHlDbfKx5yYenikZ1+QwaABGLke/JfRqV/5j/ez9xMQz2wnrpMfBw
 IvqWzGix++dYjir5ggVNhHb/9jwx/4zI2V/6mhJ/rSoMEqUM5NDNfB6xAL9C5b4o6Al0
 bU1TkxmC0hst/+ZX95BrSpLDOFPKAtJjJjK8bq0IzLSH0dYxBLFJ1IblPQgPJVXg8/5h
 TRXBFjffpBBnV+1EkO2eVkRb4aSn4VPDbXrb2oAHVQfT1EYCEdGIil8kdkpq5ZiTxTa1
 rWsHCZqYIGvW/FYCUarERaMzMlmYEjtWnajL55E3gynozIwjvugu7hEaPAGMNLziFShn rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30vtepnw2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04917cB1048349;
        Sat, 9 May 2020 01:17:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30vte1p7tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0491HM4O009186;
        Sat, 9 May 2020 01:17:22 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 18:17:22 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3 v2] KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
Date:   Fri,  8 May 2020 20:36:50 -0400
Message-Id: <20200509003652.25178-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
References: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090008
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
 arch/x86/kvm/cpuid.c |  3 +++
 arch/x86/kvm/x86.c   | 24 ++----------------------
 arch/x86/kvm/x86.h   | 21 +++++++++++++++++++++
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1f..c4e4e87 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -54,6 +54,8 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 
 #define F feature_bit
 
+extern u64 __guest_cr4_reserved_bits;
+
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -129,6 +131,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+	__guest_cr4_reserved_bits = __cr4_reserved_bits(guest_cpuid_has, vcpu);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9..6030d65 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -96,6 +96,7 @@
 #endif
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __guest_cr4_reserved_bits;
 
 #define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
 #define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
@@ -905,27 +906,6 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
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
 static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 {
 	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
@@ -944,7 +924,7 @@ static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
 
-	if (cr4 & __cr4_reserved_bits(guest_cpuid_has, vcpu))
+	if (cr4 & __guest_cr4_reserved_bits)
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc..3a7310f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -359,4 +359,25 @@ static inline bool kvm_dr7_valid(u64 data)
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 
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

