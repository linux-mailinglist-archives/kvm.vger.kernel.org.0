Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560E26866B2
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjBANVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjBANVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:21:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAB53D0BD
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:21:29 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311Cvn54002633;
        Wed, 1 Feb 2023 13:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eZhbegBou4I7xPYYPIaB/7qY1+19K7m+dR0rwf7gbu8=;
 b=F4u5rYzWW6SQXL71KmxbkJSl59WkZB6QxYbkVrwZ8J7ofx1NRmQAJjeWMsNv9+Z8afw/
 SvXVbxSxL0MtO4LNnWKDgGOSpo0CvjiDyfhB6qZZTykUicUKxYKG3IFL+/3+fHN3DO3H
 Y0kmubVk6lC1qb+9IPCliHTSnrOsR1/G2RF5PnQwdqT7AycNtPSJefT8j4+0z+EoDEmB
 Nz2jBYJZzsW8h+RblkJx3s/PooIQyOpONSOAmz0ygbS5BpJcldzdAXtEmEaZMC1tBZIb
 RNe4T+zqegEC9w8KCEV8PWaiWuykAiEkccEKL4QG5lQmKP3E2IMaCfjeLSJJKR1OsWrF 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrj28qdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:17 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311Cxhbx012610;
        Wed, 1 Feb 2023 13:21:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfrj28qct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3116j6oW013346;
        Wed, 1 Feb 2023 13:21:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ncvshbga8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311DLAUm23069036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 13:21:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEF4F2004B;
        Wed,  1 Feb 2023 13:21:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A11920040;
        Wed,  1 Feb 2023 13:21:09 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.4.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 13:21:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE qapi event
Date:   Wed,  1 Feb 2023 14:20:50 +0100
Message-Id: <20230201132051.126868-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jlGWZjg8vhTlHqryaZiFzl0pihTosTEJ
X-Proofpoint-ORIG-GUID: aYSiZbwyy4nhh29NqVHmYL65zi_2Wsfl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest asks to change the polarity this change
is forwarded to the admin using QAPI.
The admin is supposed to take according decisions concerning
CPU provisioning.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
 hw/s390x/cpu-topology.c  |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 58df0f5061..5883c3b020 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -371,3 +371,33 @@
   },
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
+
+##
+# @CPU_POLARITY_CHANGE:
+#
+# Emitted when the guest asks to change the polarity.
+#
+# @polarity: polarity specified by the guest
+#
+# The guest can tell the host (via the PTF instruction) whether the
+# CPUs should be provisioned using horizontal or vertical polarity.
+#
+# On horizontal polarity the host is expected to provision all vCPUs
+# equally.
+# On vertical polarity the host can provision each vCPU differently.
+# The guest will get information on the details of the provisioning
+# the next time it uses the STSI(15) instruction.
+#
+# Since: 8.0
+#
+# Example:
+#
+# <- { "event": "CPU_POLARITY_CHANGE",
+#      "data": { "polarity": 0 },
+#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
+#
+##
+{ 'event': 'CPU_POLARITY_CHANGE',
+  'data': { 'polarity': 'int' },
+   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
+}
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 6c50050991..2f8e1b60cf 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,7 @@
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
 #include "qapi/qapi-commands-machine-target.h"
+#include "qapi/qapi-events-machine-target.h"
 #include "qapi/qmp/qdict.h"
 #include "monitor/hmp.h"
 #include "monitor/monitor.h"
@@ -163,6 +164,7 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
             s390_topology.polarity = fc;
             s390_cpu_topology_set_modified();
             s390_topology_set_cpus_polarity(fc);
+            qapi_event_send_cpu_polarity_change(fc);
             setcc(cpu, 0);
         }
         break;
-- 
2.31.1

