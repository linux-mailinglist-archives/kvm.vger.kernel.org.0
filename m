Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBB56EA960
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbjDULjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjDULjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:39:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27570D309;
        Fri, 21 Apr 2023 04:38:28 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LBXPmS023567;
        Fri, 21 Apr 2023 11:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7j7soiS82/jhgiE5I7uOTm0ya5Yp+7Wjlod0EWUQD14=;
 b=MYGzl3cn0Dese4wzLz1shFZuTnaaVtfRZRKxAIJNxn/ZCQmLIreoVxPFg6Q58JWqY/xf
 kscG3CnBnkYOwKXjawn/fyQn7DDBV4KGPGjKJ6Xwl/1ZPOqNHrt4eUcQQIxij/wHj4S3
 AaN7Ao87YXY2fAi2kLGdfaNwf6ubRkCZSccPIDHdCEEtMVb5m8Lp0Us5jG+PrPUBVmyK
 8wsgBEbOIDqp0xr3D/T+NzN+/ufNDb871w/vYL/utKdy2iR9DIAVcRQRFwvKN+ZuF4Cr
 TWGBn2NGA1nvLwuPlvVlyAd9R3yYmhtfW5Ms244cpRIQiKD6blPHXTtvF6dAWv7mR7z/ Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrtjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:29 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LBYhmi003180;
        Fri, 21 Apr 2023 11:37:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrth2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L2bWu1024426;
        Fri, 21 Apr 2023 11:37:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6m10u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LBbNRO36045110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 11:37:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC8E420043;
        Fri, 21 Apr 2023 11:37:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4D9F20040;
        Fri, 21 Apr 2023 11:37:22 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 11:37:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/7] s390x: pv-diags: Add the test to unittests.conf
Date:   Fri, 21 Apr 2023 11:36:47 +0000
Message-Id: <20230421113647.134536-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421113647.134536-1-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3_uHCgkxz-Q8AH3IjZkT09nyI0ad-Q86
X-Proofpoint-ORIG-GUID: RLvpspeWlgQ5M4p3RyXbz0kRQ7m7E3Oe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_04,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Better to have it run into a skip than to not run it at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/unittests.cfg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index e08e5c84..d6e7b170 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -227,3 +227,7 @@ extra_params = -m 2200
 [pv-ipl]
 file = pv-ipl.elf
 extra_params = -m 2200
+
+[pv-diags]
+file = pv-diags.elf
+extra_params = -m 2200
-- 
2.34.1

