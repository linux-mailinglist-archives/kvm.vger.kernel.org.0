Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34A760B10A
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 18:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiJXQP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 12:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiJXQN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 12:13:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577BFA8CD1;
        Mon, 24 Oct 2022 08:01:58 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OEJkgh020906;
        Mon, 24 Oct 2022 14:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DIjw4NzJXTZKIoYlHbfr0G2wUYijs1GfX1L4RcLxP1o=;
 b=c3/RTcvYPbhZTnhCa0RvlWGMH7EW7TVmIjckG0UK9FdotxXbm7VXjfSpn1NgpCcHr+GZ
 hGi3JlF6PW7oIfX5dwi5k3uU9Ib8CPWyZi2KaCaQXFpjDqemNS6mBxE26OYkLl6LlnYW
 aVIWxXtFTfUIdVcuj/+V+ByOXZYQRQJRQwTEEW8vaqL7P4/msZ+KZQeCqDXW7dVWKOCN
 /JtqbNCeojM6pL+dTIR3Rf/Wh3erSeGOYUZ3tBPDGEIJ3lGF/MLTgjjAj3qkwXjijqoR
 NiPAJL+zo02fSxgXf/4lLmB7tm8dsPX5B9KW21lvFtQvUwXgCO4k7ppWx31wEm4AteBy Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdvcf8186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:44 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29OEK23o022621;
        Mon, 24 Oct 2022 14:20:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdvcf817b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OEKN9P019506;
        Mon, 24 Oct 2022 14:20:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kc859jhya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OEKcFY40567272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 14:20:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20CF852052;
        Mon, 24 Oct 2022 14:20:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.20.45])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9F4A85204F;
        Mon, 24 Oct 2022 14:20:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 2/2] s390x: topology: Checking Configuration Topology Information
Date:   Mon, 24 Oct 2022 16:20:35 +0200
Message-Id: <20221024142035.22668-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221024142035.22668-1-pmorel@linux.ibm.com>
References: <20221024142035.22668-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oswt0ADYpb361NakvgSI2QTM1wPHICGT
X-Proofpoint-GUID: 2ZLROO84aqAXvgDC-efgRUSqIQKJSEb6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STSI with function code 15 is used to store the CPU configuration
topology.

We check :
- if the topology stored is coherent between the QEMU -smp
  parameters and kernel parameters.
- the number of CPUs
- the maximum number of CPUs
- the number of containers of each levels for every STSI(15.1.x)
  instruction allowed by the machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/stsi.h    |  44 ++++++++
 s390x/topology.c    | 238 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg |   1 +
 3 files changed, 281 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index bebc492d..8dbbfc29 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -29,4 +29,48 @@ struct sysinfo_3_2_2 {
 	uint8_t ext_names[8][256];
 };
 
+struct topology_core {
+	uint8_t nl;
+	uint8_t reserved1[3];
+	uint8_t reserved4:5;
+	uint8_t d:1;
+	uint8_t pp:2;
+	uint8_t type;
+	uint16_t origin;
+	uint64_t mask;
+};
+
+struct topology_container {
+	uint8_t nl;
+	uint8_t reserved[6];
+	uint8_t id;
+};
+
+union topology_entry {
+	uint8_t nl;
+	struct topology_core cpu;
+	struct topology_container container;
+};
+
+#define CPU_TOPOLOGY_MAX_LEVEL 6
+struct sysinfo_15_1_x {
+	uint8_t reserved0[2];
+	uint16_t length;
+	uint8_t mag[CPU_TOPOLOGY_MAX_LEVEL];
+	uint8_t reserved0a;
+	uint8_t mnest;
+	uint8_t reserved0c[4];
+	union topology_entry tle[0];
+};
+
+static inline int cpus_in_tle_mask(uint64_t val)
+{
+	int i, n;
+
+	for (i = 0, n = 0; i < 64; i++, val >>= 1)
+		if (val & 0x01)
+			n++;
+	return n;
+}
+
 #endif  /* _S390X_STSI_H_ */
diff --git a/s390x/topology.c b/s390x/topology.c
index ae146d16..842bf99a 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -15,7 +15,16 @@
 #include <asm/facility.h>
 #include <smp.h>
 #include <sclp.h>
