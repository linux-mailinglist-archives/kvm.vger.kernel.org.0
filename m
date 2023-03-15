Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D20D6BB636
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjCOOgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjCOOgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:36:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9705AB4B
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:35:50 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FELT2O015062;
        Wed, 15 Mar 2023 14:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5U9DW9qO++BtSEyMWDOX/G2DdsQ2DmlQkqsLk17OEhw=;
 b=j1Km4k0ANFIWHsnJn5FYFSLQepCsUF1QO/iyUODd6PgQvSaacJ+8mJNX3NMkxkVgyyhC
 bsOUkpaBwoAltm2wiwUqLOcdoglJRpvwkJbvi1Benwges/TgyjRJHZqmmW+pxmmsIvnE
 26y5C9TupQg6iZQaWR5V3KRWYhTmNbTC+MMgDngc1gf1PeuMtL+KDevLTsNaO0xwefSJ
 ABqCiiWFPkNSIUOmkLBl/zFWw8bJHhNln9THZvsNsqbmVz+V8C+oLt4/BHcQuIxv8sO5
 1KNrcQY6peiqQbB0tZTas1mRGgMLUy4bgDOSq0O9L/Cw/Kux3kTokOTCGJNFumxOghE1 Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbfq8rcf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:36 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FELQJj014914;
        Wed, 15 Mar 2023 14:35:36 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbfq8rcdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32EN66ci015062;
        Wed, 15 Mar 2023 14:35:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pb29t0rgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FEZTp847251934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:35:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABF612004E;
        Wed, 15 Mar 2023 14:35:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51F9B20040;
        Wed, 15 Mar 2023 14:35:28 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.95.209])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 14:35:28 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v18 16/17] tests/avocado: s390x cpu topology test dedicated CPU
Date:   Wed, 15 Mar 2023 15:35:01 +0100
Message-Id: <20230315143502.135750-17-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230315143502.135750-1-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ufCC1_ULk_zyVcQfWvk9ABoeU2NVIdSL
X-Proofpoint-GUID: y2XksO21LPDcONgDbh4AW9-R691IznU4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 clxscore=1015 impostorscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
index c6ee46fb52..be1db67ff4 100644
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
         self.check_topology(0, 0, 0, 0, 'horizontal', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_default(self):
         """
         This test checks the implicite topology.
@@ -147,6 +150,7 @@ def test_default(self):
         self.check_topology(11, 2, 1, 0, 'horizontal', False)
         self.check_topology(12, 0, 0, 1, 'horizontal', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_move(self):
         """
         This test checks the topology modification by moving a CPU
@@ -167,6 +171,7 @@ def test_move(self):
         self.assertEqual(res['return'], {})
         self.check_topology(0, 2, 0, 0, 'horizontal', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_hotplug(self):
         """
         This test verifies that a CPU defined with '-device' command line
@@ -184,6 +189,7 @@ def test_hotplug(self):
 
         self.check_topology(10, 2, 1, 0, 'horizontal', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_hotplug_full(self):
         """
         This test verifies that a hotplugged fully defined with '-device'
@@ -202,6 +208,7 @@ def test_hotplug_full(self):
         self.wait_for_console_pattern('no job control')
         self.check_topology(1, 1, 1, 1, 'horizontal', False)
 
+    @skipIf(skip_basis, 'skipping basis tests')
     def test_polarisation(self):
         """
         This test verifies that QEMU modifies the entitlement change after
@@ -231,7 +238,7 @@ def test_polarisation(self):
 
         self.check_topology(0, 0, 0, 0, 'horizontal', False)
 
-    def test_set_cpu_topology_entitlement(self):
+    def test_entitlement(self):
         """
         This test verifies that QEMU modifies the polarization
         after a guest request.
@@ -286,3 +293,37 @@ def test_set_cpu_topology_entitlement(self):
         self.check_topology(1, 0, 0, 0, 'horizontal', False)
         self.check_topology(2, 1, 0, 0, 'horizontal', False)
         self.check_topology(3, 1, 0, 0, 'horizontal', False)
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
+        self.check_topology(0, 0, 0, 0, 'horizontal', True)
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
+        self.check_topology(0, 0, 0, 0, 'horizontal', True)
-- 
2.31.1

