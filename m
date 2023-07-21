Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BA675C64B
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjGUMBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 08:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjGUMBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 08:01:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797AD173A;
        Fri, 21 Jul 2023 05:00:54 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LBxr97017074;
        Fri, 21 Jul 2023 12:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=gsIU3wzB6H61e4ZbMr6hliyimv7s9bENv09BfB2Cp7Y=;
 b=m3CNdptWCR6tGMPLIMkgErCikCKLFd1r8tuqeNGjxSI/voSO08P4JGCFnsO3dDQXsM2Z
 fIuLHu2NyT/bpdgQtWVkS1uRj3XR5N8cgLAMvZnohDwuW0miq/aQ2Qs0yA7OUTYdOHQj
 AP6exAhxhoSqQaegvi+B28JetnmzcY2mt5kftdCLW6876jhAJ6BNJVdudAp1pHeAfll5
 jXiG2xt3IiilD5Re8tdJ4MJjSUSv2TP6CrNw9walAlav+uFAt/71AoavXh5GjGbrPkHc
 3RS2AtnYY/QwfpdAT/J7irt1PkjjAWR70XAKH+Luge1hiialJ8fqqdj0CkWJLOrqGPre cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rymrbp4vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:53 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36LBitqs029563;
        Fri, 21 Jul 2023 12:00:52 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rymrbp4va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:52 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36LBGHCc004149;
        Fri, 21 Jul 2023 12:00:51 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv8g1f071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36LC0mK710945266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 12:00:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56D7F2005A;
        Fri, 21 Jul 2023 12:00:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 186E52004B;
        Fri, 21 Jul 2023 12:00:48 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jul 2023 12:00:48 +0000 (GMT)
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
Subject: [PATCH v2 0/6] KVM: s390: interrupt: Fix stepping into interrupt handlers
Date:   Fri, 21 Jul 2023 13:57:53 +0200
Message-ID: <20230721120046.2262291-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xo5bvhqGNseRF3vmVm3fjsvX9tR7pdD6
X-Proofpoint-GUID: BUMH8fXY8IRHnGWQIRFGNgtDhjnCAzI9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=963 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1: https://lore.kernel.org/lkml/20230629083452.183274-1-iii@linux.ibm.com/
v1 -> v2: Fix three more issues.
          Add selftests (Claudio).

Hi,

I tried to compare the behavior of KVM and TCG by diffing instruction
traces, and found five issues in KVM related to stepping into interrupt
handlers.

I'm not very familiar with the KVM code base, so please let me know if
the fixes can be improved or if these problems need to be handled
completely differently.

Best regards,
Ilya

Ilya Leoshkevich (6):
  KVM: s390: interrupt: Fix single-stepping into interrupt handlers
  KVM: s390: interrupt: Fix single-stepping into program interrupt
    handlers
  KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
  KVM: s390: interrupt: Fix single-stepping userspace-emulated
    instructions
  KVM: s390: interrupt: Fix single-stepping ISKE
  KVM: s390: selftests: Add selftest for single-stepping

 arch/s390/kvm/intercept.c                     |  39 ++++-
 arch/s390/kvm/interrupt.c                     |  10 ++
 arch/s390/kvm/kvm-s390.c                      |  20 ++-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/s390x/debug_test.c  | 160 ++++++++++++++++++
 5 files changed, 218 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

-- 
2.41.0

