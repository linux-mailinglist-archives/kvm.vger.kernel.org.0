Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4B96D4DC4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjDCQaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjDCQ3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F326BB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:52 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333Fs2sj024073;
        Mon, 3 Apr 2023 16:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iAyxU79jZOe67iGqqcX8/K1Dt7890Atae81e50M0Dp0=;
 b=Ef4sv1NISTSYavGZgztwVr7Q4MZyfI8UyuuuxrDf3VlIcAgK11xlya1rEw8tlxrckxov
 tLUiLajCtve6Qe1tb4PYsTd9bfs8U53ZO4cLfnrvJiRWhVAL5NknGe570hKDBNmoCja0
 5n3sFQ2iLkzvMX2EADhi2yeGIe+RwQXHpEzwyTAXOwca97KVHP4SVlJuD9Lx11Imbgir
 p317WNKd16X3fgye85c5zp/QiVGnRRHtOmRWmT9PTTa3RJ/VuVhDRmUN961xYNjCQCHf
 MRpcJOaYL0YhxfAg4klkkcBjyCUaGZm+q6ruehyN5wgm2b9thXwYnarBjq1XRX+U/x+0 Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1uhgwr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333GEHJp015891;
        Mon, 3 Apr 2023 16:29:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1uhgwqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3330V6A2032749;
        Mon, 3 Apr 2023 16:29:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfsdpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTZVg55902576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C32E20040;
        Mon,  3 Apr 2023 16:29:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2440020043;
        Mon,  3 Apr 2023 16:29:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 15/21] tests/avocado: s390x cpu topology polarisation
Date:   Mon,  3 Apr 2023 18:28:59 +0200
Message-Id: <20230403162905.17703-16-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5JGJvHt6T5YF1tQX2QlFAhVWw5EKk-vK
X-Proofpoint-ORIG-GUID: ITqC-jJxYkngI0dFmpHHwQOMlrVcarBX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
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

Polarization is changed on a request from the guest.
Let's verify the polarization is accordingly set by QEMU.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 38 +++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index 38e9cc4f16..a4bbbc2cb6 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -107,6 +107,15 @@ def kernel_init(self):
                          '-initrd', initrd_path,
                          '-append', kernel_command_line)
 
+    def system_init(self):
+        self.log.info("System init")
+        exec_command(self, 'mount proc -t proc /proc')
+        time.sleep(0.2)
+        exec_command(self, 'mount sys -t sysfs /sys')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
+
     def test_single(self):
         self.kernel_init()
         self.vm.launch()
@@ -116,7 +125,6 @@ def test_single(self):
     def test_default(self):
         """
         This test checks the implicite topology.
-
         :avocado: tags=arch:s390x
         :avocado: tags=machine:s390-ccw-virtio
         """
@@ -194,3 +202,31 @@ def test_hotplug_full(self):
         self.wait_for_console_pattern('no job control')
         self.check_topology(1, 1, 1, 1, 'medium', False)
 
+    def test_polarisation(self):
+        """
+        This test verifies that QEMU modifies the entitlement change after
+        several guest polarization change requests.
+
+        :avocado: tags=arch:s390x
+        :avocado: tags=machine:s390-ccw-virtio
+        """
+        self.kernel_init()
+        self.vm.launch()
+        self.wait_for_console_pattern('no job control')
+
+        self.system_init()
+        self.check_topology(0, 0, 0, 0, 'medium', False)
+
+        exec_command(self, 'echo 1 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '1')
+
+        self.check_topology(0, 0, 0, 0, 'medium', False)
+
+        exec_command(self, 'echo 0 > /sys/devices/system/cpu/dispatching')
+        time.sleep(0.2)
+        exec_command_and_wait_for_pattern(self,
+                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
+
+        self.check_topology(0, 0, 0, 0, 'medium', False)
-- 
2.31.1

