Return-Path: <kvm+bounces-50458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 210DFAE5E57
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D2601B642A5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CF7254B09;
	Tue, 24 Jun 2025 07:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eRSYXyfi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0867A221FC3
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751372; cv=none; b=ln1pVgohw41A5saicGE9ybjpuziwXW/QHzeIdqWmzyWuXgrHBbb7J/9+pAY/bdR9eyj0EiNW8UvTHUKc6fog9rUf+Xu6sbdulLsmSuq6E8+w8Y3UkIs60TwJHxyFJd4ay9lEsJpnOcGXeGyV2Ni5xr5dZ/bShnnZjNtbOHWEHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751372; c=relaxed/simple;
	bh=GMmgH/C3dqBImnDwjPaXIXWM/um/xrS0xzw+G+eOMrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3ujyhKanHaEBWJdK92svPSiWtv+S+KKGImyVkcjjKg0GmazwIwOazdJThEGtRrANcspO2yrf5IVNq2B9x9kzDUYsAxIwHEwOCAmkj73W6MM1DZDq9UOdNxOt7TPHzQqdF2k2lx9L9+pIHXLS+7sIxb4vqElFmMTxQdB5hTY3Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eRSYXyfi; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7fZtY017392;
	Tue, 24 Jun 2025 07:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=j87T5
	hbCtjwElKW/Ya/lVxUUs+MLBpntekxXbDCehEo=; b=eRSYXyfimcISFrs/OeLQQ
	yp3+2Q2Ln6PpKW4LSxPnGkgGI616s3girWjvsExpic1fzUc2yVCDSO0cyQlCYv5i
	R5xKFzfEO/61n4FyP3WLQYu3MxZXKUlQqppCWf+sfVZtM55y54DEoeDYu83mVheV
	jxHsTqPq7r64kXrgVwb9HvX2v5ytCjd8SXok9+4LmwfWbYNnrbDDo+hVTSI+34X6
	AcmN1xz2W+VwCr8UBBokIozlOIZ+/r6sKiGhYzl4a0KqM4U03W2PyAmMUicnHDPB
	zStpj30n6upcT3hVqZDVvWhlDp5JMEtaaKn3L8nuE1g/F/0E0RL+pInBH/6755nT
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7bcxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O6TAM5008158;
	Tue, 24 Jun 2025 07:49:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3ar32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:08 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55O7n5Xk006279;
	Tue, 24 Jun 2025 07:49:07 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq3ar1g-3;
	Tue, 24 Jun 2025 07:49:07 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v6 2/9] target/i386: disable PERFCORE when "-pmu" is configured
Date: Tue, 24 Jun 2025 00:43:21 -0700
Message-ID: <20250624074421.40429-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250624074421.40429-1-dongli.zhang@oracle.com>
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_02,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240066
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA2NiBTYWx0ZWRfX4aFXi6IFA4Sb kQXqKewL0CGHTrRQVvME4ETFnxjQsCGlAtsLnQ0BQOF1bcJdPC5AZoP4Xsdn4zM5cw0EbSm9h6t OnOiGrF9XQmK2RAGPFsvp/5bJCLwt3Zquxl35eshrKnYwBv6YjpOTQMsQuz21Tz3X753DJfSAO+
 depZr3IFTIQ8GmPsXw/Bdj+OmeV+QpxaV8TtPUfYfIslFgXFwjFvNmQfK0hyNfzFgJabYVJAhSA vi0hF7ffruAIWWzaqaDUfoSDBF0QwOFaSbvfM6b3U59bEvvetOPvhTYxexv9TnnG/JFym5xUety 42kPylYTS2IJm8nzwD4mmu+I+sHiVLwzNGzcE+8AqnUMls4dOT4SJV5dSH3xmLaBbPQDuYBz/mQ
 18bGfSn7FShUpVa8jsI1qUtHSIUJn/QwOEYmyxLB6A9wTjDLmLRATp457E36oRQyBH4PvSRS
X-Proofpoint-GUID: gVeLL2SRRdkn0_2Un3ixBvR-49bv4uwy
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685a5875 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8 a=0hacFnLdYK-0wtQaQsEA:9
X-Proofpoint-ORIG-GUID: gVeLL2SRRdkn0_2Un3ixBvR-49bv4uwy

Currently, AMD PMU support isn't determined based on CPUID, that is, the
"-pmu" option does not fully disable KVM AMD PMU virtualization.

To minimize AMD PMU features, remove PERFCORE when "-pmu" is configured.

To completely disable AMD PMU virtualization will be implemented via
KVM_CAP_PMU_CAPABILITY in upcoming patches.

As a reminder, neither CPUID_EXT3_PERFCORE nor
CPUID_8000_0022_EAX_PERFMON_V2 is removed from env->features[] when "-pmu"
is configured. Developers should query whether they are supported via
cpu_x86_cpuid() rather than relying on env->features[] in future patches.

Suggested-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
Changed since v2:
  - No need to check "kvm_enabled() && IS_AMD_CPU(env)".
Changed since v4:
  - Add Reviewed-by from Sandipan.

 target/i386/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 21494816d4..50757123eb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7768,6 +7768,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             !(env->hflags & HF_LMA_MASK)) {
             *edx &= ~CPUID_EXT2_SYSCALL;
         }
+
+        if (!cpu->enable_pmu) {
+            *ecx &= ~CPUID_EXT3_PERFCORE;
+        }
         break;
     case 0x80000002:
     case 0x80000003:
-- 
2.43.5


