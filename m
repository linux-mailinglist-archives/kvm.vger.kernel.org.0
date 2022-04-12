Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A49F4FDC9B
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344379AbiDLKgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381003AbiDLK0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:26:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B790E54BD1;
        Tue, 12 Apr 2022 02:29:48 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C8BrgY012804;
        Tue, 12 Apr 2022 09:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=n0N8LxyFzTgRl4eQsM8PZ39uWTWdh0NanMX95mTnDPE=;
 b=TFxs5u1w1pobIWd/T1oHTqNK6fXJvFsah5uBKdE5XMWAc2/FMHW+vs5QSZVh/75fUe9A
 VSmUjsofSGfANm/U81XsCPHWPOd9QYtcZnXJMTWCtaiTGeAT2XLMkySIdhwdmixIq3Av
 QTOMxN2ZmGOogJAlDvahO93GiCDx8lUM8fz5/Y7XSQ/r89UrlxBK94N53du7H75ULlsz
 ETrP8QW9JeZFzFV2MXBk0y61dd+cqlR8U0tDs//6VdOwC6p9vAznbUR0sPp10UjPvCKH
 ErhViuibH4IkgiRfhDGHlT9hgoKi8jsPQPTUZvwZ9fZsMIsQkZg/jTKudj+IGsxupQK2 tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd5puhkup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:48 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23C99u5S003084;
        Tue, 12 Apr 2022 09:29:47 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd5puhku4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:47 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23C9BmZ3020039;
        Tue, 12 Apr 2022 09:29:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8unv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23C9TgMT38928866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 09:29:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07593AE045;
        Tue, 12 Apr 2022 09:29:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8250AE04D;
        Tue, 12 Apr 2022 09:29:41 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 09:29:41 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/3] s390x: epsw: fix report_pop_prefix() when running under non-QEMU
Date:   Tue, 12 Apr 2022 11:29:40 +0200
Message-Id: <20220412092941.20742-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GI1b6Mzn6PW_BdQ0kp1KvIP5ZzEyQDpX
X-Proofpoint-GUID: 3861WgmHBG1xtGVo7Lk_hC_qJZ7wyVuA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-12_02,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we don't run in QEMU, we didn't push a prefix, hence pop won't work. Fix
this by pushing the prefix before the QEMU check.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/epsw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/epsw.c b/s390x/epsw.c
index 5b73f4b3db6c..d8090d95a486 100644
--- a/s390x/epsw.c
+++ b/s390x/epsw.c
@@ -97,13 +97,13 @@ static void test_epsw(void)
 
 int main(int argc, char **argv)
 {
+	report_prefix_push("epsw");
+
 	if (!host_is_kvm() && !host_is_tcg()) {
 		report_skip("Not running under QEMU");
 		goto done;
 	}
 
-	report_prefix_push("epsw");
-
 	test_epsw();
 
 done:
-- 
2.31.1

