Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BC819975
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfEJIXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 04:23:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727112AbfEJIXP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 04:23:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A8N4Bx176151
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 04:23:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sd4yka5br-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 04:23:09 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 10 May 2019 09:22:41 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 09:22:37 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A8Mala63176922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 08:22:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 324D7AE051;
        Fri, 10 May 2019 08:22:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC01AE045;
        Fri, 10 May 2019 08:22:35 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.187.238])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 08:22:35 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     sebott@linux.vnet.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [PATCH 0/4] Retrieving zPCI specific info with VFIO
Date:   Fri, 10 May 2019 10:22:31 +0200
X-Mailer: git-send-email 2.7.4
X-TM-AS-GCONF: 00
x-cbid: 19051008-0008-0000-0000-000002E53737
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051008-0009-0000-0000-00002251C19D
Message-Id: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=596 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the PCI VFIO interface allows userland, a.k.a. QEMU, to retrieve
ZPCI specific information without knowing Z specific identifiers
like the function ID or the function handle of the zPCI function
hidden behind the PCI interface. 
  
By using the VFIO_IOMMU_GET_INFO ioctl we enter the vfio_iommu_type1
ioctl callback and can insert there the treatment for a new Z specific
capability.
  
Once in vfio_iommu_type1 we can retrieve the real iommu device,
s390_iommu and call the get_attr iommu operation's callback
in which we can retrieve the zdev device and start clp operations
to retrieve Z specific values the guest driver is concerned with.
 
To share the code with arch/s390/pci/pci_clp.c the original functions
in pci_clp.c to query PCI functions and PCI functions group are
modified so that they can be exported.

A new function clp_query_pci() replaces clp_query_pci_fn() and
the previous calls to clp_query_pci_fn() and clp_query_pci_fngrp()
are replaced with calls to zdev_query_pci_fn() and zdev_query_pci_fngrp()
using a zdev pointer as argument.

These two functions are exported to be used from out of the s390_iommu
code.

Pierre Morel (4):
  s390: pci: Exporting access to CLP PCI function and PCI group
  vfio: vfio_iommu_type1: Define VFIO_IOMMU_INFO_CAPABILITIES
  s390: iommu: Adding get attributes for s390_iommu
  vfio: vfio_iommu_type1: implement VFIO_IOMMU_INFO_CAPABILITIES

 arch/s390/include/asm/pci.h     |  3 ++
 arch/s390/pci/pci_clp.c         | 72 ++++++++++++++++---------------
 drivers/iommu/s390-iommu.c      | 77 +++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h           |  4 ++
 include/uapi/linux/vfio.h       | 10 +++++
 6 files changed, 226 insertions(+), 35 deletions(-)

-- 
2.7.4

