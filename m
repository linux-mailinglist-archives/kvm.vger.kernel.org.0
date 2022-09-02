Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BEC5AA932
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiIBH4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiIBH4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52E5E32F
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:54 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827VmqW012162;
        Fri, 2 Sep 2022 07:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+IWiVjvMv3xCNsfnJjzrKOprtnCXnRUJuvZF+ft0qyU=;
 b=cUA6IkVqrYYi4Yk7F+rlAQei9plYMSrwGQv6GfO3Ot3FYcqHcY2ZeKx63RE1LHMTCs5m
 J4nQjTNe7ArKq2VKT20sRjlkw5skj5WwUvgI7QzOSyyBpLmlXV4eO2S6uVwz4C7V8uHZ
 OiHMQJ6OaIlDgS8BQarvhqRozER3FE62wpNwvGfFQLtsIRAUUbeVCd7hTiT5+tIk39UZ
 1nR4ZRpBJPf5IvpNiypYJ/8BR7fjbaCORQq8VEOf+fpW2CekV7zwmXDGlDVgztpx+L5y
 4lwB3YvzmlFWXuzKF0RAliwro7ZuXa/TJKT+y8nJAumcKNZ8YvA/Z6wi7YypG02k8Dy9 YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmuwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:48 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2826UNRd025400;
        Fri, 2 Sep 2022 07:55:47 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbrnmuw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:47 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827pb9s027648;
        Fri, 2 Sep 2022 07:55:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3j7aw8wqwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827u5F839387640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:56:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B7211C04A;
        Fri,  2 Sep 2022 07:55:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A92111C04C;
        Fri,  2 Sep 2022 07:55:41 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:41 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 10/10] docs/s390x: document s390x cpu topology
Date:   Fri,  2 Sep 2022 09:55:31 +0200
Message-Id: <20220902075531.188916-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x2LUgSHHP-1QddOS7LzjJVLZZ2zVUwv7
X-Proofpoint-ORIG-GUID: Ah9qK5dsGwHKrbKCyWIxcKLGrBtAVUsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic examples for the definition of cpu topology
in s390x.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 docs/system/s390x/cpu_topology.rst | 88 ++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 docs/system/s390x/cpu_topology.rst

diff --git a/docs/system/s390x/cpu_topology.rst b/docs/system/s390x/cpu_topology.rst
new file mode 100644
index 0000000000..00977d4319
--- /dev/null
+++ b/docs/system/s390x/cpu_topology.rst
@@ -0,0 +1,88 @@
+CPU Topology on s390x
+=====================
+
+CPU Topology on S390x provides up to 4 levels of topology containers:
+drawers, books, sockets and CPUs.
+While the three higher level containers, Containers Topology List Entries,
+(Containers TLE) define a tree hierarchy, the lowest level of topology
+definition, the CPU Topology List Entry (CPU TLE), provides the placement
+of the CPUs inside the last container.
+
+Prerequisites
+-------------
+
+To use CPU Topology a Linux QEMU/KVM machine providing the CPU Topology facility
+(STFLE bit 11) is required.
+
+However, since this facility has been enabled by default in an early version,
+the capability ``KVM_CAP_S390_CPU_TOPOLOGY`` is needed to indicate to KVM
+that QEMU support CPU Topology.
+
+Indicating the CPU topology to the Virtual Machine
+--------------------------------------------------
+
+The CPU Topology, number of drawers, number of books per drawers, number of
+sockets per book and number of cores per sockets is specified with the
+``-smp`` qemu command arguments.
+
+Like in :
+
+.. code-block:: sh
+    -smp cpus=1,drawers=3,books=4,sockets=2,cores=8,maxcpus=192
+
+If drawers or books are not specified, their default to 1.
+
+New CPUs can be plugged using the device_add hmp command like in:
+
+.. code-block:: sh
+   (qemu) device_add host-s390x-cpu,core-id=9
+
+The core-id defines the placement of the core in the topology by
+starting with core 0 in socket 0, book 0 and drawer 0 up to the maximum
+core number of the last socket of the last book in the last drawer.
+
+In the example above:
+
+* the core with ID 9 will be placed in container (0,0,1), as core 9
+  of CPU TLE 0 of socket 1 in book 0 from drawer 0.
+* the core ID 0 is defined by the -smp cpus=1 command and will be
+  placed as core 0 in CPU TLE 0 of container (0,0,0)
+
+Note that the core ID is machine wide and the CPU TLE masks provided
+by the STSI instruction will be:
+
+* in socket 0: 0x80000000 (core id 0)
+* in socket 1: 0x00400000 (core id 9)
+
+Indicating the CPU topology to the Guest
+----------------------------------------
+
+The guest can query for topology changes using the PTF instruction.
+In case of a topology change it can request the new topology by issuing
+STSI instructions specifying the level of detail required, drawer with
+STSI(15.1.4) or books STSI(15.1.3).
+
+The virtual machine will fill the provided buffer with the count of
+drawers (MAG4), books per drawer (MAG3), sockets per book (MAG2) and
+cores per socket (MAG1).
+
+Note that the STSI(15.1.2) is special in two ways:
+
+* When the firmware detect a change in the values calculated for STSI(15.1.2)
+  it will trigger the report of the topology change for the PTF instruction.
+
+Migration
+---------
+
+For virtio-ccw machines older than s390-virtio-ccw-7.2, CPU Topoogy is
+by default disabled.
+
+CPU Topoogy is by default enabled for s390-virtio-ccw-7.2 and newer machines.
+
+Enabling the CPU topology on older Machine is done by setting the global
+option ''topology-disable'' to false before enabling cpu topology with the
+cpu feature "ctop" like in:
+
+.. code-block:: sh
+   -machine s390-ccw-virtio-3.0,accel=kvm,topology-disable=false
+   -cpu z14,ctop=on
-- 
2.31.1

