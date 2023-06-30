Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D2B74381B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjF3JTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjF3JTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:19:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5784207
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 02:18:53 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35U9BuMZ026927;
        Fri, 30 Jun 2023 09:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8ynEoLKmcgXYOv1d02YBKimHuzn/Z5U5ecziAYNP/xc=;
 b=U9SmvRzGhPPyZYqS/+1CrHBpGyeeKGqzOlVrrZst7oGrLTiI+aMDmHVewk9b2cEoUQbP
 NEz+2ZJwpUn28LJkdGo1Nv+mJmD3tAl0LLvxPUnGjvDweVl4lkG7/0bqBrZp1InTRccp
 xUhVYOjm9B67tp5gECoYr7ZkXDDUUnmeuYs7aXgjTTKLo+ZiwFSUUZWLdZR2/GckEhtO
 Mh87Xzc+INO1CtJbW9siStJl47Zv38D/4C65V5wnNKrR0+ZNwZEJPj/p+WrGUrGGETVV
 ng7eMHdu8cnCjPQ8tGZ93hhe5jrCoJ7PWQ/EBYVXe/TQZXB0AosFzW0RKZnai3CJdy5M KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g8d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:21 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35U9DKgd000733;
        Fri, 30 Jun 2023 09:18:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv72g8bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U1kGWm019237;
        Fri, 30 Jun 2023 09:18:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4542qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35U9IDd21770030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 09:18:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CA0E20049;
        Fri, 30 Jun 2023 09:18:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DBA20040;
        Fri, 30 Jun 2023 09:18:11 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.38.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 09:18:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v21 13/20] docs/s390x/cpu topology: document s390x cpu topology
Date:   Fri, 30 Jun 2023 11:17:45 +0200
Message-Id: <20230630091752.67190-14-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2CMYSKdXpjUJyNqZYnyDfdM6V_kkJMXO
X-Proofpoint-GUID: VkAOPmbV-OlusbmDtIrVF15cF-ORNuTX
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

Add some basic examples for the definition of cpu topology
in s390x.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 MAINTAINERS                        |   2 +
 docs/devel/index-internals.rst     |   1 +
 docs/devel/s390-cpu-topology.rst   | 170 ++++++++++++++++++++
 docs/system/s390x/cpu-topology.rst | 240 +++++++++++++++++++++++++++++
 docs/system/target-s390x.rst       |   1 +
 5 files changed, 414 insertions(+)
 create mode 100644 docs/devel/s390-cpu-topology.rst
 create mode 100644 docs/system/s390x/cpu-topology.rst

diff --git a/MAINTAINERS b/MAINTAINERS
index b8d3e8815c..76f236564c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1703,6 +1703,8 @@ S: Supported
 F: include/hw/s390x/cpu-topology.h
 F: hw/s390x/cpu-topology.c
 F: target/s390x/kvm/stsi-topology.c
+F: docs/devel/s390-cpu-topology.rst
+F: docs/system/s390x/cpu-topology.rst
 
 X86 Machines
 ------------
diff --git a/docs/devel/index-internals.rst b/docs/devel/index-internals.rst
index e1a93df263..6f81df92bc 100644
--- a/docs/devel/index-internals.rst
+++ b/docs/devel/index-internals.rst
@@ -14,6 +14,7 @@ Details about QEMU's various subsystems including how to add features to them.
    migration
    multi-process
    reset
+   s390-cpu-topology
    s390-dasd-ipl
    tracing
    vfio-migration
