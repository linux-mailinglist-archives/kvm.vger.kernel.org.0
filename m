Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F09A2D5D89
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390037AbgLJO04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:26:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389933AbgLJO0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:26:55 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAE5KIH137723;
        Thu, 10 Dec 2020 09:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=sIct3ma9V/iBuzV7f52S+uJZk5QhKcVNkka4/nB3NiE=;
 b=KLe6ScgXAJRVqgLDgW823ONUE2on6KVoQWLmrzUmejIfnb4PbBO5DQRWC3qdcDWqOt2W
 GM08Adg/FHWwgmTctAWbPdefA4pm13tMD01uDaVZYv2Fy6f33jMOQz4iRRbA2NRer/Dl
 kIv1UlQJ8YWzsNw1DoAXjpF6hr33hXWQXUyV2vSa/mGkLx/Rx2jCsGHrWTnVSPA9AhkP
 dIsB362RMsN9/tgNjYjRRg62dOpTwZS9ZcQkB1CCRkloDBxPjcuqnw17fkSN0OwA+RxC
 1c5cOLdU6bu4DJ8lgOB8+bI6zJxUlDzOBikf8RCuwrXuoZFoa8EjRllW/DMOpjE9AlYE 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bknv3r1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAENb7b040835;
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bknv3r0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:06 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEHVjZ011706;
        Thu, 10 Dec 2020 14:26:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u85vkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:26:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEQ1W557803092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:26:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC45C52075;
        Thu, 10 Dec 2020 14:26:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CAB635207B;
        Thu, 10 Dec 2020 14:26:00 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 898ADE0450; Thu, 10 Dec 2020 15:26:00 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 0/4] KVM: s390: features and test for 5.11
Date:   Thu, 10 Dec 2020 15:25:55 +0100
Message-Id: <20201210142600.6771-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_05:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=940 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

the following changes since commit f8394f232b1eab649ce2df5c5f15b0e528c92091:

  Linux 5.10-rc3 (2020-11-08 16:10:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.11-1

for you to fetch changes up to 50a05be484cb70d9dfb55fa5a6ed57eab193901f:

  KVM: s390: track synchronous pfault events in kvm_stat (2020-12-10 14:20:26 +0100)

----------------------------------------------------------------
KVM: s390: Features and Test for 5.11

- memcg accouting for s390 specific parts of kvm and gmap
- selftest for diag318
- new kvm_stat for when async_pf falls back to sync

The selftest even triggers a non-critical bug that is unrelated
to diag318, fix will follow later.

----------------------------------------------------------------
Christian Borntraeger (3):
      KVM: s390: Add memcg accounting to KVM allocations
      s390/gmap: make gmap memcg aware
      KVM: s390: track synchronous pfault events in kvm_stat

Collin Walling (1):
      KVM: selftests: sync_regs test for diag318

 arch/s390/include/asm/kvm_host.h                   |  1 +
 arch/s390/kvm/guestdbg.c                           |  8 +--
 arch/s390/kvm/intercept.c                          |  2 +-
 arch/s390/kvm/interrupt.c                          | 10 +--
 arch/s390/kvm/kvm-s390.c                           | 22 +++---
 arch/s390/kvm/priv.c                               |  4 +-
 arch/s390/kvm/pv.c                                 |  6 +-
 arch/s390/kvm/vsie.c                               |  4 +-
 arch/s390/mm/gmap.c                                | 30 ++++----
 tools/testing/selftests/kvm/Makefile               |  2 +-
 .../kvm/include/s390x/diag318_test_handler.h       | 13 ++++
 .../selftests/kvm/lib/s390x/diag318_test_handler.c | 82 ++++++++++++++++++++++
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 16 ++++-
 13 files changed, 156 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
