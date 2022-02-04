Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37864AA1C9
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbiBDVQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9190 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242234AbiBDVQN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JQBKB022463;
        Fri, 4 Feb 2022 21:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c+/z/nGdUo/eAT2rhuk32NdGy9vuZBQEad2crmImLoA=;
 b=f6ym4TqCiPZNl+sY+W1Jd5o/JtHDvYUJ5ArLoqzdIjWt4yetrrEvtI8XP38yuGWmBvE2
 PVbTAMiZvVvGZY97zcXw20d1YCceU0KvqQHIZ+DjoIBLxaawbgyGE5/PXSFkqTP9bMM+
 A/N7WGxUrvJpjZYYy8kMOpX8Sv29pY1C34cg1ufOUhB+EDvy+jX4tEFpzq0q499ldVbF
 ZjIKpMDp7f0jz6wVPlL8wGR5x/f7rcKBtdV1Nmle3AO1o/y4HxlZwHh4eAme0wnjeSFp
 QNF5WN5y7TVblRWYXPqhlhklxpkeNlIjuSu/Mf3AfHjobSROLj9WjqMW7IMD2EOElzyC fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5x300-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:12 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214KvGUi026184;
        Fri, 4 Feb 2022 21:16:12 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5x2ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LDHUJ029643;
        Fri, 4 Feb 2022 21:16:11 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3e0r0vauv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:11 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LG9F627328890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:09 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92DDE136063;
        Fri,  4 Feb 2022 21:16:09 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8122136065;
        Fri,  4 Feb 2022 21:16:07 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:07 +0000 (GMT)
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
Subject: [PATCH v3 13/30] s390/pci: return status from zpci_refresh_trans
Date:   Fri,  4 Feb 2022 16:15:19 -0500
Message-Id: <20220204211536.321475-14-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FRyjFzOPmYczC_0N7fz7T0e_Y3oERJu3
X-Proofpoint-GUID: WMDW8qu5Ut-HIBTZwz7J87qNFbuwhFUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
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
index 50860ebdd087..845bb99c183e 100644
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

