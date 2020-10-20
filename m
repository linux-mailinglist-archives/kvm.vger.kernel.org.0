Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5542867E2
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgJGS4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:56:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726111AbgJGS4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 14:56:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097IaMXY111478;
        Wed, 7 Oct 2020 14:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=ZY+GQVC1bcC8uF8DszSKcv11bWaq3iF8ovZZYd4c/1k=;
 b=Z4+CNaELJnrE3QdNA9Bbsvqoi9RbeTuuyW77Yk8w3LfElqjmbzxGMP/0181EnnRvAHa4
 /QI1HX+KtcMZTEmR2RUfRoCKSDmoD0XEZZ3H6Foqk8Lb3N/d/rjPm9uyKDX4ExLG0oI3
 ya3ctFLY/bCLQOfyS66xInXhPG7JqFIau1gwRVmW+BvF5lqzI513J0ATJXYhmkNHX/iD
 /pubC9Yt8vgIzk89ZkcGxIOus8eeh61TTOik+kBKTQpCntDmLGEzFs2WInGdmXxBJYJP
 j41VXEXNq331t8x5XRxkiEuGZtkkwYDye50HJAIUmoqv1oUi4jHKT9XU+G2m66ND0qjl 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jehsp3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:32 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097IaZoN112746;
        Wed, 7 Oct 2020 14:56:31 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jehsp3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:31 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IkcDp014993;
        Wed, 7 Oct 2020 18:56:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 33xgx999cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 18:56:31 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097IuL5d58786116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 18:56:21 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D452A78060;
        Wed,  7 Oct 2020 18:56:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B666F78064;
        Wed,  7 Oct 2020 18:56:26 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 18:56:26 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] Pass zPCI hardware information via VFIO
Date:   Wed,  7 Oct 2020 14:56:19 -0400
Message-Id: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=986 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides a means by which hardware information about the
underlying PCI device can be passed up to userspace (ie, QEMU) so that
this hardware information can be used rather than previously hard-coded
assumptions. The VFIO_DEVICE_GET_INFO ioctl is extended to allow capability
chains and zPCI devices provide the hardware information via capabilities.

A form of these patches saw some rounds last year but has been back-
tabled for a while.  The original work for this feature was done by Pierre
Morel. I'd like to refresh the discussion on this and get this finished up
so that we can move forward with better-supporting additional types of
PCI-attached devices.  

This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry. 

Changes since v2:
- Added ACKs (thanks!)
- Patch 3+4: Re-write to use VFIO_DEVICE_GET_INFO capabilities rather than
  a vfio device region.

Matthew Rosato (5):
  s390/pci: stash version in the zpci_dev
  s390/pci: track whether util_str is valid in the zpci_dev
  vfio: Introduce capability definitions for VFIO_DEVICE_GET_INFO
  vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO
  MAINTAINERS: Add entry for s390 vfio-pci

 MAINTAINERS                         |   8 ++
 arch/s390/include/asm/pci.h         |   4 +-
 arch/s390/pci/pci_clp.c             |   2 +
 drivers/vfio/pci/Kconfig            |  13 ++++
 drivers/vfio/pci/Makefile           |   1 +
 drivers/vfio/pci/vfio_pci.c         |  37 ++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  12 +++
 drivers/vfio/pci/vfio_pci_zdev.c    | 143 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |  11 +++
 include/uapi/linux/vfio_zdev.h      |  78 ++++++++++++++++++++
 10 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
 create mode 100644 include/uapi/linux/vfio_zdev.h

-- 
1.8.3.1

