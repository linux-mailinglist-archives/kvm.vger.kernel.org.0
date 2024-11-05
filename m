Return-Path: <kvm+bounces-30746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDD29BD0E0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC798287FC7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AF9136327;
	Tue,  5 Nov 2024 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X4cGdg3E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87CD126C03
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821437; cv=fail; b=iXGK+dLQxvvh/z4IRJW7cUsoTThLp51Mc5Fl69+D2OZUFt26f2bbB5TpnEKBLgrXMUiGQf6tcflFxmAjQoiscOw/jMvM7Q+UFTl8dT6Tzh4IpIWFTzPJd3eWdh80AgIJ4p17ftvn1YrDFz0VP73UwtWc0BSDIovLMvZwrsi3rLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821437; c=relaxed/simple;
	bh=D2yybRkn/ngbdA9aj/hBUhFEEXEpEJL2SeNZZCTA6TI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UaJ68e4zsK399MreN2aLbEwFiqDSw2rRcPDOZRq3yWtxMQYbrbYoAe5XQjGS56FjchWRMs4+cbYdGNvnKMk3otHaYcuJfZMjaknBkaiDolezf5bsF+PFCvUReXlv1z15cICASInSNgNkeQav94lpD+IZQTpL5OSN72Y6kdzAVT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X4cGdg3E; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLGmKJYJumTCqdcGTP3v+HMUfLqLaGl4RPmgAVPmJc96hjm3Q1a+XYpICcvmQb3wBk00YX/5x7yUj+aibiOp44saAC62PJ+xpTDGiNRdPd6civMP0PCJ3PgaKDw4+5vkaeRkHkAj+jw9BO0qmOW4XlNJqTzTvuhHmkLzLpGNkeHyHTqPbrPBXWi7ONjNDX+N29Tai6jGEVfClB3GU7uYqCpn4W1FxmjK3KqbyLP+o+Z1/6/91W/+OVR7RFw+NhNaWhxjnG3JPRQ6QsYnnurlNKTMx5ilcPrf5hWHEU6LM7IHk40Ejxirm+ZRhzW+siP69eg0yk06sFXyg6cqVwHh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5McF2g6XfGZuXIOTMI/U5mQVecxq2hurvCJOSW+tze8=;
 b=wTUIAaeQ7Cb2fJUMmRBhfiJvy4QJ5Vj4zCjRi2HxYO0s6MAS5DtA9TJ9A8HQ+udkfmvbzuAWMb3UMMIn78L0bXW6wBsAj7GDEJaW2mbI98xB6nJogqNFcRxG4VieT1SLDMFFeyZjOpR43uQi0oJ4hs0GMhPUIrUmxDHfPxkIibkr3t2YhwpzrE47lX+K9XhaJjDTb+RvPRAYHixoj72MoiOYP+ZG+G1oTOGr6J1Ar3lBDmC8flOKAuwFhk+650pwq0BR1xUBYTvxt7ylWICIcBkEX1DQt06PMN4qpgPhroJOZn+jZDroob5EQYq9G0PWYoVzU3u0FQmKjFl1A67ENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5McF2g6XfGZuXIOTMI/U5mQVecxq2hurvCJOSW+tze8=;
 b=X4cGdg3EbHgL13819Ma38xKb80NJFjA04ILY5XiVx3f6IVkny8a3KrbYcOJ2U4rw7SowSb9t5F4jhY6H9uqUqpsUELL26jPcTd9ZrMhbp0pesuBrAiJDfntGZsxh9/pxv0SMJdzuOPtlC4Tu5SqkHfZFRyBn0qw7voFln3KwUSxonAUhVgyf0L4UzsAuh79wQAQ7mfBRJLc1M+WgabGKRgxEuvwetRRm7cYe/kfYHPql/SXZd8u6L5GA3EishiGLJHHKvY8R+JCIRLfUxhGn+ZuvteUhZ/FomR5vxoxpsaqrH+SnU0A7QZgKl2IBKtd5agG6oEL/8MZDD1SlKcrg3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 15:43:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:43:52 +0000
Date: Tue, 5 Nov 2024 11:43:51 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 5/7] iommu/vt-d: Make the blocked domain support PASID
Message-ID: <20241105154351.GI458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BN9PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:408:fc::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: f11450e4-e36a-47fb-7abf-08dcfdb0a647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vwl4UL3OiW6SP4WpZwaJIdqOkaqwCE95RIaIjPoxpN4md+8PWm54aNXWBgZ2?=
 =?us-ascii?Q?YEFDIjSrnfQdrr6lpomwOoy0gElKWDTbtF9A2Piv4928FP3gFPrwbuzdwV4Q?=
 =?us-ascii?Q?hXvbKymnrFAOqtmvHdQ6mueTwmr0DIMxCsqUo5OGO//4gQdt5aT4tK8/EfIQ?=
 =?us-ascii?Q?T9Ult48YPAlLbnKL0Xrih+9rtdxvVXrngydxuAOlU7YII8HJ8nzSWxwgyVpY?=
 =?us-ascii?Q?1aY28DctFzu2xV4L/0Z6O683SZQy7FEoideiLwEYDvoJXyoEQXQj1hp57n1H?=
 =?us-ascii?Q?sJwlKclzozByViC3+cH5a0nU6TKvkPj0H0NlUeIz1djN5eLHFqrDJv1dVKad?=
 =?us-ascii?Q?HDBKsGKcBHNFZ8Ak0EJNwO36nItmCS3DFxue4NheIFskMtxM0Lu5PcGhcRYe?=
 =?us-ascii?Q?G4vpKKuETH2elalWp4itsghOKxX8SG7/BU/JUPb6+m2TsBn8IJ5xK5rHqbwZ?=
 =?us-ascii?Q?MZma0PWRZugnOzPQzLDDLsYbuaHcLUyfcmTHWHegFfD2T8YhDSZm+X8UsdYQ?=
 =?us-ascii?Q?N7mHp6V7IikW7P2/kj4FE+MGhSJW0xjdlCozEMtGCNVmvZHH3kQ+OBl0ChD8?=
 =?us-ascii?Q?BlmwBc0NY/PxZqnsB8w9J7YB0e74Btr+hj9Ulb+Mde6Fe1EPbvMyAgkcknMw?=
 =?us-ascii?Q?WSpdNYhAhfu/grCxlGjoNyCJzY8CjC3OaU9JV2c3NFqMSFKGQeYxEt3ZR6A/?=
 =?us-ascii?Q?hzIx+rn51EM1XRYzBO98+y31XbL+HDTiVPWpuh/yptMEtMeZt+7YipdC/OcJ?=
 =?us-ascii?Q?VXBvnLeUioYLFPr742HhOkRv4DZFgrOn0gL307VWWtnh+uHPSI0261FAq5/Q?=
 =?us-ascii?Q?3N+KS1ycQqDUb4OS9313BJtCHXxod5/N2skWzwiP1RfKQ7hGc48e1hXfgp5I?=
 =?us-ascii?Q?zZ7KYnldiQA5zmK/Gr+gqEXtC8Nmizb2gr16XHnogiBBuNyNP5fOUbFKoDkn?=
 =?us-ascii?Q?ZruZs5x6yJ5YVelbOB73wLJ+NODm5TpWo8CT+FoDWvverEtf7oyIQiLcT7H+?=
 =?us-ascii?Q?gYwMuGnfBeC/SbB3t8AuoX+nUcnqwVmOP68uy/85pfAwIxXEaCabHFsR+aF/?=
 =?us-ascii?Q?gTCUTqbLQYLa/Vugq7GOaXwQW+cP49rklWM57whKc9YK5q3/XSgLFnEF68Un?=
 =?us-ascii?Q?K3bhZG7fU6jRdH7wNfWtzzGQbeOcm/ZZwNHuEYOrIgezlK0F1Z6qnFnuU190?=
 =?us-ascii?Q?FcKXR9McStPGGjgulTDVCuzX1cvq4JpmYHyFLORizfDSuVSwtmK/JMgkR66i?=
 =?us-ascii?Q?Yq04YchGyftRCVBnxZ8IXgTMASyKJpMdzP9R6r0b5d3+QR06gBBJg9n9gsiH?=
 =?us-ascii?Q?Tzk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RdC9kB/d3Y6/abH3nR0SW5Y88GCJiUHXSUmQhikX/D1k3qfRdlQbpciwsgpf?=
 =?us-ascii?Q?I2fMGOfyvSRSRqYaJIPBj3z8/pmEnCI7B1FiWfmRD/3h512TdVmv0mlNEsbh?=
 =?us-ascii?Q?qEoO8qb4IL6HRxv8QSmWmh/0Ll7iQdZxvnCaMfNxO5MFhr0p29IcxtknYdXL?=
 =?us-ascii?Q?Sm5Fr+1rsl/Oze3+OCOeyxlCHsQVKPbnYzIyRusD7+g2txMoLdAs3xx71cFV?=
 =?us-ascii?Q?eOITQduwFm7Jd+HJSNqgBgthuXvY7PiyF7iBD6hUskARHEetWFN1kj22qzp3?=
 =?us-ascii?Q?HQ6G6YzCrRS081xQRCxNlozFzkS90kGJUPSqHBISLriDmYO0M5VlpXx9BZBC?=
 =?us-ascii?Q?PRkld196L+CAgn4OID6yRzC2Yq5M7oyOx9IlsbDQXsjMX//ifahNyqKqkqan?=
 =?us-ascii?Q?tZSVdfBENiGDXif+3YoDr4Ru/ps3kc0rhP7SPaY87j6Xi6BXk0UG/RPKZcMP?=
 =?us-ascii?Q?RRMJ8RVNpfudzL9AqzmhLYQ64gHb4Q8qFw3r1aQxI95a3pDY2G+V/zeMy0+u?=
 =?us-ascii?Q?qTnn34Obmsd8iAD1EZNAW5HEPJvBGEbpeo7yGMs4aLAKNPlFnqmK95JlcTBX?=
 =?us-ascii?Q?DXtRbcQmD5KTRAcDjNFfEwRvCPbqmxRUChWa+a5aemNf2YVudZ9vhbAROYjP?=
 =?us-ascii?Q?yJ1I6V+438xo2bOJUQBBre5tZiZxiC+7BkGhg3yOQBZ2aVXfUPKcLOOScNXU?=
 =?us-ascii?Q?eiZ3fQ91fkkVWhmqS6vr2dkrLt9kGw9xb2LFDyoOcjdI7K9tBD//kM7gIePN?=
 =?us-ascii?Q?rWt5iwpBfFPAoJseuWnNUEXzR4yiP/tYqHE4GeYoNsoXziMB2M6N/+AbynMu?=
 =?us-ascii?Q?2cjpxL8tEzW0k/HN4ebgXTr8RV1nKeCkkDutB1n15j7cmbJixH1pCwL1cvl+?=
 =?us-ascii?Q?topNsaNlveEGb86spTUDNSSpjRhk7+A892aAwbxI0vAppZDq+mAK0eVLM1Nu?=
 =?us-ascii?Q?Gv1UBYBxlo3jHaTfWVtab38DLG0Ih6fwD5fdxutsHsXljc8C5a0/u4mz8ayZ?=
 =?us-ascii?Q?Too8a6x+rksKubHaRhJu2tIiYHxoOXuRQDEdxK65J/HUwvSaQN5OeK1BWusd?=
 =?us-ascii?Q?62y6h0vceeE9MBxf5df0R3OX+UvhUT3Xa68awZKp8NHwaOm7DaLEiMVwBlCN?=
 =?us-ascii?Q?12+i+oajRUbYbrihl9uT628qSOnsmE85chVqMSXvrtsD62jUBkXRr1dZe0Ec?=
 =?us-ascii?Q?cs7tQdHOgWXM/pkGAsVW+NlOPidanvdfXBJkTDpjHpQYpSt3yjGE3MDTlB0a?=
 =?us-ascii?Q?CV82805dj2QPLAPhpD1ygAYy2TGW47FkSb5BRohm5s6erPlcKu4Eb9jK9Al8?=
 =?us-ascii?Q?DbBTo5jMUHZpsU/f8h1UrFsEC9qIv0MnhOhbwfEhdPs2Vvi4zPpfs/RDda9/?=
 =?us-ascii?Q?bHcBjvIak9IDuntFDMLMS8ZZfhOeRtt+mbIxvS3CdziZYqLHSGBlA0tuVvXl?=
 =?us-ascii?Q?q+kuw9w9ol5SfSNHBxvLxHhtknSUK+8TYpjtJ0STvQEp88sYvvA6WqcCT//4?=
 =?us-ascii?Q?ybhI/n+cvZLDQBhbCXgrYm4OAxCITcXHfGRcF82y6inRxuUUS0AK8D609RRB?=
 =?us-ascii?Q?Be50hkNRl1YH1cg3faKNNbLy5zgEEWr7laP8M7SY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11450e4-e36a-47fb-7abf-08dcfdb0a647
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:43:52.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PkQh6I377nLPRsqIbOngNrTMtF2tdE3ZjHA0gRRj5T+9z/Uzg94L6UKVeQ8//nd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

On Mon, Nov 04, 2024 at 05:20:31AM -0800, Yi Liu wrote:
> The blocked domain can be extended to park PASID of a device to be the
> DMA blocking state. By this the remove_dev_pasid() op is dropped.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

