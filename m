Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9744BF50B
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiBVJtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiBVJtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92B4BBE1F;
        Tue, 22 Feb 2022 01:49:18 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M9IaHE035574;
        Tue, 22 Feb 2022 09:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=aGu1/OV1b80PAfQFSXG+657PvJczt7AlFVXysG0fZKo=;
 b=RWZ29F7mGnIXJxf6g/TFclLxrgVjVyufwMQYdCpKslQnjFt+38z/0e8QapvXYBGVST4v
 xLQE4FCGnOAR+fQdaRl2ajvCOu/uarBQqwGdE5isUCdnkoSOZdC+VqL42YHu2Qhnb8sV
 vqzJ7M8MiGbLnOTiw6pXF81y7foAJPwv9bVVgIHrWtRch2fGIqHEPDBr7qHAY1IfqTlx
 /2lVXcAoWWajorbUiQ7utPyOOGLRJgB0l9J6GxfyBJyDQ2ayPeLhvIRA3A5OEpuJLu4V
 ZMMLgDcg2Wvinxzd6vvKD6vJ6+j7LedlCeYjjuRfl+0T/dp4HlfO7Czn42RZ/IwixwqN Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecw3a8jju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9kL0G002828;
        Tue, 22 Feb 2022 09:49:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecw3a8jjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9lOZU000657;
        Tue, 22 Feb 2022 09:49:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtj1kb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nBp557016704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C927752054;
        Tue, 22 Feb 2022 09:49:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id B347352050;
        Tue, 22 Feb 2022 09:49:11 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 58027E04DC; Tue, 22 Feb 2022 10:49:11 +0100 (CET)
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
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 00/13] KVM: s390: Changes for 5.18 part1
Date:   Tue, 22 Feb 2022 10:48:57 +0100
Message-Id: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eAyqdknrZnqhg2pE7Dv5PEsLV7yjYHSb
X-Proofpoint-ORIG-GUID: pZWGbtQUsyey98P8KiAwN7XbIINiyVMz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

first part of the s390 parts of KVM for 5.18. This is on top of the fix
that went into Linus tree, so it will move kvm/next to something between
rc3 and rc4.

I added 2 later fixups for the storage key patches on top. Let me know if
you prefer them folded in.

We might do a 2nd pull request later on depending on timing, review and
other constraints
with
- rewritten selftest for memop
- ultravisor device (could also go via s390 tree)
- parts/all of Claudios lazy destroy
- parts/all of PCI passthru (could be later and might go via s390 tree as
  well via a topic branch)
- followup to guest entry/exit work if we find a small solution
- adapter interruption virtualization facility for secure guests

The following changes since commit 09a93c1df3eafa43bcdfd7bf837c574911f12f55:

  Merge tag 'kvm-s390-kernel-access' from emailed bundle (2022-02-09 09:14:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.18-1

for you to fetch changes up to 3d9042f8b923810c169ece02d91c70ec498eff0b:

  KVM: s390: Add missing vm MEM_OP size check (2022-02-22 09:16:18 +0100)

----------------------------------------------------------------
KVM: s390: Changes for 5.18 part1

- add Claudio as Maintainer
- first step to do proper storage key checking
- testcase for missing memop check

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: MAINTAINERS: promote Claudio Imbrenda

Janis Schoetterl-Glausch (11):
      s390/uaccess: Add copy_from/to_user_key functions
      KVM: s390: Honor storage keys when accessing guest memory
      KVM: s390: handle_tprot: Honor storage keys
      KVM: s390: selftests: Test TEST PROTECTION emulation
      KVM: s390: Add optional storage key checking to MEMOP IOCTL
      KVM: s390: Add vm IOCTL for key checked guest absolute memory access
      KVM: s390: Rename existing vcpu memop functions
      KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
      KVM: s390: Update api documentation for memop ioctl
      KVM: s390: Clarify key argument for MEM_OP in api docs
      KVM: s390: Add missing vm MEM_OP size check

Thomas Huth (1):
      selftests: kvm: Check whether SIDA memop fails for normal guests

 Documentation/virt/kvm/api.rst            | 112 ++++++++++---
 MAINTAINERS                               |   2 +-
 arch/s390/include/asm/ctl_reg.h           |   2 +
 arch/s390/include/asm/page.h              |   2 +
 arch/s390/include/asm/uaccess.h           |  22 +++
 arch/s390/kvm/gaccess.c                   | 250 ++++++++++++++++++++++++++++--
 arch/s390/kvm/gaccess.h                   |  86 ++++++++--
 arch/s390/kvm/intercept.c                 |  12 +-
 arch/s390/kvm/kvm-s390.c                  | 132 +++++++++++++---
 arch/s390/kvm/priv.c                      |  66 ++++----
 arch/s390/lib/uaccess.c                   |  81 +++++++---
 include/uapi/linux/kvm.h                  |  11 +-
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c |  15 ++
 tools/testing/selftests/kvm/s390x/tprot.c | 227 +++++++++++++++++++++++++++
 16 files changed, 897 insertions(+), 125 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c
