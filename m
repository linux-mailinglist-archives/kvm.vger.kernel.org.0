Return-Path: <kvm+bounces-43492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2DBA90E1A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 23:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A8F97A522D
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7F124A059;
	Wed, 16 Apr 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WQYFbBtH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E9234966
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840682; cv=none; b=L+51C3ecZUYABveqs9mlxEm4A0rn1ebgDJcifsnr8ZIf0Urf2Xvtejmm7hAjstzyArge5FybiiLSwKPLjCImsmIRCEDChemVFnY5fJfwiQTXNFAPAU2xVYtIruAhbJ0lOy82RAjGf1q/UvA6Fh92FZBbt15ndy/+i6I0e8bT0LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840682; c=relaxed/simple;
	bh=wvh615J8/P7uVN4R1bJKS3O0GKCAgPn8BN+ZRB7kQ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umfZ3z7Aok6hYV4Ah9m92SKcv3GBmojLUADPKOglRPeovMF5EZaWu/kqkbZVm/i0Zs0CEwh5O1P/95MQajgfyIIP/ShjV0YAAYp4j0jknAtJs8s+X6SPHUrK5k28hORI31H72L80LViybebF0F/hzzNYQWw4JrxLHWMZzSHbTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WQYFbBtH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLNCqs025168;
	Wed, 16 Apr 2025 21:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=rTtC5
	HX+LFK2aqM+GF1UaLiudQLeAADMm0hU7G6YEPw=; b=WQYFbBtHSlbhwZhRQeXsy
	lnNuL2mijQ8eJ5ggW7z+4WfYekgtuIWLuuOK/7Rl8oOzRvjbX/Tx9kAk9UMVAxFs
	2pMzNNStF4Z34GlKGpLbGnx006/LVtnEuubDsStynES7rXpEvjErDt4ON3Q8MIgi
	XkSj1qL0E1mvV1XLcNVJFwGpZg1etoWU2EILMyJNbu8Wdx39JlyKJH95pOV5nv+S
	WVSSC/ky6WWmRVnLMTCq9C5pmwMcBcBGog/nmC04SqnAlaG9bKwlSo81fNbhA05u
	Kkv8w/yoPxT9J0GpuXgE+rVjw7f2cDdY/XPqyqwj/bPV1NclaMlqas3jEFIxSkT0
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4616uf5acv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53GK1BOt005662;
	Wed, 16 Apr 2025 21:57:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5xhvf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 21:57:05 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53GLv1qQ036583;
	Wed, 16 Apr 2025 21:57:03 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 460d5xhvcp-2;
	Wed, 16 Apr 2025 21:57:03 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, kraxel@redhat.com,
        berrange@redhat.com
Subject: [PATCH v4 01/11] [DO NOT MERGE] i386/cpu: Consolidate the helper to get Host's vendor
Date: Wed, 16 Apr 2025 14:52:26 -0700
Message-ID: <20250416215306.32426-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250416215306.32426-1-dongli.zhang@oracle.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_08,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160177
X-Proofpoint-GUID: PtTCavTn841i6Bel1apKzzDvO2A0KHHl
X-Proofpoint-ORIG-GUID: PtTCavTn841i6Bel1apKzzDvO2A0KHHl

From: Zhao Liu <zhao1.liu@intel.com>

Extend host_cpu_vendor_fms() to help more cases to get Host's vendor
information.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
This patch is already queued by Paolo.
https://lore.kernel.org/all/20250410075619.145792-1-zhao1.liu@intel.com/
I don't need to add my Signed-off-by.

 target/i386/host-cpu.c        | 10 ++++++----
 target/i386/kvm/vmsr_energy.c |  3 +--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 3e4e85e729..072731a4dd 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -109,9 +109,13 @@ void host_cpu_vendor_fms(char *vendor, int *family, int *model, int *stepping)
 {
     uint32_t eax, ebx, ecx, edx;
 
-    host_cpuid(0x0, 0, &eax, &ebx, &ecx, &edx);
+    host_cpuid(0x0, 0, NULL, &ebx, &ecx, &edx);
     x86_cpu_vendor_words2str(vendor, ebx, edx, ecx);
 
+    if (!family && !model && !stepping) {
+        return;
+    }
+
     host_cpuid(0x1, 0, &eax, &ebx, &ecx, &edx);
     if (family) {
         *family = ((eax >> 8) & 0x0F) + ((eax >> 20) & 0xFF);
@@ -129,11 +133,9 @@ void host_cpu_instance_init(X86CPU *cpu)
     X86CPUClass *xcc = X86_CPU_GET_CLASS(cpu);
 
     if (xcc->model) {
-        uint32_t ebx = 0, ecx = 0, edx = 0;
         char vendor[CPUID_VENDOR_SZ + 1];
 
-        host_cpuid(0, 0, NULL, &ebx, &ecx, &edx);
-        x86_cpu_vendor_words2str(vendor, ebx, edx, ecx);
+        host_cpu_vendor_fms(vendor, NULL, NULL, NULL);
         object_property_set_str(OBJECT(cpu), "vendor", vendor, &error_abort);
     }
 }
diff --git a/target/i386/kvm/vmsr_energy.c b/target/i386/kvm/vmsr_energy.c
index 31508d4e77..f499ec6e8b 100644
--- a/target/i386/kvm/vmsr_energy.c
+++ b/target/i386/kvm/vmsr_energy.c
@@ -29,10 +29,9 @@ char *vmsr_compute_default_paths(void)
 
 bool is_host_cpu_intel(void)
 {
-    int family, model, stepping;
     char vendor[CPUID_VENDOR_SZ + 1];
 
-    host_cpu_vendor_fms(vendor, &family, &model, &stepping);
+    host_cpu_vendor_fms(vendor, NULL, NULL, NULL);
 
     return g_str_equal(vendor, CPUID_VENDOR_INTEL);
 }
-- 
2.39.3


