Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1762C6648
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgK0NGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:06:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729913AbgK0NGm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:06:42 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCXRx2157382;
        Fri, 27 Nov 2020 08:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gnA6VjrfI7l5pN7+f9zxBkVs77NSTk5PQT8xijBl3H4=;
 b=CUDDFd3CU+AsDW/qdbioQewLvoqlLiGvhtp+W+wGpmJyhkVwT3lKPzTVOWnO2elCmIpC
 Y7VlfWT86CRyfJC+yj7wFgIOn711Iu6BURn/ShhqAvhtaHJrahrjfOYZKBpn8qo+yEpP
 OXK5ot6qdW8nyN36Mjp8SoVxq/d3VPVRtRne90uEETGA+y9jOp6v+lr6N3bb8Vhh6DMu
 8TI9qCTEyONyZoiZxqlalhwx6wphHTUzOHDlI1dULs3JVXuoAp4/KtFUFrdu6TAZgGUY
 y1DM6Go0EHnUV57H0jP2/rMGVwm/kpEPhf1nYpUw+Vqpb9zZzhEF3BHbhHOojIE2dKlK GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352wxxy1sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:40 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARCY3id163002;
        Fri, 27 Nov 2020 08:06:40 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352wxxy1rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:40 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCSREO024095;
        Fri, 27 Nov 2020 13:06:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 352jgsh028-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:06:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARD6ZB11835584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 13:06:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F06A64C04A;
        Fri, 27 Nov 2020 13:06:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36D214C046;
        Fri, 27 Nov 2020 13:06:34 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 13:06:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/7] s390x: Consolidate sclp read info
Date:   Fri, 27 Nov 2020 08:06:24 -0500
Message-Id: <20201127130629.120469-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127130629.120469-1-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_06:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=1 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011270078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only read the information once and pass a pointer to it instead
of calling sclp multiple times.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
 lib/s390x/sclp.h |  3 +++
 lib/s390x/smp.c  | 28 +++++++++++-----------------
 4 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index c0f0bf7..e19a1f3 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -36,6 +36,7 @@ void setup(void)
 {
 	setup_args_progname(ipl_args);
 	setup_facilities();
+	sclp_read_info();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 4e2ac18..ff56c44 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -25,6 +25,8 @@ extern unsigned long stacktop;
 static uint64_t storage_increment_size;
 static uint64_t max_ram_size;
 static uint64_t ram_size;
+char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
+static ReadInfo *read_info;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -110,6 +112,22 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
 	report_abort("READ_SCP_INFO failed");
 }
 
+void sclp_read_info(void)
+{
+	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
+	read_info = (ReadInfo *)_read_info;
+}
+
+int sclp_get_cpu_num(void)
+{
+	return read_info->entries_cpu;
+}
+
+CPUEntry *sclp_get_cpu_entries(void)
+{
+	return (void *)read_info + read_info->offset_cpu;
+}
+
 /* Perform service call. Return 0 on success, non-zero otherwise. */
 int sclp_service_call(unsigned int command, void *sccb)
 {
@@ -127,23 +145,22 @@ int sclp_service_call(unsigned int command, void *sccb)
 
 void sclp_memory_setup(void)
 {
-	ReadInfo *ri = (void *)_sccb;
 	uint64_t rnmax, rnsize;
 	int cc;
 
-	sclp_read_scp_info(ri, SCCB_SIZE);
+	assert(read_info);
 
 	/* calculate the storage increment size */
-	rnsize = ri->rnsize;
+	rnsize = read_info->rnsize;
 	if (!rnsize) {
-		rnsize = ri->rnsize2;
+		rnsize = read_info->rnsize2;
 	}
 	storage_increment_size = rnsize << 20;
 
 	/* calculate the maximum memory size */
-	rnmax = ri->rnmax;
+	rnmax = read_info->rnmax;
 	if (!rnmax) {
-		rnmax = ri->rnmax2;
+		rnmax = read_info->rnmax2;
 	}
 	max_ram_size = rnmax * storage_increment_size;
 
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 675f07e..6620531 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -271,6 +271,9 @@ void sclp_wait_busy(void);
 void sclp_mark_busy(void);
 void sclp_console_setup(void);
 void sclp_print(const char *str);
+void sclp_read_info(void);
+int sclp_get_cpu_num(void);
+CPUEntry *sclp_get_cpu_entries(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 77d80ca..f77ad1e 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -25,7 +25,6 @@
 #include "smp.h"
 #include "sclp.h"
 
-static char cpu_info_buffer[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static struct cpu *cpus;
 static struct cpu *cpu0;
 static struct spinlock lock;
@@ -34,8 +33,7 @@ extern void smp_cpu_setup_state(void);
 
 int smp_query_num_cpus(void)
 {
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
-	return info->nr_configured;
+	return sclp_get_cpu_num();
 }
 
 struct cpu *smp_cpu_from_addr(uint16_t addr)
@@ -228,10 +226,10 @@ void smp_teardown(void)
 {
 	int i = 0;
 	uint16_t this_cpu = stap();
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+	int num = smp_query_num_cpus();
 
 	spin_lock(&lock);
-	for (; i < info->nr_configured; i++) {
+	for (; i < num; i++) {
 		if (cpus[i].active &&
 		    cpus[i].addr != this_cpu) {
 			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
@@ -245,22 +243,18 @@ extern uint64_t *stackptr;
 void smp_setup(void)
 {
 	int i = 0;
+	int num = smp_query_num_cpus();
 	unsigned short cpu0_addr = stap();
-	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+	struct CPUEntry *entry = sclp_get_cpu_entries();
 
-	spin_lock(&lock);
-	sclp_mark_busy();
-	info->h.length = PAGE_SIZE;
-	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
+	if (num > 1)
+		printf("SMP: Initializing, found %d cpus\n", num);
 
-	if (smp_query_num_cpus() > 1)
-		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
-
-	cpus = calloc(info->nr_configured, sizeof(cpus));
-	for (i = 0; i < info->nr_configured; i++) {
-		cpus[i].addr = info->entries[i].address;
+	cpus = calloc(num, sizeof(cpus));
+	for (i = 0; i < num; i++) {
+		cpus[i].addr = entry[i].address;
 		cpus[i].active = false;
-		if (info->entries[i].address == cpu0_addr) {
+		if (entry[i].address == cpu0_addr) {
 			cpu0 = &cpus[i];
 			cpu0->stack = stackptr;
 			cpu0->lowcore = (void *)0;
-- 
2.25.1

