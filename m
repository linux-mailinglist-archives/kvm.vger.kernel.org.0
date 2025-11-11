Return-Path: <kvm+bounces-62716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B99BC4BA49
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EC98534E395
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA012D73B5;
	Tue, 11 Nov 2025 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d9UUXkpl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725192D24BA
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 06:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842025; cv=none; b=dgDK1vMK3tUpqrRxl5EuDJHeN/secEnS1hVvQb7eYAXUG/uUomVAOYFSOZ6gRcGATWPRVA97E/YxPpmTKeIx5cipvs8qO26TliXWC/8mkLSQ1VqKHZgP0oLokm+h44eMGdUG7Chddm/b4R82yrjHwGhO3XsgIizUnGqp9CnXfVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842025; c=relaxed/simple;
	bh=71Sf0pz2SgKDJYniMLq6x9xBcWr8UoC3jczpPj91oE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY9CYan467B/HnjDNwN9Y8WBXSUQgXCXYoJwHZ1ZW31SY7DUprdLjbTdS5hoVw7nRw+8rMFALEND6cQB0whfOdrxv4rLvWVdoMpEEWANGXwjCUtjIjFuWkM5+AQg2YuF4YTvwCBIB0Hvbb1roV+AQDhR1YCijSts6FN0UJh82t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d9UUXkpl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB68EI6001041;
	Tue, 11 Nov 2025 06:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2deag
	evKAnTw8QdOvgqpHGJYSKDO5JNyiKn9kTS3xyE=; b=d9UUXkplqeDCvlKDY4/UE
	RVyAnRie8vvrJOcVSWLuApZ7sq1btvxRBmxPe7jDxTjfWZIMdcXBPdvuc/c7a2FX
	6iyLVPxRqX7LXKRbjyv/+o+F3hKOLOhYHEWFDcbmSvj2KhmpFoiYTHJX4ZyvCCx/
	sPucK7v5KRwm4152+BJJ3BBEYqYV/01gZUCn0+tDXxvZdhgXl2UcOlzUy3qXsCpQ
	gWO2eAzFIeGLxAEIEqU9SqnDEmUmOeAtZYMpKteGGOLQqUws1Nws01BR5+coMXPu
	XNtiojo43JZv3Ja8lTTKz/fR+mKIvkN90aI32QHXAEkqWzqCKgXZlRUiVUGrplxW
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abxrt82py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:19:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB4v36q007397;
	Tue, 11 Nov 2025 06:19:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9mka6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 06:19:55 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AB6C6ql029277;
	Tue, 11 Nov 2025 06:19:54 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va9mk84-3;
	Tue, 11 Nov 2025 06:19:54 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v7 2/9] target/i386: disable PERFCORE when "-pmu" is configured
Date: Mon, 10 Nov 2025 22:14:51 -0800
Message-ID: <20251111061532.36702-3-dongli.zhang@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=c7+mgB9l c=1 sm=1 tr=0 ts=6912d58c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=ljiX_LIxqC18hRgHw8cA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: Hu8qkhj9Ngxw7NZWFoKWcddzrzaKQjNn
X-Proofpoint-ORIG-GUID: Hu8qkhj9Ngxw7NZWFoKWcddzrzaKQjNn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAzNyBTYWx0ZWRfX/zPWvxYIoJlt
 i1RhC6BMyA2fGssWMOs7OcYGNn73YPxiWWswDjs5mf7QyP8/Onj4ytsGNMPsaJElLALawBXQZyP
 LDudB3hzM7IAc4+p/MiDh8wOJ5WWXvqt2qIbJX0AlT4qtUzLmJtBVnYew1e9Ah+dvQ5S267rxMr
 ojIZjgTs7l8eXpWNnCta61K0LDYzhvifRSvQ9CetYSuzmoRNp0wM4l3nBeF6GdIzLagaF7wJpRt
 he/7IEnKu7FZCfxiTWj5GlMXR09HrEYgzSM224dkskWmtIuX7IoWgWD7lZV5UcjrE/ZsE4Oo8Ux
 N796rZQkSrMay0W1R0pB2e9tEj/mGd8uoiC0seCey0oVPhmCKinzQyJ9yMz+Td+CXZGIHchA6M7
 CHbYACWn6TxXgfTAWSfAcQUmB93P1g==

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
index 3653f8953e..4fcade89bc 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8360,6 +8360,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
2.39.3


