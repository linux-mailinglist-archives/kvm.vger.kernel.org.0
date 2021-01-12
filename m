Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E11C2F317E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbhALNV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:21:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52974 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbhALNV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:21:59 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CDCfWO147430;
        Tue, 12 Jan 2021 08:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3nfVSqIDucRs07ASsbfEZd5kfYYlRSSzmSpwSHWiEmU=;
 b=S0phzV8hBMyf1h5ExrboNqH8lH8XHxAvkiZJ1dqS4kLk6JFt0lpfJ90bbx889R8u+qhn
 tJNf8aW1vqwuLOi/sHndFnR81jyc53NuTWGCmsOWNq7lN8+cJIFiBZaKrJfbk1bszBPl
 mV2PJBPc2XO41j8SCPRjXMFblq5lfW0OJJ3DKH9UcPYOsqpd48na+BH2HsC6gzFXBQb2
 U+T58gooIwe/N+6T4URhFFHOe1OozkeSOjeCk+0DyGllaELHEJm957rCELhrdFKuJYJG
 FLSmvGzV4EqBNg1l7pi2MLK2CPG5JQ1+v41rD7GwlRIyoGt9OWE6YCdRahIzXAOXGSDX iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cf1084y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:17 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CDCkGF147500;
        Tue, 12 Jan 2021 08:21:17 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cf1083y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:17 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDH7bm015900;
        Tue, 12 Jan 2021 13:21:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447unt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDL7M629884820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1421C4C04E;
        Tue, 12 Jan 2021 13:21:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CCB54C059;
        Tue, 12 Jan 2021 13:21:11 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/9] s390x: SCLP feature checking
Date:   Tue, 12 Jan 2021 08:20:48 -0500
Message-Id: <20210112132054.49756-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of SIE is announced via a feature bit in a SCLP info CPU
entry. Let's add a framework that allows us to easily check for such
facilities.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 25 +++++++++++++++++++++++++
 lib/s390x/sclp.h | 13 ++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index 6a1da63..ef9f59e 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -35,6 +35,7 @@ void setup(void)
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
+	sclp_facilities_setup();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 12916f5..06819a6 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -25,6 +25,7 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 static ReadInfo *read_info;
+struct sclp_facilities sclp_facilities;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -128,6 +129,30 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (CPUEntry *)(_read_info + read_info->offset_cpu);
 }
 
+void sclp_facilities_setup(void)
+{
+	unsigned short cpu0_addr = stap();
+	CPUEntry *cpu;
+	int i;
+
+	assert(read_info);
+
+	cpu = sclp_get_cpu_entries();
+	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
+		/*
+		 * The logic for only reading the facilities from the
+		 * boot cpu comes from the kernel. I haven't yet found
+		 * documentation that explains why this is necessary
+		 * but I figure there's a reason behind doing it this
+		 * way.
+		 */
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
index acd86d5..6c86037 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -92,12 +92,22 @@ typedef struct SCCBHeader {
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
@@ -271,6 +281,7 @@ void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
 CPUEntry *sclp_get_cpu_entries(void);
+void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
-- 
2.25.1

