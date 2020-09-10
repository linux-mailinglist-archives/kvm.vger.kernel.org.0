Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05211263A98
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 04:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgIJCfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 22:35:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730170AbgIJCWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 22:22:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2K1kn120784;
        Thu, 10 Sep 2020 02:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Im5lFzFO+oz07/AqPHuNeJRA5EHCZPkjSgrZD9h/h3o=;
 b=vUGPME/5yZ2/2JKLZysR6rPPaNglbRBuUiPH+0EfgkYC9l0QMn5LSvjK5lZySUUJVx51
 UbjhZKWCGkRoVSnhk0zwaJtfio9GCOpiVmUCWSPMgzO/N1ZQadP73BFrPHY0EM2eKlOq
 vxdTMLfsovKtnEEVF3qni51tBCYEHGkA1vdtqbVqihnEuW9zskOCH5HXKX1U8MZ+9Wlv
 0NGdP6KQSftAnRN99xvu0F8eNMLvts8JXREKi6UVqje7X2nSltbex2x5BzN7QOTsxxJU
 ZZnULbL7rbrMQuqgHGsO7opiFH4KOcs0kWvsUlKBiM6ViycmAlj0RgoWUuhi6AalLyIw eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3an5515-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:22:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2L6Sj022985;
        Thu, 10 Sep 2020 02:22:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk88weu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:22:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A2MUf2012670;
        Thu, 10 Sep 2020 02:22:30 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:22:29 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, thomas.lendacky@amd.com
Subject: [PATCH 2/3 v2] KVM: SVM: Add hardware-enforced cache coherency as a CPUID feature
Date:   Thu, 10 Sep 2020 02:22:10 +0000
Message-Id: <20200910022211.5417-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100020
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some AMD hardware platforms enforce cache coherency across encryption domains.
Add this hardware feature as a CPUID feature to the kernel.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/amd.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 81335e6fe47d..0e5b27ee5931 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -293,6 +293,7 @@
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
+#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD hardware-enforced cache coherency */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4507ededb978..698884812989 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -632,6 +632,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		 */
 		c->x86_phys_bits -= (cpuid_ebx(CPUID_AMD_SME) >> 6) & 0x3f;
 
+		if (cpuid_eax(CPUID_AMD_SME) & 0x400)
+			set_cpu_cap(c, X86_FEATURE_HW_CACHE_COHERENCY);
+
 		if (IS_ENABLED(CONFIG_X86_32))
 			goto clear_all;
 
-- 
2.18.4

