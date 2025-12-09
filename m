Return-Path: <kvm+bounces-65545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE984CAF16E
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 08:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED48C3056783
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 07:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCB625A321;
	Tue,  9 Dec 2025 07:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CoNJiyle"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15BC2116E0;
	Tue,  9 Dec 2025 07:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765264008; cv=fail; b=JYYGfRVJ7uXKTaZ3bfvveFMA01yweM2cC2Ryuz4KAR2D56e0dyfgGeVGP1GMn2BNCbs/aOLh2AHZPgkHADcpG53IKO3E+n9gmTqPAGBiMG9tp0memZ1znkAiqItEg85ckZE0nZfo6PaKol0r365MrBjqkBxCXrE3qfFZP/+odDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765264008; c=relaxed/simple;
	bh=36OsF8U1teJMSbuKqCFRNohTHok1hbLkeXkegPiJJ2c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U6+wwZoKrMCZT/xGHZBrQXQuoSA4j3NfqUCTN98dsh7pUKvS9e0JwV1ko35EyD7XpV1v9j4tm/AFWo3uEqmWJ1rwDgGqXRXNAppxiE4OO6czoiV6+UxlfWW0Ur/iFoUsCPweYZBYK37JCmDG5G4jiIrGDukL7MBTqFtfB5sMiek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CoNJiyle; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765264006; x=1796800006;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=36OsF8U1teJMSbuKqCFRNohTHok1hbLkeXkegPiJJ2c=;
  b=CoNJiyles7imFhrrJT5ntoybmrbvTCArZhmhpobd5+DXDTXMx4r3EsvO
   vSSSHi3ljyvfAxn2iQ04VlrP0LcIYY08rqtEjL32ayGLC/V1gBOjJ3/BV
   uHQ2kBycdKRkQchRzxR8PmX/hufkxpuJjM7EjhuKs9CDKaML0a7AZwt3X
   go21R+eJnPN7LFZSDAd+j/jJ3Ae62jMHIXS8jUxjNwy/tv+q1eMVXiaqw
   m+C23/R+jXfM/N5OYcNu46Fu9WokYr+IQ3DeguFqoqtxqTqUvxzNLJXvQ
   mjfUi3D3qN2OaLtERaPdmsr2CZhrhUsUOh+X3D1snLDFg3dCYeDGuA1iV
   w==;
