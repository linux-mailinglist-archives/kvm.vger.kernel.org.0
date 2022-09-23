Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B35E7A40
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiIWMKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiIWMIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 08:08:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31AE1DF08;
        Fri, 23 Sep 2022 05:04:40 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NABjNf024892;
        Fri, 23 Sep 2022 12:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=t347ADSp+0eF5KkwSzm0TMKLJXApBkKgO9IpGEUq63s=;
 b=QF3stjeeQsAylzp7JByivunB2FFdtPZxaTH9SU16o6iwGu+TzW/ayqU2sJe94CMWgXQE
 YZCDh1aVfSDm3f2HDzj4Yw9DbB9UyVZVTUPSKF4778+faGFRx4W1hcrU/25bsZhx219n
 /zsL/ve33oMxj3CBw/TlgFe4k8oBOAjZgNI6uTdwgRrTdIg34PSJsPxqv+x2w+2Rzv0M
 pcUaQQMyEppQ9tmbpvpP4AAy7wkRRnK9nDg9X+qQLGkPk4piNnu97o5+tHouHh5Wdlv/
 sCoyR4nVeVKMnTFPlZCvbnNIRfW9w6ZPFl8d/5RwUXWlo22Gq/Mcl9zUrZJ0PW7bIsm9 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3js8neeprn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NBdFvs012289;
        Fri, 23 Sep 2022 12:04:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3js8neepqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NBpOoq030452;
        Fri, 23 Sep 2022 12:04:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3jn5v97x98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NC4Xtv43450642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:04:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC835AE053;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7214BAE045;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.171.28.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 3/4] KVM: s390: pci: fix GAIT physical vs virtual pointers usage
Date:   Fri, 23 Sep 2022 14:04:11 +0200
Message-Id: <20220923120412.15294-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220923120412.15294-1-frankja@linux.ibm.com>
References: <20220923120412.15294-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TAx-wyZSf-YG1G1caHUZ6IypRyQxYL7y
X-Proofpoint-ORIG-GUID: R9OHEHarYr1hiPRopylORh7F7E3v41UF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220907155952.87356-1-mjrosato@linux.ibm.com
Message-Id: <20220907155952.87356-1-mjrosato@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
index 3c12637ce08c..90aaba80696a 100644
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

