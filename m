Return-Path: <kvm+bounces-50460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A828AE5E59
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E08171B64441
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D672571A0;
	Tue, 24 Jun 2025 07:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dUXoohAq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4AE23E336
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750751374; cv=none; b=DROxfaPJtBlbKywQzgx8QyOd6FY0A0Tvm3jMh0RcY/zdMigJcB6+0ELU8LOrJ5ZxI6cFJlqSGwLAaW5Gk/pmj+T8VL3eUAF80cnw6gA3u6TXqOdr6G831OV5OnTMTl7j4h6LYUYBKaSc/miJIxGMQq2u9SqzLaqM5yv+O72Ce3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750751374; c=relaxed/simple;
	bh=UvuureSKTwlKjn6Asq+f88i9HnZAt6mspiM99SjwtAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSB4B23BADz6SWm3aXWA8p6tps0eWQ0n7+EV9Ol8GEpWgmm+3z1zYrcpti9z+hQ3Iu6NZN4zWoAhWMzdMKIllwvDQWcsB4WUcoHZcAlpOSK481h1YcwjMsWjQnomk/og6qq7jjUuJY6qJf4Jr8WLHh8ppQk2CcX9DlyBtWQjT+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dUXoohAq; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7ffV6010205;
	Tue, 24 Jun 2025 07:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=MJZis
	hDpgpaSxw5cNGh9XrMCLDkdsDpqJ1CRZm8YqzA=; b=dUXoohAq6P6y7EBWGBBG3
	4CEJ3lK/xMJA9Y47lngk0IB7U0JmmZ3Umjel6tlQpSLJVfb0Ow6buTjD60NLiLO9
	5OewKYr6itCiuU/ZPpI/b2ZLKJoumsasM8OkkK8oPKpI7XjmrugALm0ue/8YDchU
	K8ys8RYxyD5JOahoQqEccMNCQSHZvBNFb03V0dzB2EOLw9APP8oWKJQTyr66IrbS
	M09AvmKHDIpE/98HaRX/HeoThTRfjvs9g5Rpd890JRZDIVMTfpOjhVRCYUYCsHM/
	ZkpEzaGxCAfJKDVSyuaDOfgr7CtBNeqJTS1iwIaxAt3r6vbaPdbkGUvv20Kpui0A
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt1bcbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7W8HV005631;
	Tue, 24 Jun 2025 07:49:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3ar2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 07:49:07 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55O7n5Xi006279;
	Tue, 24 Jun 2025 07:49:06 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq3ar1g-2;
	Tue, 24 Jun 2025 07:49:06 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v6 1/9] target/i386: disable PerfMonV2 when PERFCORE unavailable
Date: Tue, 24 Jun 2025 00:43:20 -0700
Message-ID: <20250624074421.40429-2-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: 75eLXVljPSDzqjN09xUffxg-OOojDoL2
X-Proofpoint-ORIG-GUID: 75eLXVljPSDzqjN09xUffxg-OOojDoL2
X-Authority-Analysis: v=2.4 cv=cpebk04i c=1 sm=1 tr=0 ts=685a5875 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8 a=He110phtp1333cD8tQQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA2NiBTYWx0ZWRfX2gi1eFZrK1p3 +2oH2e8Pxi5i2xjX7ksZxz9/r42jjKpGqdQqkFDrMvnWTYFLhU4SnTAixfCNLYS00cV8sHdL3Ur Tu1fLNocGMCiejttUnf4sEDDMA/QXjGw8qauCHAT/AM4bSIFHDlO1jDNi35GwC9YOiFoxQDdQyq
 8nx1V6t5JW4h6haSWW3ClBAJBQoZROmPix+jVOIx9ZuHoa3Xmn+L3YPa7J8B2kpmJaUAD0rTIOu 1MXzCCab8gBG+Kt7LSkf2mvFnUYm6vkjvMzJV0XUFdoVOpbb09pRWwYiiJDOcHIKpqH/kaXMpxn WSUfhfYdIZAZmlnicDfTFpt/u6J942eSrC9FWIW0KDmRfIyF61sOz6fy9OIhOuXfyYfhtj5bOb9
 jZZWsJR2Ow2SZMectjkvaHXbhmZ/Zh67f+jIu5zuC38qNwqG8Mvlc9OIJf+npc3EFT4UfiPO

When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
reflected in in guest dmesg.

[    0.285136] Performance Events: AMD PMU driver.

However, the guest CPUID indicates the PerfMonV2 is still available.

CPU:
   Extended Performance Monitoring and Debugging (0x80000022):
      AMD performance monitoring V2         = true
      AMD LBR V2                            = false
      AMD LBR stack & PMC freezing          = false
      number of core perf ctrs              = 0x6 (6)
      number of LBR stack entries           = 0x0 (0)
      number of avail Northbridge perf ctrs = 0x0 (0)
      number of available UMC PMCs          = 0x0 (0)
      active UMCs bitmask                   = 0x0

Disable PerfMonV2 in CPUID when PERFCORE is disabled.

Suggested-by: Zhao Liu <zhao1.liu@intel.com>
Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
Changed since v1:
  - Use feature_dependencies (suggested by Zhao Liu).
Changed since v2:
  - Nothing. Zhao and Xiaoyao may move it to x86_cpu_expand_features()
    later.

 target/i386/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0d35e95430..21494816d4 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1855,6 +1855,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
         .to = { FEAT_24_0_EBX,              ~0ull },
     },
+    {
+        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
+        .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 },
+    },
 };
 
 typedef struct X86RegisterInfo32 {
-- 
2.43.5


