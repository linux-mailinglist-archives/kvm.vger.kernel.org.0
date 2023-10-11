Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1BD7C4E04
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 11:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbjJKJCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 05:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346123AbjJKJBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 05:01:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A75131;
        Wed, 11 Oct 2023 02:01:22 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8tkKQ007455;
        Wed, 11 Oct 2023 09:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ly6nOVmLFPM5r4FD5lNRHV7MclS6f84ksNvLe3J383U=;
 b=IcuzMN0of4xXOkxbTsattdAFl75MLs9CwhiLT30CY2/LOcvE1n8TTTZ0/uEbfEBhDXaE
 9xYssPrd3y7TwXF7kogTIgHbOunstxO4COliYPKbX2Z4tq0E7n05OzxQmB9J3ZT0DyiA
 jeRAj1yP2HdhMKj4tGiVBDJdzpN4D4pFYaQoXqcPlWnBSrv/4A4Txu3vY7Qmmr92/ydc
 IYzMZl3vkxUNdiisL4eODZJ6cM+QamgOKqKfOdTJZ41tDzJbYecFKuwQ3nDXjMkuEAxD
 q5vtt5whvdGXtQGQT2NRVAcc+WfgnJEamHJjgERXhF5GGtT9byLArHeWTqmq4LeI8lQR dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrmb85v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 09:01:16 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8v41f010800;
        Wed, 11 Oct 2023 09:01:14 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrmb85rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 09:01:14 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8UclE026364;
        Wed, 11 Oct 2023 08:56:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnneuut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8uhid40108288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AE4420043;
        Wed, 11 Oct 2023 08:56:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FA7E20040;
        Wed, 11 Oct 2023 08:56:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:43 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: [kvm-unit-tests PATCH 7/9] s390x: topology: Rewrite topology list test
Date:   Wed, 11 Oct 2023 10:56:30 +0200
Message-Id: <20231011085635.1996346-8-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b5_2nMEgyawjk3Yrhr4mCo0a_0CIIKX2
X-Proofpoint-ORIG-GUID: RLTlbXXO0hjPvAFY-a3Bk7YEYcrp-8kt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rewrite recursion with separate functions for checking containers,
containers containing CPUs and CPUs.
This improves comprehension and allows for more tests.
We now also test for ordering of CPU TLEs and number of child entries.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h |  36 +++++----
 s390x/topology.c | 197 ++++++++++++++++++++++++++++-------------------
 2 files changed, 140 insertions(+), 93 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 8a97f44e..fdb38e2c 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -30,28 +30,34 @@ struct sysinfo_3_2_2 {
 };
 
 #define CPUS_TLE_RES_BITS 0x00fffffff8000000UL
