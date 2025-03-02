Return-Path: <kvm+bounces-39824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5649A4B520
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 119EE16C7F5
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 22:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2127D1EEA51;
	Sun,  2 Mar 2025 22:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oofLWmuj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EEF1EB9EF
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953053; cv=none; b=ne5pfWRNTHs0TLXJf/31qnM9KU+mhMuBDjYMj91KBuqLyzKc8ZzaNuMPuQttT5diUMz+J1bBv+t5vdX7ylaDxS06WRa44gqcyyiY0JSqL3q9zrpFEZiET7X5JaNHga/Cl+LVjwudEla8C3el44GMuklXhKcBnKqd516Dw9Zu5ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953053; c=relaxed/simple;
	bh=uAgcxCFcwnF+iBEQtcKUjWZhdRq9JxzG87WGwwPjT1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgyoZYJzhl5ik0ZNNSNKmv3Zn18REH/yfUS+33gQMbVMT+Q0tdLRLxDzuybhEzMtDs0TADA4+N6sXiwAKdfi722QhuLdoWENIGHXbzWS0CZVpcblsqS4pMtmU0w41mgfVOkyXqkSXl0X1Mwy6Sfm9xdU3X13frL0EFMndrRhmh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oofLWmuj; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 522KpZXN026810;
	Sun, 2 Mar 2025 22:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=0m8tE
	jQoU7X3EBz17H0m3RUQCYEEnqfwW8rGE+cMqHA=; b=oofLWmujRvldJXnnbn621
	yd7WMOgst1ljuwZ7h0JlTzTMXgtsUxU3i440UXsRs+foKYhP6+pf1LjC9CegUSQE
	xN/+3qEXvZHdHnfsdy6ttsigV2VE6eZzYKnWbcvH6LCabdnS3skJZ8a6jCcOU5Jc
	Gwtoqw6IQ/v3agtdKkla0tIPG1eclb3svGqCxswVhkG595DjB1AQxAAwO5idZWOX
	XFIVq/eRosm99XROgn7dtPmVMqcAXPry0KQtZMVSRqV+yY9/8AC8EhgB+2qHSkOt
	sq5YsLI1Z0uKM79Nvs67mxa1PKnyr+kaVb4USbaNro9HD+D0AXULpdj5q0KPyIYz
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9q9m8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 522Kj1hf015712;
	Sun, 2 Mar 2025 22:03:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp803e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Mar 2025 22:03:33 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 522M3Qod040088;
	Sun, 2 Mar 2025 22:03:32 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp80353-8;
	Sun, 02 Mar 2025 22:03:32 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
Date: Sun,  2 Mar 2025 14:00:15 -0800
Message-ID: <20250302220112.17653-8-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: XyB4pbHP5z8kl8XyELTxQEdnGXr6-Yo2
X-Proofpoint-GUID: XyB4pbHP5z8kl8XyELTxQEdnGXr6-Yo2

There is no way to distinguish between the following scenarios:

(1) KVM_CAP_PMU_CAPABILITY is not supported.
(2) KVM_CAP_PMU_CAPABILITY is supported but disabled via the module
parameter kvm.enable_pmu=N.

In scenario (1), there is no way to fully disable AMD PMU virtualization.

In scenario (2), PMU virtualization is completely disabled by the KVM
module.

To help determine the scenario, read the kvm.enable_pmu value from the
sysfs module parameter.

There isn't any requirement to initialize 'has_pmu_version',
'num_pmu_gp_counters' or 'num_pmu_fixed_counters', if kvm.enable_pmu=N.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/kvm/kvm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e895d22f94..efba3ae7a4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -184,6 +184,10 @@ static int has_triple_fault_event;
 static bool has_msr_mcg_ext_ctl;
 
 static int has_pmu_cap;
+/*
+ * Read from /sys/module/kvm/parameters/enable_pmu.
+ */
+static bool kvm_pmu_disabled;
 
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
@@ -3256,6 +3260,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    g_autofree char *kvm_enable_pmu;
 
     /*
      * Initialize SEV context, if required
@@ -3401,6 +3406,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
 
+    /*
+     * The kvm.enable_pmu's permission is 0444. It does not change until a
+     * reload of the KVM module.
+     */
+    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
+                            &kvm_enable_pmu, NULL, NULL)) {
+        if (*kvm_enable_pmu == 'N') {
+            kvm_pmu_disabled = true;
+        }
+    }
+
     return 0;
 }
 
-- 
2.43.5


