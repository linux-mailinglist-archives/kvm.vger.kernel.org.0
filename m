Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49FE638A5E
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiKYMnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKYMnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:03 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE21AD82;
        Fri, 25 Nov 2022 04:43:01 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APBRNgC018753;
        Fri, 25 Nov 2022 12:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=hMrJCLxRNG0jiaX9N7pTPXY/37kSTvQDSsFgyPGtUXU=;
 b=pPdot0R/tBhHtjICiaOyWh6RiDN88z2nDJyOPoq58Tihc1OlsWQ92XDwxOVHdwqNKIIN
 HVgxBDwHVE0g/IzRwF715eBvMeVWVuYBqhfCwOb2mGBXhB8gB/6uoZdXjgiFyMUxHL36
 YdDV7hKNK9leRVrYnX1UmIxZhXRLbSpDu+yLAdUC4Nxpn6oe47r2B/+vFjM44jttDAMH
 Vj/EMgbO5lAnZvGUpiuZziGJ0U5y23aexMvSK9kv++v0ORJ9TEkOpsIFa8p+gUOWLYob
 6h16WTTdaZzNdn6siSFKm80wg8xIj/bj0gTOK5eCyCB5yQ9YQfNmKnEexOwlMUA1Chvg tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2vum1jus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APBlsOo027781;
        Fri, 25 Nov 2022 12:43:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2vum1ju0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZcHP016123;
        Fri, 25 Nov 2022 12:42:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps91jxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:42:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCgtOZ34472646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:42:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D416F4C044;
        Fri, 25 Nov 2022 12:42:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7175B4C04E;
        Fri, 25 Nov 2022 12:42:55 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 00/15] KVM: s390: Updates for 6.2
Date:   Fri, 25 Nov 2022 13:39:32 +0100
Message-Id: <20221125123947.31047-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sukBRkqv7d0-nY3NhL0cYmqJngvSyq6Y
X-Proofpoint-GUID: V22A4_DQ5pHXPFYcemVTOieFLXaKHowe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

please pull the following changes for 6.2:
- Second batch of the lazy destroy patches
- First batch of KVM changes for kernel virtual != physical address support
- Removal of a unused function

Notice:
There was a merge conflict in next with the kvm arm tree because of
capability numbers.

Please only pull the tag, there's a vfio-ap patch on top that
Christian needs for getting debug data only which shouldn't go
upstream.

The following changes since commit 247f34f7b80357943234f93f247a1ae6b6c3a740:

  Linux 6.1-rc2 (2022-10-23 15:27:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.2-1

for you to fetch changes up to 99b63f55dc514a357c2ecf25e9aab149879329f0:

  KVM: s390: remove unused gisa_clear_ipm_gisc() function (2022-11-23 09:06:50 +0000)

----------------------------------------------------------------

Claudio Imbrenda (6):
  KVM: s390: pv: asynchronous destroy for reboot
  KVM: s390: pv: api documentation for asynchronous destroy
  KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
  KVM: s390: pv: avoid export before import if possible
  KVM: s390: pv: support for Destroy fast UVC
  KVM: s390: pv: module parameter to fence asynchronous destroy

Heiko Carstens (1):
  KVM: s390: remove unused gisa_clear_ipm_gisc() function

Nico Boehr (8):
  s390/mm: gmap: sort out physical vs virtual pointers usage
  s390/entry: sort out physical vs virtual pointers usage in sie64a
  KVM: s390: sort out physical vs virtual pointers usage
  KVM: s390: sida: sort out physical vs virtual pointers usage
  KVM: s390: pv: sort out physical vs virtual pointers usage
  KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
  s390/mm: fix virtual-physical address confusion for swiotlb
  s390/vfio-ap: GISA: sort out physical vs virtual pointers usage

 Documentation/virt/kvm/api.rst      |  41 +++-
 arch/s390/include/asm/kvm_host.h    |  14 +-
 arch/s390/include/asm/mem_encrypt.h |   4 +-
 arch/s390/include/asm/stacktrace.h  |   1 +
 arch/s390/include/asm/uv.h          |  10 +
 arch/s390/kernel/asm-offsets.c      |   1 +
 arch/s390/kernel/entry.S            |  26 +-
 arch/s390/kernel/uv.c               |   7 +
 arch/s390/kvm/intercept.c           |   9 +-
 arch/s390/kvm/interrupt.c           |   5 -
 arch/s390/kvm/kvm-s390.c            | 111 ++++++---
 arch/s390/kvm/kvm-s390.h            |   8 +-
 arch/s390/kvm/priv.c                |   3 +-
 arch/s390/kvm/pv.c                  | 359 ++++++++++++++++++++++++++--
 arch/s390/kvm/vsie.c                |   4 +-
 arch/s390/mm/gmap.c                 | 147 ++++++------
 arch/s390/mm/init.c                 |  12 +-
 drivers/s390/crypto/vfio_ap_ops.c   |   2 +-
 include/uapi/linux/kvm.h            |   3 +
 19 files changed, 604 insertions(+), 163 deletions(-)

-- 
2.38.1

