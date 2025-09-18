Return-Path: <kvm+bounces-57981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBDAB8313F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 08:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70473189A2D8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 06:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44832D77ED;
	Thu, 18 Sep 2025 06:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqS2uFqk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551C2750ED;
	Thu, 18 Sep 2025 06:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175432; cv=fail; b=kVsvbuFPcwgmZDQtcV2YQHzZHsYolzzWcDX4KjP1wzZ49XSWSjSGADMltFlxAG/8O6bgvCwCcQaMevRJf8OgXADpNISmBs2cXlm5UBnQLNq6VdCx13Ylvx2HVJTo9uHwBrtv3i9LT3kVTDMuqQdjfP8uwTL5gCQVfjz607ralF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175432; c=relaxed/simple;
	bh=5hfrdvAm7xSnhr/Nr8BLfgLJ6ZsAzHQlQeCcIwuSrDk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jCRgGBMNg5q7J6QyVEVvOLHXmmu7XlghFgiERXW3c80U6eCzVUlnWbPVb2zTdvvLR09ApFcTT2YTytRZGJ2g/ghL+nYjYorqJ08IHX149PSYF3mv6781d9GQGzZnPO41IKCbz9D2jxeuTe4ykEtMiTezuXwxKE04iysmUf1it+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqS2uFqk; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758175430; x=1789711430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5hfrdvAm7xSnhr/Nr8BLfgLJ6ZsAzHQlQeCcIwuSrDk=;
  b=GqS2uFqk8KJoXk94VnKiakEu3eRLSUn0sJBr6WfozngeFYdrT4NOo77j
   4b77wYikZO2SvttVJke3+yx+0toXd3/lAsGM73KpskJGC5vVCtLclFScP
   Sf75mpFAO0vsuxfaT2sk8BpQ++XnGjdW333bznu7b3dqsePCLkaUYY1Sv
   QXnPnJCGL5/hxTeS6bMHAd9Y2cDW0SDN11wtd/zcibRFuzBjJIUE3BhYi
   JFeDIKuNzyAtt/CuriZmHgJH4LLSCAxbth9RHVaYHwQvyV0ewT9JlS8Gj
   nXNAQygKYUwGXnT2z2F4Glm1jGvnNLrGVImuQutdjGGi4z3rGKF0MuGQB
   w==;
X-CSE-ConnectionGUID: DEL8f5iYT/OWyTftTRQpUw==
X-CSE-MsgGUID: OrQWTgldQ1OM0zGY7uMe2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60606792"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="60606792"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:03:48 -0700
X-CSE-ConnectionGUID: pRJw245nR36nQljk+D1wbg==
X-CSE-MsgGUID: uKst1uhsRcqjiSrssr6x2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175043592"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:03:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 23:03:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 23:03:46 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 23:03:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zcdv7FUUoIWKFPRlf6s7s1gK6Ngj4EI/QagMYsh8M/nkHWb81wbRj56vkwx7gQBJB/9M0biDipaFm9eqP8ZZ7qkpvu+3I0ziRhfaqvttVHOFNOa/Ili2i3M4ss196Lm64CQ8LtCk1J57NQfz3/TKa7zrN20gS8orda5LZJ9EKdLBUkgSpYmqK5CfwxlrMcrks99UDIrk+tfPD2ZGmL7zDxfWgTPy8gWiGfUL9N0Pvv9aTVFiBrfVPpkpfahkz/H8EhNXyE5XthWAF8nsyQHrrYEl/54mZR+bNIEzV5ytdjLs5iZ/yO7uzYyRiFzlrhaTK7UWJiv8mA49abf0kRDIOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYMFiO3Vi0CtnvWu+3gmq/bNFI/DotSztIEzf0XlsrE=;
 b=VnB8xU0D8BgHttbbfwusFN0I8dSwpgwpmgVALuyWpCOoHaGEejxfVSrZcoDenIMj/AdwM7/uH8vQkmQBEOThcX28t7gk5Y0Dsmc164bCSp7LshtE9rjx3/dcDtwz03iAQw0D06afTRGKwgvk+ckiRlkX4jAOFaUNK8t7NqtvJY4rgl+VUSpUYkqdJgi44ntBKRAptaZaGhgkxSuASqyIvKRzHI4auAZy40oK/okWvu4dhBmYl+dOzZqSCdfhsPIIn/pJ/16seJy1INTbcix3+5z6S1i6Yjf82YMSilHJBDWcKi2upNbH5PArvPq70a1gOLjKdNbTWOwYT+kwm5f1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 06:03:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 06:03:43 +0000
