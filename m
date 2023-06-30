Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E6B743819
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjF3JTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjF3JTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:19:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108734201
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 02:18:52 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35U9I8L9012015;
        Fri, 30 Jun 2023 09:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FZ9TXTay6jOBYDcFdzv2FKEjfRMUjf/AsOTTzukO9Y=;
 b=AZGGdmYwOVUBWYxPywmlCwiofg+azfC9H6LhH5TtwYf8f0obWopEBtvvSUZ2VCftWzJW
 QrYyQtx5t/tebaos6pEgwS5b0t3Jzuv9FxjnzmV864yD2l+cmmxm4O5ty9fkexkUEiU0
 qIX5PwxXqnSjZKXvZwnGRn9x4aimWH5NObltlYgwgHW/svpT4BC5NMpmG9Skgsxew9tr
 qCQAAIPSYiOysyX6JEHQ7j+Pf4EisrQ7Mju5VPM9WFWFwMczkArokK4MfxZqa9/RVbJi
 WRptnGisCuNfYSabFn57y8r3k+TtUzMml0B7f05i3aPPlQi2ibHx4mB1ABNu4Hj1b3r3 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv9vg1r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:33 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35U9IT5g014272;
        Fri, 30 Jun 2023 09:18:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv9vg19q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U4GViA029773;
        Fri, 30 Jun 2023 09:18:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rdr452yf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35U9IH2F38535596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 09:18:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E2A320043;
        Fri, 30 Jun 2023 09:18:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2774C20040;
        Fri, 30 Jun 2023 09:18:16 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.38.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 09:18:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement tests
Date:   Fri, 30 Jun 2023 11:17:48 +0200
Message-Id: <20230630091752.67190-17-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z64GFIrYuIIrj_auUAXo2Nb6XWCJjDty
X-Proofpoint-ORIG-GUID: kczaCzaHtGE2C8vJAPJVsr4Nrxx4th2Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
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

This test takes care to check the changes on different entitlements
when the guest requests a polarization change.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index 2cf731cb1d..4855e5d7e4 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -240,3 +240,50 @@ def test_polarisation(self):
         res = self.vm.qmp('query-cpu-polarization')
         self.assertEqual(res['return']['polarization'], 'horizontal')
         self.check_topology(0, 0, 0, 0, 'medium', False)
+
+    def test_entitlement(self):
+        """
+        This test verifies that QEMU modifies the polarization
+        after a guest request.
+
+        :avocado: tags=arch:s390x
+        :avocado: tags=machine:s390-ccw-virtio
+        """
+        self.kernel_init()
+        self.vm.add_args('-smp',
+                         '4,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
+        self.vm.launch()
+        self.wait_until_booted()
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
+        self.guest_set_dispatching('1');
+
+        self.check_topology(0, 0, 0, 0, 'low', False)
+        self.check_topology(1, 0, 0, 0, 'medium', False)
+        self.check_topology(2, 1, 0, 0, 'high', False)
+        self.check_topology(3, 1, 0, 0, 'high', False)
+
+        self.guest_set_dispatching('0');
+
+        self.check_topology(0, 0, 0, 0, 'low', False)
+        self.check_topology(1, 0, 0, 0, 'medium', False)
+        self.check_topology(2, 1, 0, 0, 'high', False)
+        self.check_topology(3, 1, 0, 0, 'high', False)
-- 
2.31.1

