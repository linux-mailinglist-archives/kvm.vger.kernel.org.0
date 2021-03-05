Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5451A32DF15
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhCEBaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:30:07 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18112 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCEBaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:30:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6041899f0000>; Thu, 04 Mar 2021 17:30:07 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 01:30:06 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.52) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 5 Mar 2021 01:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ac6ihfUy/biuNfmwDjXSVfCvM+Fe8JeYfDTnCl0MZDXL7k8N/WRclG3ImNFBnPJQHMn9ls/r1wn9z8duARBs3KpzA5sSh7v2WLatLQaCw2j3t71z0deeZh4zWRwbSrUh4jiKVfi5lVfKpS4FtpiJoxAU3yM2rmaNwh95d+Yzh8w78+Xjss+wbwvCKfok/IZ3tejJOPl/3wmj0fLGhrI7o1yCxzl4bCt94WmLriiZehE7TQc2BKVJMd5aSeGysk8JB/+4ywoAHso6HMAJeTSJilZ6v48fTIC3ufODN+G10g7EpAUhAlqvX0AWcAtPrUduPnvZ4J3+SSdRRl/Pda2ozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0HnrV8BhKqIOPMc7De7KpT+ejGhNiggopqlkuBAI10=;
 b=KoVBgGRIgD2I5uWLfeXdmP223dKwG/g2f5rhTkXZFmEKP9VP4BfZohXik4wWQ1fN+yGguDJaBJ8oYf4+rGXEeSybNlEyNzr1Uo5XfADvyqednBq91hGfbN15/lcjpheyRnBSFkDU0wJU4oHRVjwhU6VnIhFNLXaLjtm02Q6AtWapnmh7i8Ak1+4SExGPGCOWWng2mBOYfDOqRLcAxrd7WMNW9uj5MftSTH8mVT+5S5xECUQHaf4rWSkwAgJcm4Wfhk5QEq0k+Qi/jPL6knpjhgioDKEXfADYXVtDJncEYPs9TLzicd1XsqjnGR2cIqRj9q3fSsaKj6l/TZxMyIt6Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Fri, 5 Mar
 2021 01:30:04 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Fri, 5 Mar 2021
 01:30:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
CC:     Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio: Depend on MMU
Date:   Thu, 4 Mar 2021 21:30:03 -0400
Message-ID: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0117.namprd13.prod.outlook.com (2603:10b6:208:2b9::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Fri, 5 Mar 2021 01:30:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lHzI3-007fZC-7x; Thu, 04 Mar 2021 21:30:03 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614907807; bh=94v8CiAQgCxpNFeI1+EuH7XU8W3yryiC8Ef1AwGRROo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Zn8QLekN6zaKagG1OEf8dAhrc9RkxuyYCuzGE3rmCsaYyGXJXFflymqRb0F6vJ4uD
         iW4h+QfIJkLm6UNv6qhTZ7zFMHWk3DBcJvTaRLvIMrkeK/1UOjak2Y+L1dB7ijw3y7
         edNockL5AUvug+rfiMRmLI66XKCqpkrj9C6cSK9wPdlg1aioSADG3s1LdM9E0mAa+z
         03TgSiAA3+40Z27xfzopFCSN14HyBGIHQBlN8G72WjXSxKPvKeUvJ7MJmhBVgiJNo+
         L8EgdP8tostP+8q66Z2/0aexKJDlZPQJTHlZMtm0QHvWq11erlrZir10bfMIQd1H/u
         gE3FMESIJS6Qw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_IOMMU_TYPE1 does not compile with !MMU:

../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of f=
unction 'pte_write'; did you mean 'vfs_write'? [-Werror=3Dimplicit-function=
-declaration]

So require it.

Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 90c0525b1e0cf4..67d0bf4efa1606 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -22,7 +22,7 @@ config VFIO_VIRQFD
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
-	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.
--=20
2.30.1

