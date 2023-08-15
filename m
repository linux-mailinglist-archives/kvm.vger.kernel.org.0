Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009BE77D246
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbjHOSob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbjHOSoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:44:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2524C19A0;
        Tue, 15 Aug 2023 11:43:59 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FISkPP009736;
        Tue, 15 Aug 2023 18:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b4qqs5p1+tL7145x1KZqgpgGY/eSyFNdpfmpDdEztJI=;
 b=exTDavLG3LMs1+eaLJn2RhDLHkX+0iTuvXihO8XoHjYKxqQ9NSCoa4g+PZnKeBDXJbGa
 xZGzf0gMnjHcjvgOK9BmMStlAe7/cRfgHQw464Fl6OsZEMb1ZW6D+E2q910vrsIP19IB
 Jd74fQ20XVtQW9ahkNukDbxGS/4o4j8knwIsdayHO0tnmLZsrWxVxMxnDMOIlzvphxyS
 tiFPGxXTgPzN1R9NvdK3WBHonIhw1X0DvrjzztNC5hmUu2qbi6kmMo24GR9UbVWzScYG
 VzpSx5jtsBYMtilKm4nWbYDvE1SoxpwTnXc0qvwbTWV73nBvBX671hXu8ABDn4z/Vl2R iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgep28bjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:55 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FITrlW012935;
        Tue, 15 Aug 2023 18:43:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgep28bjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:54 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FGtMFS013425;
        Tue, 15 Aug 2023 18:43:54 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sepmjphp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:54 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhqAF27919080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:53 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCF695804E;
        Tue, 15 Aug 2023 18:43:52 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83C195803F;
        Tue, 15 Aug 2023 18:43:51 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:51 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 12/12] s390/vfio-ap: Make sure nib is shared
Date:   Tue, 15 Aug 2023 14:43:33 -0400
Message-Id: <20230815184333.6554-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: no--9qH4NYYhmNF9p13et18N0fxfsoB-
X-Proofpoint-ORIG-GUID: wKKizstHSgvH-_M-3s6oBi0O_oF0ZkVE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the NIB is visible by HW, KVM and the (PV) guest it needs to be
in non-secure or secure but shared storage. Return code 6 is used to
indicate to a PV guest that its NIB would be on secure, unshared
storage and therefore the NIB address is invalid.

Unfortunately we have no easy way to check if a page is unshared after
vfio_pin_pages() since it will automatically export an unshared page
if the UV pin shared call did not succeed due to a page being in
unshared state.

Therefore we use the fact that UV pinning it a second time is a nop
but trying to pin an exported page is an error (0x102). If we
encounter this error, we do a vfio unpin and import the page again,
since vfio_pin_pages() exported it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8bda52c46df0..0509f80622cd 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -359,6 +359,28 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 	return 0;
 }
 
+static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
+{
+	int ret;
+
+	/*
+	 * The nib has to be located in shared storage since guest and
+	 * host access it. vfio_pin_pages() will do a pin shared and
+	 * if that fails (possibly because it's not a shared page) it
+	 * calls export. We try to do a second pin shared here so that
+	 * the UV gives us an error code if we try to pin a non-shared
+	 * page.
+	 *
+	 * If the page is already pinned shared the UV will return a success.
+	 */
+	ret = uv_pin_shared(addr);
+	if (ret) {
+		/* vfio_pin_pages() likely exported the page so let's re-import */
+		gmap_convert_to_secure(gmap, addr);
+	}
+	return ret;
+}
+
 /**
  * vfio_ap_irq_enable - Enable Interruption for a APQN
  *
@@ -422,6 +444,14 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 	h_nib = page_to_phys(h_page) | (nib & ~PAGE_MASK);
 	aqic_gisa.gisc = isc;
 
+	/* NIB in non-shared storage is a rc 6 for PV guests */
+	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
+	    ensure_nib_shared(h_nib & PAGE_MASK, kvm->arch.gmap)) {
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
+		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
+		return status;
+	}
+
 	nisc = kvm_s390_gisc_register(kvm, isc);
 	if (nisc < 0) {
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
-- 
2.39.3

