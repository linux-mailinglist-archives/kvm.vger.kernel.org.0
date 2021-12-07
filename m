Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F346C56B
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbhLGVCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60900 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239100AbhLGVCO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:14 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jghu1023995;
        Tue, 7 Dec 2021 20:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lrxSwJNVrPIBdjmAsBiJ+hSZ6e3frVZ93EYKJ+w57zU=;
 b=CMVgHiClFOu1X3Bt3woWWMlfxVA8uvnsb0721e4ZKsvE2eOi+DrleywuQ8Vf+0j8e2JJ
 l55X1cuaEAZifzFPamVqN5HjP7RcDIqit05YoivcqFGUAEM7thmZGVAGF1dgr+/rUzcK
 ikIyuK8UP2SWa/CTpbbIJYblzK34/7VSMp/S6OASVMQRIFcezdlB9zOd7ome/5RVrHUY
 ZDkZNOdCoVIO9UT9vJrjzgNroZMEnW6c3oHIoSAKb7zEzry0nnKITJ8+lcYdz778E5RA
 BSVhA9JZA12disDrvG6eDbTerB1VwZfQeuwCcAcY9nZem/Eok+m49fnM+j6g03dx5DDj Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4t8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:43 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KDOhl027358;
        Tue, 7 Dec 2021 20:58:42 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctbgt4t8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:42 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvomT031438;
        Tue, 7 Dec 2021 20:58:42 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyammgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KweGJ14090732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:58:40 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A49CAE05F;
        Tue,  7 Dec 2021 20:58:40 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B64C0AE079;
        Tue,  7 Dec 2021 20:58:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:58:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/32] s390/pci: export some routines related to RPCIT processing
Date:   Tue,  7 Dec 2021 15:57:20 -0500
Message-Id: <20211207205743.150299-10-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zAkfD8jLedDFashu1sIa5D8NgQzbxOW6
X-Proofpoint-ORIG-GUID: oeY3vVCQQna9X7QvztwKC3zK-z8oZsMj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=972 bulkscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will re-use dma_walk_cpu_trans to walk the host shadow table and
will also need to be able to call zpci_refresh_trans to re-issue a RPCIT.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/pci/pci_dma.c  | 1 +
 arch/s390/pci/pci_insn.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 1f4540d6bd2d..ae55f2f2ecd9 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -116,6 +116,7 @@ unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr)
 	px = calc_px(dma_addr);
 	return &pto[px];
 }
+EXPORT_SYMBOL_GPL(dma_walk_cpu_trans);
 
 void dma_update_cpu_trans(unsigned long *entry, void *page_addr, int flags)
 {
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index d1a8bd43ce26..0d1ab268ec24 100644
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

