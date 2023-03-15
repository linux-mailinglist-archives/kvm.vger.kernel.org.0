Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030A46BB634
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjCOOgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjCOOf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:35:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D7A56518
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:35:47 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FCpnJY000743;
        Wed, 15 Mar 2023 14:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=N0vW1+w774dkCmI3ncBWIImCzCYY7NMi+9NA3Ik1WUA=;
 b=ImLXU/Uo01dhX8p4HBJIDP0UitJnnDmu8dKlfaFfIEZ/6PCzuO08Dc66JaOh1xgjtPyF
 H48tYvaWU0f9cebz6Gr/mMwzpQzX0jZxMhUD5GBv5kA3P0M2ygYJ5/11lPCUskgRA7Fm
 jg1rKjml7+UaipgrXD8Nh62uzESKXbhZvB5kbU45sc2yNWSjM/uYDxqovfxQyL1nrGI5
 1gf292CwAgvuZRC9zup7dmspvMOd1I5fZEJYPx+qC5HLai9NrcN3z3WEXxu3AJdluS3z
 PS0Q0Y5Cuqs5MfyFoHWz+ma0GNTAu8TB+5aeNr4hCtjegD6BSjEDFSjHfilpvE6712kl gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbed8ud5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:33 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FDVnW2004355;
        Wed, 15 Mar 2023 14:35:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbed8ud3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32EN62qT001318;
        Wed, 15 Mar 2023 14:35:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pb29rrrex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FEZQwG12649156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:35:26 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47782004D;
        Wed, 15 Mar 2023 14:35:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D27320043;
        Wed, 15 Mar 2023 14:35:25 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.95.209])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 14:35:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v18 14/17] tests/avocado: s390x cpu topology polarisation
Date:   Wed, 15 Mar 2023 15:34:59 +0100
Message-Id: <20230315143502.135750-15-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230315143502.135750-1-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EvxjnNWuEVchWBN9sMGxW_wNW6qo9AAa
X-Proofpoint-ORIG-GUID: -TsCJZQ1sgv4qSymgrPB8O710KXzDitC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index c908111e94..70bd3a8b5a 100644
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
         self.check_topology(1, 1, 1, 1, 'horizontal', False)
 
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
+        self.check_topology(0, 0, 0, 0, 'horizontal', False)
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
+        self.check_topology(0, 0, 0, 0, 'horizontal', False)
-- 
2.31.1

