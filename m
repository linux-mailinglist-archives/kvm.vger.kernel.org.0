Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C248D66310F
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 21:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbjAIULW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 15:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbjAIULA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 15:11:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71C7767F;
        Mon,  9 Jan 2023 12:10:53 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309JuEd7007452;
        Mon, 9 Jan 2023 20:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WbMDgdUJZVKJs0Nl9/VYi0q97VLNPhEA1RGhIIXexw4=;
 b=tICUTTr25xyQuaVIfVsGyhVM3CaIMsA4ASISY+XYNFT6hzBme/UIOlxZ367da1OIEEqr
 sOQ/n0nGWPCf9F0JptTssk+P0mma08DiuHwqn8IylSE6eKiV3feBtwcHCAiJY8BUNEoV
 jrI/ZfzfT1a8LEL3dtUdA2BWE9dxbQ39gf/fI+G6RInnWnY8MEhahe+O/UZXN3Ayzh62
 8XmRJmBf8gIsbpnR4XX2bf6hkQO0c7X3PcwS3oZ1t39DBJlUVeihOfVgEQ6vmhtQY7Bt
 /ac8A9WUbhz3JvqDabAObQqr4Le03mkIuaqmv1zckMeszyksbl/YvE8se4SD8/ZywQDb zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjw3qdqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:48 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309Jt5o8015678;
        Mon, 9 Jan 2023 20:10:48 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjw3qdq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:48 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 309IIJIf007444;
        Mon, 9 Jan 2023 20:10:47 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3my0c75qk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:47 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309KAkr826804658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 20:10:46 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF68958054;
        Mon,  9 Jan 2023 20:10:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 815195803F;
        Mon,  9 Jan 2023 20:10:43 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.251.44])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 20:10:43 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: s390: pci: use asyncronous kvm put
Date:   Mon,  9 Jan 2023 15:10:37 -0500
Message-Id: <20230109201037.33051-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109201037.33051-1-mjrosato@linux.ibm.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Oy22cas3PYwW1KMUoEHNyWu-S5fSk_fC
X-Proofpoint-GUID: uWY384HuphX1JMDaGrC_ZMgCEmJTwW4n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301090141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's possible that the kvm refcount will reach 0 at this point while the
associated device is still in kvm device list - this would result in a
deadlock on the vfio group lock.  Avoid this possibility by using
kvm_put_kvm_async to do the kvm_destroy_vm asynchronously.

Fixes: 09340b2fca00 ("KVM: s390: pci: add routines to start/stop interpretive execution")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index ec51e810e381..d1d528438138 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -509,7 +509,7 @@ static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
 		kvm_s390_pci_dev_release(zdev);
 	mutex_unlock(&kvm->lock);
 	mutex_unlock(&zdev->kzdev_lock);
-	kvm_put_kvm(kvm);
+	kvm_put_kvm_async(kvm);
 	return rc;
 }
 
@@ -567,7 +567,11 @@ static void kvm_s390_pci_unregister_kvm(void *opaque)
 	mutex_unlock(&kvm->lock);
 	mutex_unlock(&zdev->kzdev_lock);
 
-	kvm_put_kvm(kvm);
+	/*
+	 * Avoid possible deadlock on any currently-held vfio lock by
+	 * ensuring the potential kvm_destroy_vm call is done asynchronously
+	 */
+	kvm_put_kvm_async(kvm);
 }
 
 void kvm_s390_pci_init_list(struct kvm *kvm)
-- 
2.39.0

