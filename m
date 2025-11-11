Return-Path: <kvm+bounces-62720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F874C4BA55
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F141234E87C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E682D839E;
	Tue, 11 Nov 2025 06:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="afqfaflZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630652D7805
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842028; cv=none; b=tEmd/urJKOO6We7aDUiecXMuJHwSSXSrGWWZ0JIXYbnLWxqwqOLNpLjZHgV4Oatp688sj32tNG9Ogv85SXUD7EqYOC3vaE6HT0hfMPeKxOcT8KFWjZ+etlhdUMAlwn2djfsroUYpGelhKL7Uwlrih4QtDO1+jgEFZEMLdFNorBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842028; c=relaxed/simple;
	bh=hklp8k3vCs8qAvGdbHaR+MQTpXuKOGRarVJqZuShxOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyNydPXGaInpk6vws/yVBH63UG0w7bR2b//6ixub4BdUp9VSLQYPy+Wni61o0u69DcZwHQBKSWgdiLne9PPqaH8ZtZr/up4hZM2Q5LjZTWoowQs3z4QIeAn+ulIR5y4FKgRRq0WUGyb77H3YdYHJFpjRm8Sxah25jX7i4/GBpjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=afqfaflZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB68EI8001041;
	Tue, 11 Nov 2025 06:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vOa3O
	0dowZ7B+SXuKhootqsWVoB6Ku5f0N3qcBEwP3s=; b=afqfaflZdpQdS3BpNltJR
	ZWSOSQRcxDwAl/El3nXiuW4Gtjc/kur/D7TEQjqrIBvJ8L3lHWWfNdQlbxD4bOo6
	gn7N0UyDYtWA5Rz2K7bFvzRoQwv9e1XR7jmiFa9vGBnATf3BmyxKaD/ooY/JXrx0
	wJcf8hrHxQ3I77zasD34n7ZwDIvdUcO2RMNreLiRuaP6NUsLD92fsFXQWB/o+O7z
	xm2OIaN3vj3JQdlRJr+MuJ2YlGWCi2dd62qL5UkWBkX48DJ9xiUQiph7ojmxLvS3
	/VVokBz7XoiEKRfexSQxzGlNAACYkupjbb4Qyt+Z8UBz8fBKr5WF7PSpFMkJh57H
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abxrt82q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB51YH3007485;
	Tue, 11 Nov 2025 06:20:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mkeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:20:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6r1029277;
	Tue, 11 Nov 2025 06:20:02 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-10;
	Tue, 11 Nov 2025 06:20:02 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 9/9] target/i386/kvm: don't stop Intel PMU counters
Date: Mon, 10 Nov 2025 22:14:58 -0800
Message-ID: <20251111061532.36702-10-dongli.zhang@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=c7+mgB9l c=1 sm=1 tr=0 ts=6912d593 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=A3X0-5CtyMG_TZ3YDawA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: BYFQM3QWp1zg9QQetq0jN3TAyQiGpIK2
X-Proofpoint-ORIG-GUID: BYFQM3QWp1zg9QQetq0jN3TAyQiGpIK2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAzNyBTYWx0ZWRfXxVqqfR43JXih
 5DJYzk7bUayrJf9ZbOgHOViXKF/tnrGfaNaJfZWaut6ANQxGGx1cqQ2gXbc3DhZYFLswgu81cLx
 Uua38HQomTlDNrb3OnP1+Ioi1F8bBzXdSnlAPL1AhmqPcy8Un1igBJh+o5DssLrjn+mer4+WH6i
 jl/Iq4gJGjr8ozY0xzDkHfoD4nhxIJFpMf/Kyey+W3J+Zhw7b1mH1ynngjz1R0cFiLVXlwDTFWH
 KTk6+7KwaqsfTOazib7na3Ri/5H5XQCA8hBgny/LINq+SD5SjhXDnh036saZWHeAwlddetACyWa
 LdMvwF3LM/AwH13JNU2pM7dwwKn79cluKKYFiOVym2A3q9qaGYZa0XsUNlEZAyAX68xbFdKZv8l
 dLhTuL+azuhrvCzvcmdcystHWy1/Bg==

PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
excluding runtime. Therefore, updating these MSRs without stopping events
should be acceptable.

In addition, KVM creates kernel perf events with host mode excluded
(exclude_host = 1). While the events remain active, they don't increment
the counter during QEMU vCPU userspace mode.

Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
processes these MSRs one by one in a loop, only saving the config and
triggering the KVM_REQ_PMU request. This approach does not immediately stop
the event before updating PMC. This approach is true since Linux kernel
commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
kvm_pmu_handle_event"), that is, v6.2.

No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
migrate vPMU state"), because this isn't a bugfix.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
Changed since v3:
  - Re-order reasons in commit messages.
  - Mention KVM's commit 68fb4757e867 (v6.2).
  - Keep Zhao's review as there isn't code change.
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/kvm/kvm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5258023fe7..d0df53807f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4213,13 +4213,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
         }
 
         if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
-            if (pmu_version > 1) {
-                /* Stop the counter.  */
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
-            }
-
-            /* Set the counter values.  */
             for (i = 0; i < num_pmu_fixed_counters; i++) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
                                   env->msr_fixed_counters[i]);
@@ -4235,8 +4228,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                                   env->msr_global_status);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
                                   env->msr_global_ovf_ctrl);
-
-                /* Now start the PMU.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
                                   env->msr_fixed_ctr_ctrl);
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,
-- 
2.39.3


