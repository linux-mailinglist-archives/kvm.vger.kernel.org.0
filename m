Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE406878CD
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 10:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBBJ2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 04:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjBBJ2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 04:28:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F391969E;
        Thu,  2 Feb 2023 01:28:24 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3127oOBr025902;
        Thu, 2 Feb 2023 09:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gVOPArrThz9uhf1eTcKzuO6vuGs6mfN7Gdt/YT4pV00=;
 b=dsSmzAWysbcQJ9huOnTOjfUXTkwd1TMwhPWUEoMtmQTDGLb02hGJ1pbp8ibFKtnGlf+1
 +cMoROLyMsgaoxmsqLPJedUkwTXYPRxYnP3znaiFUyNeF769z+w7NsOUY3hAOusj1N7h
 0wPmmws8Va4P91fj/1O82Qbp9Lwrlq9vr8udA731YwJFJWmYa5FxdzC9R/HT0mpHD/0m
 3X6Jc91hTDWem9KShRUewh3M7MIT4i2cFlWqcWyd+u142ZJz5y/0xayBtHh4q0ZWCv2P
 fHd8ohrTW/SYeLZ0dzdiaX59KfnWkKK+T38MgGQDa0d4XDYPUu7GrZ3SLRVwm6o0IQ53 xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng94yj8cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3127w4KT020806;
        Thu, 2 Feb 2023 09:28:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng94yj8c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311JfsQW014735;
        Thu, 2 Feb 2023 09:28:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ncvttwyk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3129SHtv47645182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 09:28:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 591D32004D;
        Thu,  2 Feb 2023 09:28:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B34BE20043;
        Thu,  2 Feb 2023 09:28:16 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.28.52])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 09:28:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 2/2] s390x: topology: Checking Configuration Topology Information
Date:   Thu,  2 Feb 2023 10:28:14 +0100
Message-Id: <20230202092814.151081-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230202092814.151081-1-pmorel@linux.ibm.com>
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7tml0u6OtQkXp5NeoF5oIKNzlZXW8WIA
X-Proofpoint-GUID: GHSnc09e80SPv8lQ1krNKpN3dmnMqvxS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_01,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=859 bulkscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 lib/s390x/sclp.h    |   3 +-
 lib/s390x/stsi.h    |  44 ++++++++
 s390x/topology.c    | 244 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   1 +
 4 files changed, 291 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 853529b..6ecfb0a 100644
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
diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index bebc492..8dbbfc2 100644
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
index 20f7ba2..f21c653 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -16,6 +16,18 @@
 #include <smp.h>
 #include <sclp.h>
 #include <s390x/hardware.h>
+#include <s390x/stsi.h>
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+
+static int max_nested_lvl;
+static int number_of_cpus;
+static int max_cpus = 1;
+
+/* Topology level as defined by architecture */
+static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL];
+/* Topology nested level as reported in STSI */
+static int stsi_nested_lvl[CPU_TOPOLOGY_MAX_LEVEL];
 
 #define PTF_REQ_HORIZONTAL	0
 #define PTF_REQ_VERTICAL	1
@@ -122,11 +134,241 @@ end:
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
+static int sclp_get_mnest(void)
+{
+	ReadInfo *sccb = (void *)_sccb;
+
+	sclp_mark_busy();
+	memset(_sccb, 0, PAGE_SIZE);
+	sccb->h.length = PAGE_SIZE;
+
+	sclp_service_call(SCLP_CMDW_READ_SCP_INFO, sccb);
+	assert(sccb->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION);
+
+	return sccb->stsi_parm;
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
+		if (!strcmp("-cores", argv[i])) {
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
+		} else if (!strcmp("-books", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-books needs a parameter");
+			arch_topo_lvl[2] = atol(argv[i]);
+			report_info("books: %d", arch_topo_lvl[2]);
+		} else if (!strcmp("-drawers", argv[i])) {
+			i++;
+			if (i >= argc)
+				report_abort("-drawers needs a parameter");
+			arch_topo_lvl[3] = atol(argv[i]);
+			report_info("drawers: %d", arch_topo_lvl[3]);
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
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
 	{ "PTF", test_ptf},
+	{ "STSI", test_stsi},
 	{ NULL, NULL }
 };
 
@@ -136,6 +378,8 @@ int main(int argc, char *argv[])
 
 	report_prefix_push("CPU Topology");
 
+	parse_topology_args(argc, argv);
+
 	if (!test_facility(11)) {
 		report_skip("Topology facility not present");
 		goto end;
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3530cc4..b697aca 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -211,3 +211,4 @@ smp = 2
 
 [topology]
 file = topology.elf
+extra_params=-smp 5,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
-- 
2.31.1

