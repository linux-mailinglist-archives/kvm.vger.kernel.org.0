Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1046440E08
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJaMNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229798AbhJaMNm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VBmbCP012237;
        Sun, 31 Oct 2021 12:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=5Jinu7Hot+ooSK+KB8REF/4a5RPkFJlnwz2O5Nqj8wE=;
 b=FJCLB7VNdhCQB4pPOXpxT/zRvsA7xTDGXEM+dO0uNHntqdWw7kH2vAeodP9QHA9VdjD/
 vgY7sRgPSFlBi3jFfzzbD2pu8+03ddXfaCZmLBsOzg3FC6dnoqOCDhGB7iK8WXo5GNEo
 Lgz6dnLdmUGmm59as4XaKH5rpkIK2yL4ycSj4K/+xEillhG/NWJ0yQx51eAJiW4zjkR9
 5RI0Hwik3ZzALLaY/D1PHPxzGTSuA1tJPb3EhOe9nx+mrwRxPdJLSSuDB2BxCwq7gcTc
 ug6prYny0MfeaQ+AY1dNHwg45K4rZYOnfwyIUcJMih599JWl72TaSlAU3awPT8CNubN4 qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c1tkj890c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:10 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VC1eaM015196;
        Sun, 31 Oct 2021 12:11:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c1tkj88yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8uNX023602;
        Sun, 31 Oct 2021 12:11:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c0wahw9h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB5x763373600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EB564C046;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C0FA4C044;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9F194E056B; Sun, 31 Oct 2021 13:11:04 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 00/17] KVM: s390: Fixes and Features for 5.16
Date:   Sun, 31 Oct 2021 13:10:47 +0100
Message-Id: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -2i2aUBmfhQFWakUJvRgtlR0e22jKrfT
X-Proofpoint-GUID: hQdgjFB_AsKk3-XdsGf78Hg0cpqxw5hI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

sorry for late pull request, I was moving...
This is on top of kvm-s390-master-5.15-2 but for next.
FWIW, it seems that you have not pulled kvm-s390-master-5.15-2 yet, so
depending on 5.15-rc8 or not the fixes can also go via this pull
request.

The following changes since commit 0e9ff65f455dfd0a8aea5e7843678ab6fe097e21:

  KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu (2021-10-20 13:03:04 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.16-1

for you to fetch changes up to 3fd8417f2c728d810a3b26d7e2008012ffb7fd01:

  KVM: s390: add debug statement for diag 318 CPNC data (2021-10-27 07:55:53 +0200)

----------------------------------------------------------------
KVM: s390: Fixes and Features for 5.16

- SIGP Fixes
- initial preparations for lazy destroy of secure VMs
- storage key improvements/fixes
- Log the guest CPNC

----------------------------------------------------------------
Claudio Imbrenda (5):
      KVM: s390: pv: add macros for UVC CC values
      KVM: s390: pv: avoid double free of sida page
      KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
      KVM: s390: pv: avoid stalls when making pages secure
      KVM: s390: pv: properly handle page flags for protected guests

Collin Walling (1):
      KVM: s390: add debug statement for diag 318 CPNC data

David Hildenbrand (8):
      s390/gmap: validate VMA in __gmap_zap()
      s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()
      s390/mm: validate VMA in PGSTE manipulation functions
      s390/mm: fix VMA and page table handling code in storage key handling functions
      s390/uv: fully validate the VMA before calling follow_page()
      s390/mm: no need for pte_alloc_map_lock() if we know the pmd is present
      s390/mm: optimize set_guest_storage_key()
      s390/mm: optimize reset_guest_reference_bit()

Eric Farman (2):
      KVM: s390: Simplify SIGP Set Arch handling
      KVM: s390: Add a routine for setting userspace CPU state

Janis Schoetterl-Glausch (1):
      KVM: s390: Fix handle_sske page fault handling

 arch/s390/include/asm/pgtable.h |   9 ++--
 arch/s390/include/asm/uv.h      |  15 +++++-
 arch/s390/kernel/uv.c           |  65 +++++++++++++++++++++---
 arch/s390/kvm/intercept.c       |   5 ++
 arch/s390/kvm/kvm-s390.c        |   7 +--
 arch/s390/kvm/kvm-s390.h        |   9 ++++
 arch/s390/kvm/priv.c            |   2 +
 arch/s390/kvm/pv.c              |  21 ++++----
 arch/s390/kvm/sigp.c            |  14 +-----
 arch/s390/mm/gmap.c             |  15 ++++--
 arch/s390/mm/pgtable.c          | 109 ++++++++++++++++++++++++++++------------
 11 files changed, 196 insertions(+), 75 deletions(-)
