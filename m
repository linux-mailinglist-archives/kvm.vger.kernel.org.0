Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEB948F124
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiANUcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244377AbiANUcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:13 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EJQP2o004475;
        Fri, 14 Jan 2022 20:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AV/AvvDMFbTnwO9QqF8MSPog1mX1WxewBgWFUp4rHCY=;
 b=LFhUHMaK6+2zY+rbWl6HZBLPNbVAMJy5lqcRZjT8hmpoOuixBZ9zIzA61Hbug52gcVZ8
 FmrFvf26hN5C15Mj1/ACQEeBY/fyyRnFs4qRxIZ5AHxYCqN9ogxrMF9qTS/kEMtmLlbS
 c4wjdsVi2EXN8um1Nw996T8/35baRDddHup5zNCD2lOBKDRtlv5b8FRosPKidnwshaPI
 c/1rVxjbteLTWS8UrKU8cfK97Zrl//o0RQAvkzuThWcrZxgQC1VFb7MybodFH2fLb6r7
 yUKSELmvyUseRsJTQswiyExvt9ZokUhLYpkNxmIissDZRpdAhb4C4dxyDdIIFMLgrNzt Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfb794mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:12 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EJuVKH004547;
        Fri, 14 Jan 2022 20:32:12 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfb794md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:12 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLrOt027862;
        Fri, 14 Jan 2022 20:32:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3df28cyfc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:10 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKW9Lc32375238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:09 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E4AAC6059;
        Fri, 14 Jan 2022 20:32:09 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D6B6C6065;
        Fri, 14 Jan 2022 20:32:07 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:07 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 09/30] s390/pci: export some routines related to RPCIT processing
Date:   Fri, 14 Jan 2022 15:31:24 -0500
Message-Id: <20220114203145.242984-10-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: r9D8Hxhbn_n1Jh6J_fzja5KI1PVFsECH
X-Proofpoint-GUID: iCe6HvC8LaayB6xZEL8J16XA8Iv6C_NY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will re-use dma_walk_cpu_trans to walk the host shadow table and
will also need to be able to call zpci_refresh_trans to re-issue a RPCIT.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
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

