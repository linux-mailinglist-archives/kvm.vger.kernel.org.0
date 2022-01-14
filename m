Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8151948F190
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbiANUjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:39:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240286AbiANUjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:39:09 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EJvpM2017506;
        Fri, 14 Jan 2022 20:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=1iQ5P5txPvuJR9ya+vTLrfN+PIPqiw6VN7RJnObuOF8=;
 b=HasTMkt4/sspCh09qYDLSONrRSysNjF7t0JXUhxE2ww0ekEas5BGbQifwnauPwDTgXM9
 1WqV4sujM3u1HcOC32i/14FaiqhRdMRp6gBa1ge08sMs8IzBbNFf1oh1bJdzOLlR1jbe
 f9f+uLBvIy/KTqnPVUG8NqJhcC3tc0GW3DVbY10oCf0bKEtStGBffXQOsuWsK5+n+Sch
 rehQaCFq2QcB8b5dPa9FtTaOVC+cPK2I9AE9l8yf9hRs0BNxezayhW0zYlU96EDA/tnJ
 IJ4RS358k7hnlRXW/zWsoPnf46dSaozatLIm5C698q2T/+4UrQkRVOXmj7xADns2JzZ/ +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsvgpp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKMFvl006540;
        Fri, 14 Jan 2022 20:38:57 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsvgpnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:57 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLr8c027865;
        Fri, 14 Jan 2022 20:38:55 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3df28cyj26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:55 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKcsJS26411510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:38:54 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A72FC605F;
        Fri, 14 Jan 2022 20:38:54 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09502C6057;
        Fri, 14 Jan 2022 20:38:52 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:38:52 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 0/9] s390x/pci: zPCI interpretation support
Date:   Fri, 14 Jan 2022 15:38:40 -0500
Message-Id: <20220114203849.243657-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yz1z78IqfFMh9kUVHCo9eJZ4v7JbHAAn
X-Proofpoint-GUID: Q5k42dAKHx9PDrLl-BU-6kv7StBOOirD
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For QEMU, the majority of the work in enabling instruction interpretation
is handled via new VFIO ioctls to SET the appropriate interpretation and
interrupt forwarding modes, and to GET the function handle to use for
interpretive execution.  

This series implements these new ioctls, as well as adding a new, optional
'intercept' parameter to zpci to request interpretation support not be used
as well as an 'intassist' parameter to determine whether or not the
firmware assist will be used for interrupt delivery or whether the host
will be responsible for delivering all interrupts.

The ZPCI_INTERP CPU feature is added beginning with the z14 model to
enable this support.

As a consequence of implementing zPCI interpretation, ISM devices now
become eligible for passthrough (but only when zPCI interpretation is
available).

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Associated kernel series:
https://lore.kernel.org/kvm/20220114203145.242984-1-mjrosato@linux.ibm.com/

Changes v1->v2:

- Update kernel headers sync                                                    
- Drop some pre-req patches that are now merged                                 
- Add some R-bs (Thanks!)                                                       
- fence FEAT_ZPCI_INTERP for QEMU 6.2 and older (Christian)                     
- switch from container_of to VFIO_PCI and drop asserts (Thomas)                
- re-arrange g_autofree so we malloc at time of declaration (Thomas) 

Matthew Rosato (9):
  Update linux headers
  target/s390x: add zpci-interp to cpu models
  fixup: force interp off for QEMU machine 6.2 and older
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: use I/O Address Translation assist when interpreting
  s390x/pci: use dtsm provided from vfio capabilities for interpreted
    devices
  s390x/pci: let intercept devices have separate PCI groups

 hw/s390x/s390-pci-bus.c                       | 121 ++++++++++-
 hw/s390x/s390-pci-inst.c                      | 168 ++++++++++++++-
 hw/s390x/s390-pci-vfio.c                      | 204 +++++++++++++++++-
 hw/s390x/s390-virtio-ccw.c                    |   1 +
 include/hw/s390x/s390-pci-bus.h               |   8 +-
 include/hw/s390x/s390-pci-inst.h              |   2 +-
 include/hw/s390x/s390-pci-vfio.h              |  45 ++++
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     |  11 +
 include/standard-headers/linux/ethtool.h      |   1 +
 include/standard-headers/linux/fuse.h         |  60 +++++-
 include/standard-headers/linux/pci_regs.h     |   4 +
 include/standard-headers/linux/virtio_iommu.h |   8 +-
 linux-headers/asm-mips/unistd_n32.h           |   1 +
 linux-headers/asm-mips/unistd_n64.h           |   1 +
 linux-headers/asm-mips/unistd_o32.h           |   1 +
 linux-headers/asm-powerpc/unistd_32.h         |   1 +
 linux-headers/asm-powerpc/unistd_64.h         |   1 +
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-s390/unistd_32.h            |   1 +
 linux-headers/asm-s390/unistd_64.h            |   1 +
 linux-headers/linux/kvm.h                     |   1 +
 linux-headers/linux/vfio.h                    |  22 ++
 linux-headers/linux/vfio_zdev.h               |  51 +++++
 target/s390x/cpu_features_def.h.inc           |   1 +
 target/s390x/gen-features.c                   |   2 +
 target/s390x/kvm/kvm.c                        |   1 +
 27 files changed, 693 insertions(+), 27 deletions(-)

-- 
2.27.0

