Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F22A8396
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgKEQfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 11:35:09 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:60132 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEQfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 11:35:08 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa429bb0001>; Fri, 06 Nov 2020 00:35:07 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 16:35:04 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.52) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 5 Nov 2020 16:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bf1kMxXfh2Yy4t35nnp0T1OCvCqz9P+qc1GBpWd7jHbZF9+9Yn7LXYZxbrjcma+SeGxMU1tZUDMQxIYPT+pn4dBBoPrZJJOnelQQGQ3xjna/TnVfaCazT/WL6ZbhQYwKfnmGCmceOlE71GgVEH6vlrMwIJgb0qDdRAq8NJrryzUkgNo57BghvNmrUP7ChYVxv9f+rzsqV0LSjPzYxzStE1i15ivSzjBF4H79QoLxQzcZU3UdJkxDFXpg0Lcrp5nOEsTLFzaOVAN83vfNw8Q3I7msqLdczZk/isMRh6EnaPNr7wrnNviBTalbn2YygBNOQdMGnqr48nlRcRCmWZqOHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19KNU0NlsVP11D30t0pYvdo1bGwqR8kLRleMcR1iEcQ=;
 b=ByN5RSjYw6ghExhMXsj1u8rrWmwMD3fog6jaTyNJVVFa/RPnFNsJ5sJqpdUm9rXqx/yc92+klKAN5uHwdb8z6Bbq3whjPIjf/6ry02tKtLFjm/1gbk9kUH+QPs0Wo6/01iCMkDqza6bujMt3ZAOf5IdLZ1g25ZI0qlETpIEP0lAuhkijY4cTcfLr0TyQ+9ak8mBpyQqn/Ho2MxjFMOq99xgWMZ7W/siYtD7gaX9RsUh0KI4WC/gCwkXVa3U/S7vX/uApCqnPuxH9XFT4moBX+idwtfujYydu7E1qvZSY8mO/tzHeZ8jSYZ6YGJWY5tfgT134jIPwSj1kV9/zNCgdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 16:35:00 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 16:35:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Date:   Thu, 5 Nov 2020 12:34:58 -0400
Message-ID: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:207:3d::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0065.namprd02.prod.outlook.com (2603:10b6:207:3d::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 16:34:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kaiDy-0007Jy-HG; Thu, 05 Nov 2020 12:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604594107; bh=+zGzODOJ2QtI/XplZ/FtWd1GSBYZ5b8sbNAEsPsN/DE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=IjB7z+pVH5X4Puv+tF9kLMeXs2fWGCg9+RC2YoApCH88V62QVLbeaZHi/1gm2XOuQ
         QySw6eX1LNqckupwGQLf9xFk9MUx03dcWbMeSd4TmTLof4SVMrA8CN4dNW1U5D+2Pi
         Gv9zCyXWWBbSWZp1Uhipp2Roc57AghHOBtnSsX8MZcBVlSNPK4tgyFVj0x844l9oOj
         JepoJbvpCLsUy+n2dewZgcxTeWqXOrdzOgvSQvDNhEaCuwTwFf08FOXdCTs/xj15D6
         XFCP85Ck4UhCCNnNDul774VOorjvT93w75xhmrrTkSGjURtDdsZc+fEnSjP8VLYh6H
         DqL8/CyoPWMwA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit f8f6ae5d077a ("mm: always have io_remap_pfn_range() set
pgprot_decrypted()") allows drivers using mmap to put PCI memory mapped
BAR space into userspace to work correctly on AMD SME systems that default
to all memory encrypted.

Since vfio_pci_mmap_fault() is working with PCI memory mapped BAR space it
should be calling io_remap_pfn_range() otherwise it will not work on SME
systems.

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

The io_remap_pfn_range() commit is in Linus's tree and will be in rc3, but
there is no cross dependency here.

Tom says VFIO device assignment works OK with KVM, so I expect only things
like DPDK to be broken.

Don't have SME hardware, can't test.

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index fbd2b3404184ba..1853cc2548c966 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1635,8 +1635,8 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault=
 *vmf)
=20
 	mutex_unlock(&vdev->vma_lock);
=20
-	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		ret =3D VM_FAULT_SIGBUS;
=20
 up_out:
--=20
2.29.2

