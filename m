Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2F5536B7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352903AbiFUPwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352026AbiFUPwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:52:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7542D1D8;
        Tue, 21 Jun 2022 08:52:03 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFoaqr017027;
        Tue, 21 Jun 2022 15:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JjiCIvKrXQsRFjYwo+9FkFa/7IxAweALsDhLyS0TsJA=;
 b=jB3bApJdXHh3ovihwyNSgFUP3lW3cKQBG0gkHeb65l6CGZJPj5kNXM63JJPf8dLnNnKo
 ANythxxMEZyQ6vgz705UKQF5LV4vNuEi9CoWhYq6IIjXyHWiB2R/2ZVm8NE//C+ZrXpZ
 WLTHAYz/tPmUDp4R/tIu9Fkd9bEnYXNBEvgG2yZRTDQ4ifW0t75sM7hh/k6HHyEEjs5z
 GdbmIPp2WDi/CE98sEg0L/Xk10AawF7rHKH1iPRfzC/lB1Ay5dz7Q2jez1EQlPiYhCfc
 qTg+s2GpzUnUT3mxXdYD1dFGIvFf2w8dcGSS/nDfIXNvdUNzRaTg9Ti8CcggHYzH6WuZ Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh0281dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:52:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFoaOK017055;
        Tue, 21 Jun 2022 15:52:00 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh0281de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:52:00 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFaIec013910;
        Tue, 21 Jun 2022 15:51:59 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3gs6b9muae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:59 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpwBl26608054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:58 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 621D3136055;
        Tue, 21 Jun 2022 15:51:58 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6078B13605D;
        Tue, 21 Jun 2022 15:51:57 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:57 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 19/20] s390/Docs: new doc describing lock usage by the vfio_ap device driver
Date:   Tue, 21 Jun 2022 11:51:33 -0400
Message-Id: <20220621155134.1932383-20-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ntC656unWBR8-vSNTrFn9Jkimhccj3Jg
X-Proofpoint-GUID: njDiD-YS_a3EXnWIcgVY9fNYUM-kfxXe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=971 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a new document describing the locks used by the vfio_ap device
driver and how to use them so as to avoid lockdep reports and deadlock
situations.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 Documentation/s390/vfio-ap-locking.rst | 105 +++++++++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 Documentation/s390/vfio-ap-locking.rst

diff --git a/Documentation/s390/vfio-ap-locking.rst b/Documentation/s390/vfio-ap-locking.rst
new file mode 100644
index 000000000000..c4e1eeec79a0
--- /dev/null
+++ b/Documentation/s390/vfio-ap-locking.rst
@@ -0,0 +1,105 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+VFIO AP Locks Overview
+======================
+This document describes the locks that are pertinent to the secure operation
+of the vfio_ap device driver. Throughout this document, the following variables
+will be used to denote instances of the structures herein described:
+
+struct ap_matrix_dev *matrix_dev;
+struct ap_matrix_mdev *matrix_mdev;
+struct kvm *kvm;
+
+The Matrix Devices Lock (drivers/s390/crypto/vfio_ap_private.h)
+--------------------------------------------------------------
+
+struct ap_matrix_dev {
+	...
+	struct list_head mdev_list;
+	struct mutex mdevs_lock;
+	...
+}
+
+The Matrix Devices Lock (matrix_dev->mdevs_lock) is implemented as a global
+mutex contained within the single object of struct ap_matrix_dev. This lock
+controls access to all fields contained within each matrix_mdev
+(matrix_dev->mdev_list). This lock must be held while reading from, writing to
+or using the data from a field contained within a matrix_mdev instance
+representing one of the vfio_ap device driver's mediated devices.
+
+The KVM Lock (include/linux/kvm_host.h)
+---------------------------------------
+
+struct kvm {
+	...
+	struct mutex lock;
+	...
+}
+
+The KVM Lock (kvm->lock) controls access to the state data for a KVM guest. This
+lock must be held by the vfio_ap device driver while one or more AP adapters,
+domains or control domains are being plugged into or unplugged from the guest.
+
+The KVM pointer is stored in the in the matrix_mdev instance
+(matrix_mdev->kvm = kvm) containing the state of the mediated device that has
+been attached to the KVM guest.
+
+The Guests Lock (drivers/s390/crypto/vfio_ap_private.h)
+-----------------------------------------------------------
+
+struct ap_matrix_dev {
+	...
+	struct list_head mdev_list;
+	struct mutex guests_lock;
+	...
+}
+
+The Guests Lock (matrix_dev->guests_lock) controls access to the
+matrix_mdev instances (matrix_dev->mdev_list) that represent mediated devices
+that hold the state for the mediated devices that have been attached to a
+KVM guest. This lock must be held:
+
+1. To control access to the KVM pointer (matrix_mdev->kvm) while the vfio_ap
+   device driver is using it to plug/unplug AP devices passed through to the KVM
+   guest.
+
+2. To add matrix_mdev instances to or remove them from matrix_dev->mdev_list.
+   This is necessary to ensure the proper locking order when the list is perused
+   to find an ap_matrix_mdev instance for the purpose of plugging/unplugging
+   AP devices passed through to a KVM guest.
+
+   For example, when a queue device is removed from the vfio_ap device driver,
+   if the adapter is passed through to a KVM guest, it will have to be
+   unplugged. In order to figure out whether the adapter is passed through,
+   the matrix_mdev object to which the queue is assigned will have to be
+   found. The KVM pointer (matrix_mdev->kvm) can then be used to determine if
+   the mediated device is passed through (matrix_mdev->kvm != NULL) and if so,
+   to unplug the adapter.
+
+It is not necessary to take the Guests Lock to access the KVM pointer if the
+pointer is not used to plug/unplug devices passed through to the KVM guest;
+however, in this case, the Matrix Devices Lock (matrix_dev->mdevs_lock) must be
+held in order to access the KVM pointer since it is set and cleared under the
+protection of the Matrix Devices Lock. A case in point is the function that
+handles interception of the PQAP(AQIC) instruction sub-function. This handler
+needs to access the KVM pointer only for the purposes of setting or clearing IRQ
+resources, so only the matrix_dev->mdevs_lock needs to be held.
+
+The PQAP Hook Lock (arch/s390/include/asm/kvm_host.h)
+-----------------------------------------------------
+
+typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
+
+struct kvm_s390_crypto {
+	...
+	struct rw_semaphore pqap_hook_rwsem;
+	crypto_hook *pqap_hook;
+	...
+};
+
+The PQAP Hook Lock is a r/w semaphore that controls access to the function
+pointer of the handler (*kvm->arch.crypto.pqap_hook) to invoke when the
+PQAP(AQIC) instruction sub-function is intercepted by the host. The lock must be
+held in write mode when pqap_hook value is set, and in read mode when the
+pqap_hook function is called.
-- 
2.35.3

