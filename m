Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223F465EF6B
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjAEOyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjAEOyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB15BA06
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:00 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Eolns021339;
        Thu, 5 Jan 2023 14:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4XbdqSg29A4QtjfzyCWmXNUKMNG4NiwGYUouTXfz8gI=;
 b=c8kYstzS5XzU2kSsyjmoF97LczlK/ssA3l7gjCfLC+OUboKT1tFMyg88/54qMW5+gK2z
 Ndn1ZglXTLs1aQU9dMRJE7pjVfaC/QfsKg3lfNRfbRKvkKgsAuXE44lm4I60V77EO/fn
 6UqYG3PwSsU0ytqU6MF9/1Qt4s/fw+ZF/8md1hT040k2h+E1EEy5f0ZXoClS3UrjXHvM
 4VkYKaQP8FW4MFJO8aXkyU9C4QngzSyeYreSv+WcV0GbzLkzpMT7gRQKJIFtjnL7KXsP
 7g/zz52mRlNloOG2KYCTXA0vcFQzV02Tul4VQ+0OirJwiKMVnEEC6giUsOUZscGpOVjY RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0p101sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:26 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305Eq8uf028646;
        Thu, 5 Jan 2023 14:53:26 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0p101s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305DESrU028726;
        Thu, 5 Jan 2023 14:53:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mtcbfn3bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErKs135062140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4F3A2004B;
        Thu,  5 Jan 2023 14:53:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A02520049;
        Thu,  5 Jan 2023 14:53:19 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:18 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested topology entries
Date:   Thu,  5 Jan 2023 15:53:06 +0100
Message-Id: <20230105145313.168489-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9etx2hSWC-Isj-F9PiE5d2FoL2wRYysp
X-Proofpoint-ORIG-GUID: GtZBef6pTThgUVnEjTQVHePTHE1ntGwe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=880 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum nested topology entries is used by the guest to know
how many nested topology are available on the machine.

Currently, SCLP READ SCP INFO reports MNEST = 0, which is the
equivalent of reporting the default value of 2.
Let's use the default SCLP value of 2 and increase this value in the
future patches implementing higher levels.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/sclp.h | 5 +++--
 hw/s390x/sclp.c         | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index 712fd68123..4ce852473c 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -112,12 +112,13 @@ typedef struct CPUEntry {
 } QEMU_PACKED CPUEntry;
 
 #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
-#define SCLP_READ_SCP_INFO_MNEST                2
+#define SCLP_READ_SCP_INFO_MNEST                4
 typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
     uint8_t rnsize;
-    uint8_t  _reserved1[16 - 11];       /* 11-15 */
+    uint8_t  _reserved1[15 - 11];       /* 11-14 */
+    uint8_t  stsi_parm;                 /* 15-16 */
     uint16_t entries_cpu;               /* 16-17 */
     uint16_t offset_cpu;                /* 18-19 */
     uint8_t  _reserved2[24 - 20];       /* 20-23 */
diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index eff74479f4..07e3cb4cac 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -20,6 +20,7 @@
 #include "hw/s390x/event-facility.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/ipl.h"
+#include "hw/s390x/cpu-topology.h"
 
 static inline SCLPDevice *get_sclp_device(void)
 {
@@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
 
     /* CPU information */
     prepare_cpu_entries(machine, entries_start, &cpu_count);
+    if (s390_has_topology()) {
+        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
+    }
     read_info->entries_cpu = cpu_to_be16(cpu_count);
     read_info->offset_cpu = cpu_to_be16(offset_cpu);
     read_info->highest_cpu = cpu_to_be16(machine->smp.max_cpus - 1);
-- 
2.31.1

