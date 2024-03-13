Return-Path: <kvm+bounces-11722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E26387A4F4
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 10:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DFE0B22014
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E84421370;
	Wed, 13 Mar 2024 09:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cU3lSPwY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D735620309;
	Wed, 13 Mar 2024 09:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710321904; cv=fail; b=ByOuPho2o5/uwS06wWkNDlZlANmig7+eWjOTxmLE/ACj3v9fX/RVouO4eKqEXyUXUop7KuD8wjnjnGcGIaM+lSjA4LzW5zOlJ/BY1FdZQVAVZ4b+FlBSuHKYijBLeiZ9OQAKAJUGEemscwJsJMCDNuAAxxTRjTl7xDJNiTDTJlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710321904; c=relaxed/simple;
	bh=mD49Ja4JpVuPOC3nYU5ps2n8xSywhGdHBz/zGOGoxXY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IQnw8vDQasAbm3KqM4qXbIYnzERcUORKjlAhjbVFqyUClmwzYfgcknpOB7L2fgiNYu71Ys96u0i2e8zStALrRkgf2Tbv/5j66sThHv8JL4SMOrcyPn7GeZda99OwbzpI/6zoXoiC4HO91SBpq7lgDJhOKenBsy3tcU2O/NCxy0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cU3lSPwY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710321902; x=1741857902;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=mD49Ja4JpVuPOC3nYU5ps2n8xSywhGdHBz/zGOGoxXY=;
  b=cU3lSPwYeam6omkrRvk0npbW7uHL+bN/WxnKfEPVYYe7O0yrFFWa55t3
   yxaTvMy5sk/vJnw8TOPiWEJJpyDoGU0jhj5pr32t3Ccj9KdZ6eIiX2slL
   vx8j+2Xm7ub5vNppharjtIt2iGxWRzXshcR19tQetxSFqNl4EHUkNYf0J
   xvdkY8dGd9rr43kgTrktRcoAUyFJgsME1gTxgKKFGLIW6uAFx3VGdD9iz
   OCA/VJOgy5x9gjsrxNEaLDQT51asuvYd9q6rhxv4/qdn2jv+nm0+kfBxV
   zc744KpxMRAUrAJtXWisuMt9MSaF1VeGvHqJx14EZA6f5Za9hEdaUsTJL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="15709902"
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="15709902"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 02:25:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="16430003"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 02:25:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 02:24:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 02:24:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 02:24:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 02:24:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfAMqxWJ7EQ68mcua9oOvzxJI32vrtEJ2TsKOsue9q8sQizM8dlUv5jXOYx2batU34m5MFQj0RthiFGOt5DKxV/sMCVX/cnippg2Jd9GRLEr6TO1Nc0LWNc4zMeXkygCXfkuFT5RAn0YG7vfxyLMAFP1PNPg8e0pu1DKwZDwd+nisOWE4c7mYtjgPAAQEKL5reRLtr4zjaESiJi8dLeO2hh+o/zXOZxhtp2knmYtbpJ/BZyDjJq/Txmo9XJ4D9NR7s4h7R01nJcjflI6P9OsfqCbu5IEGbwg3YfkA7FvfDXosfqhtgbR2GaQro4BkWZPWJ0z6ZGLwYIZOdzhm74uzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6XBISy4V5aKD/w/69mmzVgP77Orndogh95O+XVh5ZA=;
 b=CaCzMvgMWg2E6btYpGMnf7phhmdBA3xEv8m3gNMpFMjMfX9f2kANc+ADDkzpGqb/jpl0vjCyk7xstQIopciaaUY6A3FUQwVUunchRYYkMSgtFS7TTtF6qvrwN+sUbS1hpl1YUXek0l06Ht/VkPT8PYfUMmSpweTA6D+U1tS6MfYZA2LrYAS+RTQjnLSZNA5HDS2nQbrynnFCd/6AOm4qP5yZIxc/QU3SVL6uUTqyOlQmxVlH6rzTnXKtyhpFO3FeEpIghX8G5SWM9AD/rm2JhYTUwTq5lcM17y8Yul/YQFlniPQ7SUHj03P+N5t7pWgcmz1MMTrPQHLzFy+W6GINMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7914.namprd11.prod.outlook.com (2603:10b6:610:12c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Wed, 13 Mar
 2024 09:24:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7386.017; Wed, 13 Mar 2024
 09:24:57 +0000
Date: Wed, 13 Mar 2024 16:55:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Sean Christopherson <seanjc@google.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yiwei Zhang
	<zzyiwei@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZfFp6HtYSmO4Q6sW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com>
 <Ze-hC8NozVbOQQIT@google.com>
 <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfB9rzqOWmbaOeHd@google.com>
 <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527688657D92896F1B19C2F98C2A2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527688657D92896F1B19C2F98C2A2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f709294-a68e-4b53-db7d-08dc433f7361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cvNKt+waRNOMVMnIoz7HoG/cLqEbPgUaD0c30qH2EMAwRDS6RSLUQrMqj8jyT6Vd+TTGvy8Du0my6pFB/v20pFLmzHSujm0vTfKR8uIfgYjirAhs3RHevsbG8CEtJjaBYNWDtFskwAfQCsvuJ2oXrHvniEPvQpklOQrVaDkiliFwg0LNk10v0sPqi7g5IqhxoiI/TgkyIYVPlxZMjowquZI3LmXWS9Hgho3J8ONcCxo+D/TyvXc+tv8IiOi7+D5znX1GOMnsTZHQ0leO9QKlCYDvWpz2rD9fEfpMvUfF2KFekn26L3rw+9rmM9PX9ha6HFkFXywcve7qcOZ7R+tBOLblUXeuY09UVSXV39Qi3mIAHEr3wkAIWMz8YekC7DZvB7xrJBKwOmNcwcBsiZ+y1JEOqZN/bM3phjI2/2D6JIIJ31CMs2bSWc70kM0SQFaXJxsc0/xiS2BTHSe8Csi3jF5rjfNDjfjpge5FiAZfEppZnxiCjkxAV5RcM7lDp45+bY6vBYUhOA89DVzy0FzKacprZ2YMtR/8NYhtCvGy6y7c4qqhFqzbZhCRpKdSPKaDSEQkr/M7oGroyCO+K24LVVvNnL9HRJQHicTIQa5FIJy2fASnYDuqUvlf70izRDZll9ikPhDFwvYN5iJmGIJ19yVQ26PNfF7tqmxSewS5QM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZT4HrKQvW53Sp+cysZDaoYfshSnMOU781v15cQaHuGAOAWTSHft1D7cbW4rd?=
 =?us-ascii?Q?NfJYER7ZTrYEnRjTqHvPj3mhKJVXNQz88amsnQEp71ZG7SVLt6K3X5yUBjz7?=
 =?us-ascii?Q?ExvbdoNzLgud1Goj3dDQt0O61xjejTvkflFRCeexxA83nGUy5WKrBE9IfE9x?=
 =?us-ascii?Q?ft4cJewBP2TFDaobeKWbeDucmuzithYu7YG2jEooypCM1eFljW/iDX3UQ7Rf?=
 =?us-ascii?Q?ASaABep24GBOkk5J5aQ8llmMzgfQ112tJ2tPQqz0N7nJt/KgR6DJsiF+dlas?=
 =?us-ascii?Q?wvPoTB+T/lPxPdO1cquGwzZO9fi24tbwzFPeLilkz0LAlQ496OXvaBlw1Bvf?=
 =?us-ascii?Q?Xo0bz9dl1kg2ioaCY9+sfIhHDhovc/Nrvlvo/A0dW0KvpuOjUPL7OQnewK5h?=
 =?us-ascii?Q?nBLora/bLlLbNJCyqaXSB+XMYPdS77h7wETvcr5s2GLqjrtraIdVi0FUzOyD?=
 =?us-ascii?Q?5l91coc0fXZFvzUR+ebu9aAhuDGARXS0t/Ubdd0969QMbzJPvQBuWs427Wck?=
 =?us-ascii?Q?0pW4tT5UG/iDg+CHMy2Y+MmlP3T29wyOOYpg2GLThsWN5KOUaaZ0i8Dn2KVG?=
 =?us-ascii?Q?HNE7Z7a4sWUh2z6Zit1AsanMHbtCDW2qdthet5/uIoPb7svrK54a9nEFrB9G?=
 =?us-ascii?Q?stZggO024OJnLlfJxQDXn1A7LYqKJVF6JskgzG7yfcjD0dhfEmhw49tIOxM4?=
 =?us-ascii?Q?VKPUzIyvbFQTonvTE0lhesEa0Paq79w7i/aNg5nXfcQl7MMj0d597CG3S5wZ?=
 =?us-ascii?Q?cV+oZvjDEr0AQcPphOk3wSvt8VRRYQtf4TG3JFa1jWA8aGalszd11Q1xf9kH?=
 =?us-ascii?Q?f84iCCCVLn2eTb76XsaRSEO2WKp6l4yjDC84dZ09yrPxlGq5UrYsfJH4lVps?=
 =?us-ascii?Q?XXsh462F/YhDZXEc1ocuNwmIDM5FkQhu2bJ0ACFWLzPNXfPggp98gF/sXbk8?=
 =?us-ascii?Q?5szUcEuSfMFLJag0IoFueWBOT815ObA7OGr6vFpggJE+hNxZDx952IQZXmHt?=
 =?us-ascii?Q?qXkj66H2pVSklP0qMRGvsgGSLWhyZIVZb6Ii9Mp/8ShIX9g8e5E94kfxFanr?=
 =?us-ascii?Q?KmjmzLnQ8hCx87MLBbhaAsoGxurks6IVCwP2GFzEsK42T9M1jAUJLPar0y5W?=
 =?us-ascii?Q?to/9Ci6PbI11l78IC3/eg5ig8cAUYRyXrQstgWe9KrSpVb2tQJu9IJMaucz4?=
 =?us-ascii?Q?vjcdNYFpv8gAXsCV7ZeblshZrMZEzza4cGR9poo2HH4Gua7x51ncm+xHm7mD?=
 =?us-ascii?Q?nwkbYDHoHKEjwQVx1CgaQ6nUFpBpHmBA9V5Y8FWjiP+i55mCpegzDOaBaYS3?=
 =?us-ascii?Q?BlLVfmmVHNwApJMJjc5BiyMJg/UOawNovzsKW5HriZHqmobBN3gAT//ZplW6?=
 =?us-ascii?Q?ldGsT56SLwZqQh4mdE7E5oEtypnER9YtFFYp+d0eaM/bWGYiURhAYVMGWLzp?=
 =?us-ascii?Q?GcBRTfLSClNen9SsdH6f2CUjUWHWY4Mkimi1jfV32MhH1Wd0hUQiA8IGDVRp?=
 =?us-ascii?Q?05XZsrIFE7TD/68nQmty2u1vNCbG0QrNWqrqDTc3RyOP15fFK7Bg1xCCyrZ5?=
 =?us-ascii?Q?Am8xrRNnra8b+CEtIIoYGwdwARON5W60S4WAV0Cn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f709294-a68e-4b53-db7d-08dc433f7361
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 09:24:57.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuLfZAXFtuS5aKV80mFSKkSBfM+IRZNDa6VqFfPZWgYDdUmPREgFgBi7QqKPI0vkfATGubqXiEa0o8YbYuQ4SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7914
X-OriginatorOrg: intel.com

> We'll certain fix the security hole on CPUs w/ self-snoop. In this case
> CPU accesses are guaranteed to be coherent and the vulnerability can
> only be exposed via non-coherent DMA which is supposed to be fixed
> by your coming series. 
> 
> But for old CPUs w/o self-snoop the hole can be exploited using either CPU
> or non-coherent DMA once the guest PAT is honored. As long as nobody
> is willing to actually fix the CPU path (is it possible?) I'm kind of convinced
We can cook a patch to check CPU self-snoop and force WB in EPT even for
non-coherent DMA if no self-snoop. Then back porting such a patch together
with the IOMMU side mitigation for non-coherent DMA.

Otherwise, IOMMU side mitigation alone is meaningless for platforms of CPU of
no self-snoop.

> by Sean that sustaining the old behavior is probably the best option...
Yes, as long as we think exposing secuirty hole on those platforms is acceptable. 