X-CSE-ConnectionGUID: LbemP3KPQJuA5EQ8FkylYg==
X-CSE-MsgGUID: /LEK/4YwSUyKQaUautp5Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="70836335"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="70836335"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:06:45 -0800
X-CSE-ConnectionGUID: lsHQR11QRMO3OkUAu1SrWw==
X-CSE-MsgGUID: Y9DN6ZGbT0u2guefBMtOfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="195754056"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:06:45 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:06:44 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 23:06:44 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:06:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yI9G+AM3gZD4ZQn7GujbsGS0K1Kha6ksnHyE+9I8x+JroFPC9muB51+HzHWgBgLjFFqpZlmnEeIxp9t0rLedff1OrnyFSIyMSrCZ5vVIEeqmy5Jo9UnhSqoXJBq5MzXQmcUBkWm99rREzuS1jiCHTnHSGJt6lqrMwgaPe9Jkm1TBAH4RPsdBMuC0BOfzphpti79fvTyesfiKJTfW3x+4vBvDvbkeaemakv8kVFUy4EuTwy1N14Gawfbi+pPUGZ1xvWNX7R/orQYpb8rlbZCnQTXGk1AVGiirhKKx0Mhm/RA8fR/xtlv/wZtrhA74Aql6xSlL/Yjcdi6UZSc+LxqHnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oao+M/YwE5NSkUFi1EZ6bk9lU6YW6sEu+zxCF5lkNVM=;
 b=PWQ4sfkE+Xz8ycQCsR2OKI3PhK9izWoTg+HT4Mv7wKjL97mEa680fygeb7hYlGgDJOZ4VNoOFGvshV6yJxQxZprC5PtQRz+awi9W7N1buzufn23qCwHr34Hd8tctA00OlTE94rCikzG2Cl6qXes6VaV9rYqCwiGl9i2pN0OD/3VgfM8mxG8j3HcKIZy4YniXmn+z6/QpLXrZFgmHdv+fZ9GOdjyAtJl2hLvnWhkxbMjmBptpu1qD6R3RXN1HxUYEPpKwmixAtWbCQBZQmOwrlNYO0ConJieqtiTZ6U/ILMUjEyFEYeljTh42D+a3b/Wmx5flQkmahXnqLaR1mzeI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7605.namprd11.prod.outlook.com (2603:10b6:510:277::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 07:06:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 07:06:42 +0000
Date: Tue, 9 Dec 2025 15:06:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
Message-ID: <aTfKeNMIiF8NCRlO@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:3:17::28) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: df0dff4d-90c8-4d2c-4d92-08de36f18166
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fOhG28HitfOh4xbkRbnIiJH5caBnCWNdfERWkln7VS8yc8o4UX9Wmb/5BMwO?=
 =?us-ascii?Q?RaMFOaya44MO+ZPth+fd/fX2Ow9M6PyOS62VA/IQvMMJ31x/DBtqG3BTTsNF?=
 =?us-ascii?Q?PN23C2m9d3/PH13rF1QtrDjCRXfw6ELbMHmHkSs+mznUMyQHVcY3AaGyGDY/?=
 =?us-ascii?Q?h8qaa2xfn3nkGWIF0nEj7Osvu0jSESD/j04L5vpqAotpoqOz3++4T3tN/n2V?=
 =?us-ascii?Q?HOOUdoycovC6FNguyGHSoJt0cysAr+aN4CPjPa03AFVgE8SUgKrB1y3Mi3yQ?=
 =?us-ascii?Q?JKFqn7LVjF8mz2wIYgMY5POSuoJ0uOhPoT3P6r9zCrNsGL5SM2gneE2XZMHW?=
 =?us-ascii?Q?VTBjQyyZFsTJw08/Ub5TsR+/pBF/pa5jutiz86pksX5/5+OIwcPNskhADDIh?=
 =?us-ascii?Q?pWSoJB405XSyahgDIE4J+iv1LZkrDzIi5e4dA9owN3DFqF08WU70WQ9crt8U?=
 =?us-ascii?Q?grQdAxRLPFBXPnMnY06tVMlE46FQhoJbmGVijNXErHP04WWXQp1fe48aEGcv?=
 =?us-ascii?Q?twWkNE/08IWyVPhgFbx4eIBWgN5na0XdBAKUp/olsU7d5e8T8BZEctMbrgQN?=
 =?us-ascii?Q?zdQ3MDwHli1wMWEERWTDAfAGwG2EJkUmlYBGhDdRRKQQxkH8PtHGsxEqybSD?=
 =?us-ascii?Q?4zrahiirTVLkLgEp9kuBNkuHAo9kbLJ1huwjyJaaWk4kvWJOlnLpp0UO837F?=
 =?us-ascii?Q?9x9ADOtkCPqx0P7CRhMDncW6t6K1i8zqtKe6/Mp9SLQl1vWOZkuK0dwoefny?=
 =?us-ascii?Q?DtI9ed/znZj3Fr0efd33xmk3SSjSSD2PnP6Pvl6eIl/IwwjrJWzEYUgTsHem?=
 =?us-ascii?Q?i2VnTPO60JqiR1bx7oAygvp5cf9KLhEfsQTybbdxnwQNnoaTxzBNStOOguax?=
 =?us-ascii?Q?oOKKuqOmYY09k4PsecccwrYkn8vueQu4hnkZvEXb/5GKz8LGSUZiJmCEohWH?=
 =?us-ascii?Q?SE4yUGwCboMwnlZ0HAcLPcMUDOlSM1sjxYlO7TqkvfmGrrXAMEX5RvLNoHCk?=
 =?us-ascii?Q?DJyMiLeBKJcl6Z4NxYrE4wgf3pSJZI8imfnz9yDtGieYW8QaN6f+EM08Xl/u?=
 =?us-ascii?Q?dB/0Djl0QZav/0jfq7wamKzS9RWki/pwwRGmNRXTkf/CLNmx8VnbMej24EQH?=
 =?us-ascii?Q?8qz3k3vuer4t+b+FZeuP+aCxx8QFJdJb5tQaIgdEfz3Il2QHnSWpVQCb2umd?=
 =?us-ascii?Q?6r6bLjJJ0dvrUpVnNhK+foKMtGBR0mAGizzad9wlQ/MuwPfG9rXbKuUYZjMy?=
 =?us-ascii?Q?nunRfcS3DZrAaF5IMkGSIa8Ei1IP/T1J0/RWK7dt6YoD6KhxQdMQcKu1qDES?=
 =?us-ascii?Q?+5kGcn4ag+GQislOfTlQomD1RxletyWPXIQ2jB5gPJcskZcQW0NmxuRHY8gb?=
 =?us-ascii?Q?rJDBbNbiQ07zNrR0B4vExmL51WTgct0xAEXG14F1I4a9oOwNx6kXAAQ6itfe?=
 =?us-ascii?Q?vRMNmUAQ4hkVSX4nQUnPsvk0f8U4IBo+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UVj7zACzZLlODjz5vEvGOjeqmAiZrPoL20SBD8RsfhRSYPLCX0qm1dYDrtjR?=
 =?us-ascii?Q?w4R3haSwRPy26oRSNy9ERbXCdF557XLULVQXzCwNvwxXdzxdRYuaAJU75pcM?=
 =?us-ascii?Q?v1j3ttrmTC/7ugRvnRkp6NoH0latHT2Hv1kdPmfPAEr2HxUC83/yTMR3fEIR?=
 =?us-ascii?Q?fdvBOUBvs29Ju+61MhTJvqnIPrYkv2rdEYNkcIyziOGcvXJlrwemcrR8r2xF?=
 =?us-ascii?Q?ESN7LJ+TA8Gapk0xiVvUcqaPiVY+GTJTk05izLQT3NhWxptfQTN2Pu+pvN50?=
 =?us-ascii?Q?vJKJ8qSitLZcDfkhYiWeP8Jc7WmMIcJ+LeGePevrAc8YEj4u4Kv3QaxDFI7U?=
 =?us-ascii?Q?9k8ldRu4CpxSVVzd3E2jNC3Svbm+FkHJwgZLAYSVjPekieoBlB7HKFUCnSCz?=
 =?us-ascii?Q?YMhEACc5L8RlkssWYI2vWvZeoLEXmhdxWEFLdQ+XdCUEwo9L8a7y7oDgq/kE?=
 =?us-ascii?Q?/1PvHwRF/rh6ojdBjJSzl5eHRphRV3mRE+q5LCNOBVINyMmCyoXVKib6/nEL?=
 =?us-ascii?Q?Qr9orEPr9U7ziRInrK00ctFBHRXYcsqhlB9rTAs+eg+Tg9WoEs/FZQ2xYHya?=
 =?us-ascii?Q?3n32QPJsLWnIa9tF+fPNpkCXfqBwm1DRdgQGbyfDJYfWlHXRTPCOhMBVr2/R?=
 =?us-ascii?Q?FB+vXMbYwaTR/znn1LBRudYmk24zDjy2jPKmt1nUNaAG4oqMoTdGaBHTpHe9?=
 =?us-ascii?Q?8Fe9DmX+hXy6rTnuOuhxRSCWUY8Gni/7DArz/YyMCUtILeXV5uAbQ7eWTg05?=
 =?us-ascii?Q?VXCZPkUWoBUbidsUqocyHMU5IK4REiM/eiE4OVys1QBV5ujY8GRSirvQaGu/?=
 =?us-ascii?Q?XkArt3HlWuLuJCWTfKCgpZBdyTEgVZldYrcKRt3jWeY4G20QeaGCrkSkG2PH?=
 =?us-ascii?Q?X83JJKzUB1owEAJhegYACC2J2SuFZ3cA5fj1j3XQZIJ1Lgt1cWph2lbsb1NQ?=
 =?us-ascii?Q?muFmbQXYmAAB/d4spfRblexV2707SFzbmpssZaMaW3XXjREYv+7KGzupx8Zs?=
 =?us-ascii?Q?2Uphhc2pO+SStI4AvZ9wVM4Ab5aKq/YnLRsygTZ41JKaZD0VOxs93svBR+We?=
 =?us-ascii?Q?cOgrGwlXNTOwkyaFZ9j5fXDBUl0D0oNrg4lrCwWB8/k+uDlZd4ZqhON4Hw3I?=
 =?us-ascii?Q?czz20Ye2Rv/Rlb3v/MTmHKOtwdM+3hwJmIQQAGXo56AEih5hMI9dqV/GIBgQ?=
 =?us-ascii?Q?4HWaT/CKX2C4WRhAmp01eQ1PPlZpFDDyR1rzPJimJJP0K2uSpZApCRUWH4d3?=
 =?us-ascii?Q?oMyWVpLKAJ4vW26aWSA0LXyrsraQslrLYKjXdTtXZVw9w5SUq9uRDloHGInb?=
 =?us-ascii?Q?OqXo0ZHH8RARwfRKUP3gQIRy1wOq7sJG8pLXCe4WXzNGmJNmHVkakI3LoIic?=
 =?us-ascii?Q?EzlV0F940aivAMgKG+E5bPzuvDw6g0nctYlVVkKlAqS+Gg0dxST76HqRU/45?=
 =?us-ascii?Q?7QWdE4q/slY1crfjY2ukjVk1alUvwmr6gwkdKl/ZTzowK8iaxdAehMl122ER?=
 =?us-ascii?Q?uuzyozv26hk9A57YVhr+9NcZrJE0DZYC0wtuE1aJtq0mkfY2RAMerW1Xf7YY?=
 =?us-ascii?Q?e8Wg1Q30uEhIOoK/DXkJF+6kIfnVxxJWHcefHLxJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df0dff4d-90c8-4d2c-4d92-08de36f18166
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 07:06:42.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5v3oojrsf4owkZwoHKQSp5kCvhr6pMvxRcQyl4YCQBBKJBiVXerAuXfcZwpGpuSE7GN6wefLWo7pwZShi6dKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7605
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:50PM -0800, Sean Christopherson wrote:
>Now that VMXON can be done without bouncing through KVM, do TDX-Module
>initialization during subsys init (specifically before module_init() so
>that it runs before KVM when both are built-in).  Aside from the obvious
>benefits of separating core TDX code from KVM, this will allow tagging a
>pile of TDX functions and globals as being __init and __ro_after_init.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> Documentation/arch/x86/tdx.rst |  26 -----
> arch/x86/include/asm/tdx.h     |   4 -
> arch/x86/kvm/vmx/tdx.c         | 169 ++++++--------------------------
> arch/x86/virt/vmx/tdx/tdx.c    | 170 ++++++++++++++++++---------------
> arch/x86/virt/vmx/tdx/tdx.h    |   8 --
> 5 files changed, 124 insertions(+), 253 deletions(-)
>
>diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
>index 61670e7df2f7..2e0a15d6f7d1 100644
>--- a/Documentation/arch/x86/tdx.rst
>+++ b/Documentation/arch/x86/tdx.rst
>@@ -60,32 +60,6 @@ Besides initializing the TDX module, a per-cpu initialization SEAMCALL
> must be done on one cpu before any other SEAMCALLs can be made on that
> cpu.
> 
>-The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
>-allow the user of TDX to enable the TDX module and enable TDX on local
>-cpu respectively.
>-
>-Making SEAMCALL requires VMXON has been done on that CPU.  Currently only
>-KVM implements VMXON.  For now both tdx_enable() and tdx_cpu_enable()
>-don't do VMXON internally (not trivial), but depends on the caller to
>-guarantee that.
>-
>-To enable TDX, the caller of TDX should: 1) temporarily disable CPU
>-hotplug; 2) do VMXON and tdx_enable_cpu() on all online cpus; 3) call
>-tdx_enable().  For example::
>-
>-        cpus_read_lock();
>-        on_each_cpu(vmxon_and_tdx_cpu_enable());
>-        ret = tdx_enable();
>-        cpus_read_unlock();
>-        if (ret)
>-                goto no_tdx;
>-        // TDX is ready to use
>-
>-And the caller of TDX must guarantee the tdx_cpu_enable() has been
>-successfully done on any cpu before it wants to run any other SEAMCALL.
>-A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
>-online callback, and refuse to online if tdx_cpu_enable() fails.
>-

