Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620BE54D2BC
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349070AbiFOUeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346792AbiFOUda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:33:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE69D3191C;
        Wed, 15 Jun 2022 13:33:28 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FKHXQM028305;
        Wed, 15 Jun 2022 20:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=OK3SMhL7kItwW0xAP8fySSjRRWt6T0CykUhFGZAJkSc=;
 b=DGkk18Ov8ftKU6ehTRvRFu+Mg/RbGBkNz6qXeZwf0CcqY5P2ZV9uN9SqsMG2MeerXrd9
 2EOOTLqG6yy8GUhVwMgiIiVucl8idZ+Fb+P6qzHNaoC0WSIdBupJXmA5pQYhrh8sSHjn
 DlK8Ri4PTkCOByZb6z5ipH/9EHgwNh4KRfYO4oxp43xpET4eKuq//D+/sewTKCu0mdhc
 46uD+macLRx9izf8LENdEifrltvZeSnJ2XLx2uyNozMgW9u3FTk/gBmkinCEP3f4kgYL
 XbVBY1EzIo5ySFhpA5icWDToVOYEku3SAdZXIl9K0W/GQZE6uh5kuHHwcc/8KYTA/LxX qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppbsbecc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:25 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25FKIGAJ029223;
        Wed, 15 Jun 2022 20:33:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppbsbebk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FKKE21014777;
        Wed, 15 Jun 2022 20:33:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3gmjp94w52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FKXKpT15073620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 20:33:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44B8D42041;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31D8342042;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 05994E001B; Wed, 15 Jun 2022 22:33:20 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v2 00/10] s390/vfio-ccw rework
Date:   Wed, 15 Jun 2022 22:33:08 +0200
Message-Id: <20220615203318.3830778-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rWSZqbvxCQu_me46_eYLqknwSkmba_jP
X-Proofpoint-ORIG-GUID: JDbNutMgLLYXotigA6oumb4_PIMEJc9t
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_16,2022-06-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=769
 priorityscore=1501 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206150074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Last autumn, Jason Gunthorpe proposed some rework of vfio-ccw [1],
to better fit with the new mdev API (thank you!). Part of that
series was pulled for kernel 5.16 [2], but the complexities of
the remaining patches got them hung up behind other work.

I dusted off that work a couple weeks ago (see v1), but am going
to split that further with the goal of this part to clean up the
existing device lifecycle and FSM used by vfio-ccw. The remaining
work runs into conflicts with other work (notably [2]), so I'd
like to propose this first group without that hangup. This makes
the behavior/usage of the FSM state a lot more consistent than
it is today.

This is all internal to vfio-ccw, with the exception of removal
of mdev_uuid from include/linux/mdev.h in patch 1.
@Kirti, I can drop that hunk if that's a concern for you.

One potential conflict still exists on patch 6, with [3].

v1->v2:
 - Rebased to v5.19-rc2
   - Patch 1: Remove mdev.h from vfio_ccw_fsm.c
   - Patch 4: Earlier patches removed meaningful users of private->mdev,
     leaving this as a very simple cleanup
 - [JG,MR] Added r-b's (Thank You!)
 - [MR] Patch 1: Update commit message
 - [MR] Patch 2: Add comment regarding interrupt types changing FSM state
 - [MR] Patch 5: Drop Fixes tag
 - [JG] Drop patch for clearing drvdata on mdev remove
 - [EF] Defer items to later series
   - The "if !private" patch, and JG's associated comment on patch 7;
     entire process requires further investigation
   - The vfio-mdev rework patches (to [2])
   - The "tie vfio_ccw_private to mdev lifecycle" patches
v1: https://lore.kernel.org/r/20220602171948.2790690-1-farman@linux.ibm.com/

Footnotes:
[1] https://lore.kernel.org/r/0-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
[2] https://lore.kernel.org/r/20220603063328.3715-1-hch@lst.de/
[3] https://lore.kernel.org/r/165471414407.203056.474032786990662279.stgit@omen/

Cc: Kirti Wankhede <kwankhede@nvidia.com>

Eric Farman (9):
  vfio/ccw: Fix FSM state if mdev probe fails
  vfio/ccw: Do not change FSM state in subchannel event
  vfio/ccw: Remove private->mdev
  vfio/ccw: Pass enum to FSM event jumptable
  vfio/ccw: Flatten MDEV device (un)register
  vfio/ccw: Create an OPEN FSM Event
  vfio/ccw: Create a CLOSE FSM event
  vfio/ccw: Refactor vfio_ccw_mdev_reset
  vfio/ccw: Move FSM open/close to MDEV open/close

Michael Kawano (1):
  vfio/ccw: Remove UUID from s390 debug log

 drivers/s390/cio/vfio_ccw_async.c   |  1 -
 drivers/s390/cio/vfio_ccw_drv.c     | 59 ++++++-------------
 drivers/s390/cio/vfio_ccw_fsm.c     | 89 ++++++++++++++++++++++++-----
 drivers/s390/cio/vfio_ccw_ops.c     | 77 ++++++++-----------------
 drivers/s390/cio/vfio_ccw_private.h |  9 +--
 include/linux/mdev.h                |  5 --
 6 files changed, 117 insertions(+), 123 deletions(-)

-- 
2.32.0

