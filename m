Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235406EE565
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbjDYQPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjDYQPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:15:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304B7161B1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:15:35 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PGEFqR007449;
        Tue, 25 Apr 2023 16:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pqh5OBPcMwvmkNu0dW2pzyb13sEEfE/zW+gthcivmKk=;
 b=IQKFnSodR+2XFlkzGbDPChR+koZosovWEld2BrBHtstyVpNsbxteMBi4RxleQkIrgYe6
 DYYYNwApadr1W4FIyYT24hSyLr3O42jFlqRpuQn4XbF0NnFGKDlmwGZ1ilOZzYFzZIiY
 lY5+Z6A1ANhRhGQNSmFDdxl1BYVfwVNnl1IJYNAFgw+q2Pa1PQX1Mi/i8GPgW26lGMab
 ly9Z1CMTLGlWR45+r7IKJzfVjmonhMvlKaVgGrxcMRKs6cLmC09z+ffs71caEIVjgsnP
 bELM2VRtDaCmvrDeKvTXAX6c+C8h4e7FNcDT+P2ZkpHtwlBhlfV29krnT+F8e6r/oblJ jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6hng1rb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:16 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PG4OMx004815;
        Tue, 25 Apr 2023 16:15:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6hng1r8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33ONbbuO026564;
        Tue, 25 Apr 2023 16:15:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47771v72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 16:15:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PGF6GT38339324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 16:15:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BCE22007C;
        Tue, 25 Apr 2023 16:15:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A74C520079;
        Tue, 25 Apr 2023 16:15:05 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 16:15:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v20 12/21] qapi/s390x/cpu topology: query-cpu-polarization qmp command
Date:   Tue, 25 Apr 2023 18:14:47 +0200
Message-Id: <20230425161456.21031-13-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230425161456.21031-1-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a_N8lvOv22nK1gl02sh6Ctyd7mD2sMoH
X-Proofpoint-ORIG-GUID: U6EBXajmetAyFDwXd-DaxUeNwVNj1zOI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_07,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The query-cpu-polarization qmp command returns the current
CPU polarization of the machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
 hw/s390x/cpu-topology.c  | 14 ++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index ffde2e9cbd..8eb05755cd 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -4,6 +4,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or later.
 # See the COPYING file in the top-level directory.
 
+{ 'include': 'common.json' }
 { 'include': 'machine-common.json' }
 
 ##
@@ -424,3 +425,32 @@
   'features': [ 'unstable' ],
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
+
+##
+# @CpuPolarizationInfo:
+#
+# The result of a cpu polarization
+#
+# @polarization: the CPU polarization
+#
+# Since: 2.8
+##
+{ 'struct': 'CpuPolarizationInfo',
+  'data': { 'polarization': 'CpuS390Polarization' },
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
+
+##
+# @query-cpu-polarization:
+#
+# Features:
+# @unstable: This command may still be modified.
+#
+# Returns: the machine polarization
+#
+# Since: 8.1
+##
+{ 'command': 'query-cpu-polarization', 'returns': 'CpuPolarizationInfo',
+  'features': [ 'unstable' ],
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index e8b140d623..d440e8a3c6 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -18,6 +18,7 @@
 #include "hw/s390x/cpu-topology.h"
 #include "qapi/qapi-commands-machine-target.h"
 #include "qapi/qapi-events-machine-target.h"
+#include "qapi/type-helpers.h"
 
 /*
  * s390_topology is used to keep the topology information.
@@ -468,3 +469,16 @@ void qmp_set_cpu_topology(uint16_t core,
                          has_drawer, drawer, has_entitlement, entitlement,
                          has_dedicated, dedicated, errp);
 }
+
+CpuPolarizationInfo *qmp_query_cpu_polarization(Error **errp)
+{
+    CpuPolarizationInfo *info = g_new0(CpuPolarizationInfo, 1);
+
+    if (s390_topology.vertical_polarization) {
+        info->polarization = S390_CPU_POLARIZATION_VERTICAL;
+    } else {
+        info->polarization = S390_CPU_POLARIZATION_HORIZONTAL;
+    }
+
+    return info;
+}
-- 
2.31.1

