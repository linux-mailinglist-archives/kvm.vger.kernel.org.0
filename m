Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1078C3E8
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbjH2MKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjH2MJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961CE98;
        Tue, 29 Aug 2023 05:09:46 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TAlDYw028835;
        Tue, 29 Aug 2023 12:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=gj92iVXaobHEatMyudGwB0SyS9cTSepfDiB7c1VDWTw=;
 b=YWuzDQGl4dBlnj+NKqzB4qJuJ36OawwH6n1oQ7AE+Em77hhheJjTxmuHcZauwCO0ALlW
 1G3z3q4vL7EB9pybAIzO+RF/3mPYzXTdBnHm/gUgvDeENNNdMDSqtJOa4Pucv9AOG22K
 ASKNUPSD/HadrDaS7hue2GksvCegEAQRNV6XcbdL7XxRR+fsPO1ckLU3eRJEfpXfCShQ
 8FImWRSv9ROiRFNxjnY84D/GOP10UvE/H2BRAY15vt8Ua29+iaIWMc68t0OZoeE5j7Kn
 +iyZLundnzlWJF5opMr+2gM1KthJ0RHftVzVfqsgAY9fBDxrBdezh4OsktIZgn27g4Et BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssf7tj8x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:46 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TBueSr003260;
        Tue, 29 Aug 2023 12:09:44 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssf7tj8ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:43 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBMTmh019294;
        Tue, 29 Aug 2023 12:09:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sqxe1jmm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9Ip534341200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A590E20043;
        Tue, 29 Aug 2023 12:09:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85B92004D;
        Tue, 29 Aug 2023 12:09:17 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 00/10] KVM: s390: Changes for 6.6
Date:   Tue, 29 Aug 2023 14:03:55 +0200
Message-ID: <20230829120843.66637-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: geidxyUFPihARKa4096C7t72cWnCBITo
X-Proofpoint-GUID: a2og6tUuosVXYadhofZoRMMlHEjP12Kh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=589 impostorscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

let's try this again.
Please pull the following changes for 6.6.

Please note that Heiko and I both merged Heiko's vfio-ap feature
branch. Linus has pulled Heiko's next branch already (e5b7ca09e9aa).

I've also merged tags/kvm-x86-selftests-immutable-6.6 since we
introduce a new selftest with the guest debug fixes. I had to fixup
the selftest commit since a function name changed.

In the long run we're considering putting vfio-ap patches into their
own repository but for 6.6 we didn't find the time to speak with all
affected maintainers.

Changes:
- PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
  Allows a PV guest to use crypto cards. Card access is governed by
  the firmware and once a crypto queue is "bound" to a PV VM every
  other entity (PV or not) looses access until it is not bound
  anymore. Enablement is done via flags when creating the PV VM.

- Guest debug fixes + test (Ilya)

The following changes since commit ede6d0b2031e045f0a0e4515e4567828d87fd3ef:

  Merge tag 'kvm-x86-selftests-immutable-6.6' into next (2023-08-28 09:23:36 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.6-1

for you to fetch changes up to 899e2206f46aece42d8194c350bc1de71344dbc7:

  KVM: s390: pv: Allow AP-instructions for pv-guests (2023-08-28 09:27:56 +0000)

----------------------------------------------------------------
- PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
  Allows a PV guest to use crypto cards. Card access is governed by
  the firmware and once a crypto queue is "bound" to a PV VM every
  other entity (PV or not) looses access until it is not bound
  anymore. Enablement is done via flags when creating the PV VM.

- Guest debug fixes (Ilya)
----------------------------------------------------------------

Ilya Leoshkevich (6):
  KVM: s390: interrupt: Fix single-stepping into interrupt handlers
  KVM: s390: interrupt: Fix single-stepping into program interrupt
    handlers
  KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
  KVM: s390: interrupt: Fix single-stepping userspace-emulated
    instructions
  KVM: s390: interrupt: Fix single-stepping keyless mode exits
  KVM: s390: selftests: Add selftest for single-stepping

Steffen Eiden (3):
  s390/uv: UV feature check utility
  KVM: s390: Add UV feature negotiation
  KVM: s390: pv: Allow AP-instructions for pv-guests

Viktor Mihajlovski (1):
  KVM: s390: pv: relax WARN_ONCE condition for destroy fast

-- 
2.41.0

