Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0190253313B
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbiEXTE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240838AbiEXTEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:04:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4903D9EB59
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:03:42 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIIVrq028478;
        Tue, 24 May 2022 19:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=HbJM3KWUBbR+g1EEvYVqV5pvjbE9Y6NQc5NCaKJ4vNk=;
 b=FX5lcqBCTX9JoRDmQGGixtvKYIXGlc++HJzWhEP+OxU1PSsOHBYSpwy8VfseNfcA6OhS
 XJ1RlMd4xpT3ttbjVj1O1hM7l3j0EAJbgzFWqkNEAF6m3FR300rXTmTrP/POgNbwRqa3
 K2wFdXLbwowqRilXtguZ0z+2CmAObzdy8qOaC8Jd4AWOdUqRfzvHTO4NZrUcii71YFml
 Zt3nIIsKR42FCPUVBsbroNr1eQeL4rUuIwy9fY5pvaua/vM/1I3mHxOyVvf58AS8W4JA
 fRWv5yAKZqH6HujdTsnfP5tQduCKl4ITIbM13ln86JZtdztLdj4tvvzlBgBu2KvET1FB ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hd0sdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIJMIT032665;
        Tue, 24 May 2022 19:03:19 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hd0sd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:19 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIrwR3011951;
        Tue, 24 May 2022 19:03:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3g93ut8qcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:18 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ3H0326411448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:03:17 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02D38124052;
        Tue, 24 May 2022 19:03:17 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58EB412405A;
        Tue, 24 May 2022 19:03:13 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:03:13 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 0/8] s390x/pci: zPCI interpretation support                
Date:   Tue, 24 May 2022 15:02:57 -0400
Message-Id: <20220524190305.140717-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NGq1p70JZ31y0wUWPCs_752H-XHyzxU5
X-Proofpoint-GUID: xVRXw3okr8ZjfJii8GoCTWCkkgm6boti
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=740 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For QEMU, the majority of the work in enabling instruction interpretation       
is handled via SHM bit settings (to indicate to firmware whether or not
interpretive execution facilities are to be used) + a new KVM ioctl is
used to setup firmware-interpreted forwarding of Adapter Event
Notifications.                                        
                                                                                
This series also adds a new, optional 'interpret' parameter to zpci which       
can be used to disable interpretation support (interpret=off) as well as        
an 'forwarding_assist' parameter to determine whether or not the firmware       
assist will be used for adapter event delivery (default when
interpretation is in use) or whether the host will be responsible for
delivering all adapter event notifications (forwarding_assist=off).
                                                                                
The ZPCI_INTERP CPU feature is added beginning with the z14 model to            
enable this support.                                                            
                                                                                
As a consequence of implementing zPCI interpretation, ISM devices now           
become eligible for passthrough (but only when zPCI interpretation is           
available).                                                                     
                                                                                
From the perspective of guest configuration, you passthrough zPCI devices       
in the same manner as before, with intepretation support being used by          
default if available in kernel+qemu.                                            
                                                                                
Associated kernel series:                                                       
https://lore.kernel.org/kvm/20220524185907.140285-1-mjrosato@linux.ibm.com/                             
                       
Changelog v5->v6:
- Update linux headers (KVM_CAP_S390_ZPCI_OP changed)
- Move featoff to ccw_machine_7_0_instance_options() (Thomas)
- s390_pci_get_host_fh: s/unsigned int/uint32_t/ (Thomas)
- s390_pci_kvm_interp_allowed: add !s390_is_pv() check (Pierre)
- Fail guest SET PCI FN (enable) if we cannot get the host fh
  or if the retrieved host FH is not enabled (Pierre)
- bugfix: don't free msix if we never initialized it

Matthew Rosato (8):
  Update linux headers
  target/s390x: add zpci-interp to cpu models
  s390x/pci: add routine to get host function handle from CLP info
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: let intercept devices have separate PCI groups
  s390x/pci: reflect proper maxstbl for groups of interpreted devices

 hw/s390x/meson.build                |   1 +
 hw/s390x/s390-pci-bus.c             | 111 ++++++++++++++++++++++--
 hw/s390x/s390-pci-inst.c            |  56 +++++++++++-
 hw/s390x/s390-pci-kvm.c             |  53 ++++++++++++
 hw/s390x/s390-pci-vfio.c            | 129 +++++++++++++++++++++++-----
 hw/s390x/s390-virtio-ccw.c          |   1 +
 include/hw/s390x/s390-pci-bus.h     |   8 +-
 include/hw/s390x/s390-pci-kvm.h     |  38 ++++++++
 include/hw/s390x/s390-pci-vfio.h    |   5 ++
 linux-headers/asm-s390/kvm.h        |   1 +
 linux-headers/linux/kvm.h           |  32 +++++++
 linux-headers/linux/vfio.h          |   4 +-
 linux-headers/linux/vfio_zdev.h     |   7 ++
 target/s390x/cpu_features_def.h.inc |   1 +
 target/s390x/gen-features.c         |   2 +
 target/s390x/kvm/kvm.c              |   8 ++
 target/s390x/kvm/kvm_s390x.h        |   1 +
 17 files changed, 426 insertions(+), 32 deletions(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

-- 
2.27.0

