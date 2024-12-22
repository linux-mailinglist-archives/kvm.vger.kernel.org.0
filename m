Return-Path: <kvm+bounces-34294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3B69FA5F1
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 15:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF3121888507
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 14:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A1E18C018;
	Sun, 22 Dec 2024 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IozGQ8+S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458F117BB16;
	Sun, 22 Dec 2024 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734876214; cv=none; b=cJysTyRSPvVgyPcbw2Usb+n3jl5CcCQMcVMFwQt5tN1Mfc7ksvSsT14mQt+vzNgPB/63G1fFqOvD7fqMAlQKL2OQ/4EQPkjqFpwqNMgJGFVhd4dgEuaUtWfV47AaTKtUo7F2EP2nwcf5jsrbfTfTpi+CarNWYLbHkf8GuVMW1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734876214; c=relaxed/simple;
	bh=iGyl36QphMOuV4HAzwTCn7TiSK/Q+mwoOF3aCtPc8Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsOfqk28ucyXPTj3TrLeW9kxFzCaMBhDZzRCOOyXnnI+aDyoh0frCL1I7Pl+jY8tIH3tVPOVjEl6+sW9sAVFfIGMPIsR6mJB1tb2oyCyVsheLey+FVw6K8Y1i4V1li4KfPXYlmyraI0JVSjAFQM1vZ/dIsiwmUvjCbTjUCfVKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IozGQ8+S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMAF2PZ023846;
	Sun, 22 Dec 2024 14:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=OVj9v0sW/9wzyeybW
	J+omZ7xVKusFKkJ4EDONFSKrUo=; b=IozGQ8+S/7chxUwFUxaIax1nn4UUkT8je
	rjjtsOya3ynIbnEh7w8TfZAmCZPvZPoeBt2BvSuRcXLDrhOaxS/76KbAE9P+9Cxq
	BkUBCzDgYYDfnovT8oQdJfH0MLGIiP/88zxA64/sx1W/jqG1IkP3yrspZXnxC3A2
	y4Dp5dW71UxIPxrlIUfWfxvLCMrzPY7goXTk/YGqyPs6WmLOLktBsLhUZeWxFygH
	KPsW3m78b02W/+3YQQ6JycD0T48VoKifrO8L9iBOU8vo2MkRKcKuB8r08hpl+ppZ
	Fn6AzoIECfv0M01svyVJC+cJy/QGNoSbglM3ktkyjQqSHDmAMIy7g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43pb8b9a5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:23 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BME3N5e023245;
	Sun, 22 Dec 2024 14:03:23 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43pb8b9a5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMD1Ddv010616;
	Sun, 22 Dec 2024 14:03:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43p90msx3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:22 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BME3IJs34406834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Dec 2024 14:03:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0AE82004D;
	Sun, 22 Dec 2024 14:03:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7502520040;
	Sun, 22 Dec 2024 14:03:14 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.11])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Sun, 22 Dec 2024 14:03:14 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Sun, 22 Dec 2024 19:33:13 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
Date: Sun, 22 Dec 2024 19:32:32 +0530
Message-ID: <20241222140247.174998-5-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241222140247.174998-1-vaibhav@linux.ibm.com>
References: <20241222140247.174998-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mKYCzC_xH1pDr1V48_jsi_rfNfwNVEHQ
X-Proofpoint-GUID: -NRJ0pLixIAJAKAc9ZPSb4GlT-JcKMXl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412220124

Introduce a new PMU named 'kvm-hv' to report Book3s kvm-hv specific
performance counters. This will expose KVM-HV specific performance
attributes to user-space via kernel's PMU infrastructure and would enable
users to monitor active kvm-hv based guests.

