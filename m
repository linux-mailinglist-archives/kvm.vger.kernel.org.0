Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5886275F02A
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjGXJu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjGXJta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7163211E;
        Mon, 24 Jul 2023 02:47:48 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9diEo003160;
        Mon, 24 Jul 2023 09:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=zGEo4gpofWgFbCX750DuEL36KciT6htVbhnnpCfFGmE=;
 b=AKE3fahVjp1jfONyTxYSl+6nSY2iheVKg1RjoCSSF9i9i3sHq20cj9AAxkd0UoaRI2FU
 fMw6Cud/C2bqIqTgSzgXGh1fBLI1gXBeHKBjZE0J3vpvB9DrLjcTrJdu5+nF12Ulz3Ug
 3QpVM3+DB4jpu7swWtN5v8GHxw/M+N3G+EorG3Bud7cakq4PkQhjCMivPlRera+pyGC0
 RlSrCXMRWSTh+JVi73eKWOpS2hwAgXeMkkR+SFKiKYqLDVnkoY3ZBrLcvnOtEurJTQat
 S/IDWsZfgLWcomud1J0T+/qsAjEtTfrVJp63ziHvrqH/jUn5mahINmmv5otac8vO/5SZ 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1k3un6de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:26 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9dmw7003445;
        Mon, 24 Jul 2023 09:47:25 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1k3un6cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:25 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O879io014373;
        Mon, 24 Jul 2023 09:47:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxj9n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lJDu38404452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE40220043;
        Mon, 24 Jul 2023 09:47:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B85A20040;
        Mon, 24 Jul 2023 09:47:19 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:19 +0000 (GMT)
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
Subject: [PATCH v3 0/6] KVM: s390: interrupt: Fix stepping into interrupt handlers
Date:   Mon, 24 Jul 2023 11:44:06 +0200
Message-ID: <20230724094716.91510-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qvaVxnpdYAcjeTf5fr_fADhkq3YNBm9L
X-Proofpoint-GUID: GurYVXf9XghTDBlcawC9TjCau1YDO_3R
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=852 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 arch/s390/kvm/intercept.c                     |  40 ++++-
 arch/s390/kvm/interrupt.c                     |  14 ++
 arch/s390/kvm/kvm-s390.c                      |  27 ++-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/s390x/debug_test.c  | 160 ++++++++++++++++++
 5 files changed, 230 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

-- 
2.41.0

