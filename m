Return-Path: <kvm+bounces-39828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D93AEA4B52B
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD94F188E602
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 22:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CE31EEA2C;
	Sun,  2 Mar 2025 22:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fC68TUyO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D481EF097
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953068; cv=none; b=EHFLHeL0jws88a8ch4n2guwjI206Jjpk91RgLroXzX7k1HiCMXxuldmlkW0HC8HUnjUJw7dZ2hx7rnWOog2gtFNA6dZPZAJlrck6q1jUb/dzwdZQMKGtWvdtsj1ANVd48SnsyluIwt6PvE0UlUBMxBS96/QOGkxA2zzcSsHyIo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953068; c=relaxed/simple;
	bh=tGGV+UTsljSgEr36IY0kRgpECQWJBjingjv6uVDKrEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilv/AI4m2wo4WqiKx7BUtxO/1ff4i7jOKsM/G3vcqo31cSRPG1e+QiQ00+OwZvXChsNRYe5ajH7Cc1kiFilRM0gPgjBEiT4E8mSky1OdApyjm+6pJlW/EgP/JfJn7dTMxzazTDb83hwQR2X2z/dTqn54tA3xACQHkMcAfDZ0JFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fC68TUyO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 522LMCJo003317;
	Sun, 2 Mar 2025 22:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=1KsyX
	tYvE8+5TYNU/WZD01B4eudxoQTw0Xy+KT0rojI=; b=fC68TUyOta7p9PisXL9H0
	2O3OetZZW3J7VRG55ZbwOTRwQPsAIlwKDmSqNsDgTFdFjBMQx+lrT4aJ+Irtc07a
	aK07sN3TL+fgnXlaYOzJPGNEq+QWHaDMFKP6hyrc6+AHKIhhWXJk52ZilpTIjPlr
	v4RNfMREXBTJHt5PKZH5ra9pECdexvQmO0CvOduiRyvGhrbMjpWJaE1OLXHl78M7
	SeeDO9AREh6d5FWLWMLOjet7qv/ubVXXc0t6kHJ3+//8J9x+/3XjorcteMzlrP8X
	Eb+J9DoRwfmEd7HMESEFWomuLrY9wlLcNJZgntc01HlxG/uFgvUgSqE3Et4PVsdG
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86hm11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 522GhEHW015706;
	Sun, 2 Mar 2025 22:03:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp803bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:28 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 522M3QoT040088;
	Sun, 2 Mar 2025 22:03:28 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp80353-3;
	Sun, 02 Mar 2025 22:03:28 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is configured
Date: Sun,  2 Mar 2025 14:00:10 -0800
Message-ID: <20250302220112.17653-3-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: -gGPgAOHi58Mdz9KevhOej3wfPapcmnp
X-Proofpoint-GUID: -gGPgAOHi58Mdz9KevhOej3wfPapcmnp

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
---
 target/i386/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b6d6167910..61a671028a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             !(env->hflags & HF_LMA_MASK)) {
             *edx &= ~CPUID_EXT2_SYSCALL;
         }
+
+        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {
+            *ecx &= ~CPUID_EXT3_PERFCORE;
+        }
         break;
     case 0x80000002:
     case 0x80000003:
-- 
2.43.5


