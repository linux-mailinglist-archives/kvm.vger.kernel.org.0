Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F7714EF02
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgAaPDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:03:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729016AbgAaPDW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:03:22 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF1C6c114650
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:21 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvf34nx8y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:19 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:14 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:10 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF293h46661862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:02:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42F2F11C04C;
        Fri, 31 Jan 2020 15:02:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 397F011C05C;
        Fri, 31 Jan 2020 15:02:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:02:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id ED680E0378; Fri, 31 Jan 2020 16:02:08 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 02/12] s390: PCI: fix IOMMU region init
Date:   Fri, 31 Jan 2020 16:01:57 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150207.73127-1-borntraeger@de.ibm.com>
References: <20200131150207.73127-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0020-0000-0000-000003A5DEF9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0021-0000-0000-000021FD995F
Message-Id: <20200131150207.73127-3-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=2 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

The fix in dbe9cf606c shrinks the IOMMU memory region to a size
that seems reasonable on the surface, however is actually too
small as it is based against a 0-mapped address space.  This
causes breakage with small guests as they can overrun the IOMMU window.

Let's go back to the prior method of initializing iommu for now.

Fixes: dbe9cf606c ("s390x/pci: Set the iommu region size mpcifc request")
Cc: qemu-stable@nongnu.org
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reported-by: Boris Fiuczynski <fiuczy@linux.ibm.com>
Tested-by: Boris Fiuczynski <fiuczy@linux.ibm.com>
Reported-by: Stefan Zimmerman <stzi@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Message-Id: <1569507036-15314-1-git-send-email-mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 hw/s390x/s390-pci-bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 963a41c7f532..2d2f4a7c419c 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -695,10 +695,15 @@ static const MemoryRegionOps s390_msi_ctrl_ops = {
 
 void s390_pci_iommu_enable(S390PCIIOMMU *iommu)
 {
+    /*
+     * The iommu region is initialized against a 0-mapped address space,
+     * so the smallest IOMMU region we can define runs from 0 to the end
+     * of the PCI address space.
+     */
     char *name = g_strdup_printf("iommu-s390-%04x", iommu->pbdev->uid);
     memory_region_init_iommu(&iommu->iommu_mr, sizeof(iommu->iommu_mr),
                              TYPE_S390_IOMMU_MEMORY_REGION, OBJECT(&iommu->mr),
-                             name, iommu->pal - iommu->pba + 1);
+                             name, iommu->pal + 1);
     iommu->enabled = true;
     memory_region_add_subregion(&iommu->mr, 0, MEMORY_REGION(&iommu->iommu_mr));
     g_free(name);
-- 
2.21.0

