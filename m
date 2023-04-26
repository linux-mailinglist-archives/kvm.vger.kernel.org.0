Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF16EF4BB
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbjDZMwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240947AbjDZMwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:52:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0953AA2;
        Wed, 26 Apr 2023 05:52:38 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCbAso008214;
        Wed, 26 Apr 2023 12:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=hJmXLPxY1riaGxYRO6ymmQakDznPtTUmJ4xGcePiU5w=;
 b=GAPDzlRZ7/miovpZiWHlU41BmZY/Fz2dEUI+1MuqBN9CLbkBr6efuQaY9XcgPt+UEV5/
 +2TJwp6lpsO0uueSGs04oBLbZCZCeUgT9emeUFZbC9DiHghiKjlfqyZkaMFZ70Q1Poga
 pqMoioSvoFUlXedVV582wmc365W3na3D8R+Z13yHUP2kYnq9lWghuKcMgbCRUM+t6mge
 EhBMhCBX7UcHSHO1upN7YP6lRdUHfXbf75Ez3kGsFyjGZTK5hNjnvTh7hCwi3x5dKkOK
 acnqXqM+j7JvlXJs0Yes1e5cNkymdvC14TPqbP+yXvgz1uxsG6FkNYK2I6jNxqzsnfe8 NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q74448hty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:37 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QCjHS2011269;
        Wed, 26 Apr 2023 12:52:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q74448hsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCTaFc023207;
        Wed, 26 Apr 2023 12:52:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47772bp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QCqVQo26280582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 12:52:31 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43C1420043;
        Wed, 26 Apr 2023 12:52:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 961D420040;
        Wed, 26 Apr 2023 12:52:30 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.39.26])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 12:52:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [GIT PULL 3/3] KVM: s390: pci: fix virtual-physical confusion on module unload/load
Date:   Wed, 26 Apr 2023 14:51:19 +0200
Message-Id: <20230426125119.11472-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230426125119.11472-1-frankja@linux.ibm.com>
References: <20230426125119.11472-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JpQVacR7eeYqZpwSxCCG7-Fs0KxzJBwL
X-Proofpoint-GUID: RLlTB5LDLCVydoVLnIWz2S9fN9WhobWU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

When the kvm module is unloaded, zpci_setup_aipb() perists some data in the
zpci_aipb structure in s390 pci code. Note that this struct is also passed
to firmware in the zpci_set_irq_ctrl() call and thus the GAIT must be a
physical address.

On module re-insertion, the GAIT is restored from this structure in
zpci_reset_aipb(). But it is a physical address, hence this may cause
issues when the kvm module is unloaded and loaded again.

Fix virtual vs physical address confusion (which currently are the same) by
adding the necessary physical-to-virtual-conversion in zpci_reset_aipb().

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230222155503.43399-1-nrb@linux.ibm.com
Message-Id: <20230222155503.43399-1-nrb@linux.ibm.com>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index b124d586db55..7dab00f1e833 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -112,7 +112,7 @@ static int zpci_reset_aipb(u8 nisc)
 		return -EINVAL;
 
 	aift->sbv = zpci_aif_sbv;
-	aift->gait = (struct zpci_gaite *)zpci_aipb->aipb.gait;
+	aift->gait = phys_to_virt(zpci_aipb->aipb.gait);
 
 	return 0;
 }
-- 
2.40.0

