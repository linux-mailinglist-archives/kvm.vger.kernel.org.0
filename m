Return-Path: <kvm+bounces-30745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E63D9BD0DC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31ACB1C212A2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3786E824BD;
	Tue,  5 Nov 2024 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dSOL0Dq/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCA47D3F4
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821378; cv=fail; b=ro+XZWLX4mR2Qnj2sCX8eZ7vuqkafbbLMALcvZUCHhKqs7EqhIs4k3w7pBzg/Ok7n68z9dG1/OBqTMFI647/87J06FgzI7jSloQQNQcY2zbzv4bseIEDg6XZ2oT71nqrMk2FA3hGDbdtrt70v3cmrTDcBJh7Prdp/KafDtw0LWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821378; c=relaxed/simple;
	bh=q/nT7kmDsXzlRlqORD6RJj957AWgLtzgyK+AiNrQkPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o2tEQLjRMn97iZks758X70hGVDX2J+7cvPG1EIx5Gl4UcpZ4KBy5GBKd4l9scJYXsPIK7f6VcXzzkx8PP9cMNzyEPXeVSll5F6ql/cQFBEhzyAcqfI7n8mNeUO2q4reBuQF4OZsgaW/bjKicQaUAwZ5iAVhJUOij1YbGp4gQglw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dSOL0Dq/; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOj6rk3qKmbPWLRcvMKvTP9fDIq5gimsM428xBnzuS1K2jsWgQLz5OnFXKZtD3FkGw9r/lC6G0/ZEYM2t7j/pX8vkubQ46hNVtl4ot7Icc9N4gU4mdmeq9Zq+5FhCXa4i6DzHWz4wD+tyhyGoup420+HX7dHlHPylZh46OjYLSZp4Yc+AqqyVXXiI+5Q/Zf8uA4/7VMTpL1ZYJNgZzPU2O457LqywMB+LQN6clU0y1+aCgWANNPvgDY4vkNjk7eYlpsQpOjD7y0aIRPEokYLD1PZkXs9LpsG1BXWGsXFtdB2+WaTcaZnUgtCxb5tGIy/Bwj4FdCLw6ykqNdcfYOQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAj3ESjitfWFNg9OzSnTIk3X/0E9eNau1GE3tXZcEw8=;
 b=fShdMzsFl3l2ioapKZRP0Ahly10e4QiTqOcoVRlm/OcDsVBOyjirblMUWxRDErQTZa+6qa+t8Lm65gR+gcRq3Q4+qT4wJnl7G/DAsxacd4/TDMMicODGx6AMtC/2B8vDXpsz0ofqCiX+gW6Qt3Li9gnxupBc+7NVD8+T+IO58I7FojfrWgZhEfNNW+5aevID39IWeeK8B3fq6/GQXX9xQ84DpPNca+CU4SO4bdOGfSTtBcUxh/QfVdd7WtxovButCNQwTfKEul3Jugj1WtQTkvQlaAqVhrEiSu7iJFXAfB9Z31qX9O+b6f9EwjAKZ2mRQl68r0S+pxrUYfiiyj3EJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAj3ESjitfWFNg9OzSnTIk3X/0E9eNau1GE3tXZcEw8=;
 b=dSOL0Dq/giVUZFEgmuc4Rulg1rjc9KcDTdHHaajIb9CO5sUceEQpfFSdgBHkFDjaImKFKF5nNsplnfJqZ8Nt9Kd55Sijt7GWTEqATjHPGHqaQ0RlOKViBtLHCj/VncrOXFYiRGEziVL9sZ4SeGZfZWAQvlIdUvZ8mOUSqaUd+E4EMzTWSYIsb7FMLyRV03X96Xq6SCc3tni1pRpApc2pPwh3HABEMMdUjvclybFqrppaDRW53mMQ6rh5eJ6J0zjW6hDilulOQVlNaRDz8BBJ8/1cx+MDtNM1dQE6Z3w/pElMKlgKi1UgUnUATbFBbrqY/7p83wIgBzuQEw6KB2QAbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 15:42:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:42:51 +0000
