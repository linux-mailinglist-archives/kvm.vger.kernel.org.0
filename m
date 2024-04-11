Return-Path: <kvm+bounces-14270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFA98A1B3E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90BBA1F22594
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455525FDA5;
	Thu, 11 Apr 2024 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N1cEqTvK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6F5D479;
	Thu, 11 Apr 2024 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712851017; cv=fail; b=E4WtUAZH3G3iE0e09Cqx5mv1zEm9hSHDQvsm+URZUenBCwpWPaWplJ7yHZ5h+iQTtNOkLTspAOuAWSicLfcup15fUdA6XctXCzAOVEBvSX9tGKeFrYnp3xL2Ebt7RBsOYiHrSuj2qMrBkLgqAs+ilbc+v0DTa9ejX1l/NGXjbrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712851017; c=relaxed/simple;
	bh=CFWJcTduTP1zHbliVaNBpknZQGtqEaefINr5dTn+v1k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VlKlOJh7yxLdjPml3mMtC+xiyM/pdOZBmaEioK/2sPmsvMi6IEhXKAGraHwn0TdvNKcyn0P2IdR0fFn4oAdk5gScwJHq3ecLdrPIH/jaZwAqEtUiiu5TROuKv+WG60Y3WD4YJo49RFUg2HW7AmPsVCb/yAK+w/b0YC7/X6fSEig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N1cEqTvK; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712851015; x=1744387015;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CFWJcTduTP1zHbliVaNBpknZQGtqEaefINr5dTn+v1k=;
  b=N1cEqTvKWFKEIXQH9VbCWuo2Lk7PXwRtGh0MFc3nb05PVTHqwRYLQIgk
   rRuLH1T41iFmxAuOMON1LnhtrBvBHwBFvtWz2sYU4U/S0Bi6RKDT2NBef
   Y2MmZQVEriMd/G65Uu2Ug3VxaTmrEfon8fVWirsBBdcnCBIjFaN944U57
   GI5LcgE9BFpBZFXoXxTKMNr7ZMuYEQpDxA5NirvkrrqbBV5c69xrbni1l
   WAVdMJ9f5FyMHFCxuaD0/3zuvtjO4LaqfNDaoq0C47sAvBo/NwSxfv19s
   0LwzO7JjaLuCF4+pjJU1IVnr0K/Qt0/VofDeDuTyPq8MR14xklT3dJw0E
   Q==;
X-CSE-ConnectionGUID: hZCMiyj3TJ6lIU59bLqHzA==
X-CSE-MsgGUID: WOEwW2d1QamNhyX/giWzmQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="11236457"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="11236457"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:56:54 -0700
X-CSE-ConnectionGUID: 20ondo7RRGCeUFLMs1iLkQ==
X-CSE-MsgGUID: Tqth7AlCTK+ivjAgeUhxAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="44228636"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 08:56:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 08:56:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 08:56:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 08:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzO5mscRnPJqkJgBg2kjaq4GLQirqTj7/icR7Zd5u9DTVVIBNOP0MJVs3+1uHiNrlYdk28PNxPHe0HcBCk4YqHof/gnD6gKO6WFgMkVibFQP0+G1u3hvRTC6gP2rNW905f3GHSGNiuWnMQxmu8R/2Bst4miX5XNCRMj/f2ZS6llKS5vPdgnRbSE7GeM1vpokocStbZ/0oYxlqWhU+WGMo2fNCngLyJRrqORrcYHAyk1NwDGNPqdSPHobGIKUU+yb3bpiu9j7ozxjuop/6mTBhP5vnJfO8jut6WWQ01NHjJPWKOxCLprXQyqOFDmKUpSJOk+5+wnU5GSqufgkmKuoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFWJcTduTP1zHbliVaNBpknZQGtqEaefINr5dTn+v1k=;
 b=B3jbBDjtlMj0clLIWQ+09ycvqvh34ymVwCAytVgUa9N6lOaBx7jxTWDh6SGvH+MfmotXxqQk6/i+6rU0I0rw/aqxMHAHU9pXALTolo1V//DdkEcfMH0fKSPQLCX6RxgoDqLd/33KdKXn454QG0jyi/Ne1+G2V4WH5uH6F6f1JgmcwsHLkYM3mMS4IpHsFQAZ2fagCnI/NYm0I6luuM7vmqpMUi591gzgMauhzvrFs6AO5Y6bBAdU9QBpzD7s7N5MkzxsHoUKsnoUEyAWRUpoOqKOY50SEXsESOXEAV7qCQajQk5j/WMHX+h/1oA4sCmvbXmzJx2+Kf0hFcJXoaWnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Thu, 11 Apr
 2024 15:56:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 15:56:51 +0000
