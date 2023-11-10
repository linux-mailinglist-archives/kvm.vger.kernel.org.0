Return-Path: <kvm+bounces-1476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E40327E7CBB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AA7CB213C0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F7038DCC;
	Fri, 10 Nov 2023 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eD+y+6UQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183E328D4
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:43 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF9E3821D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:42 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADqtaw018722;
	Fri, 10 Nov 2023 13:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=FoSX7lUsNXa/v7qOHvbEMgur7RgMTlyEpicsBiGqu6Q=;
 b=eD+y+6UQzay7JO7d+bCLnIOUlEeQmiZNpwmhJzJ2HMpImPOEDZz7V1QNsNw6p91sydPc
 fGuyQMBkS6z5YZpB4F00C2fKDXjikEs+OxeFDfbt6nPxxGIqF5FNriHcJAPsAQKvEsQF
 DcpFhmGksbqKurFUx96iOsIm6hjYMBmaUjsB4vv5gnpPfLCisVLVJgQT/GL148QTqH9V
 uT20pmkyGB36TJTF4NhLLNxxPhbGDY7aPtpGRM2pnLPw7ioAfFBKrNMjJe7wG2HUAu8F
 33YdzposhlvdQTXFsoV/g+qMb8lZZwsU8j8IMrK5dzt7M47Ry374Ml6W461fMNoj/GFD 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nsjr1gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADqvDr018764;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nsjr1fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AABGpGA000662;
	Fri, 10 Nov 2023 13:54:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w23b7eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsYTC16188000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B514220043;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4558320040;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 16/26] s390x: topology: Rewrite topology list test
