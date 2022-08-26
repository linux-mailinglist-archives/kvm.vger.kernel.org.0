Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35595A238D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiHZIt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 04:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245161AbiHZItw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 04:49:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3A5C1C
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 01:49:51 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q7qnlw028637
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=bfXspsdKD4ZHZwcjk9pnph9GNDE5b8zYHA5nvXdQlYM=;
 b=kPtVUaWndhbzuVUl4b2P7NjIa2IV93MI+I9hTSxW56ezvKPZ4PJhvMp24OUN1bzyILTl
 qmFPEnDii5wMyS7Hg6M8hTu/QjuHmee3Su62ryD8C4ANQfC0IIXTVK/zDxZ1eP+l+4F8
 Unx1dEsiblPQj+qdjCfL9ScdHVFXH5OQoaxAUpJKVyfeVVdAZNeENhFHh3SxTt8F+T53
 o9OGrOSe6zdKGO1nPIGyYahk+OaYf0LMDh04k1Ihvi5VI0L8j6fvnDFSdeikG80QLkej
 6cmZAkkos2jxnzimu6Rypcf4T2IwFt9XhNTN5g1c/gfmC+Ak2uGBXHXwKO1Ca/LHt0FH Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6t62hsxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27Q8ZZUK011855
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:49 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6t62hsx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:49 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27Q8bS7O028419;
        Fri, 26 Aug 2022 08:49:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88wg4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27Q8nirV38535606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 08:49:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABE82AE053;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F067AE045;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: Add migration test for guest TOD clock
Date:   Fri, 26 Aug 2022 10:49:42 +0200
Message-Id: <20220826084944.19466-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yihnwQHk2h_7nJDbATgV84URs4YlTLD9
X-Proofpoint-ORIG-GUID: FBJ5R0kh97lRYQ1mG1M_H12dMLXvPHX7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=811 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest TOD clock should be preserved on migration. Add a test to
verify that.

To reduce code duplication, move some of the time-related defined
from the sck test to the library.

Nico Boehr (2):
  lib/s390x: move TOD clock related functions to library
  s390x: add migration TOD clock test

 lib/s390x/asm/time.h  | 48 +++++++++++++++++++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/migration-sck.c | 45 ++++++++++++++++++++++++++++++++++++++++
 s390x/sck.c           | 32 -----------------------------
 s390x/unittests.cfg   |  4 ++++
 5 files changed, 98 insertions(+), 32 deletions(-)
 create mode 100644 s390x/migration-sck.c

-- 
2.36.1