Date: Thu, 11 Apr 2024 23:56:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Alexandre Chartre <alexandre.chartre@oracle.com>, Andrew Cooper
	<andrew.cooper3@citrix.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <daniel.sneddon@linux.intel.com>,
	<pawan.kumar.gupta@linux.intel.com>, <tglx@linutronix.de>,
	<konrad.wilk@oracle.com>, <peterz@infradead.org>,
	<gregkh@linuxfoundation.org>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <nik.borisov@suse.com>, <kpsingh@kernel.org>,
	<longman@redhat.com>, <bp@alien8.de>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZhgIN4LIu2K5vf5y@chao-email>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
 <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
 <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
 <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8665:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a6cf0c-fecd-4cd4-4fce-08dc5a4000d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXgcKTde/ofcS7NrTyScnlqgAxenEgVK7K26oaevJ+T4GoET2VpIvcgMh/CuZZeGLJhizPAGBaUJvDZ8RKPgX/1iuW3H0m0brGE10ZlEEOnVBIrZJIqjIbpAZY2Dk6IHw4pNwI5253N3yJ1vWM4H+utS2RH9AbArwEeaywyUiXz+hkanwhu8fkVUGag1zlJuw5Ouhr62EBpQq5iP5WQ6gQH/HXdvmMHxYpc7dmtVun9ShH6Sh1iYVwzhrK9gP6q00bqsyAdE0veDciQsI3bq0EL5AidhYJtgc01Ex3TFfGxBL45rt6kHOz+riCLuPqR6aFtCtXpZvvOFEPBk3BzoqcHcEfj8xRcpFLLZ1hVLJBd1PwRXc2gqVbGi+4nLJO+PPJww36oynN3AaD8IWiAU0hw/UE52PVKQqWW4gGUwAgrJk6ax6tQ+pedpg6zpuf+x1XbjNThd3VHDADpWLR5JhCpFWqQQXiq+eh3jMVFmNQoT5SCmr5MJmQUoSyndYZb/TaIkL0CCf81z/XlHc0XpzgyyyoYfAtuFs+McthJiX0vFThr650noejEe9vTaDiEYsn4BLl6k6a69udDbAECL8xgap3mnQlBcLNLMyb1GEQn6Nzxp5xTffurZ/yOlnyShmHDgWrZ3tSpC+qTiDKw9RNAPe4bC5Zqma/9SWgRgaSk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXpDZm1LR2dhcEM2VVp5WUFvSUVBcy9FNng2cFdud1BZSWF1MU9SOGJXVmRO?=
 =?utf-8?B?a1RiN25HMGdyK3JYVDlkbm4rbXVVVWxDTFBQQnkyeDRQaXhXdldMRHJFeWRa?=
 =?utf-8?B?NnZJREpIMVFzMFA0aGE3Y054YlYzM2F3MVVJOTlUMTBPbVRrdURSNVo2QnA3?=
 =?utf-8?B?Rm1CTUR4MjV4RG93VzZObUlyUjJLQml3OEZjWGZIYXNkT01BenkraGt5ZVY0?=
 =?utf-8?B?a1ZsdThxNVkzMEo5TTNjV3JkT3VDSUZYMlhzYWlseDdsbUhSWmkwZkY0Umhy?=
 =?utf-8?B?UHFHcTBhU2FjdUJSdHczaWVRUlNxSTQydmRGTlhiYkdaeWtpdnVscGxpOFFs?=
 =?utf-8?B?UmJSR3YyS3EySnRENmtYeTZ5eWl4eVBOMXhPUVhEM3VQdnZGY1pSNW5aWGkz?=
 =?utf-8?B?T0FoV29vNEN6eGlvMjh1czduTUxsem5aNDgxMVNoeE1ocWFYeFd5TFNtMDFB?=
 =?utf-8?B?UEZUeHdvZXdkTEtFaXd5SDNkTGgrNTNsYnRoem0rWThBclU1UEVOSUQvZjhL?=
 =?utf-8?B?U1RFUStqSUZwTDdwcXc1d1M2UThNeU8vY2Y1REtqbFUyc0JpcGNUL3o5K2Jo?=
 =?utf-8?B?MzkxNkh6eHc1a0g4U2U1ZnFxNEE1L3hRYnR6MU5hU0kwNkFCVTZmdGNzaU5T?=
 =?utf-8?B?NGZSemlUY1EyOUtvWW1UbzBNRzJQcy9XZlc1eFV6SHdpUjV5ZDNLU3dETzZr?=
 =?utf-8?B?TWo4a3JKVWdadkM4VlV5dnQ5ZTJ3ZXVCMmFwVUpwZ1gxVVJSYXlSR2hNWDhK?=
 =?utf-8?B?bW16eTF3amtLQk9WWTJiZTYrUXQ2RFlJQkh2UkdJOWM1bFhqTGlCRlljV2N0?=
 =?utf-8?B?R2VwQ09XaUZpdi9NMDZvQ3FVbHJVNHhXRjFvdlVNSVpMYnVPUldBYVF3aFp6?=
 =?utf-8?B?dFZzZ0dBa2VMS3l5cS9VeEE1cmlPRzBUQ0R2SlNwNzlDL2R0MGY5MUN5czZ4?=
 =?utf-8?B?WEQ3SGo2eXl6bzNzTml4UDJMNmdxSHluMlA3c0c4UDJ5Wi85Zk5PeGFyT2tG?=
 =?utf-8?B?cUpZK0UyUWdnNzNwa3JTRlp6UTZjeUQyMDYrRlV6bGkwRFpPSDUrWHp3eWFr?=
 =?utf-8?B?eFJINC8vY1Z0WGZPS3UvdUo5Q2o5WFl2aUJuUHMweHFnTGROaG50bUVUYTk4?=
 =?utf-8?B?dWRCNWVFbElNM1h0d1NjUkdsaFB4SzhuNEJ2eE0zSGZJUU9EQ2N6TDZaSFFW?=
 =?utf-8?B?SXE5R0tQU3RZdklscnZ3L0xpZ291YVk4cDFUTHVlUGJxUDNScWgzNkFJaTBP?=
 =?utf-8?B?aHFPVTk0SG9LbXpOaElXdnlDZDc3cGN6UncxVmludzFoYytpbDFYL2l3djFT?=
 =?utf-8?B?aTcrVmhkOXF6Sm0wRW1iOE93bUltNXRoL0dRK2Z2NU9pc3N2L3JNbEVCUWNq?=
 =?utf-8?B?OWdzY2FWTnhPUzZtNFZaajc3YlpYZ0VRS1hXeEZBNWt5ZHpuRGg1RUh0UGlP?=
 =?utf-8?B?QitHTCtCTmRPVmxBYW9tS0plbzBsYlNVOWtFTFN0V3dhYmRMdzEzT1N5WjlU?=
 =?utf-8?B?ZjdDS0d1SXdHc1I0cDdGQjVxeEdaeGNmRFowR09jUWtDSFdKdTEyNnFDYTRP?=
 =?utf-8?B?UUt2TU1YYzZ2em5tMStaUytwTEVVNmJ5YjFRQ01HWXd1YUhNOUhPeHB6ZzNP?=
 =?utf-8?B?OGNuRVNRWUNZVHdLd1c4WDZ1ZHhFNlVSbmx6UC91OVZSMDh5ZFdKQm9qSmlU?=
 =?utf-8?B?YXRIVXFWOUVBbDVLbHdlMmVRRHFMZjh6WlpFUDk0NEpKalVGaFcyQVo3NmEv?=
 =?utf-8?B?bWFhRExvMkt2anFKS3pkSXJGQXlDVU1KVVY1L2RPeWExRVJHZ3BIYU1ranpy?=
 =?utf-8?B?VGlVdnFXank1NEhzVWlhTXdMZ2hDaUNiOHR5RHpCVS9BWFphcGhqdmswZk1N?=
 =?utf-8?B?NkJIbS9ZcS9naWlyaDF0WldtUGI2S0ZuOVhTaFRJUmJxSXRweC9jMmdqSVVO?=
 =?utf-8?B?QWEwNTJxUjhJd1AxUXdSQ21aZzFVbHdwQ1QvOXFMcjQ1MkRBOUwvZ0xEY0lQ?=
 =?utf-8?B?Zi9DK29YTmc2eWJpZFNCOVQrVlpzbDJtY0plQmkyaXkwL2NkVDhLdUFWUzZr?=
 =?utf-8?B?OHNNb3Fjb0w1Q09DRnVsZll6enNYY2JqZzVKNkdVQWJaVkp3ZEZBU0lCZWJR?=
 =?utf-8?Q?wpfMyNm/aw87derUZUOhDe4kp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a6cf0c-fecd-4cd4-4fce-08dc5a4000d0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 15:56:51.9293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csiNYEEtwndJlKhssY8CsQ7qPdPFi6iOZEfp00opuiBEEH516xpW1Q/qeVd1KqMHgKsLv/vb9ClO0W4VufPX/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8665
