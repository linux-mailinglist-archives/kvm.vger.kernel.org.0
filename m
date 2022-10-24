Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F2F60B41E
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 19:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiJXR3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 13:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiJXR3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 13:29:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE799895F2;
        Mon, 24 Oct 2022 09:05:10 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OFHhIY008273;
        Mon, 24 Oct 2022 16:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=cSBjRI2Tla03lkvgJJSHtdC8Er8iUaZ9m1+YWH6z0dQ=;
 b=oWIpMMvy5WXQ4PIIwXBhhQaPRT0/FiJ/pQRnbPZ+KBXk3cXAQv6WII+lvAaLjWT1Pxhi
 p6aGE3Jd5brWbOlu88aj3nQjHm913UZa7dL9quFebAEdUpBn9xxwGLrEo7r93cjLRa2w
 2GQDjXSMCmCaHKhzdaKWAI3Dv3wNorLe9PBJW55LepAA8ELpJkcmwCfJGmoXE8V952fe
 XyL6xt3MtRkmUDhmls0i91y8N1lYhI3lC3q23F3VBxHjfIoLDyjSARCpdPSaHX2ZoalG
 tzRB2GAVJs84Y7QUqF542LmpToCdXTa7eHE1aOc1efrg0J2dHoCb8U2esdYpx6M125ep hg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdw7dhr2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 16:02:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OFo8Zl000342;
        Mon, 24 Oct 2022 16:02:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3kc7sj2nkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 16:02:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OG2cmt4391674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 16:02:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ACA2AE04D;
        Mon, 24 Oct 2022 16:02:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF56BAE045;
        Mon, 24 Oct 2022 16:02:37 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 16:02:37 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [v1] KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
Date:   Mon, 24 Oct 2022 18:02:37 +0200
Message-Id: <20221024160237.33912-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -vkrPUleVb1gjwVtETmLhatzQgj1KZj8
X-Proofpoint-ORIG-GUID: -vkrPUleVb1gjwVtETmLhatzQgj1KZj8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=967 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
page. This currently works, because virtual and physical addresses are
the same. Use page_to_phys() instead to resolve the virtual-real address
confusion.

One caller of pin_guest_page() actually expected the hpa to be a hva, so
add the missing phys_to_virt() conversion here.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..c6a10ff46d58 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
 	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
 	if (is_error_page(page))
 		return -EINVAL;
-	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
+	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
 	return 0;
 }
 
@@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 		WARN_ON_ONCE(rc);
 		return 1;
 	}
-	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
+	vsie_page->scb_o = (struct kvm_s390_sie_block *)phys_to_virt(hpa);
 	return 0;
 }
 
-- 
2.37.3