With this patch applied, other parts of the document will be stale and need
updates, i.e.,:

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 2e0a15d6f7d1..3d5bc68e3bcb 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -66,12 +66,12 @@ If the TDX module is initialized successfully, dmesg shows something
 like below::
 
   [..] virt/tdx: 262668 KBs allocated for PAMT
-  [..] virt/tdx: module initialized
+  [..] virt/tdx: TDX-Module initialized
 
 If the TDX module failed to initialize, dmesg also shows it failed to
 initialize::
 
-  [..] virt/tdx: module initialization failed ...
+  [..] virt/tdx: TDX-Module initialization failed ...
 
 TDX Interaction to Other Kernel Components
 ------------------------------------------
@@ -102,11 +102,6 @@ removal but depends on the BIOS to behave correctly.
 CPU Hotplug
 ~~~~~~~~~~~
 
-TDX module requires the per-cpu initialization SEAMCALL must be done on
-one cpu before any other SEAMCALLs can be made on that cpu.  The kernel
-provides tdx_cpu_enable() to let the user of TDX to do it when the user
-wants to use a new cpu for TDX task.
-
 TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
 TDX verifies all boot-time present logical CPUs are TDX compatible before
 enabling TDX.  A non-buggy BIOS should never support hot-add/removal of

> static int __init __tdx_bringup(void)
> {
> 	const struct tdx_sys_info_td_conf *td_conf;
>@@ -3417,34 +3362,18 @@ static int __init __tdx_bringup(void)
> 		}
> 	}
> 
>-	/*
>-	 * Enabling TDX requires enabling hardware virtualization first,
>-	 * as making SEAMCALLs requires CPU being in post-VMXON state.
>-	 */
>-	r = kvm_enable_virtualization();
>-	if (r)
>-		return r;
>-
>-	cpus_read_lock();
>-	r = __do_tdx_bringup();
>-	cpus_read_unlock();
>-
>-	if (r)
>-		goto tdx_bringup_err;
>-
>-	r = -EINVAL;
> 	/* Get TDX global information for later use */
> 	tdx_sysinfo = tdx_get_sysinfo();
>-	if (WARN_ON_ONCE(!tdx_sysinfo))
>-		goto get_sysinfo_err;
>+	if (!tdx_sysinfo)
>+		return -EINVAL;

