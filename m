Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DAF63C691
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbiK2Rmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiK2Rmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:42:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FFF2BF4
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:42:35 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATGx8xL013084;
        Tue, 29 Nov 2022 17:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zRgxJwhdvMuf0/S6nTCkxTz5a4usYMPGRTMHVCwL9So=;
 b=E6NOUSkEUs5yk1iBQGPREyXt31R5fGWZ4g8RZQQ+OfyQLr5zqdfvGkWwEIv1axczNwQE
 F1TUfNSiCOfe/V14kNiOaGw7igClWraMTQ/vkRHwb3TNGye2oRvq3K5dmP1WOlnOJWvt
 KJdxX+hs8LGOFkUQMRRyHRvjafbqsdbLd0IcOdk4HlWopig0QL6efN4kdB5+PfMKvswk
 lsExxsoPqyurkFNpyz2dykVRGiDqA6OjQUaRcECIWGR2t2B1KG81h19zlUvALIknAoYU
 VVsy54jdluVyt1Q3w+L2Ah81z4ocnVLULrbFc/+lDQPFBNHkhUoZfhbhLhGnI4C7ngWC YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5kmv6nu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:22 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATGx7XZ013054;
        Tue, 29 Nov 2022 17:42:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5kmv6ntc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATHZN73019130;
        Tue, 29 Nov 2022 17:42:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9cfey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATHgxj464422286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 17:42:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F4BEA404D;
        Tue, 29 Nov 2022 17:42:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F0F1A4040;
        Tue, 29 Nov 2022 17:42:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.89.107])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 17:42:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v12 7/7] docs/s390x: document s390x cpu topology
Date:   Tue, 29 Nov 2022 18:42:06 +0100
Message-Id: <20221129174206.84882-8-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221129174206.84882-1-pmorel@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XsptuCgLKPfvCqgGefrwAoIZ-KrupQhD
X-Proofpoint-ORIG-GUID: wVBJDpKjGPNYHQvzk1e33pRkioveiNM7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_11,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic examples for the definition of cpu topology
in s390x.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 docs/system/s390x/cpu-topology.rst | 80 ++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 docs/system/s390x/cpu-topology.rst

diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
new file mode 100644
index 0000000000..2fad28453c
--- /dev/null
+++ b/docs/system/s390x/cpu-topology.rst
@@ -0,0 +1,80 @@
+CPU Topology on s390x
+=====================
+
+CPU Topology on S390x provides up to 5 levels of topology containers:
+nodes, drawers, books, sockets and CPUs.
+While the higher level containers, Containers Topology List Entries,
+(Containers TLE) define a tree hierarchy, the lowest level of topology
+definition, the CPU Topology List Entry (CPU TLE), provides the placement
+of the CPUs inside the parent container.
+
+Currently QEMU CPU topology uses a single level of container: the sockets.
+
+For backward compatibility, threads can be declared on the ``-smp`` command
+line. They will be seen as CPUs by the guest as long as multithreading
+is not really supported by QEMU for S390.
+
+Prerequisites
+-------------
+
+To use CPU Topology a Linux QEMU/KVM machine providing the CPU Topology facility
+(STFLE bit 11) is required.
+
+However, since this facility has been enabled by default in an early version
+of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to notify KVM
+QEMU use of the CPU Topology.
+
+Indicating the CPU topology to the Virtual Machine
+--------------------------------------------------
+
+The CPU Topology, can be specified on the QEMU command line
+with the ``-smp`` or the ``-device`` QEMU command arguments.
+
+Like in :
+
+.. code-block:: sh
+    -smp cpus=5,sockets=8,cores=2,threads=2,maxcpus=32
+    -device host-s390x-cpu,core-id=14
+
+New CPUs can be plugged using the device_add hmp command like in:
+
+.. code-block:: sh
+   (qemu) device_add host-s390x-cpu,core-id=9
+
+The core-id defines the placement of the core in the topology by
+starting with core 0 in socket 0 up to maxcpus.
+
+In the example above:
+
+* There are 5 CPUs provided to the guest with the ``-smp`` command line
+  They will take the core-ids 0,1,2,3,4
+  As we have 2 threads in 2 cores in a socket, we have 4 CPUs provided
+  to the guest in socket 0, with core-ids 0,1,2,3.
+  The last cpu, with core-id 4, will be on socket 1.
+
+* the core with ID 14 provided by the ``-device`` command line will
+  be placed in socket 3, with core-id 14
+
+* the core with ID 9 provided by the ``device_add`` qmp command will
+  be placed in socket 2, with core-id 9
+
+Note that the core ID is machine wide and the CPU TLE masks provided
+by the STSI instruction will be:
+
+* in socket 0: 0xf0000000 (core id 0,1,2,3)
+* in socket 1: 0x00400000 (core id 9)
+* in socket 1: 0x00020000 (core id 14)
+
+Enabling CPU topology
+---------------------
+
+Currently, CPU topology is disabled by default.
+
+Enabling CPU topology can be done by setting the feature flag
+``disable-topology`` to ``off`` like in:
+
+.. code-block:: sh
+   -cpu gen16b,disable-topology=off
+
+Having the topology disabled by default allows migration between
+old and new QEMU without adding new flags.
-- 
2.31.1

