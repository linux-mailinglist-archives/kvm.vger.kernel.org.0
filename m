Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A825AB779
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbiIBR1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiIBR1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:27:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415167CB6
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:27:48 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282GpNC7015658;
        Fri, 2 Sep 2022 17:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=CozVj0g0GyNgm2sc/Ugcz/RuZrKe8VI4rAjngT+s1cE=;
 b=E3rTvy4vm7Q9ZVqeeMhXz8daQr1K+n3mzDMmrtwtizIt8aer0cORsjctjKjqeu5zk0ia
 w7DdqZSij5Qh070sHLBT/nzHtL68ATLe3kfSQwOr3o2+s6MpqnZqAL2WE01wKqEZgsHN
 J9a1EhEB4UhkLsZhL+qMeEOANPCi6AukvwiNB1aBQc5b84L6vuJbOWYKFhRbf1ryzBWP
 BZyEqyM2Rch8M1lj0fRUPFsPgn+wT+4Moqi0/3doKVOM+GkzZPgA+72U/QetS0koaAGc
 2crejeRtM4BHMlavWLZGzrkAfqwo5Ki8AIDC3ysiSPN/G+OTYiMB95JsKzgcq46L0CFp Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnqj8w7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:42 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 282HQfAE008054;
        Fri, 2 Sep 2022 17:27:42 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnqj8w7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:41 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 282HKEER007737;
        Fri, 2 Sep 2022 17:27:41 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3j7awabjur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:41 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 282HRd5U5046808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 17:27:39 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E9306E052;
        Fri,  2 Sep 2022 17:27:39 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 219B76E04E;
        Fri,  2 Sep 2022 17:27:38 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.86.252])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 17:27:37 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v8 0/8] s390x/pci: zPCI interpretation support                
Date:   Fri,  2 Sep 2022 13:27:29 -0400
Message-Id: <20220902172737.170349-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hLwWS4Ls5MoKYDDH0IlC5UJYwC2nb_dU
X-Proofpoint-ORIG-GUID: PBuHoWS1uCJWM7wJO69CcT0lJKK9jVsq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_04,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=918 malwarescore=0 spamscore=0 clxscore=1011 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the kernel series [1] is merged and the freeze is over, here is a
refresh of the zPCI interpretation series. 
                                                           
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

The zpcii-disable machine property is added to allow disabling use of
zPCI interpretation facilities for a guest. This property is set to on
for older (pre-7.2 compat machines), but defaults to off for 7.2 and
newer. This allows newer machines to use interpretation by default if
the necessary kernel interfaces and hardware facilities are available,
but also provides a mechanism for disabling interpretation completely
for debug purposes.

As a consequence of implementing zPCI interpretation, ISM devices now
become eligible for passthrough (but only when zPCI interpretation is
available).

From the perspective of guest configuration, you passthrough zPCI devices
in the same manner as before, with intepretation support being used by
default if available in kernel+qemu.

Changelog v7->v8:
- Rebase onto 7.1.0
- Move compat machine changes for patch 8
- Refresh kernel header sync to 6.0-rc3                     

[1] https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/

Matthew Rosato (8):
  linux-headers: update to 6.0-rc3
  s390x/pci: add routine to get host function handle from CLP info
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: let intercept devices have separate PCI groups
  s390x/pci: reflect proper maxstbl for groups of interpreted devices
  s390x/s390-virtio-ccw: add zpcii-disable machine property

 hw/s390x/meson.build                          |   1 +
 hw/s390x/s390-pci-bus.c                       | 111 ++++++++++-
 hw/s390x/s390-pci-inst.c                      |  56 +++++-
 hw/s390x/s390-pci-kvm.c                       |  54 ++++++
 hw/s390x/s390-pci-vfio.c                      | 129 +++++++++++--
 hw/s390x/s390-virtio-ccw.c                    |  25 +++
 include/hw/s390x/s390-pci-bus.h               |   8 +-
 include/hw/s390x/s390-pci-kvm.h               |  38 ++++
 include/hw/s390x/s390-pci-vfio.h              |   5 +
 include/hw/s390x/s390-virtio-ccw.h            |   1 +
 include/standard-headers/asm-x86/bootparam.h  |   7 +-
 include/standard-headers/drm/drm_fourcc.h     |  73 +++++++-
 include/standard-headers/linux/ethtool.h      |  29 +--
 include/standard-headers/linux/input.h        |  12 +-
 include/standard-headers/linux/pci_regs.h     |  30 ++-
 include/standard-headers/linux/vhost_types.h  |  17 +-
 include/standard-headers/linux/virtio_9p.h    |   2 +-
 .../standard-headers/linux/virtio_config.h    |   7 +-
 include/standard-headers/linux/virtio_ids.h   |  14 +-
 include/standard-headers/linux/virtio_net.h   |  34 +++-
 include/standard-headers/linux/virtio_pci.h   |   2 +
 include/standard-headers/linux/virtio_ring.h  |  16 +-
 linux-headers/asm-arm64/kvm.h                 |  33 +++-
 linux-headers/asm-generic/unistd.h            |   4 +-
 linux-headers/asm-riscv/kvm.h                 |  22 +++
 linux-headers/asm-riscv/unistd.h              |   3 +-
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-x86/kvm.h                   |  33 ++--
 linux-headers/asm-x86/mman.h                  |  14 --
 linux-headers/linux/kvm.h                     | 172 +++++++++++++++++-
 linux-headers/linux/userfaultfd.h             |  10 +-
 linux-headers/linux/vduse.h                   |  47 +++++
 linux-headers/linux/vfio.h                    |   4 +-
 linux-headers/linux/vfio_zdev.h               |   7 +
 linux-headers/linux/vhost.h                   |  35 +++-
 qemu-options.hx                               |   8 +-
 target/s390x/kvm/kvm.c                        |   7 +
 target/s390x/kvm/kvm_s390x.h                  |   1 +
 util/qemu-config.c                            |   4 +
 39 files changed, 955 insertions(+), 121 deletions(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

-- 
2.37.2

