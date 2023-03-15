Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91916BB626
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCOOfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjCOOfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:35:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850F029E3D
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:35:30 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDdTYs030714;
        Wed, 15 Mar 2023 14:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3eu0zFICVookgj1YRxiGpwqJlzDHo02+NaMVsBUQU+k=;
 b=oK9ZTNY5O+Uc38p4JMgI3AUQ9KgIXN+/yx+3clmHH5HG2M/nmj+TOVOJSPng9r6griha
 7JeTiCkzzVND7QpQyowRl8G9TNI4sbB3rZ/f1Smt2K2Nva0iSjUaY6+Y9oQzu4sLE+n7
 hFdsujrMXNGrbRHLRpTTULu2rZbyBeBv3DcfsJq3F4DU1bNeORc606CZekBT3yJoQ9ah
 QsxYfH1aA324XzZklh96gjMWwBroamJOH8hYjeR/jyDIMjiaIQnODWY5KkNsC5FKM+Qz
 OBNVovLhmNBeqLaEuZURn1ObRGl4YBKUCMplVqdGYbwKVs7T+FPqYU/Q9z9NJXKOq58g rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbdb7n34e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:17 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FD0MuW010855;
        Wed, 15 Mar 2023 14:35:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbdb7n33h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FECjlo008595;
        Wed, 15 Mar 2023 14:35:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pb29sgwjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FEZBEI19726904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:35:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B919E2004F;
        Wed, 15 Mar 2023 14:35:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 618FE20040;
        Wed, 15 Mar 2023 14:35:10 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.95.209])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 14:35:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v18 04/17] s390x/sclp: reporting the maximum nested topology entries
Date:   Wed, 15 Mar 2023 15:34:49 +0100
Message-Id: <20230315143502.135750-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230315143502.135750-1-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ngFSFiUZJZtn0GNivnQ1B3My8DuWY3hH
X-Proofpoint-ORIG-GUID: 17CwBHxaF0-rO3Gp-6Mf6oqdcnwDT48p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_07,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150118
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

