Return-Path: <kvm+bounces-41715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC239A6C2B0
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4165E189EFC3
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97B922F3A8;
	Fri, 21 Mar 2025 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CRHOvNy4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581E61EB9E1
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742582531; cv=fail; b=gmkeBno7IcYCA+15r1ERBo6xtAmyZIKLeMhJQFotAobhibx2S7GCuPK5nqmOvu/RB8D+SxFgKiNMyaUrmdFETeObh1Iu3RXMLFQ7U+hLvtIXzSwMzP7I2zRbVsJ9x1rHP7vlV8AoMjAj4rqa8WWR0mT2TZBDYjhP+nbYqauktKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742582531; c=relaxed/simple;
	bh=rHVjyLb3m4A4B3lCbvo/trkhN0X+K8VKDlMYVKZVxtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E2zqeKn3BZPpWnby0W0M8bgs0RuLLduB1HjWdf47CDHqyzAc+rDOZ5NNNsYxhPhXDrFzPCjqBgCMQ5RRBv5/kEaiC++4as/nZ9SzQ6R0+YKAuM/B72/jA7bQZ32PczoAjdrx9oic+GkoFA6wQwEXZjKic9eC4p4c71xfGBsJEAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CRHOvNy4; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUMELfiDsNiY8VP+n18ujpjKr6jTWkrfpCqH6In047DwhKRz/GyOxVBG5F7O/nbaNGDNInw9TEHGTsw5lUT+7FSvuCgvKCl/PqIUb3qWMAYhit2dcnPZyAplm5e/k2GMWdkOLRA9i5D+UbmijTrE0JN4icVh+xcfKX1oiIWHTohzJ2ESYK6NMBPhfrzuCStvbhyaDOOTcansa2Yjx6ieBDOEXIp1G4hg7oIcTJAtFSa3F5Dn7LZnwAa3tNYcMoLnV3GjL66fsEu+U5jgfQEHK/R1TaxwA+5QQzNlblEgFWaApWS9K4rG/WW98S7n6TMRcTiikiL7jyE4DG0ytDVI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHVjyLb3m4A4B3lCbvo/trkhN0X+K8VKDlMYVKZVxtE=;
 b=ES8t387ggzAopFweklSOwIgQzYQnzan1EDTfyyXnIlHRd1riTl6rIdRkPGGEUxZ2IWhuovux0rdrY1hyHamFeqUDH/d8GF05gEF4x1og9JK7YSrF3Cssgb4nAeXVeVph1GdvuWmfXqU/qzToxHPy95eo9DKWiGIoWs7QFb2+RsYt6H66W3yYP705CiUShgl1JSIFB6wUbtdXaGNoxjFYou/Rn8B69giq4bzGgdH3HHKUpivp9AD5051BrAE6NTFv75v7XcC36uZC3m3ICKGf5p+aHI4xLShisPaEJuqaQ122DRp7V2yA2bG/DwSoET/ek+5uiVtxj+Z8xHWSF7ZqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHVjyLb3m4A4B3lCbvo/trkhN0X+K8VKDlMYVKZVxtE=;
 b=CRHOvNy4eFjpRNNS6ZYGU3fUKxgeQ8hBaQsXsQGDM0epdtu+ELVoztRYqFeUeyH24U0WqwS9lnqFUYx5fOtGo8G1uxMma3FOZFs8umAUyU+N468/G/cn6u5BqmJcbAVPV3QkeI2p5rTFon4i7vWSaYk3khaUxG3As7VjGVR3OV5HrIWyaqQ4tsWRGMH00vZAUMUVZyLVDwjiwiES2CIXLoz8n4uEAnRXAOGQtrCl+zyw06J+jzLeTX9jaD6/cS3n7Xle5kIm9cLEepxbTmYbsqMHttE3X+k8yGcVPRgo+HPuK5m6xecETgL0jYcQp+WmDZ30noTrDaMwK/oYwlxRBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Fri, 21 Mar
 2025 18:42:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 18:42:07 +0000
Date: Fri, 21 Mar 2025 15:42:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
	kevin.tian@intel.com, eric.auger@redhat.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <20250321184205.GB206770@nvidia.com>
References: <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
 <20250320234057.GS206770@nvidia.com>
 <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
 <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
 <035649d0-5958-45f3-b26d-695a74df7c39@intel.com>
 <Z92wIQGa8RcJb2T/@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z92wIQGa8RcJb2T/@Asurada-Nvidia>
