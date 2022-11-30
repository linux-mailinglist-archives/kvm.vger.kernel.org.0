Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797FD63D99A
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiK3Pkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 10:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiK3Pkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 10:40:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6492982A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 07:40:45 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUFZ862018696
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6XrRs4n1gRu2OILvBgOkx9EORUxKIjjI1yA+3yP1T5w=;
 b=fSl2x0bGdfz/IEDrNFnLvIPR1Ptbyj1ZnpJnkIDgb13qJ5YE5tEkDicQoQ+8e4uUO5Tu
 M81akX2VDf6g/257ULPs3fvJlf5xWjfO9TXvWNCV9Q27fg8qaFKcG4CWvi77lv5YKV1H
 htGT3jSa2LU/gCTgXu6f4V2BLt8dYZ1354tdY9wOgw20DefVGxIFHiT/vwfdTAhd4orx
 tLQjrMvYVDM1w7MJI902Z5VZoB+01D6zgkb9koc1w2ySYN6ARE29XR4BgfBbFLloWsIG
 dyRLHrNCtA0HCSUAqAANOdD4JT+FO8l1ZdhxTt94yzqHI0zVZ5PLDWLKvpcwC4MyKHgo +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69xs83my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUFZpdE020809
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:40:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m69xs83m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUFZlDI019849;
        Wed, 30 Nov 2022 15:40:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae94ccq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 15:40:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUFfLpf8979160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 15:41:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE0752052;
        Wed, 30 Nov 2022 15:40:38 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9A27652050;
        Wed, 30 Nov 2022 15:40:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
Date:   Wed, 30 Nov 2022 16:40:36 +0100
Message-Id: <20221130154038.70492-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UZfXLrn7G2oE-cr4qmevK-eIKwYXdDc6
X-Proofpoint-GUID: bXhCuaxwjDx4x3mnDLhCeJuot1NyfnLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=846 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since a lot of code starts new CPUs using the current PSW mask, add two
macros to streamline the creation of generic PSWs and PSWs with the
current program mask.

Update the existing code to use the newly introduced macros.


v2->v3
* rename PSW_CUR_MASK to PSW_WITH_CUR_MASK

Claudio Imbrenda (2):
  lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
  s390x: use the new PSW and PSW_WITH_CUR_MASK macros

 lib/s390x/asm/arch_def.h |  4 +++
 s390x/adtl-status.c      | 24 +++---------------
 s390x/firq.c             |  5 +---
 s390x/migration.c        |  6 +----
 s390x/skrf.c             |  7 +-----
 s390x/smp.c              | 53 +++++++++-------------------------------
 s390x/uv-host.c          |  5 +---
 7 files changed, 23 insertions(+), 81 deletions(-)

-- 
2.38.1