Date: Tue, 5 Nov 2024 11:42:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
Message-ID: <20241105154250.GH458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-4-yi.l.liu@intel.com>
X-ClientProxiedBy: MN0PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:208:52d::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bdfff72-1f77-455b-23ad-08dcfdb081bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zosAy/N9ibmp43aVHTpsWeSL/E17Vr6HxcKt8DXhzNSeIWg6CizIOKTUbWgS?=
 =?us-ascii?Q?9NK+HSxzOpeUxG+rrSoRa/3jgWEsEw9vB8Gu4CmvvcbWo/+7hq5ejpZPHjq4?=
 =?us-ascii?Q?ia9HlMhDJ0XBs3nIi9leNtaB5h9d6RkxrrCcNe9Z/PLSyhSoawZNrobDORmw?=
 =?us-ascii?Q?WWyBbnDSAdv/cy5UBNIwakYdk9uW6UWEX+s/BzpVMdEDkIukI0a21VUKpS1t?=
 =?us-ascii?Q?JZfBu2KCLj76QAmWSDcD4RlcguSqIVjcq8dvGDwU/YHKoC+16VJ4hkBXVSOH?=
 =?us-ascii?Q?PcPNZi8IPny48rlhaksFqWs2j09SMco2/3oKdKNGUBx1yeMfD86/3rhR69et?=
 =?us-ascii?Q?ncrGOoOfCXHQyAjv/9Da/koO9yO6nJZ4DRshbW47bh2TWnCduObtYm7sgHQn?=
 =?us-ascii?Q?0bd6akchikUpKsG0F2Fft/eBQQ110riqMcAb6l2sELBx/IU0OAru6VUeJoNe?=
 =?us-ascii?Q?VbxKNqmL6HBsHf/LafQ0FMeruTuxcyPjGbD4u8w4XukbUgXejg5m0cf4oZKm?=
 =?us-ascii?Q?nmcz2m0JnH+JvpYyE+CbHDC4mtHo+xHIBVcphY+SPJLsM0TbhKcGdxgNOiqD?=
 =?us-ascii?Q?wsFQgnBygHP2GpKUN7MG+boJmh+Tv+H0uYHEu2t3b9C+JsDd41lwAXuOoOfb?=
 =?us-ascii?Q?a2hEywyT3Z4FUU+h8oFPQnY6jpGIodL+ShUIqsGT2vgKfEYspqPXd4nlYlBH?=
 =?us-ascii?Q?XyHD0ItCnYVWUw/3kLhGEOYS7KhfxJLWSKMDiBJswHSv+TmD1CLYjRzTziQd?=
 =?us-ascii?Q?18LLCV+ZyFJ4WV58I/mVBhFzDHgW7rT6XrYQEN1r044mGGRExYAjWJ2IVmg1?=
 =?us-ascii?Q?rN701FWXmCQHcbDwaL7n02hLkhuJfJyYih09jsp7XN5LstkS+j4aUi+f5oqs?=
 =?us-ascii?Q?7YS7hP9Q8sxNMiVjLO3XwSMIFHBuL7c+6mPddfI2u1d12vUPWW+Huf9V06/H?=
 =?us-ascii?Q?eID8YNxX3GnOOlUwXqW42I4fFnxeyz0OHRlwBn0gqKnFio0fnMZfxfC5rJrH?=
 =?us-ascii?Q?JGCt4TTP1O3/BWDm3TdhYA33Qwghmc9zZcgsmitqewwd4HCzaKMlo8rnRlf1?=
 =?us-ascii?Q?RAgWthX3PZDkzaKHnXavQHMDnDFylYj7spiqt0tfVKk0GRZ0I3qtP6xrfoyc?=
 =?us-ascii?Q?d714Oflu/Q6T5EvSY9zdumYfKUAwEw2Wz6sqkA8IYkKA3N3hUwgLqR6b1z30?=
 =?us-ascii?Q?Tl2hW2tC7RarQHl8sTSPCs/O6EwztxKCxD3DxGczKWMu1Cgv7jqcwYcrE0cU?=
 =?us-ascii?Q?v4yqqt684ye/TGPnnWW74fkb0CJWKsSuozVuZlDvJicEEtLpZ2zAT9kG+eiW?=
 =?us-ascii?Q?jKOToeeoKNHFfnIKGuVVt2lp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+mBnARatAMibjeHOgU4A19xAhJKz32rvEg7lYkc4guKfrwOwTRP2fSFNuLlI?=
 =?us-ascii?Q?Ihej8ZKazqWefPzfp84zZnM2xMZbpS/5W8f2X2pBbC7UY9sPGo6cc7hsCv6g?=
 =?us-ascii?Q?BiUcax3cfghJo51GfrPnIbaf4sQxG3h/WGQXclhPOx1UQzYbbrPxjby9afPM?=
 =?us-ascii?Q?VhoOrMJFhk6P6ta5BIEivldx7dmAYH+e0dzo/3nKaY/EqPvueZ2Gg6k9Ufd+?=
 =?us-ascii?Q?cmOxR9x3jB9cNXsPiIvNspFpyOKStw35omOizRkq7dqkmYv1yL7uZxLpgYaY?=
 =?us-ascii?Q?tvG4H5RjWOYzU860uwC4i/voBn4zApM/FWGynzKAAuEfrfsjrB8TYwFJT6KO?=
 =?us-ascii?Q?GhL3QxS8myA17gh82MO3pZGs/J2nvdaxGHC4/XJriN7Y6Y2wwo9ejLl3uKP2?=
 =?us-ascii?Q?cdiMV6POv60BFepG5gFpvaNkl9UejSbB7JM4d86W3Yk2i9+2N941aYk4BqFy?=
 =?us-ascii?Q?IVTU1Hb/9AEw4CkKvRK+myXNImMESHIVt5bwNGxMWW/PAMAPlwznh6GkcjRU?=
 =?us-ascii?Q?YxRxM4Kp/PuWp1edBW6w2SRhkiWNdT9JDSUV3kcQwx3Ca0pHJvIpnH18Jh23?=
 =?us-ascii?Q?7MJsx/60zHteLQkK99UqNIAhY00ct/sLq1IBslodn2XAIcWTMdfeJRztrIBQ?=
 =?us-ascii?Q?vAjHatm9WQzM1i4nCq1JkmZh85gltiekCqt2w2kF0SIAYqwYQ6R4DtkKIFJf?=
 =?us-ascii?Q?1pGWmJeohHyUlC0BFm5nqy9oiMrMuUDgpQshLrJhTf3fF0bduHipLKz8Tymy?=
 =?us-ascii?Q?XWrljSerdZIRJskksUQEw1eoJIZHgMArbRYSmZuG//UZoTx3Dkhrss+6ivO4?=
 =?us-ascii?Q?VaE64on/jQHLaN+N7Z5ixkzNHB03N95itHUvCesfaHVF6sAUjEbQK1VO1wd5?=
 =?us-ascii?Q?5BwccIUmUD9G6d6MmtQpraiwU09M/0riZDrOWr+olB6e853F/zlfE2pq9O/1?=
 =?us-ascii?Q?FonD+eJ/DsF6RzLTBZJCOI0f5w70omEQOcWOF8EfLOPrwwfE75XS18sQ8F+7?=
 =?us-ascii?Q?OMl7w0m3pcP98NlOuYXl8l7bhMxagAoVtwd1znQVERVc6zwxF1Zh7sw5KN+W?=
 =?us-ascii?Q?xImhzG4DuwONVmsD7eV9el4mbmnxObSiVrvuakHeIGxKCICbbGSS7SNcJiPp?=
 =?us-ascii?Q?7k3XLenVxFy+W+scO5efq5rLtYGwfBCNn/hlx03ydQ9LRzbZvfcKugJmeekl?=
 =?us-ascii?Q?5kyX3HZMCKanyoO70uSr+FdQTDQ0W6DdWBofDk16alFRz01ML8tGNhRFEvAu?=
 =?us-ascii?Q?d8dbqxKJaURjCUynRUTOFIsupsYlJeijgiQbtoMEiaL1VOkHWJSECe6qgut3?=
 =?us-ascii?Q?rNrCq7NMBMuem39OKGE9PUpmToWApkc3CpC0E0IB7avQbGSLolJTgISqybod?=
 =?us-ascii?Q?AD6G+daDV1Ivnk7x3FznmyfkRCBEeGzRdf8QXWdqxbjJBfK0b3Q20Dz88Otn?=
 =?us-ascii?Q?EIuah9oA3IeBe77WwZh50KthFaVmlTIRAr5vBeZcTXB5ZiANzBr7kZFWq3r0?=
 =?us-ascii?Q?itXfMLdGxL4eaVrd7oJENGjBL2RPisXhcEFK8i8gyGKqnYddmzLWNyn6OxZP?=
 =?us-ascii?Q?TV7p9Hp+MPob35bMqsI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdfff72-1f77-455b-23ad-08dcfdb081bd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:42:51.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEXrQ/tFLIbyDqA6jeGfQg4s791V5YfBa8HRSogAM5iQItBfIqv44tvvWKeyHQPK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

On Mon, Nov 04, 2024 at 05:20:29AM -0800, Yi Liu wrote:
> The iommu drivers are on the way to detach pasid by attaching to the blocked
> domain. However, this cannot be done in one shot. During the transition, iommu
> core would select between the remove_dev_pasid op and the blocked domain.
> 
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