Date: Fri, 10 Nov 2023 14:52:25 +0100
Message-ID: <20231110135348.245156-17-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tZ5kTXoTFywvPH8pgBB6B0157BWcBTf2
X-Proofpoint-ORIG-GUID: mIWBGiLHAdC2igNMAbV5Uvc-Yc48chBF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=904 mlxscore=0 bulkscore=0 adultscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Rewrite recursion with separate functions for checking containers,
containers containing CPUs and CPUs.
This improves comprehension and allows for more tests.
We now also test for ordering of CPU TLEs and number of child entries.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-9-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/stsi.h |  36 +++++----
 s390x/topology.c | 202 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 149 insertions(+), 89 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 1e9d095..f2290ca 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -30,15 +30,18 @@ struct sysinfo_3_2_2 {
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
 
 enum topology_polarization {
@@ -53,16 +56,19 @@ enum cpu_type {
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
index df158ae..01021eb 100644
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
@@ -238,108 +237,163 @@ done:
 }
 
 /**
- * check_tle:
- * @tc: pointer to first TLE
+ * stsi_get_sysib:
+ * @info: pointer to the STSI info structure
+ * @sel2: the selector giving the topology level to check
  *
- * Recursively check the containers TLEs until we
- * find a CPU TLE.
+ * Fill the sysinfo_15_1_x info structure and check the
+ * SYSIB header.
+ *
+ * Returns instruction validity.
  */
-static uint8_t *check_tle(void *tc)
+static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 {
-	struct topology_container *container = tc;
-	struct topology_cpu *cpus;
-	int n;
+	int ret;
 
-	if (container->nl) {
-		report_info("NL: %d id: %d", container->nl, container->id);
+	report_prefix_pushf("SYSIB");
 
-		report(!(*(uint64_t *)tc & CONTAINER_TLE_RES_BITS),
-		       "reserved bits %016lx",
-		       *(uint64_t *)tc & CONTAINER_TLE_RES_BITS);
+	ret = stsi(info, 15, 1, sel2);
 
-		return check_tle(tc + sizeof(*container));
+	if (max_nested_lvl >= sel2) {
+		report(!ret, "Valid instruction");
+	} else {
+		report(ret, "Invalid instruction");
 	}
 
-	report_info("NL: %d", container->nl);
-	cpus = tc;
+	report_prefix_pop();
 
-	report(!(*(uint64_t *)tc & CPUS_TLE_RES_BITS), "reserved bits %016lx",
-	       *(uint64_t *)tc & CPUS_TLE_RES_BITS);
+	return ret;
+}
 
-	report(cpus->type == CPU_TYPE_IFL, "type IFL");
+static int check_cpu(union topology_cpu *cpu,
+		     union topology_container *parent)
+{
+	report_prefix_pushf("%d:%d:%d:%d", cpu->d, cpu->pp, cpu->type, cpu->origin);
 
-	report_info("origin: %d", cpus->origin);
-	report_info("mask: %016lx", cpus->mask);
-	report_info("dedicated: %d entitlement: %d", cpus->d, cpus->pp);
+	report(!(cpu->raw[0] & CPUS_TLE_RES_BITS), "reserved bits %016lx",
+	       cpu->raw[0] & CPUS_TLE_RES_BITS);
 
-	n = __builtin_popcountl(cpus->mask);
-	report(n <= expected_topo_lvl[0], "CPUs per mask: %d out of max %d",
-	       n, expected_topo_lvl[0]);
-	cpus_in_masks += n;
+	report(cpu->type == CPU_TYPE_IFL, "type IFL");
 
-	if (!cpus->d)
-		report_skip("Not dedicated");
-	else
-		report(cpus->pp == POLARIZATION_VERTICAL_HIGH ||
-		       cpus->pp == POLARIZATION_HORIZONTAL,
+	if (cpu->d)
+		report(cpu->pp == POLARIZATION_VERTICAL_HIGH ||
+		       cpu->pp == POLARIZATION_HORIZONTAL,
 		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
+	else
+		report_skip("Not dedicated");
+
+	report_prefix_pop();
 
-	return tc + sizeof(*cpus);
+	return __builtin_popcountl(cpu->mask);
 }
 
-/**
- * stsi_check_tle_coherency:
- * @info: Pointer to the stsi information
- *
- * We verify that we get the expected number of Topology List Entry
- * containers for a specific level.
- */
-static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info)
+static union topology_container *check_child_cpus(struct sysinfo_15_1_x *info,
+						  union topology_container *cont,
+						  union topology_cpu *child,
+						  unsigned int *cpus_in_masks)
 {
-	void *tc, *end;
+	void *last = ((void *)info) + info->length;
+	union topology_cpu *prev_cpu = NULL;
+	bool correct_ordering = true;
+	unsigned int cpus = 0;
+	int i;
 
-	report_prefix_push("TLE");
-	cpus_in_masks = 0;
+	for (i = 0; (void *)&child[i] < last && child[i].nl == 0; prev_cpu = &child[i++]) {
+		cpus += check_cpu(&child[i], cont);
+		if (prev_cpu) {
+			if (prev_cpu->type > child[i].type) {
+				report_info("Incorrect ordering wrt type for child %d", i);
+				correct_ordering = false;
+			}
+			if (prev_cpu->type < child[i].type)
+				continue;
+			if (prev_cpu->pp < child[i].pp) {
+				report_info("Incorrect ordering wrt polarization for child %d", i);
+				correct_ordering = false;
+			}
+			if (prev_cpu->pp > child[i].pp)
+				continue;
+			if (!prev_cpu->d && child[i].d) {
+				report_info("Incorrect ordering wrt dedication for child %d", i);
+				correct_ordering = false;
+			}
+			if (prev_cpu->d && !child[i].d)
+				continue;
+			if (prev_cpu->origin > child[i].origin) {
+				report_info("Incorrect ordering wrt origin for child %d", i);
+				correct_ordering = false;
+			}
+		}
+	}
+	report(correct_ordering, "children correctly ordered");
+	report(cpus <= expected_topo_lvl[0], "%d children <= max of %d",
+	       cpus, expected_topo_lvl[0]);
+	*cpus_in_masks += cpus;
 
-	tc = info->tle;
-	end = (void *)info + info->length;
+	return (union topology_container *)&child[i];
+}
 
-	while (tc < end)
-		tc = check_tle(tc);
+static union topology_container *check_container(struct sysinfo_15_1_x *info,
+						 union topology_container *cont,
+						 union topology_entry *child,
+						 unsigned int *cpus_in_masks);
 
-	report(cpus_in_masks == number_of_cpus, "CPUs in mask %d",
-	       cpus_in_masks);
+static union topology_container *check_child_containers(struct sysinfo_15_1_x *info,
+							union topology_container *cont,
+							union topology_container *child,
+							unsigned int *cpus_in_masks)
+{
+	void *last = ((void *)info) + info->length;
+	union topology_container *entry;
+	int i;
 
-	report_prefix_pop();
+	for (i = 0, entry = child; (void *)entry < last && entry->nl == cont->nl - 1; i++) {
+		entry = check_container(info, entry, (union topology_entry *)(entry + 1),
+					cpus_in_masks);
+	}
+	if (max_nested_lvl == info->mnest)
+		report(i <= expected_topo_lvl[cont->nl - 1], "%d children <= max of %d",
+		       i, expected_topo_lvl[cont->nl - 1]);
+
+	return entry;
 }
 
-/**
- * stsi_get_sysib:
- * @info: pointer to the STSI info structure
- * @sel2: the selector giving the topology level to check
- *
- * Fill the sysinfo_15_1_x info structure and check the
- * SYSIB header.
- *
- * Returns instruction validity.
- */
-static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
+static union topology_container *check_container(struct sysinfo_15_1_x *info,
+						 union topology_container *cont,
+						 union topology_entry *child,
+						 unsigned int *cpus_in_masks)
 {
-	int ret;
+	union topology_container *entry;
 
-	report_prefix_pushf("SYSIB");
+	report_prefix_pushf("%d", cont->id);
 
-	ret = stsi(info, 15, 1, sel2);
+	report(cont->nl - 1 == child->nl, "Level %d one above child level %d",
+	       cont->nl, child->nl);
+	report(!(cont->raw & CONTAINER_TLE_RES_BITS), "reserved bits %016lx",
+	       cont->raw & CONTAINER_TLE_RES_BITS);
 
-	if (max_nested_lvl >= sel2) {
-		report(!ret, "Valid instruction");
-	} else {
-		report(ret, "Invalid instruction");
-	}
+	if (cont->nl > 1)
+		entry = check_child_containers(info, cont, &child->container, cpus_in_masks);
+	else
+		entry = check_child_cpus(info, cont, &child->cpu, cpus_in_masks);
 
 	report_prefix_pop();
+	return entry;
+}
 
-	return ret;
+static void check_topology_list(struct sysinfo_15_1_x *info, int sel2)
+{
+	union topology_container dummy = { .nl = sel2, .id = 0 };
+	unsigned int cpus_in_masks = 0;
+
+	report_prefix_push("TLE");
+
+	check_container(info, &dummy, info->tle, &cpus_in_masks);
+	report(cpus_in_masks == number_of_cpus,
+	       "Number of CPUs %d equals  %d CPUs in masks",
+	       number_of_cpus, cpus_in_masks);
+
+	report_prefix_pop();
 }
 
 /**
@@ -372,7 +426,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 
 vertical:
 	report_prefix_pop();
@@ -385,7 +439,7 @@ vertical:
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 	report_prefix_pop();
 
 end:
-- 
2.41.0


