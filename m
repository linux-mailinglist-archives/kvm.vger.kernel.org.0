Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DD74380B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjF3JS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjF3JS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:18:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BAF2680
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 02:18:28 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35U9C0cx027068;
        Fri, 30 Jun 2023 09:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eaqBbYc9OuxUEUgL1yFTHAtAOUTitq+XgR0fDgvmGBo=;
 b=oUrhQq66k0RkfYbBGAZxA/8NeOijLVt7aZ2BJy+DgxyUqNhoCfHzKEMbEO/Tmh89YczS
 8bku9X1TR6NIy7+cEcFa5AvHkQWGQxeRreK1AaNt4Twg9BTEdxpf4IFXHaGEeohYRcEC
 CdEm+B7a4WAC6rsuDfcZUokTbhgfaZzegrmMyhcKWfRC/Bn1GT/R/nz80p9hcXpgr5X3
 9RyBxDrLVxT7+is837Exj981g1wHDuzyRFOCKS+RDbLmAVNwGw5YlLbLbefjbgbEdKxx
 nLssWiaLo6PSjHX1iEUibJ21pEF+mxeUsJSQr9P48Ricz3j7pRgRQGW+U8ZJYv0N+5pS 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g8cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:21 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35U9FQV4011530;
        Fri, 30 Jun 2023 09:18:20 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g8b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U98sEu002456;
        Fri, 30 Jun 2023 09:18:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rdr452yf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:17 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35U9IBK261538606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 09:18:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAF4B20043;
        Fri, 30 Jun 2023 09:18:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 843F320040;
        Fri, 30 Jun 2023 09:18:10 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.38.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 09:18:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v21 12/20] qapi/s390x/cpu topology: query-cpu-polarization qmp command
Date:   Fri, 30 Jun 2023 11:17:44 +0200
Message-Id: <20230630091752.67190-13-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KgRQeVnA9l0rLF8osDJpFF4076jBtQ6u
X-Proofpoint-GUID: o5bV3w8MaEZxXz2XcF7GKT2nm-zedxPN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The query-cpu-polarization qmp command returns the current
CPU polarization of the machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 29 +++++++++++++++++++++++++++++
 hw/s390x/cpu-topology.c  |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 1362e43983..1e4b8976aa 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -445,3 +445,32 @@
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
+# Since: 8.1
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
index 69f31db4af..4f08bdeb2f 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -465,3 +465,11 @@ void qmp_set_cpu_topology(uint16_t core,
                          has_drawer, drawer, has_entitlement, entitlement,
                          has_dedicated, dedicated, errp);
 }
+
+CpuPolarizationInfo *qmp_query_cpu_polarization(Error **errp)
+{
+    CpuPolarizationInfo *info = g_new0(CpuPolarizationInfo, 1);
+
+    info->polarization = s390_topology.polarization;
+    return info;
+}
-- 
2.31.1

