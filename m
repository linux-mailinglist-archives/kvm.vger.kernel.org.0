Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D2C69F665
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 15:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjBVOVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 09:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjBVOVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 09:21:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C206C39BA0
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:21:29 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MDo5uj014756;
        Wed, 22 Feb 2023 14:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J5JrMXF/pUdDunkR3HOT5gqAt60V8LAp26JeFI/d5uc=;
 b=s3PdDTJKC5MWhuEEBypL92SEE8DlZIgoB7wfnv/uWLqYk5l83PLi08MWp0dHh+3En+0n
 hHfRoBKGhitkyOq/uYKuiSgUkjy8jLnCTwYM3QDHbYp0Hfa1XAJsCAitM7B6V6dJvCUh
 0ugaL0Ql6sjqUFBmGAnZL/zjOFFPCrpNpncDiaR/muV4VP9JV13X2IqFB1wLSPeTd3qC
 E5O/NCSVXuJQEvp3MOPhOgH4yX5lA/v7AR2znbe3Pm9Q4B3cxwPVzOe+gC6oiPAe1rCP
 bSd5qC21sUeaayxorLuJOv3nvVlhVw9qVLGpj0ahgrbZH93dsyW8hGUnFUnX/VXsBH4E +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm9ggwfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:17 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MEEa9C004100;
        Wed, 22 Feb 2023 14:21:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwm9ggwdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LNucOB019945;
        Wed, 22 Feb 2023 14:21:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ntnxf5fn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MELBnA29098260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 14:21:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F6320040;
        Wed, 22 Feb 2023 14:21:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DF412004D;
        Wed, 22 Feb 2023 14:21:10 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 14:21:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v16 10/11] qapi/s390x/cpu topology: CPU_POLARIZATION_CHANGE qapi event
Date:   Wed, 22 Feb 2023 15:21:04 +0100
Message-Id: <20230222142105.84700-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230222142105.84700-1-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: frPBVbfW3uovQ1PzpsI5WH-9AHCOXeQN
X-Proofpoint-GUID: QaBH8DQmt4dOCJH4tNLzyucvitc47IsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest asks to change the polarization this change
is forwarded to the admin using QAPI.
The admin is supposed to take according decisions concerning
CPU provisioning.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 34 ++++++++++++++++++++++++++++++++++
 hw/s390x/cpu-topology.c  |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index baa9d273cf..e7a9049c1f 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -389,3 +389,37 @@
   'features': [ 'unstable' ],
   'if': { 'all': [ 'TARGET_S390X' ] }
 }
+
+##
+# @CPU_POLARIZATION_CHANGE:
+#
+# Emitted when the guest asks to change the polarization.
+#
+# @polarization: polarization specified by the guest
+#
+# Features:
+# @unstable: This command may still be modified.
+#
+# The guest can tell the host (via the PTF instruction) whether the
+# CPUs should be provisioned using horizontal or vertical polarization.
+#
+# On horizontal polarization the host is expected to provision all vCPUs
+# equally.
+# On vertical polarization the host can provision each vCPU differently.
+# The guest will get information on the details of the provisioning
+# the next time it uses the STSI(15) instruction.
+#
+# Since: 8.0
+#
+# Example:
+#
+# <- { "event": "CPU_POLARIZATION_CHANGE",
+#      "data": { "polarization": 0 },
+#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
+#
+##
+{ 'event': 'CPU_POLARIZATION_CHANGE',
+  'data': { 'polarization': 'CpuS390Polarization' },
+  'features': [ 'unstable' ],
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 3a7eb441a3..d498873c80 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -21,6 +21,7 @@
 #include "qapi/qapi-types-machine-target.h"
 #include "qapi/qapi-types-machine.h"
 #include "qapi/qapi-commands-machine-target.h"
+#include "qapi/qapi-events-machine-target.h"
 #include "qapi/qmp/qdict.h"
 #include "monitor/hmp.h"
 #include "monitor/monitor.h"
@@ -167,6 +168,7 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
             s390_topology.polarization = fc;
             s390_cpu_topology_set_changed(true);
             s390_topology_set_cpus_entitlement(fc);
+            qapi_event_send_cpu_polarization_change(fc);
             setcc(cpu, 0);
         }
         break;
-- 
2.31.1

