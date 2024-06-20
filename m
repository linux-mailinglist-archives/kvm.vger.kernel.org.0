Return-Path: <kvm+bounces-20062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B24910140
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 12:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24A51F22C68
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AF31A8C19;
	Thu, 20 Jun 2024 10:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQCt7FNv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4FD628;
	Thu, 20 Jun 2024 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718878565; cv=fail; b=hdR+plH0ga6TVGx6m2IR7O4GFHnzO0OUuUycleR74th555fMfTapYJJ4kIU8ORDjc8WUL/8DtLpUyp8cgzoSDd4KiZ5yEpI0J7efyN9c8igPONI0SnpcDRHuudBU29g9CYk4ncVWA3TiZkDAuAnxYV26no7k9ARPADCgkx9sKtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718878565; c=relaxed/simple;
	bh=ppXVJ7JGBLb02NMq3EcxZfmlTOb0ksDnsvp4neHPNAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ry4nW9X5UrIIdkFXp7jnBQKoo2QICMCabBKQXKua2Yn4q1OskhZBb4gZ8OQVCr5PC8hA3XJ18zf4/aKmBdQwNUiEaUGZYhXTSDAdqiMIA+9E1xOywSKv/i84ewRnZUM8gNn2IejmKYe6YKZGz7wKhJ3nIktXbQIZXN9SHFD8HR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQCt7FNv; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718878564; x=1750414564;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ppXVJ7JGBLb02NMq3EcxZfmlTOb0ksDnsvp4neHPNAM=;
  b=KQCt7FNvH2eA1qnSQziVEnBzz6itbH8ffG658+lFGwjCaalSnSCm/Cu6
   iSG4mTMM9cJ84VxQUPQL10PFCDgAAWUs1hMVcIshbiAQQC0YWFLVLwtkL
   1NZYbkFxLuXKcKrmKpeeNN9Lh+zPrNbez0x6sKC55iPEsrYCGS8VtREaN
   3sZx4418i18VUZvAz1HEB8+tnVeeBK4FB/ppS2yk7RVK/rHBwBIq8naIX
   Xff9+0oGuMVT4CeOTRw0tII5eKBHHlw9FOYgsk8WPnnL7+a77x0ScXL3x
   bNg1YI1YzXt2OkcvjnjdHVERDen7JN22Iy9WGtfSFe+wqrAoE4eORM5Da
   Q==;
X-CSE-ConnectionGUID: g1Ls0NaHTQOcn7rviJ5VsQ==
X-CSE-MsgGUID: tPZVXH7hQyGBQY9gVNzTnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="41248911"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="41248911"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 03:16:03 -0700
X-CSE-ConnectionGUID: z9flMIXDQ5e3FXybW9nasw==
X-CSE-MsgGUID: rWRv/8sDT9OsGwmaoCYOrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72925162"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 03:16:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 03:16:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 03:16:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 03:15:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwH62BgWDFB94TH0CJmC8Dr2sCmCxRUtBZlaC1rCG1IgC87RUqBnfPyTP5U+cQUcmMQEeAyrEzq1CBQ0tzG/2XyjlXpslXiBMdR8TGeOyu+dDjngh/TvIeTtdSa23Y19zxKwvwao95AZ02IhA+lFrmLTIbAGIlBnzvq2qXLGlwj5eysUdwgidPKDsLNjmcVoeo4M/YY7bwHNAU0ThYm7hj0eloXeeSGusuVMRqEEOwtA6sqprz6tLoKIIMU2rnLtJ/P14Re6qm1pzz1SXj/Fj8WA3WHa8PuMit7GWSeK+AszrlZ6lcThkPGYgTXaBXShU/yEDY2lnrf1qG5LHY01Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrI6m78cIv5yKCMYnCZFqdoEZCyxcQ85WrwFtKJqNqQ=;
 b=iidcRG90HsyLHavGIV2nro75M1ycW9JCe3laJEuuoqo9J/qegIrFkvasEluBvdOKsfZqI+dOQJ8WCtSp7e+GAHksxdDdd3DoaLbPSm4adzZ5TkE7L0554qZXbzHE8iQ2LZOVFHXZN99Og+n3pWJp48/UG/5FarEaXsD7OahMyPpQL+jH3wtz1BV0DkkidFXzt/HN7NE3lhM9anKZ93y6AfQ0VwahWP2PDd5tAw9vVw/FBO8OwkTCvs+F75nyTGz4Ua9MKVdTfwqptzfV/0OY0SK1POP4GZC14vWiG8jqmI1TxmK+qiepKgGpuBaZwlgVPOeK88V8cj9W2N22sxMgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.25; Thu, 20 Jun 2024 10:15:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 10:15:50 +0000
