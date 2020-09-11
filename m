Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADD12668DE
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIKTdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:33:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgIKT3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:29:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJSbHV196416;
        Fri, 11 Sep 2020 19:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=usKpguEBabkPCRPy1hUBhTm+4+t6jBApvsck91vQHks=;
 b=NucQFBY+Zni+4DETzabmy8q2E3eWYIsN7vccdOD7lxqLfm3R27jS/U5tO4AS3VuS4GGN
 1NOvXuteg/ILBE8U7337TimfaOz2O4PavIPZzgs7+W/OBqmWCESNibobeP6J4plLMcXM
 3bfb/8VXVsu7yUp95PkAFKWA/YCpbTl0oS7yYJNQMfpXDMlnpYyFGcjKoZm/ZgrfYIPF
 +likOGqlKsulOVqAm08gZrpQqqWAz/lSCts2YBkS7gFEpgUr/u8SPAPcgeNK6sVuXg1/
 SbDSLdAxuQSmccsTTmSPZ6f6rXWjmcQHoDth+a3863GBNKskXo1/LXwN1IVNrO/S7i1G SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mmg38s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 19:28:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJQUlc052956;
        Fri, 11 Sep 2020 19:26:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmm3y5b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 19:26:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BJQQ6b009922;
        Fri, 11 Sep 2020 19:26:26 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 12:26:25 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 2/4 v3] x86: AMD: Add hardware-enforced cache coherency as a CPUID feature
Date:   Fri, 11 Sep 2020 19:25:59 +0000
Message-Id: <20200911192601.9591-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a system,
it is not required for software to flush the page from all CPU caches in the
system prior to changing the value of the C-bit for a page. This hardware-
enforced cache coherency is indicated by EAX[10] in CPUID leaf 0x8000001f.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

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
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 033c112e03fc..57394fee1d35 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -41,6 +41,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
 	{ X86_FEATURE_SME,		CPUID_EAX,  0, CPUID_AMD_SME, 0 },
 	{ X86_FEATURE_SEV,		CPUID_EAX,  1, CPUID_AMD_SME, 0 },
+	{ X86_FEATURE_HW_CACHE_COHERENCY, CPUID_EAX,  10, CPUID_AMD_SME, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.18.4

