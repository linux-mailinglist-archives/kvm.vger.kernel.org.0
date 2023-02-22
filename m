Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDDD69F85F
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjBVPzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 10:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjBVPzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 10:55:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C0C3B3EC;
        Wed, 22 Feb 2023 07:55:11 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MEpHPt004182;
        Wed, 22 Feb 2023 15:55:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=sBGetJc+VL5iXHJ7ErzxJOm/AIpSkSanEzYKQEo55VE=;
 b=N4oCKEDJfAmRR2pF1oYfxiTSV07B2PNZYE2TEm2SJXEUoKrs1wgxMt+5FHXKUjKqxscs
 o+gU4r6CkxsAGsH1CYzbJT3sTsUAJr69fOguzHnd2YPLsEXg1KvbDLvOtLJPMATQKmkd
 rQqp4VeAaZndF/hL2KyeaiZbo1AB9caI8FeoX39w4ohtpwSscw4n64hp3VYICVNLVTVk
 vBqNyefoPGVmO96CTtwAYwpS1sotoqBRLC5xelYtC1hhCBeKa4CmHboY2Zx/u1EA0ZLY
 5+eFtC/jVTH6MASxGhpJyUxUiObSS9c7Jl0S7vSGiwMWiGl5s6J9nLpBEK5ZgwfyplES eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwn671qs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MEs1Ug014190;
        Wed, 22 Feb 2023 15:55:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwn671qrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MAYVw9014629;
        Wed, 22 Feb 2023 15:55:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6488b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MFt48j26935790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 15:55:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B8C02004B;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32C6320040;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mjrosato@linux.ibm.com,
        farman@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] KVM: s390: pci: fix virtual-physical confusion on module unload/load
Date:   Wed, 22 Feb 2023 16:55:02 +0100
Message-Id: <20230222155503.43399-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8AC88WsUx72kUVAeyLodhFgkjnqTfLlN
X-Proofpoint-ORIG-GUID: L8WpBXaQiDAIIRXf2GAOrHP4sxKdUj3U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index ec51e810e381..9adb4a4b2bba 100644
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
2.39.1

