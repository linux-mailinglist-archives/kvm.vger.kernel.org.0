Return-Path: <kvm+bounces-30912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7959BE465
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3F6D1F239D7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C001DE2CD;
	Wed,  6 Nov 2024 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SOHKUoNn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11831173;
	Wed,  6 Nov 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730889493; cv=fail; b=agdm+TvgDue9RbXEeFbX5DzLzvMMYNEjHrjz7B5WZspqVIrHIFvA58lPi++SlgCcpbAOFGzAnsoTRs1ydLz5D+ADC03clU6dbn7q7a9TpkbJV107ydoLRQ90qnxZqXqsr7dgYBjRWDwiY3Kku43T5hF8jnNpTo6KCYcZ26/kI3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730889493; c=relaxed/simple;
	bh=q8nZKW2h8Nw9ldY0CIgVQQPh2O3V4RW113Drf9/OmT0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xi3lA2gMIMrMTPZXyr5iglE72DTBsTlrYuwsc5UdxTcgGbbXA8qYkL3aL8hAgzdWEkDHIsedDIk/meMWmID7f0MV/MJSHG75DSkodm8EvfIIaPWHXrAzfh/6zIi2sHGAOSvWcLlMU3umt9xv8Pm+Jok27ZnaYQVLkQ2GNLxTPSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SOHKUoNn; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730889491; x=1762425491;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q8nZKW2h8Nw9ldY0CIgVQQPh2O3V4RW113Drf9/OmT0=;
  b=SOHKUoNn0DWTjSQefYBVrtJr0X3CYdxwtzHfbIPLFBIWzPFKhF156DjD
   xgUEZR/FJlZeQp66+LzlxIUkwCic1Su0M7UhT0GmDH7jS9yHwrHzFV09+
   oeUk6EqOlyMunWc5Fuij6GNYjI6BrZzbMOsLHPMs7Wb7yqukKWSSgPQ+/
   5iDb8zJrN+hUrtQVsxVaqY5GrZG+GWR4NKTGoMPUJ6ZUNDI+6ArUJCxOm
   hxMO52tP6dU9FtRUE7neRGv+JdGR5qwwBSJP+4jBurY9VwI2iZlr5fSi2
   4WBDjVC3GtqVkzQ3isxOU9wj2qhObcRQk8mP0wdzE+FzefsI01NKgumts
   A==;
