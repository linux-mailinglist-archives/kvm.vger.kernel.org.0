Return-Path: <kvm+bounces-58356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E25B0B8F380
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C40F1730E7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA32A2F0C78;
	Mon, 22 Sep 2025 07:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADdaJDxx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408631DC994;
	Mon, 22 Sep 2025 07:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758524901; cv=fail; b=ANV61qn16d6wvHD1TMCj6U4sWtch81bclVnQHLPcqUi7aLZ5xBW/+wF4gSoH7IYpzaefL6972U2SCDyBJFtDrM3D1qJ8UxUD/SAyUa5JdLFtfNJZVc6bkkPpVvwfX3zmhwlEpc10fnd6gMCeYggoK4QHZrBiOFwrP2xI3nP5i2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758524901; c=relaxed/simple;
	bh=ulTev7yOIOt6dWMNOrOcwO3lhflxmNprujI0MYqlgIQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ndr6J+y824aAwdBq4Bg6OXv/88c2duaeF3tjjFuXBE/dzzbTsgpweY29ObhsZRDJ1Esoe0WZ8BTTmpLFaxWbnLIzRAMaybvGJAK64vSHpnPV/9fRpd0MlIAP7AJlR8sHHftIAkQLvtJN4UywQs3nlphc50OzAr2YvJD5yuYdzbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADdaJDxx; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758524900; x=1790060900;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ulTev7yOIOt6dWMNOrOcwO3lhflxmNprujI0MYqlgIQ=;
  b=ADdaJDxxkDcfOXwwlftTZsWEQAA7lGG2vsGhdDKjueMW7NjRv1jaeoRw
   p1xsGoMDmNjV6UL8cSRRO4lHUyLrFatWjnj6DX1yt1rb75IeZkJiMssZG
   LwIHItUYKD1hXG9JA8l9NGqE9pTbtbe8nFNMbvUxa6RqEz74dYcl6ugNh
   OryeXb3Q8cnaEo/A9TqfS25PXSbgHVWNL97OIhjXaJHXGVS60wT7HWASF
   votparh+ktc3sOvyA9sGODGxNSVTA0ZBb5t04N3I1WR1NqolaRIn218uv
   DfKq+ncW7fD9cHOB9aOrFHYuTgYkLhEm2TMCiHq+9/r2eseew0tUeOyCG
   g==;
X-CSE-ConnectionGUID: q1xHEmsWTkGD5JKMDVti6w==
X-CSE-MsgGUID: lBj0MLlnQYqTpRan4FcxyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71406011"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71406011"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:08:19 -0700
X-CSE-ConnectionGUID: gQxpeaVATO2VCnvprhLrww==
X-CSE-MsgGUID: 3CIWEaxvQzCXxZDHdF22CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="207369647"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:08:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 00:08:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 00:08:17 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 00:08:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DAwSL1KsNA6RRbxyJ+38MMaiixM2pgADEx/NdEW/GzKevbWl7peXngLOFZQ+LwssFnikBFYMCT7QA5LRPpGq86ndwCDIYzphaI63pmDxvPhZvfKF7Tzs8Qrqtivezeg0f8ibcs9nkTqc4Kn1AU9OrWxnYu2JK+v4IKmD9/QiLKs/sTqHQs5tGSw5uHe8NkmYxPQ9ZdYQV6WH6IZ1T3rihuYAVUp5P/Q6srVH5H+/rLzub+Ap1AZIbRgNfYofH/SNTsPGbCnjlvFEWm4lVSJiS3pNPYexjjLD/ckAdmZdTSQ6jBrTuZjmzd2T7uhNMJByCBPOMRq900dW0JoPBQ71Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXZr6T2moBoh58ruSC9l1vN4qG86E8sv2fNkwFu6g9M=;
 b=PajSI/L4ptngENrIS3ZE8UEEK0GlZVAruUBATd3nELq6Prd/ODKHcmR0b91VtLg2X+MDmQTCINs/sW+yHJDuGUdAGecukS4ro7z7yh4/LariHgVRzZR+AyOGe0W5Z5DpwWcCJaRMHR2KOmFRjw6uThGEUXaQ7l0b7dvnCudu6skRn6+u8tHljFuqphMi4w4pmfHZPrqmQxRqTMnvVYnRCJZQOzY88RwwcbtT6ty3KxGzMpg8twNHMZICqmFnuTV6RiOBdJb1Hes9TXLnKJ/a9t/HEbAKAXv6maGUvrHNu9eFsvocSiMV/1bTbcoiON2ePb5fkIn1lW5iM4dmf9rnag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN0PR11MB6035.namprd11.prod.outlook.com (2603:10b6:208:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 07:08:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9137.012; Mon, 22 Sep 2025
 07:08:15 +0000
Date: Mon, 22 Sep 2025 15:08:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Naveen N Rao <naveen@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Xin Li <xin@zytor.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 2/6] KVM: SVM: Update "APICv in x2APIC without x2AVIC"
 in avic.c, not svm.c
