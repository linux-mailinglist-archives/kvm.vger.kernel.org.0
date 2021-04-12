Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C120135CABA
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243217AbhDLQGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240732AbhDLQGK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG4SUt096045;
        Mon, 12 Apr 2021 12:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=GV4FlGfQXJpJ7BggiAQ7ShtsLJvuaLMzOPcWEaPWkVc=;
 b=tp4rbRMddBJiMMFqpm9oV8l+ZJwrE74nrULhr5tzJ36VxCkL3n2EvIyiC6ZoHqlIFmor
 8NandfbQz4ByVW8v6LztEvRz1NbCXDHfnDvGt2EVx/NyRKSi7vwKrfNsXw2DKwUNuxjp
 ERAqUhHbj3rdDDXC5gsVEeybkRldMql0TkgQa9VMd3fQqKqWxSqY6Ty6pwdcERLAh/cu
 MSi+GtrI3Lzjwd3d80R6jZCRvIG59JBpjb/MbT5L9sYQyySGeD3ywhZF3NShQrrVd4UI
 X+ivWwPYziIfG7R/L+QgMTXTQyh9k3zI1eu/nqi1gz6ITLC3+uTlFxQHvPjdG2e6BsHY iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG5NcT103142;
        Mon, 12 Apr 2021 12:05:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFqCdI029750;
        Mon, 12 Apr 2021 16:05:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n89y1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5kZc30867920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 276F511C050;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15AB911C054;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C9AC1E02A6; Mon, 12 Apr 2021 18:05:45 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/7] KVM: s390: Updates for 5.13
Date:   Mon, 12 Apr 2021 18:05:38 +0200
Message-Id: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KV8HIJTj25eAiOhQqv-vqhYhU6rXRScC
X-Proofpoint-ORIG-GUID: dSMjm8eYpxk2xS6lPYu4Iud-hIwW5V5h
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

only small things for 5.13, one is a fix (with cc stable) consisting of
multiple patches. I had it running in next for a while since this is
a pretty complicated area of the architecture but its now good to go.

The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.13-1

for you to fetch changes up to c3171e94cc1cdcc3229565244112e869f052b8d9:

  KVM: s390: VSIE: fix MVPG handling for prefixing and MSO (2021-03-24 10:31:55 +0100)

----------------------------------------------------------------
KVM: s390: Updates for 5.13

- properly handle MVPG in nesting KVM (vsie)
- allow to forward the yield_to hypercall (diagnose 9c)
- fixes

----------------------------------------------------------------
Bhaskar Chowdhury (1):
      KVM: s390: Fix comment spelling in kvm_s390_vcpu_start()

Claudio Imbrenda (5):
      KVM: s390: split kvm_s390_logical_to_effective
      KVM: s390: extend kvm_s390_shadow_fault to return entry pointer
      KVM: s390: VSIE: correctly handle MVPG when in VSIE
      KVM: s390: split kvm_s390_real_to_abs
      KVM: s390: VSIE: fix MVPG handling for prefixing and MSO

Pierre Morel (1):
      KVM: s390: diag9c (directed yield) forwarding

 Documentation/virt/kvm/s390-diag.rst |  33 +++++++++++
 arch/s390/include/asm/kvm_host.h     |   1 +
 arch/s390/include/asm/smp.h          |   1 +
 arch/s390/kernel/smp.c               |   1 +
 arch/s390/kvm/diag.c                 |  31 +++++++++-
 arch/s390/kvm/gaccess.c              |  30 ++++++++--
 arch/s390/kvm/gaccess.h              |  60 ++++++++++++++-----
 arch/s390/kvm/kvm-s390.c             |   8 ++-
 arch/s390/kvm/kvm-s390.h             |   8 +++
 arch/s390/kvm/vsie.c                 | 109 ++++++++++++++++++++++++++++++++---
 10 files changed, 250 insertions(+), 32 deletions(-)
