Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A769492320
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbiARJwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230412AbiARJwW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:22 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8SQX5019749;
        Tue, 18 Jan 2022 09:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mUBB2Ac2xzg39AufNUJNvufVifUheWBgj3Sii365vs4=;
 b=fHr4db4HMihkr1gsFHeUET/Mw6uKqas22QBtoe2EyEjYC7JyrDL3Gxme9EfL8FI2dH9E
 NX9xQQdM2xuczU2yLjhkwfbxr4Va6trdYi8V2mTvst5OtbGOd/OT8ibI8ASFIcCAExnn
 kI8IBcyGx/KR+tYe9O0UGiTiT101LBuxe8qa1bnlMSF+wGNvscRJN3XnnivIwq+PijfF
 lbN/y3zfXkXHowsaklWsq+2e/Ozu8IEVoIKhJmleJphqpvVHiSMP/RUM3vvRn6YHvplz
 zp1xsWratgZJMTVdhV4ujzinminXNIDY6iqWSvF5+eNElNXnt75T+nHP/TO5RGT6Tchy sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f1gfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9ZlJP005247;
        Tue, 18 Jan 2022 09:52:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f1gf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9kxrV013295;
        Tue, 18 Jan 2022 09:52:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwa9he6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qF9t46072266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 379A0A4053;
        Tue, 18 Jan 2022 09:52:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9551A4059;
        Tue, 18 Jan 2022 09:52:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:14 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC PATCH v1 00/10] KVM: s390: Do storage key checking
Date:   Tue, 18 Jan 2022 10:52:00 +0100
Message-Id: <20220118095210.1651483-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jJ_T8otVUHyjaSHlMxx457Ff1fnaIoLy
X-Proofpoint-GUID: QA7z1TfJ1MRLNXuCsEbhN0T8anwN9Ien
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=873
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check keys when emulating instructions and let user space do key checked
accesses.
User space can do so via an extension of the MEMOP IOCTL:
* allow optional key checking
* allow MEMOP on vm fd, so key checked accesses on absolute memory
  become possible

TODO:
* Documentation changes for MEMOP
* Consider redesign of capability for MEMOP

Janis Schoetterl-Glausch (10):
  s390/uaccess: Add storage key checked access to user memory
  KVM: s390: Honor storage keys when accessing guest memory
  KVM: s390: handle_tprot: Honor storage keys
  KVM: s390: selftests: Test TEST PROTECTION emulation
  KVM: s390: Add optional storage key checking to MEMOP IOCTL
  KVM: s390: Add vm IOCTL for key checked guest absolute memory access
  KVM: s390: Rename existing vcpu memop functions
  KVM: s390: selftests: Test memops with storage keys
  KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
  KVM: s390: selftests: Make use of capability in MEM_OP test

 arch/s390/include/asm/ctl_reg.h           |   2 +
 arch/s390/include/asm/page.h              |   2 +
 arch/s390/include/asm/uaccess.h           |  32 ++
 arch/s390/kvm/gaccess.c                   | 237 ++++++++-
 arch/s390/kvm/gaccess.h                   |  85 +++-
 arch/s390/kvm/intercept.c                 |  12 +-
 arch/s390/kvm/kvm-s390.c                  | 122 ++++-
 arch/s390/kvm/priv.c                      |  66 +--
 arch/s390/lib/uaccess.c                   |  57 ++-
 include/uapi/linux/kvm.h                  |   4 +
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c | 560 +++++++++++++++++++---
 tools/testing/selftests/kvm/s390x/tprot.c | 184 +++++++
 14 files changed, 1207 insertions(+), 158 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c


base-commit: bad13799e0305deb258372b7298a86be4c78aaba
prerequisite-patch-id: 5f8ae41bde2fa5717a775e17c08239ed1ddbcc83
-- 
2.32.0

