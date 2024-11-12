Return-Path: <kvm+bounces-31547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1657D9C4B16
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5288EB307FF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 00:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9071F819E;
	Tue, 12 Nov 2024 00:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CIZrrNty"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA55E1F8191;
	Tue, 12 Nov 2024 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731371655; cv=fail; b=r2HCWkx1iYXhCrfJSu3XE0wl6xJcSmA+2LwojbuJH0MtvHySTMMmaS50v5hylnCKsoO1yXcIqcSqJqGEo6ODLaBOEhaHC8YCs+svGEyEUkf0UppS9VgCDNrrvB81GSxtakwoCRHw4PerCEyRscJxCuNWmULy/C90lYVKy1WZEbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731371655; c=relaxed/simple;
	bh=V9Wnfs0t6vvrZ8fLnw/+XBjJdacP8yjs9aRBvBVu2vo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rwX3W62BGT+Sy91h+4PbRgRFmo+00jXjUOHRikj8Y5MWLeqEhi6UHCS+8l1tzONmvDesP5rG05c41xYjBzObUE7M5byddSIeTb64Bgsja4+A3BtxO24iiMBt2b38kfCbSs5gvmdQNfo+3RMZYyh4ztWjV9+I4+WhnpGhwHrGS4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CIZrrNty; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731371653; x=1762907653;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V9Wnfs0t6vvrZ8fLnw/+XBjJdacP8yjs9aRBvBVu2vo=;
  b=CIZrrNty3YNyPXe2dgUzA4Su4bjsVCbFwMvCjsENs1rt2WXNybg7B+Eq
   +1D4SlB/BkFkhTSRfPvjWMeaz/K55v7rNhLz6k2xB711ymCME3cBLZhmB
   ngZs0xwc+HDRMi/0HsX0R8+sok+8G/ZHqgrh10xG1twKihWw30OfMYLi9
   p5Hbyv3Dj0YPqy5IPzxVVrxehDeuIzmEknAxnowIkp3vVE+v/hlErnHcp
   TXEg5bDu5/pxtv92SRkM83JNJrYci45O/ggyj7voNypJydF9ieB3VKh/6
   xvuxEhLAaELrzTvLle9DUUgTsZR750U4AvnzLCFpWNgWzEC2+N1nRCdR5
   A==;
