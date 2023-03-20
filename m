Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F364E6C0C9C
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 09:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCTI47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCTI4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 04:56:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F19610A8C;
        Mon, 20 Mar 2023 01:56:52 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32K63Cv7029689;
        Mon, 20 Mar 2023 08:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qwTxqo7XurWzd0igKaurjnpLGgaHYg5lJpYfy+8MnOw=;
 b=eOiOf3oVAxGsDI99EFXxnN6blqiaEaAVMxcQ7+ND9D9woWvphIP8fL/jz37HZKCVhROj
 Gy5Oy846zh8Gm1ZWaS6VOVzcWuOvoA0U8yRJuxfncXcjSgNp0hw7FmmuMCDuLGGM+kOG
 oRPzOprhPfsFUNRma7QfvQo5y78xMt1qEnmJczMwauMxsQuM4wEvjr5XJmHUj9jWJdph
 aJ150rvrJsBBGhfdRIoyHRerLVhWvYznf8dNuLL6XOcaZFf7qpG9uu01KYh6y6ioQdmj
 FEj8hfZV5VJN3046f990aet6v7ONfyDKSQVgwdIBsJfWplgjVeDnxptAac5kZszWHczv hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdpyk2q31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32K8XBTl025230;
        Mon, 20 Mar 2023 08:56:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdpyk2q2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K3i9DG017149;
        Mon, 20 Mar 2023 08:56:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6ay3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:49 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32K8uj9B17302026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 08:56:45 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3705A20040;
        Mon, 20 Mar 2023 08:56:45 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E92520043;
        Mon, 20 Mar 2023 08:56:44 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.19.239])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 08:56:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking Configuration Topology Information
Date:   Mon, 20 Mar 2023 09:56:42 +0100
Message-Id: <20230320085642.12251-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230320085642.12251-1-pmorel@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FX4l_KHI9auVHkbdY2-Ny4C7RtfhpYEN
X-Proofpoint-GUID: a2kfSM45VvR8XD4cPgwe4WqUKNLzsAJ6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_04,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 spamscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303150002 definitions=main-2303200072
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

We retrieve the maximum nested level with SCLP and use the
topology tree provided by the drawers, books, sockets, cores
arguments.

We check :
- if the topology stored is coherent between the QEMU -smp
  parameters and kernel parameters.
- the number of CPUs
- the maximum number of CPUs
- the number of containers of each levels for every STSI(15.1.x)
  instruction allowed by the machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c    |   5 +
 lib/s390x/sclp.h    |   4 +-
 lib/s390x/stsi.h    |  36 ++++++
 s390x/topology.c    | 291 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   8 ++
 5 files changed, 343 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 390fde7..9679332 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -238,3 +238,8 @@ uint64_t get_max_ram_size(void)
 {
 	return max_ram_size;
 }
+
+uint64_t sclp_get_stsi_mnest(void)
+{
+	return read_info->stsi_parm;
+}
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 853529b..6a611bc 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -150,7 +150,8 @@ typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
 	uint8_t rnsize;
-	uint8_t  _reserved1[16 - 11];       /* 11-15 */
+	uint8_t  _reserved1[15 - 11];       /* 11-14 */
+	uint8_t stsi_parm;                  /* 15-15 */
 	uint16_t entries_cpu;               /* 16-17 */
 	uint16_t offset_cpu;                /* 18-19 */
 	uint8_t  _reserved2[24 - 20];       /* 20-23 */
@@ -341,5 +342,6 @@ int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
 uint64_t get_max_ram_size(void);
+uint64_t sclp_get_stsi_mnest(void);
 
 #endif /* _S390X_SCLP_H_ */
diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index bebc492..1351a6f 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -29,4 +29,40 @@ struct sysinfo_3_2_2 {
 	uint8_t ext_names[8][256];
 };
 
+#define CPUS_TLE_RES_BITS 0x00fffffff8000000UL
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
+#define CONTAINER_TLE_RES_BITS 0x00ffffffffffff00UL
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
+	union topology_entry tle[];
+};
+
 #endif  /* _S390X_STSI_H_ */
