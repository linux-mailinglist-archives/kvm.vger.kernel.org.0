Return-Path: <kvm+bounces-31938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C609CE0C0
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 14:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EDFE1F21205
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 13:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F73C1CF7AF;
	Fri, 15 Nov 2024 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UnOAfArd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24BC1CEAD3;
	Fri, 15 Nov 2024 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731678985; cv=none; b=kjwgSBXyk6lT2/Sg8A1HZ/nWnpjjsXCDSWb02JoRMP+SItkdlSJoJSOcDAALd/0aF5UkJSrNyPDcsH4gREbRzZdPTvS2WgZ1lwjxVhoXPj/Tm2bHVOIl+RbMPejNtQqwM5HgKTBNufhLFtiH/mLPRIMBKiO+mMLGR+yPF6YU0d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731678985; c=relaxed/simple;
	bh=JI8YdmdDuxzVT7VJan0710NwIlBYfBa4zQXHL369xJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cOc6lsGwD1aFzyLhjbUXIu7H3XrqSXWbV9r66rYVtghRj2TrWzAlO0aS48+kd4FNU7vNoiifeBj9ugLmifdPvm15fGkLybchLDHdqfus2U8x/7vy5wLypd87kl47BL5ZqvBr+Clu4icnU1As1HiyXDi6RJ8QrCMMSJijs4UXNgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UnOAfArd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYZot004840;
	Fri, 15 Nov 2024 13:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=jMG5e+eCpRAtlTm2d3DZi6QRFLOEn0rnI4AP5D0dp
	Fs=; b=UnOAfArdlq5GPygU7ECA9cbFYg1a/6v0/ZkOyS0UIyzuwP9mI1OMakmvP
	35IHv7Q7V33q7lBAkFRpDyqJ3kdKE4ll+a5G12qYC1nMkR5d/K8p7976ejXt3/Tw
	sYO8TOV8KRvU82OKby1KhIL2Jo1qmgZOUWigZbSXZAEGk97t0O5FmUZC0U2vtNvu
	F+0+8tfq4j3M0hrBWT1nC5clLn+YN8al0yc5o1IR4nAAimz3Tb0s/J3ea8iQE3mg
	wG71KkeROhGDLGwpnVVon6lvcv5uOj6jXRraVN4tuVHrF+czn1YDE4M1FduvOT0S
	mn4tHJzhmmrHpABYTYGwcrkhlsIyA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wren40vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 13:56:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDo6oo029734;
	Fri, 15 Nov 2024 13:56:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjmt84a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 13:56:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFDuHJ256623476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 13:56:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD2C220043;
	Fri, 15 Nov 2024 13:56:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF03720040;
	Fri, 15 Nov 2024 13:56:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.57.75])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 13:56:16 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        freude@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@de.ibm.com, svens@linux.ibm.com,
        frankja@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [PATCH v1 1/1] s390/vfio-ap: remove gmap_convert_to_secure from vfio_ap_ops
Date: Fri, 15 Nov 2024 14:56:11 +0100
Message-ID: <20241115135611.87836-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rkl9u0x4CB4cOvPko5K6OP-HjVXKbYrM
X-Proofpoint-ORIG-GUID: rkl9u0x4CB4cOvPko5K6OP-HjVXKbYrM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150116

If the page has been exported, do not re-import it. Imports should
only be triggered by the guest. The guest will import the page
automatically when it will need it again, there is no advantage in
importing it manually.

Moreover, vfio_pin_pages() will take an extra reference on the page and
thus will cause the import to always fail. The extra reference would be
dropped only after pointlessly trying to import the page.

Fixes: f88fb1335733 ("s390/vfio-ap: make sure nib is shared")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 32 +++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9f76f2d7b66e..ace1b332c930 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -360,10 +360,26 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 	return 0;
 }
 
-static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
+/**
+ * ensure_nib_shared() - Ensure the address of the NIB is secure and shared
+ * @addr: the physical (absolute) address of the NIB
+ *
+ * This function checks whether the NIB page, which has been pinned with
+ * vfio_pin_pages(), is a shared page belonging to a secure guest.
+ *
+ * It will call uv_pin_shared() on it; if the page was already pinned shared
+ * (i.e. if the NIB belongs to a secure guest and is shared), then 0
+ * (success) is returned. If the NIB was not shared, vfio_pin_pages() had
+ * exported it and now it does not belong to the secure guest anymore. In
+ * that case, an error is returned.
+ *
+ * Context: the NIB (at physical address @addr) has to be pinned with
+ *          vfio_pin_pages() before calling this function.
+ *
+ * Return: 0 in case of success, otherwise an error < 0.
+ */
+static int ensure_nib_shared(unsigned long addr)
 {
-	int ret;
-
 	/*
 	 * The nib has to be located in shared storage since guest and
 	 * host access it. vfio_pin_pages() will do a pin shared and
@@ -374,12 +390,7 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
 	 *
 	 * If the page is already pinned shared the UV will return a success.
 	 */
-	ret = uv_pin_shared(addr);
-	if (ret) {
-		/* vfio_pin_pages() likely exported the page so let's re-import */
-		gmap_convert_to_secure(gmap, addr);
-	}
-	return ret;
+	return uv_pin_shared(addr);
 }
 
 /**
@@ -425,6 +436,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		return status;
 	}
 
+	/* The pin will probably be successful even if the NIB was not shared */
 	ret = vfio_pin_pages(&q->matrix_mdev->vdev, nib, 1,
 			     IOMMU_READ | IOMMU_WRITE, &h_page);
 	switch (ret) {
@@ -447,7 +459,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 
 	/* NIB in non-shared storage is a rc 6 for PV guests */
 	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
-	    ensure_nib_shared(h_nib & PAGE_MASK, kvm->arch.gmap)) {
+	    ensure_nib_shared(h_nib & PAGE_MASK)) {
 		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
 		return status;
-- 
2.47.0


