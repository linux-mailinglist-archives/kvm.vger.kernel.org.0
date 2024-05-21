Return-Path: <kvm+bounces-17842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 853DA8CB1AA
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 072621F2355B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068D514431F;
	Tue, 21 May 2024 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hydB7utl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFDD1FBB;
	Tue, 21 May 2024 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306585; cv=fail; b=YA7dN0ot2EV3A82t1lD836HrZU5e+4ygy4VPmpl3w2NfbhhNUxXvVUVDytPhRrCB1VUC7btzU7nnwDqNm4m+uQDId8VmmYTc6WibuROGQw0YZlHzgKaQFGSo7vK2+0wrHOuRVUyUPgDtQfLaJvdrgh2OgNOO4MozlR9rqQYS34g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306585; c=relaxed/simple;
	bh=EddNggBkzWvMtIX3VJX/oV4enCPs3K7rOmDfaZBSvLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jVhruyHNcBrNQa1lX/TcZ3WhoMSHO4zC6FBEhMw1j9OxRWCiSGq2jVojyP88JDuS4MoUl/HlBss72rynX9uUN3cnMgWZwdxqx8q3VXrEmB02HOap6Pmelv5iQx+MJdjupl8hwrKPme+1BJr/cNSaOepBJm8crJOf9PmOMo260Vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hydB7utl; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQAXmKPQu1petPrbS9YOltmzKbtEfSaE5F3dng8ZjCQO5Itz2ejPj3MN+BTStEYmrvvcn/i47ehZSn4fErXmOiC4OOYmk34i88caix+aEYQ5t/Lt+EbH4IXacvUbI29dNBHavHJ3+NKJWjs8UIy8Vr1BdvdfhxAu+SUtTMOdcwUpB4YTJ2zLa+Eg/gITLe9YPK+xnzV6LYbLUKNvx/bDOzaYlyu/E4P3GDmj8X0pBkgXTCRaRzSdrSfLdmlrbmcvyDqql0lOiawViX3uW0QRpP+66dvcI0XU+LrsHCbaFfJgdzwfetlC+zjmR7kkfWWqTWDOYvj0VAuac1cfZiUX/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDzz+oHhaNjHDdpFnUZkTho7vXmx9z8b3iiocy/5bmc=;
 b=T0z522/bUH2s4ttvRFo3x/RW4CA0MpqSagWBn52zPVzms5EHFdFwL68M0kQT3eEhDc8vMQ0YSTPQuEQcINTj8QJep5ko6Oo/CPcHtUMcQutJDKRq0DDiwbZOaUwNKOo5IxWhwId0qWZfe1Av7bcJ5DaJgT99YlWYDYl7k6uEOrs+Kj3Fqmnfq8+y7reO9VivsIowlpQL9zGXlrgC3MdrznQTX/TlWKj90bBCIDCwbbZRL9eKFnIa16cgjD/F3VDmeVf0+9nh4y9aVfQ3kNqebCP9QKSt4XKQSnhFUNudibPxGEe1WW1vBbr8+ztryE9spWnbKAgadKFIDPq8VXY+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDzz+oHhaNjHDdpFnUZkTho7vXmx9z8b3iiocy/5bmc=;
 b=hydB7utl1jEQNo9Qwx5XxzGymCgD3ijF+fN+GreeLoOdQcy8RxLplzgDL1xNwzKUZ6dxKCYwU+1AwLdhmkbv2DoxTZQ7W6U1oqRHDi8O6fUHETlkteEphdio99QwAfeeiHxHtRM5bG+cFHU70JC4uICGV++6rLIIsXiMMYo+l56QhcFYhaQ0ysnpXfgT7FbFl9gtbKXmrtussgACL546KvfGdvjfhP8QDJNip5bP8t6/aMSm3U0imgcfkKks1QvgLBMWo1y1C3YkzD3Ais8cIWpd0F7ZL69oh+L78S4/cxjqcUSDtK15HamFRXm/GEiif1AUHvk89Q/FdrDz+hFCcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8698.namprd12.prod.outlook.com (2603:10b6:806:38b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 15:49:40 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 15:49:40 +0000
Date: Tue, 21 May 2024 12:49:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <20240521154939.GH20229@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZktZDmcNnsHhp4Tm@infradead.org>
X-ClientProxiedBy: BL1P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8698:EE_
X-MS-Office365-Filtering-Correlation-Id: 41418c12-cec0-47b1-4389-08dc79ada019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D7Zj8uJwmtFhWsPQmDbcxDJpIKQqepklYHj8V6caKWxX4VkIfvEa5rXawc+Q?=
 =?us-ascii?Q?CFp1ndC2jVwkb0+Rp7/mZKjlf18sAuQSFhODlQ54wWKuEAyxHH8SDclnnuOb?=
 =?us-ascii?Q?/V4oAG/H/aEAqBkJy91pI2VDbc7U0GGxI/qFpqvV1YS30Hm+vK6XiMIni14B?=
 =?us-ascii?Q?0FhjM58oQu/QSb2ep41gX0McELvb7BrRX2/TdaIkV+vgxB931yN204o6i3OE?=
 =?us-ascii?Q?bd8TS/zoEX9TyGs6BRbPSSJo6rUOElHJEAHHkTvNDALx5aPyjRURjG52bChP?=
 =?us-ascii?Q?CjgI29/oVmNyXa7WY8gTDuGQ1jPYE2pGX/xE2IDrGtZujBitozpAN6owo6Vs?=
 =?us-ascii?Q?XUi7er6kYDMObu9VGSRPOD+PwYjqJ7zDLiTGT/QlAU2QhLS7HizXiZcPSpTN?=
 =?us-ascii?Q?0NW7Ok0RSDfgI6gYYg9Z2ke6hqRXpY7F8SZ9G607T7aCN+hOMiKyzeGqbwAy?=
 =?us-ascii?Q?weQqWzLD5W5VTl9Pu/MFeNIDwt0skF5lvJT/4HqmQ/gJuhatJd1geiUiU3eH?=
 =?us-ascii?Q?2xrkZdDiz+lEbf1UM6s7CyhcpbYfvlGulqnuvHG7UPuix5SQksQG+LTfaFI2?=
 =?us-ascii?Q?LM18rNWC+3lIuAmZv6o7kKV88GXRqWXp7Q1RUt60iWX0q+rCkBPDmbSQcx7E?=
 =?us-ascii?Q?DjlNtdTZtu6bcUmvuQQc6nQGqBmhMOWhZL8eXYAEL3dLMj4Qdf3OwFeGEQDV?=
 =?us-ascii?Q?v3fGXo/ckyEzMJZVhPQBjzNbY8xejmk9Sh5e40CcXPTDnjp+NXWEj1iTx0CZ?=
 =?us-ascii?Q?ibMaXaGxIO22kyUcnCcJjehiRLos3LarZfc02iPHgMG/iW7MbXqEnTBgp+3v?=
 =?us-ascii?Q?bpz9q63ZJTUH4WZk5FAd47f4SpbKoqZBl+uLkIg9m70pQZXH9l0jnoQZTBzL?=
 =?us-ascii?Q?hdGANrBz4l9G/NYQtvfYmQ5v46wHAVd5LmkVBgW9tGEPLm5SOUstgrOC8M+E?=
 =?us-ascii?Q?gbIq3X6PC0fWlF8cBdxiLxrPG8KzkZ+HG7zU5qnOQt58f4lmVR2umVV2Yefq?=
 =?us-ascii?Q?1/C++iX2yXSn91IyUhUlRqV4jMs2yzQXuuMKa3k4tEZVYhQ6oK/e5plNhzJ0?=
 =?us-ascii?Q?ZCk5IqeHTRKfPULusyL6yAVruYy2P/Q49kYY3tRVi9GudUGhJelK5ELERYV3?=
 =?us-ascii?Q?Heej0xmRZQW62zxB2DDCR5S6jsS8IIvaYmaoNYvwv2JgtFqN/i3H+9NU+GOs?=
 =?us-ascii?Q?toGj4ooUsySqJMb7Av/LSiWxnxCAJgAX8v3g4lfhVsx9UXLPGklfAOrf3NwD?=
 =?us-ascii?Q?9I24L/WvxkqXqnfG2qMXtDceaQ69CoamjH3FNABzZQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?remzpClW+5wyQmLs87vxxkViMgA+nV3y01obTS8nksET7K8XJG2Fd5MyWoXl?=
 =?us-ascii?Q?9dbtQJgiIGcAnaV4KW6OjKhOciM8lch8siOOUXZ+V9qUi+y2DRZ22oZTFRQ2?=
 =?us-ascii?Q?yhumezBfAFkcze6WICBlMc3D7ub7yig9jJnZxOkr/9UJWjZegQjsFKHTq8Dm?=
 =?us-ascii?Q?NFU0zYV3o1PEWjDFAQfTx1JXpCTmPGXMo7E8QV3Hs8toVSWi1Jw+/qBh9LSH?=
 =?us-ascii?Q?f9Y59VvwuqEVb93y30oq9+lyzFv9QglUJav7KO2gq9VCWP/7Xa7SK3PCdYNZ?=
 =?us-ascii?Q?1jqnXxr3EFEHOUW3SCLZ+e5SCTXQMFjFdtJh6MaI1Sj+h7TqDmX7WsZxgmOg?=
 =?us-ascii?Q?XqNr62K0jY7bJ28FKPaF+m5wx/fhJnYPq3gvHmK+jAqS8PZrXZQySxuoUVY9?=
 =?us-ascii?Q?boEIMO7D8Q8SbRDrfXBPmivzDZXrHC6idED06pKASzHCN/uO816Psa+94z0F?=
 =?us-ascii?Q?/nzL7F11awEEPhALSSsZGKX6pmMB/7m+f7GWOumhJm50IvDAhaxbW0zEQH9W?=
 =?us-ascii?Q?n6nV67TinmlOH5nmm6oxhFI2TChjs6xkhvLFrGEYfcJIcRT3SqYlA2elkBHw?=
 =?us-ascii?Q?vx4lFrXM23YVz0hVtg4VFSCXN+ka8iTIWLarndCoMe0OluJRBCXwlYxwrJZR?=
 =?us-ascii?Q?cZfRFapQD/gJtaKgVbFo3gZ9tmV6O3A+A/FrwXaTIOTjmNRq3LHMfHGYMaEQ?=
 =?us-ascii?Q?erc/DH94sqvleIvC+chpGkDSZpc3FEv81uZqRmRZTeI2oWeNVrHzb/drc0dl?=
 =?us-ascii?Q?9fqjXK5ispFY/NGvBjDVOPR27xVS1lewrFpEZ1wdmG7RjdPJcnPkiWvf3QFG?=
 =?us-ascii?Q?3Zum7EZJA13S9W6j/FcCG7z/InijDOONxxnYN1p8Eb2vvNrBT7DFu+msFrs1?=
 =?us-ascii?Q?KTzR8yUDQtYo1v4JzTdTAePKTSKhdZ8tvqX035+987UjopsgcDVRAcklsOn/?=
 =?us-ascii?Q?Jyckt9QfC0dVjSH2O0qy1rvj6Yq0E8kzG/kbubBfIXiXoUIl2llPKJ77azWZ?=
 =?us-ascii?Q?jpOCvGYtKkA2G2Nbjxs+JBtXnXR3amjL7o5XmslO7oGV/7GIsuDtPEn6bHj6?=
 =?us-ascii?Q?GxxctJPCe+aR5uS1ESMubEi2h3Uw0ax/H5io2EQpW8G9nLXk41Q7AGhqIeWG?=
 =?us-ascii?Q?Wl08ZGbUcmP0sTI7yKs9REn/I6dW1n9ZvkXosegmk4kX88VURhcNbM67XIiM?=
 =?us-ascii?Q?/bE//YAd9SSlp3XRTkTLbBH4XdgY6orZriJXYoX3LRD63ooVnMiw5HqIe6zk?=
 =?us-ascii?Q?80TYMlrVsvu58hJUe5TWIMUn/FxaAI7U/FNQ5rOsv/DM75BUzVgHJMqO06Cj?=
 =?us-ascii?Q?WLN/gQ8uEVbIAB0gaVVyrn3pmBlVbi2epjJ5hh3a2sd47Od3oZtuAzATBfQE?=
 =?us-ascii?Q?q9Z4/ixZ89FqGEfQHEw4WGfgz3I+94XSi4DrR1NtuNyc8wP97FnhZKsO9oul?=
 =?us-ascii?Q?iH9NQr79KWbUT1Sibhs5jfC0t5VoLsnMPuyZwNuHkOGzFzqITGO1mlDSJnT4?=
 =?us-ascii?Q?xg5P22rlYHiv6lPkb0HZwPG44hdEfLHAjAMs3gJsqf/fgi0frKyJ7K9OrdRl?=
 =?us-ascii?Q?QrubkfPGnhaehcx+YCX5T3bRA6oOQbJG4C4Sg9VN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41418c12-cec0-47b1-4389-08dc79ada019
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 15:49:40.3321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJNWQPjvRcIaldxRSuhGtgHPn7fAHfEpvIHcPmQY+KtAND1ta2yO4pBf7HYBqWHI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8698

On Mon, May 20, 2024 at 07:07:10AM -0700, Christoph Hellwig wrote:
> On Tue, May 07, 2024 at 02:20:44PM +0800, Yan Zhao wrote:
> > Introduce and export interface arch_clean_nonsnoop_dma() to flush CPU
> > caches for memory involved in non-coherent DMAs (DMAs that lack CPU cache
> > snooping).
> 
> Err, no.  There should really be no exported cache manipulation macros,
> as drivers are almost guaranteed to get this wrong.  I've added
> Russell to the Cc list who has been extremtly vocal about this at least
> for arm.

We could possibly move this under some IOMMU core API (ie flush and
map, unmap and flush), the iommu APIs are non-modular so this could
avoid the exported symbol.

Jason

