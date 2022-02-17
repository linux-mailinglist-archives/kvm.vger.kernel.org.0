Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B794BA16C
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbiBQNkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:40:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241038AbiBQNkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:40:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9CF29ADC1
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:49 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HDBtBL032405;
        Thu, 17 Feb 2022 13:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HtBjouYh/khg0VzKgu31GEOtWucFRevC0aoJP77O1TE=;
 b=E8qoQwpdrLKdA7A/3ebnQqfXxYpf4j9v11LRJitsav8HtwxHDfstvhkZ37PLQutIrZb0
 t3pj0Z7BV52wc405buFO+sZFZkegkOdCkRSg8i4Upd6p2YozTcXLIeEkNCnvyeU4xrg4
 XSwcBppsLV29NdoyR4xWyaGY53QPdLTvyLViwMvauN8tJGWZx2TxDK78YXXHsnI9vSan
 BwhJHe3ahWcTu3MLFdRqJsCTPMm/HoQNNwa5r5hBzH18UBV/lxyZThuYozSsX+B5++sk
 n8UI1SMMD9DN4hspYZKzJlGz8/akoJI3GcCQfE2gGTzQnBN588FoQhbA4yJ6ae53eb+N Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9n9pkjnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:29 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HD1pck014937;
        Thu, 17 Feb 2022 13:39:28 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9n9pkjmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDbP6e029436;
        Thu, 17 Feb 2022 13:39:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3e645k8hre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdLSg32964930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A865D4C05A;
        Thu, 17 Feb 2022 13:39:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4AC24C044;
        Thu, 17 Feb 2022 13:39:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 11/11] s390x: topology: documentation
Date:   Thu, 17 Feb 2022 14:41:25 +0100
Message-Id: <20220217134125.132150-12-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _agRRUwEZj5qcxZLuOUhWLDcE5TBlgiB
X-Proofpoint-ORIG-GUID: 1wfrkBIeWAkdFaIcQhIfufr2yXiscKRP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The use of the S390x CPU topology is explain in a new documentation
file.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 docs/system/s390x/numa-cpu-topology.rst | 273 ++++++++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100644 docs/system/s390x/numa-cpu-topology.rst

