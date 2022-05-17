Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2923C52AA16
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 20:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351808AbiEQSJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 14:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiEQSJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 14:09:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2E75FB8;
        Tue, 17 May 2022 11:09:07 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HHuj7S032306;
        Tue, 17 May 2022 18:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=lZFnxU6GEX5YViFl4HPs4Icmctdn4XUXeWdOlmCpBqI=;
 b=QJPxroUWOl7U/e0Sj75xbp+o88cRZji5Oj7CRaL/Cp9v/7F55yT+phD+bPuDDd9rdYVh
 TR2jHE7Uyun/vqjI/VFfour4iWTs3PZjw0WiYbdoTpUugmoJRPac1PqNTMgragcgMWli
 b89L9WdNoBtfhU2mjjIJ0YuvH/3+U08OcDx2p4L5S1UdQWMKgpdQUPLdNPDzeVNH29Wp
 iuybvA7sgUFyjxJsSccP0yaIdsqVXGLvjPlnCUPrKC9S9baTj53bUBAZEsG4/ZrJrztw
 cQwaEQRRkMH2Hl7I1Do3OJBt3fhIaBG616NbXSjh3gNxN4gAd8+aHdvK9EH3JDngVH7r rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4gj40esf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:08:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HHvk73004564;
        Tue, 17 May 2022 18:08:58 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4gj40erg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:08:58 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HI8Z07005730;
        Tue, 17 May 2022 18:08:57 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3g242b4v30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:08:57 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HI8ube7078890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:08:56 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC5E9AE05F;
        Tue, 17 May 2022 18:08:56 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BAD5AE062;
        Tue, 17 May 2022 18:08:54 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.37.97])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 18:08:54 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     jgg@nvidia.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Date:   Tue, 17 May 2022 14:08:50 -0400
Message-Id: <20220517180851.166538-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qhZLpU9-0YZ89O6SOHMewEQV1JK1GVPw
X-Proofpoint-GUID: 9Pst9FCHRpDpoz83T36CDDZkW0241MAR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 mlxlogscore=765 bulkscore=0 clxscore=1011 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170107
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

And tested with s390x-pci (zdev-kvm series) and vfio-ap (no GVT to test
with)

@Jason since it's based on your initial patch if you'd rather a SoB just
let me know.

Matthew Rosato (1):
  vfio: remove VFIO_GROUP_NOTIFY_SET_KVM

 drivers/gpu/drm/i915/gvt/gvt.h        |  2 -
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 60 +++++------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 35 +++-----------
 drivers/s390/crypto/vfio_ap_private.h |  3 --
 drivers/vfio/vfio.c                   | 68 +++++++++------------------
 include/linux/vfio.h                  |  5 +-
 6 files changed, 41 insertions(+), 132 deletions(-)

-- 
2.27.0

