Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B879786F65
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbjHXMq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbjHXMqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371AA10FC;
        Thu, 24 Aug 2023 05:46:22 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgl5f028742;
        Thu, 24 Aug 2023 12:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=jPr17UQ/G7REXtdlBty5BnVHx2iw/Zi/X/0qCv6DGNQ=;
 b=tZxEsF05FqcdTtr99Aen8BQ8n/XmLgDM4rOiChNPBCh8ebNAkJT79JAbhEV6toPZ1CKe
 Re/ZSiiY9cHypwJ+a3H0W3+r9+txBIvS61q+oe8Bxg8WK5d/p8UAqfa3smb9VYtDSTgE
 ZAyCtOsLEN6b5i5x094XvvgsrAabWkTnrLkGT1iFwLF293azOFcBEU9xKPrbawmrFxTT
 hX3S8qROAxe84oJCbyolhBCkPA06UoqKIr+FhsrGOhoLjizdDa7MjlKNx6YWkBP7R1NA
 6kfph4ThM73gMWPI3asYiFIA+oQmhyInOBAFagQTd91YZu0eXddz6Cf9ls9uWA+z+/cN Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0h2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:20 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh66E029951;
        Thu, 24 Aug 2023 12:46:14 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0gqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:13 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCex68010275;
        Thu, 24 Aug 2023 12:46:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sy05s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCk8N746203194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A43F2004B;
        Thu, 24 Aug 2023 12:46:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75C2C20043;
        Thu, 24 Aug 2023 12:46:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 00/22] KVM: s390: Changes for 6.6
Date:   Thu, 24 Aug 2023 14:43:09 +0200
Message-ID: <20230824124522.75408-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 84lEH36jOBhcOiLDaRClP7V1ACs9QLvt
X-Proofpoint-GUID: 2dcyxyXmhdV4l4HcpZpN489TbdEZFOOf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=920 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

please pull the following changes for 6.6.

Please note that Heiko and I both merged Heiko's vfio-ap feature
branch. We had to do that since vfio-ap patches go through his s390
repository but Steffen's KVM cpumodel patches are based on Tony's
vfio-ap changes.

In the long run we're considering putting vfio-ap patches into their
own repository but for 6.6 we didn't find the time to speak with all
affected maintainers.

- PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
  Allows a PV guest to use crypto cards. Card access is governed by
  the firmware and once a crypto queue is "bound" to a PV VM every
  other entity (PV or not) looses access until it is not bound
  anymore. Enablement is done via flags when creating the PV VM.

- Guest debug fixes (Ilya)

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.6-1

for you to fetch changes up to b1d8b21681db97b775d05ebc39c4d662192c8f15:

  KVM: s390: pv: Allow AP-instructions for pv-guests (2023-08-18 16:11:39 +0200)

----------------------------------------------------------------
Ilya Leoshkevich (6):
      KVM: s390: interrupt: Fix single-stepping into interrupt handlers
      KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
      KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
      KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
      KVM: s390: interrupt: Fix single-stepping keyless mode exits
      KVM: s390: selftests: Add selftest for single-stepping

Janosch Frank (2):
      s390/uv: export uv_pin_shared for direct usage
      Merge remote-tracking branch 'vfio-ap' into kvm-next

Steffen Eiden (3):
      s390/uv: UV feature check utility
      KVM: s390: Add UV feature negotiation
      KVM: s390: pv: Allow AP-instructions for pv-guests

Tony Krowiak (11):
      s390/vfio-ap: no need to check the 'E' and 'I' bits in APQSW after TAPQ
      s390/vfio-ap: clean up irq resources if possible
      s390/vfio-ap: wait for response code 05 to clear on queue reset
      s390/vfio-ap: allow deconfigured queue to be passed through to a guest
      s390/vfio-ap: remove upper limit on wait for queue reset to complete
      s390/vfio-ap: store entire AP queue status word with the queue object
      s390/vfio-ap: use work struct to verify queue reset
      s390/vfio-ap: handle queue state change in progress on reset
      s390/vfio-ap: check for TAPQ response codes 0x35 and 0x36
      KVM: s390: export kvm_s390_pv*_is_protected functions
      s390/vfio-ap: make sure nib is shared

Viktor Mihajlovski (1):
      KVM: s390: pv: relax WARN_ONCE condition for destroy fast

 arch/s390/include/asm/kvm_host.h               |   5 +
 arch/s390/include/asm/uv.h                     |  25 +++-
 arch/s390/include/uapi/asm/kvm.h               |  16 +++
 arch/s390/kernel/uv.c                          |   5 +-
 arch/s390/kvm/intercept.c                      |  38 +++++-
 arch/s390/kvm/interrupt.c                      |  14 ++
 arch/s390/kvm/kvm-s390.c                       | 102 ++++++++++++++-
 arch/s390/kvm/kvm-s390.h                       |  12 --
 arch/s390/kvm/pv.c                             |  23 +++-
 arch/s390/mm/fault.c                           |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c              | 172 ++++++++++++++++---------
 drivers/s390/crypto/vfio_ap_private.h          |   6 +-
 tools/testing/selftests/kvm/Makefile           |   1 +
 tools/testing/selftests/kvm/s390x/debug_test.c | 160 +++++++++++++++++++++++
 14 files changed, 486 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c
