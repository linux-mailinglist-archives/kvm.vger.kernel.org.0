Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB1223E4E
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgGQOjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:39:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63846 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbgGQOjS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:39:18 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEWqU2141015;
        Fri, 17 Jul 2020 10:39:06 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32b9ag0kw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:39:05 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEU73e024878;
        Fri, 17 Jul 2020 14:39:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 327527kf7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:39:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEd1gN57802966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:39:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF534C044;
        Fri, 17 Jul 2020 14:39:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45A6A4C058;
        Fri, 17 Jul 2020 14:38:58 +0000 (GMT)
Received: from localhost.localdomain.localdomain (unknown [9.77.207.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:38:58 +0000 (GMT)
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: [v3 09/15] powerpc/perf: Ignore the BHRB kernel address filtering for P10
Date:   Fri, 17 Jul 2020 10:38:21 -0400
Message-Id: <1594996707-3727-10-git-send-email-atrajeev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0 suspectscore=1
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=703 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007170108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit bb19af816025 ("powerpc/perf: Prevent kernel address leak to
userspace via BHRB buffer") added a check in bhrb_read() to filter
the kernel address from BHRB buffer. This patch modified it to avoid
that check for PowerISA v3.1 based processors, since PowerISA v3.1
allows only MSR[PR]=1 address to be written to BHRB buffer.

Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 0ffb757d..bd125fe 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -469,8 +469,11 @@ static void power_pmu_bhrb_read(struct perf_event *event, struct cpu_hw_events *
 			 * addresses at this point. Check the privileges before
 			 * exporting it to userspace (avoid exposure of regions
 			 * where we could have speculative execution)
+			 * Incase of ISA v3.1, BHRB will capture only user-space
+			 * addresses, hence include a check before filtering code
 			 */
-			if (is_kernel_addr(addr) && perf_allow_kernel(&event->attr) != 0)
+			if (!(ppmu->flags & PPMU_ARCH_310S) &&
+				is_kernel_addr(addr) && perf_allow_kernel(&event->attr) != 0)
 				continue;
 
 			/* Branches are read most recent first (ie. mfbhrb 0 is
-- 
1.8.3.1

