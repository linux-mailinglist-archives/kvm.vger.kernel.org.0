Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E7250B5B1
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446939AbiDVK6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446761AbiDVK5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:57:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2208DFD1;
        Fri, 22 Apr 2022 03:55:02 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M7bAY0016499;
        Fri, 22 Apr 2022 10:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I0oy/s/LZhoJnhbLzpmA54HgUDSW0x98y/8k/6mPwYM=;
 b=dr61SoViwoijjWncv7rSrj6koKgPbQAtLaoiuQI67eEU4fDoizkVPp2GxGBNOB88URYu
 kZD2UtMBNCeB7WCcT/5oNC5bcQzvO61I9V83G+G+k8TFyToeiGdsvvvTUKp/u/R8NPrG
 a4zRVvrXGbOWk1iMbp5zr/Ah2wbSo5vByvOHZxaeJAbc+x22Lyhgn0PtapPVQlg1lRcW
 BhVcLJEiV7QZR+jfJZNg1zGxS+d5+wil0mMviF2KVRAKfVA9TJpI+WQT0eEdZg0BgK5T
 gmrYXcTkbBgUDRIOM05Dbkw+PP99yi04QDjLQ71HZL80oCE2S09R81/W3aVfvhtBCY5Q cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jnq1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:02 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MAhLYS022296;
        Fri, 22 Apr 2022 10:55:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jnq15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MArAq4020645;
        Fri, 22 Apr 2022 10:54:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8s7tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:54:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MAg4CQ29950308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 10:42:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DC76AE059;
        Fri, 22 Apr 2022 10:54:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DD1DAE05D;
        Fri, 22 Apr 2022 10:54:55 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 10:54:55 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 2/4] s390x: add support for migration tests
Date:   Fri, 22 Apr 2022 12:54:51 +0200
Message-Id: <20220422105453.2153299-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220422105453.2153299-1-nrb@linux.ibm.com>
References: <20220422105453.2153299-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e0l_4UF3P1hlWSnu6Iucv0PkvCbMQrL5
X-Proofpoint-ORIG-GUID: 45gWGjg5qFFHxPrh2OC-bMWJrckrm8AX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have SCLP console read support, run our tests with migration_cmd, so
we can get migration support on s390x.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/run b/s390x/run
index 064ecd1b337a..2bcdabbaa14f 100755
--- a/s390x/run
+++ b/s390x/run
@@ -25,7 +25,7 @@ M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
-command="$(timeout_cmd) $command"
+command="$(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
 run_qemu_status $command "$@"
-- 
2.31.1

