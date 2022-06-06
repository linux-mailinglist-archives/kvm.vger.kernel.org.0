Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384F853F004
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiFFUjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbiFFUjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:39:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11ABB0D13
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 13:36:32 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KUtFN038532;
        Mon, 6 Jun 2022 20:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=CC6JtraPwaG1BaPQbsXEnimCvQdPEEqWr8I+1T+e0TE=;
 b=lVCjHXgwA369hZMaaLF8A4Uc9PlgrFBA+lgiuWwep0SapewZILqTLYlbPRfg0qacRjdF
 4BEfCho+H9i8i20E0VUDHUuFdzWL2s0vKCSWa+xuenh3aYchXnuLB+V77WKPrBJL1z/Q
 zj8jU5YSH7SX2SZw5d8WYXaM2k0kwYj6KPhj8Oe+r6HdG4s0dndIAtN4Q/a4+PykE0fY
 wpOTLTPkuH+VnCqaaQTIO/oh8r7Vbuf7jk/8clSym205ugQOGgvjN8rG9kjUa5phkV4y
 YXmm6ngTX36dYwrbctoNaVfXD2r9K7A3JQa0RGFhfryGeoCYeYPf35uroy3FGlHEXuRB Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs614h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:25 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KVKkd039825;
        Mon, 6 Jun 2022 20:36:25 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs614h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:25 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKNw5006013;
        Mon, 6 Jun 2022 20:36:24 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3gfy19ftuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:24 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KaNt622479290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:36:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC5752805C;
        Mon,  6 Jun 2022 20:36:23 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489FD28058;
        Mon,  6 Jun 2022 20:36:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:36:20 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 0/8] s390x/pci: zPCI interpretation support                
Date:   Mon,  6 Jun 2022 16:36:06 -0400
Message-Id: <20220606203614.110928-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v2xkGrF6LlBfedhNUcgX8o6RscFVfsDE
X-Proofpoint-GUID: xNYFqqktEf4OuBhrjTxwbfw2Gl2sXPc8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=711 impostorscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
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

The zpcii-disable machine property is added to allow disabling use of
zPCI interpretation facilities for a guest. This property is set to on
for older (pre-7.1 compat machines), but defaults to off for 7.1 and
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

Associated kernel series:
https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/

Changelog v6->v7:
- update linux header sync to 5.19-rc1 + latest kernel series
- Drop 'target/s390x: add zpci-interp to cpu models' (David)
- Add a new patch that adds the zpcii-disable machine property.
  zpcii-disable=on can be used to force interpretation facilities off
  for the guest.  With this series, 7.1 machine and newer will default
  this to off, meaning interpretation will be allowed if available by
  default.  7.0 and older machines will default to zpcii-disable=on.
  zPCI interpretation will only be used when the underlying kernel
  supports it, hardware facilties are available and zpcii-disable=off.

Matthew Rosato (8):
  Update linux headers
  s390x/pci: add routine to get host function handle from CLP info
  s390x/pci: enable for load/store intepretation
  s390x/pci: don't fence interpreted devices without MSI-X
  s390x/pci: enable adapter event notification for interpreted devices
  s390x/pci: let intercept devices have separate PCI groups
  s390x/pci: reflect proper maxstbl for groups of interpreted devices
  s390x/s390-virtio-ccw: add zpcii-disable machine property

 hw/s390x/meson.build                         |   1 +
 hw/s390x/s390-pci-bus.c                      | 111 +++++++++++++++-
 hw/s390x/s390-pci-inst.c                     |  56 +++++++-
 hw/s390x/s390-pci-kvm.c                      |  54 ++++++++
 hw/s390x/s390-pci-vfio.c                     | 129 ++++++++++++++++---
 hw/s390x/s390-virtio-ccw.c                   |  24 ++++
 include/hw/s390x/s390-pci-bus.h              |   8 +-
 include/hw/s390x/s390-pci-kvm.h              |  38 ++++++
 include/hw/s390x/s390-pci-vfio.h             |   5 +
 include/hw/s390x/s390-virtio-ccw.h           |   1 +
 include/standard-headers/asm-x86/bootparam.h |   1 +
 include/standard-headers/drm/drm_fourcc.h    |  69 ++++++++++
 include/standard-headers/linux/ethtool.h     |   1 +
 include/standard-headers/linux/input.h       |   1 +
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |  11 +-
 include/standard-headers/linux/virtio_ids.h  |  14 +-
 linux-headers/asm-arm64/kvm.h                |  27 ++++
 linux-headers/asm-generic/unistd.h           |   4 +-
 linux-headers/asm-riscv/kvm.h                |  20 +++
 linux-headers/asm-riscv/unistd.h             |   3 +-
 linux-headers/asm-x86/kvm.h                  |  11 +-
 linux-headers/asm-x86/mman.h                 |  14 --
 linux-headers/linux/kvm.h                    |  85 +++++++++++-
 linux-headers/linux/userfaultfd.h            |  10 +-
 linux-headers/linux/vfio.h                   |   4 +-
 linux-headers/linux/vfio_zdev.h              |   7 +
 linux-headers/linux/vhost.h                  |  26 +++-
 qemu-options.hx                              |   8 +-
 target/s390x/kvm/kvm.c                       |   7 +
 target/s390x/kvm/kvm_s390x.h                 |   1 +
 util/qemu-config.c                           |   4 +
 32 files changed, 683 insertions(+), 73 deletions(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

-- 
2.27.0

