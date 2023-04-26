Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63C76EF5C7
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbjDZNsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbjDZNss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 09:48:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CC8659F;
        Wed, 26 Apr 2023 06:48:44 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QD6bwm007418;
        Wed, 26 Apr 2023 13:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a1ETQXiiN8wd0j/u+pUzE5byCXMPM28zg7FIaJx6GuY=;
 b=g18HyCREJjiDpU3YKwrNQ62WJJFVJ/pZm+8KBwE40qBZv+tl4OiMerBFl2E12cs+xMAb
 LF0TpWlxIre3/x6SDfGciq6Pi9r3v+E3RWXmiYvhysybkQmd4rX+SAlkd2p3gnbx+5+F
 j57dx5GtlIhCvLkNQa4Y0Xn6/nXoqbrRCFpdqeEe9OqS6KvQz4VKlxENLkSekTKZLdMA
 fjfp7vNKqwubMUtdR1sHu+PAULC+Rs4xOO/+tKKyiS5JrkW8CBLbwO6M0m7OfbjvORMz
 hVBMFY3GxAzAo0k38pHLGALcr2id00Zj79Gl1mbgYcxMwzqlVw2vguaO4PKjV2OJt07L Nw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73vwavpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 13:48:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCUHJ8017653;
        Wed, 26 Apr 2023 13:48:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug2cth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 13:48:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QDmYmZ44499618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 13:48:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C55C20043;
        Wed, 26 Apr 2023 13:48:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC4320040;
        Wed, 26 Apr 2023 13:48:34 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 13:48:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, jgg@nvidia.com
Subject: [PATCH v2 0/1] fix race in gmap_make_secure
Date:   Wed, 26 Apr 2023 15:48:33 +0200
Message-Id: <20230426134834.35199-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zqIEc1bqt70avOTdwjFSRCOUKcA02gbf
X-Proofpoint-GUID: zqIEc1bqt70avOTdwjFSRCOUKcA02gbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_06,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 suspectscore=0 mlxlogscore=490 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a potential race and, most importantly, removes the last
user of follow_page without FOLL_GET.

This removes the last user of follow_page without FOLL_GET. Once this
patch is merged I'll send a separate patch to perform FOLL_GET
automatically with follow_page, as suggested by Jason Gunthorpe.

Claudio Imbrenda (1):
  KVM: s390: fix race in gmap_make_secure

 arch/s390/kernel/uv.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

-- 
2.40.0

