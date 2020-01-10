Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7E13768C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgAJTFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:05:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbgAJTFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:05:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ44Ed111312;
        Fri, 10 Jan 2020 19:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=AOtZE2Ew8hycb3SG+EnQmNQT+PxozxfzEjsUQMh/A/s=;
 b=Bzn/J7UT1T61gmZkCk5vbEUQl1TX7zikcJc7drBa47visSSlDYUrXXYCwC2IDFAR4i7t
 58SVag0bRztRmzfWIYStozEQPsR/ZS2dbeSOMtWcyvB9NIjDDqiqquffapV9/J0QYRTO
 KaO7RCvWsQGtypBGMmqXw+OZA8QLWNfxxqxyzDWJmGFWQABgp/2Y20Zeu7HMImLxfn1B
 Zmuw+GnvpjZlKfSP9b0cI/t76wg/m/Thl2aktuoRCDM2Vjt2IptsxQ7XNh3yX0HtRf/o
 k9dcm9Cn1AEgHDg6QuoYJsLCakcfFqfzmdYObBpBzFRYlix+mW8pQrQwe5XkDfBCsnpQ jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xakbrbyrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ4RxF038537;
        Fri, 10 Jan 2020 19:05:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xekkvjm94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00AJ5Ec4006978;
        Fri, 10 Jan 2020 19:05:14 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:05:14 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 07/10] device-dax: Add support for PFN_SPECIAL flags
Date:   Fri, 10 Jan 2020 19:03:10 +0000
Message-Id: <20200110190313.17144-8-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we assume there's gonna be a PFN_DEV|PFN_MAP which
means it will have a struct page backing the PFN but that is
not placed in normal system RAM zones.

Add support for PFN_DEV|PFN_SPECIAL only and therefore the
underlying vma won't have a struct page. For device dax, this
means not assuming callers will pass a dev_pagemap, and avoid
returning SIGBUS for the lack of PFN_MAP region pfn flag and
finally not setting struct page index/mapping on fault.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/bus.c    |  3 ++-
 drivers/dax/device.c | 40 ++++++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 46e46047a1f7..96ca3ac85278 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -414,7 +414,8 @@ struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int id,
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(&dev_dax->pgmap, pgmap, sizeof(*pgmap));
+	if (pgmap)
+		memcpy(&dev_dax->pgmap, pgmap, sizeof(*pgmap));
 
 	/*
 	 * No 'host' or dax_operations since there is no access to this
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 113a554de3ee..aa38f5ff180a 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -14,6 +14,12 @@
 #include "dax-private.h"
 #include "bus.h"
 
+static int dax_is_pfn_special(struct dev_dax *dev_dax)
+{
+	return (dev_dax->region->pfn_flags &
+		(PFN_DEV|PFN_SPECIAL)) == (PFN_DEV|PFN_SPECIAL);
+}
+
 static int dax_is_pfn_dev(struct dev_dax *dev_dax)
 {
 	return (dev_dax->region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV;
@@ -104,6 +110,7 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	unsigned int fault_size = PAGE_SIZE;
+	int rc;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
@@ -126,7 +133,12 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
+	if (dax_is_pfn_special(dev_dax))
+		rc = vmf_insert_pfn(vmf->vma, vmf->address, pfn_t_to_pfn(*pfn));
+	else
+		rc = vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
+
+	return rc;
 }
 
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
@@ -149,12 +161,6 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	/* dax pmd mappings require pfn_t_devmap() */
-	if (!dax_is_pfn_map(dev_dax)) {
-		dev_dbg(dev, "region lacks devmap flags\n");
-		return VM_FAULT_SIGBUS;
-	}
-
 	if (fault_size < dax_region->align)
 		return VM_FAULT_SIGBUS;
 	else if (fault_size > dax_region->align)
@@ -199,12 +205,6 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	/* dax pud mappings require pfn_t_devmap() */
-	if (!dax_is_pfn_map(dev_dax)) {
-		dev_dbg(dev, "region lacks devmap flags\n");
-		return VM_FAULT_SIGBUS;
-	}
-
 	if (fault_size < dax_region->align)
 		return VM_FAULT_SIGBUS;
 	else if (fault_size > dax_region->align)
@@ -266,7 +266,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE) {
+	if (dax_is_pfn_map(dev_dax) && (rc == VM_FAULT_NOPAGE)) {
 		unsigned long i;
 		pgoff_t pgoff;
 
@@ -344,6 +344,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	vma->vm_ops = &dax_vm_ops;
 	vma->vm_flags |= VM_HUGEPAGE;
+	if (dax_is_pfn_special(dev_dax))
+		vma->vm_flags |= VM_PFNMAP;
 	return 0;
 }
 
@@ -450,10 +452,12 @@ int dev_dax_probe(struct device *dev)
 		return -EBUSY;
 	}
 
-	dev_dax->pgmap.type = MEMORY_DEVICE_DEVDAX;
-	addr = devm_memremap_pages(dev, &dev_dax->pgmap);
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
+	if (dax_is_pfn_map(dev_dax)) {
+		dev_dax->pgmap.type = MEMORY_DEVICE_DEVDAX;
+		addr = devm_memremap_pages(dev, &dev_dax->pgmap);
+		if (IS_ERR(addr))
+			return PTR_ERR(addr);
+	}
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.17.1

