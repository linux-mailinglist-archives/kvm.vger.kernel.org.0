Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103C0281C8B
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJBUGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:06:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgJBUGq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:06:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K2Jav110817;
        Fri, 2 Oct 2020 16:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=+JYwpC35tUm/nlFFYqmK4F+lxWr/aRuhCz48GQWyD0k=;
 b=CB+/aRw/ks6mUxhkT5hiHsAWRzO9eYOgMLbgsTiSYg2H74wfiFGxhn+maRr+t3Z8DFcV
 JloVp3PtycRqjdhjkG8QqJjH9TM46fvAx4ZfJ5TPi/6+gdNNSaCu/lF+B688hQCH9rzb
 LezwrmnY9AGjD8Asbsv92/4W3E2k0FQVCIthrPymZSEQc5lr1K38kIHihSDESoHK3/NK
 Xi4oaPVIPg5vuCoMpCh1ySHrFdq69osTbA8AXe+sRWun/CK8dvbLUb9HNWEAUlkeCwsH
 K0kVTHxtj7ZIyN9OVuEeIBKYhLSPwsNFNPrF2rdKF6/tvtg9fZVIp+NvhUOEEDDAMD1F yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xaqmrb0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:37 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K5HvV125763;
        Fri, 2 Oct 2020 16:06:37 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33xaqmrb05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:37 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092Jl8D5005732;
        Fri, 2 Oct 2020 20:06:36 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 33sw9a09g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:36 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6VsO32833974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:31 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46D7FBE054;
        Fri,  2 Oct 2020 20:06:35 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F031BBE04F;
        Fri,  2 Oct 2020 20:06:33 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 0/9] Retrieve zPCI hardware information from VFIO
Date:   Fri,  2 Oct 2020 16:06:22 -0400
Message-Id: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset exploits the VFIO ZPCI CLP region, which provides hardware
information about passed-through s390 PCI devices that can be shared with
the guest.

The retrieval of this information is done once per function (and for a
subset of data, once per function group) and is performed at time of device
plug.  Some elements provided in the CLP region must still be forced to
default values for now to reflect what QEMU actually provides support for.

The original work for this feature was done by Pierre Morel.

Associated kernel patchset:
https://lkml.org/lkml/2020/10/2/981

Changes from v1:
- Added 2 patches to the front of this set that move the s390-pci-bus.h and
  s390-pci-inst.h files to include + associated MAINTAINERS hit.  These
  can be applied separately, but are included here for the sake of
  simplicity.
- Patch 4: header update placeholder refreshed to rc7
- Patch 5: Move new s390-pci-clp.h to include folder
- Patch 6+: s/grp/group/ and fallout from this
- Patch 9: Move new s390-pci-vfio.h to include folder


Matthew Rosato (6):
  s390x/pci: Move header files to include/hw/s390x
  MAINTAINERS: Update s390 PCI entry to include headers
  update-linux-headers: Add vfio_zdev.h
  linux-headers: update against 5.9-rc7
  s390x/pci: clean up s390 PCI groups
  s390x/pci: get zPCI function info from host

Pierre Morel (3):
  s390x/pci: create a header dedicated to PCI CLP
  s390x/pci: use a PCI Group structure
  s390x/pci: use a PCI Function structure

 MAINTAINERS                                        |   1 +
 hw/s390x/meson.build                               |   1 +
 hw/s390x/s390-pci-bus.c                            |  86 ++++-
 hw/s390x/s390-pci-bus.h                            | 372 --------------------
 hw/s390x/s390-pci-inst.c                           |  33 +-
 hw/s390x/s390-pci-inst.h                           | 312 -----------------
 hw/s390x/s390-pci-vfio.c                           | 235 +++++++++++++
 hw/s390x/s390-virtio-ccw.c                         |   2 +-
 include/hw/s390x/s390-pci-bus.h                    | 385 +++++++++++++++++++++
 include/hw/s390x/s390-pci-clp.h                    | 215 ++++++++++++
 include/hw/s390x/s390-pci-inst.h                   | 116 +++++++
 include/hw/s390x/s390-pci-vfio.h                   |  19 +
 .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h |  14 +-
 linux-headers/linux/kvm.h                          |   6 +-
 linux-headers/linux/vfio.h                         |   5 +
 scripts/update-linux-headers.sh                    |   2 +-
 16 files changed, 1085 insertions(+), 719 deletions(-)
 delete mode 100644 hw/s390x/s390-pci-bus.h
 delete mode 100644 hw/s390x/s390-pci-inst.h
 create mode 100644 hw/s390x/s390-pci-vfio.c
 create mode 100644 include/hw/s390x/s390-pci-bus.h
 create mode 100644 include/hw/s390x/s390-pci-clp.h
 create mode 100644 include/hw/s390x/s390-pci-inst.h
 create mode 100644 include/hw/s390x/s390-pci-vfio.h

-- 
1.8.3.1

