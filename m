Return-Path: <kvm+bounces-30478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B9A9BAFFF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8F5C1C214EA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39A81AF0AB;
	Mon,  4 Nov 2024 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UsR1EPUS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5B1AE00B
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713363; cv=none; b=ceI9nFQBiMdmtBu9Vazgt7ProIj4OFmvmgixkJO9GYqG8bqS1WHS0oClwNrCqheuby8AhbUVETzM4fOn4z7uFbfjwj1E2MvaQcDhph6CbBikgTvZgbyyPQdA/qEBTv5caMN5sPRUqjhWgTDzguEy0orCj3TMKknVRJZOChVP9vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713363; c=relaxed/simple;
	bh=V1T6VnzpgRbi81RVeZpGze5jHLndYByubh/jhZMPz4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpXo/3voG+t2S0vLY+MXqi6IoYSEA4IpbpewmaOUfN98T2RUKbb99l/glif6KMIeHh+gXgZETUzC46mKSmRX1bm0xll52J2GmRjzdfp+DiUbTD7xPGDRPJ/ZAnJ2u1kcbob+6LGZPdqoDo3TyZdB3ktUnLGJJ1Gu1/h52rPRiKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UsR1EPUS; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48fj4H012809;
	Mon, 4 Nov 2024 09:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=8dj9+
	Fj2Y7+fcJzsYZdCfnhnZ64eJxfakPqpai/l9Oc=; b=UsR1EPUSgMA/8T3Uj4kdO
	IOMuRDOvkNtmec6hplYuqak/t05nN03z2SzN7ywRj462Mmg63oZ3g7VWZDBwtG3E
	fFNgIyI0SNSM5X5RjlrWki5kWOLZEDfMIsaDlityqtvuJoamNgBYvmJSvv6Nqkew
	6AEiuTWyABosn7lJ+mXuhOKiEXLgK+2W+hx5Cb6ePcnN8Jtm4CLuQxm+6Y1lihu8
	72BnNJe1ctP1YUXea5AmSXlgRUv2sweKIARO6AjWrIIAmJmSVLrp9jNS68HKD4cR
	EyzZ5AsU7KMp1SkB+R9VLNIn0tIGgVH2wVndFLkYFyBeWsBasnS9XmbwKFMVWpjz
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nanytbxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A48fZlX009108;
	Mon, 4 Nov 2024 09:41:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbt090-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Nov 2024 09:41:54 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A49fqfe018519;
	Mon, 4 Nov 2024 09:41:54 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nahbt06k-2;
	Mon, 04 Nov 2024 09:41:53 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
Subject: [PATCH 1/7] target/i386: disable PerfMonV2 when PERFCORE unavailable
Date: Mon,  4 Nov 2024 01:40:16 -0800
Message-ID: <20241104094119.4131-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241104094119.4131-1-dongli.zhang@oracle.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_07,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411040085
X-Proofpoint-ORIG-GUID: Q3sRATBTcJgcGAcqpnTcqUfqFtcCcV9-
X-Proofpoint-GUID: Q3sRATBTcJgcGAcqpnTcqUfqFtcCcV9-

When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
reflected in in guest dmesg.

[    0.285136] Performance Events: AMD PMU driver.

However, the guest cpuid indicates the PerfMonV2 is still available.

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

Disable PerfMonV2 in cpuid when PERFCORE is disabled.

Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3baa95481f..4490a7a8d6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7103,6 +7103,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *eax = *ebx = *ecx = *edx = 0;
         /* AMD Extended Performance Monitoring and Debug */
         if (kvm_enabled() && cpu->enable_pmu &&
+            (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) &&
             (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
             *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
             *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
-- 
2.39.3


