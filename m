Return-Path: <kvm+bounces-39826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1679DA4B529
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F2F73B0336
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 22:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112201EF0A5;
	Sun,  2 Mar 2025 22:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FTaYZBjk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA21EEA3E
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 22:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953066; cv=none; b=JfYOfLkjDWoOYhIxSRmp08R/pL16lFQYvEwceH1WX55pUrDhensXxqoxvw4R4+CklQsykv8uxp7HPalJ3EMD2Iie5aFjTuXyUZdJJ45NLUAu2tQVAXnzXviQLyWDFfiF0zkdNBI8Q5I1X9vZ6YsKo3H/cPZVVjrWW3sAMWNLT7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953066; c=relaxed/simple;
	bh=xVLLAlRTPQupBGseHXSU/QaNL9kCCUoO4wARiFJ2Z2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCMU1oTHkoUHFNVBy4NklAFYo0z0/vIIb465AqjCNdC/vQnnKWFJCtuvF3z7e4VCqFg56On6yg9VhJ2VC1mDz4YPgoHH3bdntWI61BZnYm1RGUrk4UbUpZHfMLCGDItajB1Bf1uDr1b65M2jeLL4NZyXj4QSE5Tij1rO3YoLXFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FTaYZBjk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 522LIDbr001114;
	Sun, 2 Mar 2025 22:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=LKOZC
	tvRhD4G6ccnjL2iVGG3lLyMFdAXnn/UB+bsEts=; b=FTaYZBjkngQyaWt9t8ytK
	iMvfPx7SQ0Kojrqmz0ffwT3btPACEFwK0sZKAceTxEXKNILABBK9ghdQMxG6LJPr
	MMS0GOMS3FCe80/FTbdWVCNP5OIamHPowkkb6m1DcVitHhtVj6yse2NBwOOILgY6
	4yGfQciDAH8SkyqTQaJWtE1tGZNjpzRPZCaZQZB3uvn07Y8lqBDeS7a7f0Vrfbk5
	QD5Vp+xxKlwcsV8caCF7svbP2p28t4xz6whj2AqDuFCODrVZflaUjZZ1IMQs5H9K
	LkKVcVqKeTrtNVLCRRTrcE49/w1Wegy/xkngGBB2TMnaIGF9jVyWclN2GRe3MFa0
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9q9m8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 522Il31j019954;
	Sun, 2 Mar 2025 22:03:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp803bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:27 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 522M3QoR040088;
	Sun, 2 Mar 2025 22:03:27 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp80353-2;
	Sun, 02 Mar 2025 22:03:27 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE unavailable
Date: Sun,  2 Mar 2025 14:00:09 -0800
Message-ID: <20250302220112.17653-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250302220112.17653-1-dongli.zhang@oracle.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-02_06,2025-02-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503020180
X-Proofpoint-ORIG-GUID: R8zPBqmS0msg89Mj2P2iOQdqFp4IupWV
X-Proofpoint-GUID: R8zPBqmS0msg89Mj2P2iOQdqFp4IupWV

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
---
Changed since v1:
  - Use feature_dependencies (suggested by Zhao Liu).

 target/i386/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 72ab147e85..b6d6167910 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1805,6 +1805,10 @@ static FeatureDep feature_dependencies[] = {
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


