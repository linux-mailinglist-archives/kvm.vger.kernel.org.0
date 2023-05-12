Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426957003CB
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbjELJcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbjELJcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:32:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48825596;
        Fri, 12 May 2023 02:32:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9PiHh007243;
        Fri, 12 May 2023 09:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=okP6Pq6MJ09PNXRXbF+JgVfwUd0jdWmjvDe2AGlc6BM=;
 b=l1ZMCoPDhgMOSqmMyt81xndvK2d5lqwUo8chV+6QaQ+E6Z+u7JkPQRB/qsTLijFKCNen
 rFj5KamcG/AJu4OZc6dRr91fRVacURejOcWQcWv423rPO3R4UyM0r0B7lqToSRl1Fgpu
 RhjLitlwjLKcthXRw+JA7YwgTCKFPcySpPM+ZIs0BsLNIqEwST+399FP0DFCGLasurV0
 5Y0Cm2xOsZ4oni+xfaz3PVBBjwBt3PA+q8wGWxqKBOPuGV0Lm0CrZ39JP540tbrF3X0e
 2S2FKTL7F4sc3xx1YbszdOjtisRMctALHggz5A6fcTfEcup3CpDAq/xaDPO5YygOWKI5 sg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjtbg5fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C29Xpe018116;
        Fri, 12 May 2023 09:31:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896t8es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9VriS30278280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9769820040;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45FC820043;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH 0/5] s390/uvdevice: Expose secret UVCs
Date:   Fri, 12 May 2023 11:31:48 +0200
Message-Id: <20230512093153.206378-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RdJfXh1_JHc8vv_vpylVrCeum6m2H6Sg
X-Proofpoint-GUID: RdJfXh1_JHc8vv_vpylVrCeum6m2H6Sg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=680 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IBM Secure Execution guests may want to inject secrets into the Ultravisor(UV).
Also they should be able to know which secrets the UV possesses and prevent the
further addition of more secrets.

Therefore, add three new Ultravisor-Calls and expose them via the uvdevice:
Add Secret, List Secrets, and Lock Secrets.
The uvdevice still acts as the messenger only and does not inspect or modify
the requests. Only some sanity checks are made to prevent the kernel from corruption.
Also add a new IOCTL to get information about the supported UV-calls of the uvdevice.
As userspace wants to know which secrets, types, etc. are supported expose the corresponding
UV Query info data to userspace via sysfs.

The series contains:
  * A new info IOCTL, giving information about the capabilities of the uvdevice and UV
  * 3 patches adding new Ultravisor-Calls and expose them to userspace
  * A patch with an Ultravisor Query Info update for the new secret related information

Steffen

Steffen Eiden (5):
  s390/uvdevice: Add info IOCTL
  s390/uvdevice: Add 'Add Secret' UVC
  s390/uvdevice: Add 'List Secrets' UVC
  s390/uvdevice: Add 'Lock Secret Store' UVC
  s390/uv: Update query for secret-UVCs

 arch/s390/boot/uv.c                   |   4 +
 arch/s390/include/asm/uv.h            |  30 +++-
 arch/s390/include/uapi/asm/uvdevice.h |  56 ++++++-
 arch/s390/kernel/uv.c                 |  40 +++++
 drivers/s390/char/uvdevice.c          | 229 +++++++++++++++++++++++++-
 5 files changed, 350 insertions(+), 9 deletions(-)

-- 
2.40.1

