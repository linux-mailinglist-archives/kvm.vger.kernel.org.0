Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8FD5B097C
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIGQBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiIGQAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:00:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE02101D5;
        Wed,  7 Sep 2022 09:00:03 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287EsBCv004572;
        Wed, 7 Sep 2022 15:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5X3aRCOkL9BSkw+8LikzyOEbYt4MrZ08eGFD34yvfyc=;
 b=my1D00BhYjpsx1Lb4CpWQ3hty7mGOFTp/TyixBj/Jl4lA+TTsH5yuiTANa1/kqnJjrQe
 bKTjDy79Ppu5nIQ58SwTylZ4tRzR+bG5lZ5f+11M8wvDRKbRbcoaMEnABlnvNtU0to4j
 yGKDC0rSr5gMfVGDtphFLU3lR3IWwpDwjxmhnu/OLAzPkaGXzNdCqVtL4T9rqWq+DXkV
 jrWFAdch+hjQV/Rk9NEzDFohtfe69p0poXT8lIelQZjFWwNqGMBoxoQyV32JpMBkmBCZ
 lLkKAbXbK/pn6haMyy+547agLDuZngb+qh/7jOJ97i065VnE6WSQ55+PtdcGBAr+huIM Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jewfmj96n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 15:59:56 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287FtYm6031318;
        Wed, 7 Sep 2022 15:59:55 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jewfmj966-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 15:59:55 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 287FpZd6012879;
        Wed, 7 Sep 2022 15:59:55 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3jbxja1cqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 15:59:55 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 287FxsRn57868562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 15:59:54 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9847124058;
        Wed,  7 Sep 2022 15:59:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35CF7124055;
        Wed,  7 Sep 2022 15:59:53 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.65.175])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Sep 2022 15:59:53 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     nrb@linux.ibm.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: pci: fix GAIT physical vs virtual pointers usage
Date:   Wed,  7 Sep 2022 11:59:52 -0400
Message-Id: <20220907155952.87356-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j2ySYFaNaB5Leo0cwvcFOsx0Ni99hsvk
X-Proofpoint-ORIG-GUID: Va6FO4WzJjbfXVymrPaL6HVYSB6C8po1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_08,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209070060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GAIT and all of its entries must be represented by physical
addresses as this structure is shared with underlying firmware.
We can keep a virtual address of the GAIT origin in order to
handle processing in the kernel, but when traversing the entries
we must again convert the physical AISB stored in that GAIT entry
into a virtual address in order to process it.

Note: this currently doesn't fix a real bug, since virtual addresses
are indentical to physical ones.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 arch/s390/kvm/pci.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index b9c944b262c7..ab569faf0df2 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3324,7 +3324,7 @@ static void aen_host_forward(unsigned long si)
 	if (gaite->count == 0)
 		return;
 	if (gaite->aisb != 0)
-		set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
+		set_bit_inv(gaite->aisbo, phys_to_virt(gaite->aisb));
 
 	kvm = kvm_s390_pci_si_to_kvm(aift, si);
 	if (!kvm)
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index bb8c335d17b9..8cfa0b03ebbb 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -71,7 +71,7 @@ static int zpci_setup_aipb(u8 nisc)
 		rc = -ENOMEM;
 		goto free_sbv;
 	}
-	aift->gait = (struct zpci_gaite *)page_to_phys(page);
+	aift->gait = (struct zpci_gaite *)page_to_virt(page);
 
 	zpci_aipb->aipb.faisb = virt_to_phys(aift->sbv->vector);
 	zpci_aipb->aipb.gait = virt_to_phys(aift->gait);
-- 
2.37.3

