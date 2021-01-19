Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE622FC0F2
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390207AbhASUYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:24:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729879AbhASUYS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 15:24:18 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JK9IDq030472;
        Tue, 19 Jan 2021 15:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=CgSsfo6tp9hSiTZkAFnCJTkRoXKqZJ7jQPMtbVTHtPk=;
 b=ky+EvvPueMNC2hLk6CBsStkhxNJ/8OSE32/EWHBN7zz0eOkbVR9Ri1F1Ou3xvo094kRW
 KyL4KnnYshnpE6U2BYCz9aHbagFwqZITaRJ/+XlnPzcVRMfljKplFTDvaqQCDEOlSQto
 ge1Zv+sAf+7ukKGbujCU2raBBVZRpwOot1B3roKKKeBLeEqDca+I0e7+mrH4Av1tj6jd
 5SF9l9UzyWXDcVh2f8i6L7a5T0YDvYm+dooiM2RLgEabUzNAIMAndoCSOWxyFgu0LVTK
 lQ0CZvMxSWTd0/i82/k5zQsLN2zM2Z0d/OpOTeLvQLO0zhJHPjcFdagMsrqZt5x6bSBj Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665wngp45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:23:37 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JKAdK3037857;
        Tue, 19 Jan 2021 15:23:37 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665wngp3e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:23:37 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJqvs9013310;
        Tue, 19 Jan 2021 20:02:36 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 363qs90qq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 20:02:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JK2Zaa31064398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:02:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 414DDAC05E;
        Tue, 19 Jan 2021 20:02:35 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F4E3AC05B;
        Tue, 19 Jan 2021 20:02:33 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 20:02:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Date:   Tue, 19 Jan 2021 15:02:26 -0500
Message-Id: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today, ISM devices are completely disallowed for vfio-pci passthrough as
QEMU will reject the device due to an (inappropriate) MSI-X check.
However, in an effort to enable ISM device passthrough, I realized that the
manner in which ISM performs block write operations is highly incompatible
with the way that QEMU s390 PCI instruction interception and
vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
devices have particular requirements in regards to the alignment, size and
order of writes performed.  Furthermore, they require that legacy/non-MIO
s390 PCI instructions are used, which is also not guaranteed when the I/O
is passed through the typical userspace channels.

As a result, this patchset proposes a new VFIO region to allow a guest to
pass certain PCI instruction intercepts directly to the s390 host kernel
PCI layer for execution, pinning the guest buffer in memory briefly in
order to execute the requested PCI instruction.

Changes from RFC -> v1:
- No functional changes, just minor commentary changes -- Re-posting along
with updated QEMU set.

Matthew Rosato (4):
  s390/pci: track alignment/length strictness for zpci_dev
  vfio-pci/zdev: Pass the relaxed alignment flag
  s390/pci: Get hardware-reported max store block length
  vfio-pci/zdev: Introduce the zPCI I/O vfio region

 arch/s390/include/asm/pci.h         |   4 +-
 arch/s390/include/asm/pci_clp.h     |   7 +-
 arch/s390/pci/pci_clp.c             |   2 +
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 160 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |   4 +
 include/uapi/linux/vfio_zdev.h      |  34 ++++++++
 8 files changed, 222 insertions(+), 3 deletions(-)

-- 
1.8.3.1

