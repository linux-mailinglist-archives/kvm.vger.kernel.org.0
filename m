Return-Path: <kvm+bounces-40567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F190EA58BC2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8537A7A3F99
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F741C831A;
	Mon, 10 Mar 2025 05:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dy7PUQRO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A499184F;
	Mon, 10 Mar 2025 05:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741585997; cv=fail; b=TBAILfUN0Tz379UI+GHTiLhV5B5bOfQJPp93v0ncR6gTehZKNR7PE7kLCFrJjwlzc7VGY/oXEIZz1U9AILvf4wdYRBk/J2HHIOxHvyxZ8mGrFWJCHkMTG2JWYOwW4Ej0WxVsX+MuN6MU8bxo5y7Omfx53iF5KggfFqaBUczvha0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741585997; c=relaxed/simple;
	bh=UTb8gDUkeJ1E3QeLTkAwkTsdLDXEDMHqvCctpVk1DSE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jwFbCHfG96fXYtOlkpF9psfc5Uni1ScYKX7nL4nbQPO9s8XtlewMaHVB+lRD/xi9R4C3zdVAc33Vo6Ba6ncd/M4M59f5Q8ysWbNgSfPouLsdsXLjdwQDyWujBRBppMntU8ivqrhbdJGJfn6A2zeSfy8z5xLIThovBtKqDk5nA4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dy7PUQRO; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741585996; x=1773121996;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UTb8gDUkeJ1E3QeLTkAwkTsdLDXEDMHqvCctpVk1DSE=;
  b=dy7PUQRO7kLCvOwVx98xrx7WMdXOolXrUyClrpFVtr2YM6yemN7q7Rlx
   Jis9U7WfyMwoemCWJJFyaYnxqPwlSVN4IV98s3qKpN6jKdqa9FcDVakDp
   2sfjEBbZ2zAPS4hTb5twfPhuwpzkFHmuxnKC6mlmIOjgrrqxVcQH0TSrr
   Q5HN3y3om4ZFREjZaCY+z8PzivMSqZ8k9MmkmRZOpqCdYLqV6s+wlNX/a
   CWx1HtH6IpBTt3fHdzVCnXs2ooeLVHSQcGEk3J8JfXAsjiBYbUOVRVTUQ
   GOotAH1q9VK4l3+sY02idIwWPL3yPCg+KLaWoM86MDzaRoKoGZuAAMWI3
   g==;
X-CSE-ConnectionGUID: jK154x3oS1+ArZWmpK9r/w==
X-CSE-MsgGUID: jpG+b8ONTQWfVehWhZFL0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="65011713"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="65011713"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 22:53:15 -0700
X-CSE-ConnectionGUID: 7ZAGnedyTvmdRCAnU6FfCQ==
X-CSE-MsgGUID: rehFmPaTR/KZ2cExIaTffg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="119737509"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Mar 2025 22:53:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 9 Mar 2025 22:53:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 22:53:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 22:53:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDSJMdYXyEoS6soM7veuoR4xTPU3u7b7RhlrS2TtWBiYEpE9ZTIJzXrmKY10OQs6pk3+tocVWZrgZufB7iTjATC0fLjp2BLr16Ql6AJH+BQWK1DoEXlNXPJkmEg6eszcfEpB8+UXIGBBc45exjrVIkG+wWhEVY9y04BcDo+RDdPdKD8J0l8oRNsoMUamatAOVvaAY9a32DGO4Gx8vZDj39jwdkRcJKgu//3DaVIuXsn2kQjngGDb0aY7v3S1cGAJlNY/1MFUnNOHBzo/jet4/QroTyP3nzpKKgv5fT7/kIH1EBOvBF7axlwkoedUjuFppV2EM+7QolRB6U0KMBqDnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Wij7ryp3q+b2u4Gq60uJCH2H+BfTWnZOne0dzedC1I=;
 b=lQl7hbIp9Jf+lMIU2lg1r0itMMlcv96XZDeKhdIeHVZv3mCwB+M0pxuARRElQeU9q8HnVCQwXgf7QVY1eHHiD8xHFvPDH9eLKAngoym2qzXC/XsTwXHRs4eoS5UQxg3x3oYdk4G4bgG6QVxQAWYcBQ44rK2ULqVz6L4DAtNxTxABvTdyxqTTb1pvIniDglh64mNZ85azwH2PqdW7ItPYsy5+F0awY41BNkU8v/ud7uJtvfEEQPfvt1WlODMxiKAhgfOsGTp9wGHeetL+AyxCu3+F5bX8mM40/whEclVrruS2EP2M+HK+E9CHU+hpgkcUIe08qrOS547VS+/w/tT60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 MN0PR11MB6058.namprd11.prod.outlook.com (2603:10b6:208:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 05:53:10 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%4]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 05:53:09 +0000
