Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330ED1376A0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgAJTGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:06:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgAJTGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:06:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3IaH100963;
        Fri, 10 Jan 2020 19:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=C8D0pIaGNjjh2JphNwNEtO74QjeO7OaTgDpMn2oUCOQ=;
 b=eihdRw9sB5AAEspn7seM1U5ZcQbXLdkmwvsQYq2bO9Gh6HcrtIMT2X1++G3XqobSqNQJ
 2th6fRWrI2JHwTh3bDyM3j7IFK/n4eaTF6XXuhcNM24OZw0++etfJw7hRiHC/FrZYrWq
 tXB3SxHo3dktk0cXhtdwWv+I3oeI3mjbpCxSvhgjVHD/nZ+c1/Een82LrDaX+2MSlm2z
 KBhhzugXijUeAt31lKRdngewyAINmeeKeg2nu1kGN93Iy/78Tlp81CmoCobLHGWW2xaa
 pn+lpZY2zX/iUxyX7w+gWnLRnd3lzaehmeXPVGVTarifoch91V/lvKx273jo77IMnCd9 eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnqm1cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ4Dwn106360;
        Fri, 10 Jan 2020 19:05:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xevfdhx8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00AJ54wI014657;
        Fri, 10 Jan 2020 19:05:04 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:05:03 -0800
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
Subject: [PATCH RFC 05/10] device-dax: Do not enforce MADV_DONTFORK on mmap()
Date:   Fri, 10 Jan 2020 19:03:08 +0000
Message-Id: <20200110190313.17144-6-joao.m.martins@oracle.com>
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

Currently check_vma() checks for VM_DONTCOPY for a device-dax
when the dax region is not backed by devmap (i.e. PFN_MAP is not set).
VM_DONTCOPY is set through madvise(MADV_DONTFORK) and it only sets it
at an address returned from mmap(). check_vma() is called at devdax
mmap hence checking VM_DONTCOPY prevents a process from mmap-ing the
device.

Let's not enforce MADV_DONTFORK at mmap(), but rather when it actually
gets used (on fault). The assumptions don't change, as it is
expected to still retain/madvise MADV_DONTFORK after mmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 1af823b2fe6b..c6a7f5e12c54 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -14,7 +14,7 @@
 #include "dax-private.h"
 #include "bus.h"
 
-static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
+static int check_vma_mmap(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
 	struct dax_region *dax_region = dev_dax->region;
@@ -41,17 +41,29 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		return -EINVAL;
 	}
 
-	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV
-			&& (vma->vm_flags & VM_DONTCOPY) == 0) {
+	if (!vma_is_dax(vma)) {
 		dev_info_ratelimited(dev,
-				"%s: %s: fail, dax range requires MADV_DONTFORK\n",
+				"%s: %s: fail, vma is not DAX capable\n",
 				current->comm, func);
 		return -EINVAL;
 	}
 
-	if (!vma_is_dax(vma)) {
-		dev_info_ratelimited(dev,
-				"%s: %s: fail, vma is not DAX capable\n",
+	return 0;
+}
+
+static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
+		     const char *func)
+{
+	int rc;
+
+	rc = check_vma_mmap(dev_dax, vma, func);
+	if (rc < 0)
+		return rc;
+
+	if ((dev_dax->region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV
+			&& (vma->vm_flags & VM_DONTCOPY) == 0) {
+		dev_info_ratelimited(&dev_dax->dev,
+				"%s: %s: fail, dax range requires MADV_DONTFORK\n",
 				current->comm, func);
 		return -EINVAL;
 	}
@@ -315,7 +327,7 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 	 * fault time.
 	 */
 	id = dax_read_lock();
-	rc = check_vma(dev_dax, vma, __func__);
+	rc = check_vma_mmap(dev_dax, vma, __func__);
 	dax_read_unlock(id);
 	if (rc)
 		return rc;
-- 
2.17.1

