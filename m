Return-Path: <kvm+bounces-84-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0AA7DBD6D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52643281997
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53450199C7;
	Mon, 30 Oct 2023 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ApPsRsUK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1195418E3D
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:11 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F7EE1;
	Mon, 30 Oct 2023 09:04:08 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFqZ8r025061;
	Mon, 30 Oct 2023 16:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SWr5K5e2XW2UvfadKzHqaS95+Rmnr0pCAtfwXKVQDKI=;
 b=ApPsRsUK1waXcSZ5Po+9sv8U4FwEmpGWjEVW/7II2E7kdJ2U9RqQt+2VMBPsQmju6ogV
 8PYYwoizbf+VCoXlPse+GeZUFhia9fvo2HUKLylMHATILk+Nm2o89URI0LR6ImWmH7xl
 08XoFAVVVOQSUTEGv9iuXdraiVYFeYtv2YPZ0NwKk744/zDTgMOnI2v+lrwnQEErDuwa
 BtKfhodnM3O1LDtXYs4WpdoP4YwtuB+HDTbq+bSaNZZ2AdPtgL+KzabVdPXbe9kj8jWx
 2JYASqKBjzvC7ozyq/HCFEy/FNHTuoiibeV4ISCGllrdhwbk/VpICF8Q1Lw6GqBgomrk rg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fgtrc2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFqXew024808;
	Mon, 30 Oct 2023 16:03:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fgtrc1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:57 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDauEW031403;
	Mon, 30 Oct 2023 16:03:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1fb1skwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3r8024642152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8FD620040;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8709E20043;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 08/10] s390x: topology: Rewrite topology list test
Date: Mon, 30 Oct 2023 17:03:47 +0100
Message-Id: <20231030160349.458764-9-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2q83HzMQNGtWSq2qPd_yvG1xRWZFQJcf
X-Proofpoint-GUID: 8DBBwGndW6PSn13dC62pVYauY-oEbhFK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

Rewrite recursion with separate functions for checking containers,
containers containing CPUs and CPUs.
This improves comprehension and allows for more tests.
We now also test for ordering of CPU TLEs and number of child entries.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h |  36 ++++----
 s390x/topology.c | 214 +++++++++++++++++++++++++++++------------------
 2 files changed, 155 insertions(+), 95 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 1e9d0958..f2290ca7 100644
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
index df158aef..01021eb0 100644
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
@@ -237,82 +236,6 @@ done:
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
-	report(cpus->type == CPU_TYPE_IFL, "type IFL");
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
-		report(cpus->pp == POLARIZATION_VERTICAL_HIGH ||
-		       cpus->pp == POLARIZATION_HORIZONTAL,
-		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
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
@@ -342,6 +265,137 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
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
+	report(cpu->type == CPU_TYPE_IFL, "type IFL");
+
+	if (cpu->d)
+		report(cpu->pp == POLARIZATION_VERTICAL_HIGH ||
+		       cpu->pp == POLARIZATION_HORIZONTAL,
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
+						  unsigned int *cpus_in_masks)
+{
+	void *last = ((void *)info) + info->length;
+	union topology_cpu *prev_cpu = NULL;
+	bool correct_ordering = true;
+	unsigned int cpus = 0;
+	int i;
+
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
+
+	return (union topology_container *)&child[i];
+}
+
+static union topology_container *check_container(struct sysinfo_15_1_x *info,
+						 union topology_container *cont,
+						 union topology_entry *child,
+						 unsigned int *cpus_in_masks);
+
+static union topology_container *check_child_containers(struct sysinfo_15_1_x *info,
+							union topology_container *cont,
+							union topology_container *child,
+							unsigned int *cpus_in_masks)
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
+						 unsigned int *cpus_in_masks)
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
+}
+
 /**
  * check_sysinfo_15_1_x:
  * @info: pointer to the STSI info structure
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


