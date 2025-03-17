Return-Path: <kvm+bounces-41189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F41A648EB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9E16188AEC6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42647231CB1;
	Mon, 17 Mar 2025 10:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FXlfs7l4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA1A230995;
	Mon, 17 Mar 2025 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206161; cv=none; b=K6OUoUceKaLUK1bwVTfXFYya9gvwRbZqHQLZtqWgsmbGxMNRYF+3eQyfuKw7WjFvQFpGxzutm6rWdIg1K5dMANpOSfj293r2rV/YRN23AdpITjWIQLAzHBTZRh6MEc5/GREQG+CvMWY69YSmwn2ZTt67ZD3I8F9e/KyJvOSrPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206161; c=relaxed/simple;
	bh=2LBYUIWNFVQDPF+G/B5jsebHw8jZjcyk8/3xlrhCj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ+HtaX4RnoyY5m/sHxQqco8jB9N8wpPNWiuEve5B2rGqT41qIaiAdl5eoAGyOktXg82g0hHKOtHlOycs3dDlAnX1OVD+V4HQNsqBH3ZK+UUgNUateX8rkURj4HHZmpO3k+jERYgwRFmiZ6mH/Yw9DCzk/XTijSNC9CVVpEb/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FXlfs7l4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52H53ndZ003801;
	Mon, 17 Mar 2025 10:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hzY6pBErvPjpCB1au
	lfw3qwDd32oSpMBhxUNkWEaqHM=; b=FXlfs7l4n5WTrw9v+xijFyJ20R5FLNxJ9
	PQ65Qc5KVsJamOuTwPOUeHBwCpavQ3iqh8wwDgLSWcZg4XyF8hF/cE1iJsUf9yej
	uzZeCY2M3YOHhsh+4XunSXt/Z7zD9j8kU3HyAIeRzPYa+iYZRUXf99HqGu8v3AFY
	FpHvgDr9ipu3Cw6mCISQNOPLGJ0bQ3Xe9gJLbGUmyzhXhxrKVIK373VSdq4GJ60J
	uxJe/QKCW68X8w49j99GxGwiDTCUsM0wwbzjQrlhxwHwxUqNLk5ipWhh54IymAf9
	6hnUSuJDUIs4GjNKRi+ymvN2kMakoHGxd8hXifC3ox3Xt+KZIGDTA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45e02nup9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:10 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52H9oCo7017789;
	Mon, 17 Mar 2025 10:09:09 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45e02nup9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52H9ckvl001076;
	Mon, 17 Mar 2025 10:09:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dp3kdb6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52HA95fF56492504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 10:09:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45E9520104;
	Mon, 17 Mar 2025 10:09:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1395B20101;
	Mon, 17 Mar 2025 10:09:01 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.208.110])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 17 Mar 2025 10:09:00 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 17 Mar 2025 15:39:00 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: [PATCH v5 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
Date: Mon, 17 Mar 2025 15:38:31 +0530
Message-ID: <20250317100834.451452-5-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250317100834.451452-1-vaibhav@linux.ibm.com>
References: <20250317100834.451452-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3vPQgM2ecupPLwc68C1eZPZCug9RKGrI
X-Proofpoint-GUID: ndt679HswBhqDVnjNhO8SxyI5nwN9rQA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_03,2025-03-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503170069

Introduce a new PMU named 'kvm-hv' inside a new module named 'kvm-hv-pmu'
to report Book3s kvm-hv specific performance counters. This will expose
KVM-HV specific performance attributes to user-space via kernel's PMU
infrastructure and would enableusers to monitor active kvm-hv based guests.

The patch creates necessary scaffolding to for the new PMU callbacks and
introduces the new kernel module name 'kvm-hv-pmu' which is built with
CONFIG_KVM_BOOK3S_HV_PMU. The patch doesn't introduce any perf-events yet,
which will be introduced in later patches

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

---
Changelog

v4->v5:
* Fixed a kismet warning reported by build-robot by removing dependency to
CONFIG_HV_PERF_CTRS
https://lore.kernel.org/oe-kbuild-all/202502280218.Jdd4jjlZ-lkp@intel.com/

* Removed a redundant check in kvmppc_register_pmu() [ Atheera ]

v3->v4:
* Introduced a new kernel module named 'kmv-hv-pmu' to host the new PMU
instead of building the as part of KVM-HV module. [ Maddy ]
* Moved the code from arch/powerpc/kvm to arch/powerpc/perf [ Atheera ]
* Added a new config named KVM_BOOK3S_HV_PMU to arch/powerpc/kvm/Kconfig

v2->v3:
* Fixed a build warning reported by kernel build robot.
Link:
https://lore.kernel.org/oe-kbuild-all/202501171030.3x0gqW8G-lkp@intel.com

v1->v2:
* Fixed an issue of kvm-hv not loading on baremetal kvm [Gautam]
---
 arch/powerpc/kvm/Kconfig       |  13 ++++
 arch/powerpc/perf/Makefile     |   2 +
 arch/powerpc/perf/kvm-hv-pmu.c | 138 +++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 arch/powerpc/perf/kvm-hv-pmu.c

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index dbfdc126bf14..2f2702c867f7 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -83,6 +83,7 @@ config KVM_BOOK3S_64_HV
 	depends on KVM_BOOK3S_64 && PPC_POWERNV
 	select KVM_BOOK3S_HV_POSSIBLE
 	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_BOOK3S_HV_PMU
 	select CMA
 	help
 	  Support running unmodified book3s_64 guest kernels in
@@ -171,6 +172,18 @@ config KVM_BOOK3S_HV_NESTED_PMU_WORKAROUND
 	  those buggy L1s which saves the L2 state, at the cost of performance
 	  in all nested-capable guest entry/exit.
 
+config KVM_BOOK3S_HV_PMU
+	tristate "Hypervisor Perf events for KVM Book3s-HV"
+	depends on KVM_BOOK3S_64_HV
+	help
+	  Enable Book3s-HV Hypervisor Perf events PMU named 'kvm-hv'. These
+	  Perf events give an overview of hypervisor performance overall
+	  instead of a specific guests. Currently the PMU reports
+	  L0-Hypervisor stats on a kvm-hv enabled PSeries LPAR like:
+	  * Total/Used Guest-Heap
+	  * Total/Used Guest Page-table Memory
+	  * Total amount of Guest Page-table Memory reclaimed
+
 config KVM_BOOKE_HV
 	bool
 
diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index ac2cf58d62db..7f53fcb7495a 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -18,6 +18,8 @@ obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o hv-common.o
 
 obj-$(CONFIG_VPA_PMU) += vpa-pmu.o
 
+obj-$(CONFIG_KVM_BOOK3S_HV_PMU) += kvm-hv-pmu.o
+
 obj-$(CONFIG_PPC_8xx) += 8xx-pmu.o
 
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
diff --git a/arch/powerpc/perf/kvm-hv-pmu.c b/arch/powerpc/perf/kvm-hv-pmu.c
new file mode 100644
index 000000000000..12f40a7b3ced
--- /dev/null
+++ b/arch/powerpc/perf/kvm-hv-pmu.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Description: PMUs specific to running nested KVM-HV guests
+ * on Book3S processors (specifically POWER9 and later).
+ */
+
+#define pr_fmt(fmt)  "kvmppc-pmu: " fmt
+
+#include "asm-generic/local64.h"
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/ratelimit.h>
+#include <linux/kvm_host.h>
+#include <linux/gfp_types.h>
+#include <linux/pgtable.h>
+#include <linux/perf_event.h>
+#include <linux/spinlock_types.h>
+#include <linux/spinlock.h>
+
+#include <asm/types.h>
+#include <asm/kvm_ppc.h>
+#include <asm/kvm_book3s.h>
+#include <asm/mmu.h>
+#include <asm/pgalloc.h>
+#include <asm/pte-walk.h>
+#include <asm/reg.h>
+#include <asm/plpar_wrappers.h>
+#include <asm/firmware.h>
+
+enum kvmppc_pmu_eventid {
+	KVMPPC_EVENT_MAX,
+};
+
+static struct attribute *kvmppc_pmu_events_attr[] = {
+	NULL,
+};
+
+static const struct attribute_group kvmppc_pmu_events_group = {
+	.name = "events",
+	.attrs = kvmppc_pmu_events_attr,
+};
+
+PMU_FORMAT_ATTR(event, "config:0");
+static struct attribute *kvmppc_pmu_format_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+static struct attribute_group kvmppc_pmu_format_group = {
+	.name = "format",
+	.attrs = kvmppc_pmu_format_attr,
+};
+
+static const struct attribute_group *kvmppc_pmu_attr_groups[] = {
+	&kvmppc_pmu_events_group,
+	&kvmppc_pmu_format_group,
+	NULL,
+};
+
+static int kvmppc_pmu_event_init(struct perf_event *event)
+{
+	unsigned int config = event->attr.config;
+
+	pr_debug("%s: Event(%p) id=%llu cpu=%x on_cpu=%x config=%u",
+		 __func__, event, event->id, event->cpu,
+		 event->oncpu, config);
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	if (config >= KVMPPC_EVENT_MAX)
+		return -EINVAL;
+
+	local64_set(&event->hw.prev_count, 0);
+	local64_set(&event->count, 0);
+
+	return 0;
+}
+
+static void kvmppc_pmu_del(struct perf_event *event, int flags)
+{
+}
+
+static int kvmppc_pmu_add(struct perf_event *event, int flags)
+{
+	return 0;
+}
+
+static void kvmppc_pmu_read(struct perf_event *event)
+{
+}
+
+/* L1 wide counters PMU */
+static struct pmu kvmppc_pmu = {
+	.module = THIS_MODULE,
+	.task_ctx_nr = perf_sw_context,
+	.name = "kvm-hv",
+	.event_init = kvmppc_pmu_event_init,
+	.add = kvmppc_pmu_add,
+	.del = kvmppc_pmu_del,
+	.read = kvmppc_pmu_read,
+	.attr_groups = kvmppc_pmu_attr_groups,
+	.type = -1,
+};
+
+static int __init kvmppc_register_pmu(void)
+{
+	int rc = -EOPNOTSUPP;
+
+	/* only support events for nestedv2 right now */
+	if (kvmhv_is_nestedv2()) {
+		/* Register the pmu */
+		rc = perf_pmu_register(&kvmppc_pmu, kvmppc_pmu.name, -1);
+		if (rc)
+			goto out;
+
+		pr_info("Registered kvm-hv pmu");
+	}
+
+out:
+	return rc;
+}
+
+static void __exit kvmppc_unregister_pmu(void)
+{
+	if (kvmhv_is_nestedv2()) {
+		if (kvmppc_pmu.type != -1)
+			perf_pmu_unregister(&kvmppc_pmu);
+
+		pr_info("kvmhv_pmu unregistered.\n");
+	}
+}
+
+module_init(kvmppc_register_pmu);
+module_exit(kvmppc_unregister_pmu);
+MODULE_DESCRIPTION("KVM PPC Book3s-hv PMU");
+MODULE_AUTHOR("Vaibhav Jain <vaibhav@linux.ibm.com>");
+MODULE_LICENSE("GPL");
-- 
2.48.1


