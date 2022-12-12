Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D658649D6A
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiLLLS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiLLLSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:18:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C18CE3
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:17:41 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC9into029061;
        Mon, 12 Dec 2022 11:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Kgwtmtfw4hu/4UjAsR1ar1ZP0vAbM/FhOpsiRG+z3xo=;
 b=FE1oBGah2xgl6HSCJR63lblTdBmTZeoZaXT7nxlZoccusGjA8Ckl/OTUTB6d908Wi7JL
 ATFqp58tJBSCi4Sd/QJvXtcE4PlKFZz7Z9YqtWakQnyDxmN616+U221lotnJncQwG29D
 SvLCVOasvEmJqGXDiA+PJ9CrGR+HlziwQKp+E/5qEDr898T6rsuTnodEZYijz1bKFfbD
 pZ1cpoc5mn2pL8BL8QY1e/11Ou61/JU2HAOrSyydzpR2aUoXS8Y+4mn/v3otkPUGrIli
 xL+75XAdjcpAVkMxNDO+GNhBD2PtSVzgiOIIRx4OL6IZZoPFjM1//iVlRsgk+vfwgzyK dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3me1xkj4h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCBDpJO000781;
        Mon, 12 Dec 2022 11:17:38 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3me1xkj4gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2BCB9YH8020894;
        Mon, 12 Dec 2022 11:17:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3mchr61tc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCBHWg239190958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 11:17:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3338C2004B;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 011692004D;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 11:17:31 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/4] lib: add function to request migration
Date:   Mon, 12 Dec 2022 12:17:27 +0100
Message-Id: <20221212111731.292942-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iP5cV8fWp5hos9VVMQi5awmlt23ymWT1
X-Proofpoint-GUID: GQfM-imqgSTVh9BqQybWkrB1r44pQ4Br
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=730 mlxscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120102
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
* s390x: remove unneeded parenthesis (thanks Claudio)

v1->v2:
---
* arm: commit message gib->gic (thanks Andrew)
* arm: remove unneeded {} (thanks Andrew)
* s390x: make patch less intrusive (thanks Claudio)

With this series, I pick up a suggestion Claudio has brought up in my
CMM-migration series[1].

Migration tests can ask migrate_cmd to migrate them to a new QEMU
process. Requesting migration and waiting for completion is hence a
common pattern which is repeated all over the code base. Add a function
which does all of that to avoid repetition.

Since migrate_cmd currently can only migrate exactly once, this function
is called migrate_once() and is a no-op when it has been called before.
This can simplify the control flow, especially when tests are skipped.

[1] https://lore.kernel.org/kvm/20221125154646.5974cb52@p-imbrenda/

Nico Boehr (4):
  lib: add function to request migration
  powerpc: use migrate_once() in migration tests
  s390x: use migrate_once() in migration tests
  arm: use migrate_once() in migration tests

 arm/Makefile.common     |  1 +
 powerpc/Makefile.common |  1 +
 s390x/Makefile          |  1 +
 lib/migrate.h           |  9 ++++++++
 lib/migrate.c           | 34 ++++++++++++++++++++++++++++
 arm/debug.c             | 17 +++++---------
 arm/gic.c               | 49 ++++++++++++-----------------------------
 powerpc/sprs.c          |  4 ++--
 s390x/migration-cmm.c   | 24 ++++++--------------
 s390x/migration-sck.c   |  4 ++--
 s390x/migration-skey.c  | 20 ++++++-----------
 s390x/migration.c       |  7 ++----
 12 files changed, 85 insertions(+), 86 deletions(-)
 create mode 100644 lib/migrate.h
 create mode 100644 lib/migrate.c

-- 
2.36.1

