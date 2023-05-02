Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE166F4363
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbjEBMKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbjEBMKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:10:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BE6558E;
        Tue,  2 May 2023 05:10:12 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342CA0cX002452;
        Tue, 2 May 2023 12:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7j7soiS82/jhgiE5I7uOTm0ya5Yp+7Wjlod0EWUQD14=;
 b=E99Zf5wUqWVt9Hmifhc+xwXlMoiHUJxHlWdDopQHsC/cm5bLTBULshSIOMjggHHs+X1Z
 TuIVZ5nF/LTscanvNI0m7uKVaHrVmdB4tB6flzlW8MjUa2jnTHLA0PXLKp7qo3L1K2IE
 q60Rji6wkP/djPSQJAi5+hS46i/z56C2H5+IyY2d6n+0EF2gToUZyeEd7aL1e0CfOLG5
 CU2YuFyHxdfpmlUpIpccOOgp54HWnLlTrNnTLXxiOuCXFh4XL+UaFmHmBPM00qH+xlZL
 bjKMVCQNTvx3GrQkZjYBkaGmsjYSDkin9mYb4/qQbOuRgzi36h4KccONehhimfkLypmB vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb0rejm9v-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:10:11 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342C1iNw016688;
        Tue, 2 May 2023 12:01:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb0rejjbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:01:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427i7Mo009764;
        Tue, 2 May 2023 12:00:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6s9n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:00:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342C0nTN30146968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:00:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5919B20043;
        Tue,  2 May 2023 12:00:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F86520040;
        Tue,  2 May 2023 12:00:48 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:00:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v4 7/7] s390x: pv-diags: Add the test to unittests.conf
Date:   Tue,  2 May 2023 11:59:31 +0000
Message-Id: <20230502115931.86280-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502115931.86280-1-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sC8haL6NPFEZn52lGwgxslb1PNc7SnBf
X-Proofpoint-ORIG-GUID: dAKk3nM02aGbSfCTQH60BELewLuMn2jJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020103
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

