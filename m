Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622E852C587
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 23:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbiERV0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 17:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243157AbiERV0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 17:26:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DE73BFB6;
        Wed, 18 May 2022 14:26:35 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IL37Yc011281;
        Wed, 18 May 2022 21:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=y7+InN4T1AhNfnrU+hjtQbi+AUPcRelZo9Aro4X0ebI=;
 b=Cmwc0+XWsZfiP+nmbI1Lgl131c8TUhy7H7ZNgfPLKnvGxTJBLwAfMeAtHQ37T1tsYO5c
 L0EG6zbdPYiIpS2ShYDHu4F7EjvMC2qYMN6NYpVlHX3KBscJzv6UI/H69fKjJDi+I3IU
 XQvaCp1gljf3OpxiHRW8toPAdSUcR4/n9jbbDFz061PtYk85nxmiM7NFlx3XuGRhAm8V
 fefudY7suiC57SqAIsryNJ0BtjMA7a66g8HqTcMIbs3WMHFWR1XdzwaQDsSPmQmQzS24
 HYfx2Sz4dqfDJ2zVniZTQhii3+ABMakAKQDsG56sz9Zkl/hpe8iuw4/0pd+Q/fPap80H lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g58cgrgap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 21:26:19 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ILJr2m009229;
        Wed, 18 May 2022 21:26:19 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g58cgrgac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 21:26:19 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IL2rtQ019537;
        Wed, 18 May 2022 21:26:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3g242af9se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 21:26:18 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24ILQHHC27328794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 21:26:17 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B5E528060;
        Wed, 18 May 2022 21:26:17 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C359E2805E;
        Wed, 18 May 2022 21:26:13 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.37.97])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 21:26:13 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     jgg@nvidia.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Date:   Wed, 18 May 2022 17:26:06 -0400
Message-Id: <20220518212607.467538-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QrOItCWy51AZo_qIJ1RCc4LMGLxnuhOY
X-Proofpoint-GUID: C7naun7PRSTlUTRKk_2a_XczLp56l8kd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=560 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As discussed in this thread:

https://lore.kernel.org/kvm/20220516172734.GE1343366@nvidia.com/

Let's remove VFIO_GROUP_NOTIFY_SET_KVM and instead assume the association
has already been established prior to device_open.  For the types today
that need a KVM (GVT, vfio-ap) these will fail if a KVM is not found.
Looking ahead, vfio-pci-zdev will optionally want the KVM association
(enable hardware assists) but it will not be a hard requirement (still
want to allow other, non-KVM userspace usage). 

This is built on top of Jason's group locking series:
https://github.com/jgunthorpe/linux/commits/vfio_group_locking

And tested with s390x-pci (zdev-kvm series) and vfio-ap (GVT changes are
compile-tested only)

Changes for v2:
- gvt no longer needs release_work, get rid of it (Christoph)
- a few compile fixes for gvt
- update commit to mention fixes gvt oops (Jason)
- s/down_write/down_read/ in a few spots (Jason)
- avoid kvm build dependency by holding group read lock over device
  open/close and put the onus on the driver to obtain a reference if
  it will actually use the kvm pointer.  Document the requirement,
  use lockdep_assert to ensure lock is held during register_notifer;
  today all callers are from driver open_device.

Matthew Rosato (1):
  vfio: remove VFIO_GROUP_NOTIFY_SET_KVM

 drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
 drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++---------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 38 ++++---------
 drivers/s390/crypto/vfio_ap_private.h |  3 -
 drivers/vfio/vfio.c                   | 75 ++++++++----------------
 include/linux/vfio.h                  |  5 +-
 7 files changed, 56 insertions(+), 154 deletions(-)

-- 
2.27.0

