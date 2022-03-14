Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124114D8D2A
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244610AbiCNTvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244592AbiCNTvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB23FBD2
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:50:06 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVnM009010;
        Mon, 14 Mar 2022 19:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=E/oDn7pQI5rqG2up5ajWc98ZO6oaWKVCXd3/R/OuNZE=;
 b=BB/LPeXt8f7hFOhS/JGaYBo5QP1+qdkN62gza+Bki6hzPolVbThHuautDt6tv1bBHgko
 uYtiJYvRO7jjFSr7evO+Qwc+ugiglG5Ni7NsB2541uQBDTOgqg0bnvW5zDvjeGMDgecq
 tOIzkpiumJqr97rktEhhijdRO2sNFHLXyRC//6IzSxa+x0KjYENdAKecsSljA+XQ/4gJ
 jZELdXj473/SOr93dKqZ1MwEmICqyhc9hUTkOvFdSmudCuq+J6+/NqcsvzhPDDed+P93
 WZbFBoz9eijohp9QcgyxwHuzMDAdaH2poOuNh4urp/M6GcamHHMTvdOM8sJVCG0awIpV FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d28p7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:31 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJnUfd015259;
        Mon, 14 Mar 2022 19:49:30 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d28p7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:30 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJltfi010580;
        Mon, 14 Mar 2022 19:49:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3erk594d8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:29 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnSvN31129980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:28 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB464112070;
        Mon, 14 Mar 2022 19:49:27 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CBA4112062;
        Mon, 14 Mar 2022 19:49:24 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:24 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 00/11] s390x/pci: zPCI interpretation support                
Date:   Mon, 14 Mar 2022 15:49:09 -0400
Message-Id: <20220314194920.58888-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0MtzxKiTTbBVD4dj6RLW9ZBVfNh6rpYk
X-Proofpoint-GUID: ezghJ_ay3XYxpsJF7OtUizH5_6NFLikC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For QEMU, the majority of the work in enabling instruction interpretation       
is handled via a new KVM ioctls to enable interpretation, interrupt             
forwarding and registration of the guest IOAT tables.  In order to make         
use of the KVM-managed IOMMU domain operations on the host, we also add         
some code to vfio to indicate that a given device wishes to register the        
alternate domain type for its group.                                            
                                                                                
This series also adds a new, optional 'interpret' parameter to zpci which       
can be used to disable interpretation support (interpret=off) as well as        
an 'forwarding_assist' parameter to determine whether or not the firmware       
assist will be used for interrupt delivery (default when interpretation         
is in use) or whether the host will be responsible for delivering all           
interrupts (forwarding_assist=off).                                             
                                                                                
The ZPCI_INTERP CPU feature is added beginning with the z14 model to            
enable this support.                                                            
                                                                                
As a consequence of implementing zPCI interpretation, ISM devices now           
become eligible for passthrough (but only when zPCI interpretation is           
available).                                                                     
                                                                                
From the perspective of guest configuration, you passthrough zPCI devices       
in the same manner as before, with intepretation support being used by          
default if available in kernel+qemu.                                            
                                                                                
Associated kernel series:                                                       
https://lore.kernel.org/kvm/20220314194451.58266-1-mjrosato@linux.ibm.com/

Changelog v3->v4                                                                
- Unfortunately I had to remove some Review tags because the userspace API      
  moved from vfio device feature ioctls to KVM ioctls in response to            
  feedback from the kernel series.  The vast majority of the QEMU logic         
  remains intact however, with most changes being to the way we issue           
  ioctls.                                                                       
- Additional logic was added to test for availability of the KVM ioctl,         
  this replaces the probe logic done for the vfio ioctls                        
- Add code to issue indicate on VFIO_SET_IOMMU that a KVM-managed IOMMU         
  domain is to be allocated.       

Matthew Rosato (11):
  Update linux headers
  vfio: handle KVM-owned IOMMU requests
  target/s390x: add zpci-interp to cpu models
  s390x/pci: add routine to get host function handle from CLP info
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: use KVM-managed IOMMU for interpretation
  s390x/pci: use I/O Address Translation assist when interpreting
  s390x/pci: use dtsm provided from vfio capabilities for interpreted
    devices
  s390x/pci: let intercept devices have separate PCI groups

 hw/s390x/meson.build                |   1 +
 hw/s390x/s390-pci-bus.c             | 125 ++++++++++++++++++++--
 hw/s390x/s390-pci-inst.c            | 136 +++++++++++++++++++++--
 hw/s390x/s390-pci-kvm.c             | 160 ++++++++++++++++++++++++++++
 hw/s390x/s390-pci-vfio.c            | 151 ++++++++++++++++++++++----
 hw/s390x/s390-virtio-ccw.c          |   1 +
 hw/vfio/ap.c                        |   2 +-
 hw/vfio/ccw.c                       |   2 +-
 hw/vfio/common.c                    |  26 ++++-
 hw/vfio/pci.c                       |   3 +-
 hw/vfio/pci.h                       |   1 +
 hw/vfio/platform.c                  |   2 +-
 include/hw/s390x/s390-pci-bus.h     |   8 +-
 include/hw/s390x/s390-pci-inst.h    |   2 +-
 include/hw/s390x/s390-pci-kvm.h     |  68 ++++++++++++
 include/hw/s390x/s390-pci-vfio.h    |  11 ++
 include/hw/vfio/vfio-common.h       |   4 +-
 linux-headers/asm-s390/kvm.h        |   1 +
 linux-headers/asm-x86/kvm.h         |   3 +
 linux-headers/linux/kvm.h           |  51 ++++++++-
 linux-headers/linux/vfio.h          |   6 ++
 linux-headers/linux/vfio_zdev.h     |   6 ++
 target/s390x/cpu_features_def.h.inc |   1 +
 target/s390x/gen-features.c         |   2 +
 target/s390x/kvm/kvm.c              |   8 ++
 target/s390x/kvm/kvm_s390x.h        |   1 +
 26 files changed, 731 insertions(+), 51 deletions(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

-- 
2.27.0