The patch creates necessary scaffolding to for the new PMU callbacks and
introduces two new exports kvmppc_{,un}register_pmu() that are called from
kvm-hv init and exit function to perform initialize and cleanup for the
'kvm-hv' PMU. The patch doesn't introduce any perf-events yet, which will
be introduced in later patches

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  12 +++
 arch/powerpc/kvm/Makefile             |   6 ++
 arch/powerpc/kvm/book3s_hv.c          |   7 ++
 arch/powerpc/kvm/book3s_hv_pmu.c      | 133 ++++++++++++++++++++++++++
 4 files changed, 158 insertions(+)
 create mode 100644 arch/powerpc/kvm/book3s_hv_pmu.c

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index e1ff291ba891..cf91a1493159 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -334,6 +334,9 @@ static inline bool kvmhv_is_nestedv1(void)
 	return !static_branch_likely(&__kvmhv_is_nestedv2);
 }
 
+int kvmppc_register_pmu(void);
+void kvmppc_unregister_pmu(void);
+
 #else
 
 static inline bool kvmhv_is_nestedv2(void)
@@ -346,6 +349,15 @@ static inline bool kvmhv_is_nestedv1(void)
 	return false;
 }
 
+static int kvmppc_register_pmu(void)
+{
+	return 0;
+}
+
+static void kvmppc_unregister_pmu(void)
+{
+}
+
 #endif
 
 int __kvmhv_nestedv2_reload_ptregs(struct kvm_vcpu *vcpu, struct pt_regs *regs);
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 4bd9d1230869..094c3916d9d0 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -92,6 +92,12 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
 	$(kvm-book3s_64-builtin-tm-objs-y) \
 	$(kvm-book3s_64-builtin-xics-objs-y)
 
+# enable kvm_hv perf events
+ifdef CONFIG_HAVE_PERF_EVENTS
+kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
+	book3s_hv_pmu.o
+endif
+
 obj-$(CONFIG_GUEST_STATE_BUFFER_TEST) += test-guest-state-buffer.o
 endif
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 25429905ae90..83bcce2fb557 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6662,6 +6662,12 @@ static int kvmppc_book3s_init_hv(void)
 		return r;
 	}
 
+	r = kvmppc_register_pmu();
+	if (r) {
+		pr_err("KVM-HV: Unable to register PMUs %d\n", r);
+		goto err;
+	}
+
 	kvm_ops_hv.owner = THIS_MODULE;
 	kvmppc_hv_ops = &kvm_ops_hv;
 
@@ -6676,6 +6682,7 @@ static int kvmppc_book3s_init_hv(void)
 
 static void kvmppc_book3s_exit_hv(void)
 {
+	kvmppc_unregister_pmu();
 	kvmppc_uvmem_free();
 	kvmppc_free_host_rm_ops();
 	if (kvmppc_radix_possible())
diff --git a/arch/powerpc/kvm/book3s_hv_pmu.c b/arch/powerpc/kvm/book3s_hv_pmu.c
new file mode 100644
index 000000000000..e72542d5e750
--- /dev/null
+++ b/arch/powerpc/kvm/book3s_hv_pmu.c
@@ -0,0 +1,133 @@
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
+int kvmppc_register_pmu(void)
+{
+	int rc = -EOPNOTSUPP;
+
+	/* only support events for nestedv2 right now */
+	if (kvmhv_is_nestedv2()) {
+		/* Setup done now register the PMU */
+		pr_info("Registering kvm-hv pmu");
+
+		/* Register only if we arent already registyered */
+		rc = (kvmppc_pmu.type == -1) ?
+			     perf_pmu_register(&kvmppc_pmu, kvmppc_pmu.name,
+					       -1) : 0;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvmppc_register_pmu);
+
+void kvmppc_unregister_pmu(void)
+{
+	if (kvmhv_is_nestedv2()) {
+		if (kvmppc_pmu.type != -1)
+			perf_pmu_unregister(&kvmppc_pmu);
+
+		pr_info("kvmhv_pmu unregistered.\n");
+	}
+}
+EXPORT_SYMBOL_GPL(kvmppc_unregister_pmu);
-- 
2.47.1


