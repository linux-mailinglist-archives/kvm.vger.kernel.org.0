Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB0269F669
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjBVOVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 09:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjBVOVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 09:21:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA85437B7C
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:21:31 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MCohCn004731;
        Wed, 22 Feb 2023 14:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SF4wXDH39e1b1X0SzrV24sr3gFqsjjXbrAaSgSvkBQQ=;
 b=jagIr+OviPv6YqKeCMfrsISNaQIILRG878q6FuoQRhlS9p+HWyJvpDqtMrvXtxPrCR++
 MupYE/qtVc4VLcP3sc7daoyLCbxebnPpDLl7ytKUlEG3rdT9xBkELrDsVAa6Xrq+OXht
 Bmh4PYirq/88+hIKTz2P9/AguX/DTvPRcHP1ycl/wLiJ0zNWBqjlVypKHlzJ71GKHFX2
 4fT5NvgqFMPa1cTWZvlISpdX6XHbndGJbTqIa0adaaijO6V9PSE/u5TfepxFi8sJc/z9
 lo4HUvfKWf4n0fjIVwzpvry8gecCTI7CRTeEt6cp8N7UcoQy+H+AxS0FVtQlmPIZ6UTd lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwkdqtawj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:18 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MEL3Pv007694;
        Wed, 22 Feb 2023 14:21:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwkdqtauw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:17 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MAiXpk031150;
        Wed, 22 Feb 2023 14:21:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6c5ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 14:21:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MELBLP30474878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 14:21:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C89520040;
        Wed, 22 Feb 2023 14:21:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D46E20049;
        Wed, 22 Feb 2023 14:21:11 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 14:21:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu topology
Date:   Wed, 22 Feb 2023 15:21:05 +0100
Message-Id: <20230222142105.84700-12-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230222142105.84700-1-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rXL9P-LWKLsdqp6oCPY0y0yheAu5jHth
X-Proofpoint-ORIG-GUID: BaXl2WEyaftg-XX4hwWfwpJART5lIvxb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic examples for the definition of cpu topology
in s390x.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 docs/system/s390x/cpu-topology.rst | 378 +++++++++++++++++++++++++++++
 docs/system/target-s390x.rst       |   1 +
 2 files changed, 379 insertions(+)
 create mode 100644 docs/system/s390x/cpu-topology.rst

diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
new file mode 100644
index 0000000000..d470e28b97
--- /dev/null
+++ b/docs/system/s390x/cpu-topology.rst
@@ -0,0 +1,378 @@
+CPU topology on s390x
+=====================
+
+Since QEMU 8.0, CPU topology on s390x provides up to 3 levels of
+topology containers: drawers, books, sockets, defining a tree shaped
+hierarchy.
+
+The socket container contains one or more CPU entries consisting
+of a bitmap of three dentical CPU attributes:
+
+- CPU type
+- polarization entitlement
+- dedication
+
+Note also that since 7.2 threads are no longer supported in the topology
+and the ``-smp`` command line argument accepts only ``threads=1``.
+
+Prerequisites
+-------------
+
+To use CPU topology a Linux QEMU/KVM machine providing the CPU topology facility
+(STFLE bit 11) is required.
+
+However, since this facility has been enabled by default in an early version
+of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to notify KVM
+that QEMU supports CPU topology.
+
+Enabling CPU topology
+---------------------
+
+Currently, CPU topology is only enabled in the host model by default.
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
+The CPU topology can be specified on the QEMU command line
+with the ``-smp`` or the ``-device`` QEMU command arguments.
+
+If none of the containers attributes (drawers, books, sockets) are
+specified for the ``-smp`` flag, the number of these containers
+is ``1`` .
+
+.. code-block:: bash
+
+    -smp cpus=5,drawer=1,books=1,sockets=8,cores=4,maxcpus=32
+
+or
+
+.. code-block:: bash
+
+    -smp cpus=5,sockets=8,cores=4,maxcpus=32
+
+When a CPU is defined by the ``-smp`` command argument, its position
+inside the topology is calculated by adding the CPUs to the topology
+based on the core-id starting with core-0 at position 0 of socket-0,
+book-0, drawer-0 and filling all CPUs of socket-0 before to fill socket-1
+of book-0 and so on up to the last socket of the last book of the last
+drawer.
+
+When a CPU is defined by the ``-device`` command argument, the
+tree topology attributes must be all defined or all not defined.
+
+.. code-block:: bash
+
+    -device gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
+
+or
+
+.. code-block:: bash
+
+    -device gen16b-s390x-cpu,core-id=1,dedication=true
+
+If none of the tree attributes (drawer, book, sockets), are specified
+for the ``-device`` argument, as for all CPUs defined on the ``-smp``
+command argument the topology tree attributes will be set by simply
+adding the CPUs to the topology based on the core-id starting with
+core-0 at position 0 of socket-0, book-0, drawer-0.
+
+QEMU will not try to solve collisions and will report an error if the
+CPU topology, explicitely or implicitely defined on a ``-device``
+argument collides with the definition of a CPU implicitely defined
+on the ``-smp`` argument.
+
+When the topology modifier attributes are not defined for the
+``-device`` command argument they takes following default values:
+
+- dedication: ``false``
+- entitlement: ``medium``
+
+
+Hot plug
+++++++++
+
+New CPUs can be plugged using the device_add hmp command as in:
+
+.. code-block:: bash
+
+  (qemu) device_add gen16b-s390x-cpu,core-id=9
+
+The same placement of the CPU is derived from the core-id as described above.
+
+The topology can of course be fully defined:
+
+.. code-block:: bash
+
+    (qemu) device_add gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
+
+
+Examples
+++++++++
+
+In the following machine we define 8 sockets with 4 cores each.
+
+.. code-block:: bash
+
+  $ qemu-system-s390x -m 2G \
+    -cpu gen16b,ctop=on \
+    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
+    -device host-s390x-cpu,core-id=14 \
+
+A new CPUs can be plugged using the device_add hmp command as before:
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
+
+Polarization, entitlement and dedication
+----------------------------------------
+
+Polarization
+++++++++++++
+
+The polarization is an indication given by the ``guest`` to the host
+that it is able to make use of CPU provisioning information.
+The guest indicates the polarization by using the PTF instruction.
+
+Polarization is define two models of CPU provisioning: horizontal
+and vertical.
+
+The horizontal polarization is the default model on boot and after
+subsystem reset in which the guest considers all vCPUs being having
+an equal provisioning of CPUs by the host.
+
+In the vertical polarization model the guest can make use of the
+vCPU entitlement information provided by the host to optimize
+kernel thread scheduling.
+
+A subsystem reset puts all vCPU of the configuration into the
+horizontal polarization.
+
+Entitlement
++++++++++++
+
+The vertical polarization specifies that guest's vCPU can get
+different real CPU provisions:
+
+- a vCPU with vertical high entitlement specifies that this
+  vCPU gets 100% of the real CPU provisioning.
+
+- a vCPU with vertical medium entitlement specifies that this
+  vCPU shares the real CPU with other vCPUs.
+
+- a vCPU with vertical low entitlement specifies that this
+  vCPU only gets real CPU provisioning when no other vCPUs needs it.
+
+In the case a vCPU with vertical high entitlement does not use
+the real CPU, the unused "slack" can be dispatched to other vCPU
+with medium or low entitlement.
+
+The admin specifies a vCPU as ``dedicated`` when the vCPU is fully dedicated
+to a single real CPU.
+
+The dedicated bit is an indication of affinity of a vCPU for a real CPU
+while the entitlement indicates the sharing or exclusivity of use.
+
+Defining the topology on command line
+-------------------------------------
+
+The topology can entirely be defined using -device cpu statements,
+with the exception of CPU 0 which must be defined with the -smp
+argument.
+
+For example, here we set the position of the cores 1,2,3 to
+drawer 1, book 1, socket 2 and cores 0,9 and 14 to drawer 0,
+book 0, socket 0 with all horizontal polarization and not dedicated.
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
+    -device gen16b-s390x-cpu,core-id=4,dedicated=on,polarization=3 \
+
+QAPI interface for topology
+---------------------------
+
+Let's start QEMU with the following command:
+
+.. code-block:: bash
+
+ qemu-system-s390x \
+    -enable-kvm \
+    -cpu z14,ctop=on \
+    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
+    \
+    -device z14-s390x-cpu,core-id=19,polarization=3 \
+    -device z14-s390x-cpu,core-id=11,polarization=1 \
+    -device z14-s390x-cpu,core-id=112,polarization=3 \
+   ...
+
+and see the result when using the QAPI interface.
+
+addons to query-cpus-fast
++++++++++++++++++++++++++
+
+The command query-cpus-fast allows the admin to query the topology
+tree and modifiers for all configured vCPUs.
+
+.. code-block:: QMP
+
+ { "execute": "query-cpus-fast" }
+ {
+  "return": [
+    {
+      "dedicated": false,
+      "thread-id": 536993,
+      "props": {
+        "core-id": 0,
+        "socket-id": 0,
+        "drawer-id": 0,
+        "book-id": 0
+      },
+      "cpu-state": "operating",
+      "entitlement": "medium",
+      "qom-path": "/machine/unattached/device[0]",
+      "cpu-index": 0,
+      "target": "s390x"
+    },
+    {
+      "dedicated": false,
+      "thread-id": 537003,
+      "props": {
+        "core-id": 19,
+        "socket-id": 1,
+        "drawer-id": 0,
+        "book-id": 2
+      },
+      "cpu-state": "operating",
+      "entitlement": "high",
+      "qom-path": "/machine/peripheral-anon/device[0]",
+      "cpu-index": 19,
+      "target": "s390x"
+    },
+    {
+      "dedicated": false,
+      "thread-id": 537004,
+      "props": {
+        "core-id": 11,
+        "socket-id": 1,
+        "drawer-id": 0,
+        "book-id": 1
+      },
+      "cpu-state": "operating",
+      "entitlement": "low",
+      "qom-path": "/machine/peripheral-anon/device[1]",
+      "cpu-index": 11,
+      "target": "s390x"
+    },
+    {
+      "dedicated": true,
+      "thread-id": 537005,
+      "props": {
+        "core-id": 112,
+        "socket-id": 0,
+        "drawer-id": 3,
+        "book-id": 2
+      },
+      "cpu-state": "operating",
+      "entitlement": "high",
+      "qom-path": "/machine/peripheral-anon/device[2]",
+      "cpu-index": 112,
+      "target": "s390x"
+    }
+  ]
+ }
+
+
+set-cpu-topology
+++++++++++++++++
+
+The command set-cpu-topology allows the admin to modify the topology
+tree or the topology modifiers of a vCPU in the configuration.
+
+.. code-block:: QMP
+
+ -> { "execute": "set-cpu-topology",
+      "arguments": {
+         "core-id": 11,
+         "socket-id": 0,
+         "book-id": 0,
+         "drawer-id": 0,
+         "entitlement": low,
+         "dedicated": false
+      }
+    }
+ <- {"return": {}}
+
+The core-id parameter is the only non optional parameter and every
+unspecified parameter keeps its previous value.
+
+event CPU_POLARIZATION_CHANGE
++++++++++++++++++++++++++++++
+
+When a guest is requests a modification of the polarization,
+QEMU sends a CPU_POLARIZATION_CHANGE event.
+
+When requesting the change, the guest only specifies horizontal or
+vertical polarization.
+It is the job of the admin to set the dedication and fine grained vertical entitlement
+in response to this event.
+
+Note that a vertical polarized dedicated vCPU can only have a high
+entitlement, this gives 6 possibilities for vCPU polarization:
+
+- Horizontal
+- Horizontal dedicated
+- Vertical low
+- Vertical medium
+- Vertical high
+- Vertical high dedicated
+
+Example of the event received when the guest issues the CPU instruction
+Perform Topology Function PTF(0) to request an horizontal polarization:
+
+.. code-block:: QMP
+
+ <- { "event": "CPU_POLARIZATION_CHANGE",
+      "data": { "polarization": 0 },
+      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
diff --git a/docs/system/target-s390x.rst b/docs/system/target-s390x.rst
index f6f11433c7..94c981e732 100644
--- a/docs/system/target-s390x.rst
+++ b/docs/system/target-s390x.rst
@@ -34,3 +34,4 @@ Architectural features
 .. toctree::
    s390x/bootdevices
    s390x/protvirt
+   s390x/cpu-topology
-- 
2.31.1

