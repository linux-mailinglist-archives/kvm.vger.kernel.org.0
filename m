Return-Path: <kvm+bounces-25285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6305962F7F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DACBF1C2379F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EF51AAE2F;
	Wed, 28 Aug 2024 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qu6+PEzJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB01A7AF6;
	Wed, 28 Aug 2024 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868802; cv=fail; b=C5XmputuOeB3kosztb8ZFbRczew+BbDjhI87HqZE0oZ5b6/f6D1xFsMqLx9nA3jpsrNmyETp5n5uwQ8XD0cFkkNx2gXLd8OC/FT3K0oVQuPVpgTa5sZ9UF6IvaZtsWoS0xWIFR610d+EsKG7++2z3H4wVREm/0433qznjFL4aZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868802; c=relaxed/simple;
	bh=xGB8uJjBXq2I8omtEydG9w6kWOIAGju2h/qM592ZEt0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SULiSEygJ2Qjjycs2Le/8rSjIefuCxme4mhmClSxKj/WPKeR0hY2lFlO6FmJTu4kqWnbL0607aasagccvMVCU9VOf4jCSgj2S1G/B75nDfe3/dqifp+yRusXbdqgxDg5IjElQW1kpaVheYwxM/YF5hX8QKibbYL/pPV6J1QUc3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qu6+PEzJ; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHqGnpeHSjCTSlIjd7G9Ne5XGC4fdvmQ5IcDeKKrnGiCSM9qGKkQt8Yp2GwPyT0C9i2jHzmEn113skEahCNJ/xTOTBokbveJ2Y/iCFaj34yovcpPzsX904VVir2UXleKCH+klsAqz3b3WAQ5KIC+SJvQiGN/5BIvjsbuJM6LP17G15RKP/g889+raT/VyIY64a8M6yI12wg3BMFOddQUWj4BL2V28ayl+zaKbhJXE21jxEjFFBZ1yK0mQS4qAfaRvIX/BV/mMB12slcR1wVr2IgkTp7n46bvpAYz9mg0+MgqlCeQCegm6beNQDHQOzTxG5qE+MBp91AetvjNq/j4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65ybDY25Ul9Id83lvnrljqo8ccq+X6M9Z6buslPkxEA=;
 b=uN1xThTi+RMrTBk7x2dRMMwAcEroqyw880IxhJ16m4p2ZDrnbZ7Tyz5oYNEaVHcavCHy8AGf6oVt90p8xPJZRZPooG4pazHiSgY8gviwmQLttWiOWjAIl9L9Cqvgs+bZlGYnwMfdh42j/uAL5z89EsGzWCMlrv0+Rv5tF5H3d4zssr3Ev7nldqFhRp8jaYKO1TdSP+o1CpDuov6cVZnyAMDOu4JORR80b4SDIlX0qN4Mbw6PV9eiH6dJ9hLXELTBiSly30VQ/GIPg72APmGsjSIuU9TR4hYg2wDbMhg+xOIap2ipoOfX4NZUZkx3CA6hfFPsbajZhulVTmXGs8XG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65ybDY25Ul9Id83lvnrljqo8ccq+X6M9Z6buslPkxEA=;
 b=Qu6+PEzJVmRDpV2tKmP8zyDzXxlWNYR8uVTDCWAbR595loLU0ghiK6eEadhsRFmoqGc6hxC/f+gdkww8kx+p+VFSC0CLDJS4OebCHYtBq+oZ+SPyDuMGP7jIDM+Cpkzh5xDzn3tyk9btEeIUZhx/E84J+i8qH9R+sVBVTNg/2/xNkFWAo+A13EcZ9amZ+INMil+CTsrdi1MEf9BC6+GvskEc/zqN8hM27jZ8bNlfR/fDg2S0TIDOn0tN5Z+pG5uAdxWdqZM5iRMZSAi9bjsOkM5o2FXilNl/bUwrj0wt7pPGeBrO9mJkI/jh5wk7qfAKLEkUf9VGbZLLSElnBc+uDA==
