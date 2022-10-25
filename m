Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D083360C64E
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiJYIVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiJYIUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:20:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9475DFC13;
        Tue, 25 Oct 2022 01:20:46 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P8FOkX023318;
        Tue, 25 Oct 2022 08:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SbmNTW4Xb+kGK0qFfNhn75uGSg7Pq7pAyAhuLoBLOSg=;
 b=f+6vafmwnGHncf8iyRwb2z/I/jqpN87F6xBuEWaJMvq7qCY7c6kDCPRoICENNnCWB+GW
 8fq2HHH5x4Ca9SCqtlS3FAVGYX0/h3oKfYy0WigQyREr1ONaPjfasEnKq0HGialFDfcN
 z/TDHpWz6Dln7BB5wSi+kuTAidUlo0ihQuwgNa+XaaS+9GSf6cExsf+VXIrb2gwRwRKY
 IZwnxgPq88Ofhg1PN1fwsUQ5iyOHvfecVXybZvSwLFy7bwbfyYT8YqPmll7NYvnho8l6
 W3uY/upobWx7x5TxcJhTy7C0QsJbZRUsKzPDUTA3loksKbNJ+nf57lhflSuGE5w+ghd/ Iw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kec4p84f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:20:46 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P8KOM0012191;
        Tue, 25 Oct 2022 08:20:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3kc7sj3mhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:20:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P8LFAR20775246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 08:21:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A36EFAE04D;
        Tue, 25 Oct 2022 08:20:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FBECAE058;
        Tue, 25 Oct 2022 08:20:40 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 08:20:40 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [v2 1/1] KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
Date:   Tue, 25 Oct 2022 10:20:39 +0200
Message-Id: <20221025082039.117372-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025082039.117372-1-nrb@linux.ibm.com>
References: <20221025082039.117372-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PYPDczW0jSEIsQzny5FJH35iXKVPbb54
X-Proofpoint-GUID: PYPDczW0jSEIsQzny5FJH35iXKVPbb54
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=992 suspectscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250046
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
index 94138f8f0c1c..0e9d020d7093 100644
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
+	vsie_page->scb_o = phys_to_virt(hpa);
 	return 0;
 }
 
-- 
2.37.3

