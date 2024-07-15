Return-Path: <kvm+bounces-21642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0F89313FB
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 14:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF67FB24459
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 12:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D89F18A958;
	Mon, 15 Jul 2024 12:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pg8d+kPk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F032AD31
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 12:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721045956; cv=fail; b=Qg8R/oAGnHEyvsBx8TbyrZORIYF1qiynxgD53livOXZ2eqgHpOMm3pkwuEL6Vy7d+h5TLHHKJye6Q1Q3Gud1aZ+eWMLcyHp50K+Ffh4qtMTbUUigP/fPo/N/ulYSKd3nfIMRYnQAo7+FNSyvHvySnJwdNpaWzDZbf/yRYqwMdPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721045956; c=relaxed/simple;
	bh=fwqcT8t4xJ641g4C/I/NDX7ouNWxLdmCxNAucM1rUl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bPC2dUcQI/YH299vsXOCxHj2fPUqQ1jeL+1fgpQoT4CKutmoxXkuEUMlt2yi0Ig6OXfKnQDW4GGbWC4+yrtRVrwYnpTFqkhUvM9/1a7H0OBaSVfKlWwIYC3siNku9aDCAr+bH5VpVFIkj90E6nMaP75DU1QjSMq1cfs45N7POSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pg8d+kPk; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=meSiC+i0d0lSZ4BvANDxgM+gzDc+r/gLog32nNO2aDHhgYOXyTNsRvy6MS9urQ7lbFXLmijx26Pw0pW7xNGa0gnLPLA/wMHCibdvraFBBAlRCmrMrhNpuUE7s0nmHNhC2R974ZZSQl7Nh2yZPhOb2nY1kgiEmeckN9kb0j7CQeGVtro3uehhfeWfEoFLdwJbhJ0zzpVSSUdUt8Mmo6n6y5L4RBrtsbfqoES8kCfPDaJ18IhiY7whuDMk9GbcTViq9t4v0F1ubR/fxyp+Smjn5y7fvZQDnI0MOTRzODkJiEJ/0aVYWNm6dgis7vwqIF/id2baYagrkdBpQrj+jOlLTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2pgldiR97lqVdPkIpZsbGnqsRrtGPB9izyXvaIItho=;
 b=QFV3rIFM5k/50GXa+cIVdrRh3K8OqE1vW9aZRlbJE5WASKdVZ9WvW9faf/Hwk+wodqn+IVFsuiArfDT4tGtakEpvoIXJnQ2ajbbrXja/gKxIQU0b+FDsGeMeACz77IKQDI98S1BV1lY/4njmpJqW9DBnJTdWpkHVeYQvRMwxC8fdjvSnx/qbaH1MVGvwGbX+9jVG6nKw+aoA9D/oc03oIKJtSOixX1WZjqdTRAaIYEDHqXTiA36Q2jVhd1rQL7Q1W2KuGTahFxXb4B7fdXbn72p0xAefiU5vRtxzH3bdTKvbJma6B0/UsM1yCqUGcnsjhpmdrIz5FPvegYb9d4WQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2pgldiR97lqVdPkIpZsbGnqsRrtGPB9izyXvaIItho=;
 b=pg8d+kPk6FPp3YQOUTWBs3n9j8vSS43khDTnBNJ+/vVv37h+bFlwDrpceHgtuz9nEuvlNUfhBX5KN0kRJTv9/Ls/uZ4O+7QZciSPy1yAxev5ByPSD2ih2TL1NuT7ZFJzobNTxJlib/A5uAcDR3xq0LmCdke9U1YNwmasF9uYeA7P3YJFI+72WsIstk0FkEqf5bRlykptsumgkScp5Bo0w2PedfdKjWcOQezHQpq9Bhf+DZGdNUunae6Iezr1u1Y0ZwEn9PQYQ9VOu8p4jeZO2bSHiCv6mh5HvcaCbgE2XnWVlIfT+H503vnZRBiMN6FI+MusHSxKLycytsJKi+CNag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:19:11 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:19:10 +0000