Received: from BN9P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::18)
 by SJ2PR12MB8846.namprd12.prod.outlook.com (2603:10b6:a03:549::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Wed, 28 Aug
 2024 18:13:15 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:408:10c:cafe::e5) by BN9P222CA0013.outlook.office365.com
 (2603:10b6:408:10c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Wed, 28 Aug 2024 18:13:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Wed, 28 Aug 2024 18:13:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 11:12:53 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 11:12:52 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 28 Aug 2024 11:12:51 -0700
Date: Wed, 28 Aug 2024 11:12:49 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|SJ2PR12MB8846:EE_
X-MS-Office365-Filtering-Correlation-Id: 776b926e-b118-4754-b108-08dcc78d1458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?22qgr47ZHuNfqCVtPJh6qymNmHJZ7f4eDqZCY56vPdxxC4jHcNcCRG1v4J/8?=
 =?us-ascii?Q?qxhBzHwT3jDTWgFu1xUqFTU5jlmNHHNlb0Lkkubxvqa1J3wjUlZcFb+/msSq?=
 =?us-ascii?Q?jdIh244FIbfa6w1KQLw+kQ9WddcAFDpG4rekgT1D7GkSBXY0IobHk423cqMg?=
 =?us-ascii?Q?MzR3i5h9ErET9IjKblnuEVan+ZiXz62MLLETwJqF9Dtl0L2WThZ4/lhdG8an?=
 =?us-ascii?Q?/j3sMnV3QZq8mzi6PGf9FaNgYE4pa/MUg8I1PcZIAHWM+AU//j0PhhzCm1pT?=
 =?us-ascii?Q?cYxgA+wHdaByhHWAXdWGpIns4D29pXjwcEhXfd3CWGu5AezmWXp3wXEu9F8S?=
 =?us-ascii?Q?AbaesiD/0H+OjBr9aH3JSo7kkIS7DsUayequASWelrAVulz6jm5DFAiIc+mK?=
 =?us-ascii?Q?Z2SF6Nxoq+UbDc6bAsNqdjkZK2nqHrsgq+8yo2Qz0JiTREUygT9exRNH2iGa?=
 =?us-ascii?Q?0mZfKWRoDMY7eVED/HvbtX8lUP5aa8Rp3K3olE1H68/RPV202ekz6Pq4nToC?=
 =?us-ascii?Q?809c6qk1D4wJDPai2X65aLRmHuT6xqB2Nnbv8MpGHzaAcZvMIo1jDcZAcWhJ?=
 =?us-ascii?Q?uMCssCtbXVAAt3NyYd9V3OvxXMqd4xPWx8KROiL+YckOBSESD5GigKyGMP1L?=
 =?us-ascii?Q?jCwug+TM2rQcjQ+v+PI23sEKfuMWnOx4HKRNX2szSsUnO1HmGIWsbl16kt0v?=
 =?us-ascii?Q?YRFodJtTrqBXjD5qya0J9dk3H0I9shilS3D0c9CyhIbcaRO0s47QyfSCQ1ou?=
 =?us-ascii?Q?FR64k9czCF2HD7Hgam2/WMbYTfAljkJaecZPGLdF0gtXlXodoLpRoflVTe46?=
 =?us-ascii?Q?6Tzqube4JdbTGZ/x+KicUup8qE7OQZA8pT5vK09MT9pGc1RmX+HslzkEZxkJ?=
 =?us-ascii?Q?aAKRDGo77VAqkq/b2E5DeqP471bSWm7PAyU+89rGEQzM4NimNInOY7m1Uxqk?=
 =?us-ascii?Q?FbpHnlt1I14wJNRatF+SZ+YNDPdTPPBHj54SI4meuVwCwnDrZsZIvBdHZ1na?=
 =?us-ascii?Q?LRdveKgQS/2rPm/Bi+i6UP1rwfQSnaFdeXcjl8CHfJMUs4VTqDyhKsZZFU+z?=
 =?us-ascii?Q?uiBwK9Rt/+dVjaArt4Oy78gDskrphGo45n72be2FcL1lAA/iYODyet3dP6HR?=
 =?us-ascii?Q?I/6StTObgSYOBkRGCnX1+5FtkMLTL4UNjeon7/MAiJXIKWhiwsRK/kBpE6st?=
 =?us-ascii?Q?wfCaEcBtbwuRKPAXpSkLCnT/R5pBt7fs7R0e7yIl6M6vzvtkruGXlmZ1UkA7?=
 =?us-ascii?Q?VJ9yHKpi37nAFHYbE1h9k5IIUHuB+9z1W+tfXW1CJQjWKieR4q0v858Xbbv5?=
 =?us-ascii?Q?FrcWGEmOUOmAPj7mvDF0HWJ2zJm9CKuToaLZyZvn+Y2JarYPXbKaJQhfbuYX?=
 =?us-ascii?Q?yygzHqV0hDBF+nrRAW5HNEOYThfSDKAI904wbMQwNQsfN8xxRiRLHcNEKlPc?=
 =?us-ascii?Q?NwxfJZP/J4xP7NIj8ex1jRl7lrLN5W2A?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 18:13:12.3253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 776b926e-b118-4754-b108-08dcc78d1458
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8846

On Wed, Aug 28, 2024 at 06:06:36PM +0000, Shameerali Kolothum Thodi wrote:
> > > > As mentioned above, the VIOMMU series would be required to test the
> > > > entire nesting feature, which now has a v2 rebasing on this series.
> > > > I tested it with a paring QEMU branch. Please refer to:
> > > > https://lore.kernel.org/linux-
> > > > iommu/cover.1724776335.git.nicolinc@nvidia.com/
> > >
> > > Thanks for this. I haven't gone through the viommu and its Qemu branch
> > > yet.  The way we present nested-smmuv3/iommufd to the Qemu seems to
> > > have changed  with the above Qemu branch(multiple nested SMMUs).
> > > The old Qemu command line for nested setup doesn't work anymore.
> > >
> > > Could you please share an example Qemu command line  to verify this
> > > series(Sorry, if I missed it in the links/git).
> >
> > My bad. I updated those two "for_iommufd_" QEMU branches with a
> > README commit on top of each for the reference command.
> 
> Thanks. I did give it a go and this is my command line based on above,

> But it fails to boot very early:
> 
> root@ubuntu:/home/shameer/qemu-test# ./qemu_run-simple-iommufd-nicolin-2
> qemu-system-aarch64-nicolin-viommu: Illegal numa node 2
> 
> Any idea what am I missing? Do you any special config enabled while building Qemu?

Looks like you are running on a multi-SMMU platform :)

Would you please try syncing your local branch? That should work,
as the update also had a small change to the virt code:

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 161a28a311..a782909016 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1640,7 +1640,7 @@ static PCIBus *create_pcie_expander_bridge(VirtMachineState *vms, uint8_t idx)
     }

     qdev_prop_set_uint8(dev, "bus_nr", bus_nr);
-    qdev_prop_set_uint16(dev, "numa_node", idx);
+    qdev_prop_set_uint16(dev, "numa_node", 0);
     qdev_realize_and_unref(dev, BUS(bus), &error_fatal);

     /* Get the pxb bus */


Thanks
Nicolin

