Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931CA47B29F
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbhLTSLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:11:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233340AbhLTSLM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 13:11:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKG8RYJ005888;
        Mon, 20 Dec 2021 18:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=0dBIE2T/ZUmIbGqS8NCfzLF1CrXGI36LccET0x3dqzI=;
 b=jBe+j5LEKEFSVcbH5axFh4Mf8x4DrNZ3pb1efJULTnrEsqRRofnxfSC4TaNRfH68xgSO
 uX70kcyayhL0jxpU7lJKfK9JNV86eHfKraRFPhF0P7L4yX14MxIRofAMGbttGKGxja86
 MA+fBAJHE/IthG/ho7UUFvcM4zMRiiJ3uvEW1l5D6N3wQhVhYslMuFEZWydOZUPzOvfa
 sf6m/kGG6WNlqAGKLCZbWeOMXFgFGPSRUnvLQ8VNT47GNpp0mvAUGxSr57+tbqrDzx0A
 +/h09gxKcStZh1cf1Zkg5yWGpn5+CPIj5yMzGfDDBBAppaCXVjhuUXeh8uUvNxtvn53C qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d1s0pagrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKI8HHx011033;
        Mon, 20 Dec 2021 18:11:10 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d1s0pagqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI3QAs024544;
        Mon, 20 Dec 2021 18:11:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3d17996bh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKI2stu48497058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 18:02:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B215204F;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5F27C5204E;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 194D1E63A4; Mon, 20 Dec 2021 19:11:05 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 0/6] KVM: s390: Fix and cleanup for 5.17
Date:   Mon, 20 Dec 2021 19:10:58 +0100
Message-Id: <20211220181104.595009-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3wmg73tWF7s2kzMRxjSD5YJDO0HBf8iG
X-Proofpoint-ORIG-GUID: UWCOiqTjAIi6hMqstsOWaAGlIuMiIuQd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

the first set of patches for 5.17, mostly cleanups but also one fix. I
will let this go in via next instead of master as we probably have less
non-CI testing during the holidays and it is not security-related.

The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.17-1

for you to fetch changes up to 812de04661c4daa7ac385c0dfd62594540538034:

  KVM: s390: Clarify SIGP orders versus STOP/RESTART (2021-12-17 14:52:47 +0100)

----------------------------------------------------------------
KVM: s390: Fix and cleanup

- fix sigp sense/start/stop/inconsistency
- cleanups

----------------------------------------------------------------
Eric Farman (1):
      KVM: s390: Clarify SIGP orders versus STOP/RESTART

Janis Schoetterl-Glausch (4):
      KVM: s390: Fix names of skey constants in api documentation
      KVM: s390: gaccess: Refactor gpa and length calculation
      KVM: s390: gaccess: Refactor access address range check
      KVM: s390: gaccess: Cleanup access to guest pages

Janosch Frank (1):
      s390: uv: Add offset comments to UV query struct and fix naming

 Documentation/virt/kvm/api.rst |   6 +-
 arch/s390/include/asm/uv.h     |  34 ++++-----
 arch/s390/kvm/gaccess.c        | 158 ++++++++++++++++++++++++-----------------
 arch/s390/kvm/interrupt.c      |   7 ++
 arch/s390/kvm/kvm-s390.c       |   9 ++-
 arch/s390/kvm/kvm-s390.h       |   1 +
 arch/s390/kvm/sigp.c           |  28 ++++++++
 7 files changed, 155 insertions(+), 88 deletions(-)
