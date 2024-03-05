Return-Path: <kvm+bounces-10942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB132871BD2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94FF4B22711
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8A977A0E;
	Tue,  5 Mar 2024 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p0ODYWU/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6167C5FBA5;
	Tue,  5 Mar 2024 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634256; cv=fail; b=OSvBOtLhg9ZEYbiG9VBlW0tiOh9v933HJk6o1sSsFK1LzFeJOJV31CjfyUwn5XzWDHB4Q3gYYv9N8yhQqHjcKSo9BZemcHy6GUzC6hxX2zHBG0OCobFY/MZecY2BRUo5+7E1MpC1vdLaDphcU10J0N59z3ETxwPJWiuXDwKc+Fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634256; c=relaxed/simple;
	bh=PCPoEscrqyDenQs86QkKV1wT/niX8KNFD7OhI/8NWEc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fjnn0kNb5W+kXWznBC/7La42TgMD+Mobzru1uSNT+Kn53FQUzNvSHQgdx1FXKAD7iiKqC4VZWeidx2Y/huyMeFG7Z0wunLaJyEdakCKL3r8dCxireiPGwG1Vgg0YWxXQgmeLs+UwRQ2PFMyTIby1ejNloV3lGpd5KxyPe/RmSDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p0ODYWU/; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBSAcJCoyX0HLwY4Y7eqLEMwjKKR/Ay8mzXXxTEBQuNzR+M5DHzVoZ0MGfgCjx/r80cf9u0Vgi67xMdL6mPL5j1/BDtP3zR0F4bBU+YteJ/EpZ6SY8eAvmzkX1mJ748KcHtRKj37zL2R54uhYo1CESLHz4m9BYVi5iM29IV8gRdJaGcuJrgoh7qPO9U83ferXXib9clvMFDe7WvYRO3Y4e/urlElPbqdtpUIgHa2eMIpFFWdePn6joMt1FSGQZoPHizFvUAhoE6yyZ0bXd9T38nKhGoeDp/0oUjh2jfaMbLfdUcrWk8JVLYD4HNqFD8IlIqxpG9iI4yq573GYmfA4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKDrPIO/QWk9rI2EOx2e+ni1hyhZbNDxAOjlD7faWi0=;
 b=fTWu02YTt/g6UDhyF2wNwVyxBH2SesEo72/OOJHgtlw85jkTZ1NqDrqix7FgGXogcbFkBSt0RyR5yrn3VbZBjc9yGqcoJzSTfoUnkJay/UMkXoeNp86IDAng7P3fQkH2jiGglXnY+ImYRq9KFGO4gIWH+RCCctzhZG03Z5nWWuAGtPByq2ntnENS84be4wxtLtu0pA2imSK+0J5E6MIgaMg8nb0b0xqXPT6smQZDxEt4tkzEPLtqbLW3hBmuNEM2BlM1xA5A9W+SBD/OGmdeOIydXRJzlzeNKZOyzniJChP/3D8cG4ynIO9PwbLmJTcri96CCKPyvC3cjdivQsLxhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lst.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKDrPIO/QWk9rI2EOx2e+ni1hyhZbNDxAOjlD7faWi0=;
 b=p0ODYWU/87Mkkbz50iYHTOxd5M6/hR47RIWkLWkEodmNbp5OcfXVpX39HTaeaiXqoosNkVy3B3tejiGRqTEDqF7lPmQQec4w9w7jioX7xAbxT2Zzj1tiuBE4UAuwPYqufbTEqYdKsmA0/NnmLujFx7B/FiH+XUEXI//TLXo1Ppa8UCe3uxxZErdajeGVMTI0mWOMIMM1M4Ylp6GdgS+hCde6ju8lQSoGPkKRI0FHTe4Vk0MhqE7vT0ycf4YzjauGGXMqfuD6gzSZYbjncq4YPL+fNTAK7lgLXVUrc1RE2L9iNUWHQ2ZfU2NZeQ9qyVfaBUN1Je/ShhUTQNAe86fLLQ==