X-ClientProxiedBy: MN0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:52f::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: 76fbc45f-ab6b-4fa8-f033-08dd68a814bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yUGVqMfJXaSWDf2Z7kpQiDe9fNDQbFbCp1OuSDa10I9WBYEjiqqwkowf0Axm?=
 =?us-ascii?Q?1uSNwk+ydbbLNT3fqbTgbDE2PeKcyMD3FbFGT4bY8Ib54L0VEiT2jGT6+aB6?=
 =?us-ascii?Q?aGNwO4hgQBBZAvSnbngluk12tZmZlBFfq8z6YDKOPJDXDy9W2wNmnIqnXObu?=
 =?us-ascii?Q?Ou5Ta/Zw3jP3YS7C+oAF6IpEhF8YmntzMTdXWVukSFVdOo6SE8b7UyvEnUaD?=
 =?us-ascii?Q?COSZ4TkkQsRDQ2aAwO1RwpC/vwyEx4sJZRX42IU7LfLwyTXmNGGXMTZl36nZ?=
 =?us-ascii?Q?tte9iG4fvbJmeBsCPXmTHXNxNkJqyi713EXPKMQBtRDrSStp/euIiez2iZg5?=
 =?us-ascii?Q?v+J1/K4NG/yJ885S7pHzt34hvVscmNxBXyL1W2fxXDirZJbBsAigKdvTn/0u?=
 =?us-ascii?Q?Knx5DDwjNNevw09XtG+kTBHUdsEqnfVEeSr+jdRl66tGKllu3tTHwVRIhgHo?=
 =?us-ascii?Q?mvi6JgTFgjTgVHETo9MWqGzUh0nCkWLMVOTiFZ9FPLe+ekCRx+CeoDUYtfxb?=
 =?us-ascii?Q?qOUJY2xFx6tzjszLfFKPuqaCYL2fWVMTgQtVNkBSb+btGI2j2m2Up9ezH6Fb?=
 =?us-ascii?Q?/FYKB899XZ44eqJJHFQURAToLxPhXlwZzYrvLV5RWKfAOQ0Q0d1b7J9p20EY?=
 =?us-ascii?Q?cxecj3xcOaO6Q22gFowxWZxbSWJltqDQMgf0KhhxuD/R4Tk5rp0fP8HSWEC4?=
 =?us-ascii?Q?0yprnqczf2eoyK8Zrrz7pP1PpiLXB0rRqTFUOpYXo/cDSDkCp9/yjKX/Rl9u?=
 =?us-ascii?Q?Pr3OvAG8F0klBsKe4horYib2P88KTyuCAcqP+wpd4jUFUQb1aJa2br41LYjM?=
 =?us-ascii?Q?x/Uu9DKoz6vsh0XEZH1xCux1bhIQp73OZ5Qrd79JIP1Zk1BPsUjppGPbWeb9?=
 =?us-ascii?Q?RJ53PSjVlMsmR6G2dJxrAjpFwq1ouIWZVD62E8qo7fnwJdXkabbuomb5BqNJ?=
 =?us-ascii?Q?KgzPh1lIfDsfMZreScnJyZup5O7J+PiitlgATpqLsRbGt74gfYLDH/qh2qGG?=
 =?us-ascii?Q?eW6WLNz8KNB6nezCTZsjdFWFLu2oljDgOsW8OL5amwGcItycPek3MpaEoSJj?=
 =?us-ascii?Q?+yl1cyIEXD6p+EDeqTfSmM+/HJ3RaWrXmtfpmkVxP0uP9QWgTa5bewYqoIYg?=
 =?us-ascii?Q?oX7nkjxPtg4SiadCEipT13ha9ZU6IFdLlbNEB27wwd9JaiLomrUeVyP05p87?=
 =?us-ascii?Q?7QLM2at5sBQokIgVRZdxGLEZlKkcMPV5pIGtsIwHULRy2L47r3DtjW/LDDJJ?=
 =?us-ascii?Q?SAtCrZbg5N6wun5lup1Medo5EstCH/d+xunF7N3GahQnNAJInwcUFN1ZQ7tl?=
 =?us-ascii?Q?8ZAU9YqIm5ajBZ6UrMsPf4DkxrRoV9IxS48XD0jaM+WLSeQR86r62zanUaqE?=
 =?us-ascii?Q?p+QC5WOWGaHMdYhXyHGOjIj7Eg2z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8o5091kkLn/ItO73mJYZPxb4u2tnSwtHjdQQAvpRo3VNpODkbpx/85TunCk9?=
 =?us-ascii?Q?C7bH3ryhAACMKAxbD6lzUVgSxwLV6Lu53DIUUFv9bff597NBJAc8dRJMdAi1?=
 =?us-ascii?Q?X+wyOX0vVWdOYY8rd68of57SGujiGk9CRFb76llmaL+ss4LSW+BYCiE3+IAQ?=
 =?us-ascii?Q?QNXWkrB+LY3aAS8BIA36IKDCiPtRxshyyldJqBwPOBwOKZVusKjn8riAO0jL?=
 =?us-ascii?Q?aftf/WSoGJOS2LEnAg05RErt2bJ3mlPb/EJGUsXSfsGZUX9Kwnff4QXLHXAE?=
 =?us-ascii?Q?ux5cUAmNqc9/f8NijIRpj6OBtgwzhMYHEfnIlC8Jq3IJxo4Uinfv+aSwVPJz?=
 =?us-ascii?Q?F3SQoZ49auzc+3vM8Amrx5Rtw2a5i09c6PbipDcnTnUFhIxrLtb0HwaPpDUc?=
 =?us-ascii?Q?pLCuRd54JUjW5EGJLbWLSX05UQapo8ZgVgF2SwDzdseCGI9zKiLIBeU0Rr9p?=
 =?us-ascii?Q?jNxgYymQMiZ5HlBP+ViUevgaZXsI9xRBeew0qyyQl9g6nOz6ApAxY3mFC4pn?=
 =?us-ascii?Q?n77M5p+uulcrRMPN8DYzHtwuMDFFYblP8ZRj/rM0VSVKT6fgPgmBhR2MyrgT?=
 =?us-ascii?Q?CwaE7qX9eS0a9zDYdu5fALg13vYde0ymdBOYlWPieCLCXzsmY3ODqRsesKDo?=
 =?us-ascii?Q?ZFdCRbAjMwgo2A/Y4pP9f/nLVVDiOCV9a1wwNi3phsDL8PMv+UXAVM+uoRpI?=
 =?us-ascii?Q?5mSE5BB/1hNpQSBE3waugHF/TkKbISIXN0HsDpiVDT+fHk2EDlElx70odrwF?=
 =?us-ascii?Q?NBMSU7xAhoGUMiaQu7ohDpOfoGlyF1Wb+2E6JHwDdHRIZTgLNzM321Wi+5J5?=
 =?us-ascii?Q?bHLpsx1otID6EjmF5coHyCTbWpFKxyVlDA4I8yN0ca/yNM7Xvj4uUeWOJ+En?=
 =?us-ascii?Q?wLsCPiQnU6lHAixhrW74DUTl/tr+5FilBzrnfTNryi7ckPwk7FKejU51jsNW?=
 =?us-ascii?Q?THy/kovA6J7txbIJ5qFWAFIwseO4+WK1xKpkLCrwMRcaTYsVplz0cZ42z4hX?=
 =?us-ascii?Q?F5vQ0qPSvf/woLKxRW7LBPj2EXlldv75Y2B86qN0MvOvLb/N6WQw93oT2R3J?=
 =?us-ascii?Q?tGAQXaxx9eKEjsbWH+DjlZF9ghIQqjJnuF+OcOgeUXGfsfF6gp3sE2QYUH1p?=
 =?us-ascii?Q?++FZQLbfx1mPnScYXJJgn90JGjhkvre1MBq3LiQIJ1t+bbR7F4GRQk3W0kmq?=
 =?us-ascii?Q?n2ILLw+vWw1VHbYGBF/p7abnFy0E3Z3iW2Ege4Y6Y9FUOwHiiVw7CoCZ5crr?=
 =?us-ascii?Q?PjqvJVwK+nQfs4jRORnk4ei4rg6vy3NLVkqs7XHaGQQf4dmb7U+MGwyJ6Np5?=
 =?us-ascii?Q?PeOH12KDKhXw1/+2SOcn4zu2b5HGYXfD+MuecMHjTj/6gAhhTiK4J7NnDDnt?=
 =?us-ascii?Q?kdKvFyRGH597p9vg6ZkMyqNSC9yLgoPdzQqEQkO7JDp0fun5H1WgfPMghhsa?=
 =?us-ascii?Q?zdL+jCcDp2zzf9arygRNg3x1Pbg0jHhvbyyVWidRCO1xVLrpw3S+BqDyE6XR?=
 =?us-ascii?Q?ha6MaCpXtU9F2u5rplMYwcSNuIiUyWb8oYv+mO4wZ4JsnfUn77JQVPhPGcxo?=
 =?us-ascii?Q?uLQem/uVdnaUvRuYlwTb0QRxwHqDB17Mq4tOmFr5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fbc45f-ab6b-4fa8-f033-08dd68a814bf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 18:42:06.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLumUR5ZW0sFrO0PwFls/OAHxg+qeICdV/uppmsuQlIOHFU3HkA5uqNrwGYkj00h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183

On Fri, Mar 21, 2025 at 11:29:53AM -0700, Nicolin Chen wrote:

> Yes, this is a per-device ioctl. But we defined it to use the
> device only as a bridge to get access to its IOMMU and return
> IOMMU's caps/infos. Now, we are reporting HW info about this
> bridge itself. I think it repurposes the ioctl.

I had imagined it as both, it is called GET_HW_INFO not
GET_IOMMU_INFO..

Maybe all that is needed is a bit of clarity in the kdoc which items
are iommu global and which are per-device?

Jason