diff --git a/docs/devel/s390-cpu-topology.rst b/docs/devel/s390-cpu-topology.rst
new file mode 100644
index 0000000000..cd36476011
--- /dev/null
+++ b/docs/devel/s390-cpu-topology.rst
@@ -0,0 +1,170 @@
+QAPI interface for S390 CPU topology
+====================================
+
+Let's start QEMU with the following command defining 4 CPUs,
+CPU[0] defined by the -smp argument will have default values:
+
+.. code-block:: bash
+
+ qemu-system-s390x \
+    -enable-kvm \
+    -cpu z14,ctop=on \
+    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
+    \
+    -device z14-s390x-cpu,core-id=19,entitlement=high \
+    -device z14-s390x-cpu,core-id=11,entitlement=low \
+    -device z14-s390x-cpu,core-id=112,entitlement=high \
+   ...
+
+and see the result when using the QAPI interface.
+
+Addons to query-cpus-fast
+-------------------------
+
+The command query-cpus-fast allows to query the topology tree and
+modifiers for all configured vCPUs.
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
+QAPI command: set-cpu-topology
+------------------------------
+
+The command set-cpu-topology allows to modify the topology tree
+or the topology modifiers of a vCPU in the configuration.
+
+.. code-block:: QMP
+
+    { "execute": "set-cpu-topology",
+      "arguments": {
+         "core-id": 11,
+         "socket-id": 0,
+         "book-id": 0,
+         "drawer-id": 0,
+         "entitlement": "low",
+         "dedicated": false
+      }
+    }
+    {"return": {}}
+
+The core-id parameter is the only non optional parameter and every
+unspecified parameter keeps its previous value.
+
+QAPI event CPU_POLARIZATION_CHANGE
+----------------------------------
+
+When a guest is requests a modification of the polarization,
+QEMU sends a CPU_POLARIZATION_CHANGE event.
+
+When requesting the change, the guest only specifies horizontal or
+vertical polarization.
+It is the job of the upper layer to set the dedication and fine grained
+vertical entitlement in response to this event.
+
+Note that a vertical polarized dedicated vCPU can only have a high
+entitlement, this gives 6 possibilities for vCPU entitlement:
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
+  {
+    "timestamp": {
+      "seconds": 1687870305,
+      "microseconds": 566299
+    },
+    "event": "CPU_POLARIZATION_CHANGE",
+    "data": {
+      "polarization": "horizontal"
+    }
+  }
+
+QAPI query command: query-cpu-polarization
+------------------------------------------
+
+The query command query-cpu-polarization returns the current
+CPU polarization of the machine.
+In the case the guest issued a PTF(1) to request a vertical polarization:
+
+.. code-block:: QMP
+
+    { "execute": "query-cpu-polarization" }
+    {
+        "return": {
+          "polarization": "vertical"
+        }
+    }
diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
new file mode 100644
index 0000000000..0535a5d883
--- /dev/null
+++ b/docs/system/s390x/cpu-topology.rst
@@ -0,0 +1,240 @@
+CPU topology on s390x
+=====================
+
+Since QEMU 8.1, CPU topology on s390x provides up to 3 levels of
+topology containers: drawers, books, sockets, defining a tree shaped
+hierarchy.
+
+The socket container contains one or more CPU entries.
+Each of these CPU entries consists of a bitmap and three CPU attributes:
+
+- CPU type
+- entitlement
+- dedication
+
+Each bit set in the bitmap correspond to the core-id of a vCPU with
+matching the three attribute.
+
+This documentation provide general information on S390 CPU topology,
+how to enable it and on the new CPU attributes.
+For information on how to modify the S390 CPU topology and on how to
+monitor the polarization change see ``Developer Information``.
+
+Prerequisites
+-------------
+
+To use the CPU topology, you need to run with KVM on a s390x host that
+uses the Linux kernel v6.0 or newer (which provide the so-called
+``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal the
+CPU topology facility via the so-called STFLE bit 11 to the VM).
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
+Note also that since 7.2 threads are no longer supported in the topology
+and the ``-smp`` command line argument accepts only ``threads=1``.
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
+    -device gen16b-s390x-cpu,core-id=1,dedicated=true
+
+If none of the tree attributes (drawer, book, sockets), are specified
+for the ``-device`` argument, as for all CPUs defined with the ``-smp``
+command argument the topology tree attributes will be set by simply
+adding the CPUs to the topology based on the core-id starting with
+core-0 at position 0 of socket-0, book-0, drawer-0.
+
+QEMU will not try to solve collisions and will report an error if the
+CPU topology, explicitly or implicitly defined on a ``-device``
+argument collides with the definition of a CPU implicitely defined
+on the ``-smp`` argument.
+
+When the topology modifier attributes are not defined for the
+``-device`` command argument they takes following default values:
+
+- dedicated: ``false``
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
+The vertical polarization specifies that the guest's vCPU can get
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
+The upper level specifies a vCPU as ``dedicated`` when the vCPU is
+fully dedicated to a single real CPU.
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
+book 0, socket 0 without defining entitlement or dedication.
+The core 4, will be set on its default position on socket 1
+(since we have 4 core per socket) and we define it as dedicated and
+with vertical high entitlement.
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
+    -device gen16b-s390x-cpu,core-id=4,dedicated=on,entitlement=high
+
+The entitlement defined for the CPU 4, will only be used after the guest
+successfully enables vertical polarization by using the PTF instruction.
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

