Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A1761BFC
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjGYOjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 10:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbjGYOjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 10:39:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDFA1999;
        Tue, 25 Jul 2023 07:39:17 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PE8EMO023252;
        Tue, 25 Jul 2023 14:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=wu3B0hpZD/zo6Hxv6q5CzIkc7w68SW69q6uSI+uwjHQ=;
 b=IOtdaDbznB6oSz3/XE3h5w0X338v/ZfPQE+g+ubjsfVeAlbsUJKPveKheMEwKCLq9ZpX
 Hc85nFQ2S065ctrIVV36QhBQq8ra2G1ff4rqMeg+2mtuFp2t7OqTI35nEsJk5i8YNGHr
 WRMhoTgqmBwohuC+BQZait3ku6zzGWURcCGVCBM3JBGDAZNDwsMev8NZCq2p9C34kfpA
 XKLsfYNbRobn6S8zcS+OFIhv6LPXvEK8bQcH6g9Yj7uT83x4lQLGi7nbIdBcidjCnsvy
 AH3q+40daWSx8x10f6EYejbBnR0CVnxy1hJTowQxsII5QW2OKN/HPFqNfmp6WcPcXYjB 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2942ch7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:16 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PE8nCM027253;
        Tue, 25 Jul 2023 14:39:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2942cgsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:13 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEF0Ca001872;
        Tue, 25 Jul 2023 14:39:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unjcb5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PEd0LH59900386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 14:39:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896B82004E;
        Tue, 25 Jul 2023 14:39:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 529B02004B;
        Tue, 25 Jul 2023 14:39:00 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 14:39:00 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 0/6] KVM: s390: interrupt: Fix stepping into interrupt handlers
Date:   Tue, 25 Jul 2023 16:37:15 +0200
Message-ID: <20230725143857.228626-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7C6GiDpNvidE8ZGQM6E6D548frGwKcnx
X-Proofpoint-GUID: GrZXOqHWfQPyNrsjmOl2dINRIpGEh5Pg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxlogscore=916 clxscore=1015 impostorscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3: https://lore.kernel.org/kvm/20230724094716.91510-1-iii@linux.ibm.com/
v3 -> v4: Restore the per_event() macro (Claudio).

v2: https://lore.kernel.org/lkml/20230721120046.2262291-1-iii@linux.ibm.com/
v2 -> v3: Add comments, improve the commit messages (Christian, David).
          Add R-bs.
          Patches that need review: [4/6], [6/6].

v1: https://lore.kernel.org/lkml/20230629083452.183274-1-iii@linux.ibm.com/
v1 -> v2: Fix three more issues.
          Add selftests (Claudio).

Hi,

I tried to compare the behavior of KVM and TCG by diffing instruction
traces, and found five issues in KVM related to stepping into interrupt
handlers.

Best regards,
Ilya

Ilya Leoshkevich (6):
  KVM: s390: interrupt: Fix single-stepping into interrupt handlers
  KVM: s390: interrupt: Fix single-stepping into program interrupt
    handlers
  KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
  KVM: s390: interrupt: Fix single-stepping userspace-emulated
    instructions
  KVM: s390: interrupt: Fix single-stepping keyless mode exits
  KVM: s390: selftests: Add selftest for single-stepping

 arch/s390/kvm/intercept.c                     |  38 ++++-
 arch/s390/kvm/interrupt.c                     |  14 ++
 arch/s390/kvm/kvm-s390.c                      |  27 ++-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/s390x/debug_test.c  | 160 ++++++++++++++++++
 5 files changed, 229 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

-- 
2.41.0

