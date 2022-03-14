Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E6F4D8CF5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbiCNTtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbiCNTtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:49:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EEF3EAA2;
        Mon, 14 Mar 2022 12:47:42 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlYt7025603;
        Mon, 14 Mar 2022 19:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jmXiDoamZ6A/nz+QAIB6MB8dJ9r4Q11uaUeMfJF8JPU=;
 b=IldFFzQgbT6fNkUKutnp3O9KlS2hiTV+3TR6ERfR7Mdb7oJnGc+Z5xW66dxQI1TKX/aH
 Kr9J7DuSeD1py3KWkxFmgoj+TgvrXazHl46WayDQRZPa544kdztx9NFxk4d2vaFvP3/4
 TpuWiGynvoaffuTP4uOJWKmDwPV08hGiBwciPr1WmioviN1qGWgMRsi6nNo9aMQ9T8vw
 u785gyA8/6FXabXKYht7n9aOnN1u2wprpc5dTyZfKPPdWi9AcWH+JSDDqvHln7jsae2t
 4fgJolmcGlGHWLBOw+IH9EloCfIVm9RijaX7MQwdHYjKdkKFeouRTrW6X46W2sK2hp2o 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ag0xhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlY8E025676;
        Mon, 14 Mar 2022 19:47:34 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ag0xdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:34 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJNuuX001686;
        Mon, 14 Mar 2022 19:47:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3erk594csc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJlGEo6292066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:47:16 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47A11112061;
        Mon, 14 Mar 2022 19:47:16 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E3B112063;
        Mon, 14 Mar 2022 19:47:06 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:47:06 +0000 (GMT)
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
Subject: [PATCH v4 13/32] s390/pci: return status from zpci_refresh_trans
Date:   Mon, 14 Mar 2022 15:44:32 -0400
Message-Id: <20220314194451.58266-14-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0-tL8yOiMEZcG7wASO7AAaz0xhmgkZFl
X-Proofpoint-GUID: IpE5ClWXoe_7Hq2DlizJsNA3x50FpKyP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=850
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current callers of zpci_refresh_trans don't need to interrogate the status
returned from the underlying instructions.  However, a subsequent patch
will add a KVM caller that needs this information.  Add a new argument to
zpci_refresh_trans to pass the address of a status byte and update
existing call sites to provide it.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci_insn.h |  2 +-
 arch/s390/pci/pci_dma.c          |  6 ++++--
 arch/s390/pci/pci_insn.c         | 10 +++++-----
 drivers/iommu/s390-iommu.c       |  4 +++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index 5331082fa516..32759c407b8f 100644
--- a/arch/s390/include/asm/pci_insn.h
+++ b/arch/s390/include/asm/pci_insn.h
@@ -135,7 +135,7 @@ union zpci_sic_iib {
 DECLARE_STATIC_KEY_FALSE(have_mio);
 
 u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status);
-int zpci_refresh_trans(u64 fn, u64 addr, u64 range);
+int zpci_refresh_trans(u64 fn, u64 addr, u64 range, u8 *status);
 int __zpci_load(u64 *data, u64 req, u64 offset);
 int zpci_load(u64 *data, const volatile void __iomem *addr, unsigned long len);
 int __zpci_store(u64 data, u64 req, u64 offset);
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index a81de48d5ea7..b0a2380bcad8 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -23,8 +23,9 @@ static u32 s390_iommu_aperture_factor = 1;
 
 static int zpci_refresh_global(struct zpci_dev *zdev)
 {
+	u8 status;
 	return zpci_refresh_trans((u64) zdev->fh << 32, zdev->start_dma,
-				  zdev->iommu_pages * PAGE_SIZE);
+				  zdev->iommu_pages * PAGE_SIZE, &status);
 }
 
 unsigned long *dma_alloc_cpu_table(void)
@@ -183,6 +184,7 @@ static int __dma_purge_tlb(struct zpci_dev *zdev, dma_addr_t dma_addr,
 			   size_t size, int flags)
 {
 	unsigned long irqflags;
+	u8 status;
 	int ret;
 
 	/*
@@ -201,7 +203,7 @@ static int __dma_purge_tlb(struct zpci_dev *zdev, dma_addr_t dma_addr,
 	}
 
 	ret = zpci_refresh_trans((u64) zdev->fh << 32, dma_addr,
-				 PAGE_ALIGN(size));
+				 PAGE_ALIGN(size), &status);
 	if (ret == -ENOMEM && !s390_iommu_strict) {
 		/* enable the hypervisor to free some resources */
 		if (zpci_refresh_global(zdev))
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index 0509554301c7..ca6399d52767 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -77,20 +77,20 @@ static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
 	return cc;
 }
 
-int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
+int zpci_refresh_trans(u64 fn, u64 addr, u64 range, u8 *status)
 {
-	u8 cc, status;
+	u8 cc;
 
 	do {
-		cc = __rpcit(fn, addr, range, &status);
+		cc = __rpcit(fn, addr, range, status);
 		if (cc == 2)
 			udelay(ZPCI_INSN_BUSY_DELAY);
 	} while (cc == 2);
 
 	if (cc)
-		zpci_err_insn(cc, status, addr, range);
+		zpci_err_insn(cc, *status, addr, range);
 
-	if (cc == 1 && (status == 4 || status == 16))
+	if (cc == 1 && (*status == 4 || *status == 16))
 		return -ENOMEM;
 
 	return (cc) ? -EIO : 0;
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3833e86c6e7b..73a85c599dc2 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -214,6 +214,7 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
 	unsigned long irq_flags, nr_pages, i;
 	unsigned long *entry;
 	int rc = 0;
+	u8 status;
 
 	if (dma_addr < s390_domain->domain.geometry.aperture_start ||
 	    dma_addr + size > s390_domain->domain.geometry.aperture_end)
@@ -238,7 +239,8 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
 	spin_lock(&s390_domain->list_lock);
 	list_for_each_entry(domain_device, &s390_domain->devices, list) {
 		rc = zpci_refresh_trans((u64) domain_device->zdev->fh << 32,
-					start_dma_addr, nr_pages * PAGE_SIZE);
+					start_dma_addr, nr_pages * PAGE_SIZE,
+					&status);
 		if (rc)
 			break;
 	}
-- 
2.27.0

