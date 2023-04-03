Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595716D4DC6
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjDCQaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjDCQaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:30:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49DA1FD3
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333Fs05b022959;
        Mon, 3 Apr 2023 16:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AgSYXTt+E9RmNHxszdN84g1wny/caJf8aGUhdF8ciFU=;
 b=LYyp87IvROVJJgEAG0IvjP2RSYmfgIzER30xcbw7RATR2tzotkSLHliTI7CqNmlO+R5Q
 q30qDcu3dtHBuPn3TEsw7mhrbYYvF39Zg8/WnJlhJpNcnMJNRZf7cOy1eTpt0rFUhECR
 fW9vHIRmgf9sfKrEGW8sZ7JBkfKJfHjuXSlu5+1XKmVkUds8er/IR95MeyVtFwLzep+g
 XV2zeVheDMRbfrECw5yv5HuSxlhN4tJp5DGy5QYVofX2/7pL0LETC2kC6ETE+K2aZJNG
 L773avlSqfb1eKFArdjNwmhfIcK6fK9Y7ncJ/QJxZLS2cpVg5owEuswKJ6PT/rKpWlR+ uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1uhgwsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:47 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333Ftl6H027789;
        Mon, 3 Apr 2023 16:29:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr1uhgws5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3332rOj4004436;
        Mon, 3 Apr 2023 16:29:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86sddj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:44 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTfln46334462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A3DF20040;
        Mon,  3 Apr 2023 16:29:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E672004B;
        Mon,  3 Apr 2023 16:29:40 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:40 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 20/21] tests/avocado: s390x cpu topology bad move
Date:   Mon,  3 Apr 2023 18:29:04 +0200
Message-Id: <20230403162905.17703-21-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5-nGmm4JuRke5HbMDKjKbRE0Iza60Gvv
X-Proofpoint-ORIG-GUID: n2uSvhIR6saPG_e8WjhYcMB64k9U35-K
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

This test verifies that QEMU refuses to move a CPU to an
unexistant location.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 tests/avocado/s390_topology.py | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
index 02c6a8cbe8..665876affe 100644
--- a/tests/avocado/s390_topology.py
+++ b/tests/avocado/s390_topology.py
@@ -408,3 +408,28 @@ def test_dedicated_error(self):
         res = self.vm.qmp('set-cpu-topology',
                           {'core-id': 0, 'entitlement': 'medium', 'dedicated': False})
         self.assertEqual(res['return'], {})
+
+    def test_move_error(self):
+        """
+        This test verifies that QEMU refuses to move a CPU to an
+        unexistant location
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
+        res = self.vm.qmp('set-cpu-topology', {'core-id': 0, 'drawer-id': 1})
+        self.assertEqual(res['error']['class'], 'GenericError')
+
+        res = self.vm.qmp('set-cpu-topology', {'core-id': 0, 'book-id': 1})
+        self.assertEqual(res['error']['class'], 'GenericError')
+
+        res = self.vm.qmp('set-cpu-topology', {'core-id': 0, 'socket-id': 1})
+        self.assertEqual(res['error']['class'], 'GenericError')
+
+        self.check_topology(0, 0, 0, 0, 'medium', False)
-- 
2.31.1

