Return-Path: <kvm+bounces-31872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A73059C90EF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8842CB613B0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4210C185B48;
	Thu, 14 Nov 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DGCONTAS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB313BADF
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601581; cv=fail; b=MwwaUnt+4VYk7cBcGwje2HLo4j8UMkDbZi+lTEeEHlJZonrUI5wQmeCp32RBTSJHLi86OSjWJKG2LxGEtpTA75WmiblCoJ/pVX6aAwav3nAmrwG0Dgq5N+6B2j9EjR2botRK/gjQTczcjh0tCVobg9KC+eQoFN9W++LPBF4PkAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601581; c=relaxed/simple;
	bh=SWHxOLuhCXXLjHbTwOU9OVprst0LeeN6x2OoCiJDDXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ClPlXDCV1TLgdIs8p9LZNBxfCPLHBb9+GuuRHR6mN0hlWwy/XmIMGyOHh/i5yTUyFOhz++x39FvQurAe0e4DN+VHb2C2QXYG4061sTIJRb6WM6hXw/EyBSbUuiyG/eu8OR8yuvDqgx0CKwS4zq0gG6VbbmZKlW6Ry3cdJsVXql0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DGCONTAS; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2dxiGHRNSHueWnkx9auaLO1j9AGvDxD6GyOIzyJ+MYRT/cC1lYsB+8oPq6ZZZ20g/EP3e2QUNdwzl63aWm82/d+FivJSZ2BPoyJn8JdufLOv++Cqwah+KqEwW39igQKrtcfltKZIaprI1GW/BJ0SUoSqeClO+0N7qH8DBPaoIIS7QDqX8Em4V2LSK7NeMvUAatD2x0DAyTdZ5MfF7ocRP9UGFLiCEhrokAXkm2Kocht0ky3RI6m8AkQnlpf/BWdtElBsGQK0YgGgHueu/jtmyYN9qV9OjtkGQVngDlrWkWyrZyFmqB8EleeX7eGZYl/sfYxtj46WkCxuqGV+c/xxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yThPyEF8rL0InbQl2ZRJvEqdYEaE7nDj9LN/7Dn3utw=;
 b=uUz+nhKIsIYbCjP9+Dximx1CUvoGNnOwjpQD+5+zfpOBXbv0N2c3Vvo17ZwA0bn1oS8I21bkXSq0NRKTxP/46IiZ4iOh3vmidoUt1AyGAqZ2SFph0Tj0MlNIWmNtDVYnPJsxecGlq8UU0dDXGKpqRTg/GiIBniSeEvoFG1DyIl3eSUrnqPNElYr379uo8sdDx3JGtCIWAAzpKp+RHtOZiHeNxHQuy6prJaTZTfBUwRruWs5LqlVfw+li/E6kwEvLkwHsw78HsGpSnRBQvrWl8Lrn04AewDFX/EsFHaCtyjF1C0I57lw7KcCsvfWnsdWoIuLvlUK+tzkTfny1gcd7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yThPyEF8rL0InbQl2ZRJvEqdYEaE7nDj9LN/7Dn3utw=;
 b=DGCONTASWnyjD3idKjM7DLeQ4qQr77jAG6/MtBN7fYvYZk5AJzmEugFa11UA0ZR92PCLwmo8vXd4Y2eb/HAL2ugM48+eRmKUcMpH5dd03yMpc5zQkRxaBmOb1G9SQPTCsFObhdAjelunwuf4LKd4/C3pNhGUfpk6HaYylN5FbrceZ0c/BrgLZocbLTHh9vkf14Nqta71YLk+tphlbxUOF6YHKLmdujDuTS9NxF1/uufTD/5fldWXiofV1X8YirUiF3DGh9qjOe5JzhpAxp5L1EfMEqZhWPFLtA12GsDHD26ne5kkTHTqUbyTgymqlmHbUpDFxa0GrDa4AOtGFtd8FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV3PR12MB9410.namprd12.prod.outlook.com (2603:10b6:408:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Thu, 14 Nov
 2024 16:26:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 16:26:14 +0000
Date: Thu, 14 Nov 2024 12:26:13 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org, kevin.tian@intel.com,
	joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 1/2] vfio/mlx5: Fix an unwind issue in
 mlx5vf_add_migration_pages()
Message-ID: <20241114162613.GQ35230@nvidia.com>
References: <20241114095318.16556-1-yishaih@nvidia.com>
 <20241114095318.16556-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114095318.16556-2-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:208:236::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV3PR12MB9410:EE_