X-CSE-ConnectionGUID: Rq+sMiQHTNWDfdOAavHWGQ==
X-CSE-MsgGUID: /2ilLR6ATj24ufC+Nqyp+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="18806279"
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="18806279"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 16:34:11 -0800
X-CSE-ConnectionGUID: FUC0GOV4T6m8btbdh8/Z7w==
X-CSE-MsgGUID: CmZhyR7LSQyCAOSQNSNp0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="86737894"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 16:33:59 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 16:33:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 16:33:59 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 16:33:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnR0hz4jaqe+UoycvTWmfhGpCo62x/PaPGRSwT7blGG7s+1CLw58IUuQmqEfSYcgcVtfUYKwNozx9aqbdVRtT/E6aJBnKI/fNtwnCDnrI6E2JAafLGFpzogPnGy+pDEa7xsWUzjUuEIqLHjpFogbJY450WbGlKWo9xXmTh3tIL0H7GB/KfkGC+OHm/WZkkQ7+UMiDicrgH7kcEH65xzHJUkQl17DS+mox2XfFeHuRVLhD998L4NTqxIcPw7ix9CaM7bHWWbP3jpZxRkENWO7ZBCu0lyzVNCLBAPL9YdTqa6g1cXXRN/sCEqR+h0euLUA73KT6CVlIIFe6ljT1xrAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFBI/tf4DCZT7TE/M3fR3F4AelnTPtDICjm9VGW2gfc=;
 b=R4F/XEz/J8TLrv90TdEYKcFC7CbVK+87j1t3YGRgSB3Y38HzrIm0F8/n6OaRVjG2AvxL2wPf6/fBaTfQuwzse+vQwU7gAzI7T4uPktU2mzfr06qbr6mkIxLkBp5UQII1FjLYYIQaiARa6l5BTExFIf8LfhkRd3ICYWruTvJCY8zfiFkRQJcHrFgPgbnJyfdJj/usk46SX5Ium4AssTlobszuLL+wm9z9ahriWpaW+g0wkI6cWfNurPQPAqTyXj6FkoUI7xflsf1DVe3we2Wd3TINzp9JBt13A+Yy4UV1hq1LBrI7oxKInu1QpLmvHWNyNSm82ivR15O9dnzbki7qxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA2PR11MB5017.namprd11.prod.outlook.com (2603:10b6:806:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 00:33:56 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 00:33:56 +0000
Date: Tue, 12 Nov 2024 08:33:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Weijiang Yang
	<weijiang.yang@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Message-ID: <ZzKiapQZgn0RscrC@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <ZjLP8jLWGOWnNnau@google.com>
 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
 <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
 <ZyuaE9ye3J56foBf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZyuaE9ye3J56foBf@google.com>
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA2PR11MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: f6445d77-5100-425a-7e9c-08dd02b1b109
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kkwY1e73mDsetiND7wl89reI2lMmPED8lnUmiRzNNYQJm5ujAX4f8VsBHU7J?=
 =?us-ascii?Q?3Xvwm8t2PWsFnx/do5byUkAIp/6yjYR0Tmdl5x42B9k1Ngmpkahkyu+R7ibm?=
 =?us-ascii?Q?YXW0YCPQorVc5ttuSg/XB/EtmlUFh8YTg4I4M7NC/MSlDdrEoBh17N0hsDaj?=
 =?us-ascii?Q?PYY5XA1X2hkRNLBd8+Ro+dZxd/jZbR643iTlz+CvhWSsR7MEH/5Fqtj0gi7x?=
 =?us-ascii?Q?oPTcOGo+PYmriFD3NUzWQtWe3bMTKdUvkwM5G144DHcVIJjH3sWsWc+Rd64y?=
 =?us-ascii?Q?oPh3pifTEdMXVNtMl59+ol73Sz3JabT38v1U4Cqhpf/GV+CBmvzP2jKrV2EE?=
 =?us-ascii?Q?T4a/iDpJpVqvFHIwJNkihmtpgiZfP0D+MNdVMXaVltEpq4RBse7Fwgn4zsKU?=
 =?us-ascii?Q?gVQ0YOvIomn2/CElO34YHKWBje8eHBRGL7djGcQ4IiiPYAbpjIshXlOXI6GM?=
 =?us-ascii?Q?APIz8Qh1AGSTkfZev3Cf5HqnbL8yZA1fVyMTpfwCp2G/cZJK03koPXDd6fUh?=
 =?us-ascii?Q?hy52qLdEhqJY9He4q6D5yohv820A3ly83oxVofeUDaLM8IXWQmCC7dK1VDP/?=
 =?us-ascii?Q?MOzoEtmLc75NZ34qGJ/vC1xlTVauvvgP1zxU1a0s0ECC/gMh9RGoso2miqsl?=
 =?us-ascii?Q?VZwSlJpuTK2IrrjonRNHVLGkQdbCm19Ohudm+pEHoXyH/US8pp5yAvTUqXqR?=
 =?us-ascii?Q?wjdgdUF+mBz9AwhOdGabtKOl2PakkeGJ6Nmu1IiA90FDF1wfTTBDdT0mS9zq?=
 =?us-ascii?Q?fxHcMH3zdp5xm7xZGETlxH5oETxI96SpuokL+bRqq8xb7XY7X79rdqADGscS?=
 =?us-ascii?Q?ECtF+6lBaXnEP0pduh40fiFNKVo7r0nsIOoTL09EyzgSae/II/SjdeU8CZVb?=
 =?us-ascii?Q?3O9LwEoHcQ3QlAPoU7HggMdoexwMfr9HENuyPWkCXI8oKmfc4JU8xicLp6yn?=
 =?us-ascii?Q?ifXeqeNR4brkYvp+zL8+ZZlRpyo1mDzOCjymgefVEwn8G0i3Xdl7FFDp5kEo?=
 =?us-ascii?Q?k+kthpF0nTSRY55VDs/ubUMZyZXYL+v0C3KdsauwqJ7wK5uQ/JFu/V+6Xvyd?=
 =?us-ascii?Q?9d3SMsXJ8Os2dcQtfekWLWUnCLTGj5LHkpcSJz5XYenTJd1ibmbY8EYZOR0y?=
 =?us-ascii?Q?pIOvJpYORB97H5nUvPkIHzMLyXmN+/9dHC1Rqaw4FhUEfihNKUtZAMc+dxdE?=
 =?us-ascii?Q?rbYUeKinJ8oHD+1VOyR5/RBJ/aFesNGs+hxvB6l5Z4pEzq60DZ6aNmocXFjZ?=
 =?us-ascii?Q?kgP1zSQwAAs819XAfb62nzA/stPcXwe2iavOOUQSHQmtSbhqzCSfaDaMKBet?=
 =?us-ascii?Q?biEGs5CGK70ju4uOH0oAHLSl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8vcKVCXVWVcbpcZ/c/DN/9TnejekU4wN6bfmIdU3Rt3jTa2L6yzv66dclGFd?=
 =?us-ascii?Q?Bd0S4XS8pNxqmVjY1Il6Lay7zXo2hsrMQ2lSvYMawrSmyjy5mJ0z75q7grNx?=
 =?us-ascii?Q?63IQRtawTu4ggCNpYjOpgHUK3od538fgGN4F0xHwrcWJ56BVF/k8p4ZNm1lk?=
 =?us-ascii?Q?hoEjOhPphGeanne2UbYP1INpP9hBEjQpwd9A1LXF0wavVO7vZpWUt1tzpBwm?=
 =?us-ascii?Q?y3R3zkYCCBpIel2VykOH1M1OSsWbQ9O9l2sa5KL9/DSPajo6QH2s3EqRL4kI?=
 =?us-ascii?Q?ihB3zHD6dDtdJ7eUGkYi+WsStz9m8PjW9/dpFs9nW28Ic5YDpU7WpoWjxBpI?=
 =?us-ascii?Q?9SXU0g+JSN767NNocY7qZ6E35zBoV+Je3nHwk/xWnT0L0jpFL2ApEvoqn2dO?=
 =?us-ascii?Q?p/kz/L8pi5PpUI+WcjqnikLhrNiaQDslcLFuBwjlgo1R7duS3tC1lRHxtpM7?=
 =?us-ascii?Q?231cHhRDFbFqnFkr5Y3YJVRMrtR9GIkbNpRLlLmOhftTVFSK9gbu672GbSvA?=
 =?us-ascii?Q?GqsjQ2WlZ27LGWrvS/tPfOI76pl0rV+jXNyJh19B4KpPBrthZkQBso+SutOD?=
 =?us-ascii?Q?8OPZUBHk55daHVjHrgrP9SF0c7UKqjpz05u0P7R/9Mev8frE6FKB1zX+xBWK?=
 =?us-ascii?Q?dlwmkZyWzHptiRJMaBfQNuJsMEiZiRmtJ21h6oXLd0skr2sYG6ZpCF4A4409?=
 =?us-ascii?Q?3JxqOtOfEhYmEjpC5t6BWUyeJmTcvhejF90iABwkHfo7W73+ApjjCyJH0qjj?=
 =?us-ascii?Q?bFXYbD0kKy4Riwgkm4SuGRQszXuGvhx36PxcY4Glvi/r9jdSDhy7GaUYAZ1c?=
 =?us-ascii?Q?4TsGD6Uu9i4HnHPeH8xs8/t2xcYI6kVKG9va/rj+Hz3+g3jtHr2dVCCAFXIL?=
 =?us-ascii?Q?kMR/GftlwYl8Tt+iOu5P3fHN2tN/EfD0OCspl6gtce8tnhoWisq7WS6UnkzV?=
 =?us-ascii?Q?QAZMuaIVmdLz8ppS8Jm30slcwgQAaB4smEdqa+Qu+A54Y1bywe18ylX4Ai/F?=
 =?us-ascii?Q?C9qIe/3l5iwQePYUBv18meBCkybF5CP9w8F/Q6kQArKeFROUysSVnv5nMnN+?=
 =?us-ascii?Q?fQButTBondJYGgfW7T4BMz2k72IjQJ4C6yZ8Jm5XYmkrSC14piYSIf5DoMhB?=
 =?us-ascii?Q?7Kz8fs/ZvgSLbsktnonaAGcqKzDKmPlrmPxHpnwbkIrFcgecGtNLhofa9PbY?=
 =?us-ascii?Q?h//5VXCVNZu1xdGkBvR02uqS0kUFqISRhgqxy4KblawYBsxv/D+C7p1ejRVO?=
 =?us-ascii?Q?j9HYdS3jExtepV3m9ibHt4iyr2GFhIXh8Er2bexyQoTZ/oa1Pt7oF0rQARIT?=
 =?us-ascii?Q?86HLmZ1shjaSUON2uWvs53WACiII603Wl3bCL9Qe+coWlnsFzTzPxqFxWVD+?=
 =?us-ascii?Q?y48Yq7qWcnlxRKHkovZDc1HwZiARkCY3vUdL5YsrOTiO4q3lfhPaCx2/aFBk?=
 =?us-ascii?Q?tLeja3EeY8La5yTEa88gefur7MLbvNPOUO8Jk7Z9ADT/V1TEcD92dIwxHyhU?=
 =?us-ascii?Q?SCmcAraXY3+Zgq9jUJrcCNmYEmRHKc7UhyDmGCqMwsfzvQpH7880C0/eNBkN?=
 =?us-ascii?Q?HDsWwzg3wj6t8pmkMDzoGJoVzh88qj75DGWQcqdn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6445d77-5100-425a-7e9c-08dd02b1b109
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 00:33:56.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9E1qOp8H0P9OHuvESmxtjmShEdnIpixz6vzF/3HAC7jG556YF68qhkiDEnLM1aXsx8PLQxcxunqBEd/wTekhWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5017
X-OriginatorOrg: intel.com

On Wed, Nov 06, 2024 at 08:32:19AM -0800, Sean Christopherson wrote:
>On Wed, Nov 06, 2024, Rick P Edgecombe wrote:
>> On Wed, 2024-11-06 at 09:45 +0800, Yang, Weijiang wrote:
>> > > > Appreciated for your review and comments!
>> > > It looks like this series is very close. Since this v10, there was some
>> > > discussion on the FPU part that seemed settled:
>> > > https://lore.kernel.org/lkml/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/
>> > 
>> > Hi, Rick,
>> > I have an internal branch to hold a v11 candidate for this series, which
>> > resolved Sean's comments
>> > for this v10, waiting for someone to take over and continue the upstream work.
>> > 
>> > > 
>> > > Then there was also some discussion on the synthetic MSR solution, which
>> > > seemed
>> > > prescriptive enough:
>> > > https://lore.kernel.org/kvm/20240509075423.156858-1-weijiang.yang@intel.com/
>> > > 
>> > > Weijiang, had you started a v2 on the synthetic MSR series? Where did you
>> > > get to
>> > > on incorporating the other small v10 feedback?
>> > 
>> > Yes, Sean's review feedback for v1 is also included in my above v11 candidate.
>> 
>> Nice, sounds like another version (which could be the last) is basically ready
>> to go. Please let me know if it gets stuck for lack of someone to take it over.
>
>Or me, if Intel can't conjure up the resource.  I have spent way, way too much
>time and effort on CET virtualization to let it die on the vine :-)

Just FYI, I will take it over; I plan to submit v11 after x86 fpu changes [*]
are settled.

[*]: https://lore.kernel.org/kvm/67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com/

