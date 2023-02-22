Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6279C69F65E
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 15:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBVOV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 09:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjBVOVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 09:21:25 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8132937B7C
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:21:24 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MDa1gD018701;
        Wed, 22 Feb 2023 14:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3eu0zFICVookgj1YRxiGpwqJlzDHo02+NaMVsBUQU+k=;
 b=Dy/twpWV706t4W5deLc5tMgXPo4wmD+aO03s879qC8nHt1cv8PByZij/a0DUZ3Hn9j4i
 xwcoeZPwVVrFYtggYHajgn0P1pg+OGY0JUrsOfmUGEUNoqzSF0tcuEofTMS5uZW1jYhr
 +3QWuIF5mBW79M72BfU+HfsXdQsrIdOxw/Q4tdQlV5S8dDYZRi22yDraOSiY/kfM4cKk
 t7h3o/+tmccCA0TEOJMXgBpAkiRAKMwb752QZmqxIrC6zLCcpBZgtGjc2zOKTFjfXM61
 BAgTcdbnkxYPTL6YXU5xWk7nKRkuiHxID0HduGfk7QNqBZ0FQZ3LmLtn9VL7fm/LBwr0 FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm2yh9dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:13 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ME0TRl021219;
        Wed, 22 Feb 2023 14:21:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm2yh9d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31M13C4a007338;
        Wed, 22 Feb 2023 14:21:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6dfdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:11 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MEL7bZ42402148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 14:21:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFCEF20040;
        Wed, 22 Feb 2023 14:21:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48DE22004B;
        Wed, 22 Feb 2023 14:21:07 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 14:21:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v16 04/11] s390x/sclp: reporting the maximum nested topology entries
Date:   Wed, 22 Feb 2023 15:20:58 +0100
Message-Id: <20230222142105.84700-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230222142105.84700-1-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eo5jHcRWT2s1SWK1GGGSv6aWlGKb1FDL
X-Proofpoint-GUID: ZvQDkRNDnAkMif1phO_FMBT7W-R6yH6D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302220122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum nested topology entries is used by the guest to
know how many nested topology are available on the machine.

Let change the MNEST value from 2 to 4 in the SCLP READ INFO
structure now that we support books and drawers.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 include/hw/s390x/sclp.h | 5 +++--
 hw/s390x/sclp.c         | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index 712fd68123..902252b319 100644
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
+    uint8_t stsi_parm;                  /* 15-15 */
     uint16_t entries_cpu;               /* 16-17 */
     uint16_t offset_cpu;                /* 18-19 */
     uint8_t  _reserved2[24 - 20];       /* 20-23 */
diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index eff74479f4..d339cbb7e4 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -20,6 +20,7 @@
 #include "hw/s390x/event-facility.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/ipl.h"
+#include "hw/s390x/cpu-topology.h"
 
 static inline SCLPDevice *get_sclp_device(void)
 {
@@ -123,6 +124,10 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
         return;
     }
 
+    if (s390_has_topology()) {
+        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
+    }
+
     /* CPU information */
     prepare_cpu_entries(machine, entries_start, &cpu_count);
     read_info->entries_cpu = cpu_to_be16(cpu_count);
-- 
2.31.1

