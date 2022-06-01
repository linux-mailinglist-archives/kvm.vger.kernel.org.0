Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C524653AA48
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355728AbiFAPhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355661AbiFAPhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:37:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57370BF52;
        Wed,  1 Jun 2022 08:36:58 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251FRImI026302;
        Wed, 1 Jun 2022 15:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=stFH+XOlUoO6VDXvXHOgrcSKXkunn4F4oA+Oacr1vfw=;
 b=NAN798bUTHh1ZbaHov0SmWp5yMmc2xob02MibSqLH6HkREz5cnMv8BTvNaYWZ3Vxmnv7
 FEWIptBm70vk7k2IhjQ2JcLoFyMXfNllrOKgb+1Si5JJlIJ3cCzC2/i9sFiug9Kah/dB
 Yp3HmTy39ep+pZJ/K1eacvzVmmmXenZOq3gqzq3dRpdcZsksETs1I1jVrUjuTInQahjY
 wdeIFVGvQ1NisL9VIfesI/RQkrPuzf9ye60e3kOopqEghG5lmyXjwYr2GBPgS10PBgG0
 9ISa7NXY493i4ZsQ2OdxcaqIjZhcXmHhAvwT7CI4LGNc6ujHuHu1ReMD+Owfc45dYCnS rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas5874d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FSJK9029577;
        Wed, 1 Jun 2022 15:36:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas5873h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FMBvO025743;
        Wed, 1 Jun 2022 15:36:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gdnetsfb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251Faixp14614950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C14C52050;
        Wed,  1 Jun 2022 15:36:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 19EEC5204F;
        Wed,  1 Jun 2022 15:36:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D40A0E028C; Wed,  1 Jun 2022 17:36:46 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 00/15] KVM: s390: pv dump and selftest changes
Date:   Wed,  1 Jun 2022 17:36:31 +0200
Message-Id: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Hk8yqLuINshMXBuRB6hdtpgGhYua7rW
X-Proofpoint-GUID: Ne9Xjg8rwB5yGDiyoiAQYOKBCKAAsxI8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

sorry for the late 2nd pull request for 5.19.
It has 3 numbering things that I had to take care of:
api.rst: 
4.136 KVM_S390_PV_CPU_COMMAND
8.37 KVM_CAP_S390_PROTECTED_DUMP
kvm.h
define KVM_CAP_S390_PROTECTED_DUMP 217
and then I messed up so patched have been sitting here much longer than
the commit date tells.

Please pull

The following changes since commit 85165781c5d900d97052be1d2723f6929d56768d:

  KVM: Do not pin pages tracked by gfn=>pfn caches (2022-05-25 05:23:44 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.19-2

for you to fetch changes up to b1edf7f159a6d532757b004a70f31a6425d5043f:

  KVM: s390: selftests: Use TAP interface in the reset test (2022-06-01 16:57:15 +0200)

----------------------------------------------------------------
KVM: s390: pvdump and selftest improvements

- add an interface to provide a hypervisor dump for secure guests
- improve selftests to show tests

----------------------------------------------------------------
Janosch Frank (11):
      s390/uv: Add SE hdr query information
      s390/uv: Add dump fields to query
      KVM: s390: pv: Add query interface
      KVM: s390: pv: Add dump support definitions
      KVM: s390: pv: Add query dump information
      KVM: s390: Add configuration dump functionality
      KVM: s390: Add CPU dump functionality
      KVM: s390: Add KVM_CAP_S390_PROTECTED_DUMP
      Documentation: virt: Protected virtual machine dumps
      Documentation/virt/kvm/api.rst: Add protvirt dump/info api descriptions
      Documentation/virt/kvm/api.rst: Explain rc/rrc delivery

Thomas Huth (4):
      KVM: s390: selftests: Use TAP interface in the memop test
      KVM: s390: selftests: Use TAP interface in the sync_regs test
      KVM: s390: selftests: Use TAP interface in the tprot test
      KVM: s390: selftests: Use TAP interface in the reset test

 Documentation/virt/kvm/api.rst                     | 162 ++++++++++++-
 Documentation/virt/kvm/s390/index.rst              |   1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst       |  64 +++++
 arch/s390/boot/uv.c                                |   4 +
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/include/asm/uv.h                         |  45 +++-
 arch/s390/kernel/uv.c                              |  53 ++++
 arch/s390/kvm/kvm-s390.c                           | 269 +++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                           |   5 +
 arch/s390/kvm/pv.c                                 | 198 +++++++++++++++
 include/uapi/linux/kvm.h                           |  55 +++++
 tools/testing/selftests/kvm/s390x/memop.c          |  97 ++++++--
 tools/testing/selftests/kvm/s390x/resets.c         |  38 ++-
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |  87 +++++--
 tools/testing/selftests/kvm/s390x/tprot.c          |  29 ++-
 15 files changed, 1052 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst
