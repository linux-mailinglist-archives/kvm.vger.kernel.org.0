Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7788273899E
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjFUPhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbjFUPhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:37:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB84A19B4;
        Wed, 21 Jun 2023 08:36:56 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFKKVM011023;
        Wed, 21 Jun 2023 15:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=G7MEZMdUUsCqQek+MW4ro0zJnjqhW7Db6W7qNyBmTbw=;
 b=J3xeg6CW5nBAJGBZ8uy7+kxAUjBoeixCEIyHV4Ol7ThxyVV2ObyZ66mjThdcxA7vD2s3
 gXkjqK7vKCWfrOpeJSA5aCxfciPVVaYvRpF4+HqJ8jYEqu6ODGHqfVCygVSnkWvENGaW
 ahx7Ms/DsflJzlWAoxDej2Q6AJKYKm0dtqwc5TokQJK/pd+nZjvYk4o68suGohCmxJEt
 Ypks94BjYvrNsb9iqYnnEJ0yj07bj2Brm9KGmj+5UMMlTQ7F/K7nUNbu7dqtZ+Rz6fdZ
 uC6EEbuCNDn2mt9tlV8jAcRrgetQbmnkLF9ej9x3CuCye5/eSBkkwWgJ/llaBQzpwc4l tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3rjgcy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:36:12 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFLigo014588;
        Wed, 21 Jun 2023 15:36:10 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3rjgcdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:36:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L5r23W023736;
        Wed, 21 Jun 2023 15:34:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r943e25fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYFpO21365318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FF8A20043;
        Wed, 21 Jun 2023 15:34:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 288E520040;
        Wed, 21 Jun 2023 15:34:15 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 00/11] kvm: s390: Changes for 6.5
Date:   Wed, 21 Jun 2023 17:29:06 +0200
Message-ID: <20230621153227.57250-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7panbRaGIXS6FVjRZeNt9QnbsKd7dQ4L
X-Proofpoint-ORIG-GUID: CrtzZ-Qe0qk3iQ4ei_e5PnBdBZgaSjPc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=798
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

here are the patches for 6.5 (or later):
~80% of the code is a new CMM selftest by Nico.
~19% of the code is Steffen's additions to the uvdevice introducing the UV secret API.
The rest are a couple of fixes that we picked up along the way.

I plan to remove the ifdefs and the PROTECTED_VIRTUALIZATION_GUEST
config in the (near) future so we won't run into the linking problems
that plagued the uvdevice patches anymore.


Please pull:
The following changes since commit f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6:

  Linux 6.4-rc2 (2023-05-14 12:51:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.5-1

for you to fetch changes up to db54dfc9f71cd2df7afd1e88535ef6099cb0333e:

  s390/uv: Update query for secret-UVCs (2023-06-16 11:08:09 +0200)

----------------------------------------------------------------
* New uvdevice secret API
* New CMM selftest
* cmm fix
* diag 9c racy access of target cpu fix
* VSIE AP control block fix
----------------------------------------------------------------


Christian Borntraeger (1):
  KVM: s390/diag: fix racy access of physical cpu number in diag 9c
    handler

Nico Boehr (2):
  KVM: s390: fix KVM_S390_GET_CMMA_BITS for GFNs in memslot holes
  KVM: s390: selftests: add selftest for CMMA migration

Pierre Morel (1):
  KVM: s390: vsie: fix the length of APCB bitmap

Steffen Eiden (7):
  s390/uv: Always export uv_info
  s390/uvdevice: Add info IOCTL
  s390/uvdevice: Add 'Add Secret' UVC
  s390/uvdevice: Add 'List Secrets' UVC
  s390/uvdevice: Add 'Lock Secret Store' UVC
  s390/uv: replace scnprintf with sysfs_emit
  s390/uv: Update query for secret-UVCs

 arch/s390/boot/uv.c                           |   4 +
 arch/s390/include/asm/uv.h                    |  32 +-
 arch/s390/include/uapi/asm/uvdevice.h         |  53 +-
 arch/s390/kernel/uv.c                         | 108 ++-
 arch/s390/kvm/diag.c                          |   8 +-
 arch/s390/kvm/kvm-s390.c                      |   4 +
 arch/s390/kvm/vsie.c                          |   6 +-
 drivers/s390/char/Kconfig                     |   2 +-
 drivers/s390/char/uvdevice.c                  | 231 +++++-
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/s390x/cmma_test.c | 700 ++++++++++++++++++
 11 files changed, 1100 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/cmma_test.c

-- 
2.41.0

