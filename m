Return-Path: <kvm+bounces-16183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCE28B6052
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 781E01F21BCD
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6161272D3;
	Mon, 29 Apr 2024 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QUkSdU7S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE9E1272B2
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714412689; cv=fail; b=rIDG3NGdV5WnYGbs2AmHi6DRfAsZv5cV7J6jV9NiQJ349q6+HpTcI7jpR3zyPryK3htUkUmP2MTFrzTYW1nXBMNGIvt3njDL+38H0+VuCRQwuCSZXWKscXIbE4tsN/Jeo+sIZIJ/LIxM0hJI+5AR2xoZd/0WRMrSAiS1QRXrdQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714412689; c=relaxed/simple;
	bh=9ooM7yt6ze+600vF6LLm3EkB8lOdADYJKgjspGtCX1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=muiF4cQz1A7PFmh30uXH4JoGrLevXvqWfytB0BwGmgtRVIh6UWxiVQESauBEXLDK1mGcKMvOMNVbZT7GsOtWcyymUSoggtyGw9iTrhXejb3y37lOuV7j+MipG2lHdC0DisQCopjp/7DRrRlXtdl8JYwIBU761/GfWM7qaQzDvMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QUkSdU7S; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDrI6DPF6lM+ZTPWgfxmfausYak6xwz54/+cV3GMjOLY2cy6PZw0ZbV0olW5fMcd/IUaOMq52S+MuI0ZTwq5i8sJQS2R86ifIMGpv3P0JyezgBCnf8teyfc5RVhUta5E5c/Qx6uKdwSKqujTHffeIC45vCNds45DbeRSqrnE3qTkd8xQ7Y0H7EJZc5Vmc0UVFID/KmXJfNiS5jqbFXvXtgKX+/az1rEkbIXoU6K/0BHnv9IuazRAirJssq1cZRDIc2LAtYJrJfKqZ8Mt1QSKLDogckNzSC8+zdOMu6RxXMFVavb/SnHRxpYiBJ+aVA2cOFWEWCKejyyXQ3uI2iSLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Sy29mngExAk7z332Nj1bLHhZeXMvS1gLj5v4o1ylmI=;
 b=ltBnIFErsXdnAQ867IXGCQVlNrRWjILFmrftgLExEekV9TB3gwdRuMulOUU9OsHMaYLNuUD4+nDocA1906f3Gv/otbpPupMUhIrKSuuX2BGCH7d5Lxke8OkqolauxlE2z+7xguh/yKvRQBQQC1UCejDNKs3iEVobzgtSMiew7A1ZN9+x097xMa/O3+C1LOwq3TJ8RYCSqGxj40waMk1ZG2Nn207NoWr+gFu4x0wy+Htq39PO/Zft0h9oxTFRMP51cd1tmPbrYnpxX5XCXYjDco0qDLeG9ZyDH++sBZbutL6/qowaeT6jBpF3pTaBFfLNRG4sMEXIokxMg+Car+aOEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Sy29mngExAk7z332Nj1bLHhZeXMvS1gLj5v4o1ylmI=;
 b=QUkSdU7SxZjBRgafFiddsXTSCU+ru9cF+rOewEeuGUb9Q0H1D5Oc3jFsSKODT4rIEQapUx4mwuFUZacSAfEpTHM8RdTtIxFViAfW2TQ3bjEpJw4S2f2hV81MQ6n/t2Y9dqyPryvdOgL47SD3qVKhXCXQxwmKIl87xYIkWEX4p2OCMER0jGvxHYY2j/rjzSuP7/T0ncAMaLy0mFWqoEpn1eQsd2fjitScl6syQSfdSQNyH429/P+Oy08XY0aiQccwU8yXUoSmLVtzLLhGldoRflEDZd5TBXWNBsMHSeJwvLqPuHSI+1zMRKCTwhoFW1jonzMYLh9zq+xqiRWNQ2DtoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BY5PR12MB4065.namprd12.prod.outlook.com (2603:10b6:a03:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Mon, 29 Apr
 2024 17:44:43 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 17:44:43 +0000
Date: Mon, 29 Apr 2024 14:44:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240429174442.GJ941030@nvidia.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426141354.1f003b5f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:208:d4::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BY5PR12MB4065:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee27a68-03cc-4ca2-ed69-08dc68740da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9jBhKxNGagNKvmzPzsE5u2Kn4eUcrIYnOzqr4E9yJ74NQokgOTsjFLWOoFep?=
 =?us-ascii?Q?HwZJmBdTN04S0nhvwSMz5WFs7Zd+WvEeP+usgo8tpRahml01qgoQ9nlSh3mP?=
 =?us-ascii?Q?GkMYWTP+ekr8upObIH1z4I4Om9PQOPTc5fT6CPTlR0R2BD+dN09FjbEgH7HC?=
 =?us-ascii?Q?ukg7bhMlZgIHyl8pOAYTXRhrJp2e9Nq/JmlGXFl+PQs4LlnKrQBJxd58S5IZ?=
 =?us-ascii?Q?baUHGmbuiRVCFFvIdgNyaI4u04oA2OTjsADwuIymUfSgv4E0GZHtDG5kGHRw?=
 =?us-ascii?Q?3OIfkyMX2MlwM+BCtLZxOB0Ncw3MfS6cfONdJf6+t3coKIAicV5ut8jyXzyD?=
 =?us-ascii?Q?oCfFu1HdZu0fae4vjaly9VlbRFnyr0U/qpWpsSK4BirxZ/HnQCbP9dl2i6d4?=
 =?us-ascii?Q?1RfpN7b9i8s5Xo6Vczm0E/8fJQM48MGxbx4ts9d0BUcrZH/QhVty/FLLqf3Z?=
 =?us-ascii?Q?VEi3+U+JiXTnsW6wTsRzx/WXaquLkA6TWhFzQb2K7wQ2yi7KYwPvuYjtKhtP?=
 =?us-ascii?Q?SqtN0u9SFJVJe6uzoZHIr2whJdqBlrcztprVxxpO4BB4ffnC1ugB9rIXhwSO?=
 =?us-ascii?Q?c2eOWZ+1++hmlwIqndzbnMq3U1FGkYYMYVyFS6z1hTLYiTyzKCg0dOjplUiE?=
 =?us-ascii?Q?ZcolmvjR9vSKCv+B/wAlwyBASawcOTgzjARmlyU/knt4DbUcmqxKz90s0d/o?=
 =?us-ascii?Q?jadixFRpct9LbEUWg7twQ/rRKnlNaa15GcdEro8TLcKwrbhccry8ljQN7K7Q?=
 =?us-ascii?Q?lnHnDqC6NjV/XUCCeQpq4KYe2x1De4WOfRCHv9xVvFCrxdogRo+ytX9eO9nE?=
 =?us-ascii?Q?6go0XLQKn1xsfHUG16yWSmqbgO94LGtJatKh0oEfG+T8j9WNKBlSPNweILVi?=
 =?us-ascii?Q?EThM/TDaDG+tTIybZM6sxgXw4MrjCLh63RFsFc1AAtsigilD4uHQ+UhLd1mI?=
 =?us-ascii?Q?DEeC/jrotrskLnGWglVS8WjtbWwTbVFHHRyDIyJebsljjg8ak2BokQrhvp7K?=
 =?us-ascii?Q?Bpwdi6Z2DDwzp1fiXq0Xh8HueH7/W3CVmmsmZO7IHbgGZf3iKVaXUsgbcqmm?=
 =?us-ascii?Q?RbEPZ+MyCaW449WbXR4HM6ox33qApdMz/EHsLYpeLT21mqT2H1hmeAuGyb7O?=
 =?us-ascii?Q?KQihqzTt7hbCV8gyldl91pDUnL2Go/4zLsJEb4XZpvYdrvhVA8UUvSAoMBZj?=
 =?us-ascii?Q?H/Obe5mAtq4Ym/w1fczy1QIQoGHzaH3MmHGR2WDQz6fe805T5p0dMHptPbG3?=
 =?us-ascii?Q?VoiG86I52cehkiYWIL5IGWd3fXCmX82ZCtgrTA6nRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fYmy/J7/AvP9CfH75wKGmyhZka8YI/p3dIRuZ5UtI4lmF0QATeUYGHysOIva?=
 =?us-ascii?Q?u9MsIFOVRneL6db1kjf5/xJ9078yDHfwXKXsttfUL15Dnh5iurgAv9AsOVy0?=
 =?us-ascii?Q?qX3tZNBZdk9zYFriPGp1k0xd1rMWqOd6gy6Fxz+7aUH3Nz7D2EcUUXWSHFbO?=
 =?us-ascii?Q?EMUeWDYx0UU/rHOCbU2k0rUDdQVNMKdJ+UWQFDFD2U3CF6bXXo5WA9Lia6sv?=
 =?us-ascii?Q?SYLJ7l6lS4ieGbACR4uaxsn2e2F94mZSjdjnHK5FUAJOvTjEihnvtQy0rWOI?=
 =?us-ascii?Q?1J8srBC8iV/rq6XxUpO/mtACkW6Ln3Z1n1bK18Bbtfp77prjsvhAGec6j03y?=
 =?us-ascii?Q?Towf1Lg2lPO7BcIoexU7gG1vJdq5dmJfZllnKQhF4cWDgzTkrBUXa8wPY8Xq?=
 =?us-ascii?Q?2R1gf7wxfiN1pTEzNXXpq91ShN8UE04oOhAnyXerF46HMYBgJQkySdZvaJCg?=
 =?us-ascii?Q?fiJmoQ3DZt025+EvDp+UQ86/iWQvSxPWw8+GJeMlCq+V6RhiZKzq6RzKoLwv?=
 =?us-ascii?Q?yRSJEb0ZIvbQC9+JBB7RLN4sftj1snbMXhldXAhiCXBp2QABB2MTx2nXZT7p?=
 =?us-ascii?Q?BQefdWcMM5JnujttQZep2DCal/Zym11Vbtsfayb81ZsfmT7TEiNpkmBkGdeE?=
 =?us-ascii?Q?kXL7rq3zhsKEP3apgNlYCGizoj12rgMVNrmrj5h7V1x2Qywo+gk2Zt+poroO?=
 =?us-ascii?Q?n2CNPs35D7bJdN75Fgn1ga8G37PGGB77OxSKiBcYQV5d+DRoOmjCDnRk8ln0?=
 =?us-ascii?Q?dS5Pg84g/U1wOqo+0eHpiNxHqDCWDbj8gPMpI1wnuIlpo1eUFA0PXyuFRYny?=
 =?us-ascii?Q?eIhlUsT5fXoc54tGdAZ2fZkOoYVCym8ZWRvLcZU8WOeCoEG2O665aJ7tS5Bz?=
 =?us-ascii?Q?0HHkHJ1bmOa5sUuGcRvPIH0wM6OjwE18ngrVaTFxbmEcbH3LHHHrKh9at4CK?=
 =?us-ascii?Q?eKvZs9qsNRMWL6thZiMz8zgllLvK1jOuhLTIUctIWV2NH3gfEuON97lc672b?=
 =?us-ascii?Q?H0EQLgScxm3IGRk+8JzFR8M+cmP0ELsEkQmCup9oY87tQX/i/3npwWXM/mg/?=
 =?us-ascii?Q?4T1bDIaoIQUCoeoj2Q2Kn5NhmCGWbxLISG7K91Gwgw4aoDvNFSCVwltVXO2A?=
 =?us-ascii?Q?MBVm1IBAtqY0sXTR8mShUztCEzIKPTLycqq8bT02XNX4CVbAbwujO5wvME78?=
 =?us-ascii?Q?kPxOjUf611/VYUZNDJMutWAY5V+8KtH2ugoVylU8KWxvvNbxjq5mEa8CjJTB?=
 =?us-ascii?Q?nkyjHw6cLVi5KUlY+7YEIZUgnXJx5Dg49aRhu8XwNs18a9pR7SF4WGOlIJVy?=
 =?us-ascii?Q?fCKvKfag1bygpHFgFwgvHg2lP+TDkd26y5jI0nuoabC3BG+V8SyA94CigYdw?=
 =?us-ascii?Q?Q/DMFMKfj5hgYrMEL7PeC+Lfmp1IpZrUwLVfnmOrzvu6W41Fb/2yo5rPtSiR?=
 =?us-ascii?Q?di4Ae75IwTIhUzSRLQRN7e6o01P+52RM92V8ZPfIgonwHYjJ4HJyNavI4qIH?=
 =?us-ascii?Q?L+JazlNw4e33t9Ktbdc9uUWEmjHWg/zOUXDjIhaJLpSU/kA9f8wDPQo/XoVj?=
 =?us-ascii?Q?Yc1gc3cmC7IYRwd3K8YuBI0l4KumviMCrMwtD/Mt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee27a68-03cc-4ca2-ed69-08dc68740da3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 17:44:43.5601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rLr6Y8a+tR2aC2SYi3k5YKTu7Rd6jds0KBysQx5bJTQb0iLtdH+xaCKG1jkvXSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4065

On Fri, Apr 26, 2024 at 02:13:54PM -0600, Alex Williamson wrote:
> On Fri, 26 Apr 2024 11:11:17 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
> > 
> > > This is kind of an absurd example to portray as a ubiquitous problem.
> > > Typically the config space layout is a reflection of hardware whether
> > > the device supports migration or not.  
> > 
> > Er, all our HW has FW constructed config space. It changes with FW
> > upgrades. We change it during the life of the product. This has to be
> > considered..
> 
> So as I understand it, the concern is that you have firmware that
> supports migration, but it also openly hostile to the fundamental
> aspects of exposing a stable device ABI in support of migration.

Well, that makes it sound rude, but yes that is part of it.

mlx5 is tremendously FW defined. The FW can only cope with migration
in some limited cases today. Making that compatability bigger is
ongoing work.

Config space is one of the areas that has not been addressed.
Currently things are such that the FW won't support migration in
combinations that have different physical config space - so it is not
a problem.

But, in principle, it is an issue. AFAIK, the only complete solution
is for the hypervisor to fully synthesize a stable config space.

So, if we keep this in the kernel then I'd imagine the kernel will
need to grow some shared infrastructure to fully synthezise the config
space - not text file based, but basically the same as what I
described for the VMM.

> > But that won't be true if the kernel is making decisions. The config
> > space layout depends now on the kernel driver version too.
> 
> But in the cases where we support migration there's a device specific
> variant driver that supports that migration.  It's the job of that
> variant driver to not only export and import the device state, but also
> to provide a consistent ABI to the user, which includes the config
> space layout. 

Yes, we could do that, but I'm not sure how it will work in all cases.

> I don't understand why we'd say the device programming ABI itself
> falls within the purview of the device/variant driver, but PCI
> config space is defined by device specific code at a higher level.

The "device programming ABI" doesn't contain any *policy*. The layout
of the config space is like 50% policy. Especially when we start to
talk about standards defined migration. The standards will set the
"device programming ABI" and maybe even specify the migration
stream. They will not, and arguably can not, specify the config space.

Config space layout is substantially policy of the instance type. Even
little things like the vendor IDs can be meaningfully replaced in VMs.

> Regarding "if we accept that text file configuration should be
> something the VMM supports", I'm not on board with this yet, so
> applying it to PASID discussion seems premature.

Sure, I'm just explaining a way this could all fit together.

> We've developed variant drivers specifically to host the device specific
> aspects of migration support.  The requirement of a consistent config
> space layout is a problem that only exists relative to migration.  

Well, I wouldn't go quite so far. Arguably even non-migritable
instance types may want to adjust thier config space. Eg if I'm using
a DPU and I get a NVMe/Virtio PCI function I may want to scrub out
details from the config space to make it more general. Even without
migration.

This already happens today in places like VDPA which completely
replace the underlying config space in some cases.

I see it as a difference from a world of highly constrained "instance
types" and a more ad hoc world.

> is an issue that I would have considered the responsibility of the
> variant driver, which would likely expect a consistent interface from
> the hardware/firmware.  Why does hostile firmware suddenly make it the
> VMM's problem to provide a consistent ABI to the config space of the
> device rather than the variant driver?

It is not "hostile firmware"! It accepting that a significant aspect
of the config layout is actually policy.

Plus the standards limitations that mean we can't change the config
space on the fly make it pretty much impossible for the device to
acutally do anything to help here. Software must fix the config space.

> Obviously config maps are something that a VMM could do, but it also
> seems to impose a non-trivial burden that every VMM requires an
> implementation of a config space map and integration for each device
> rather than simply expecting the exposed config space of the device to
> be part of the migration ABI.  

Well, the flip is true to, it is alot of burden on every variant
device driver implement and on the kernel in general to manage config
space policy on behalf of the VMM.

My point is if the VMM is already going to be forced to manage config
space policy for other good reasons, are we sure we want to put a
bunch of stuff in the kernel that sometimes won't be used?

> Also this solution specifically only addresses config space
> compatibility without considering the more generic issue that a
> variant driver can expose different device personas.  A versioned
> persona and config space virtualization in the variant driver is a
> much more flexible solution.

It is addressed, the different personas would have their own text file
maps. The target VMM would have to load the right map. Shared common
code across all the variant drivers.

Jason

