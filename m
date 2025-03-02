Return-Path: <kvm+bounces-39822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BD7A4B51E
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367B816C825
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 22:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850C81EF09C;
	Sun,  2 Mar 2025 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcBaXsOB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A11D5CD9
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 22:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953047; cv=none; b=SlMSQ2DC443uXi6LAyNsF8LcPaLDkN+BzHW+JoUHwwrmkhHuXzdsiV/OmeD6zeHWWwJvORZHFg6VTHPZoZqyyNv+9YqIlOdj12vWw9utA6KWHJou552QkhDc4kQz1qMFtR2gnEFFAhtDrOLoPK2AUeWqRSopXpMA3tOW5gW18/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953047; c=relaxed/simple;
	bh=0zjn1uM1ZBIP6bZfFWoDP6m3riOI8hr7WYYrbam5QLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZxTJn3No90TViILfEfXx2kObtOCNDovnQ5q0hOypRNsU72fYf706NQcEYg8nbgzGaf0J+cR34vYMIjNV/Am8yFV8a6RhbOgJ2uCRaoTryJG9vyLG7y8nomxTqPycDHojETe4c6zRkJKfKdtBZy/H1Z08MdLScu9EachhiOxA1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IcBaXsOB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 522LMCJs003317;
	Sun, 2 Mar 2025 22:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=qYamF
	w2LhUb6NZycSLPuiD4OaENsBW2PqzvkADGcg2s=; b=IcBaXsOB59pCkUwkldSz2
	XZ5w/7Cf+O8O6XOoVDO7jr7/n5D5Wkm9RULN3XuVDLph+9ItGgIT3PBzuIbIllB7
	frcCBQdMeGscRiKPSszruteaQtauqg1SvfK8VyLys4VVh7eW/yPn9Ag7b34WW/u3
	vhyK4KTPRRg+dtIw61kPyuhInQ8/2fKvhgGxFfmlA5GOCPWS2MVddkLaihAylFOH
	I6bHg3v2Gmf0Oj2oe37UJToah9M9izpRJ7fBFyygFIP4TJusJRzIMWrtDU1f3igy
	X0C1NfKCKmenpFI5m+yb1xHz17nUGqYRLO7WGlROkT/fhsFCBJJuB3gVd6Gxx2Yd
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86hm28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 522JC9kr015772;
	Sun, 2 Mar 2025 22:03:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp803fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 522M3Qoj040088;
	Sun, 2 Mar 2025 22:03:35 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp80353-11;
	Sun, 02 Mar 2025 22:03:35 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH v2 10/10] target/i386/kvm: don't stop Intel PMU counters
Date: Sun,  2 Mar 2025 14:00:18 -0800
Message-ID: <20250302220112.17653-11-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: fcG2tYD14NBusWqgi361T_u3mqxCmJm5
X-Proofpoint-GUID: fcG2tYD14NBusWqgi361T_u3mqxCmJm5

The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
these MSRs one by one in a loop, only saving the config and triggering the
KVM_REQ_PMU request. This approach does not immediately stop the event
before updating PMC.

In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
excluding runtime. Therefore, updating these MSRs without stopping events
should be acceptable.

Finally, KVM creates kernel perf events with host mode excluded
(exclude_host = 1). While the events remain active, they don't increment
the counter during QEMU vCPU userspace mode.

No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
migrate vPMU state"), because this isn't a bugfix.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/kvm/kvm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c5911baef0..4902694129 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4160,13 +4160,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         }
 
         if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
-            if (has_pmu_version > 1) {
-                /* Stop the counter.  */
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
-            }
-
-            /* Set the counter values.  */
             for (i = 0; i < num_pmu_fixed_counters; i++) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
                                   env->msr_fixed_counters[i]);
@@ -4182,8 +4175,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                                   env->msr_global_status);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
                                   env->msr_global_ovf_ctrl);
-
-                /* Now start the PMU.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
                                   env->msr_fixed_ctr_ctrl);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,
-- 
2.43.5


