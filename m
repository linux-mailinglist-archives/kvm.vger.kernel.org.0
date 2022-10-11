Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1005E5FB8C1
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJKRAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJKRAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:00:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D94AE5D
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:00:34 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BG42Bm016306
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zXVE7MaAmIg3Fz1aEdPf7KnCuI9IgFX1ycqBkhbMf4s=;
 b=N6eosLkMPmxsX/FTv7s9CfPwCPTdiQ6OI9GTBoBfxEbi6ANdsxv1ULv3VFztwO3YvwxE
 cD+J+ONAs1s8NfEMcPOd/vi6Mv1g8w/PHdtfVJiwWUxtzuMffcJ08s/YEqXEyIrNhHjh
 okGuXqelli1ZkJtFKy5SDnKW7oA9mFoIKaZ8pcDuIfGVPvtrOV+OaABIWhiN5A2yp++R
 X9yGjwCIyWZkjT1Qcc7RALutw0UcbffuyZP2obvUW607fMNC1UizLV78XsGp+VYsXpxj
 uBdAyLz06dCpgprG7vz/Qlabyc+WBQwu4S3zWxRALBHT1hIrF0cZC0rUfI/kzaKGFUOy pQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k590dg6bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BGptFZ027515
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3k30u93kd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:00:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BGtf0e50659808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:55:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19435AE051;
        Tue, 11 Oct 2022 17:00:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D29E5AE053;
        Tue, 11 Oct 2022 17:00:24 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 17:00:24 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: Add migration test for guest TOD clock
Date:   Tue, 11 Oct 2022 19:00:22 +0200
Message-Id: <20221011170024.972135-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vi9UZteyio1CHHSsQknV9BUEFL-wlQPf
X-Proofpoint-ORIG-GUID: Vi9UZteyio1CHHSsQknV9BUEFL-wlQPf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=968
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
---
- check the clock is really set after setting (thanks Claudio)
- remove unneeded memory clobber (thanks Claudio)
- add comment to explain what we're testing (thanks Christian)

v1->v2:
---
- remove unneeded include
- advance clock by 10 minutes instead of 1 minute (thanks Claudio)
- express get_clock_us() using stck() (thanks Claudio)

The guest TOD clock should not go backwards on migration. Add a test to
verify that.

To reduce code duplication, move some of the time-related defined
from the sck test to the library.

Nico Boehr (2):
  lib/s390x: move TOD clock related functions to library
  s390x: add migration TOD clock test

 lib/s390x/asm/time.h  | 50 ++++++++++++++++++++++++++++++++++++++-
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 s390x/sck.c           | 32 -------------------------
 s390x/unittests.cfg   |  4 ++++
 5 files changed, 108 insertions(+), 33 deletions(-)
 create mode 100644 s390x/migration-sck.c

-- 
2.36.1

