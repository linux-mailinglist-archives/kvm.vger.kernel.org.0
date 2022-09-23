Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389CD5E7A36
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiIWMKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiIWMIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 08:08:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BB18B3E;
        Fri, 23 Sep 2022 05:04:39 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NBcKV4009282;
        Fri, 23 Sep 2022 12:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=cMQsJdyHoIadexI0enjCs7e7g+XMk0AFDRQak/aforc=;
 b=fz+pJyVluDMesZAoKmGPpwhBdb+3t/JQXg2nk0Fv408z2ck+JZuKec2xUD1mI49hT8Ew
 ZwWUCAdiVf67BZSO15EwfB75e9Ckz1qbCs68aAcGpRrwWh99GQd7RkWzn4wtOL1/Fc2T
 yYjkRsJKo7xDSyT1tM/TTK2A5nXgMaz5Au3AJmU2rifwmz/JYFA9igMKGL7yn/6nqC4B
 erxCtaLz5xELgZ032vwKBO22Al03IDhuFsTLvHJrYBYmSFpUPcCQ21EVGRIkMMtszsUK
 /U05t8WORKlDbv4FxXPDkKtXsksqN3qG+h7pRmyUO1lOtcKxtgyEXed5iF28qULFEXRZ Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsa67bxng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:38 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NBgGLs026501;
        Fri, 23 Sep 2022 12:04:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsa67bxme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NBpvW2025569;
        Fri, 23 Sep 2022 12:04:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3jn5v8nwhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NC4WWl14549396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:04:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B403AE053;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14015AE045;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.171.28.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/4] KVM: s390: Fixes for 6.0 take 2
Date:   Fri, 23 Sep 2022 14:04:08 +0200
Message-Id: <20220923120412.15294-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m3kXJyrkLONkSIA0crx7crZPNn9rtW92
X-Proofpoint-ORIG-GUID: mXvgXl-3u3q0Kf8YYqhJR7jS7JdQ-Rs_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=772
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

vfio-pci has kept us busy for a bit so here are three additional pci fixes.
Additionally there's a smatch fix by Janis.

It might be a bit late for rc7 but we wanted to have the coverage.
Enjoy the weekend!

The following changes since commit 521a547ced6477c54b4b0cc206000406c221b4d6:

  Linux 6.0-rc6 (2022-09-18 13:44:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.0-2

for you to fetch changes up to 189e7d876e48d7c791fe1c9c01516f70f5621a9f:

  KVM: s390: pci: register pci hooks without interpretation (2022-09-21 16:18:38 +0200)

----------------------------------------------------------------
More pci fixes
Fix for a code analyser warning
----------------------------------------------------------------

Janis Schoetterl-Glausch (1):
  KVM: s390: Pass initialized arg even if unused

Matthew Rosato (3):
  KVM: s390: pci: fix plain integer as NULL pointer warnings
  KVM: s390: pci: fix GAIT physical vs virtual pointers usage
  KVM: s390: pci: register pci hooks without interpretation

 arch/s390/kvm/gaccess.c   | 16 +++++++++++++---
 arch/s390/kvm/interrupt.c |  2 +-
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 arch/s390/kvm/pci.c       | 20 ++++++++++++++------
 arch/s390/kvm/pci.h       |  6 +++---
 5 files changed, 33 insertions(+), 15 deletions(-)

-- 
2.37.3