X-OriginatorOrg: intel.com

On Thu, Apr 11, 2024 at 05:20:30PM +0200, Paolo Bonzini wrote:
>On Thu, Apr 11, 2024 at 5:13 PM Alexandre Chartre
><alexandre.chartre@oracle.com> wrote:
>> I think that Andrew's concern is that if there is no eIBRS on the host then
>> we do not set X86_BUG_BHI on the host because we know the kernel which is
>> running and this kernel has some mitigations (other than the explicit BHI
>> mitigations) and these mitigations are enough to prevent BHI. But still
>> the cpu is affected by BHI.
>
>Hmm, then I'm confused. It's what I wrote before: "The (Linux or
>otherwise) guest will make its own determinations as to whether BHI
>mitigations are necessary. If the guest uses eIBRS, it will run with
>mitigations" but you said machines without eIBRS are fine.
>
>If instead they are only fine _with Linux_, then yeah we cannot set
>BHI_NO in general. What we can do is define a new bit that is in the
>KVM leaves. The new bit is effectively !eIBRS, except that it is
>defined in such a way that, in a mixed migration pool, both eIBRS and
>the new bit will be 0.

This looks a good solution.

We can also introduce a new bit indicating the effectiveness of the short
BHB-clearing sequence. KVM advertises this bit for all pre-SPR/ADL parts.
Only if the bit is 1, guests will use the short BHB-clearing sequence.
Otherwise guests should use the long sequence. In a mixed migration pool,
the VMM shouldn't expose the bit to guests.

>
>Paolo
>
>

