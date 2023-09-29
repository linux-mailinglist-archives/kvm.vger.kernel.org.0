Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E847B375D
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 17:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjI2P5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 11:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjI2P5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 11:57:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F289C;
        Fri, 29 Sep 2023 08:57:13 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38TFU3f0030078;
        Fri, 29 Sep 2023 15:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=6h0z+yZiGisXyM6BbilRr/lxHaZQS0rY0ZmTHsvZq0k=;
 b=BUyX7l0wOOutfVysPM6uASq99hk/rbjpUl3EkH8ZgmAvdrVUUMSr0ujB7Y+Jtw2V1hjP
 CLPtAXMvJS8nsBrbu2ZLoMcufMCR97C6bYGh0cgqGX+UeImz9JSTiGVYKyj29SIQBP8I
 1ZMxs8Za+Sd0Bd6rZ3qFHlJLwKDX4MLdz3idSl0/awZ8735CwkI53MJh1UjMVFbSB1s2
 r4KFQ3+MgIA/buH/X1TKkGmJfU3Qb6iDfNukMSKhoi+mfHTSRxYGBvd1llIC6EuCq9cv
 z9M9Z8/OER0pKXcV+n73SWgGFwds7aAjkjLJUmjYKvWA8PkAfwPFZkauCGFHcL+SWEE+ DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tdyu3c5qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:12 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38TFZfTD025113;
        Fri, 29 Sep 2023 15:57:11 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tdyu3c5q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:11 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38TF8kI6008192;
        Fri, 29 Sep 2023 15:57:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tabbnwr3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38TFv6ZO13435560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 15:57:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 922BE2004E;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DC422004B;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [GIT PULL 0/1] KVM: s390: gisa: one fix for 6.6
Date:   Fri, 29 Sep 2023 17:57:05 +0200
Message-ID: <20230929155706.81033-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w0P25m4yOARKGxBvKXR28KOMOByZK_bI
X-Proofpoint-GUID: jzI4hlGS9EmHOGJ__8Z89_zlBFfIEzLI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_13,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=508 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309290134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

a small fix for gisa, please pull :)


Claudio

The following changes since commit 6465e260f48790807eef06b583b38ca9789b6072:

  Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.6-1

for you to fetch changes up to f87ef5723536a6545ed9c43e18b13a9faceb3c80:

  KVM: s390: fix gisa destroy operation might lead to cpu stalls (2023-09-25 08:31:47 +0200)

----------------------------------------------------------------
One small fix for gisa to avoid stalls.

----------------------------------------------------------------

Michael Mueller (1):
  KVM: s390: fix gisa destroy operation might lead to cpu stalls

 arch/s390/kvm/interrupt.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

-- 
2.41.0

