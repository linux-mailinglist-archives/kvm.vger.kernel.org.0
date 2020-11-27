Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB32C6666
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgK0NJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:09:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729874AbgK0NJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:09:12 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCWh9D181417;
        Fri, 27 Nov 2020 08:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dCuRmNlHkF7zTHmbcinSmdJygmI/9pM6oX0ohxvH4xQ=;
 b=KVlhn2isSdR8xmLep68aSTbW0KnPElcoeM4AAXwtv4Dc7sEKxkvNvwCYu4S04KOwC6bT
 CBS+ddsos27MIrJH5Hjok9ICC2CTXjReQKWYaSPDSjTOSubr4otHM3XgOZkAgEvrwwfs
 ScxpQKPTPX4yUfUF9U4beWfV+N9VymONIa1F3r4cD+baa+eK+Lz/AHkw9hEuB/v5Y0mO
 Y/oHiL85g62Fes56UrYF4r0fiW1GDSuulFEi2ulhtv6SDuWRPM45c65Ajpvndn7/hU9r
 BOFDbvrIwQ0q7fjLg+QW38w8Nsp6r9GmdkNZjw5EhDn5yyunmr709c02Ks4cIY/I9cvV HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3530kaacnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:09:11 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARCWoLa181744;
        Fri, 27 Nov 2020 08:09:11 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3530kaacn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:09:10 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCSOvs024042;
        Fri, 27 Nov 2020 13:09:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 352jgsh05c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:09:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARD6ZH144433898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 13:06:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD5B34C05E;
        Fri, 27 Nov 2020 13:06:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24C8F4C046;
        Fri, 27 Nov 2020 13:06:35 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 13:06:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/7] s390x: SCLP feature checking
Date:   Fri, 27 Nov 2020 08:06:25 -0500
Message-Id: <20201127130629.120469-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127130629.120469-1-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_06:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=1 spamscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of SIE is announced via a feature bit in a SCLP info CPU
entry. Let's add a framework that allows us to easily check for such
facilities.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 19 +++++++++++++++++++
 lib/s390x/sclp.h | 13 ++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index e19a1f3..e843601 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -37,6 +37,7 @@ void setup(void)
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
+	sclp_facilities_setup();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index ff56c44..68833b5 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -11,6 +11,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <asm/interrupt.h>
@@ -27,6 +28,7 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static ReadInfo *read_info;
+struct sclp_facilities sclp_facilities;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (void *)read_info + read_info->offset_cpu;
 }
 
+void sclp_facilities_setup(void)
+{
+	unsigned short cpu0_addr = stap();
+	CPUEntry *cpu;
+	int i;
+
+	assert(read_info);
+
+	cpu = (void *)read_info + read_info->offset_cpu;
+	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
+		if (cpu->address == cpu0_addr) {
+			sclp_facilities.has_sief2 = cpu->feat_sief2;
+			break;
+		}
+	}
+}
+
 /* Perform service call. Return 0 on success, non-zero otherwise. */
 int sclp_service_call(unsigned int command, void *sccb)
 {
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6620531..e18f7e6 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -95,12 +95,22 @@ typedef struct SCCBHeader {
 typedef struct CPUEntry {
     uint8_t address;
     uint8_t reserved0;
-    uint8_t features[SCCB_CPU_FEATURE_LEN];
+    uint8_t : 4;
+    uint8_t feat_sief2 : 1;
+    uint8_t : 3;
+    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
     uint8_t reserved2[6];
     uint8_t type;
     uint8_t reserved1;
 } __attribute__((packed)) CPUEntry;
 
+extern struct sclp_facilities sclp_facilities;
+
+struct sclp_facilities {
+	uint64_t has_sief2 : 1;
+	uint64_t : 63;
+};
+
 typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
@@ -274,6 +284,7 @@ void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
 CPUEntry *sclp_get_cpu_entries(void);
+void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
-- 
2.25.1