Message-ID: <1cd5f0a7-2478-41b8-97cc-413fa19205dd@intel.com>
Date: Wed, 17 Sep 2025 23:03:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/10] fs/resctrl: Introduce interface to modify
 io_alloc Capacity Bit Masks
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0013.prod.exchangelabs.com (2603:10b6:a02:80::26)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d3424b-c01e-4d8a-9673-08ddf6791f06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFpiamtIK0wwVndGaUtNWmZjUDQ1bDJXWWw3amw0SUhHNysxMlRoU0V2MkY1?=
 =?utf-8?B?dkF1aVhkZjJIdzhUNk9DemRtUnhVNU54UjlEb0gzb2JPYlJlbjdCMzlaUjI1?=
 =?utf-8?B?VVdCbW9OUmFJY0E2UHFSL0laOUJhS0pMaTNHM2t2cDQ2Skh5SGFpbnpJRFFC?=
 =?utf-8?B?UEVtKzQ2aUdTNG5YNmhjS3NKekpqUmY3UTBCRmdCUU5Kc1ZDUVZDQ05Nb0N0?=
 =?utf-8?B?a1BuWjB0RlJoWCswOHVGUXNWbm1CYWZRbjEvb2ZJRGlQUG52Tk1rNFNSZWVa?=
 =?utf-8?B?SzNIRGhXZlUyY1U1OGFBVUtNUFl5QXkrSkFVTktITjBLc3hnTE4vWXNPd1Vj?=
 =?utf-8?B?dlhoaXh3MWJjZTVvQ3BaeTVWYzk2dHdCTUJQc2JSaFU4aWVYbE1CSWN6ZmRt?=
 =?utf-8?B?MjB6VDdZYk1iOHlySVgyWTRrdkNXVjVlNzZXemp6YlFQTVd3YzhNYk1lN3ZP?=
 =?utf-8?B?dnViMndLNm45dStSRS9OdDZ1ZHZoZWFLenNQdVc3MzV1R3YwOVJ4Ri9SNW1t?=
 =?utf-8?B?WWMyQXUwNUxPMks1eFNZdlZ1aG9BbFdxQmwyVVFkaTM1dW9tbzJTNHV6ZWhU?=
 =?utf-8?B?dWFBOUNHRnE0SEFlUm5ZVEZQRTJFMk5KbWVKSDFSOE40L01tWTJwUG50Rkly?=
 =?utf-8?B?cHJyZWRVRUdYWGZGM2M1ZFhGZXJPSGRPUFloUEJXcnc3ZG9FVjczdXFoT0pr?=
 =?utf-8?B?aGd5OWplanRLQjRKK0pqNXdGaWJyQWg0M2dHRnNPekJUa2xJQ2xLNU4yeXZK?=
 =?utf-8?B?OHhxUVJBejhYN0RSczR0RUFTSzNmWmZuak9RK0U0OUhqcnJ1YUpjanVhSlpj?=
 =?utf-8?B?Ny95aFBqV3lDUlkxV0lGN0F3SThLd01SVWNoL1VZZURJMVVDV1poRmVoZkxk?=
 =?utf-8?B?TU10QmVNY3kvN2lKNktpNjd0L0NWcThlK2xYcnEzclNPYTI2bGhXeVlHQWNi?=
 =?utf-8?B?dGNEV1N1UXhWUHlnNmZrdlVyLzNzSStyQWc1OTBrM2JKUFhOdi92K1dQQ3E4?=
 =?utf-8?B?ZzVaRjFML2hyWVBaaEl4bFZSYlV1MnovY0U0UmZaeldoNkt5TXE4TkF5ZHRl?=
 =?utf-8?B?U3BXZ2hFbVNzeG5TVTBZdlhLbzE5MEQ1eVdyTER1SWJlRERZdzJkbFRCNFJL?=
 =?utf-8?B?Nzg2bEZQYlZYdUpYdCs3N294RXhQRHZma3Bmakx2dmxnZ29wUmVTa09CcWNJ?=
 =?utf-8?B?YlIybFpwSjRmb3hQTmU5Y2ZnZ3UwdjRGOWVERnBEVzFmTHdZQUlSMUw0cS9B?=
 =?utf-8?B?L0pTelZ4aGVhdDhjUXpkSjNRbzlRNWxXcXFnc2N2Z1czYWd1ZTgrNFBQaTlp?=
 =?utf-8?B?QjBYLzhGSDc4cFNqL1I0Q3pQbGhaaDNBVk9zL2cyZHg2M0VmWkZ4WTR1RU1Q?=
 =?utf-8?B?eGI2d3dEMnAyMWU4MHRjNUlGejlmenc2cnlGT1N3bjNjSXVhVjBkN21uVW9h?=
 =?utf-8?B?S1FTU3JTRmZRN25BSDRyRWtjbENiWGlNY2JJWlFabDdoWFJKcXg0RGYxdURn?=
 =?utf-8?B?QTVQb2d2MmV6MEYwdXh6bDcrNU9iczNTYTUrcmhCYmlHaXlnK3NqeEpZa2Vk?=
 =?utf-8?B?ekxTcEtUMnhDWExWWFpnTi9MS3czemhoZlBhY1NXQ3pjYzRTSGFnakdrSTA1?=
 =?utf-8?B?a3pQT1Q0aHpzWTVRTU1MMDhjT3pFSG9wcWc5bUdXbzVleGpLUTA3aFZSZ0VP?=
 =?utf-8?B?QkNhbjc2WTQ2OU84L3BUOFg3UGZTY1hLdHZyUG1sK2FTajAwSTlUNDBNOW91?=
 =?utf-8?B?MzJkL3hvOWdhTGxnWk95UTBnUDg0ajdTS0oyNUtoYmRrbjJnZTJrbEpRSjda?=
 =?utf-8?B?SnBTRHIycGZjQjBlaTdYbEJ4UksvTUluV0E3VklVODBHMVBsQ3VQYUR0cENx?=
 =?utf-8?B?VCs5Ui9mREdENmhzRmgvZlVqRlJxMEpkcFNERlJEaWYyU0Q3R1V4MmJPcGph?=
 =?utf-8?Q?a9LppdKdZVc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU5WMndFa1g0S3ROQ0RWb0FHSldQbWl3K2NEaVNWSWI4S05CV1ZobDlYSlFB?=
 =?utf-8?B?UEpSY3NabWNNbVRUMXBKVkN2RDRTeVFHQi9XVU40MGVLSGQ1cCs2cEIrOFNN?=
 =?utf-8?B?Z0FjZWI2NEJGczVHNThCMUNXOVdFUEtjQnpaWVZQYXh1NFIxSGFjTE84UEwv?=
 =?utf-8?B?NTJNRkRhMU1FV2pTTkJQTWVCZW40Z0lFWmpsQXNpMXJyYndJVW5LbWlFdXpw?=
 =?utf-8?B?amYrODU0WEc0ZUZMVjVEVEhQZmQrU0xZRUd2WThLQWd3c0FZNEFSSmJubnRT?=
 =?utf-8?B?L2FrK0dlb1F2Ylo2dW41dW9wbWZKcCtFVXNsUWx0YzJpOUZTYkZLOGtBTUxm?=
 =?utf-8?B?cjF5eHJSeS93b2c3ckdmZHZpRmtOSytUWWRBeFd0djk0MGErQy9OK1dNMVBm?=
 =?utf-8?B?V1dRdWp0SmpmaTB4UjhBamxGLzd3RXQrS0lCVUorYUVQUzRxS2cvSGdHUTZH?=
 =?utf-8?B?QnIwRDdOZzcyeU9zbkFrYTE2S0JHekMrV1d3SlYyaDZtR2ljUkxFN0ZxNnVQ?=
 =?utf-8?B?RERWTkEyd0V0b3orNTUwYzdkYm1oazFxZHFjcmdNckl6bHJCWjBva3JEYTBX?=
 =?utf-8?B?ZFNwUFFRQ3I2TTQ1R2RYY0tDSkFpOXVqMy9OcEl1blgrL0pHWml0RzdUcEls?=
 =?utf-8?B?TkRGV2RTMnZ1NU94Vm9mUDkvWkk5ZXY0UkVpend2aDE5M0QzQnpOdzdqTjM5?=
 =?utf-8?B?Mjg4ZWxod2pPUU9KbjZHZ1Jlb2x6Q1RwVm1ycnZoUFY0ZHVYUTJUVm5vTTNB?=
 =?utf-8?B?dVJCM1FZQUtrTzB3VjFzVjZ6WUtSVS81WnZqa1RFdVNjMkJUSndJNzRuZDV6?=
 =?utf-8?B?dFJQYnM0bU5HdWtNVG8xMm1rdi9HTDhGN0FPLzMxTW5KSEw4K29FUzU4SnRa?=
 =?utf-8?B?YThNU1Iwc0laMS9VRGlicVFLZHZjVC9aUXJCVXp1alNoV3VUQzZLUnhKV1pp?=
 =?utf-8?B?RnBWNTVRZWxacVhXc0RmbTcxYTlFVTVhRVhYdENCVm9IcUI0NWNGNDZ1QzVL?=
 =?utf-8?B?UlBlOFliWEg4VWVPNHFDWWEvSmFGQU9NZnZYM0FMWktLWk9DeUZobjJLTGJv?=
 =?utf-8?B?cGJHUUM1V2wrcXh2WnVFWVVrcEpMMVBWWHR0UXVHNGpmaE53L3BGUVJabWV1?=
 =?utf-8?B?K3A2Zm92MENjYUJHR1BLeXBaNGJiYTVEeGI2MFlRYXNyQXMyZ2VuNVppQTVj?=
 =?utf-8?B?UVVpdXRPdEFxMnU5MC9jVWNibWovZFZEaDd4WFdrem04S01yK0lJYzJrUWJS?=
 =?utf-8?B?YmhIbWQvNlB1QjlSN3A2NGFyNmZiRFpMUUljQUJxUVJnZXNZd3JTZy93ZGdH?=
 =?utf-8?B?ZGUxZ1FNWFBabzdKcWY2VmVzUkRId05zS2loQ0VnSGlOcytTU3poTFVGSitO?=
 =?utf-8?B?Z0p0NTNENm1lK0pOdGllKzhhV283OHlYUjRVVU43NEY4VysyTHVNS3hyb2hs?=
 =?utf-8?B?N0xOZTVFejloZ0xTekJ2ck5xWHdOeVA4RHVGSjU3VmdIM1k4dlpNUzZPc29u?=
 =?utf-8?B?ZytqOGxCRlA5a3JsajNMN3RGVFlodVc2bGhmRXRQSlJYeUpEcWhtaXphVmNa?=
 =?utf-8?B?d3hvUEZucWVaTm9sMmR3OXNWN0VGUERpSitKWG5lOWYwckt0U1hBR1RBaHcw?=
 =?utf-8?B?WFJvaXkzM3hnUTNOdDg1UFdhY2ordGFMU3M5MGl3YzQrVENrdUYxOWdubTNG?=
 =?utf-8?B?RUpCNnYyc2tHRnlhYmdSYndlWGJlN05TN2I1cEFla0Fma251NGFCY3VqTnJB?=
 =?utf-8?B?SHhVdE4xbGVWOGFiZjVzWS9iYXJ2ZWNmRTFjOHBieENQTjhwWFA3L1RaSmUz?=
 =?utf-8?B?MFppQ3dBUUhCMDFKOWRQc2JSWW5UR2VqQk5VeS8yQjlCSlhJbXBDWFcwNURH?=
 =?utf-8?B?S0FOZWJiUUdmaXBkUEtZQTQyeTdxbHRVdmtJQXZkSTg3UVl3L0xCRFVmcHV1?=
 =?utf-8?B?YlpUZkNZWFkwRk1xdGtnaDhVZFJ1VGhmOVE0dHZoZnpWTTVSaWdxVnpkZlI5?=
 =?utf-8?B?OEpSL3NvOUNOTTlNMnUwZGhlb0FMUjFGWC9FVmFhbmd0WTYyN0MxcWQ0WjJa?=
 =?utf-8?B?eE1JVWJQQmoyeFhtaWRHU2dLVjl6UVJhdTBuczNSZnpGVWF4WnRYY2g4VUlM?=
 =?utf-8?B?UXRoNjBSTmJDQ3VVUkx6SkV2c3VnUFp5NmNpNnF6Szl6YnpoeDlWU2ozK0Rt?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d3424b-c01e-4d8a-9673-08ddf6791f06
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 06:03:42.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anqFbFpX3OOywLA6TjLpKClFuqT9vB0f9mPCnRYchPkXjjjaTAh+qLPPb0Ve17LttLOLbDWCYV+WGO1TAD2uSKDWHAdRKvwXIHNnvvyz2Ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> The io_alloc feature in resctrl enables system software to configure the
> portion of the cache allocated for I/O traffic. When supported, the
> io_alloc_cbm file in resctrl provides access to Capacity Bit Masks (CBMs)
> reserved for I/O devices.

