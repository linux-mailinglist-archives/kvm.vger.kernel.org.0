Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454F4786F7C
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbjHXMrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240170AbjHXMqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA9AE59;
        Thu, 24 Aug 2023 05:46:36 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgqLN020119;
        Thu, 24 Aug 2023 12:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=KMP/0iEuBdF8cdYBkFPfv8+HL5/LLlqDIMWCj8DhJv0=;
 b=tHdeLW13Aq5KTOXdqmPs0Tx66hwk8QLuX53zYDJVnPKax14wF04qSlj8qczziFTGoXiY
 6LEEA4ToveLFbuTu3DAqOw30/kxe0PopcYyH1qq8y+7Tl3yhAKXfJCSZSnww9d6+977M
 //NMDRu+SrLxeMKv4MIf/GhSim1Pg6BSJrMrtEYhZC2pSwOrAwynWYHoRBtGCi2KmNY2
 e2floyzQNzI0lBBU3ifcpFy/XRedkFeimMinPiXBxCpzR6TGhZTqirfVIMLIQx7ACnnu
 zA/wWa8oJQfsfNgW0LpjBPL1Du9uJ6SUHnVxj4BpmkD8Oltv0tD9PN4JvOZ9kh1PIsuy Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0hpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:34 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCgoak020020;
        Thu, 24 Aug 2023 12:46:30 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0h7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:30 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCR0ct018220;
        Thu, 24 Aug 2023 12:46:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sq04h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkMXc44499460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A8DA20043;
        Thu, 24 Aug 2023 12:46:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9877D2004B;
        Thu, 24 Aug 2023 12:46:21 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 18/22] s390/vfio-ap: make sure nib is shared
Date:   Thu, 24 Aug 2023 14:43:27 +0200
Message-ID: <20230824124522.75408-19-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OR1TxtxWkoICe2S_bwpTsnV3WhesGARQ
X-Proofpoint-GUID: BoR16pi8Xu2No94u5usnfw6xIXcwUQL5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=947
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20230815184333.6554-13-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
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
2.41.0

