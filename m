Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1E4D8CD2
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbiCNTsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbiCNTsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:48:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DEF3E0E5;
        Mon, 14 Mar 2022 12:46:45 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EHL9qX021019;
        Mon, 14 Mar 2022 19:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hfULLIHmIRLOxrV3tByOMuxSq7Z4VpKx/OSKlELsCsQ=;
 b=igmJnq1cbPUWTr2aImKzv3sC8pzKo2HHyOParhriJYwNSsFKuVXbjwvC3gbAajzhJJ0H
 EPZ4fQ4D9S9U+sWZaUXhW2JGBBohxeNYdjT7GF06pqGhA6KFuEAe2ciAZp32uVYH1mZ6
 8t+BTVLOPJl5EuJeAHsupXgZC1mMY7f5Atgg2loXaYYhsV2kz0z7QpY7qHcFLuda9LhJ
 Xd/Hk5CX2Z/1oyxeyPF0KcWrilKoL4+htZ8BqKd8XstobQX/r0bu+W91Rt/P0d2AR8bf
 DcknargG9faqLW5wmZ7jsW9GncHx2uNInNW45GKGaWCug3HtOypTdJjYflI8huJf0iww WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6af0v3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:38 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJfxuv030128;
        Mon, 14 Mar 2022 19:46:38 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6af0v3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:38 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJN5cA032066;
        Mon, 14 Mar 2022 19:46:37 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 3erk5988yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:36 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJkZ1517367548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:46:35 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CE0B112061;
        Mon, 14 Mar 2022 19:46:35 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23AEC112064;
        Mon, 14 Mar 2022 19:46:26 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:46:25 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 09/32] s390/pci: export some routines related to RPCIT processing
Date:   Mon, 14 Mar 2022 15:44:28 -0400
Message-Id: <20220314194451.58266-10-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Pw-6tsBVZrC51ILVOhO3zB7gOGNM00K
X-Proofpoint-ORIG-GUID: pdygPP8qm1CRLNzs_iUv83k01nbx_DRn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=857 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will re-use dma_walk_cpu_trans to walk the host shadow table and
will also need to be able to call zpci_refresh_trans to re-issue a RPCIT.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/pci/pci_dma.c  | 1 +
 arch/s390/pci/pci_insn.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index f46833a25526..a81de48d5ea7 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -116,6 +116,7 @@ unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr)
 	px = calc_px(dma_addr);
 	return &pto[px];
 }
+EXPORT_SYMBOL_GPL(dma_walk_cpu_trans);
 
 void dma_update_cpu_trans(unsigned long *entry, phys_addr_t page_addr, int flags)
 {
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index 2a47b3936e44..0509554301c7 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -95,6 +95,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
 
 	return (cc) ? -EIO : 0;
 }
+EXPORT_SYMBOL_GPL(zpci_refresh_trans);
 
 /* Set Interruption Controls */
 int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
-- 
2.27.0

