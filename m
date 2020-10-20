Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D152281C6F
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBUAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:00:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725300AbgJBUAy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:00:54 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092JWLQu071707;
        Fri, 2 Oct 2020 16:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=lIbcftX8dHVCw3Fd7UfxzvrLwo6H9wOwsR6Kl/OP0eM=;
 b=Dq0iIiG6vxrT8Kb8QHGIyKtxiuCwmCH5WOQCdjWrcM+7MlLj+m4gYvhSE3VyXIqOaSam
 gGYce7EQro+A7owOJaf4uzHxVvQdpQmQqAIf2EHrtdzPH/LfNqwDtnJ1PqqEmvBeTVGF
 csQpwCJvP0lWFw3qK/TMu7eAfAUmk5VTDJX1KdIov3lRIvqr9QQItkXdyLt+kRUKg5dR
 510Vi7nlpTJYoPyGozlSpYtfKUEYFHC/MFtGmPkQr4ZcjEMB43HaCPHeoENcSvrlwrMT
 EjGMRB6GTrU+mwRm12b0C2IhB+BkMg461egfCT8GCXLO5ctA3C6e4pCUKpcSyglauA0C 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xa0xs6xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:53 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K0ZXJ164510;
        Fri, 2 Oct 2020 16:00:52 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xa0xs6x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:52 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JlIgb026874;
        Fri, 2 Oct 2020 20:00:52 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 33sw9ae9vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:00:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K0mZE54985076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:00:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DB7F6E054;
        Fri,  2 Oct 2020 20:00:48 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B716E050;
        Fri,  2 Oct 2020 20:00:47 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:00:47 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Pass zPCI hardware information via VFIO
Date:   Fri,  2 Oct 2020 16:00:39 -0400
Message-Id: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides a means by which hardware information about the
underlying PCI device can be passed up to userspace (ie, QEMU) so that
this hardware information can be used rather than previously hard-coded
assumptions. A new VFIO region type is defined which holds this
information. 

A form of these patches saw some rounds last year but has been back-
tabled for a while.  The original work for this feature was done by Pierre
Morel. I'd like to refresh the discussion on this and get this finished up
so that we can move forward with better-supporting additional types of
PCI-attached devices.  The proposal here presents a completely different
region mapping vs the prior approach, taking inspiration from vfio info
capability chains to provide device CLP information in a way that allows 
for future expansion (new CLP features).

This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry. 

Changes from v1:
- Added ACKs (thanks!)
- Patch 2: Minor change:s/util_avail/util_str_avail/ per Niklas
- Patch 3: removed __packed
- Patch 3: rework various descriptions / comment blocks
- New patch: MAINTAINERS hit to cover new files.

Matthew Rosato (5):
  s390/pci: stash version in the zpci_dev
  s390/pci: track whether util_str is valid in the zpci_dev
  vfio-pci/zdev: define the vfio_zdev header
  vfio-pci/zdev: use a device region to retrieve zPCI information
  MAINTAINERS: Add entry for s390 vfio-pci

 MAINTAINERS                         |   8 ++
 arch/s390/include/asm/pci.h         |   4 +-
 arch/s390/pci/pci_clp.c             |   2 +
 drivers/vfio/pci/Kconfig            |  13 ++
 drivers/vfio/pci/Makefile           |   1 +
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |  10 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |   5 +
 include/uapi/linux/vfio_zdev.h      | 118 ++++++++++++++++++
 10 files changed, 410 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
 create mode 100644 include/uapi/linux/vfio_zdev.h

-- 
1.8.3.1