Date: Mon, 15 Jul 2024 09:19:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Message-ID: <20240715121908.GS1482543@nvidia.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240711184119.GL1482543@nvidia.com>
 <BN9PR11MB52760966CBFA7DB116ADCA338CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760966CBFA7DB116ADCA338CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL6PEPF00013DF8.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:b) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 96966544-e911-4b4a-1da0-08dca4c85520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BU0gJ5TAKvLhSwQ5J5e0U2ki9lkkPmzExRjygQufhaZVjNSt5hV2rsVvdg5B?=
 =?us-ascii?Q?DNVRyqzv7CChu1o+NT4JzE3n4nFcbQMi2ukf+Kvs8VboVMwBwh0/woHwArsZ?=
 =?us-ascii?Q?5MEqzQ0S5UiMhrS54BlSxYwWhH6lQpyow2NMuZi85+3G0VopaGO2E1mEETZY?=
 =?us-ascii?Q?7BeiBIEs6vfGfAKH7yB6Wl+metTMdeWLIAewRVNSYqqxNDPZHuDDmmhBF2TE?=
 =?us-ascii?Q?ri2dV7h2lrTWX4S2KHIR+jyJQPI4k7LzF3DHbJ42CL2iv7hY1YHjY9vPFxTm?=
 =?us-ascii?Q?7bMjbm7nq+OXx/1JrNjhgdR2tkFbqqAbS1+uKssA80y08v81hfneMOrlVUlD?=
 =?us-ascii?Q?zB9vUsMXoj5dTD7NAql47MWh/reSM/oA1cKBEBgs52UvTFjJV7myDetXQuSi?=
 =?us-ascii?Q?eWFVhPMSetilMJxIPYXm8bh9PUKLfJ2g/7aRfDT4c/ey8p+kUVDNiDXA4Oy7?=
 =?us-ascii?Q?OMrqlVfpru0DjhSpqCAn25yLktX31Upr+q9gNFltMQUVYztF6wBsvQiB7WEI?=
 =?us-ascii?Q?0Wi+iQJZi/qtiOqOhnj0JhbU4iMWqUFpq7O8IekHpJcH9TXgsdMTnYveSnc+?=
 =?us-ascii?Q?kmMy0oB+5BJ/+rvLRMraU48+/vVO4QXxn/vRoN7DoO1Ucs05WCN3cRK7KaTC?=
 =?us-ascii?Q?8KFDufighTdptx4QKZzCwgl2otaR/QHDj3lwcCwcoZn9NtrCPMKm/GQjHO2D?=
 =?us-ascii?Q?aM0kcupUTlHK2HmjYmT4/vDrX5syiAjOthDbpR9zXn8v+N4b3HaLSnYzleKn?=
 =?us-ascii?Q?d+1/p2R6QbEv78n9K9cmH61NJUvICH+ndDej50wpr90ir4SKJz/VEscqgwyC?=
 =?us-ascii?Q?6+PzJ0daofo0Xnagr8pex7HjSdic4sfnbdArFG2a9uEhpxAOHJe1cUWQxcIy?=
 =?us-ascii?Q?hPqP1Q+E3OigTCSK2HiP+BBIxmsmA74LDHnQDWJEhMKM7bk5ulEbflHCQ8X4?=
 =?us-ascii?Q?Z+M4D83KdwW8vCTEnn1MqcCTwunkRzEmuSgF4GRq2VTG6S3xf7Zq1bP00AVN?=
 =?us-ascii?Q?pMpZfQe+hsUwnSJ3jFfhL4q1bOInYEhgWKrqUFuS1Vop99dW+3FmAs0VGXy5?=
 =?us-ascii?Q?WXOIhOlA/rjS/FPTWs8GUmGPnjZIYSzLSQB5eMBVFAY1CpzweC3jABBMM6WT?=
 =?us-ascii?Q?tRUSJSr8YAV4GuTCKUgO5vS7HOTy15wS8OuDdmmDc/0ftrSus/AcEtIsftAK?=
 =?us-ascii?Q?rT3n4KY0ENNMf/OQGzcRI6ei5EhliYJaHva10UxROtjFbygxsZBKwBUUAWIK?=
 =?us-ascii?Q?Ewj5Hta3UGtWGOfskGzjNUuzceTGYkaZFnhymk9pzDNmnzhqM86zWmjL7yPy?=
 =?us-ascii?Q?Tp7slR2AQnY3hCRv9EhkeMFvWBqQ9wcId+XQ8Q1H2rNoOg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4e1B91yi0O6jxDynD1tdzdmtwLNNmtZ5HD0QutcSRBfz3JLYQ+EfqrpfAKJY?=
 =?us-ascii?Q?lCCgdoUbtInNMFOiOHkkijUSufqaGzQlAwwrKXQIa2uDvrbsprcLkGfa898W?=
 =?us-ascii?Q?UMyt3Aawhfp++gE9fj9wRdvkKgpgMmxsHonP4SBVaaYMKhtxxjK6kS56JS1Y?=
 =?us-ascii?Q?EN5Q4zJQ366NaHeIxDPBhCgSkrN2fiwEzeFBmEdgiOICyYTtZyk+8tVFlcK8?=
 =?us-ascii?Q?+6w2T65ghWiE1bQGIwZ1bBhgP41bWYwAmawOLEa0+4Ruz7FhtGuzx6bAGXb6?=
 =?us-ascii?Q?8F75xHj36Yh5a7gOPRWbqHGCBH93R0H/gHdJsnJA8hn/AZA8Y26B1b+uIg5b?=
 =?us-ascii?Q?LDgOBYwIcemFar3irXstQHkdlDBwDZou2sm+a/khom75kvYIamzWmVLPqWjQ?=
 =?us-ascii?Q?A6q4AGTmromzF4CLklISfka9CGK+MUJPVjE263Dhd6YH0VbU2OPQvQheWUqJ?=
 =?us-ascii?Q?qdW6fKKS7FoCe3dkuxY18QBDYTh2jiAcmmpOWZc+K83azzMW8ItgB4QRVpMv?=
 =?us-ascii?Q?pJR+LVBbOhdVDntSUCo8d72VqofW0vz17cRWvpxA6T0d+EFuWuUeyysL1Pil?=
 =?us-ascii?Q?s6cy2iZyddnCL8pe++cgtE7UpoP/Cv9GplCPo2A562Bo4U7CEKQLanPxYg9z?=
 =?us-ascii?Q?bP95jrgCUHVKDxJm69/tOqWgJlLfgqMbMVBVJeAHzNmQTeZEwaRJg611+8Gg?=
 =?us-ascii?Q?BL9MHUDTe9oUnq2CsEEAvVlvA6Stw9dLRy8LMMCCa8aKBoG5d2t6d1QhtGbz?=
 =?us-ascii?Q?OcxF1r5kBXXqOvu/yWAQVxe5uzW3E0Z547G+mMYbxXpWOEWJjeNKv6yTrTPy?=
 =?us-ascii?Q?tF6efBgAxcaToo7L4bVsULVGsJSiuwNxNjo1taPr73S16CltHgNscVB/3i5X?=
 =?us-ascii?Q?rmY3jyrShMe8mCNDdYapqiNnYeAQLF3lvr9NesmBh3xGWAHDe2vQTCOo9R24?=
 =?us-ascii?Q?cTHhd3Tf9fyAeINZj/W+k6lo0RHFy3kCV6t5ythliprMLJXjeLtJtzCUdPmO?=
 =?us-ascii?Q?ynPzpBaEbGdgUErwpBbUXYTYRzY/FBVDowg20K4NfdYA/TPBL9TNfNeLUEzo?=
 =?us-ascii?Q?slSjXPNFCxjE2J6Bm7YIEK7kczYrNfi0j7ejrpLFr7d/pm3mrENc9/02kwKL?=
 =?us-ascii?Q?/HRDRRoCUIsUOjO3jxOY3rkzCOH4fhbFajTDohJEmXetyFGfGHezjOKHm42d?=
 =?us-ascii?Q?QNyk0qGRKH9bFSudZW6mqe37UXYTtbFaqVfo/QeNf9/0vmL6WHTu4nqZnwsv?=
 =?us-ascii?Q?1TeT0RyH2/PbVjv429eqln7XLYLgAqU6LuUzRpkwHFZrbi3Ht5Y+pAheNc0k?=
 =?us-ascii?Q?A9SJJUbW2PVGmoYfE3xgpdMfOIlXto5YRYdiIh/DebUmAFwnzdLTFbnmTLtl?=
 =?us-ascii?Q?4cFgcBk0tzNXEA0oDnELDUieEO7DVNnmVDd9rq0yaUSd2tWTcDD8aDpxWsEl?=
 =?us-ascii?Q?jonGb/OKQd8IQv7Lw0zhxiSngYaozv7BYbOJozn+VVJsEKKOaT6qyn19OEAQ?=
 =?us-ascii?Q?1xzVUuKrVH+PRxDdmVc/Tmuj/Jx3nF7ndLgstd7qqiOHGn44IS00PSXtOzbP?=
 =?us-ascii?Q?1yJlds8nX1CLaVme4xU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96966544-e911-4b4a-1da0-08dca4c85520
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 12:19:10.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7aVZ39/daT90JiXj4dy+dok0W7/mB9MREkrof/x114jk2D/rjp/ErmHD6cuyj7B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779

On Mon, Jul 15, 2024 at 08:16:40AM +0000, Tian, Kevin wrote:

> > Then the description is sort of like
> > 
> > Replace is useful for iommufd/VFIO to provide perfect HW emulation in
> > case the VM is expecting to be able to change a PASID on the fly. As
> > AMD will only support PASID in VM's using nested translation where we
> > don't use the set_dev_pasid API leave it disabled for now.
> > 
> 
> yes that's clearer.
> 
> btw I don't remember whether we have discussed the rationale behind
> the different driver semantics between RID and PASID. Currently RID
> replace is same as RID attach, with the driver simply blocking the old
> translation from the start and then no rollback upon failure when
> switching to the new domain (expecting the iommu core to recover),
> while for PASID replace we expect the driver to implement the hitless
> switch.
> 
> Is it because there is no need of perfect HW emulation for RID or just
> to be cleaned up later?

Yeah, too much legacy it would be hard to go in and do something about
this for RID across every driver.

PASID can be a bit more well defined from the start since we only have
three drivers and two of them support replace.

An ideal driver should be like ARM and support hitless replace
whenever possible in all paths so there is no confusion within the
driver.

Jason