...

>-	/*
>-	 * Ideally KVM should probe whether TDX module has been loaded
>-	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
>-	 * to probe whether the module is loaded (there is no CPUID or MSR
>-	 * for that), and making SEAMCALL requires enabling virtualization
>-	 * first, just like the rest steps of bringing up TDX module.
>-	 *
>-	 * So, for simplicity do everything in __tdx_bringup(); the first
>-	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
>-	 * only complication is having to make sure that initialization
>-	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
>-	 * cases.
>-	 */
> 	r = __tdx_bringup();
>-	if (r) {
>-		/*
>-		 * Disable TDX only but don't fail to load module if the TDX
>-		 * module could not be loaded.  No need to print message saying
>-		 * "module is not loaded" because it was printed when the first
>-		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
>-		 * vm_size, as kvm_x86_ops have already been finalized (and are
>-		 * intentionally not exported).  The S-EPT code is unreachable,
>-		 * and allocating a few more bytes per VM in a should-be-rare
>-		 * failure scenario is a non-issue.
>-		 */
>-		if (r == -ENODEV)
>-			goto success_disable_tdx;

Previously, loading kvm-intel.ko (with tdx=1) would succeed even if there was
no TDX module loaded by BIOS. IIUC, the behavior changes here; the lack of TDX
module becomes fatal and kvm-intel.ko loading would fail.

Is this intentional?

>-
>+	if (r)
> 		enable_tdx = 0;
>-	}
> 
> 	return r;
> 
>@@ -3596,6 +3480,15 @@ int __init tdx_bringup(void)
> 	return 0;
> }

