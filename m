Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13F6223E58
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGQOjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:39:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726851AbgGQOjg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:39:36 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEUphU033227;
        Fri, 17 Jul 2020 10:39:23 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32as6ejr2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:39:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEUmZu021688;
        Fri, 17 Jul 2020 14:39:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 327527xtk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:39:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEdJqk52363408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:39:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E4394C04E;
        Fri, 17 Jul 2020 14:39:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BDC44C04A;
        Fri, 17 Jul 2020 14:39:16 +0000 (GMT)
Received: from localhost.localdomain.localdomain (unknown [9.77.207.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:39:16 +0000 (GMT)
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: [v3 15/15] tools/perf: Add perf tools support for extended regs in power10
Date:   Fri, 17 Jul 2020 10:38:27 -0400
Message-Id: <1594996707-3727-16-git-send-email-atrajeev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=1 mlxscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added support for supported regs which are new in power10
( MMCR3, SIER2, SIER3 ) to sample_reg_mask in the tool side
to use with `-I?` option. Also added PVR check to send extended
mask for power10 at kernel while capturing extended regs in
each sample.

Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
---
 tools/arch/powerpc/include/uapi/asm/perf_regs.h | 6 ++++++
 tools/perf/arch/powerpc/include/perf_regs.h     | 3 +++
 tools/perf/arch/powerpc/util/perf_regs.c        | 6 ++++++
 3 files changed, 15 insertions(+)

diff --git a/tools/arch/powerpc/include/uapi/asm/perf_regs.h b/tools/arch/powerpc/include/uapi/asm/perf_regs.h
index 225c64c..bdf5f10 100644
--- a/tools/arch/powerpc/include/uapi/asm/perf_regs.h
+++ b/tools/arch/powerpc/include/uapi/asm/perf_regs.h
@@ -52,6 +52,9 @@ enum perf_event_powerpc_regs {
 	PERF_REG_POWERPC_MMCR0,
 	PERF_REG_POWERPC_MMCR1,
 	PERF_REG_POWERPC_MMCR2,
+	PERF_REG_POWERPC_MMCR3,
+	PERF_REG_POWERPC_SIER2,
+	PERF_REG_POWERPC_SIER3,
 	/* Max regs without the extended regs */
 	PERF_REG_POWERPC_MAX = PERF_REG_POWERPC_MMCRA + 1,
 };
@@ -60,6 +63,9 @@ enum perf_event_powerpc_regs {
 
 /* PERF_REG_EXTENDED_MASK value for CPU_FTR_ARCH_300 */
 #define PERF_REG_PMU_MASK_300   (((1ULL << (PERF_REG_POWERPC_MMCR2 + 1)) - 1) - PERF_REG_PMU_MASK)
+/* PERF_REG_EXTENDED_MASK value for CPU_FTR_ARCH_31 */
+#define PERF_REG_PMU_MASK_31   (((1ULL << (PERF_REG_POWERPC_SIER3 + 1)) - 1) - PERF_REG_PMU_MASK)
 
 #define PERF_REG_MAX_ISA_300   (PERF_REG_POWERPC_MMCR2 + 1)
+#define PERF_REG_MAX_ISA_31    (PERF_REG_POWERPC_SIER3 + 1)
 #endif /* _UAPI_ASM_POWERPC_PERF_REGS_H */
diff --git a/tools/perf/arch/powerpc/include/perf_regs.h b/tools/perf/arch/powerpc/include/perf_regs.h
index 46ed00d..63f3ac9 100644
--- a/tools/perf/arch/powerpc/include/perf_regs.h
+++ b/tools/perf/arch/powerpc/include/perf_regs.h
@@ -68,6 +68,9 @@
 	[PERF_REG_POWERPC_MMCR0] = "mmcr0",
 	[PERF_REG_POWERPC_MMCR1] = "mmcr1",
 	[PERF_REG_POWERPC_MMCR2] = "mmcr2",
+	[PERF_REG_POWERPC_MMCR3] = "mmcr3",
+	[PERF_REG_POWERPC_SIER2] = "sier2",
+	[PERF_REG_POWERPC_SIER3] = "sier3",
 };
 
 static inline const char *perf_reg_name(int id)
diff --git a/tools/perf/arch/powerpc/util/perf_regs.c b/tools/perf/arch/powerpc/util/perf_regs.c
index d64ba0c..2b6d470 100644
--- a/tools/perf/arch/powerpc/util/perf_regs.c
+++ b/tools/perf/arch/powerpc/util/perf_regs.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 
 #define PVR_POWER9		0x004E
+#define PVR_POWER10		0x0080
 
 const struct sample_reg sample_reg_masks[] = {
 	SMPL_REG(r0, PERF_REG_POWERPC_R0),
@@ -64,6 +65,9 @@
 	SMPL_REG(mmcr0, PERF_REG_POWERPC_MMCR0),
 	SMPL_REG(mmcr1, PERF_REG_POWERPC_MMCR1),
 	SMPL_REG(mmcr2, PERF_REG_POWERPC_MMCR2),
+	SMPL_REG(mmcr3, PERF_REG_POWERPC_MMCR3),
+	SMPL_REG(sier2, PERF_REG_POWERPC_SIER2),
+	SMPL_REG(sier3, PERF_REG_POWERPC_SIER3),
 	SMPL_REG_END
 };
 
@@ -194,6 +198,8 @@ uint64_t arch__intr_reg_mask(void)
 	version = (((mfspr(SPRN_PVR)) >>  16) & 0xFFFF);
 	if (version == PVR_POWER9)
 		extended_mask = PERF_REG_PMU_MASK_300;
+	else if (version == PVR_POWER10)
+		extended_mask = PERF_REG_PMU_MASK_31;
 	else
 		return mask;
 
-- 
1.8.3.1