-#include <s390x/vm.h>
+#include <s390x/hardware.h>
+#include <s390x/stsi.h>
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+
+static int max_nested_lvl;
+static int number_of_cpus;
+static int max_cpus = 1;
+static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL];	/* Topology level defined by architecture */
+static int stsi_nested_lvl[CPU_TOPOLOGY_MAX_LEVEL];	/* Topology nested level reported in STSI */
 
 #define PTF_REQ_HORIZONTAL	0
 #define PTF_REQ_VERTICAL	1
@@ -85,7 +94,7 @@ static void test_ptf(void)
 	 * any Virtual Machine but KVM.
 	 * Let's skip the polarisation tests for other VMs.
 	 */
-	if (!vm_is_kvm()) {
+	if (!host_is_kvm()) {
 		report_skip("Topology polarisation check is done for KVM only");
 		goto end;
 	}
@@ -99,11 +108,232 @@ end:
 	report_prefix_pop();
 }
 
+/*
+ * stsi_check_maxcpus
+ * @info: Pointer to the stsi information
+ *
+ * The product of the numbers of containers per level
+ * is the maximum number of CPU allowed by the machine.
+ */
+static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
+{
+	int n, i;
+
+	report_prefix_push("maximum cpus");
+
+	for (i = 0, n = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
+		report_info("Mag%d: %d", CPU_TOPOLOGY_MAX_LEVEL - i, info->mag[i]);
+		n *= info->mag[i] ? info->mag[i] : 1;
+	}
+	report(n == max_cpus, "Maximum CPUs %d expected %d", n, max_cpus);
+
+	report_prefix_pop();
+}
+
+/*
+ * stsi_check_tle_coherency
+ * @info: Pointer to the stsi information
+ * @sel2: Topology level to check.
+ *
+ * We verify that we get the expected number of Topology List Entry
+ * containers for a specific level.
+ */
+static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info, int sel2)
+{
+	struct topology_container *tc, *end;
+	struct topology_core *cpus;
+	int n = 0;
+	int i;
+
+	report_prefix_push("TLE coherency");
+
+	tc = &info->tle[0].container;
+	end = (struct topology_container *)((unsigned long)info + info->length);
+
+	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
+		stsi_nested_lvl[i] = 0;
+
+	while (tc < end) {
+		if (tc->nl > 5) {
+			report_abort("Unexpected TL Entry: tle->nl: %d", tc->nl);
+			return;
+		}
+		if (tc->nl == 0) {
+			cpus = (struct topology_core *)tc;
+			n += cpus_in_tle_mask(cpus->mask);
+			report_info("cpu type %02x  d: %d pp: %d", cpus->type, cpus->d, cpus->pp);
+			report_info("origin : %04x mask %016lx", cpus->origin, cpus->mask);
+		}
+
+		stsi_nested_lvl[tc->nl]++;
+		report_info("level %d: lvl: %d id: %d cnt: %d",
+			    tc->nl, tc->nl, tc->id, stsi_nested_lvl[tc->nl]);
+
+		/* trick: CPU TLEs are twice the size of containers TLE */
+		if (tc->nl == 0)
+			tc++;
+		tc++;
+	}
+	report(n == number_of_cpus, "Number of CPUs  : %d expect %d", n, number_of_cpus);
+	/*
+	 * For KVM we accept
+	 * - only 1 type of CPU
+	 * - only horizontal topology
+	 * - only dedicated CPUs
+	 * This leads to expect the number of entries of level 0 CPU
+	 * Topology Level Entry (TLE) to be:
+	 * 1 + (number_of_cpus - 1)  / arch_topo_lvl[0]
+	 *
+	 * For z/VM or LPAR this number can only be greater if different
+	 * polarity, CPU types because there may be a nested level 0 CPU TLE
+	 * for each of the CPU/polarity/sharing types in a level 1 container TLE.
+	 */
+	n =  (number_of_cpus - 1)  / arch_topo_lvl[0];
+	report(stsi_nested_lvl[0] >=  n + 1,
+	       "CPU Type TLE    : %d expect %d", stsi_nested_lvl[0], n + 1);
+
+	/* For each level found in STSI */
+	for (i = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
+		/*
+		 * For non QEMU/KVM hypervisor the concatenation of the levels
+		 * above level 1 are architecture dependent.
+		 * Skip these checks.
+		 */
+		if (!host_is_kvm() && sel2 != 2)
+			continue;
+
+		/* For QEMU/KVM we expect a simple calculation */
+		if (sel2 > i) {
+			report(stsi_nested_lvl[i] ==  n + 1,
+			       "Container TLE  %d: %d expect %d", i, stsi_nested_lvl[i], n + 1);
+			n /= arch_topo_lvl[i];
+		}
+	}
+
+	report_prefix_pop();
+}
+
+/*
+ * check_sysinfo_15_1_x
+ * @info: pointer to the STSI info structure
+ * @sel2: the selector giving the topology level to check
+ *
+ * Check if the validity of the STSI instruction and then
+ * calls specific checks on the information buffer.
+ */
+static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
+{
+	int ret;
+
+	report_prefix_pushf("mnested %d 15_1_%d", max_nested_lvl, sel2);
+
+	ret = stsi(pagebuf, 15, 1, sel2);
+	if (max_nested_lvl >= sel2) {
+		report(!ret, "Valid stsi instruction");
+	} else {
+		report(ret, "Invalid stsi instruction");
+		goto end;
+	}
+
+	stsi_check_maxcpus(info);
+	stsi_check_tle_coherency(info, sel2);
+
+end:
+	report_prefix_pop();
+}
+
+/*
+ * test_stsi
+ *
+ * Retrieves the maximum nested topology level supported by the architecture
+ * and the number of CPUs.
+ * Calls the checking for the STSI instruction in sel2 reverse level order
+ * from 6 (CPU_TOPOLOGY_MAX_LEVEL) to 2 to have the most interesting level,
+ * the one triggering a topology-change-report-pending condition, level 2,
+ * at the end of the report.
+ *
+ */
+static void test_stsi(void)
+{
+	int sel2;
+
+	report_info("SCLP maximum nested level : %d", max_nested_lvl);
+
+	number_of_cpus = sclp_get_cpu_num();
+	report_info("SCLP number of CPU: %d", number_of_cpus);
+
+	/* STSI selector 2 can takes values between 2 and 6 */
+	for (sel2 = 6; sel2 >= 2; sel2--)
+		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf, sel2);
+}
+
+/*
+ * parse_topology_args
+ * @argc: number of arguments
+ * @argv: argument array
+ *
+ * This function initialize the architecture topology levels
+ * which should be the same as the one provided by the hypervisor.
+ *
+ * We use the current names found in IBM/Z literature, Linux and QEMU:
+ * cores, sockets/packages, books, drawers and nodes to facilitate the
+ * human machine interface but store the result in a machine abstract
+ * array of architecture topology levels.
+ * Note that when QEMU uses socket as a name for the topology level 1
+ * Linux uses package or physical_package.
+ */
+static void parse_topology_args(int argc, char **argv)
+{
+	int i;
+
+	report_info("%d arguments", argc);
+	for (i = 1; i < argc; i++) {
+		if (!strcmp("-mnest", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-mnest (maximum nested level) needs a parameter");
+			max_nested_lvl = atol(argv[i]);
+		} else if (!strcmp("-cores", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-cores needs a parameter");
+			arch_topo_lvl[0] = atol(argv[i]);
+			report_info("cores: %d", arch_topo_lvl[0]);
+		} else if (!strcmp("-sockets", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-sockets needs a parameter");
+			arch_topo_lvl[1] = atol(argv[i]);
+			report_info("sockets: %d", arch_topo_lvl[1]);
+		}
+	}
+
+	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
+		if (!arch_topo_lvl[i])
+			arch_topo_lvl[i] = 1;
+		max_cpus *= arch_topo_lvl[i];
+	}
+}
+
+/*
+ * Heuristic, measures on LPAR shows that the maximum nested
+ * levels value is 4.
+ * QEMU have a maximum nexted level of 2.
+ */
+static void set_default_mnest(void)
+{
+	if (host_is_qemu())
+		max_nested_lvl = 2;
+	else if (host_is_lpar())
+		max_nested_lvl = 4;
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
 	{ "PTF", test_ptf},
+	{ "STSI", test_stsi},
 	{ NULL, NULL }
 };
 
@@ -113,6 +343,10 @@ int main(int argc, char *argv[])
 
 	report_prefix_push("CPU Topology");
 
+	set_default_mnest();
+
+	parse_topology_args(argc, argv);
+
 	if (!test_facility(11)) {
 		report_skip("Topology facility not present");
 		goto end;
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3530cc4c..6dadf23d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -211,3 +211,4 @@ smp = 2
 
 [topology]
 file = topology.elf
+extra_params=-smp 5,sockets=4,cores=4,maxcpus=16 -append '-mnest 2 -sockets 4 -cores 4'
-- 
2.31.1