diff --git a/docs/system/s390x/numa-cpu-topology.rst b/docs/system/s390x/numa-cpu-topology.rst
new file mode 100644
index 0000000000..9ae15f792f
--- /dev/null
+++ b/docs/system/s390x/numa-cpu-topology.rst
@@ -0,0 +1,273 @@
+NUMA CPU Topology on S390x
+==========================
+
+IBM S390 provides a complex CPU architecture with several cache levels.
+Using NUMA with the CPU topology is a way to let the guest optimize his
+accesses to the main memory.
+
+The QEMU smp parameter for S390x allows to specify 4 NUMA levels:
+core, socket, drawer and book and these levels are available for
+the numa parameter too.
+
+
+Prerequisites
+-------------
+
+To take advantage of the CPU topology, KVM must give support for the
+Perform Topology Function and to the Store System Information instructions
+as indicated by the Perform CPU Topology facility (stfle bit 11).
+
+If those requirements are met, the capability ``KVM_CAP_S390_CPU_TOPOLOGY``
+will indicate that KVM can support CPU Topology on that LPAR.
+
+
+Using CPU Topology in QEMU for S390x
+------------------------------------
+
+
+QEMU -smp parameter
+~~~~~~~~~~~~~~~~~~~
+
+With -smp QEMU provides the user with the possibility to define
+a Topology based on ::
+
+  -smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books] \
+       [,sockets=sockets][,cores=cores]
+
+The topology reported to the guest in this situation will provide
+n cpus of a maximum of maxcpus cpus, filling the topology levels one by one
+starting with CPU0 being the first CPU on drawer[0] book[0] socket[0].
+
+For example ``-smp 5,books=2,sockets=2,cores=2`` will provide ::
+
+  drawer[0]--+--book[0]--+--socket[0]--+--core[0]-CPU0
+             |           |             |
+             |           |             +--core[1]-CPU1
+             |           |
+             |           +--socket[1]--+--core[0]-CPU2
+             |                         |
+             |                         +--core[1]-CPU3
+             |
+             +--book[1]--+--socket[0]--+--core[0]-CPU4
+
+
+Note that the thread parameter can not be defined on S390 as it
+has no representation on the CPU topology.
+
+
+QEMU -numa parameter
+~~~~~~~~~~~~~~~~~~~
+
+With -numa QEMU provides the user with the possibility to define
+the Topology in a non uniform way ::
+
+  -smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books] \
+       [,sockets=sockets][,cores=cores]
+  -numa node[,memdev=id][,cpus=firstcpu[-lastcpu]][,nodeid=node][,initiator=initiator]
+  -numa cpu,node-id=node[,drawer-id=x][,book-id=x][,socket-id=x][,core-id=y]
+
+The topology reported to the guest in this situation will provide
+n cpus of a maximum of maxcpus cpus, and the topology entries will be
+
+- if there is less cpus than specified by the -numa arguments
+  the topology will be build by filling the numa definitions
+  starting with the lowest node.
+
+- if there is more cpus than specified by the -numa argument
+  the numa specification will first be fulfilled and the remaining
+  CPU will be assigned to unassigned slots starting with the
+  core 0 on socket 0.
+
+- a CPU declared with -device does not count inside the ncpus parameter
+  of the -smp argument and will be added on the topology based on
+  its core ID.
+
+For example  ::
+
+  -smp 3,drawers=8,books=2,sockets=2,cores=2,maxcpus=64
+  -object memory-backend-ram,id=mem0,size=10G
+  -numa node,nodeid=0,memdev=mem0
+  -numa node,nodeid=1
+  -numa node,nodeid=2
+  -numa cpu,node-id=0,drawer-id=0
+  -numa cpu,node-id=1,socket-id=9
+  -device host-s390x-cpu,core-id=19
+
+Will provide the following topology ::
+
+  drawer[0]--+--book[0]--+--socket[0]--+--core[0]-CPU0
+                         |             |
+                         |             +--core[1]-CPU1
+                         |
+                         +--socket[1]--+--core[0]-CPU2
+
+  drawer[2]--+--book[0]--+--socket[1]--+--core[1]-CPU19
+
+
+S390 NUMA specificity
+---------------------
+
+Heterogene Memory Attributes
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The S390 topology implementation does not use ACPI HMAT to specify the
+cache size and bandwidth between nodes.
+
+Memory device
+~~~~~~~~~~~~~
+
+When using NUMA S390 needs a memory device to be associated with
+the nodes definitions. As we do not use HMAT, it has little sense
+to assign memory to each node and one should assign all memory to
+a node without CPU and use other nodes to define the CPU Topology.
+
+Exemple ::
+
+  -object memory-backend-ram,id=mem0,size=10G
+  -numa node,nodeid=0,memdev=mem0
+
+
+CPUs
+~~~~
+
+In the S390 topology we do not use threads and the first topology
+level is the core.
+The number of threads can no be defined for S390 and is always equal to 1.
+
+When using NUMA, QEMU issues a warning for CPUS not assigned to nodes.
+The S390 topology will silently assign unassigned CPUs to the topology
+searching for free core starting on the first core of the first socket
+in the first book.
+This is of course advised to assign all possible CPUs to nodes to
+guaranty future compatibility.
+
+
+The topology provided to the guest
+----------------------------------
+
+The guest , when the CPU Topology is available as indicated by the
+Perform CPU Topology facility (stfle bit 11) may use two instructions
+to retrieve the CPU topology and optimize its CPU scheduling:
+
+- PTF (Perform Topology function) which will give information
+  about a change in the CPU Topology, that is a change in the
+  result of the STSI(15,1,2) instruction.
+
+- STSI (Stote System Information) with parameters (15,1,2)
+  to retrieve the CPU Topology.
+
+Exemple ::
+
+  -smp 3,drawers=8,books=2,sockets=2,cores=2,maxcpus=64
+  -object memory-backend-ram,id=mem0,size=10G
+  -numa node,nodeid=0,memdev=mem0
+  -numa node,nodeid=1
+  -numa node,nodeid=2
+  -numa cpu,node-id=1,drawer-id=0
+  -numa cpu,node-id=2,socket-id=9
+  -device host-s390x-cpu,core-id=19
+
+Formated result for STSI(15,1,2) showing the 6 different levels
+with:
+- levels 2 (socket) and 1 (core) used.
+- 3 sockets with a CPU mask for CPU type 3, non dedicated and
+  with horizontal polarization.
+- The first socket contains 2 cores as specified by the -smp argument
+- The second socket contains the 3rd core defined by the -smp argument
+- both these sockets belong to drawer-id=0 and to node-1
+- The third socket hold the CPU with core-id 19 assigned to socket-id 9
+  and to node-2
+
+Here the kernel view ::
+
+  mag[6] = 0
+  mag[5] = 0
+  mag[4] = 0
+  mag[3] = 0
+  mag[2] = 32
+  mag[1] = 2
+  MNest  = 2
+  socket: 1 0
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : c000000000000000
+
+  socket: 1 1
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : 2000000000000000
+
+  socket: 1 9
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : 0000100000000000
+
+And the admin view ::
+
+  # lscpu -e
+  CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
+  0   0    0      0    0      0    0:0:0:0         yes    yes        horizontal   0
+  1   0    0      0    0      1    1:1:1:1         yes    yes        horizontal   1
+  2   0    0      0    1      2    2:2:2:2         yes    yes        horizontal   2
+  3   0    1      1    2      3    3:3:3:3         yes    yes        horizontal   19
+
+
+Hotplug with NUMA
+-----------------
+
+Using the core-id the topology is automatically calculated to put the core
+inside the right socket.
+
+Example::
+
+  (qemu) device_add host-s390x-cpu,core-id=8
+
+  # lscpu -e
+  CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
+  0   0    0      0    0      0    0:0:0:0         yes    yes        horizontal   0
+  1   0    0      0    0      1    1:1:1:1         yes    yes        horizontal   1
+  2   0    0      0    1      2    2:2:2:2         yes    yes        horizontal   2
+  3   0    1      1    2      3    3:3:3:3         yes    yes        horizontal   19
+  4   -    -      -    -      -    :::             no     yes        horizontal   8
+
+  # chcpu -e 4
+  CPU 4 enabled
+  # lscpu -e
+  CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
+  0   0    0      0    0      0    0:0:0:0         yes    yes        horizontal   0
+  1   0    0      0    0      1    1:1:1:1         yes    yes        horizontal   1
+  2   0    0      0    1      2    2:2:2:2         yes    yes        horizontal   2
+  3   0    1      1    2      3    3:3:3:3         yes    yes        horizontal   19
+  4   0    2      2    3      4    4:4:4:4         yes    yes        horizontal   8
+
+One can see that the userland tool reports serials IDs which do not correspond
+to the firmware IDs but does however report the new CPU on it's own socket.
+
+The result seen by the kernel looks like ::
+
+  mag[6] = 0
+  mag[5] = 0
+  mag[4] = 0
+  mag[3] = 0
+  mag[2] = 32
+  mag[1] = 2
+  MNest  = 2
+  00 - socket: 1 0
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : c000000000000000
+
+  socket: 1 1
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : 2000000000000000
+
+  socket: 1 9
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : 0000100000000000
+
+  socket: 1 4
+  cpu type 03  d: 0 pp: 0
+  origin : 0000
+  mask   : 0080000000000000
-- 
2.27.0

