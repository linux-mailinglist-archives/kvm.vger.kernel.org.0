Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6654A743822
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjF3JUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjF3JT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:19:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E963A90
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 02:18:55 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35U9HTkR029829;
        Fri, 30 Jun 2023 09:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EA67TRFd2GWuXpPn7bro4u5y2JZI0PD/QDHDqDDRHP8=;
 b=on2q7hMN0Y8Cbx8LwrIZW6MNndkVRhUIIm+1EVE2RofkLfhWBophLNCWAZQNpOhNOUE7
 iMyO++m9RN5nFbPH28mA3EWiZQgGShyePRamOAFLtUjWcBZ7jn2cxkAXwkVb5sweebY/
 h7RIwPshnIUEythPW3R7oyyCP2NI3B6NTSTUY3mnm8u8JQxZZUxujG7x17nnAr2SpWwH
 WjMbXH4g35xqbRVb+1cm0+4yNRy1OJYi3Eiu6w9CVuM2APHiPXvTT7wlHOMq85iy4rc1
 fR9H1USKHLCPXjQyL379oCSv22ZJZt/IWp4h0TYqlPb+t94n+mIbue698U8J+BcWkh7a lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv9jr0v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:27 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35U9IQX9032757;
        Fri, 30 Jun 2023 09:18:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhv9jr0uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U4FHlo008362;
        Fri, 30 Jun 2023 09:18:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4542dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 09:18:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35U9IIZw59572616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 09:18:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3FE520043;
        Fri, 30 Jun 2023 09:18:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 889E920040;
        Fri, 30 Jun 2023 09:18:17 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.38.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 09:18:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v21 17/20] tests/avocado: s390x cpu topology test dedicated CPU
Date:   Fri, 30 Jun 2023 11:17:49 +0200
Message-Id: <20230630091752.67190-18-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K5bDIsFvjfIw5yvIULUgs779NQzkky_r
X-Proofpoint-GUID: a6yxaMCpo01wdePg7B_UK-XBzJF9fueh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

A dedicated CPU in vertical polarization can only have
a high entitlement.
Let's check this.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index 4855e5d7e4..cba44bec91 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -287,3 +287,31 @@ def test_entitlement(self):
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
+        self.wait_until_booted()
+
+        self.system_init()
+
+        res = self.vm.qmp('set-cpu-topology',
+                          {'core-id': 0, 'dedicated': True})
+        self.assertEqual(res['return'], {})
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
+
+        self.guest_set_dispatching('1');
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
+
+        self.guest_set_dispatching('0');
+
+        self.check_topology(0, 0, 0, 0, 'high', True)
-- 
2.31.1

