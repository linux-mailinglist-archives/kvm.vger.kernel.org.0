Return-Path: <kvm+bounces-26950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFC297991E
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 23:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 202F1282CAF
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 21:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6525B216;
	Sun, 15 Sep 2024 21:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xc3zUvCA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6D4644E;
	Sun, 15 Sep 2024 21:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434471; cv=fail; b=Lcib3CZE8pwqFyZRQYiYCXF8zskk8KT8DEAce6YJERHilwNuhoAb4NqyoegHGLCnXNgTfhOufRtS8Xde1uYzJQ/fUwAbOoYVAaFfChLaY2+ihLrqbMV00I3304kQL28LB9tYxlTlfU6psGzNwX+G8/qh5nCPHQDgnJLcrQhzx8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434471; c=relaxed/simple;
	bh=9kTYAALRlut6O9Vbxbjsz53y9Kc0nj3zjBtwP4Vtxto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YhPD/o3gqgzGjQjkONNgGdfquMsy9UUr9PgtbS9OKh0gs0I8v7lVBC47y4fx5op1OGsIKTxwf2UFFq5HlRo6Q/ghfNXpsQsx3sInN31NbIoBRa54660uvz211PWTgm/KHTrXXPeSKwQp3zAWJ+U52p8o5DarDK04gFiHpczzQ28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xc3zUvCA; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N1vgbhpU1t42anwaJ5P6F0kLVGnvjfYUKSWPP2IIZd4J5mG+6jwDOcPKyTmTB2OwFEtI0ELBbJPWWsB7qOM91dlcJDbKZ9UrTMN1dujzEPZapumOCdjw2Pvly514ceW42GpJXrvoeK5bE+WxotPTqiRB7HPncf/4fFJFNnatLRMib0FJ+Kzr432yK/EvDiyPZHR+7Y4F1COsGfKh2H0GyNm7fbGPwNXcLDXDZVf3UclqQ38TqCfvS0JkY+KT9xQvoQ/e59a890nqBCmTGRMlo6ID/2ft2Jge/6d+dGrIWvfIGhI/rpMV5VHYaJBDFzH63Us2lB9mcjxltznH0oFWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kTYAALRlut6O9Vbxbjsz53y9Kc0nj3zjBtwP4Vtxto=;
 b=jF8UQuBkbUNmnqoGXzju/+Wwa7dkqesrhiVAS/EeDXw4sVmNidKMYFwAZ7b4juacv8cvXmJQ7IQBzU7if466rEvePun4d7Ld66sM6W+v/5jPMwmm4k12oX9ie9YMIdAAQ1Ecn2ci974GhKANHsPmVdnsLEBmocMwy/pisDEwwV5vzR5Q02zQvcJuF02jJqMbzHCHcdgRh36VD0P+2ygWQM8E5ZITGyNDsLASm0ulnrWtIATExm0qqXIksLwTIjBodPwqow6c2RU6V1X8Lonmtw6xCrqF/AehW5Gz5mOBFO4akeOMPCRxNRvXTf7hoWvv1kuESP+lXhJz9oWXZ0sEfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kTYAALRlut6O9Vbxbjsz53y9Kc0nj3zjBtwP4Vtxto=;
 b=Xc3zUvCAgqH6bse3JQUEN6saSRBnVJa5L82mKWmdDcvG6efQ/OwJHTISgbXb2oEpH2tKkcLL3DaTy5vyVIAeeI4nDDx8ziyQTDD0b1n2jRgWmFb/ZiXxQfPR5kkOaXjq7ua/6OqtV+Plft2AZaGZDlESZkukx/BNnI2WcyRFRTVilggxnjY2JO2lyIQrz7mPhdXcZm0M5uXsKzNQNBrkwsHiiej/E4UEkf5qkFDg81/m8xC1Yj5X9aTOfvKQkl+ypc9DjSlEmwaFiXuIlyN+gAWzKK7vN4vGDqXXOo1sbmhJV3DHsedDgXC+8fdR04cIERgOO3S+1rfYKDp/t1xshw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN6PR12MB8469.namprd12.prod.outlook.com (2603:10b6:208:46e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Sun, 15 Sep
 2024 21:07:46 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7962.022; Sun, 15 Sep 2024
 21:07:46 +0000
Date: Sun, 15 Sep 2024 18:07:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <ZudMoBkGCi/dTKVo@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-13-aik@amd.com>
X-ClientProxiedBy: YQBPR01CA0033.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::41)
 To CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN6PR12MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: 416aa0db-fb9d-4c77-50d8-08dcd5ca7284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kwwtNNdAJ/XnWmjlW/3wxILICgTwP8LMpmGG3cG18Ra1TbISg1h9rRFCH94k?=
 =?us-ascii?Q?aLufqPwHlyUd0evt5fu82xRz0beZ+tvZZUbe8U/cnST2p9zc1vORPZmf98fC?=
 =?us-ascii?Q?se6MNhktaBK1vNNEsZlI3ks8Nx90jCcogTrYoD+K0zTG+rhLsxgH6d4keAp8?=
 =?us-ascii?Q?CKpNT+ORFTV+PJ6FQ3j2DKrhvj8CwqoTOMrtUvnd5yNpQIW+8Uon29RO4dVb?=
 =?us-ascii?Q?27Xw02Ie0yR1kqNbFvMRg5f0hZ7zXMNHRWoAQIqlfUQJuJzrIVQpyy8yOk7t?=
 =?us-ascii?Q?gI+Yfoipkp1C6MnowM0qt3uMydFV9HLyAffyHaC4ZqdS86FUxzs5WHsD8FMx?=
 =?us-ascii?Q?rZt13A/7t5ce07XKWEoDcPPTWWmMRqlFB1SJ7qLffg7DySf6ZqheqO/6LM1e?=
 =?us-ascii?Q?J15YCKZcXNiuThn2AG5sjLCtxLS432gioKHkYCL35ZhdapkQseUmXyB2vdqQ?=
 =?us-ascii?Q?ggLwYi0ozsEeNs5UTpROwQtguRzfSya2gZY5CJKb7Gum06KEzaJ3QMG3rlv3?=
 =?us-ascii?Q?kn9/im01uGlos2Xb9CFtbTRbscOcy0vbzCqnmiu64zn9hEECQgRlLyk/JwSk?=
 =?us-ascii?Q?+9XqqMDGdfkKMxhkbjHMKBrG0SGs5tS5c/1S9JI0pDeNAIF2niyW+pEs44g7?=
 =?us-ascii?Q?RZQH78zyPI660whgpsTCQxqJN5HZEJagJxwGRk4BTLGQ5SsB9/9ko1b2IXU+?=
 =?us-ascii?Q?58v5BdEBwxgJVF4NrWOpHRiiqh+0CblCkmfQ4BkwOFAyJ1F+o8ImAtXI3e7s?=
 =?us-ascii?Q?NS6UUBWMLzwkF/pwoWhxIrqNNffBeGByPbni+7YXbr53y8UXB4ajbFieeSTe?=
 =?us-ascii?Q?464RJjQ5U28BYc5hJjhYCELCjdz+AF9jrCYue7BS9aSLoUBtTtQRs4IJKcKM?=
 =?us-ascii?Q?UELwqqaQEFUov/igTONx+191kOlLkfKbhrlMO8rHDQdwtajZG4LFBPHkA4hD?=
 =?us-ascii?Q?UaCXexwXWhUYK5RCbhyqNhhU26I/14VkS82Q4W8sJnFBiI5tgD0aCLd7fKzZ?=
 =?us-ascii?Q?98E9pijj5tYnU3Lin+wPKE51PlX2vkevP6meAN1EzcSndUZUVZS/Bu/AOQeb?=
 =?us-ascii?Q?TVB2ERa3S4MQdyaWQOa0gnASROcvFrhNRSyeqAWOy4oN8EUNNlvvComvaWxG?=
 =?us-ascii?Q?EyX/dMrc6L7b+5u8d9Cscfv543eavdOakEJGkedzk9QuUVym2uDu7t8RYb/W?=
 =?us-ascii?Q?w8uAlYwUG7sBfxgPP9/YtB0ZXJNvN1AxH6+4o12H3QOestxYnQH3k7ksxJ/8?=
 =?us-ascii?Q?dLbCNQCw1IbR/uSBUtExilgE+bPhNQ+8wJxiSH2YWolCsIMnsNHECp114jhc?=
 =?us-ascii?Q?ITkGOYKoBplq2qf0Cig/tVOPNopv/4tzq3DkPo4Ip9vM+6OhB+RKbQSdxbu8?=
 =?us-ascii?Q?aELqkX4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QboZB6KUpioNuxFv9TqenmjiTSF72uV5BU5l304a1hnKtKAR8LRodlSXKOKd?=
 =?us-ascii?Q?LRbaGlgPN2xHvo2dP3Lnx5veTKE+kSKfKgUSFnKlBoxjKxGGkZKnQMNxmPbT?=
 =?us-ascii?Q?r7PJ6Y3TVD2uh0a5fvFDzUDlb+Ro5tFHBqfKE40m6tBOTlDAA438TWyrC2Q1?=
 =?us-ascii?Q?rxSyXrTBnXCNV9QSLq+H4vlNMdOpzsCjC3VLg4bBAH8X0VaMvc8T/KmHy9KA?=
 =?us-ascii?Q?Gi6E7s7rEU1N7O/hlf4SFiAUVIpxMm73cL9HRfxTfIUBqSgyMfaSM9oGoopR?=
 =?us-ascii?Q?4Lgxxzl0blkHSXzcdGjLPoLx4cs59mtcExD4jylNsIMP49hUHrbS9w1oeLWD?=
 =?us-ascii?Q?J49r/oAKNlZE6S2Hd8Qvnsh5bQuaeXYME1u/n3cn5xsGdoeoVYsMn12B+vvI?=
 =?us-ascii?Q?cxwgks3JqErvqf3E5z1OXA3W39i6qZjLhst182wdQd4PH3z4VCefuG5EiK7l?=
 =?us-ascii?Q?tAkZsh41pAL5kK9ymIoLI+Q94ygw7mn/SfuNIXBKvXd6DBelMJ/NVdARTmU9?=
 =?us-ascii?Q?VuwDvLKcDGnIabrWCSaSP0i7mDdxlz37aFte3hMbvLaR/5PJ5E4+0r8ULx59?=
 =?us-ascii?Q?hVHlNqAkFgdAKbp/I0BoOozGZue5/cqs8u1dKpPwVi9m2bxRIGBe9KMOcerj?=
 =?us-ascii?Q?na24vvavEhU1zysl3y56I7GxOCSAYIYBNivGxpl/Ai29yNI+/N8aGQ5alvQT?=
 =?us-ascii?Q?WrG3GnEHsWvueEv4ncXX8hVzUW68fMeRSUjtwVpyStpwoeoDZTVaBdKIW0qI?=
 =?us-ascii?Q?rMCdJFZ2f7PgnbYbzuUhK6MZqYKw2vOK8loi1Dl8hBlolgsus2QaLVJGXhD5?=
 =?us-ascii?Q?qC55jVCXVyYIGKw7wRZmEJCuKRw4O4ultrq04G/m/r7yZ5TeIL5oRUgRur1j?=
 =?us-ascii?Q?gppHitENVe2xGqZyE+GU8myx03Jq1h1mybYvZgIFfAjqok/lktU3sRcSCOW4?=
 =?us-ascii?Q?TtoDpYU85N9PoDJhSQ3ZLlnUmM/pxER0mYDS0MmbwhZZ8kP46mSB60NZCaEs?=
 =?us-ascii?Q?e+/m6rvEXUxrPfnbae78fvo4XzPjMxRMfU5cp3B5B5k0lDOmP3EvfOv3LJRT?=
 =?us-ascii?Q?5va1xSFZRJvDZgnm4yDXoadWrgetJjD5VCwTE5BhY1rN277UcjmxawoML2rk?=
 =?us-ascii?Q?ZNCPD72/dKbXlGso1sLVq0uWWvbKNtBJXjHynahdwhG5nH/KgyFUXl/zcRpN?=
 =?us-ascii?Q?76hFLKtCUtIhU28ysyW3Ms+OpBLOpa8vT4aE3VAnTi5ISNmgLjetuJsjksZa?=
 =?us-ascii?Q?W2BLB3T3/NBTS+kgSifaOETY2UJwOX09LhZFtWt3DXDEqVkrlu/vJ1Pex60b?=
 =?us-ascii?Q?pZvyoUFMWXt+ioFasfg/2tMvlwCiLx7LOGPLfjZUJiU4Epu+zQKEOTtXtknm?=
 =?us-ascii?Q?OD7Gh6VepFEqzCtzRacgBjx9Vby5T/qBF1RCmAHjx9bg3A7NVMSIuI5GXHkK?=
 =?us-ascii?Q?skN1Hg5Xw2SK3xxPnXbtbV5ZAmZS71iRWrdCAQP8nWnJHV1bxf8PIqU69IIb?=
 =?us-ascii?Q?sB5g0q935A9O5mADTtIa/6PXOhGW830tOgy4tQIhEajq6ER629JyXhGPaSLH?=
 =?us-ascii?Q?1/OX8DZfCDGbTxEBmyNlVfy1y4KxojwoJaVxY1SO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416aa0db-fb9d-4c77-50d8-08dcd5ca7284
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2024 21:07:46.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDZuxgcQRWWre141qjCaPGRq79zs6udfQnvsQx4udXrdkLwNlwAC/J0AyItUO0yM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8469

On Fri, Aug 23, 2024 at 11:21:26PM +1000, Alexey Kardashevskiy wrote:
> IOMMUFD calls get_user_pages() for every mapping which will allocate
> shared memory instead of using private memory managed by the KVM and
> MEMFD.

Please check this series, it is much more how I would expect this to
work. Use the guest memfd directly and forget about kvm in the iommufd code:

https://lore.kernel.org/r/1726319158-283074-1-git-send-email-steven.sistare@oracle.com

I would imagine you'd detect the guest memfd when accepting the FD and
then having some different path in the pinning logic to pin and get
the physical ranges out.

Probably we would also need some CAP interaction with the iommu driver
to understand if it can accept private pages to even allow this in the
first place.

Thanks,
Jason