X-CSE-ConnectionGUID: +X+BVtBZSI6a8HX71TC94Q==
X-CSE-MsgGUID: 3xFm10DURy6NyFziSurL2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="18300426"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="18300426"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:38:10 -0800
X-CSE-ConnectionGUID: WLAnu0nGTBmUiHX8mFV3Ng==
X-CSE-MsgGUID: XHvOYWn0SUe8FSeCGVxaig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="121986459"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:38:10 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:38:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:38:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:38:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2PAliOiQd2TccL08uf6sDtFIBRDJvorkqPwIaiSKMlGrOj16q/aV5h2dfkdPDozErwD6OeOiVkanhdDt+ioyCBevBGcdX44shlqxJo2rFgadlq05Nvkhf8xU+KAmeMLj5NiD3HjFKSD34e7XLvEhXgTkgz7CKcecxhF5IU4SO0nCt3snGKNhL3yqnBeSsKOugI7oVnUuDfN496kkvPvGTcrTIVLWf0D/SjyVoJ0zF3sQfFkPyDO0Yogcmu0xIX0FU/xOxUry9bXtKrZmrQolwHEWf54C+I8z35jd/3l2HmabSK6mUJmCalzKfnVzGzxLbZwQOW8VAnE9gHChaRSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNrLBpfnE18aGT+uBRlCkR6lP7oCxXIwbgZPWRzV9U8=;
 b=pD3PKjDa8QBkvop5YnSXnOVppAzhjMNbibrIE70p8KThifX2pOZdGUUHEppVcPdDkhXVyzNyOaG0LtJI3vFdvQegjGWcgs2SE1VPTR0SsJLEuVByjQnnOO5z0KAVXtFZKQoFRLMuPwGTuaPVSaogTH/WnD57tY+rSdRRR2XzawckdBeydt7l36Z7NW0tyXa2mhUyB3akiXu054pqHKnVu2f2gTyHyy6TYDwSgM1+LNFLNSkhHFCbbQqoBXzoLvBYT3H8ZxT/Ed1HgieKtBLWcVTifyd+qt5qWYXx95gWPMvwINMtgE3GS5CPTu9/CUiHDeoIQDz5lbEvPZyMxQDd3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6753.namprd11.prod.outlook.com (2603:10b6:510:1c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 10:38:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 10:38:06 +0000
Date: Wed, 6 Nov 2024 18:37:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Yong He
	<zhuangel570@gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Unconditionally set irr_pending when
 updating APICv state
Message-ID: <ZytHAtKgixnZ/AOD@intel.com>
References: <20241106015135.2462147-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241106015135.2462147-1-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a72f66-baed-427a-471a-08dcfe4f196c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tiGO3pKdIseEBYzpN/56UJqCe7a/GN1rhaT+HrZhEvxzoUx42OJJhqipT5OD?=
 =?us-ascii?Q?H6prsMO40a0OX6L6pdS2WSH0ZRPg5LhSJ6Uq1zXQ4rnK++Q6fbKP98rQCAVf?=
 =?us-ascii?Q?dQH1fsdy4sm7kW7GgpUXkCeshwzkhB0VYl+B7T6+NpWX0K96dkfVKiYSGzlp?=
 =?us-ascii?Q?Mnyiv/pCUXCcc9H1+QCZH7pFtmRIABPQ13JXGxi4Abs8VNhJCpT7rXkK0LGO?=
 =?us-ascii?Q?4A1KnLvnl8LWdPqmyGPJn1Ubl1GM94FeAQ1gI8Rumv6elTJc70McfuYAtFK9?=
 =?us-ascii?Q?QXHBdN4K8XhE2ROCMaB0NApSGAfN82eSCf8+DdzjVRsBz4WpgotiP1YYgM4/?=
 =?us-ascii?Q?GiphmHu1WIL6cX01wjF8Mej4fnuRJw9N26DdRpqyJ8/RSx2kCTM6/Fg81EkD?=
 =?us-ascii?Q?iaqMFljz5USOVkF1RjFUJKPT7G7UQmDwOJu50v7TzgdTury14kDI2PzOLfpD?=
 =?us-ascii?Q?OjWWz01n0FZb85LyPoHiFvFobcaXqAStIpHvkm+BOw9GLuesLw4KBu1BRtsa?=
 =?us-ascii?Q?lXydTUroEULyWthoV3Yj8fs8bVc3pYcnJZnVcRGNP24z1twO4s33WTnFOHFQ?=
 =?us-ascii?Q?TyTmEojj7xvUxkg3iaEnblwbBeWXtYmpERgf/hYbjL01Qus0DdLfi/S6VkJW?=
 =?us-ascii?Q?x+oKAfZFgpXi0aSncCQ/QszmmM2etlopL4hnmdfxZf7KVJu7htKhVSdSE0dj?=
 =?us-ascii?Q?yd4k1T/AFQrNlBU1Vn9X+h+gsVIBavfPcpQqJ3ejZ7TB2VPU+IwjDWu9/hZp?=
 =?us-ascii?Q?fKAkP6VccX2/cLoBJnHl8DCgXOwGZEIPn8mfvKYmkopExef8ykXhoO1SYJMX?=
 =?us-ascii?Q?zK1ZAgGbOOTc73gXIlV58cf8TDfZPFg4M3N4Ka8kBcVZxg8zKXR58BgOAEGd?=
 =?us-ascii?Q?3YH4do5OzCKePGrJ2qti3SIG9OfLDHneD9t/733Fd//ZSPgBTW0vzJoqTaHJ?=
 =?us-ascii?Q?Vt8e8F69uhaMSaWFdyIE98eBQhRnjZwfVAzh/p+/pY9q3AO7zBgnZXNZ5k4N?=
 =?us-ascii?Q?fKNFakS/Zz1Zot35+dw8YEMGgvfNjyvUweUirx7jxkudnNuL5aYztY7+Nfsp?=
 =?us-ascii?Q?+Tc/FsbvWhpDrvEJKaAZSnyxP6zx5rjvnfD0BOBZArI101m6pHuuOKyykFU4?=
 =?us-ascii?Q?Ozju3sL+PstovEYnd4yZXgHO/BPBD9J2h+W4b9tyqSKj1MUcuGHJ/j2cOKwF?=
 =?us-ascii?Q?YgfLCmteYC2XWimbXxG7LlsKGk6upTNHf3BZOQBc0iq9boVnd59AoWYuavdO?=
 =?us-ascii?Q?GZZPqEU6A3aPoUTkgqIq7/mTKbGgel/dLr3qoKgLXQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2qL9vvb4r0En4nYFnHAw5drAGd6A502ndAXQn0KAWnvEXiPSeIjv2RX8NHU?=
 =?us-ascii?Q?EjR1FdQRwoAOU+AGCsnCU9OxRQQKS3+7gQUKSCbam9e4Sb8NbTH2cIUfPlmk?=
 =?us-ascii?Q?T+Ewpe+60/hVAYvOXLz5egAv4uqtx6UkLmQr5wzHprKLXbZCJJHVqDwsnSwp?=
 =?us-ascii?Q?zgA9Kx2Txgc/cXC+R9aFrzbo3Fyw5JgncSgrewTqX4DFJo3fzZSOkPH8m8mZ?=
 =?us-ascii?Q?8MWr4hKXU4OvJiuD/YRxt5ezHn5Mmjy2JwSVcRSctN/HYqtKG8HdbBehpnOj?=
 =?us-ascii?Q?PE6A1dPv8VG2E4jDm/1WKaBjUDtbPjzJw4EpIABou0TPT1vkzc8b9/Ve/SRG?=
 =?us-ascii?Q?UTP5SCijzMmDjQXldPFeU8skb/ICrlRR5pFqDydQ8QNyB4oFUCkhP0AeJX93?=
 =?us-ascii?Q?k+KWSFUpbcOpUEGFLR5oYvU7UgIHCmI5GksARsmubFtReLw1tpgycNCTe+ov?=
 =?us-ascii?Q?IefkEESU6KJfLfbknwz2Xc+uQG/B24GaHsT1qU67dutwVOjLxTHi7qiZEdjS?=
 =?us-ascii?Q?VLiYdoBQJsKSJShT2SnjtrQc+ETiR5JfxPl52S+baidoRG0A0yFXmh6CHR7x?=
 =?us-ascii?Q?30Dy3siiiVshQvAG06hhNGXw2XODgJSYOiDX8YzbnSZg8jC826UIhPqcXYUK?=
 =?us-ascii?Q?D+aQ94TP5VgST7AthPHNj0jn64ojk3+PjBJesNJsPVL4jtqtOGuUjeYrcSun?=
 =?us-ascii?Q?YUtSli03c4RlRKFrrEnl3jyTHiKkwgPwn8hE6NqFFJlNJI64foDD7flECvt2?=
 =?us-ascii?Q?gNO1ODPa/JwlilrTsaeIsPPyRXmVL2MCNHKizrCZjoUUVcwgqpXiU4bsVg6E?=
 =?us-ascii?Q?JkDAcKk2klZFLlVXRLvmELXfAw+bmZFva3D7bl+tj7KJuRNrxmVtXCIJLEWc?=
 =?us-ascii?Q?LjLFxZwgJESvGmU2iYeRMI+KPwDnDDFAij3yQJnFN42YYt0PA42iJn4p6m5r?=
 =?us-ascii?Q?TT5rWdIRxCYmg+BTSyHEdB+gWcUVLNvbPKPkr8jJwObGrZm1KqL80gsYBKLL?=
 =?us-ascii?Q?I5ciwW6Yk2Z1L2tlFLHKEWLfb9b38La+LJcncRrpKpf1ap1VTmLHddTWgYjw?=
 =?us-ascii?Q?TW29i7RQasgpvB47m/A3YTfhVoYoA2JRRTHAtUSgFf1eCrEcvdw9D1fYdiO3?=
 =?us-ascii?Q?TYRwosbUK347SYit6gtbPWD4BUWIyP82sdArfST7hDn4n0bgKHeRlGXXl+c3?=
 =?us-ascii?Q?8Zpub1jy8V33JKkW2yl741FxRTiDc1pkQybfy9p12jpnMAkL4ribY1vK9Tr1?=
 =?us-ascii?Q?pq+agOBAKWsK+ZShwq69wfYXgC1P33QWey5qsPCHNGfHJ1YUNE0sfvc9CBMD?=
 =?us-ascii?Q?FlstItMY+fN+kOUcGKgL+1AAQHQouWz29JPbhmT6pxtErl1O6XtHtOxy4r1x?=
 =?us-ascii?Q?v8gGXOz8gM6kd1dePpF01CwXCHvaKjtm4Ve3JTAU/nv6Vw1TQlQpnwwxMtAM?=
 =?us-ascii?Q?t+yKM39c89HyTmhqnwQjRDUaUvyHt80KNmrmlV8xwSnRMdFnNBuF+Pfq1H1a?=
 =?us-ascii?Q?zC5ZLJFg+F4MTlv3OdLynD/Iif9srbmcJVrxPIl0InMS9ZEAZDojGVjxPq6O?=
 =?us-ascii?Q?GSYgbagPJueJdPA82m0+ISMCZsOCCa+b6XuG4sL0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a72f66-baed-427a-471a-08dcfe4f196c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:38:06.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMr2+E31JE0CEAZZ+3PxZ89rzR6mFcxn0vhGOveZfUj6VrH+s2Vk8O+W+UA+SOdM5mmUvq05EWQ36rAaAVEshw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6753
X-OriginatorOrg: intel.com

On Tue, Nov 05, 2024 at 05:51:35PM -0800, Sean Christopherson wrote:
>Always set irr_pending (to true) when updating APICv status to fix a bug
>where KVM fails to set irr_pending when userspace sets APIC state and
>APICv is disabled, which ultimate results in KVM failing to inject the
>pending interrupt(s) that userspace stuffed into the vIRR, until another
>interrupt happens to be emulated by KVM.
>
>Only the APICv-disabled case is flawed, as KVM forces apic->irr_pending to
>be true if APICv is enabled, because not all vIRR updates will be visible
>to KVM.
>
>Hit the bug with a big hammer, even though strictly speaking KVM can scan
>the vIRR and set/clear irr_pending as appropriate for this specific case.
>The bug was introduced by commit 755c2bf87860 ("KVM: x86: lapic: don't
>touch irr_pending in kvm_apic_update_apicv when inhibiting it"), which as
>the shortlog suggests, deleted code that updated irr_pending.
>
>Before that commit, kvm_apic_update_apicv() did indeed scan the vIRR, with
>with the crucial difference that kvm_apic_update_apicv() did the scan even
>when APICv was being *disabled*, e.g. due to an AVIC inhibition.
>
>        struct kvm_lapic *apic = vcpu->arch.apic;
>
>        if (vcpu->arch.apicv_active) {
>                /* irr_pending is always true when apicv is activated. */
>                apic->irr_pending = true;
>                apic->isr_count = 1;
>        } else {
>                apic->irr_pending = (apic_search_irr(apic) != -1);
>                apic->isr_count = count_vectors(apic->regs + APIC_ISR);
>        }
>
>And _that_ bug (clearing irr_pending) was introduced by commit b26a695a1d78
>("kvm: lapic: Introduce APICv update helper function"), prior to which KVM
>unconditionally set irr_pending to true in kvm_apic_set_state(), i.e.
>assumed that the new virtual APIC state could have a pending IRQ.
>
>Furthermore, in addition to introducing this issue, commit 755c2bf87860
>also papered over the underlying bug: KVM doesn't ensure CPUs and devices
>see APICv as disabled prior to searching the IRR.  Waiting until KVM
>emulates an EOI to update irr_pending "works", but only because KVM won't
>emulate EOI until after refresh_apicv_exec_ctrl(), and there are plenty of
>memory barriers in between.  I.e. leaving irr_pending set is basically
>hacking around bad ordering.
>
>So, effectively revert to the pre-b26a695a1d78 behavior for state restore,
>even though it's sub-optimal if no IRQs are pending, in order to provide a
>minimal fix, but leave behind a FIXME to document the ugliness.  With luck,
>the ordering issue will be fixed and the mess will be cleaned up in the
>not-too-distant future.
>
>Fixes: 755c2bf87860 ("KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it")
>Cc: stable@vger.kernel.org
>Cc: Maxim Levitsky <mlevitsk@redhat.com>
>Reported-by: Yong He <zhuangel570@gmail.com>
>Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
>
>v2: Go with a big hammer fix, and plan on scanning the vIRR for all cases
>    once the ordering bug has been resolved, i.e. once KVM guarantees the
>    scan happens after CPUs and devices see the new APICv state.
>
>v1: https://lore.kernel.org/all/20241101193532.1817004-1-seanjc@google.com
>
> arch/x86/kvm/lapic.c | 29 ++++++++++++++++++-----------
> 1 file changed, 18 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index 65412640cfc7..e470061b744a 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -2629,19 +2629,26 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_lapic *apic = vcpu->arch.apic;
> 
>-	if (apic->apicv_active) {
>-		/* irr_pending is always true when apicv is activated. */
>-		apic->irr_pending = true;
>+	/*
>+	 * When APICv is enabled, KVM must always search the IRR for a pending
>+	 * IRQ, as other vCPUs and devices can set IRR bits even if the vCPU
>+	 * isn't running.  If APICv is disabled, KVM _should_ search the IRR
>+	 * for a pending IRQ.  But KVM currently doesn't ensure *all* hardware,
>+	 * e.g. CPUs and IOMMUs, has seen the change in state, i.e. searching
>+	 * the IRR at this time could race with IRQ delivery from hardware that
>+	 * still sees APICv as being enabled.
>+	 *
>+	 * FIXME: Ensure other vCPUs and devices observe the change in APICv
>+	 *        state prior to updating KVM's metadata caches, so that KVM
>+	 *        can safely search the IRR and set irr_pending accordingly.
>+	 */
>+	apic->irr_pending = true;

Should irr_pending be cleared after the first search of IRR that finds no
pending IRQ, i.e., in apic_find_highest_irr() when !apic->apicv_active?

Otherwise, irr_pending will be out of sync until the arrival of an interrupt.
Not sure if we want to avoid the unnecessary performance overhead of repeatedly
searching IRR.