Date: Thu, 20 Jun 2024 18:14:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<peterx@redhat.com>, <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZnQBEmjEFoO39rRO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240617095332.30543-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c028f5-83f9-4e3b-720b-08dc9111f581
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qQlLTpjWVeUIVm0eSbvVlyjFsmprj4rSBRr1/LLA2hkVZ1Mtqd6SUq+7FV7X?=
 =?us-ascii?Q?AQpJ6hWNw4Ncr0q8b3IpajDAvRbocU3C0xEAdE1Co2eSU1sAVSu3xeWF/EL0?=
 =?us-ascii?Q?B4522HVAcjj25UY2VTFqwEr2O4dnl9H9h29BzqxEB3IT8LLI5Bt7/eusLX/Z?=
 =?us-ascii?Q?lClSEvb74wG9ZVZQm3LGl0aw8Migdp+VPOnjenYjoZ9FKhR52NiFDdZGnAyQ?=
 =?us-ascii?Q?kfjHU748RTiQP7lXKVkAUFjhNg/apebYXbrKagmLt9ICU/S1DRqmIzD00rn1?=
 =?us-ascii?Q?CTESCwlYZwFh3i4iFPvECSLVz1eztorQOGNM6XIosHz2ZxQUSP+dKhfwJTbe?=
 =?us-ascii?Q?Ev3pxRdt/TsYVu/q/kE2Obd4fuj7FY17S9iAtB3WoxyfIPiIOa67YrkCIo41?=
 =?us-ascii?Q?U/mJSbkPOslf81NLefHWPKs0j5VLXYU314eqURP/Z0gucS6TKAZZYi4wzJHG?=
 =?us-ascii?Q?eYUiPPOkqIRfJ72FuYDhRR36T8zb1bEZEN0r5pmSFd/nuUxABfI6m65hKO0x?=
 =?us-ascii?Q?Yruk+bIgH5P/2BT79d9U+g/QOyhbbOs+9AT+fA1Y5AVh2TZpVrw+H8RQUIjo?=
 =?us-ascii?Q?9rpsp3taboXjd3Kq1/+SkE/IaYQMjEeh5I6XCfQbfGsr5c4KNhGUaqHK0hY6?=
 =?us-ascii?Q?PoG+KFZK/4AXEsBxtvtOnh0K6RTwkRmidNTtWWraA4R4Pz3ICcvRryeq4qUP?=
 =?us-ascii?Q?AmqUSg+g4qmq7FOaadEa4PUFEP/tn8LxAf7ZiJuS5p0mRFIYJaAKsZELgVWv?=
 =?us-ascii?Q?6c14wKeffyc/mFTFLAvmDfUqOcXw1ev0vFO6D56VNZqD0wNuF/LrD1T1eY3v?=
 =?us-ascii?Q?tkYNmC+asVTKE8+/F33vAI8j4LwWNM3bfXAUwJqoAEQYNzRGK2O45ev9GNYR?=
 =?us-ascii?Q?iRJ+3OPopMI9UvyOpZl0dOvpEwhJmYTqGi/B9yEKEJNtix4RtjUXmt+yIkdp?=
 =?us-ascii?Q?ZWQ5qVhDSCRwFyBNs+tR5KC/oGKPx85zS2NEH/+/uu/sELXMC1Vp2yzTsIua?=
 =?us-ascii?Q?+QXfaBlQqmoIBnc8v1LrWf4OQGP+czfWWgNQWwyBL/YAB1ulRggWtaQE/gP8?=
 =?us-ascii?Q?I/AeboFOU+W+znwsGCdxnUxPNcaTYCDncjLsAE1x3wlRn8lZY56hkKwS5f4g?=
 =?us-ascii?Q?7wSnvE0IVg9N817ypW57AJ66VJM+Cqpa8pzpzhRiK5IO4pvjkkOwObchfTJs?=
 =?us-ascii?Q?mUmzKU+wYc0QTUJpCr1+AKoz6mbzl/X6d0Z2ZuiEBzNZHaF135+PXJI1OCWG?=
 =?us-ascii?Q?KJXhXO4uC7SVpkZUfnjOM0li5HQjjDjMtyQ9+a4bSHF7oX6J+gxvwFmQPH+M?=
 =?us-ascii?Q?JfThxiEYE0SRx28L4dm1RktF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+VNbtKPoCFFuCzbK0CZxqZxP/mi1sex3l8o/WEGI/MhOXXXcmvOn1auYtozq?=
 =?us-ascii?Q?sMFfpldll2n71EJIUBlG6r0egKtuKtFdxN/cNIEv61Z4OT5j0ZVBxzibUixQ?=
 =?us-ascii?Q?5ajgmDJnvZGxGLGh43cET3oYOFDx8XbtQ4P1rfONkR4qBuiVCgeZfKRr+4J3?=
 =?us-ascii?Q?u5dAdjWrWqvs07+DeAcfvyPTN6E5vqlSg5da3RrH0d4ZuGgdcnVmumNU0xcM?=
 =?us-ascii?Q?ouRNOj14huN1+NpR2FDVJhz1Kj9mK8zXZTkC6jGU54r8eIi3OqvqkEj6sQgA?=
 =?us-ascii?Q?FqpGoqQTK9FRUc2pAOwAmFIemcwDibEn6LGECdq2eADp+JZjeIVvn4WVi59h?=
 =?us-ascii?Q?k+c7Q04p5qZfMArU8JZnNJkI90gtDwqjpObweGb2enUqADdZVi+xz6ZML0yq?=
 =?us-ascii?Q?WoEWTXfjGi07gwZnfyyXK031b2rfHHqNpzUa/DLTtWQ/dXaax9QXpOc3uKzc?=
 =?us-ascii?Q?Lr/pBthSvTvOvEy9lXA5ImK/63C/myKUTvcRzMk23PSKQFSwvrSOGMnPAaPt?=
 =?us-ascii?Q?S91DftTCuD5LLmZmmpLXC2DIx3kN5NR+jMMVbz5ihjCPbE6gTGbN80IHteI0?=
 =?us-ascii?Q?2N13dM70hq+u50VLyXEnkvoyYF/E5AEQok68/r+oC16mCpd7nbn5+Qkjh7vd?=
 =?us-ascii?Q?edsxNU4GdlVWYPYOnfBDpHK/+M1bFldPU1JtO0N3Rw9cdBXsRtoyRNW9OG9C?=
 =?us-ascii?Q?VCwvUKTds5Dl4SFNuELZ5W0qH4aJEvwGbuCMp0XZwF8qqncF9tcwkCliES8v?=
 =?us-ascii?Q?nJEIOaNsm+q9B/lydqPu9j5DQ5h0Izyl/GsXbPYZ/JWWWxUSZ5PBQtk9rkiW?=
 =?us-ascii?Q?bhLORm7jJ2W/4sE8o55vL4AtXVGSvlj5qmPySKr9uum+um8T0UGS3f8ev+Wt?=
 =?us-ascii?Q?2A1T/lj8U9foDnnr3BCEGPHpfEvZhqXbZlNNF6sMb3sh5FUz7l+LytXm2ClG?=
 =?us-ascii?Q?UYjH+9IS4GHnLKEBvpUHAmx30+bZkdj39N6kD8ltZ9q+m+GrM1Tbjc0YcoGN?=
 =?us-ascii?Q?JoXTiyrqJlD9ebv2bx5wn02NTKehVrtL+24I9RwDMBT063IIvSa6l45lNmaI?=
 =?us-ascii?Q?VeOhEusfTQLlgL8wjRW1gtViMcs6uPUWSZ+/UxqoxYvd2mngT7facH0HHYTc?=
 =?us-ascii?Q?WfSjUM8qs5g6eJNU1w3D/uxT2yNHZJO08X43Zwaz41Dlc6vEoOPaXQtrIiMI?=
 =?us-ascii?Q?bliLLlzytCay7HtL9UCgafuZlINBsakc0sXZ6ZrV78yH2Qnzy6VMT49pbInA?=
 =?us-ascii?Q?az5J6pLCvfKI/WS7d8OAvAARPWJ1T1GYMZX9tzRbHD71fC98fpAax02C1dtT?=
 =?us-ascii?Q?/YOGxmmzZsEvPVLRqeCtZGyYGhSn/6MHFzZXhrF/CB3gSBqSEKgj0jWKVrqj?=
 =?us-ascii?Q?yWJj9Vi3kKd0tLbEPX8P11LLsPp/GAwwIiegVsC7tG//ucyfV2i2mCIQuYPX?=
 =?us-ascii?Q?OSgUM28b/SrYyN9Emt4EE5bZ8pXvWfSYntXgfH41bBZhGFWLKcVaKJmD60uZ?=
 =?us-ascii?Q?5F5JA8f5iDAoGh/g3cNxPGzLlGfA5GQgVEoyEmRVdet/aWBvIUPOKCWtawQs?=
 =?us-ascii?Q?PNLhn3jzF2B93RfFX8SWCBa62C7yUneMiY3/0zSE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c028f5-83f9-4e3b-720b-08dc9111f581
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 10:15:50.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACh8PPk+kscGDv9wCwhwE9jv26uQJktu4NqE5zEWwhOjhsfKDEuNU08LObBas9c6zDxcDD+4oxizupKcmIVNzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
...
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index ded364588d29..aaef188003b6 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	if (ret)
>  		goto err_free;
>  
> -	/*
> -	 * We can't use anon_inode_getfd() because we need to modify
> -	 * the f_mode flags directly to allow more than just ioctls
> -	 */
> -	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> -				   df, O_RDWR);
> +	filep = vfio_device_get_pseudo_file(device);
If getting an inode from vfio_fs_type is not a must, maybe we could use
anon_inode_create_getfile() here?
Then changes to group.c and vfio_main.c can be simplified as below:

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index ded364588d29..7f2f7871403f 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -269,29 +269,22 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
                goto err_free;

        /*
-        * We can't use anon_inode_getfd() because we need to modify
-        * the f_mode flags directly to allow more than just ioctls
+        * Get a unique inode from anon_inodefs
         */
