Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8436D7D121B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 17:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377617AbjJTPDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377588AbjJTPDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 11:03:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FB4D46;
        Fri, 20 Oct 2023 08:03:05 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KF0PJE012628;
        Fri, 20 Oct 2023 15:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I3YkIsPQpDoE7Qz/xMlqA1jM26BOKVO6YCbX1uvPmnw=;
 b=Dpm9DeQQhZiIYmmNZlx/15z47RlvYwCU3YtQE+173OmD6ANxfJdhOe5gdk4kndtBWZCp
 RvmSs6gmiBf/NuLW4Jpacl4qAkozLqpH4IG1igmw+3iPaN2khGCNsnma4sx5RvptApSI
 rhzgqmTF2R227lt+NpR8M97lr0N1hXaRgK0Nw9YQsn7tjKzS4A9ZS5d3QEc50zShuMW9
 PS8qYO01pmFiguXMctmAzf9oHaKO+9OwJVbh1BrsldspEwzGJKu1cujTPMFPj9aOvvYO
 /jjQbVAUq1YEWx6i3XnAyLA1nDapf/3NEd4l9TrNqPbj4zVeKATvNV8gtdqGqth3HQBH /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuut9r6fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 15:02:53 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KF0StO013204;
        Fri, 20 Oct 2023 15:02:53 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuut9r5n4-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 15:02:53 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KCAoYX029822;
        Fri, 20 Oct 2023 14:49:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc47n67g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn65n37814638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FE4A20040;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FC2120043;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 08/10] s390x: topology: Rewrite topology list test
Date:   Fri, 20 Oct 2023 16:48:58 +0200
Message-Id: <20231020144900.2213398-9-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cmCWlPWlGE7aojBkcjDJXmVI0LrtlFfy
X-Proofpoint-GUID: CshJMbFz2rDsen-_5rMFn5gAEayZo3UM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200124
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
 s390x/topology.c | 201 ++++++++++++++++++++++++++++-------------------
 2 files changed, 142 insertions(+), 95 deletions(-)

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
index df158aef..037d22cd 100644
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
@@ -342,6 +265,124 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
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
+	unsigned int cpus = 0;
+	int i;
+
+	for (i = 0; (void *)&child[i] < last && child[i].nl == 0; i++) {
+		cpus += check_cpu(&child[i], cont);
+		if (prev_cpu) {
+			report(prev_cpu->type <= child[i].type, "Correct ordering wrt type");
+			if (prev_cpu->type < child[i].type)
+				continue;
+			report(prev_cpu->pp >= child[i].pp, "Correct ordering wrt polarization");
+			if (prev_cpu->pp > child[i].pp)
+				continue;
+			report(prev_cpu->d || !child[i].d, "Correct ordering wrt dedication");
+			if (prev_cpu->d && !child[i].d)
+				continue;
+			report(prev_cpu->origin <= child[i].origin, "Correct ordering wrt origin");
+		}
+		prev_cpu = &child[i];
+	}
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
@@ -372,7 +413,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 
 vertical:
 	report_prefix_pop();
@@ -385,7 +426,7 @@ vertical:
 	}
 
 	stsi_check_header(info, sel2);
-	stsi_check_tle_coherency(info);
+	check_topology_list(info, sel2);
 	report_prefix_pop();
 
 end:
-- 
2.41.0