Message-ID: <aND11RilfAPJ7ud6@intel.com>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-3-seanjc@google.com>
 <i4znbv2qka5nswuirlbm6ycjmeqmxtfflz6rbukzsdpfte7p3e@wez3k34xsrqa>
 <aM1mVMXptK-sko3f@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aM1mVMXptK-sko3f@google.com>
X-ClientProxiedBy: TP0P295CA0013.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN0PR11MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: 329da57f-7182-454e-b7c4-08ddf9a6cc91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?v287tUKUE4elO1c7loKw27RGu3/J2Vr28PYNBsTL0ua8sel1ehVFM80NfJeQ?=
 =?us-ascii?Q?VtoFoyXf4pPwv5MncfBiQEdqVs3azc0uwlKC+bh943MlIIKLTMIbpU3B5d5y?=
 =?us-ascii?Q?kCBKN/Td9e3mOFVOyDJ+ao4xpkfd8+sjGbF9OHhlrYfLipNxEIZKeJp1P9h1?=
 =?us-ascii?Q?xSlKEk4AAA5LSx+SCT/Firr/BniwN8JLhGhifgSegyaZsMi7YWSpMu1XwK3r?=
 =?us-ascii?Q?HMxy4xZFOJ4kNXvyzNsYoYpzoPkqJEpxnsHnxC8gHfw1TN7cTKHuNICPUKpI?=
 =?us-ascii?Q?7o6eYo9Ko6CG+90ooWSIUHUVjZzwOJXr01Rv7xtjD1McmX14iSFvnZP5U8se?=
 =?us-ascii?Q?+zkQU8BQhP0TFF6iB6OuQj2F2t4FEnthPiGXSidk+CQ1bIpaFqPIcPqQbGPg?=
 =?us-ascii?Q?yM4+ZtDrohr8Q26UpzjHLJALNH71BY7V25ynvNJVW2b4m8RPCFsnesAPwfsR?=
 =?us-ascii?Q?Ec6L5248tPdnioBhu1iiM14IFf+ZZGBQpT+RH0G652mWl8eJQQgQXExczyCT?=
 =?us-ascii?Q?PrI+lBBbkSxIjtSnNqhibbr4Temf7wYAJe9VBUZpxAt35/qvRYGSNB+4bE9n?=
 =?us-ascii?Q?rtARSsp4alP0IYKjS75yibMf79XbxvVnELxYawEeVbmGIgm0Euj6LAdXhGML?=
 =?us-ascii?Q?RscM2byfyMAR5BMN2nXsi6QQnLvQ/2CaCPC+tGwnO6x0zIlHvgkBW1oNLdSC?=
 =?us-ascii?Q?jHbGNv84RZU9hKc8E3D6s+/T+aFp+mpN8cPIpHhAdFjWz1DyES+cFm833yUg?=
 =?us-ascii?Q?6dtQFgyHEzqoV/mxLshWac0/wy2j9MtoqDS0851uWUpG35GBNP71srvqWGlu?=
 =?us-ascii?Q?H01dVpQRa0/wyt+C4jsD4oo3R/U5YtecIPLxh7ZLkpAZJz9jrZ96XsStin3G?=
 =?us-ascii?Q?r+EPseit5RZxDR3wZEz8vr18b48ZPth5lYwM/x0u8RZBj1x88j1KPiuasqkd?=
 =?us-ascii?Q?EWB8qbapnQL9wy23seP8sVI8xDY3UF7H1bD58WptGzu4DClF0qs7goCoHLhL?=
 =?us-ascii?Q?BpbjWmY8RfZ220OMMezcN2NyP0Rplb7cxdK3BS3cyEhFt0nQnJWzVW4+k4oO?=
 =?us-ascii?Q?/4VsuT1xCy6KkSGQ/s0+Zvbu5R8MUs0o+/HABjhFOLa5CJ9nOW0SqyHnfGb2?=
 =?us-ascii?Q?xmjFnSOHVBnElG0R399qzMwB8jAwQCGuZ6L1HPXXbChlQ75DhMCHEKsZ081o?=
 =?us-ascii?Q?7ycNe6ED4Ignfxe3d0Tn69rey2N2hrZ81e7JbNNd0UvFveqw6ihchHcssnuz?=
 =?us-ascii?Q?6R800FJ/J3mwB0zQVMwahwMBHaAfJ0cvebW9uBORvDP2aaTvlgKXnOjIs8T6?=
 =?us-ascii?Q?WLhloNXpjUucJ6tOsMMYOPxPBI7ygh5Bl6dU10cLFub/sD5SpQBXEjI7p6to?=
 =?us-ascii?Q?nIWfxdAP5wwV33Ed7XhaGr4ZlJqryfjKkp5nP2kxewYUvEgT14jePDNKd3Eb?=
 =?us-ascii?Q?MNCpkVnYiGk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UuEcm9AEFQJj+H+5DkFUq9KJpICD4QKEjv3AVLHGXMIG41z2YW5rdWUh07kk?=
 =?us-ascii?Q?DmzEJDH2zvOjUJQB4sg5TXq9WW3+gGcR6nk7r2WMEhGxn3mMVXYIJEtjDZFx?=
 =?us-ascii?Q?lPgH31oTne6rb/OYIMDO57KxCJQGAKsLtgEr4iwJUrUV+pHf1qiFgYlifrRt?=
 =?us-ascii?Q?jlTmVYrW/fI3RudxIwx7DLo86xnKw0dhnEpSlSN+hE/D/lVO3bufT/OWQkXk?=
 =?us-ascii?Q?jnUjLEWVUZtLGOiesZ073/QmxkdeLr7cU1lSvatTtIdkcRCtB7w45OoLYNCq?=
 =?us-ascii?Q?POQRyKg7izzpVcmRXxnmZDlc2krw0JQjU+mPV41IpdV0Jma2sEuCacplUpHz?=
 =?us-ascii?Q?u/Lu3bcrE1la6ESZOOfrMLUWAmOAPcvaeX31YDVWfm6NOtdroe/fxXIri2Ii?=
 =?us-ascii?Q?rqAlr2yYsqsnTX1obRbAVVw4Wj2ZwTTB6RF92N0+Ri+b0U/iPXUNWGTgcef2?=
 =?us-ascii?Q?RLbxdIcv0bmVPOUwQL3vnZaqQ/G7zutjQfDxQ/a4WbvY2XogtUNhqI2yCbGg?=
 =?us-ascii?Q?cjaWGsxycPuancR7xdrJhmHwixRNGq0J53L/EsMT6aASRWWbS8DTIRs+X5UD?=
 =?us-ascii?Q?2HuEuA10FpG6/QcdMp6+r+aYfPgZu4KV48Xu1Q1nT8yQOFsH3Cm5sal3nlU6?=
 =?us-ascii?Q?pZflwOVeAqfYHnvjCgmm43NwYxNtBcMQOyE2sZ1p2PPmWT9p+0i5KbQZIBqK?=
 =?us-ascii?Q?W0NxWwFYgYMFVN6HW9XyOlro5+L5eY/bIZEctzzkbFCud1S2AEkWTCKvkh7+?=
 =?us-ascii?Q?IfKyw6kLAsrf/5zQ9SA3iIRnKgNk0j3jVYB35EoxTqASZ9BMDunFvyOmbVrY?=
 =?us-ascii?Q?fvqneW3TofDgF/k2ONqzCzv2S9hciKBE9fD1YchXzza0MJVc3czWw25sew/5?=
 =?us-ascii?Q?MfiwUu5pC7hQ6KqGuZHWD5B7NRL2VQTofYn/JmghQQE0aqQqW7aTrMoyT6wX?=
 =?us-ascii?Q?nPDz/JvsZJHNP7EFiiqOCO6TdIFUb8Lqc0aFW5b6c+W+uM+Kww0oTluVhbVr?=
 =?us-ascii?Q?5Obu/iAFXyJjTCjiFGv76binQP80EFxYGxQ9yVkfWE5el7UfZUDyiu3EngsY?=
 =?us-ascii?Q?9mo2w2dSlg0wU3O1Hb4nmufmGjEUUsQA3B6ZCJrxFqmASVyHwaZcToDFMJsB?=
 =?us-ascii?Q?ui/cOf7ejOa7DJZrsoUt467oaaF4pwK2+qz4mJVALjRQ1JGDcBTB/auFSunk?=
 =?us-ascii?Q?1vQe9epq/C1rbUBh5WPkW7+v/shFbwLsu9iH/nBwa+JJ/9pRkF/REOC2u2/B?=
 =?us-ascii?Q?9pnrDMfHS1078XtS09LTyWzhF5cipXcoUn4q34+//+KEjopqt1c36WC4C6jf?=
 =?us-ascii?Q?Rl5MseLq7tgJITra7PS0hjGi1aU6USSStqkZKyoFD/xaTF1vtOOk9z7IR7Cu?=
 =?us-ascii?Q?/OMJRQOzVWAtsAyScaDCeiz6A2MQXzybfCQUEdiCl0eBIerT5OuBCDZkJSwQ?=
 =?us-ascii?Q?3JV2K7TldbrmGSzTRxaxCSWwACYpWpCFPvYXydeF6MZk3sYjAqMl3+VGefBP?=
 =?us-ascii?Q?1akDnbsysGpy4Lxbvjn01wwP1MHcw507rGUK9VRK0HzwakfeqpyR34eC2awR?=
 =?us-ascii?Q?Vyt3p9Zbl9IYoynCgIYZf3FqBgfQNcSgfapPoF+4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 329da57f-7182-454e-b7c4-08ddf9a6cc91
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 07:08:15.0298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QbnfC/+EcVUo1ihzXTLbKME5iDB8eb9G1afbUqMGX4ma2D3zRzmXhvo6ZBm91ZWv6T6s3K/+ftvPVvDF0/uiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6035
X-OriginatorOrg: intel.com

>Question then.  Does anyone have a preference/opinion between explicitly passing
>in ops to vendor specific helpers, vs. making {svm,vt}_x86_ops globally visible?
>
>I don't love creating "hidden" dependencies, in quotes because in this case it's
>relatively easy to establish that the setup() helpers modify {svm,vt}_x86_ops,
>i.e. surprises should be rare.
>
>On the other hand, I do agree it's helpful to be able to see exactly where
>{svm,vt}_x86_ops are updated.

I think passing in ops to vendor-specific helpers looks a bit indirect as the
parameter should always be svm_x86_ops for AMD or vt_x86_ops for Intel.

I slightly prefer making {svm,vt}_x86_ops globally visible.

>
>And most importantly, I want to be consistent between VMX and SVM, i.e. I want
>to pick one and stick with it.