Date: Mon, 10 Mar 2025 13:53:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Message-ID: <Z85+PPhKnkdN9pD6@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
 <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com>
 <Z85hPxSAYAAmv16p@intel.com>
 <7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com>
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|MN0PR11MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f7474d-a38d-494a-fcfd-08dd5f97d641
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6fdBvlHkGThvlBIkL1wTKvfUVPX+I+/ZnPap6qONeroTbxmEPiKgLYgwe6yL?=
 =?us-ascii?Q?rjxFRCw4VzoTukLA2TZU7JIdMsbzyn0zLRdQm5Zbz8rUTH7xdpglZ5rkgPGX?=
 =?us-ascii?Q?0O+9n4v/MN7WyaqueapPjaLDXxM4LOaZ/vUZNO6LoiW4YEAlUKKigr/30Rkn?=
 =?us-ascii?Q?DcwurBgvp+9aAdaEPx7NHDwDWsZbNYNpWUU7Hj/ZyW7WTMMRZa7fcsKOe8Fc?=
 =?us-ascii?Q?LUwQavFRflXU04svJIf2nh/SWgwZiJN/T4sALA6uuoe3B0kE0tlSItxv+PF3?=
 =?us-ascii?Q?0kmfOdlw8nwyJLppBrOKezq5lLC7wXFW29jtOAZ8UfnIpSiFCCej7oPh3rAP?=
 =?us-ascii?Q?xD9VVyqCVXh1+2HlFicx3neoSQCSX3jrtHlFME6ITFCevjxvUNA8Y5d9ZxtJ?=
 =?us-ascii?Q?mnzhQ9Z4tfOnxxcpJ783ze7Rk3YjZF7QJu7+hB/n3i0WW6FHJ9ra/8ZwC3Xy?=
 =?us-ascii?Q?KUNMhe8VGTB8BR/nsDQK/8g4qB2lxl7lUqfly1XnaHF4md8MvXMHT0ob6Paq?=
 =?us-ascii?Q?34Xi0bQ1S0hzp/AjCTT3PbKc1CED7ndtaHicjDO6CErua5iVszk9DmswL+BP?=
 =?us-ascii?Q?FbHoJlqu1yZesUeFRHR6YFG2XcfhCW6mwJiOYSJra3TLv2uwFaMaG74cpkiU?=
 =?us-ascii?Q?1GGwa/sTdQyYU8O0Y44lIvEH+7Qbrp6g/toM620cp+ON4rBI/0iQ90HQACxv?=
 =?us-ascii?Q?FJYDLgYJBtZoSVImICDpThhN/px7AdP3mOqhV/HxG5zjVqjHdhp7u/s60mWV?=
 =?us-ascii?Q?nRXnHUsm801XLwVB6a/s/K0Ot1qyQTGxId+lxIntHjHV0rkdutuesm7NPo+A?=
 =?us-ascii?Q?6EthxA/fvpUykVkK6Wmev7YQj1R7TkRdOBmsGwT/Y9PNK1AL7ogZRxJcmIyB?=
 =?us-ascii?Q?YoZWaoTKLRdr1pFXV8v54b4yyLVDzyin7WACSTYW4LE8satstHw7mxsCTJfL?=
 =?us-ascii?Q?yeYbD5VAxOMZDw9jYc1vNcE/GmXCmyr1M54+x3guqgFwaFk5b9JTPXfR8DxA?=
 =?us-ascii?Q?eG2b7DINuiuB04b6Pa6j9tlJkzkrOOSCpo974/FcWO87Oi2veQD5hixGD26K?=
 =?us-ascii?Q?MKoHuXp/t5RyKKXdRfPPCF6A9hh/elLP7lwYaRBqPux2guNSiAAD3Og9Y9O6?=
 =?us-ascii?Q?03kvWBACje146KhfJTxZR7vpmjnqnq3CpJPN/0NEE3+RECAj3Nc7REfzFi7o?=
 =?us-ascii?Q?/IZituCe6GppONPO7D45tgjNUNmMGllR9ruwOlPsGjOS1R+NbUDx+Oczi4x0?=
 =?us-ascii?Q?f9XVJXTFEYu1toL2GXY6xEAk+FcJD7lxdLUAHEp5wBWkRNNEWCdLL8nS44GZ?=
 =?us-ascii?Q?+xWy+2yY9udozy2BzM0tSLhQoEt86zuuA2QM8y9edP8w5fH0WZun2QD6vGiA?=
 =?us-ascii?Q?s6Jd8jFr0Msd6tIKjfLXBHC2ZL28?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3o4pKA7sQyzeUmJDEsg94PV5e0WpyPugrCGsAZXB+ujFcG+QbJKUmTnRmh68?=
 =?us-ascii?Q?bU1G1H0UnABuw90NWwb2QD8Vf0r9sAuAtz69ofLxD4jkHW5XNe6P9yqNtqgk?=
 =?us-ascii?Q?LjepyRDJyV2+ow1kwuMYqhVXL9jpB5O3E7UW21YR2zkUEXHtiZ9oDuCP63L7?=
 =?us-ascii?Q?G3g8BxDTSnPMqPL+dVppeIzzC7rInXa3WhKmRkpt8yIwaUFUzbjRcwrcNA36?=
 =?us-ascii?Q?/SzQetL2hlS8WWT1GOwUkqKS9o2AosXyd3HoblSLR64ZusZXxeGzBTGPJryQ?=
 =?us-ascii?Q?1J8P/qo3oxBRcsjYy8LfoQMR2mw10nZYWI/z7v2CR94hx1V5mpDXTATKOqar?=
 =?us-ascii?Q?aw+wS2ZXr6+tHzcwGq7CS33X3z2OjRT9Wq2TRrb8xPdAGvqgBAwavJrpfGEV?=
 =?us-ascii?Q?DBPnfleSP7gnlC7ZZxiUiAozlWX9lLyy2hcIA0zWVBbyUrfnHWDRxPy9FITm?=
 =?us-ascii?Q?m54fG1nCk0GlXfH4cnkAiaLphj7cslw7w9g8Tzh95EJ1U+ZGzIrlRK05KDFB?=
 =?us-ascii?Q?wQAm71Jfs/kB41ecXROUwIG7OUmsSwrG4Fu5oApmRbFxsZgMEA0R0GVa/17J?=
 =?us-ascii?Q?DSkZeGQqcXjYcEkEs0iRJ/2bqmUdL6RQpISkaxeyg8CZTVPYLYRV/tgkspw4?=
 =?us-ascii?Q?q5aWmhSJvlj5By6H4Knqln4cejaomEK2nSsQPXwZseHtoo0mhFFq23SI1de2?=
 =?us-ascii?Q?nq58PkDEdmEBMbNeEltLvcIW4duElPmXmI//wJCMdumVmJThbveiZ5rUECf2?=
 =?us-ascii?Q?D1Ppc5+mLVYliuly2HUW6wL7CU/4FuqH/Z48+age71REsJuWG26tdWlPWX/T?=
 =?us-ascii?Q?f2DoyLgOmAAC91ZZ9nKgrBEKyUw4EKhqaTVbVxHqQF/lDA1oPZ18NLd2aD4p?=
 =?us-ascii?Q?ip06Mt5l+h+D4WOtNSh3bA2j0fqic5K1eHWwbAnv0uJ3XBBUgzmSyZfglc67?=
 =?us-ascii?Q?Qa5ufVyvYH0NnwLjnIHzS9ENRXFKd2A84/c6I8utqtKolknVQDXuBD7tXbDN?=
 =?us-ascii?Q?TGjKm+07D9dKEmjwsImVzJo45qYVaUWXRSiguAKypYF02C2USdf5JgYCnZbQ?=
 =?us-ascii?Q?0gb8TmwTCk+CCToZ6Ao79fU3zuRSdk3Zt3No7Nq76IX+WYxpKheptOKKtUey?=
 =?us-ascii?Q?U1sNDhAgs3pWe/1FiyuT6bgZIbfi7sU8d4x3ISk33XcLh09+32INfDxX740R?=
 =?us-ascii?Q?rC7YZkSBn8o1zxGTjrZRaItrgTZNykE/fxHhf02wf4XjiYYx1gnCCCuizmJQ?=
 =?us-ascii?Q?4CecaGQhw1iOZS8ce7pn+Q5agqBfkvs+HuTBqTcIEZm4xKW306v9WdQWlWMs?=
 =?us-ascii?Q?a6uIaaPoGC02/kKHXMkJZw4obTXJLB5dAwP9vMCCAYONO8AMVGM5b6RmxwG6?=
 =?us-ascii?Q?8gLr1pMH9zoNQdvXFQrkaCE2ighKscAZcBWv71FXI9MHPrwBbg68999XBsQJ?=
 =?us-ascii?Q?E/FsQjUtaS6ccx8MMv5P4qfCuf5XNfUxZIgJs7ZnTptNWhuiA5MQnTNEM4Xz?=
 =?us-ascii?Q?cmA8PVyOqvgJh2j0QchSHKYiVXINz+gEvWQfUQ80u/OC6i/rThhNX1V9JHAW?=
 =?us-ascii?Q?yIAPLgAhLiYpUTlQg6LPsTAkq5Aoj39XlDqHK0+d?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f7474d-a38d-494a-fcfd-08dd5f97d641
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 05:53:09.7618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +HZ8Wx2UgzLquhL08eFitFkZBJ3wHwK4PEXHKOtUARGGXRb55/Xc2yGEsx9EBBxebl4PNoJyA1mUKO10usQS+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6058
X-OriginatorOrg: intel.com

On Sun, Mar 09, 2025 at 10:20:47PM -0700, Chang S. Bae wrote:
>On 3/9/2025 8:49 PM, Chao Gao wrote:
>> 
>> It was suggested by Sean [1].
>...
>> [1]: https://lore.kernel.org/kvm/ZTf5wPKXuHBQk0AN@google.com/
>
>But, you're defining a kernel "dynamic" feature while introducing a
>"guest-only" xfeature concept. Both seem to be mixed together with this
>patch. Why not call it as a guest-only feature? That's what Sean was
>suggesting, no?

Yes. I agree that we should call it as a guest-only feature. That's also why I
included a note in this patch below the "---" to seek feedback on the naming:

	I am tempted to rename XFEATURE_MASK_KERNEL_DYNAMIC to
	XFEATURE_MASK_GUEST_ONLY. But I am not sure if this was discussed
	and rejected.

Thanks for confirming that the renaming is necessary.