Received: from BN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:408:ee::16)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Tue, 5 Mar
 2024 10:24:11 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:ee:cafe::af) by BN0PR04CA0011.outlook.office365.com
 (2603:10b6:408:ee::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39 via Frontend
 Transport; Tue, 5 Mar 2024 10:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Tue, 5 Mar 2024 10:24:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Mar 2024
 02:23:56 -0800
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 5 Mar
 2024 02:23:55 -0800
Date: Tue, 5 Mar 2024 12:23:52 +0200
From: Leon Romanovsky <leonro@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	"Marek Szyprowski" <m.szyprowski@samsung.com>, Joerg Roedel
	<joro@8bytes.org>, "Will Deacon" <will@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC: Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>, "Keith
 Busch" <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, "=?iso-8859-1?B?Suly9G1l?=
 Glisse" <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<iommu@lists.linux.dev>, <linux-nvme@lists.infradead.org>,
	<kvm@vger.kernel.org>, <linux-mm@kvack.org>, Bart Van Assche
	<bvanassche@acm.org>, Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	"Amir Goldstein" <amir73il@gmail.com>, "josef@toxicpanda.com"
	<josef@toxicpanda.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, Dan Williams
	<dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>, Zhu Yanjun
	<zyjzyj2000@gmail.com>
Subject: Re: [RFC 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240305102352.GA36868@unreal>
References: <cover.1709631800.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1709631800.git.leon@kernel.org>
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d8c86ec-271c-4d49-a081-08dc3cfe65ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BBIKQi3XwMpwRZW4ws4G0X7csKdJp8PjgE8LcABnBH9f9odwT/jBocsHq95hFFZKTwnBJc3m3SpgzMoffHPT12fgW40PukCC0IttAzgf53Lw3DyJ0zZc3bRl9fTr1bzeOtd8ifH4QDvZJiiHbEUbZo0Z9vFL8kaqbTmLouxu5Kv9MMJcEy2LRwMohZEEKmf0wlsSBzrbAeQt6L7lT2NT/fvvAL4rPDmF0AlnKKdqtuYF+aPDk4Tm2JqHcZ1SNVsdlVOLkNN6aPxaI6vCWo5RkS9AKE1nO9Wjxh4RxcJn8+hyj5LyNMlt56Qu0/8cWG3G56HcxBiw5pPjimsdZSsx21NysqQrq5B/AD5vlgw4sPSUDPTjUSLkcTpBrv3OD7riiME3lXv35NoUqy4AEop5xurJcfFEbUgLvAuFtr4A4CYgdIDF2HgsDRX2IKJoMiCq5Y4hHCzEolrllwd/n4wcCUHesmyToe0vgsLGyNSenqeFq3j1FN8qmT9y4ut636pPgihTaRq4e1r9/35Y027ELem4OfoHKCBeiFF069qHxuJonAdrTMROouAoYyxG+xiVUVbovQvn4se/pgGCyb1N5VjMAff9VcsE3mCdtJZuprb+uvWgqJjKYwyga0aebvHb6DfRtx32+675JmQYzLGUX80ygJHZNC/NcunyKg/GvAJFjieeYwK5WxGFBD+j2sQ1XiYyZjGilY8XgYcl0IWQMriwDOT93sjGlkfSfUGvrMkBgO+y1gcJ4XcLkQqBB6/J
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 10:24:10.7415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8c86ec-271c-4d49-a081-08dc3cfe65ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399

On Tue, Mar 05, 2024 at 12:15:10PM +0200, Leon Romanovsky wrote:
> This is complimentary part to the proposed LSF/MM topic.
> https://lore.kernel.org/linux-rdma/22df55f8-cf64-4aa8-8c0b-b556c867b926@linux.dev/T/#m85672c860539fdbbc8fe0f5ccabdc05b40269057
> 
> This is posted as RFC to get a feedback on proposed split, but RDMA, VFIO and
> DMA patches are ready for review and inclusion, the NVMe patches are still in
> progress as they require agreement on API first.
> 
> Thanks

Please ignore this cover letter as it came disconnected from the series
https://lore.kernel.org/all/a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org

Thanks

