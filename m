Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F636D4DC0
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjDCQaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjDCQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68221FE9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:51 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333G8POb030453;
        Mon, 3 Apr 2023 16:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=goQp7Mq83A8PTdRpJQmcUORyKCMxPBD4dCvsOZb3f7c=;
 b=Pay4U+re4QMErwjotoJOXORYchyt2eGvd1+pt/9lRdDx2bCLpcTLCgHJ/z35ICRk+OrJ
 bLmU0LDGkp9eDdjLkMpaFZUtbEMHvelcifvjMOYCxusqJNg2LXJm66s6i/xNgvV+9b4o
 LYgTNkmQUPuEcJRrTEqh3sqWMYjIVQUWq946jxPGXDZbsanUIYjEPblNKJGEyCSplFbe
 B3rItQYILm42gHfHlAUz8tniFTum99Ob7gdntUnfbdP9Pb5RfhebhhqIQPaSNHw9UZ+B
 c6RyJBOhp6Ttvbhx2AThs6Oc7LLj1k5ObVZBzSRpQOCWMZ9S+hvP3VjZlB71+y2K+XGo Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxerm06r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:44 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333G83vK029518;
        Mon, 3 Apr 2023 16:29:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ppxerm060-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3333h5PI030727;
        Mon, 3 Apr 2023 16:29:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc871ut5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTbe326084078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1C1D20040;
        Mon,  3 Apr 2023 16:29:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96C0620043;
        Mon,  3 Apr 2023 16:29:36 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:36 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 17/21] tests/avocado: s390x cpu topology test dedicated CPU
Date:   Mon,  3 Apr 2023 18:29:01 +0200
Message-Id: <20230403162905.17703-18-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Kxq0T2HeZZpmvWfgqGb_Ey3TE7scSsyC
X-Proofpoint-GUID: kGBOy05Yq6zYqqJw1DbzvOfWGbVrbOBx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030118
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A dedicated CPU in vertical polarization can only have
a high entitlement.
Let's check this.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 43 +++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index f12f0ae148..6a41f08897 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -52,6 +52,7 @@ class S390CPUTopology(LinuxKernelTest):
     The polarization is changed on a request from the guest.
     """
     timeout = 90
+    skip_basis = False
 
 
     def check_topology(self, c, s, b, d, e, t):
@@ -116,12 +117,14 @@ def system_init(self):
         exec_command_and_wait_for_pattern(self,
                 '/bin/cat /sys/devices/system/cpu/dispatching', '0')
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_single(self):
         self.kernel_init()
         self.vm.launch()
         self.wait_for_console_pattern('no job control')
         self.check_topology(0, 0, 0, 0, 'medium', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_default(self):
         """
         This test checks the implicite topology.
@@ -147,6 +150,7 @@ def test_default(self):
         self.check_topology(11, 2, 1, 0, 'medium', False)
         self.check_topology(12, 0, 0, 1, 'medium', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_move(self):
         """
         This test checks the topology modification by moving a CPU
@@ -167,6 +171,7 @@ def test_move(self):
         self.assertEqual(res['return'], {})
         self.check_topology(0, 2, 0, 0, 'low', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_hotplug(self):
         """
         This test verifies that a CPU defined with '-device' command line
@@ -184,6 +189,7 @@ def test_hotplug(self):
 
         self.check_topology(10, 2, 1, 0, 'medium', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_hotplug_full(self):
         """
         This test verifies that a hotplugged fully defined with '-device'
@@ -202,6 +208,7 @@ def test_hotplug_full(self):
         self.wait_for_console_pattern('no job control')
         self.check_topology(1, 1, 1, 1, 'medium', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_polarisation(self):
         """
         This test verifies that QEMU modifies the entitlement change after
@@ -231,7 +238,7 @@ def test_polarisation(self):
 
         self.check_topology(0, 0, 0, 0, 'medium', False)
 
-    def test_set_cpu_topology_entitlement(self):
+    def test_entitlement(self):
         """
         This test verifies that QEMU modifies the polarization
         after a guest request.
@@ -286,3 +293,37 @@ def test_set_cpu_topology_entitlement(self):
         self.check_topology(1, 0, 0, 0, 'medium', False)
         self.check_topology(2, 1, 0, 0, 'high', False)
         self.check_topology(3, 1, 0, 0, 'high', False)
+
+    def test_dedicated(self):
+        """
+        This test verifies that QEMU modifies the entitlement change correctly
+        for a dedicated CPU after several guest polarization change requests.
+
+        :avocado: tags=arch:s390x
+        :avocado: tags=machine:s390-ccw-virtio
+        """
+        self.kernel_init()
+        self.vm.launch()
+        self.wait_for_console_pattern('no job control')
+
+        self.system_init()
+
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 0, 'dedicated': True})
+        self.assertEqual(res['return'], {})
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
+
+        exec_command(self, 'echo 1 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '1')
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
+
+        exec_command(self, 'echo 0 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
-- 
2.31.1

