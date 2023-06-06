Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7482072410E
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbjFFLhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 07:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbjFFLho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 07:37:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C9AE9;
        Tue,  6 Jun 2023 04:37:43 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356BMipU017525;
        Tue, 6 Jun 2023 11:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hT2L6wqUoRwijI9uennQgGxrS1wlHDxNGpQqXVQ+BSs=;
 b=edrkFXScUoE3724+bYUb5jpkp6QRgaZk3+6wodmqPOQLBIHqZdJ4YdGFq52dmK58zt8L
 ohNRBxwRwjjbKpsEdbvwHBcqx7tghqMfGzHWY6mwi/pxxifp7v8u0zDmTUy+dULRopnG
 SqjeBe2UVE5MOW9e4b2gtmW+8WvHoTGTiXFXLEvXwYdZBuK6dWWdtMpYxSPH3dL0xlfY
 doFKrXQUVPacma7oYsmkKDNJdnAZIZq/dRPlNwiYJA53NagwkSR9fdPT9D4j2v/gTcDC
 97Rs6/YQmEUkuK4MzxsVAJQx7ozwK0RmVDVxjivkjVAR90L9QSqQKwBqlmTDqLcH9dwn Sw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r23v9rb1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 11:37:42 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3562ePnw012571;
        Tue, 6 Jun 2023 11:37:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qyxdf9gjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 11:37:40 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356BbbaG57147656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 11:37:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A49120043;
        Tue,  6 Jun 2023 11:37:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE4B620040;
        Tue,  6 Jun 2023 11:37:36 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 11:37:36 +0000 (GMT)
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
Subject: [PATCH v3 0/6] s390/uvdevice: Expose secret UVCs
Date:   Tue,  6 Jun 2023 13:37:30 +0200
Message-Id: <20230606113736.2934503-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5ouws-yezvrMu1Tipw997mGhrEqGnioi
X-Proofpoint-GUID: 5ouws-yezvrMu1Tipw997mGhrEqGnioi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_07,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=982 lowpriorityscore=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IBM Secure Execution guests may want to inject secrets into the Ultravisor(UV).
Also they should be able to know which secrets the UV possesses and prevent the
further addition of more secrets.

Therefore, add three new Ultravisor-Calls and expose them via the uvdevice: Add
Secret, List Secrets, and Lock Secrets.  The uvdevice still acts as the
messenger only and does not inspect or modify the requests. Only some sanity
checks are made to prevent the kernel from corruption.
Also add a new IOCTL to get information about the supported UV-calls of the
uvdevice.  As userspace wants to know which secrets, types, etc. are supported
expose the corresponding UV Query info data to userspace via sysfs.

The series contains:
  * A new info IOCTL, giving information about the capabilities of the uvdevice and UV
  * 3 patches adding new Ultravisor-Calls and expose them to userspace
  * A patch replacing scnprintf with sysfs_emit in arch/s390/kernel/uv.c
  * A patch with an Ultravisor Query Info update for the new secret related information

Changes for v3:
  * misc nits from Janosch

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
 arch/s390/include/uapi/asm/uvdevice.h |  53 +++++-
 arch/s390/kernel/uv.c                 |  94 +++++++----
 drivers/s390/char/uvdevice.c          | 225 +++++++++++++++++++++++++-
 5 files changed, 368 insertions(+), 40 deletions(-)

-- 
2.40.1

