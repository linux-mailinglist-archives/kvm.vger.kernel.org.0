Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A0A70942F
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjESJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjESJz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:55:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E23101;
        Fri, 19 May 2023 02:55:55 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9dTKg030262;
        Fri, 19 May 2023 09:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zWrPtHA5HwykrIoUQBF1WZ+QVnbR/V6f0WbQ2BQ0qmY=;
 b=sXtemUSAL6O5nSn5vSGZnxUfG9k17kyFx6GHZbPJsqMYDQL2r8C2RSjSTfUTctRRlqAW
 YkVV8Zjn3wGbNeKW8ur1PqvlIdA0qdPFkZSvRg7iU9DMI+JChQ86qKSMQIpKnvUWKRle
 hXnnqK+W12m8aYYRK7/4nfeqQQxRPynLUmnDJEi2S9Rj00a+Y4K2nJyZk8Jxf6wCCq1M
 D8l0bJU7AtiIUUgoUsBAv3HxmNq4HYC5W1vcR9zkTdUFfEVdPA+oqvb1jyJZjQiXeQ6o
 PyUyaqbGrYZcC9t8mDRshT+gcsODkqtneOI2dS/lPR0IztwMUISMS9WfwMYzEVut06g2 Sg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp4q5ufs1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:55:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9bCPX011002;
        Fri, 19 May 2023 09:37:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264u3ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:37:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34J9b8tM26215042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:37:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D846E20043;
        Fri, 19 May 2023 09:37:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87E0320040;
        Fri, 19 May 2023 09:37:08 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 19 May 2023 09:37:08 +0000 (GMT)
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
Subject: [PATCH v2 0/6] s390/uvdevice: Expose secret UVCs
Date:   Fri, 19 May 2023 11:37:02 +0200
Message-Id: <20230519093708.810957-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ipRv6u8jMWiWy9gVIhYDw9I-Gqonbdkd
X-Proofpoint-GUID: ipRv6u8jMWiWy9gVIhYDw9I-Gqonbdkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_06,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015 phishscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=872 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305190080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
  * A patch replacing scnprintf with sysfs_emit in arch/s390/kernel/uv.c
  * A patch with an Ultravisor Query Info update for the new secret related information


Changes for v2:
  * use __set_bit instead of the atomic set_bit (Heiko)
  * add a patch for replacing scnprintf with sysfs_emit in arch/s390/kernel/uv.c (Heiko)
  * use scnprintf instead of sysfs_emit for the new sysfs entries in the last patch (Heiko)
  * use hex values in struct definitions (Claudio)



Steffen

Steffen Eiden (6):
  s390/uvdevice: Add info IOCTL
  s390/uvdevice: Add 'Add Secret' UVC
  s390/uvdevice: Add 'List Secrets' UVC
  s390/uvdevice: Add 'Lock Secret Store' UVC
  s390/uv: replace scnprintf with sysfs_emit
  s390/uv: Update query for secret-UVCs

 arch/s390/boot/uv.c                   |   4 +
 arch/s390/include/asm/uv.h            |  32 +++-
 arch/s390/include/uapi/asm/uvdevice.h |  56 ++++++-
 arch/s390/kernel/uv.c                 |  76 ++++++---
 drivers/s390/char/uvdevice.c          | 229 +++++++++++++++++++++++++-
 5 files changed, 366 insertions(+), 31 deletions(-)

-- 
2.40.1

