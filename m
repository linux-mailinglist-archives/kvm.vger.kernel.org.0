Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8375FC915
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJLQVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiJLQVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:21:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8372CDED21
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:21:41 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CGIY37023356;
        Wed, 12 Oct 2022 16:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GbvH9IfnUHV15Ycx4DN2/N9WZhsIDvK8HLSDy9LB31k=;
 b=KahROpjaH+T/OCrzAj1+BVmddjGU58L7Fo22gSG7iOB3TOHc7q6B6mspuCpEoab+3Y20
 TpVIUCuMmGM9n5rKRW578lNT/rBDKIwxLdVj+phDvmypsVJbPLDU6FHSxXOMmZOdjlcc
 ranyUfnBctn4RWxrS2RLq4uoOxj9AWh+T706WWNyI0VGhoUABgzSCxDx/WgDOaJ+pStV
 mAdHq1W6SEmbJkoVWI0m5hp9qz+/pQCxxzTwWJstr1bVawALtZykOBbVRuMbX5dIEiDt
 eTgAypF/HpWiU5e8hORGaqlGH2+uy2ZE3qljjz9Dg/Q2MzuV4JTyZCr6H2tFWo6fvLBq +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5xfmdwvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:28 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CEUNmk029383;
        Wed, 12 Oct 2022 16:21:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5xfmdwtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CGLKlg021778;
        Wed, 12 Oct 2022 16:21:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9e9y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CGLr8i51380688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 16:21:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE2D2A405B;
        Wed, 12 Oct 2022 16:21:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E29BFA4054;
        Wed, 12 Oct 2022 16:21:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.34.168])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 16:21:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: [PATCH v10 9/9] docs/s390x: document s390x cpu topology
Date:   Wed, 12 Oct 2022 18:21:07 +0200
Message-Id: <20221012162107.91734-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221012162107.91734-1-pmorel@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e_WqOzVVVFhmksv5dRLxIRlOz-saHstW
X-Proofpoint-ORIG-GUID: ev99_bxm0-JyLL96BLsIh9FH1T0-NDzQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120106
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
 docs/system/s390x/cpu_topology.rst | 80 ++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 docs/system/s390x/cpu_topology.rst

diff --git a/docs/system/s390x/cpu_topology.rst b/docs/system/s390x/cpu_topology.rst
new file mode 100644
index 0000000000..1dcd24cbbc
--- /dev/null
+++ b/docs/system/s390x/cpu_topology.rst
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
+with the ``-smp`` or the ``-device`` qemu command arguments.
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
+* There are 5 cpus provided to the guest with the ``-smp`` command line
+  They will take the core-ids 0,1,2,3,4
+  As we have 2 threads in 2 cores in a socket, we have 4 cpus provided
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
+Migration
+---------
+
+For virtio-ccw machines older than s390-virtio-ccw-7.3, CPU Topoogy is
+unavailable.
+
+CPU Topoogy is by default enabled for s390-virtio-ccw-7.3 and newer machines.
+
+Disabling CPU topology can be done by setting the global option
+``topology-disable`` to ``on`` like in:
+
+.. code-block:: sh
+   -machine s390-ccw-virtio-7.3,accel=kvm,topology-disable=on
-- 
2.31.1

