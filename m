Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCAE1D47F6
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgEOIRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 04:17:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgEOIRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 04:17:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F6HPZH067429;
        Fri, 15 May 2020 06:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=vIWcjKr3Hp+eKqElLLlfr4wJStdIyecKEB+daQEXgr0=;
 b=qZEe2MZ1rC8tBhTDoBGz72pPU82Z39TqQa14dTY89rZ5ksqOLwvaHGrx++xoENmZETNe
 SgbWblxPYCbl6x2Fpdo7RNYS1XGhuOfa+/bo5Qu8Bf9cj10+H5hCeXTHUWveuvzdVwkw
 rTFDIjPfYsV43wb6XCGr7zggKavYk+suQ3cPQl+pKoXYt1sRyFuHqw6qk2wQklW08K3+
 iS9Ggj7JM5kv0er51tticmhuKfdfbWuUqMaPzA6Mb9eW09/CSzEVYfPG6tBNV7NV2g9b
 9vaM3WmXFoJZYIM9E941u2IiIa6HjatLmtJcjrE05GhfzOHGVXAmRkL57nRIch4uGFR7 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwqsnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 06:18:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F68Cns139397;
        Fri, 15 May 2020 06:16:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3100ye571y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 06:16:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F6Gilu026688;
        Fri, 15 May 2020 06:16:44 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 23:16:44 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
Date:   Fri, 15 May 2020 01:36:07 -0400
Message-Id: <20200515053609.3347-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150053
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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/x86.c              | 24 ++----------------------
 arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
 4 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d..e2d9e4b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -820,6 +820,8 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	u64 guest_cr4_reserved_bits;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1f..38954b1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -129,6 +129,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+	vcpu->arch.guest_cr4_reserved_bits =
+	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9..afba830 100644
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
+	if (cr4 & vcpu->arch.guest_cr4_reserved_bits)
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