-       filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-                                  df, O_RDWR);
+       filep = anon_inode_create_getfile("[vfio-device]", &vfio_device_fops, df,
+                                         O_RDWR, NULL);
        if (IS_ERR(filep)) {
                ret = PTR_ERR(filep);
                goto err_close_device;
        }
-
-       /*
-        * TODO: add an anon_inode interface to do this.
-        * Appears to be missing by lack of need rather than
-        * explicitly prevented.  Now there's need.
-        */
        filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);

        /*
-        * Use the pseudo fs inode on the device to link all mmaps
-        * to the same address space, allowing us to unmap all vmas
-        * associated to this device using unmap_mapping_range().
+        * mmaps are linked to the address space of the filep->f_inode.
+        * Save the inode in device->inode to allow unmap_mapping_range() to
+        * unmap all vmas.
         */
-       filep->f_mapping = device->inode->i_mapping;
+       device->inode = filep->f_inode;

        if (device->group->type == VFIO_NO_IOMMU)
                dev_warn(device->dev, "vfio-noiommu device opened by user "

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..c9dac788411b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -192,8 +192,6 @@ static void vfio_device_release(struct device *dev)
        if (device->ops->release)
                device->ops->release(device);

-       iput(device->inode);
-       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
        kvfree(device);
 }

