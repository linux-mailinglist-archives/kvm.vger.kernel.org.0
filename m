Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882FD65EF65
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbjAEOyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbjAEOxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:53:40 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA41104
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:53:39 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Eknkl030038;
        Thu, 5 Jan 2023 14:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3JHlvSVoOoD113y+YLcDLmKD3ivZV4W6BebEz367UL8=;
 b=kJm9KeV5pFVVDkJzurUFw7awn3zbtqOOx9fwMeq6CYtWwcZzlriTWXofxOqDx0oX4aYe
 s2qfldJhRaicLhQ77Dab6XnVlry4lbINbcfchH2FVpVIcAZ8rmuITPvLl3RKwclb8bR4
 UWZijM8GJNdc4wrB+8exEZhCkL6i1wOHyrodlXS/zXlx/gP39pds+yoPTbd9O95K7aku
 jEV0NqYvBuRsPVULN9g9Kj9nYnmXWXXhgamUquRhig49eUnbdjWKQcZvuAQJ5cqVLDpf
 nX1iWkUKq/DI3C2K091WC5iqonxqBl5xvHlCPB44+2ezHQJCrdAKvcvNon2pm+2Y3qK/ kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0m203n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:33 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305EougW015329;
        Thu, 5 Jan 2023 14:53:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0m203mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3054fPjU001024;
        Thu, 5 Jan 2023 14:53:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mtcbfewh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErRsU42664314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CDC320040;
        Thu,  5 Jan 2023 14:53:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39A9420043;
        Thu,  5 Jan 2023 14:53:26 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 11/11] docs/s390x/cpu topology: document s390x cpu topology
Date:   Thu,  5 Jan 2023 15:53:13 +0100
Message-Id: <20230105145313.168489-12-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 19vAfV-2JQ_c3lBA8hN6fOba60K3eEm9
X-Proofpoint-ORIG-GUID: tdgqR736KXCs19IBdNBvXKmEd1uZnnTP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050114
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
 docs/system/s390x/cpu-topology.rst | 292 +++++++++++++++++++++++++++++
 docs/system/target-s390x.rst       |   1 +
 2 files changed, 293 insertions(+)
 create mode 100644 docs/system/s390x/cpu-topology.rst

diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
new file mode 100644
index 0000000000..0020b70b50
--- /dev/null
+++ b/docs/system/s390x/cpu-topology.rst
@@ -0,0 +1,292 @@
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
+Beside the topological tree, S390x provides 3 CPU attributes:
+- CPU type
+- polarity entitlement
+- dedication
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
+Enabling CPU topology
+---------------------
+
+Currently, CPU topology is only enabled in the host model.
+
+Enabling CPU topology in a CPU model is done by setting the CPU flag
+``ctop`` to ``on`` like in:
+
+.. code-block:: bash
+
+   -cpu gen16b,ctop=on
+
+Having the topology disabled by default allows migration between
+old and new QEMU without adding new flags.
+
+Default topology usage
+----------------------
+
+The CPU Topology, can be specified on the QEMU command line
+with the ``-smp`` or the ``-device`` QEMU command arguments
+without using any new attributes.
+In this case, the topology will be calculated by simply adding
+to the topology the cores based on the core-id starting with
+core-0 at position 0 of socket-0, book-0, drawer-0 with default
+modifier attributes: horizontal polarity and no dedication.
+
+In the following machine we define 8 sockets with 4 cores each.
+Note that S390 QEMU machines do not implement multithreading.
+
+.. code-block:: bash
+
+  $ qemu-system-s390x -m 2G \
+    -cpu gen16b,ctop=on \
+    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
+    -device host-s390x-cpu,core-id=14 \
+
+New CPUs can be plugged using the device_add hmp command like in:
+
+.. code-block:: bash
+
+  (qemu) device_add gen16b-s390x-cpu,core-id=9
+
+The core-id defines the placement of the core in the topology by
+starting with core 0 in socket 0 up to maxcpus.
+
+In the example above:
+
+* There are 5 CPUs provided to the guest with the ``-smp`` command line
+  They will take the core-ids 0,1,2,3,4
+  As we have 4 cores in a socket, we have 4 CPUs provided
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
+by the STSI instruction will be written in a big endian mask:
+
+* in socket 0: 0xf000000000000000 (core id 0,1,2,3)
+* in socket 1: 0x0800000000000000 (core id 4)
+* in socket 2: 0x0040000000000000 (core id 9)
+* in socket 3: 0x0002000000000000 (core id 14)
+
+Defining the topology on command line
+-------------------------------------
+
+The topology can be defined entirely during the CPU definition,
+with the exception of CPU 0 which must be defined with the -smp
+argument.
+
+For example, here we set the position of the cores 1,2,3 on
+drawer 1, book 1, socket 2 and cores 0,9 and 14 on drawer 0,
+book 0, socket 0 with all horizontal polarity and not dedicated.
+The core 4, will be set on its default position on socket 1
+(since we have 4 core per socket) and we define it with dedication and
+vertical high entitlement.
+
+.. code-block:: bash
+
+  $ qemu-system-s390x -m 2G \
+    -cpu gen16b,ctop=on \
+    -smp cpus=1,sockets=8,cores=4,maxcpus=32 \
+    \
+    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1 \
+    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=2 \
+    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=3 \
+    \
+    -device gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=9 \
+    -device gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=14 \
+    \
+    -device gen16b-s390x-cpu,core-id=4,dedicated=on,polarity=3 \
+
+Polarity and dedication
+-----------------------
+
+Polarity can be of two types: horizontal or vertical.
+
+The horizontal polarization specifies that all guest's vCPUs get
+almost the same amount of provisioning of real CPU by the host.
+
+The vertical polarization specifies that guest's vCPU can get
+different  real CPU provisions:
+
+- a vCPU with Vertical high entitlement specifies that this
+  vCPU gets 100% of the real CPU provisioning.
+
+- a vCPU with Vertical medium entitlement specifies that this
+  vCPU shares the real CPU with other vCPU.
+
+- a vCPU with Vertical low entitlement specifies that this
+  vCPU only get real CPU provisioning when no other vCPU need it.
+
+In the case a vCPU with vertical high entitlement does not use
+the real CPU, the unused "slack" can be dispatched to other vCPU
+with medium or low entitlement.
+
+The host indicates to the guest how the real CPU resources are
+provided to the vCPUs through the SYSIB with two polarity bits
+inside the CPU TLE.
+
+Bits d - Polarization
+0 0      Horizontal
+0 1      Vertical low entitlement
+1 0      Vertical medium entitlement
+1 1      Vertical high entitlement
+
+A subsystem reset puts all vCPU of the configuration into the
+horizontal polarization.
+
+The admin specifies the dedicated bit when the vCPU is dedicated
+to a single real CPU.
+
+As for the Linux admin, the dedicated bit is an indication on the
+affinity of a vCPU for a real CPU while the entitlement indicates the
+sharing or exclusivity of use.
+
+QAPI interface for topology
+---------------------------
+
+Let's start QEMU with the following command:
+
+.. code-block:: bash
+
+ sudo /usr/local/bin/qemu-system-s390x \
+    -enable-kvm \
+    -cpu z14,ctop=on \
+    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
+    \
+    -device z14-s390x-cpu,core-id=19,polarity=3 \
+    -device z14-s390x-cpu,core-id=11,polarity=1 \
+    -device z14-s390x-cpu,core-id=12,polarity=3 \
+   ...
+
+and see the result when using of the QAPI interface.
+
+query-topology
++++++++++++++++
+
+The command cpu-topology allows the admin to query the topology
+tree and modifier for all configured vCPU.
+
+.. code-block:: QMP
+
+ -> { "execute": "query-topology" }
+    {"return":
+        [
+            {
+            "origin": 0,
+            "dedicated": false,
+            "book": 0,
+            "socket": 0,
+            "drawer": 0,
+            "polarity": 0,
+            "mask": "0x8000000000000000"
+            },
+            {
+                "origin": 0,
+                "dedicated": false,
+                "book": 2,
+                "socket": 1,
+                "drawer": 0,
+                "polarity": 1,
+                "mask": "0x0010000000000000"
+            },
+            {
+                "origin": 0,
+                "dedicated": false,
+                "book": 0,
+                "socket": 0,
+                "drawer": 1,
+                "polarity": 3,
+                "mask": "0x0008000000000000"
+            },
+            {
+                "origin": 0,
+                "dedicated": false,
+                "book": 1,
+                "socket": 1,
+                "drawer": 1,
+                "polarity": 3,
+                "mask": "0x0000100000000000"
+            }
+        ]
+    }
+
+change-topology
++++++++++++++++
+
+The command change-topology allows the admin to modify the topology
+tree or the topology modifiers of a vCPU in the configuration.
+
+.. code-block:: QMP
+
+ -> { "execute": "change-topology",
+      "arguments": {
+         "core": 11,
+         "socket": 0,
+         "book": 0,
+         "drawer": 0,
+         "polarity": 0,
+         "dedicated": false
+      }
+    }
+ <- {"return": {}}
+
+
+event POLARITY_CHANGE
++++++++++++++++++++++
+
+When a guest is requesting a modification of the polarity,
+QEMU sends a POLARITY_CHANGE event.
+
+When requesting the change, the guest only specifies horizontal or
+vertical polarity.
+The dedication and fine grain vertical entitlement depends on admin
+to set according to its response to this event.
+
+Note that a vertical polarized dedicated vCPU can only have a high
+entitlement, this gives 6 possibilities for a vCPU polarity:
+
+- Horizontal
+- Horizontal dedicated
+- Vertical low
+- Vertical medium
+- Vertical high
+- Vertical high dedicated
+
+Example of the event received when the guest issues PTF(0) to request
+an horizontal polarity:
+
+.. code-block:: QMP
+
+ <- { "event": "POLARITY_CHANGE",
+      "data": { "polarity": 0 },
+      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
+
+
diff --git a/docs/system/target-s390x.rst b/docs/system/target-s390x.rst
index c636f64113..ff0ffe04f3 100644
--- a/docs/system/target-s390x.rst
+++ b/docs/system/target-s390x.rst
@@ -33,3 +33,4 @@ Architectural features
 .. toctree::
    s390x/bootdevices
    s390x/protvirt
+   s390x/cpu-topology
-- 
2.31.1

