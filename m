Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE886D4DBE
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjDCQaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjDCQ3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE98E1FDE
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:47 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333FTptn012446;
        Mon, 3 Apr 2023 16:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8ACW5mvT8tm+0+AyG2GJdTWSfLWUyBLe0dnE/jrzvFU=;
 b=qE0LlBaS+odEVlZM5Wse6me1xaBKawAX/2PjeC7yyQcqjxcWE6rDhrMqgnY4WY/mKrXA
 W2OZ6isHA4Wt/xvNb6KvsYNMqX8xaBEcbFKAsOxlBCXusWR/D5kFIxb77iUdOaDm/cIY
 uUUSSKrUotCKnHO84qC6rsvpQaeZ9H/Dlo9qDaHhFCU4geW1X8SQdt+SnYDBMeweLvdT
 P7R6cllovnZnVsH0YjQ6htLN1qT/SGw2NvmnAvdYCpt80d9NquMdiHareLKmCyKIaIm8
 tUgJ9PfafTFe5fGI4tFnSBrgxZdiAGKDtopWZ8eZvatcZXvgwoaVj9AbsXwzCUqi9XYr hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1gb9j75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:42 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333FVVF5018539;
        Mon, 3 Apr 2023 16:29:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1gb9j6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 332LjFMn002680;
        Mon, 3 Apr 2023 16:29:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc879vbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTaHQ47055360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EBA420040;
        Mon,  3 Apr 2023 16:29:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63B7620043;
        Mon,  3 Apr 2023 16:29:35 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:35 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 16/21] tests/avocado: s390x cpu topology entitlement tests
Date:   Mon,  3 Apr 2023 18:29:00 +0200
Message-Id: <20230403162905.17703-17-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D6q6RSSBO7bheqKAszDI6G2Sm_khx9gS
X-Proofpoint-GUID: umQhfWbHjNMuWsVyj4JpoxJLh9iZ8vJ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030118
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test takes care to check the changes on different entitlements
when the guest requests a polarization change.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 56 ++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index a4bbbc2cb6..f12f0ae148 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -230,3 +230,59 @@ def test_polarisation(self):
                 '/bin/cat /sys/devices/system/cpu/dispatching', '0')
 
         self.check_topology(0, 0, 0, 0, 'medium', False)
+
+    def test_set_cpu_topology_entitlement(self):
+        """
+        This test verifies that QEMU modifies the polarization
+        after a guest request.
+
+        :avocado: tags=arch:s390x
+        :avocado: tags=machine:s390-ccw-virtio
+        """
+        self.kernel_init()
+        self.vm.add_args('-smp',
+                         '1,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
+        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=1')
+        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=2')
+        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=3')
+        self.vm.launch()
+        self.wait_for_console_pattern('no job control')
+
+        self.system_init()
+
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 0, 'entitlement': 'low'})
+        self.assertEqual(res['return'], {})
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 1, 'entitlement': 'medium'})
+        self.assertEqual(res['return'], {})
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 2, 'entitlement': 'high'})
+        self.assertEqual(res['return'], {})
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 3, 'entitlement': 'high'})
+        self.assertEqual(res['return'], {})
+        self.check_topology(0, 0, 0, 0, 'low', False)
+        self.check_topology(1, 0, 0, 0, 'medium', False)
+        self.check_topology(2, 1, 0, 0, 'high', False)
+        self.check_topology(3, 1, 0, 0, 'high', False)
+
+        exec_command(self, 'echo 1 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '1')
+
+        self.check_topology(0, 0, 0, 0, 'low', False)
+        self.check_topology(1, 0, 0, 0, 'medium', False)
+        self.check_topology(2, 1, 0, 0, 'high', False)
+        self.check_topology(3, 1, 0, 0, 'high', False)
+
+        exec_command(self, 'echo 0 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
+
+        self.check_topology(0, 0, 0, 0, 'low', False)
+        self.check_topology(1, 0, 0, 0, 'medium', False)
+        self.check_topology(2, 1, 0, 0, 'high', False)
+        self.check_topology(3, 1, 0, 0, 'high', False)
-- 
2.31.1