@@ -248,22 +246,6 @@ static struct file_system_type vfio_fs_type = {
        .kill_sb = kill_anon_super,
 };

-static struct inode *vfio_fs_inode_new(void)
-{
-       struct inode *inode;
-       int ret;
-
-       ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
-       if (ret)
-               return ERR_PTR(ret);
-
-       inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);
-       if (IS_ERR(inode))
-               simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
-
-       return inode;
-}
-
 /*
  * Initialize a vfio_device so it can be registered to vfio core.
  */
@@ -282,11 +264,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
        init_completion(&device->comp);
        device->dev = dev;
        device->ops = ops;
-       device->inode = vfio_fs_inode_new();
-       if (IS_ERR(device->inode)) {
-               ret = PTR_ERR(device->inode);
-               goto out_inode;
-       }

        if (ops->init) {
                ret = ops->init(device);
@@ -301,9 +278,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
        return 0;

 out_uninit:
-       iput(device->inode);
-       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
-out_inode:
        vfio_release_device_set(device);
        ida_free(&vfio.device_ida, device->index);
        return ret;


> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..1f8915f79fbb 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -35,6 +35,7 @@ struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
>  extern const struct file_operations vfio_device_fops;
> +struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
>  extern bool vfio_noiommu __read_mostly;
> @@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
>  {
>  }
>  #endif /* CONFIG_VFIO_DEVICE_CDEV */
> +struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
Sorry, this line was included by mistake.