diff --git a/s390x/topology.c b/s390x/topology.c
index ce248f1..11ce931 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -16,6 +16,20 @@
 #include <smp.h>
 #include <sclp.h>
 #include <s390x/hardware.h>
+#include <s390x/stsi.h>
+
+static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static int max_nested_lvl;
+static int number_of_cpus;
+static int cpus_in_masks;
+static int max_cpus;
+
+/*
+ * Topology level as defined by architecture, all levels exists with
+ * a single container unless overwritten by the QEMU -smp parameter.
+ */
+static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL]; // = {1, 1, 1, 1, 1, 1};
 
 #define PTF_REQ_HORIZONTAL	0
 #define PTF_REQ_VERTICAL	1
@@ -147,11 +161,286 @@ static void test_ptf(void)
 	check_polarization_change();
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
+	for (i = 0, n = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
+		n *= info->mag[i] ?: 1;
+
+	report(n == max_cpus, "Calculated max CPUs: %d", n);
+}
+
+/*
+ * stsi_check_mag
+ * @info: Pointer to the stsi information
+ *
+ * MAG field should match the architecture defined containers
+ * when MNEST as returned by SCLP matches MNEST of the SYSIB.
+ */
+static void stsi_check_mag(struct sysinfo_15_1_x *info)
+{
+	int i;
+
+	report_prefix_push("MAG");
+
+	stsi_check_maxcpus(info);
+
+	/* Explicitly skip the test if both mnest do not match */
+	if (max_nested_lvl != info->mnest)
+		goto done;
+
+	/*
+	 * MAG up to max_nested_lvl must match the architecture
+	 * defined containers.
+	 */
+	for (i = 0; i < max_nested_lvl; i++)
+		report(info->mag[CPU_TOPOLOGY_MAX_LEVEL - i - 1] == arch_topo_lvl[i],
+		       "MAG %d field match %d == %d",
+		       i + 1,
+		       info->mag[CPU_TOPOLOGY_MAX_LEVEL - i - 1],
+		       arch_topo_lvl[i]);
+
+	/* Above max_nested_lvl the MAG field must be null */
+	for (; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
+		report(info->mag[CPU_TOPOLOGY_MAX_LEVEL - i - 1] == 0,
+		       "MAG %d field match %d == %d", i + 1,
+		       info->mag[CPU_TOPOLOGY_MAX_LEVEL - i - 1], 0);
+
+done:
+	report_prefix_pop();
+}
+
+/**
+ * check_tle:
+ * @tc: pointer to first TLE
+ *
+ * Recursively check the containers TLEs until we
+ * find a CPU TLE.
+ */
+static uint8_t *check_tle(void *tc)
+{
+	struct topology_container *container = tc;
+	struct topology_core *cpus;
+	int n;
+
+	if (container->nl) {
+		report_info("NL: %d id: %d", container->nl, container->id);
+
+		report(!(*(uint64_t *)tc & CONTAINER_TLE_RES_BITS),
+		       "reserved bits %016lx",
+		       *(uint64_t *)tc & CONTAINER_TLE_RES_BITS);
+
+		return check_tle(tc + sizeof(*container));
+	}
+
+	report_info("NL: %d", container->nl);
+	cpus = tc;
+
+	report(!(*(uint64_t *)tc & CPUS_TLE_RES_BITS), "reserved bits %016lx",
+	       *(uint64_t *)tc & CPUS_TLE_RES_BITS);
+
+	report(cpus->type == 0x03, "type IFL");
+
+	report_info("origin: %d", cpus->origin);
+	report_info("mask: %016lx", cpus->mask);
+	report_info("dedicated: %d entitlement: %d", cpus->d, cpus->pp);
+
+	n = __builtin_popcountl(cpus->mask);
+	report(n <= arch_topo_lvl[0], "CPUs per mask: %d out of max %d",
+	       n, arch_topo_lvl[0]);
+	cpus_in_masks += n;
+
+	report(!cpus->d || (cpus->pp == 3 || cpus->pp == 0),
+	       "Dedication versus entitlement");
+
+	return tc + sizeof(*cpus);
+}
+
+/**
+ * stsi_check_tle_coherency:
+ * @info: Pointer to the stsi information
+ *
+ * We verify that we get the expected number of Topology List Entry
+ * containers for a specific level.
+ */
+static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info)
+{
+	void *tc, *end;
+
+	report_prefix_push("TLE");
+	cpus_in_masks = 0;
+
+	tc = info->tle;
+	end = (void *)info + info->length;
+
+	while (tc < end)
+		tc = check_tle(tc);
+
+	report(cpus_in_masks == number_of_cpus, "CPUs in mask %d",
+	       cpus_in_masks);
+
+	report_prefix_pop();
+}
+
+/**
+ * stsi_get_sysib:
+ * @info: pointer to the STSI info structure
+ * @sel2: the selector giving the topology level to check
+ *
+ * Fill the sysinfo_15_1_x info structure and check the
+ * SYSIB header.
+ *
+ * Returns instruction validity.
+ */
+static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
+{
+	int ret;
+
+	report_prefix_pushf("SYSIB");
+
+	ret = stsi(pagebuf, 15, 1, sel2);
+
+	if (max_nested_lvl >= sel2) {
+		report(!ret, "Valid instruction");
+		report(sel2 == info->mnest, "Valid mnest");
+	} else {
+		report(ret, "Invalid instruction");
+	}
+
+	report_prefix_pop();
+
+	return ret;
+}
+
+/**
+ * check_sysinfo_15_1_x:
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
+	report_prefix_pushf("15_1_%d", sel2);
+
+	ret = stsi_get_sysib(info, sel2);
+	if (!ret) {
+		stsi_check_mag(info);
+		stsi_check_tle_coherency(info);
+	}
+
+	report_prefix_pop();
+}
+
+/*
+ * The Maximum Nested level is given by SCLP READ_SCP_INFO if the MNEST facility
+ * is available.
+ * If the MNEST facility is not available, sclp_get_stsi_mnest  returns 0 and the
+ * Maximum Nested level is 2
+ */
+#define S390_DEFAULT_MNEST	2
+static int sclp_get_mnest(void)
+{
+	return sclp_get_stsi_mnest() ?: S390_DEFAULT_MNEST;
+}
+
+static int arch_max_cpus(void)
+{
+	int i;
+	int ncpus = 1;
+
+	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
+		ncpus *= arch_topo_lvl[i] ?: 1;
+
+	return ncpus;
+}
+
+/**
+ * test_stsi:
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
+	max_cpus = arch_max_cpus();
+	report_info("Architecture max CPUs: %d", max_cpus);
+
+	max_nested_lvl = sclp_get_mnest();
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
+/**
+ * parse_topology_args:
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
+	static const char * const levels[] = { "cores", "sockets",
+					       "books", "drawers" };
+
+	for (i = 1; i < argc; i++) {
+		char *flag = argv[i];
+		int level;
+
+		if (flag[0] != '-')
+			report_abort("Argument is expected to begin with '-'");
+		flag++;
+		for (level = 0; ARRAY_SIZE(levels); level++) {
+			if (!strcmp(levels[level], flag))
+				break;
+		}
+		if (level == ARRAY_SIZE(levels))
+			report_abort("Unknown parameter %s", flag);
+
+		arch_topo_lvl[level] = atol(argv[++i]);
+		report_info("%s: %d", levels[level], arch_topo_lvl[level]);
+	}
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
 
@@ -161,6 +450,8 @@ int main(int argc, char *argv[])
 
 	report_prefix_push("CPU Topology");
 
+	parse_topology_args(argc, argv);
+
 	if (!test_facility(11)) {
 		report_skip("Topology facility not present");
 		goto end;
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d0ac683..7285f60 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -236,3 +236,11 @@ file = ex.elf
 
 [topology]
 file = topology.elf
+# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
+# 1 CPU on socket 2
+extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1 -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
+
+[topology_max]
+# define 240 CPUs
+file = topology.elf
+extra_params = -smp drawers=3,books=4,sockets=5,cores=4,maxcpus=240 -cpu z14,ctop=on -append '-drawers 3 -books 4 -sockets 5 -cores 4'
-- 
2.31.1

