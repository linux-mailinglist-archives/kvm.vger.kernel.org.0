Return-Path: <kvm+bounces-66660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C872CDB206
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 03:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9142A300D665
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B04329D26D;
	Wed, 24 Dec 2025 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V0/VIXIU"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE277273F9
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766541867; cv=fail; b=aWrr9feTPyA7/uiDVlCtrCzgre28Z8LtWp+HxMwYJw6ghoKjcrVoQnzhFA7FC4Aoud2MlWhMsRaS/ZcH3N9RBC8vqsSubJanWwJIOd9UqEsjpAfna0MTZaxhF2SH83sHMLmGuRnIqCw5BDGOs2pqLYvB1d3BT4nMIKbA+VOl52o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766541867; c=relaxed/simple;
	bh=3zweAPQsBVHZUp50+PNinpfXd06RtYHKDA7mg1PyjJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uj/yJMd65zkkS0SoL7XWoa2QPyIVh7RQFo/eK0xdyR6uq29QUcuSBwOk//Jv+UIBV1cJqgV2E/4saxIdMYyrJH1VDluw5p36tbbiyEok5i2yhddRWiLUCBxwdWxSEpFf0yzZQL0VYF5FUaWxRxUVXw3+A117d5zruYMYsgcmev0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V0/VIXIU; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lplgIQAawZvpDChInlAa9A9KOgK1ZWD2/4FAU44xH3abytdl5X/mTFa97hp4gyhfQbfcCEfI/afeCGm5GQ8067SkKdXoKX4UhpCuQzEpT5kZZE7PipdXPAu0wrpNKWwaUMC7EOql5WjJkDw2HOPWHmev+oqsLUfoNh/vKRjqQP3eU8K2FTV4fqgsFoWNzk7gLCG2knGSVGtGgNFeaXChTnY13Ocbyzwv79zQns0NT3WYaIRtjtWAbpkUMjqxT/NISklwBiG10SCw2lyZ4cgnISs2MQ5WeszVbeoeksnn6nMeKPxWIYvqzLJRebeqFGUTSytwN+yQFOIGXcL6z2hgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUjOoObXcQvez26r6JBeRCAxe3sKDJSA/XinhlfBItk=;
 b=NJF3gCyCloORt6Hmvb7cw94YX1NHFNUxaXNWowLLQwFTCuFPh2YO1jLYnbyRYhyI8BBUtjcfnm/F6MQv/UbRal4Jz7XBENygQUfx6MSOJ/Ddr/voShgto0L/4v7XJBlvD4pYhMcwQEMxIk6me+cMMdCaeS15jFgpS5VULoiQ8vR514NG/haSWw/bZjvYE41SDC2G2282gM8ia0/3N9FrFIhgt2ks9Q/I9gtzmMbgU6xFNiv8U8rQx2pdpNaW/mBoYYVsyDqJ4yRQO5M85ibPwDbFFTbTaTKZASwy6ne5e1176Y/kPJqgI+KTOtVmnhEShA29wcw9mDRf+Rda6e9S8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUjOoObXcQvez26r6JBeRCAxe3sKDJSA/XinhlfBItk=;
 b=V0/VIXIU41TODak9SrBTJ5rBEQ/wo1u07MaxmoP9mnGfnXyWXee7AqaoUfBCFXY4+Im6nIMwcPMCxWyht9/+GITE+g50OrPv97qIyYQ4nCncgyfGahppp2LhSfQ2Gi1NUKXEtODFe88l4TNKSJK4bEQJaRyO+aS5r0M8o/bjIMKePW46GLoqPdOpGTHK7HNlHbxby1f/jUO23PGVw9WOAJPpLu695lH0uC6gSYxEqRneKyKZ7kQlBbaEor9efIR7esu0IVyeEnF6QTrNFc3ZWX7Dex1JGUfq/iZQv65KKqXFNg6R1lhgF6oDZ3QuSNebvIWLdFrDU5niAqicjH54zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5656.namprd12.prod.outlook.com (2603:10b6:510:13b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 02:04:23 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 02:04:23 +0000
Date: Tue, 23 Dec 2025 22:04:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	seanjc@google.com
Subject: Re: [RFC PATCH 0/2] vfio: Improve DMA mapping performance for huge
 pages
Message-ID: <aUtKJbvsQNANXjO/@nvidia.com>
References: <20251223230044.2617028-1-aaronlewis@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223230044.2617028-1-aaronlewis@google.com>
X-ClientProxiedBy: MW3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:303:2b::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: f195d303-d575-4237-122e-08de4290c1cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8bJD9ea06U/GHycmRD8zd0Myc89ne5sgYm+r8+DXezn6hTqWlt+DdkacnyT?=
 =?us-ascii?Q?heLS+S505faLqzNd78AxJD3jliTsvCLJgT33rUv959OIGayBO0ESPksZ8Nse?=
 =?us-ascii?Q?qfKzdD0aD/AW2ueAAu4twek27KAow1vGmhiN5UnZRFDy7wBCKYmKEokQdxjM?=
 =?us-ascii?Q?i++WbOAR9HLoiNjfm6vvHUzioIII54pKGcenIBoSzHZif4PDTbZs3kzhtvxb?=
 =?us-ascii?Q?jxEZaz2BpWICHzxvjx6sv4db64WNVvtUDlxRNYra7x/kO3zPXvN0Ht5mUoVV?=
 =?us-ascii?Q?JRgWNZHNizfRtvQ3hyBkTLdwWrOPv9IXceDSD7ho0DIF3ky4x4iMHhH+xZkY?=
 =?us-ascii?Q?7f3A/j9aq+ReqHkDwQtQ5KpFHhs3vINOnbskxd4zvPhNtyJxzSubnTfCnSOm?=
 =?us-ascii?Q?nMaaTUcKu0AVjeyokCh2RkPXQAmS0UBxU0Sgmuy301gFNdX6ALP2iwj+n+xv?=
 =?us-ascii?Q?puawKzh72k448lD6GOf2IZsCeeEvfSns4ejwIgCRihQF6jT+KH6biXL+CDFN?=
 =?us-ascii?Q?zxAxqWln8iZZsLM52PaSGV9dSsVaWrA0nTupEJlG0PY77HvgsN9qCX1Uxgyo?=
 =?us-ascii?Q?hrCdUZQrnhQlj0M3/9VJitSawCQPVQ5gD1p1OrNmKOKv9CmlYdCqOTMT7jMp?=
 =?us-ascii?Q?Ah40M8k/1qpSYQB+4P13AQJTHEo11zSVuq0YxHSpnYBsepfgyoLuOJclJWv+?=
 =?us-ascii?Q?CuAcyqW8VPD7ClnXiUPBWOxrx4qX1m2aWGn5+vxu1ZX4Z0Wp8ixw5UR+0RC+?=
 =?us-ascii?Q?GM4ucQeEFl0Qmyw0Za0qXCPQAWQ6/JBHI/cCIIKgrKFCw4TlGVdi2eAOauEc?=
 =?us-ascii?Q?R65ILMOYYnPGP4z9r7eJ53xiJ2f22WLaFlgEXjwAdk3omIQnuPwKoPK0uLtf?=
 =?us-ascii?Q?T0pLtSVbRXlW9+PRVuTGb6nfh4ypenXvm9NyNCZn6hUYDMSgteLMGHlS1q+A?=
 =?us-ascii?Q?YEigFd5NZ9V0i5+YoSmTtEIgLyL9kIbx8UD8JV/0HJXTLbVeTvtKvq5P81Yu?=
 =?us-ascii?Q?dTxNAP7WL/EfqlCHkfgohPZOA6QyWuMj5OpVPoNQZb64tNs7bg/nrcd2EjTb?=
 =?us-ascii?Q?3akpmKYP17AvYA1fGStOnIspHKdT9JW4BTjWOcMycqNgnuuUs0xZiOJrALYp?=
 =?us-ascii?Q?axkFdBccpm6a36PmYGx8UBrRC2mXAiaFiCw38g2DrrXss+c/7n+R4gdBcted?=
 =?us-ascii?Q?X2Q86RPg0Z+TjqZsPjpahx5JGCd67PHpff/Em8ysYiegmNSYe3pSSyxcLfdH?=
 =?us-ascii?Q?0/M84oqyv7VpJ0qBHO2TlJ12O1Y7k5i9OEyftqM3KxxlsLhMvvlW2EeYySVC?=
 =?us-ascii?Q?YTfWPkkGLphBNSr4vxI3E4mEv0XjJmqpYCSLckB4Wpx48Zp/2wWGet/oY0i4?=
 =?us-ascii?Q?PBqqV+CdSUG79W7CJ8aShDfb8Nowmwk9wcn9rD9AVoYcjQLlIKDLHUHtGUkW?=
 =?us-ascii?Q?2P6SfhaSMFgILJfyiQkxCQv6yov6vWtT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WBi49qF3iS7idFdYaarLOlAlcs7uIjvMGx429RpjtVX7bwKrLOk7ouIWdnmr?=
 =?us-ascii?Q?fH2Cy/dgP0uK0JrJbrP5JpKcBrrkOwsJXONaGSnUCyDUE3pOKUVcGkoblQS5?=
 =?us-ascii?Q?bjlI6Ai6uZhXzUEQcFNK0Gmhma4GNeERINCeLruw0uzQ2lwPfC9bZ680+54+?=
 =?us-ascii?Q?hdnMHiJ6Jn5YA0E6OvaBhwVmfwJl78zFbJzibZ7lKV2iYjOyOaTJLHR5Qy9h?=
 =?us-ascii?Q?gyMZwcgKwdYgwiaG1//1EJOqc2GBiDpZFKq9HLpPnRSIdUB3TZCOhDxJ58g2?=
 =?us-ascii?Q?+rvXW9Ky483AAyFEv2QRGUbCrtOXz01hBrj8hklyO9sY2U58FRGoK86IjGbB?=
 =?us-ascii?Q?boYkuVOuDzhSmqqSP+Os4pIuM+eyffHDILudv3IIG0TwstfrMXL5RQxBhymZ?=
 =?us-ascii?Q?B4yZ0X+4U4FXmjfIiV5+HQjftMHnqS30oGpbDhzajt1D6bTZkqMRuIHdjziZ?=
 =?us-ascii?Q?5KXfxDkUoT/kooj7RRsgUYzgXak7o18yLm827W9CbcGAm544y/eXmg+dZ1KQ?=
 =?us-ascii?Q?1jAY86XDTYxkXkz17Qo7xdWHklJ+46bGfJ6BlPbYg/5BvyynoUJ34YaOgWk/?=
 =?us-ascii?Q?Mb4X6Uhy3rO7otBskjwjySyu6J9WSj9NB0LfNRUYPna4x16WBs1wZdgGrc7H?=
 =?us-ascii?Q?nAGSaBA7BD7Bf4scTmgoryN3IXn1+2rMpDLuNm0vYKEBJPru1M7kBRctdgR6?=
 =?us-ascii?Q?sfwhtd0lLWOYcqFpI7iSOQwUazmTIQKQCIKhUBpFQMxZOT5A30GWiBD0RPF+?=
 =?us-ascii?Q?+mW/swRE1VJw9cvgTV5BrXHqRj3rf5qodvYH2OLHRE5owcaDMuvUr7lRiPVk?=
 =?us-ascii?Q?MlXBsEWEM/hlNLrT+5SPI5n4F6MCqETlMGVHEVGTwwGoQhpiOhEzy0EeCpWO?=
 =?us-ascii?Q?w/uWo8VlOfzc27/23xhFSEtIVZaPNmjRMKaZU0KCfr3BcnCtf2fbhfNbY28O?=
 =?us-ascii?Q?rVuQa3NtZghYu2g1Gz8lR2vKcBbrFZxSTLRwP82lyiE3GRnwVTBPKTqoURUg?=
 =?us-ascii?Q?gjUwIc3xTL+4CWK4B0llfNxsh4aaBJ06IXJMBpuqnU8B0RRT/GuoIT/tNpIx?=
 =?us-ascii?Q?1V9l7GxzYAkiWW48+cqVIU0y/XoQLH0b2RHB1Uai1wZvDjm5x6mBg4wkSRBu?=
 =?us-ascii?Q?KPXHJuc0fh8OHiOF3rDdvkPyO24k7IrUU+QE92U7f7n9rcjFVrLh/RbA/D2k?=
 =?us-ascii?Q?ytdDB4k68IzyUW+1EZgSayBE1VcvMgWriTCXRsBQorlXD4nkvmBVacblykSB?=
 =?us-ascii?Q?6AJ80oe0yDTRdtmpjGo6cO0q38xEZjPAWzPwJfFXVPhZfVmhbVWryOFNFAiY?=
 =?us-ascii?Q?FVCSPH31trvxyfrhZ4fxerRtp8SatamuT6roTiMPjmD2GC7Eou/qOWYS3Zx1?=
 =?us-ascii?Q?MZpAqvzgxwXtxHovQD/5T3570vxnpMgyOONY0LYsqdU0Usapx1UaXRYrhsaq?=
 =?us-ascii?Q?1SfkayeVpjiLZt9QFTsNhNEW3SBAHIe+a8mXYhUWZm4GC6c5Fq1Pcdnl1Rxr?=
 =?us-ascii?Q?2RlL3qo8QegM/FceP5C0kebjgblUXLycufh9m4W/DgIk80mDHmLV0/4MRGnp?=
 =?us-ascii?Q?QGIy/CUX+YMhOiREUiREJjRPfIH71+brqzNTF9tFHVyWYgrTh5Bk2zoB19HH?=
 =?us-ascii?Q?t3ciN+OeNgGulkJesufbYYMlCknmBVT/XAYzjGtwwhh361nyyAp5uu4hoKBO?=
 =?us-ascii?Q?Cd1oEuiAWs0U4sDVpzLAfl0ELuer4ygYEwQgbxoRiGpG0uRQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f195d303-d575-4237-122e-08de4290c1cc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 02:04:22.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ciTWD6GAVmbrvAXf5Ce+JQ5sWfzJy8eAB2q3HRiZMgp63/eYCuWmYV07dxx6xJAQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5656

On Tue, Dec 23, 2025 at 11:00:42PM +0000, Aaron Lewis wrote:
> This RFC explores the current state of DMA mapping performance across
> vfio, and proposes an implementation to improve the performance
> for "vfio_type1_iommu" for huge pages.

We are trying to sunset type1, please just use the memfd path on
iommufd which is supposed to be the fastest available option. You can
try to improve iommufd as well.

But we definately should not be making type 1 the best option and then
encouraging people to use it - that is the opposite of what we are
trying to do!

> This is being sent as an RFC because while there is a proposed solution
> for "vfio_type1_iommu", there are no solutions for the other two iommu
> modes.  Attached is a callstack in patch 1/2 showing where the latency
> issues are for iommufd, however, I haven't posted one
> for "iommufd_compat_type1". I'm also not clear on what the intention is
> for "iommufd_compat_type1" w.r.t. this issue.  Especially given it is so
> much slower than the others.

Probably your test is using VFIO_TYPE1_IOMMU for iommufd and comparing
it to VFIO_TYPE1v2_IOMMU for vfio. v0 forces 4k pages at the iommu
domain which is much slower.

It is also really weird because I have seen other people reporting a
30x speedup using iommufd and here you are reporting it is the slowest
option?

Jason