-struct topology_cpu {
-	uint8_t nl;
-	uint8_t reserved1[3];
-	uint8_t reserved4:5;
-	uint8_t d:1;
-	uint8_t pp:2;
-	uint8_t type;
-	uint16_t origin;
-	uint64_t mask;
+union topology_cpu {
+	uint64_t raw[2];
+	struct {
+		uint8_t nl;
+		uint8_t reserved1[3];
+		uint8_t reserved4:5;
+		uint8_t d:1;
+		uint8_t pp:2;
+		uint8_t type;
+		uint16_t origin;
+		uint64_t mask;
+	};
 };
 
 #define CONTAINER_TLE_RES_BITS 0x00ffffffffffff00UL
-struct topology_container {
-	uint8_t nl;
-	uint8_t reserved[6];
-	uint8_t id;
+union topology_container {
+	uint64_t raw;
+	struct {
+		uint8_t nl;
+		uint8_t reserved[6];
+		uint8_t id;
+	};
 };
 
 union topology_entry {
 	uint8_t nl;
-	struct topology_cpu cpu;
-	struct topology_container container;
+	union topology_cpu cpu;
+	union topology_container container;
 };
 
 #define CPU_TOPOLOGY_MAX_LEVEL 6
diff --git a/s390x/topology.c b/s390x/topology.c
index c1f6520f..9838434c 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -2,7 +2,7 @@
 /*
  * CPU Topology
  *
- * Copyright IBM Corp. 2022
+ * Copyright IBM Corp. 2022, 2023
  *
  * Authors:
  *  Pierre Morel <pmorel@linux.ibm.com>
@@ -23,7 +23,6 @@ static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static int max_nested_lvl;
 static int number_of_cpus;
-static int cpus_in_masks;
 static int max_cpus;
 
 /*
@@ -236,80 +235,6 @@ done:
 	report_prefix_pop();
 }
 
-/**
- * check_tle:
- * @tc: pointer to first TLE
- *
- * Recursively check the containers TLEs until we
- * find a CPU TLE.
- */
-static uint8_t *check_tle(void *tc)
-{
-	struct topology_container *container = tc;
-	struct topology_cpu *cpus;
-	int n;
-
-	if (container->nl) {
-		report_info("NL: %d id: %d", container->nl, container->id);
-
-		report(!(*(uint64_t *)tc & CONTAINER_TLE_RES_BITS),
-		       "reserved bits %016lx",
-		       *(uint64_t *)tc & CONTAINER_TLE_RES_BITS);
-
-		return check_tle(tc + sizeof(*container));
-	}
-
-	report_info("NL: %d", container->nl);
-	cpus = tc;
-
-	report(!(*(uint64_t *)tc & CPUS_TLE_RES_BITS), "reserved bits %016lx",
-	       *(uint64_t *)tc & CPUS_TLE_RES_BITS);
-
-	report(cpus->type == 0x03, "type IFL");
-
-	report_info("origin: %d", cpus->origin);
-	report_info("mask: %016lx", cpus->mask);
-	report_info("dedicated: %d entitlement: %d", cpus->d, cpus->pp);
-
-	n = __builtin_popcountl(cpus->mask);
-	report(n <= expected_topo_lvl[0], "CPUs per mask: %d out of max %d",
-	       n, expected_topo_lvl[0]);
-	cpus_in_masks += n;
-
-	if (!cpus->d)
-		report_skip("Not dedicated");
-	else
-		report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either horizontally polarized or have high entitlement");
-
-	return tc + sizeof(*cpus);
-}
-
-/**
- * stsi_check_tle_coherency:
- * @info: Pointer to the stsi information
- *
- * We verify that we get the expected number of Topology List Entry
- * containers for a specific level.
- */
-static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info)
-{
-	void *tc, *end;
-
-	report_prefix_push("TLE");
-	cpus_in_masks = 0;
-
-	tc = info->tle;
-	end = (void *)info + info->length;
-
-	while (tc < end)
-		tc = check_tle(tc);
-
-	report(cpus_in_masks == number_of_cpus, "CPUs in mask %d",
-	       cpus_in_masks);
-
-	report_prefix_pop();
-}
-
 /**
  * stsi_get_sysib:
  * @info: pointer to the STSI info structure
@@ -339,6 +264,122 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 	return ret;
 }
 
+static int check_cpu(union topology_cpu *cpu,
+		     union topology_container *parent)
+{
+	report_prefix_pushf("%d:%d:%d:%d", cpu->d, cpu->pp, cpu->type, cpu->origin);
+
+	report(!(cpu->raw[0] & CPUS_TLE_RES_BITS), "reserved bits %016lx",
+	       cpu->raw[0] & CPUS_TLE_RES_BITS);
+
+	report(cpu->type == 0x03, "type IFL");
+
+	if (cpu->d)
+		report(cpu->pp == 3 || cpu->pp == 0,
+		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
+	else
+		report_skip("Not dedicated");
+
+	report_prefix_pop();
+
+	return __builtin_popcountl(cpu->mask);
+}
+
+static union topology_container *check_child_cpus(struct sysinfo_15_1_x *info,
+						  union topology_container *cont,
+						  union topology_cpu *child,
+						  int *cpus_in_masks)
+{
+	void *last = ((void *)info) + info->length;
+	union topology_cpu *prev_cpu = NULL;
+	int cpus = 0;
+
+	for (; (void *)child < last && child->nl == 0; child++) {
+		cpus += check_cpu(child, cont);
+		if (prev_cpu) {
+			report(prev_cpu->type <= child->type, "Correct ordering wrt type");
+			if (prev_cpu->type < child->type)
+				continue;
+			report(prev_cpu->pp >= child->pp, "Correct ordering wrt polarization");
+			if (prev_cpu->type > child->type)
+				continue;
+			report(prev_cpu->d || !child->d, "Correct ordering wrt dedication");
+			if (prev_cpu->d && !child->d)
+				continue;
+			report(prev_cpu->origin <= child->origin, "Correct ordering wrt origin");
+		}
+		prev_cpu = child;
+	}
+	report(cpus <= expected_topo_lvl[0], "%d children <= max of %d",
+	       cpus, expected_topo_lvl[0]);
+	*cpus_in_masks += cpus;
+
+	return (union topology_container *)child;
+}
+
+static union topology_container *check_container(struct sysinfo_15_1_x *info,
+						 union topology_container *cont,
+						 union topology_entry *child,
+						 int *cpus_in_masks);
+
+static union topology_container *check_child_containers(struct sysinfo_15_1_x *info,
+							union topology_container *cont,
+							union topology_container *child,
+							int *cpus_in_masks)
+{
+	void *last = ((void *)info) + info->length;
+	union topology_container *entry;
+	int i;
+
+	for (i = 0, entry = child; (void *)entry < last && entry->nl == cont->nl - 1; i++) {
+		entry = check_container(info, entry, (union topology_entry *)(entry + 1),
+					cpus_in_masks);
+	}
+	if (max_nested_lvl == info->mnest)
+		report(i <= expected_topo_lvl[cont->nl - 1], "%d children <= max of %d",
+		       i, expected_topo_lvl[cont->nl - 1]);
+
+	return entry;
+}
+
+static union topology_container *check_container(struct sysinfo_15_1_x *info,
+						 union topology_container *cont,
+						 union topology_entry *child,
+						 int *cpus_in_masks)
+{
+	union topology_container *entry;
+
+	report_prefix_pushf("%d", cont->id);
+
+	report(cont->nl - 1 == child->nl, "Level %d one above child level %d",
+	       cont->nl, child->nl);
+	report(!(cont->raw & CONTAINER_TLE_RES_BITS), "reserved bits %016lx",
+	       cont->raw & CONTAINER_TLE_RES_BITS);
+
+	if (cont->nl > 1)
+		entry = check_child_containers(info, cont, &child->container, cpus_in_masks);
+	else
+		entry = check_child_cpus(info, cont, &child->cpu, cpus_in_masks);
+
+	report_prefix_pop();
+	return entry;
+}
+
+static void check_topology_list(struct sysinfo_15_1_x *info, int sel2)
+{
+	union topology_container dummy = { .nl = sel2, .id = 0 };
+	int cpus_in_masks = 0;
+
+	report_prefix_push("TLE");
+
+	check_container(info, &dummy, info->tle, &cpus_in_masks);
+	report(cpus_in_masks == number_of_cpus,
+	       "Number of CPUs %d equals  %d CPUs in masks",
+	       number_of_cpus, cpus_in_masks);
+
+	report_prefix_pop();
+}
+
 /**
  * check_sysinfo_15_1_x:
  * @info: pointer to the STSI info structure
@@ -369,7 +410,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 
 vertical:
 	report_prefix_pop();
@@ -382,7 +423,7 @@ vertical:
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 	report_prefix_pop();
 
 end:
-- 
2.41.0

