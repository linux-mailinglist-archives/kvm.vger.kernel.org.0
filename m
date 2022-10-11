Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956DD5FB6EB
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 17:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiJKPYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 11:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJKPYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 11:24:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3528DFB5E
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:15:38 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEiNbW022192
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=P5nylIES3uKqte11Q3ZvFjn6oFnhNeXlyY++KktZrms=;
 b=hDzu6p7C4JS12CKFkntBD715pIH8/T4KyC9VZhT0FzfLpyjc/0VjSvzZ0Uyrf5rluzyW
 Mx+Gr7hzpswWV4/FxpUGqC6uEOCAew/aEvt5q5uJRGodw138fGND0XWcS9rbl43ON5uc
 u7jGo+sfv/VDF+2kniut2prmd6kJh3QhMMX4MNXqRb/1idRkqNdZ//eAV5fzAif1f6i1
 woS4HmqMfwNp+8omNZhH39AsjGprCkTS3H1JU8U41c99ZYgEVZv/iPcZKeqSZVBTBAvN
 Iviab4R7y9zhmJuC09u4VQzcdAqwtd7ZTKwu7Aly1LRkAz0oxeYTf1gGl+Y5rWvobJoL uA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5a6f27n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:39 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BF553i031667
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3k30fj3g5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFEYgZ787020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:14:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F156742042;
        Tue, 11 Oct 2022 15:14:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B23394203F;
        Tue, 11 Oct 2022 15:14:33 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 15:14:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: Add migration test for guest TOD clock
Date:   Tue, 11 Oct 2022 17:14:31 +0200
Message-Id: <20221011151433.886294-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mko67opqLS3Fp6HzWqB__Q_qcg6pr7aD
X-Proofpoint-GUID: mko67opqLS3Fp6HzWqB__Q_qcg6pr7aD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=873
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
- remove unneeded include
- advance clock by 10 minutes instead of 1 minute (thanks Claudio)
- express get_clock_us() using stck() (thanks Claudio)

The guest TOD clock should be preserved on migration. Add a test to
verify that.

To reduce code duplication, move some of the time-related defined
from the sck test to the library.

Nico Boehr (2):
  lib/s390x: move TOD clock related functions to library
  s390x: add migration TOD clock test

 lib/s390x/asm/time.h  | 50 ++++++++++++++++++++++++++++++++++++++++++-
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 44 +++++++++++++++++++++++++++++++++++++
 s390x/sck.c           | 32 ---------------------------
 s390x/unittests.cfg   |  4 ++++
 5 files changed, 98 insertions(+), 33 deletions(-)
 create mode 100644 s390x/migration-sck.c

-- 
2.36.1

