Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FC7489A10
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 14:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiAJNg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 08:36:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232362AbiAJNg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 08:36:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ADMgYC028324;
        Mon, 10 Jan 2022 13:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tS2oB09IDstAatWzssNQFK/V6UJySOwoBm84tEk+6ao=;
 b=jXWoRSPZPxtmEICgmUblx2V2Q5NvoEwiyTbGPUyN4b6yNkKJvExTFyqhwdvXoqeShXxP
 ZHNArjdCbymGJoHe4FvVsXI1c/F0TYWRdsw/e1qcA8MtD59nCo2r/okdn4XmCtBwivG2
 UF49BjFSe6oB64PQ+TEsuDJ3UUmMlTOSrJCOHK/lDcx3Exe/9vUUNjhQ5yKP4RMOcA8o
 HJOHMdJiUEMNSgW6IWWx6xBr9aMFcNHx0trPDtBF/gBilil512LksbBbcmL+taul2Q4y
 RMRaswDJKZFi5i8LDdmAuMPCMHEYigeDkWh9L4/4Mtvk7IdAz8/bfch12keSlSKsoYP4 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm6pu186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ADWIRV006998;
        Mon, 10 Jan 2022 13:36:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm6pu17d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ADVqcX003093;
        Mon, 10 Jan 2022 13:36:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vhnctg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ADRNOd35127566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:27:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E3642102;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 500054205F;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.85.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/4] s390x: lib: Add SCLP toplogy nested level
Date:   Mon, 10 Jan 2022 14:37:52 +0100
Message-Id: <20220110133755.22238-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110133755.22238-1-pmorel@linux.ibm.com>
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hA7WW08co1GyWN8of3sRgdTsqKN41ZKO
X-Proofpoint-GUID: v-iUKOmupXT0ru4Gnr6oL6Cs6nKgVx6I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_06,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201100095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum CPU Topology nested level is available with the SCLP
READ_INFO command inside the byte at offset 15 of the ReadInfo
structure.

Let's return this information to check the number of topology nested
information available with the STSI 15.1.x instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/sclp.c | 6 ++++++
 lib/s390x/sclp.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 33985eb4..e15b3b2c 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -128,6 +128,12 @@ int sclp_get_cpu_num(void)
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
index fead007a..541eb441 100644
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
@@ -323,6 +324,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
+int sclp_get_stsi_parm(void);
 CPUEntry *sclp_get_cpu_entries(void);
 void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
-- 
2.27.0

