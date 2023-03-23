Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB176C6574
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCWKnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCWKnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799DE3B225
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:26 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N9oLfC026383
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rtCY4I7SvwV7gwcvS8+/0eSIAaukeb5hvVetA2z2dNY=;
 b=ikZUr/PdOga2DRy7jhRv+YdXSfqcv9sDkD0h5ftIS7/XTyRLtgwrbUlkB2hkM8SoBO2Q
 HMEunxjOwyALl2Q5i/EbOZ22PLKb0WLjyj24WYABdmLtw3Am3QjkTaEsG0ITk1Tq4XfR
 MquV6C6YTNnJA1vxDKIuugBwBZ32JeuEjV7A2ZDsaS0eJY0yrzZDFU82H0AEe/UruhFO
 ykj1PINFcy5AmVvYTwcQ63VmdaIzw+mQ+rCQWTvzueUe35kUXxVwu9/FmHm/SBAmQ230
 QtIiNSe2rx8toI2rpwsNS0sGRrN1DenHh6T97V79onAtPWI3em8VZXTiJbjURaUfswc6 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6h5yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32N9raG6004021
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:22 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmg6h5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MIGfeC018062;
        Thu, 23 Mar 2023 10:40:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3pd4jfe2ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:20 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeGSb14680708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FF332004F;
        Thu, 23 Mar 2023 10:40:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0416B20071;
        Thu, 23 Mar 2023 10:40:16 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/8] s390x: Add PV tests to unittests.cfg
Date:   Thu, 23 Mar 2023 10:39:08 +0000
Message-Id: <20230323103913.40720-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6lHl3TdI6l9ccEEbVWjbhZgobazLVQIJ
X-Proofpoint-ORIG-GUID: 5t4zCydDde8VCsK7Q3DbEr9EApYd7sTc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=809 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even if the first thing those tests do is skipping they should still
be run to make sure the tests boots and the skipping works.
---
 s390x/unittests.cfg | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 96977f2b..c9d341ea 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -222,3 +222,19 @@ file = migration-cmm.elf
 groups = migration
 smp = 2
 extra_params = -append '--parallel'
+
+[pv-diags]
+file = pv-diags.elf
+extra_params = -m 2200
+
+[pv-icptcode]
+file = pv-icptcode.elf
+extra_params = -m 2200 -smp 3
+
+[pv-ipl]
+file = pv-ipl.elf
+extra_params = -m 2200
+
+[uv-host]
+file = uv-host.elf
+extra_params = -m 2200 -smp 2
-- 
2.34.1

