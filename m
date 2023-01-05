Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CA265EF6C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbjAEOym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbjAEOyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F3A5B176
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:04 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305EokUr021279;
        Thu, 5 Jan 2023 14:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tJNKQ6XLjc0XBA0Vpw8/hB1o+7HqorlTgkt4Qg6FCGk=;
 b=UkixJwpxsLWgXQXiBSFp9O1F4BU6W6QUP4bMBh1QsE444Pjl2BY7M31SBTiO466VyW0N
 EBNT7dFMz0hqiLHgwECykcbav6w6id9Ln4Z+Cv5OgX7exY8QTGZzIBDMExhh3qnuboqX
 V9jUkxrIEI0/ppGtQasb99+cX4vstl73yOnZ1e4SJRlizhKMjoYRplJ8bwtSnGOLWqbs
 q2ICFhYm+RfCVwWiZJzdhP+0dlWkh9u02vQw7pk+OqDlrH/TYtUTJnAodycgtOQfKc+z
 GcqT77hqFbCZFERFrSnpMnFDm0ExNziXFfMPnhAo1CDdkaibxbqcDqI6/E+LRWrrCDUA /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0p101v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:33 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305ErW25032765;
        Thu, 5 Jan 2023 14:53:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0p101uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3050abd3018137;
        Thu, 5 Jan 2023 14:53:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6w1xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErQD942992086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:26 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26C9A20040;
        Thu,  5 Jan 2023 14:53:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C91720049;
        Thu,  5 Jan 2023 14:53:25 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 10/11] qapi/s390/cpu topology: POLARITY_CHANGE qapi event
Date:   Thu,  5 Jan 2023 15:53:12 +0100
Message-Id: <20230105145313.168489-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bvS4Hef6DIb0ypJN4eff5Kb9XX84u_5M
X-Proofpoint-ORIG-GUID: YSD0-adTzK4EwNlM93Xbdko_jbUkEv84
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
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

When the guest asks to change the polarity this change
is forwarded to the admin using QAPI.
The admin is supposed to take according decisions concerning
CPU provisioning.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 21 +++++++++++++++++++++
 hw/s390x/cpu-topology.c  |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 927618a78f..10235cfb45 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -437,3 +437,24 @@
   'returns': ['S390CpuTopology'],
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
+
+##
+# @POLARITY_CHANGE:
+#
+# Emitted when the guest asks to change the polarity.
+#
+# @polarity: polarity specified by the guest
+#
+# Since: 8.0
+#
+# Example:
+#
+# <- { "event": "POLARITY_CHANGE",
+#      "data": { "polarity": 0 },
+#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
+#
+##
+{ 'event': 'POLARITY_CHANGE',
+  'data': { 'polarity': 'int' },
+   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
+}
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index c3748654ff..45621387d5 100644
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
@@ -128,6 +129,7 @@ void s390_topology_set_polarity(int polarity)
         }
     }
     s390_cpu_topology_set();
+    qapi_event_send_polarity_change(polarity);
 }
 
 /*
-- 
2.31.1

