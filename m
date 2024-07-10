Return-Path: <kvm+bounces-21311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAC892D466
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 16:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 796A81C20A3B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 14:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08B219408C;
	Wed, 10 Jul 2024 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O0QFeWD9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABF3193459;
	Wed, 10 Jul 2024 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720622451; cv=fail; b=auH9byB+sw6Zc5HGot4HSqgwBjUr0vcOOxkeKkVc3T7NF7udE6OkDCjfbDQA2AwEjcIvYFV1uwW6E+2shxZao++f0mzG6RG9Dm/JRi4081yDqP/W/vC70g5+JSxC10Z3niv+SsK9GqT7jJhBFwOU/6bGqVieekpb4K9cm+0xbrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720622451; c=relaxed/simple;
	bh=Ws0jFgL+QXLqehZKzT9SoJCp+/MxLR0dgh2kRNLROvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B1G5nYTJOETON5P505smKJU8m5FtCQoRt8wTDNo1vXwrxdbWxzf/euV+YQ/5UHT4gg+1oLHAch1Vy0RP2LveCf2GYTfaaMvnemcYBPdrTZJX/qw81XjLBt1JKvidnxgCDDoc4bkqOsBNS+ofa4dK1l7SoJTG5LncLeyB0wAQAmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O0QFeWD9; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhO8g0oszeQRfcYvWN508yZc9uFbBkQ69BPw3IEDenJDropEmJmgdT2aIZsdN9KorBBjtVkWNF2uP4lJbXgnYCxRzAOTKzC3CJgNCCzcQwN5viGQF9ewzI4ZeVMBo14oZSCfhTaq3QXjiwvxJJUaJXT6q5A14tWCKlZJ2l+r/6AGmts9J4Q69Fzsg96H5OK3NHr9pfrbSpV2EjH8AXjuucldbtx2PwXPD9fGP0zqNaG6v2QQbhkr4IBoIH7FmGH/O5MtN8kFOhE1VW27yBZTe1zPhZCRd1B+lzOCKOUdsK2UWs+0Zxd1L7gf7FcZz6IlXjj8GtW3g3nBlndcKVcalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ws0jFgL+QXLqehZKzT9SoJCp+/MxLR0dgh2kRNLROvc=;
 b=R4c61BRjnZjNjbTSIB1WFUalci5XEM/Zc4iFQKNiMev+IXkforxnAXG1Fc4I6bUWvCy/6Amo85aMk1kn1xKw8qti5r/VQ1o/UDOFuM62I9yMCprg/bUOv/XqWWju4ItjQjWaEB2mK5b8IVtZxA2a3Pu3VvDpVQW69EO+rTN71TsweTFeheKK8HdaXymDGShT9TEgMS/L7PkLMb2BaRsn4jsolBk/7gVbUttBnf6RtYfGpS/1YcSaWR96CLOmsYSX8UJByifnyF0111A22rbuZHsyQaCysiE6xqKdutOUMigJ4HWOc8giIk1wBTg1P06HNcYyM1e6vOPpeIpdbIahow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws0jFgL+QXLqehZKzT9SoJCp+/MxLR0dgh2kRNLROvc=;
 b=O0QFeWD9vTWxMiAoCHGtwEbqmnfbAjxg1I64Zrq1vzqPgItxhgD7p6k1Ofk7Zr5NCgMYoTrr2cxY3s7cBA/GYnh0gsVJ/P93I7n/8cE8x498seZK3Wl7nXRAReY5SGAfASOPUlkufSyYYOnSpsXOImWD1qiPB9D6fkzv9mDfXspPIQPKj6hZLTP+qjrbM1n7J7sXuHk/aD7QTW6MwNiKLxUymHCXE0y258tSUePka2A7ogVc3RbJo73QnwptoItgcBVB81bJQQeWjbdXx/F5r21pDeFff+8grLwy8+TjkWGXcJ48FqjwcTRq5VbQn+5jrO0XliIMGUUOwhoZpFrj5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4424.namprd12.prod.outlook.com (2603:10b6:208:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19; Wed, 10 Jul
 2024 14:40:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 14:40:46 +0000
Date: Wed, 10 Jul 2024 11:40:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <20240710144044.GA1482543@nvidia.com>
References: <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
 <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
 <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
 <ZoJDFyqzGVuntt94@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoJDFyqzGVuntt94@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BL1P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::12) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f54efb6-a9b2-4189-57df-08dca0ee48e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u6hZXZmbE6kblBszZgcej8idNhNHZbDND99cc0sg6YaXNRBy9wqFXyLICdx9?=
 =?us-ascii?Q?nXADz9aatvevZwmaZKeV7C6dHJh//26S6/+KNIGqCfqjG5GibFAGma/V18o/?=
 =?us-ascii?Q?dN1XAxtm7dMubsCS6P+DCcXiVl2spqP5X4fZMlONtVcfOZxfkM8KeALcas4E?=
 =?us-ascii?Q?kQgUzmS+hADsq9Cdm6Y48uYmaF3pm/KfUKfnvlZxo2N91UeYgNPmXmZts3oY?=
 =?us-ascii?Q?lSV1rbES5KPwFTW14XlP9di9p8hg6L8wept21OIUm17QZ9W9+UNnKUnPPEq2?=
 =?us-ascii?Q?dPoGGZBlBE5eSw1IJz1csJCGnQ7at+tX/GnoCUc0xah+4DtfI/mItu1/qV4L?=
 =?us-ascii?Q?ujRBJWMulREV4NFR+kqG3AIvffygPXuyQnuDsYOphCu7/wUcyHCwIT0hW9w8?=
 =?us-ascii?Q?/ShivAVfKmn6n1Qkdc5x20SAmW537YC8+HNlNEowITrZBTXin4h+ZNAba284?=
 =?us-ascii?Q?3WiALK7zUckyBrVhD9v2l8+R/W1g9N0hTMO4owwaTZSpFWg9YUQtHV4kfF/H?=
 =?us-ascii?Q?lk42rSnz2Zxtnn3AYc2UXa5jJHrcdguXgBfY8ltbiIhMnrrCekIrm/ZJftEW?=
 =?us-ascii?Q?Uh81URuCicbYEBi5M5HgPSTw4qa6ZlzO1pP/RD0ks5WywdQY6bo6SwCwo0dA?=
 =?us-ascii?Q?5m1XWwwFlag+eh2U/OkzB+wHOuzDEfW5i2SdhClgmVZwozd/zmkUuBtS93/6?=
 =?us-ascii?Q?haXRyS5h7FhYhk9p37R+rSsLFWnEauCBVnXe3Nur99DyfVJuNNHaERXL1xDD?=
 =?us-ascii?Q?pxV2yp4RT7PImbOg0kSYq0J8yN1rXuoAjLeoeuDZtsy7JLVnb0fOTC8qW+hB?=
 =?us-ascii?Q?wro+Dh+ycnjG3+ALDsMu1U2VlGN7ft6rvas3mzMp8Hx9e+/Yaq3SbckY/uK0?=
 =?us-ascii?Q?Enclbtm2C6r92f5hmr0eXKf3IfuQyyNU8Lrv5diP8JZWb5DlDcHY4+ZvHBn+?=
 =?us-ascii?Q?zQN4abPkXbRiXkSlgYGaI7YuWtpHhcfQVgmeGdj2zAfFcRdbyOctnEnBdCvM?=
 =?us-ascii?Q?Dl13Ob5/e4lCr6nkVUsKuvqqbfCsZP2E4sRkfmGlXMCuaRdnhXnIoYVkb6L6?=
 =?us-ascii?Q?RgpVdi2y2qJKiolFRz1/7qliB4Ly3IsA7jt3KJglORGGzePGAhM+l9vRw6Il?=
 =?us-ascii?Q?I5x4XHVSWcQd/KMDtJ74X5lfg+Sf0kWQjc2tWbZz3Bt7g09TVzwW+BmWDSRa?=
 =?us-ascii?Q?SE1oQYs1fbGUB+G6U1el+Key+Pu4efHZexPdOjPlz2CgC8BbctUCXIV1tcQr?=
 =?us-ascii?Q?6cZ3je35Iak5svEEiNkojovb3LIuYsKc3nTo159BXTumQZNygog7LB8ONGA5?=
 =?us-ascii?Q?Bz/YQXMs/Hy+lC9V9lehpYNR1vdXeNgEBSFthGLGBV/0hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xfKHoJgV3kiR0X4gYahHq4+kO6EdbOZxCBkXoaDGDFMPjMn3CPw85NbwgACE?=
 =?us-ascii?Q?aQWblEh4d1ADiKA+UTXfamdaD5czwZ37/im4X5nHkVki24FZ6t+iCjv7PnTS?=
 =?us-ascii?Q?u5I9rxfCP1TQ5HeNhld5LbaCrGCrTDJpMvI8VlVaDKf7O5EKF5AUG5EC5d+A?=
 =?us-ascii?Q?QUkKZ2AaIXXtlp3HIE71eYnJHWU1i2LuMZYWi02Cf3iREgwfIsb+nLc5MAiz?=
 =?us-ascii?Q?t0XR318AuZESyjvlIpw588pkgSJ/Lx4A/Mm1yniiHurWp4JUIDdf6SsY7Tm6?=
 =?us-ascii?Q?8icCmZSmJQGhqDzhnvMwjOyyLC0PHFyX9CsUmUvT47f93uUOT1hzdx29rYzW?=
 =?us-ascii?Q?K70egw3CgtBkxuMvJ/tt+hNXaI4czvzKm414kFfe7JGI1Mnrgn6grmhtZMEY?=
 =?us-ascii?Q?WNlcII4bGegr9McJQGqx08lPzEsB3OYNyEtnpLKVVkZS2Kiggibi1tk19q9P?=
 =?us-ascii?Q?eeW4rvWYRbyWsc4Fa/kgZW7ASPywIAPHRvzPV6SO9qyNgd3nFDFZ60YG3blN?=
 =?us-ascii?Q?c49kA/EmkdPzeS98DBU8vN/w/qNtPtpmP7/gkqnUkWUzQcqGfxp89bbGiea2?=
 =?us-ascii?Q?LaDrM8Tv8EgY+hEssr0gV7gNEgM1tliqdwMYaqoqkE2d4xjYw19ytSqQ3dh7?=
 =?us-ascii?Q?M+hoJNFvjyN2PIX5KbSNxYNC4+cwOKxyHZDdRJYh1+I23tc2HDaF2AXg5YuR?=
 =?us-ascii?Q?gCdHkxIZ0lpPeB1Jcy80SI9Cec8RxQtYGhR2+9AWz7eFkf9u6bVJj4+Si0qG?=
 =?us-ascii?Q?40ObCceRiVlCY+mSy8D8IehgmimQ+RE7E20G126WXLe640JHtIRUDvYk9rhr?=
 =?us-ascii?Q?doBt8CwVP9hTYz6x+tFADobRGP/iu31er43ZG2utv9Ydn58KnUslTjl33Mlr?=
 =?us-ascii?Q?SaoUYjroCYHVjtD7hZVHyxpDZus8ZcfyciZrwtTlOJdBAZSsq1QK7XhdnrEz?=
 =?us-ascii?Q?4VySQUw2UsL7wqLI0pidL3e5FuqhW7gGi8MWphbrxV3lEXkk1zFikbh6g2t0?=
 =?us-ascii?Q?L1FKSaBQPB7bDyXKQrGINdPzZql+bN8Jz4XeNCOLb2MRh8tCnRgZACU/XXlH?=
 =?us-ascii?Q?5rUoLkOVYQsQVci0dAlH/2Qm1tnkN6OTrwwWASr4FN+R2opeOmysO3rEJsUI?=
 =?us-ascii?Q?bPgLjwsSLCfNBpC985SamWp7vlhp6BlAuMr3Urm8RNpDcdED1ttnj1y13tOK?=
 =?us-ascii?Q?ztcGs3UnmV30RyH/UPLv7PmLkt/prRnhmuRhsp5EPDDTP1pCvSsrjngEl9Sv?=
 =?us-ascii?Q?vtDaWd6eNirXvn10E4lSXvXL2CE0owULyEXblScvvHgS7yJTSoEgR+AbYDXP?=
 =?us-ascii?Q?AVmOgsCFykd6uKlNqWkKx0XExUBkVWLHk6BDOJHMz+6TUKrFWqGxeb9WUi7q?=
 =?us-ascii?Q?n7ou64TZ9a0Ky7ewQIHqHPLcieVnxgIyTXCQxhW5bnByrANgooLR/opg0H8m?=
 =?us-ascii?Q?w5v/VsO0iPSZBTyyP1oCD4Dpq4/7Embu2/GQ3X4BEVmAQ2tidvLHhSThVdJq?=
 =?us-ascii?Q?Je15o+PjPOsIEYfU+mqmUP5OfbVeIzH9n0qpWBXxStcmDsKISipZbwYo8H9/?=
 =?us-ascii?Q?wo/7EVwiR627DozokakVpxbPH9OZz156kFs1bZlD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f54efb6-a9b2-4189-57df-08dca0ee48e1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 14:40:46.8660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2j19UrbTqsPQzyIABGck1P795zDxx+Rk8+T5hlzpmAltwwQTorfR0nO8QGvgqiGL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4424

On Mon, Jul 01, 2024 at 01:48:07PM +0800, Yan Zhao wrote:

> No, I don't have such a need.
> I just find it's confusing to say "Only the group path allows the device to be
> opened multiple times. The device cdev path doesn't have a secure way for it",
> since it's still doable to achieve the same "secure" level in cdev path and the
> group path is not that "secure" :)

It is more that the group path had an API that allowed for multiple
FDs without an actual need to ever use that. You can always make more
FDs with dup.

There is no reason for this functionality, we just have to keep it
working as a matter of uABI compatability and we are being more strict
in the new APIs.

Jason