X-MS-Office365-Filtering-Correlation-Id: 4864697f-21bc-4e1d-d3a5-08dd04c90f40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gMsE+golEcwGZ4lU3+MRwjdyrC5BxY4oom9hEQ7KAnbJeg2azLon7pxi90rR?=
 =?us-ascii?Q?TUDBXL5URe3Uh8nJKhoijDfVec2C/sfTP6tHSQGW9S3o8oSeghNq/shUdQPe?=
 =?us-ascii?Q?PBvsnW/HUWV0BQ+64ouvCJg9FH1R73d3TThmn0xukawv/stQ8/n8WY/lrFLs?=
 =?us-ascii?Q?rbFND5en2NZTdRVgJGMiRU3T4y1T1xTaMiIHEkl5g23gjsc4YRzdvU1TX7Xx?=
 =?us-ascii?Q?wcKkGSNxIT7J/uQpwRjIBqwFJs7axmf5g4YdEhgO86BMwjBG/36zDf+vjyTU?=
 =?us-ascii?Q?+N4v4jsor0DVRxLbByt6jVcvO+oMmdWH2FCIB4EzCETTEe+ALwFxJwFcY7is?=
 =?us-ascii?Q?oN8D6r/G7DpJMA8I7s5boZpgi/hl7U7LQJa6aD684RFS7Us/vsQFJkT6kDs8?=
 =?us-ascii?Q?/UoM5XDR8lTXOLnRPrFurmrkNrHIrMf+ne8W3fa27qi94+xFR1knYGXwQB56?=
 =?us-ascii?Q?5LU/2iSCL35Ltzvmvv1rn6hSgTsHDSKLaRPAJP9dXI+xLrk4xKIj6vixyJRN?=
 =?us-ascii?Q?COmqxAMip8knXnCYY4Fc9Q8KzbFu/mPg1xq8K2CCVVESd3TlCHjhLVmfTyFM?=
 =?us-ascii?Q?NYMXdWpZj9rMgN31Nqlzuub3In+S6or4/5BSgtO3H98jXXjcmmE7U05uVCkz?=
 =?us-ascii?Q?zgtkdaBPd2E9VxTWRb8uHHhPpfNLD/7h+OmoZJ6EDT97tCe9HvPwJh8Us84j?=
 =?us-ascii?Q?9hH79GbOccCFLzENc7ZS3nYRLhLV/qCGWhCKRG13p9EjLIM+GlQX9Hv4kEPf?=
 =?us-ascii?Q?P7ydjERWmHBERiwQN8kD55Q0XHrtD8oL5NKXok3AJ65Tk4c5nXQwdWBLv0l3?=
 =?us-ascii?Q?1WehRFY+SeUVPSNJIH+gYLg1Pl9edxlK7EA9zd4P+rWusj4RnosHsrvQNwdl?=
 =?us-ascii?Q?XMmoERlkLMxzsYBs/sniC/HDrPQi/25X0wRG7lRDsi38rP4HuMh2UAZFEY8K?=
 =?us-ascii?Q?tUrQ+IkipzSiLzhbGhXf3I6cm+nKDqZP9v/sqYjALn0+ZSTmXuSzhn1vku+f?=
 =?us-ascii?Q?cjSstSO2NJcjL7go45fKK1GEfwvvEGRQ7wdVwKDjEz/t77ewlb5kFzqCY0bZ?=
 =?us-ascii?Q?0Jxl3Am3ABH0/iUmd6CwwN5SJavCTk1ti25qRrJxppIVPm1StJLAMQHXtDPL?=
 =?us-ascii?Q?2jmukWyMiTUWU1mgcGuPFI9OFyvFkCKjHb5VCLU1TmIyKvoOXyd8F9IoucoY?=
 =?us-ascii?Q?u/0IkzOqT/QdxPbUmlYEVdo36DX9vhefKlG9RMGQGWBUQ/MxOSD9JybZhKk1?=
 =?us-ascii?Q?PI/Yhm9kP+Fh3vfYtQ9bKJ2lwTOgUw+4orguGUxt/G++0jRc19Arcah070W4?=
 =?us-ascii?Q?WiYL3jQopd+Ps7oUy4PJBkrY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DRHqGgNJXlVfV5MuOvCYII2S/pGm0nPtjUnh51DY9vIIXTusuVm1I8/Qjxou?=
 =?us-ascii?Q?WIiVO+hH/JcvE+Ivc5iTfoz5K3HMm1kw9GySxXhK1hKWBqE1GXy5FGD8r7wP?=
 =?us-ascii?Q?+SMZ2yK4m61cseNz91QocmM+/1XgMAoCZ2mmxENApX0KHnZX6ArZO5NlBBqS?=
 =?us-ascii?Q?vtvFmrnE9W1G/rmIOn3vYEDOHLeiXviMA/o8FFY40rFdRiGhrZaUvp24lzLm?=
 =?us-ascii?Q?OI1Peyys8hBMkwshqcT8KDK6mhmQzZl/0HyZqUhM8c6E7NcykKJm6H/OWZ/N?=
 =?us-ascii?Q?3B0XcOCyob1iV6X3YO0UTgzlQ/fc+riVjjeuYRu09bO23FY0ABiNa3BpXwzm?=
 =?us-ascii?Q?GMHxvADHTvXbYltwq/nY7gW07MYn41ZbyFmIuL4Og4IWWXtiuP6W8WzeZtzy?=
 =?us-ascii?Q?aVqdgzo0GMzCSNHI+9MLLsL/UnOfk105rBsHgHJ1K0yy2aTOO6t7yE8m8Wdd?=
 =?us-ascii?Q?sPJP+ILgxcQlpGdW8nZPcYbMdYMOMguWUwztcmWOIqVTtomQgs2Dmck4p7w/?=
 =?us-ascii?Q?SHzUjMFNEdk394rOGasXkeUUKy2hoMbI81h7rkDh/NO8opRki6mfhJfHstUV?=
 =?us-ascii?Q?LrOwWVw0+u1PkBPqDZO6uhCxNZJIwoytLg7jQTm1+TLIhePJ3y4OvGRqAoE4?=
 =?us-ascii?Q?kvJgQ9wH8Q85nSTEvb5pwwprB240UcTqN1b+WGA8m56SAjetbCEjN57SDgKm?=
 =?us-ascii?Q?IZD7YMs++txt9RuLTsF1mUJg6CeEFOw0OrX7M29+MBouts9M+L0nmisp0lo2?=
 =?us-ascii?Q?Bj/bRmuQzgJvctMGWWJMiTBCkK4xJ0bTrTqwHZcVpkVeQnx/sdRLb+pH3Oza?=
 =?us-ascii?Q?L/n2E6g5rf6fIzm+0OA5RsLiHYLhS6fwnofr2E5Sx3zPjRkYK4J7QcnTFK4/?=
 =?us-ascii?Q?CYrz3CPAI/ZcNYYi/FnVU/74/vfbmeYgTBdGaNC6uc46Clqs6rAGKvgTbNKd?=
 =?us-ascii?Q?UIGOvLj83s/yob6ylwwMTt1/Udw84jWDbGGFFT1Hs09rVtIygGghJvlWY/PH?=
 =?us-ascii?Q?WmzQxfJ6bDe2CkFFR6veRzPl/tNDiRQrotDrUxDfoCuEAcOoFKm3i9gXe4sV?=
 =?us-ascii?Q?YyA3CNRFmrI4oLeAqmU4eqbfx+aNW4ItLyy4ZjJvn2WRMQFJKNXAAytIGOOs?=
 =?us-ascii?Q?EdBKm+toIsWdoTqmoXEQJ0pG94RBE9bK4f2AO/rbiY9rr9WapTWEJW9c17/q?=
 =?us-ascii?Q?2dqI2xibWCgdpYGu4pFiadCMzllzHvjWeNuJfbsR2ShLken6WyvxuivGXEPH?=
 =?us-ascii?Q?PysZtNy2IBZpLv7EGr6kkxY8BtieDZiPn4Qe+Tm5e+6nZ9Pb+D7qAaF2Ekkt?=
 =?us-ascii?Q?dqXULclVPkMm0QQktCQljUb5V3p3cbUFSAYC7P4RIe8/ak9jutP0jDxv1s6h?=
 =?us-ascii?Q?XDSPH/Q+++PygQiawLcqqi9p2gOOVvGOXZB3EN7KBSbyVQbzjarOfetS68Ee?=
 =?us-ascii?Q?SRnYrd+t4bKhfG3kja3+wif+EPOAfksXfzrwpnhHUWKTSUJ3l8vYjn8ircqF?=
 =?us-ascii?Q?KAkUhcfoWX4240yd94nnR2mGbndJU71+4yjZxUNBzjdScpeaqy1XdbrfSm0O?=
 =?us-ascii?Q?pWh0RBzwok7ikB+MwaY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4864697f-21bc-4e1d-d3a5-08dd04c90f40
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 16:26:14.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mgG78C1uDpXJiq2BzBnCzUQsbGLcc0xPtNLTKNWCMma+1GZLsBXsWGAZKTvQA58
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9410

On Thu, Nov 14, 2024 at 11:53:17AM +0200, Yishai Hadas wrote:
> Fix an unwind issue in mlx5vf_add_migration_pages().
> 
> If a set of pages is allocated but fails to be added to the SG table,
> they need to be freed to prevent a memory leak.
> 
> Any pages successfully added to the SG table will be freed as part of
> mlx5vf_free_data_buffer().
> 
> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