reserved -> allocated?

The cache portions represented by CBMs are not reserved for I/O devices - these
portions are available for sharing and can still be used by CPU cache allocation. 

> 
> Enable users to modify io_alloc CBMs (Capacity Bit Masks) via the

Can drop "(Capacity Bit Masks)" since acronym was spelled out in first paragraph.

> io_alloc_cbm resctrl file when io_alloc is enabled.
> 
> To ensure consistent cache allocation when CDP is enabled, the CBMs

This is not about "consistent cache allocation" but instead a consistent user
interface. How about "To present consistent I/O allocation information to user
space when CDP is enabled, the CBMs ..."

> written to either L3CODE or L3DATA are mirrored to the other, keeping both
> resource types synchronized.

(needs imperative)

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

...

> ---
>  Documentation/filesystems/resctrl.rst | 11 ++++
>  fs/resctrl/ctrlmondata.c              | 93 +++++++++++++++++++++++++++
>  fs/resctrl/internal.h                 |  3 +
>  fs/resctrl/rdtgroup.c                 |  3 +-
>  4 files changed, 109 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 15e3a4abf90e..7e3eda324de5 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -188,6 +188,17 @@ related to allocation:
>  			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
>  			0=ffff;1=ffff
>  
> +		CBMs can be configured by writing to the interface.
> +
> +		Example::
> +
> +			# echo 1=ff > /sys/fs/resctrl/info/L3/io_alloc_cbm
> +			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
> +			0=ffff;1=00ff
> +			# echo 0=ff;1=f > /sys/fs/resctrl/info/L3/io_alloc_cbm

