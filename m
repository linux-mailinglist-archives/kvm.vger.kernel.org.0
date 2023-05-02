Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939BE6F44BC
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbjEBNKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjEBNJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:09:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4944C2B;
        Tue,  2 May 2023 06:09:46 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8uSW019525;
        Tue, 2 May 2023 13:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=e/kpUV/nb2d4/sqLJ0FfcM6Fj3qyHpPENr86u6AfUwY=;
 b=h7IB2wyLtfZf93UTEB3VHGK/wjZKkGhavcSAyf5/ks74SqSHdjlXWeILHx9UllB4Qs5/
 4v/vNiZxG1icgATRJuX2GAMxRPkppuXB+ECWdw7Fo9Ty65GNNa2zMbc+WZMdzn5gftDR
 3Jcys/NYgtHk4aRS6136tvY/swuH//sWWJ05S4dloDJEGtxij8fxCiHtVCbzjb0jvg9V
 TXlOFCmM6rjPdIFqzuVODGWiYZQSg3d8zFyaWDEzaKp5C4pyES6z+NVONeapa1IFbGqU
 gpICp+GSVwluHxM3tp2oH8nAG9+TBNopHdKggduCACjA42PsX1opT20ju9Aqx+M2JoG2 LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8c3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:45 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D9YXH025933;
        Tue, 2 May 2023 13:09:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8bp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342437Kr027740;
        Tue, 2 May 2023 13:09:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6skjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9R3N4194920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 717192004E;
        Tue,  2 May 2023 13:09:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988C820049;
        Tue,  2 May 2023 13:09:26 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 9/9] s390x: uv-host: Add the test to unittests.conf
Date:   Tue,  2 May 2023 13:07:32 +0000
Message-Id: <20230502130732.147210-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7MHxtIJaFA9k1YaWtTysHJ_L1oDYU2xF
X-Proofpoint-ORIG-GUID: NKz8KoBgYu2CsikhX3utmnuP4iYRJ7FZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Better to skip than to not run it at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/unittests.cfg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d6e7b170..3bba03ce 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -231,3 +231,8 @@ extra_params = -m 2200
 [pv-diags]
 file = pv-diags.elf
 extra_params = -m 2200
+
+[uv-host]
+file = uv-host.elf
+smp = 2
+extra_params = -m 2200
-- 
2.34.1

