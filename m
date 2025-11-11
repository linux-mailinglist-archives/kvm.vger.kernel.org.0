Return-Path: <kvm+bounces-62712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 704B7C4BA34
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E8524EBFC6
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD48A2D5924;
	Tue, 11 Nov 2025 06:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fCxzJLwt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38E2882B6
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842022; cv=none; b=nRVtZK7weAzA3BFSznU0EiWDIbmG7AeiTzQxuUjcqYtjRBtoWSbIZ2jSuOFIbnv4eAZ3fylzEhjEpEBwKWbTddM8WvC4lMOb+xd3gv5EZTps6JoUhSLSt4mZyUaaqntpiCyndRT3J78zpx/bBghFnYGzz5Lc/NJHl4LRk4/ovUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842022; c=relaxed/simple;
	bh=8dhhTSNXXi2aM7/FnBF8pQzkYaU3DWRNkmS8JJat/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkvnTg27ExLI8sn+xLcgU0+bQLdiFxMC16S1z37WwXyBj6dpZcy2q6uwNl783ipBeU9u9B7pMq9DSDxq4A1zfYMZkMvFdZ3ECRol11BLmxjT/wJYZWNjzHXwzL5DA3E6io6UHW/JhcYFwaUkLEz8JIVW91GtH9Ry0VnWQgJ/RDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fCxzJLwt; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5iYSk024218;
	Tue, 11 Nov 2025 06:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=GO6Di
	uMe5Yf+fEiiAb+b+n0BLkryaImSvid7uRBci3Q=; b=fCxzJLwtA9QBmw6Q5ct+J
	v1H4ga9DIAjWdNBd3K6n/mgTsCWNEJyckU6aIZTR3kSPTh5f7ZGJvfhz5Fh8CYa7
	kEi6oEkr9ml/RjjLJYE51OAsv3ilPWMOd/566zfSwJYfrV6b93sbJznj1/Q3vTeq
	9AYd0qM5f9rS/jf+E1+j++PkFwnJqu2G70iylk4tazanOIJjs0pV609e779EazVL
	9G2QKr3gF3eImVcGPVFNUVTEQF20/YxLtDLeLVSEBFa+ywPdXXBe/UqKKOOQihE0
	9L8aFXfkFgS8+JTiv2glUYZ1q8kOu4FjoJciVQ8W0FUo9mJ/rEIR2S38ZZLwXvBp
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abwkar58d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:19:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB6BWG1007462;
	Tue, 11 Nov 2025 06:19:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mk9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:19:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6qj029277;
	Tue, 11 Nov 2025 06:19:53 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-2;
	Tue, 11 Nov 2025 06:19:52 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 1/9] target/i386: disable PerfMonV2 when PERFCORE unavailable
Date: Mon, 10 Nov 2025 22:14:50 -0800
Message-ID: <20251111061532.36702-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251111061532.36702-1-dongli.zhang@oracle.com>
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110047
X-Proofpoint-GUID: yfOVOj0x4w8XVagxf0LdcHT4vOLBPAPo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAyNiBTYWx0ZWRfX4T66r2FUgUoB
 lrTPfJhTgmygaLakpbHnqOvQ0cpA5iW4eGva3Ugrj6o8Mm0VHDvC8n0EO9TWRVu5ueZrCv3bHR6
 evtq3sn+9dPU6W72KT+Y3acrCnZ4CPBWqL+n5BwvJXDEBR0CKJ55ivpIpNBrmD5LgXil43hUV4p
 7hFDIoztDV5wMxIQGUJuTbNoF0Hxx48OZ1uvVldDrcNUvFRlSWKD8Gqe8wDllc2Cn2j2oxYslCj
 FGtS9Epj7Xx6h3vd+Gd4Eid9CVxrgqDQ6M7RsAKVrZvpW3LU6CUSYCIyedSOuopwSUFoCtA423r
 d9bR9/fSIAQyYBRDDb97sNKDkCZftEJu2Yj0rqWWX8Hgj+uWDWXz/2BOgoheVRDikJFIrXnp+YF
 LxY6ZK6JgSys0hLUztjIzQHGZIfJOA==
X-Proofpoint-ORIG-GUID: yfOVOj0x4w8XVagxf0LdcHT4vOLBPAPo
X-Authority-Analysis: v=2.4 cv=BMu+bVQG c=1 sm=1 tr=0 ts=6912d58a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=He110phtp1333cD8tQQA:9 a=cPQSjfK2_nFv0Q5t_7PE:22

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
index 6417775786..3653f8953e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1994,6 +1994,10 @@ static FeatureDep feature_dependencies[] = {
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
2.39.3