To accommodate how a shell may interpret above this should perhaps be (see schemata examples):

			# echo "0=ff;1=f" > /sys/fs/resctrl/info/L3/io_alloc_cbm

> +			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
> +			0=00ff;1=000f
> +
>  		When CDP is enabled "io_alloc_cbm" associated with the DATA and CODE
>  		resources may reflect the same values. For example, values read from and
>  		written to /sys/fs/resctrl/info/L3DATA/io_alloc_cbm may be reflected by
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index a4e861733a95..791ecb559b50 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -848,3 +848,96 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
>  	cpus_read_unlock();
>  	return ret;
>  }
> +
> +static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
> +				       struct resctrl_schema *s, u32 closid)
> +{
> +	enum resctrl_conf_type peer_type;
> +	struct rdt_parse_data data;
> +	struct rdt_ctrl_domain *d;
> +	char *dom = NULL, *id;
> +	unsigned long dom_id;
> +
> +next:
> +	if (!line || line[0] == '\0')
> +		return 0;
> +
> +	dom = strsep(&line, ";");
> +	id = strsep(&dom, "=");
> +	if (!dom || kstrtoul(id, 10, &dom_id)) {
> +		rdt_last_cmd_puts("Missing '=' or non-numeric domain\n");
> +		return -EINVAL;
> +	}
> +
> +	dom = strim(dom);
> +	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
> +		if (d->hdr.id == dom_id) {
> +			data.buf = dom;
> +			data.mode = RDT_MODE_SHAREABLE;
> +			data.closid = closid;
> +			if (parse_cbm(&data, s, d))
> +				return -EINVAL;
> +			/*
> +			 * When CDP is enabled, update the schema for both CDP_DATA
> +			 * and CDP_CODE.

The comment just describes what can be seen from the code. How about something like
"Keep io_alloc CLOSID's CBM of CDP_CODE and CDP_DATA in sync."?

Of note is that these comments are generic while earlier comments related to CDP are L3
specific ("L3CODE" and "L3DATA"). Having resource specific names in generic code is not ideal,
even if first implementation is only for L3. I think this was done in many places though,
even in a couple of the changelogs I created and I now realize the impact after seeing
this comment. Could you please take a look to make the name generic when it is used in
generic changelog and comments?

> +			 */
> +			if (resctrl_arch_get_cdp_enabled(r->rid)) {
> +				peer_type = resctrl_peer_type(s->conf_type);
> +				memcpy(&d->staged_config[peer_type],
> +				       &d->staged_config[s->conf_type],
> +				       sizeof(d->staged_config[0]));
> +			}
> +			goto next;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
> +				   size_t nbytes, loff_t off)
> +{
> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
> +	struct rdt_resource *r = s->res;
> +	u32 io_alloc_closid;
> +	int ret = 0;
> +
> +	/* Valid input requires a trailing newline */
> +	if (nbytes == 0 || buf[nbytes - 1] != '\n')
> +		return -EINVAL;
> +
> +	buf[nbytes - 1] = '\0';
> +
> +	cpus_read_lock();
> +	mutex_lock(&rdtgroup_mutex);
> +	rdt_last_cmd_clear();
> +
> +	if (!r->cache.io_alloc_capable) {
> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (!resctrl_arch_get_io_alloc_enabled(r)) {
> +		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
> +		ret = -ENODEV;

Compare to comment in patch #7 where the same error of io_alloc not being enabled results
in different error code (EINVAL). Please keep these consistent.

> +		goto out_unlock;
> +	}
> +
> +	io_alloc_closid = resctrl_io_alloc_closid(r);
> +
> +	rdt_staged_configs_clear();
> +	ret = resctrl_io_alloc_parse_line(buf, r, s, io_alloc_closid);
> +	if (ret)
> +		goto out_clear_configs;
> +
> +	ret = resctrl_arch_update_domains(r, io_alloc_closid);
> +
> +out_clear_configs:
> +	rdt_staged_configs_clear();
> +out_unlock:
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +
> +	return ret ?: nbytes;
> +}

Reinette



