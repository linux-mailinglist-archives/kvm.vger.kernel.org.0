Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1C63E41D5
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhHIIti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234036AbhHIIt1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:49:27 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798ZLsY024960;
        Mon, 9 Aug 2021 04:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=JQu0Ae2sq2CFtm+EyyHhqWHYlMfvGwwqyUfJNCsZ8is=;
 b=SFBqKoYjaUG7gQXtm9rYpJj0nUCvu2sUo8UVOz22s4kG4VEUuO4cR0c7RoSB+S74MjAl
 V21raL+ipt+WIM1uosBRmKb8bmli+Qg6Ra7ukakLqcNiqwwB/LIZS5n9p7ctleBG8dfr
 ttHD7qtv15G2ypXY06Lw4G4uvMv/9n8HKW5KKb/b4A3PCZvuHCz7aJxmD1aOsKCFj+BK
 FdQbpxDFJLcEYiMz/GRPTp05cSletAuY0tv/v1Y5ZanNLHv5mRBLS8QWrFYWMk8s8dn0
 zSknqNpnrFH5+5I9TOG3Vml3eBOlWcKY9Q+2ItqDNaeUjgeXS5d5LYmVgvoLHlVL9k1t xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa78t1utq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:03 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1798ZXm8027149;
        Mon, 9 Aug 2021 04:49:03 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa78t1usy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:02 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798m6uJ003746;
        Mon, 9 Aug 2021 08:49:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3a9ht8k9g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:49:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798mujF53084578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:48:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD6AB42041;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 502184204B;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] s390x: lib: Add SCLP toplogy nested level
Date:   Mon,  9 Aug 2021 10:48:51 +0200
Message-Id: <1628498934-20735-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W4dk_eewj2H91z-50alW9dHfUHzVuqxD
X-Proofpoint-GUID: APOdZfVHathere8NYubT8fbSXDZveEg1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum CPU Topology nested level is available with the SCLP
READ_INFO command inside the byte at offset 15 of the ReadInfo
structure.

Let's return this information to check the number of topology nested
information available with the STSI 15.1.x instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 6 ++++++
 lib/s390x/sclp.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 9502d161..ee379ddf 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
 	return read_info->entries_cpu;
 }
 
+int sclp_get_stsi_parm(void)
+{
+	assert(read_info);
+	return read_info->stsi_parm;
+}
+
 CPUEntry *sclp_get_cpu_entries(void)
 {
 	assert(read_info);
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 28e526e2..1a365958 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -146,7 +146,8 @@ typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
 	uint8_t rnsize;
-	uint8_t  _reserved1[16 - 11];       /* 11-15 */
+	uint8_t  _reserved1[15 - 11];       /* 11-14 */
+	uint8_t stsi_parm;
 	uint16_t entries_cpu;               /* 16-17 */
 	uint16_t offset_cpu;                /* 18-19 */
 	uint8_t  _reserved2[24 - 20];       /* 20-23 */
@@ -322,6 +323,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
+int sclp_get_stsi_parm(void);
 CPUEntry *sclp_get_cpu_entries(void);
 void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
-- 
2.25.1

