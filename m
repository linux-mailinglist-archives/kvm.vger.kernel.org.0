Return-Path: <kvm+bounces-7530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 113E08436A3
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD74E281B1F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 06:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2193A3E49D;
	Wed, 31 Jan 2024 06:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Et1ZJXlA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A73E48C;
	Wed, 31 Jan 2024 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682352; cv=fail; b=hitwNGo/QBB5ycbWBTZoUt/4RhkSX6GNABSxAY3qb80CfXbyJMHZU1FPv4E8x2ai0wgsZRCGNZZDn4VIHNnIVVB59ewowoKNgD55jHLuFdMcoqbRmpmF4BZfg7YUZe40ahMWHVmsVpKf/4t2N5n/xoRFP2kGw3nt9dJfkVouyWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682352; c=relaxed/simple;
	bh=Yx129n+DHjBYWZ2m2csq4L3L9WyMdgpeNl8aBP1ASQk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WGyXdHTEZzIRoFtVXjMGBxV8sVFp7cwQQApmtJ5dXGJzYYtKomnkzd7PkYaMGaDPbmTgGLCGy0dCFwLXPBunu1HSCulVmamgPwH/8kJaLS4eJoXSkxXWHVuCpj0IYfC+voqiNmST9T4QM3qwXjpV/I5sAHg8PzJzitKcPzyVdzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Et1ZJXlA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706682350; x=1738218350;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Yx129n+DHjBYWZ2m2csq4L3L9WyMdgpeNl8aBP1ASQk=;
  b=Et1ZJXlA/NCQ5zNW+unvY6o9HYWFCWrnYmHggxztiCskb7q5IDh7gtyJ
   TfkXUe7qyEoZA9tPyMe0+Vo8deTemkdj2f0JY8AUxTTLxIlvC4Xm/DAur
   MxV0hKVUnO/CceQNIOPXpo2C8AfEmHAPU+O6P4HjwprhT1cHDGhGEcd1p
   aCfJsdUHA7yDkHAasbZ5HWK7v2Dzq/00xgyPyPLCwj+Z2Q/CbBS1XQLua
   wSuegjbDhX+Bf4fH4Qbo5wzM7YhL2E3gEEWQYN0+reCXZCfQ9c8Mi1gLb
   UMKOCarzmnt1oSpn5LWQ5DQeVMpy9Gq0J3IJbmpK6hQnL4ku6GSDCzwSV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10144689"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="10144689"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 22:25:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="30131428"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 22:25:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 22:25:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 22:25:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 22:25:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 22:25:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QohW5xevU2fVH7kjVfkndf1ho3kdbrclFb206XIJln2Cw7xzU+9BvVrbCUROYWTEx6WMl45vvQM+lZUjl0PEDdGL7aA1uaZPgcHUkZnk3CxHCMPTQSNdgzXkqKLB4jbO673T/iQJfTugn9jPWJlRIOOFb49kAvaRIsLnod1TZH+BtszoMLIh7PUQgK5lxn4EztuoAIEQDp4w+50GqhFC8i49VgBKiaXlD6F8ePCYgnNzfcU0T6OY+IxhTb5P6WBbVQY/MU1KqfcTvfyt2y0uxFoGTyP35VQYbhFBEn5IXwGPu+255TPfAfmhXpxU8D/HT0U8+P27j6TQ1iKNgihf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHlMTNgj3UpZa5TeixY/V3ZcawHR7QuRhdBaoXlON9E=;
 b=j7cymBDt0cNeZ92uNHDWHNasSqX7vYCfIoCGypUW7ASGZ6iRGCPYzaa/IgxwQOGK/WhgkS0rA2BTa+dHHLa5lozYoogYAduc4zoOecB16vWSeS5e9MSyDNYO7wvc19JV0AwM1eBQhEnDP/wJik+m4BZ+5JjkdQwyQyLwRVYpF1yvY1b+HtB/PNDQpyjsZDTC6SDHWwwUwR/a+sCTcwRazrBeaViv+J+06d7g+yPaZymaWjRQvwXmSDCK9N4D9rndiitO7t/F22l9U77e6Qew8J5XikP5HiNd+bab9v2lFD5EWy2bwZM1sfdTntAqZ8mA96rnW9RbC7mdv1D6hUl0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6703.namprd11.prod.outlook.com (2603:10b6:806:268::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Wed, 31 Jan
 2024 06:25:45 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 06:25:45 +0000
Date: Tue, 30 Jan 2024 22:25:42 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang
	<zhi.wang.linux@gmail.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, David Matlack
	<dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <65b9e7e66e46_5a9dd294ae@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
 <20230325104306.00004585@gmail.com>
 <20230329231722.GA1108448@ls.amr.corp.intel.com>
 <20230331001803.GE1112017@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230331001803.GE1112017@ls.amr.corp.intel.com>
X-ClientProxiedBy: MW4PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:303:83::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6703:EE_
X-MS-Office365-Filtering-Correlation-Id: b10f3de1-c9cc-4a25-0532-08dc222574ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlyUbfhq441Wmlj55UHp2JONAocHoyULHzjVOww3uFCnLCLvPXv47pJBTIlZSTC2I+xb3q4ALmXE8TVGmHKelcv7yKxawfQd/+yWbvA/P5WzdLTgiYlxEYUQDzqq8xx3UkO/tryFRe0JQUfSiZzt+dS4GsihIcvRbzcY9oa71vMSHul/HzuEENblBLArHp7t2/jat4iHwkCPCF/VkQw3bYYA9s52HpaQ8FYzUUs5/Y1O/65jrfKs7hB0BAEpdxsGH7hPtRTGs9thiymQNoQsA3EFX7kmiooltKcSIJI7vM+0etzCUTaWEptYKYF6EAsa0uA1j+25lDj8j9XG0Ypij5sJ2/+4+JF7cqBlRliRo/itdhR2qjGN6rpgEbQV1pX3TOh3vzZPVn3GE5BfNs6RkqzgCMiSmtUn9zNdpkgvM5Tg7qNtd1nCFg3SAHAQW2TJ/S6DS14Klt3+URux4XvIVODs4Cwc47aG+bAbBrKy57vwMRa1kO35XTeW/DKpbDUAW1RIVK9kWBN9Sh3olY7WGgAmDk2SuM8bZPd4NEwTvO92C7nrrBxgANv+OzlisO8lq4BJR7adMCEpG9ckj/tA8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(66899024)(41300700001)(83380400001)(86362001)(82960400001)(107886003)(26005)(38100700002)(9686003)(6512007)(6486002)(966005)(53546011)(6506007)(30864003)(2906002)(478600001)(110136005)(316002)(6666004)(66946007)(66556008)(66476007)(54906003)(8676002)(4326008)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ebgtSy7xHmaBrDu9fVr+1Sn/kRxX8j87NU2YLRjBmukQgAWqV0vlBiv1+92Q?=
 =?us-ascii?Q?78rhQQaTQHPeNVnza3IRfEMMlxjHv6G7x/J9yDhB9lkGd+A0XKdKF5jZuTGO?=
 =?us-ascii?Q?srXTBUMhx5AqBWGZNeKyxAagycRdqDz9reaggY24TooiGN93hFH6kg8aL29R?=
 =?us-ascii?Q?uKTnhrJfBCFg3N83ci2Spxxi9Sg1WCCsEYF3lHa4kxdyUR21TfeAFvKT2c5k?=
 =?us-ascii?Q?o2WSpRxbGflriB6+OeE6Pivq/NS6aNFqyGjrPAJPOf90jRsfj/aCBfBqR27j?=
 =?us-ascii?Q?OheLpeS4c+pfFXPqid4WpYX/vyRMF6tQSVNGm84MUGPTLPSdcMkrlO+AF6yw?=
 =?us-ascii?Q?Pnjwe3XGIPijogDXVftabYaADc+latTCu8ZWwhsw9Vk+Spbn8x9baEk+8+aN?=
 =?us-ascii?Q?A0L/Ftr6eS6tX8c+SS9R9ajK1mJmoJYR4jJcT1l0SBHKKa65OZ7SPMs3w/YB?=
 =?us-ascii?Q?RTE0U1IRthV2WGlJxGEYoRP56BxmQtKj2KYuZ7G5306h73sb8Fd9TAW4NSWE?=
 =?us-ascii?Q?dQbOcJjSQ0CnWzQA43hHJShLQD/0w9+JcN7vJMMVmHw0tau+QJIF0aveSYvS?=
 =?us-ascii?Q?BBFoKzXUH3bEnLXZDPhtAF2w2cQWTYRcFcGDN/wvnvjeAFAAiBYiIIoN9Hhc?=
 =?us-ascii?Q?cUnTR6Cc8tviBXGW7/gQBNxQZaGl6JPK+FsOhLd4v+aG7jJOEvEexyfCI3Bl?=
 =?us-ascii?Q?QLXrMz5ZUbV7A+TPQB/PQxRG/+8ZSWoehFA4sQCiCzTuaH8IsJARH+/JxqMV?=
 =?us-ascii?Q?wbZojBmHPnnKCAgrbDpgVrt2zwhzgI0Gfu9fqvQNG/BrP3fai58hCAe30moy?=
 =?us-ascii?Q?GUhS+LxUlqlk9uom1Cb1D6QSUawbqNpYUC2A8ahJf/5B1eviJ6RkL15BDZVg?=
 =?us-ascii?Q?/J8aZUbJSSaGQ972L6AqRN5WWkMghhk+6y6cZI07vO0LZ32FJ6PwqG/PLaiw?=
 =?us-ascii?Q?JYPj+M2826RpQsotZGi/dMKCvS4dTSKJjIEJcDrJPQR1xwmyprazy4UnR4cm?=
 =?us-ascii?Q?Mto+0LEf7rppLQso9Ut4dlK91N+LWq+zXSas/xV7eayR3tafV8178xpPCLLY?=
 =?us-ascii?Q?WtteKhapnFkOAfJ/wfECU4KpKsC/8G2dxKvGqFoa2SK+VjK/XhdADpi4mLxt?=
 =?us-ascii?Q?ohtA6vXmm+gaiDY0RSQLKDAqvhsY1tJrTjVOGkgAYTNuPM3g/36FORwwBhgU?=
 =?us-ascii?Q?M99JWk6XmOKkPAjL/nvQKvOzKnMAL5EpSM7iV+bUKmfuMTI0kb/fmZPLJVkt?=
 =?us-ascii?Q?5pHZttAa63JW2VVDi0v6hlvLRLDRlZq6CgtKW8UQ4DpUTDLbk2MTSJ/bVdL5?=
 =?us-ascii?Q?yz3A1U2nqHiU6s/aX2VIj5msdIYll+RE33UhURr4ZDS6XREoNGRBs+kTyjlc?=
 =?us-ascii?Q?VFOD0uBozU0UOepAO4M0qo8homZ45fKVQIl/Uifh9ZrzIYgVoIyZLVPQGEmr?=
 =?us-ascii?Q?jLNVkC2Y/PTQ1fukUmnfvXjy+0cmvu91YmKFQ1QIjtkmeSCLsMxEcXt+u67d?=
 =?us-ascii?Q?ebsiAGJ2dz4+oCN4s/GM0el1B0cMmN5byNj17rbKeeDRlvK94UXQCYHL0uqa?=
 =?us-ascii?Q?STeTJTOmPCqpBS9Ynj7HhUwMnq6A3G8j49sX2qGja3IJamSTUkepIXu7rrDf?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b10f3de1-c9cc-4a25-0532-08dc222574ad
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 06:25:44.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYUQsZb8L587sPAcksrh0ya4Rhtb9ZyislSpKSIQU1gvZcr7Np10CrERZrWXDPbnLjc3p/Y5JhQmbmaIHZleFdpukqaoCRzNsdJoAc9Qjbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6703
X-OriginatorOrg: intel.com

Isaku Yamahata wrote:
> On Wed, Mar 29, 2023 at 04:17:22PM -0700,
> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> 
> > On Sat, Mar 25, 2023 at 10:43:06AM +0200,
> > Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> > 
> > > On Sun, 12 Mar 2023 10:55:40 -0700
> > > isaku.yamahata@intel.com wrote:
> > > 
> > > Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
> > > does not use it at all and all the system-scoped ioctl of SNP going through
> > > the CCP driver. So getting system-scope information of TDX/SNP will end up
> > > differently.
> > > 
> > > Any thought, Sean? Moving getting SNP system-wide information to
> > > KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
> > > CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?
> > 
> > We only need global parameters of the TDX module, and we don't interact with TDX
> > module at this point.  One alternative is to export those parameters via sysfs.
> > Also the existence of the sysfs node indicates that the TDX module is
> > loaded(initialized?) or not in addition to boot log.  Thus we can drop system
> > scope one.
> > What do you think?
> > 
> > Regarding to other TDX KVM specific ioctls (KVM_TDX_INIT_VM, KVM_TDX_INIT_VCPU,
> > KVM_TDX_INIT_MEM_REGION, and KVM_TDX_FINALIZE_VM), they are specific to KVM.  So
> > I don't think it can be split out to independent driver.
> 
> Here is the patch to export those info via sysfs.
> 
> From e0744e506eb92e47d8317e489945a3ba804edfa7 Mon Sep 17 00:00:00 2001
> Message-Id: <e0744e506eb92e47d8317e489945a3ba804edfa7.1680221730.git.isaku.yamahata@intel.com>
> In-Reply-To: <8e0bc0e8e5d435f54f10c7642a862629ef2acb89.1680221729.git.isaku.yamahata@intel.com>
> References: <8e0bc0e8e5d435f54f10c7642a862629ef2acb89.1680221729.git.isaku.yamahata@intel.com>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> Date: Thu, 30 Mar 2023 00:05:03 -0700
> Subject: [PATCH] x86/virt/tdx: Export TD config params of TDX module via sysfs
> 
> TDX module has parameters for VMM to configure TD.  User space VMM, e.g.
> qemu, needs to know it. Export them to user space via sysfs.
> 
> TDX 1.0 provides TDH.SYS.INFO to provide system information in
> TDSYSINFO_STRUCT.  Its future extensibility is limited because of its
> struct.  From TDX 1.5, TDH.SYS.RD(metadata field_id) to read the info
> specified by field id.  So instead of exporting TDSYSINFO_STRUCT, adapt
> metadata way to export those system information.

Hi, I came across tdx_sysfs_init() recently and had some comments if
this proposal is going to move forward:

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-firmware-tdx |  23 +++
>  arch/x86/include/asm/tdx.h                   |  33 ++++
>  arch/x86/virt/vmx/tdx/tdx.c                  | 164 +++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h                  |  18 ++
>  4 files changed, 238 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-tdx
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-tdx b/Documentation/ABI/testing/sysfs-firmware-tdx
> new file mode 100644
> index 000000000000..1f26fb178144
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-tdx
> @@ -0,0 +1,23 @@
> +What:           /sys/firmware/tdx/tdx_module/metadata

The TDX module is not "platform firmware" in comparison to the other EFI
and ACPI inhabitants in /sys/firmware. It is especially not static
platform firmware given it needs to be dynamically activated via KVM
module initialization.

Instead, sysfs already has a location for pure software construct
objects to host a sysfs ABI and that is /sys/bus/virtual. I propose a
common "TSM" class device here [1] and TDX can simply publish a named
attribute group, "host", to extend that class device with TDX specifics.

For cross-vendor consistency "host" is a symlink to the CCP device on
AMD.

[1]: http://lore.kernel.org/r/170660662589.224441.11503798303914595072.stgit@dwillia2-xfh.jf.intel.com

> +Date:           March 2023
> +KernelVersion:  6.3
> +Contact:        Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
> +Users:          qemu, libvirt
> +Description:
> +                The TDX feature requires a firmware that is known as the TDX
> +                module.  The TDX module exposes its metadata in the following
> +                read-only files.  The information corresponds to the TDX global
> +                metadata specified by 64bit field id.
> +                string in lower case.  The value is binary.
> +                User space VMM like qemu needs refer to them to determine what
> +                parameters are needed or allowed to configure guest TDs.
> +
> +                ================== ============================================
> +                1900000300000000   ATTRIBUTES_FIXED0
> +                1900000300000001   ATTRIBUTES_FIXED1
> +                1900000300000002   XFAM_FIXED0
> +                1900000300000003   XFAM_FIXED1
> +                9900000100000004   NUM_CPUID_CONFIG
> +                9900000300000400   CPUID_LEAVES
> +                9900000300000500   CPUID_VALUES
> +                ================== ============================================

This documentation needs to be per file. With an explanation of how each
file is expected to be used. Someone should reasonably be able to read
this documentation and go write a tool, I don't get that from this
documentation.

> \ No newline at end of file
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 05870e5ed131..c650ac22a916 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -110,6 +110,39 @@ struct tdx_cpuid_config {
>  	u32	edx;
>  } __packed;
>  
> +struct tdx_cpuid_config_leaf {
> +	u32	leaf;
> +	u32	sub_leaf;
> +} __packed;
> +static_assert(offsetof(struct tdx_cpuid_config, leaf) ==
> +	      offsetof(struct tdx_cpuid_config_leaf, leaf));
> +static_assert(offsetof(struct tdx_cpuid_config, sub_leaf) ==
> +	      offsetof(struct tdx_cpuid_config_leaf, sub_leaf));
> +static_assert(offsetofend(struct tdx_cpuid_config, sub_leaf) ==
> +	      sizeof(struct tdx_cpuid_config_leaf));
> +
> +struct tdx_cpuid_config_value {
> +	u32	eax;
> +	u32	ebx;
> +	u32	ecx;
> +	u32	edx;
> +} __packed;
> +static_assert(offsetof(struct tdx_cpuid_config, eax) -
> +	      offsetof(struct tdx_cpuid_config, eax) ==
> +	      offsetof(struct tdx_cpuid_config_value, eax));
> +static_assert(offsetof(struct tdx_cpuid_config, ebx) -
> +	      offsetof(struct tdx_cpuid_config, eax) ==
> +	      offsetof(struct tdx_cpuid_config_value, ebx));
> +static_assert(offsetof(struct tdx_cpuid_config, ecx) -
> +	      offsetof(struct tdx_cpuid_config, eax) ==
> +	      offsetof(struct tdx_cpuid_config_value, ecx));
> +static_assert(offsetof(struct tdx_cpuid_config, edx) -
> +	      offsetof(struct tdx_cpuid_config, eax) ==
> +	      offsetof(struct tdx_cpuid_config_value, edx));
> +static_assert(offsetofend(struct tdx_cpuid_config, edx) -
> +	      offsetof(struct tdx_cpuid_config, eax) ==
> +	      sizeof(struct tdx_cpuid_config_value));
> +
>  #define TDSYSINFO_STRUCT_SIZE		1024
>  #define TDSYSINFO_STRUCT_ALIGNMENT	1024
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f9f9c1b76501..56ca520d67d6 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -33,6 +33,12 @@
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> +#ifdef CONFIG_SYSFS
> +static int tdx_sysfs_init(void);
> +#else
> +static inline int tdx_sysfs_init(void) { return 0;}
> +#endif
> +
>  u32 tdx_global_keyid __ro_after_init;
>  EXPORT_SYMBOL_GPL(tdx_global_keyid);
>  static u32 tdx_guest_keyid_start __ro_after_init;
> @@ -399,6 +405,10 @@ static int __tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
>  	if (ret)
>  		return ret;
>  
> +	ret = tdx_sysfs_init();
> +	if (ret)
> +		return ret;
> +
>  	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
>  		sysinfo->attributes,	sysinfo->vendor_id,
>  		sysinfo->major_version, sysinfo->minor_version,
> @@ -1367,3 +1377,157 @@ int tdx_enable(void)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(tdx_enable);
> +
> +#ifdef CONFIG_SYSFS
> +
> +static struct kobject *tdx_kobj;
> +static struct kobject *tdx_module_kobj;
> +static struct kobject *tdx_metadata_kobj;
> +
> +#define TDX_METADATA_ATTR(_name, field_id_name, _size)		\
> +static struct bin_attribute tdx_metadata_ ## _name = {		\
> +	.attr = {						\
> +		.name = field_id_name,				\
> +		.mode = 0444,					\
> +	},							\
> +	.size = _size,						\
> +	.read = tdx_metadata_ ## _name ## _show,		\
> +}
> +
> +#define TDX_METADATA_ATTR_SHOW(_name, field_id_name)					\
> +static ssize_t tdx_metadata_ ## _name ## _show(struct file *filp, struct kobject *kobj,	\
> +					       struct bin_attribute *bin_attr,		\
> +					       char *buf, loff_t offset, size_t count)	\
> +{											\
> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);			\
> +											\
> +	return memory_read_from_buffer(buf, count, &offset,				\
> +				       &sysinfo->_name,					\
> +				       sizeof(sysinfo->_name));				\
> +}											\
> +TDX_METADATA_ATTR(_name, field_id_name, sizeof_field(struct tdsysinfo_struct, _name))
> +
> +TDX_METADATA_ATTR_SHOW(attributes_fixed0, TDX_METADATA_ATTRIBUTES_FIXED0_NAME);
> +TDX_METADATA_ATTR_SHOW(attributes_fixed1, TDX_METADATA_ATTRIBUTES_FIXED1_NAME);
> +TDX_METADATA_ATTR_SHOW(xfam_fixed0, TDX_METADATA_XFAM_FIXED0_NAME);
> +TDX_METADATA_ATTR_SHOW(xfam_fixed1, TDX_METADATA_XFAM_FIXED1_NAME);
> +
> +static ssize_t tdx_metadata_num_cpuid_config_show(struct file *filp, struct kobject *kobj,
> +						  struct bin_attribute *bin_attr,
> +						  char *buf, loff_t offset, size_t count)
> +{
> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	/*
> +	 * Although tdsysinfo_struct.num_cpuid_config is defined as u32 for
> +	 * alignment, TDX 1.5 defines metadata NUM_CONFIG_CPUID as u16.
> +	 */
> +	u16 tmp = (u16)sysinfo->num_cpuid_config;
> +
> +	WARN_ON_ONCE(tmp != sysinfo->num_cpuid_config);

Why crash the kernel here?

> +	return memory_read_from_buffer(buf, count, &offset, &tmp, sizeof(tmp));
> +}
> +TDX_METADATA_ATTR(num_cpuid_config, TDX_METADATA_NUM_CPUID_CONFIG_NAME, sizeof(u16));
> +
> +static ssize_t tdx_metadata_cpuid_leaves_show(struct file *filp, struct kobject *kobj,
> +					      struct bin_attribute *bin_attr, char *buf,
> +					      loff_t offset, size_t count)
> +{
> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	ssize_t r;
> +	struct tdx_cpuid_config_leaf *tmp;
> +	u32 i;
> +
> +	tmp = kmalloc(bin_attr->size, GFP_KERNEL);
> +	if (!tmp)
> +		return -ENOMEM;

Why is this allocating and then blindly copying bin_attr->size into
@buf? It it either knows that @buf is big enough, no need to allocate,
or if it does not know if @buf is big enough then the copy into @tmp
offers no protection.

> +
> +	for (i = 0; i < sysinfo->num_cpuid_config; i++) {
> +		struct tdx_cpuid_config *c = &sysinfo->cpuid_configs[i];
> +		struct tdx_cpuid_config_leaf *leaf = (struct tdx_cpuid_config_leaf *)c;
> +
> +		memcpy(tmp + i, leaf, sizeof(*leaf));
> +	}
> +
> +	r = memory_read_from_buffer(buf, count, &offset, tmp, bin_attr->size);
> +	kfree(tmp);
> +	return r;
> +}
> +
> +TDX_METADATA_ATTR(cpuid_leaves, TDX_METADATA_CPUID_LEAVES_NAME, 0);
> +
> +static ssize_t tdx_metadata_cpuid_values_show(struct file *filp, struct kobject *kobj,
> +					      struct bin_attribute *bin_attr, char *buf,
> +					      loff_t offset, size_t count)
> +{
> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	struct tdx_cpuid_config_value *tmp;
> +	ssize_t r;
> +	u32 i;
> +
> +	tmp = kmalloc(bin_attr->size, GFP_KERNEL);
> +	if (!tmp)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < sysinfo->num_cpuid_config; i++) {
> +		struct tdx_cpuid_config *c = &sysinfo->cpuid_configs[i];
> +		struct tdx_cpuid_config_value *value = (struct tdx_cpuid_config_value *)&c->eax;
> +
> +		memcpy(tmp + i, value, sizeof(*value));
> +	}
> +
> +	r = memory_read_from_buffer(buf, count, &offset, tmp, bin_attr->size);
> +	kfree(tmp);
> +	return r;
> +}
> +
> +TDX_METADATA_ATTR(cpuid_values, TDX_METADATA_CPUID_VALUES_NAME, 0);
> +
> +static struct bin_attribute *tdx_metadata_attrs[] = {
> +	&tdx_metadata_attributes_fixed0,
> +	&tdx_metadata_attributes_fixed1,
> +	&tdx_metadata_xfam_fixed0,
> +	&tdx_metadata_xfam_fixed1,
> +	&tdx_metadata_num_cpuid_config,
> +	&tdx_metadata_cpuid_leaves,
> +	&tdx_metadata_cpuid_values,
> +	NULL,
> +};
> +
> +static const struct attribute_group tdx_metadata_attr_group = {
> +	.bin_attrs = tdx_metadata_attrs,
> +};
> +
> +static int tdx_sysfs_init(void)
> +{
> +	struct tdsysinfo_struct *sysinfo;
> +	int ret;
> +
> +	tdx_kobj = kobject_create_and_add("tdx", firmware_kobj);
> +	if (!tdx_kobj) {
> +		pr_err("kobject_create_and_add tdx failed\n");
> +		return -EINVAL;
> +	}

Subsystems, PCI for example [2], are slowly unwinding their usage of dynamic
sysfs_create_*() APIs in favor of static attribute groups. Dynamic
kobject_create_*() usage is even more of an anti-pattern for new code.

This goes away with static attribute group registration.

[2]: https://lore.kernel.org/linux-pci/20231019200110.GA1410324@bhelgaas/

