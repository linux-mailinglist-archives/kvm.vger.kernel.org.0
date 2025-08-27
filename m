Return-Path: <kvm+bounces-55872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83675B37F35
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4596A363466
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFE82F548A;
	Wed, 27 Aug 2025 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNOJDynm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89225B1DA;
	Wed, 27 Aug 2025 09:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756288184; cv=fail; b=qsLBlqo+1zT2K6ye+Jsx8pfvGQfoyc+Uj8/Cc/M1B3+2CKnndcYHXPCHhGrxsSIiEpBf+Le0iOlisOrm2l/gQ4rPsHnz1jA3YqUS36nEs6JPysR8kBsfyEDCzoJeBoB/O6Iybq0Z/1NWA7Eal8FLydHt8mydWDmAe7lXEvmqO0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756288184; c=relaxed/simple;
	bh=a00b3HscbFj4tc+FKPO+Kov7AB4/N5wDR4tBT2O8+cU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BG9TNZflccwZM4eCfqEVssAnRoa5llQ11xuegRWz54u9RA+w+fxPUfPodALT0GEzLNYyq18aZw+1zB6eg890GttWjfM1sTFkabgVWPuDidJjTzTqNNvvBbr8vG8B31+GXqb/9S1rs+C6oQfaIaqs82ZCJnLpjMy38g7IcMRRivU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNOJDynm; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756288183; x=1787824183;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=a00b3HscbFj4tc+FKPO+Kov7AB4/N5wDR4tBT2O8+cU=;
  b=JNOJDynmJ7Wiw5BLSn2TIs6d8ZfPzTCP2S/5cqupfxmWVLTwyiMUZ7ga
   TBQ3rs1iI2PR/TZ4WCF3+OVhOAf84ZOGBD8BQRbFM9l+iHmogDEwnmtkH
   OpBSUwHrUTirPg0If7TPh9+zeXpNeyuOpXSnoPK26fb4gbhpNd+lBtcU2
   YXq/oRY4JKGYNuQ4S44sL5Qs+muNcRfSnLn1nFJ954UVkH/ANrweCybfj
   p4DrQVC9rGKMPwDN5m7L+ZvEfRYiMtEhgOXor5CUf8XSM8h8CAe8Q5DYn
   5oEkkmtR4xYZ9xoTyqDGvksymjQu/ueYybyal8k58giclCbsBtWEkz3T8
   Q==;
X-CSE-ConnectionGUID: 9JuzHbSnS2iUhz2TI4WOUQ==
X-CSE-MsgGUID: C3VsWsWLR8KN0lUuN5D3Cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62374771"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62374771"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:49:42 -0700
X-CSE-ConnectionGUID: 3CpumYjORrCdmv5Iz2mPUw==
X-CSE-MsgGUID: 5vQIPr1sTRaQ74T9WwNiXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200697125"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:49:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:49:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:49:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:49:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lSonRzzVjAsMpdJzD3sUSLLQPsf/iyf5mA8IFZDyVCLASgaa6p4k4o9z/UDqlNEtI6kwXMICVpwhKJKCXNnb+blO99VcA9uc5PQRB2h2tS52K79qUSoBJb4rZxAY5yCqtetVz9KKxkxCRRjA2PN51/+d9jxcsJku9s8lWniQyVJGI6AkhfI4vHvnEe3PfFI7m0jaJIo6vqx8Ob94iCi/paF81MBC1MyeVdhPsTXN6do3SsjoF5OfDKOuOKJtN/3HK7liYOcIbPfQeOS0EdQPi1i45DFCbr4JRNWS+ewb09oCPbODD5L8uIHBpN0PPuMpJ0+lKEIVTWV1CGHiLXdgqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkSUeJNfmo7elilaZMRz0CTrzfsWdS9sriA0eJJfkpY=;
 b=BvO1D4igcflMZhLh64kB5vV/o7CUf0+A+5WLdZarO5CmI8LJjAY8DZC1fiCMP5aerGeDUSZG3CC1j1cAjwF5uRQuG41ZNjMn1adOY5MkIBANISZj20n65Qya/6MwH/hXAIj0oIhOKPj+R9/rf+Po5NfPsGgLxqpgj6kHW/YpzduEaLKNIzNMbJN2CjK8Xe0R7wXNhchQBVzp1R46eJUpzFgjjjNMX3yhDxYCYkmm643mNEj8Wm4vR/77iYRqNoQXcpNab2qNAUC3T41UtDi7IMViezOBylynj0Z/EpYwN6uq1Qt8tA4NA4ozkxXvtTMfaVmb/DeBvBCXOJk1s6mq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9445.namprd11.prod.outlook.com (2603:10b6:208:578::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 09:49:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 09:49:38 +0000
Date: Wed, 27 Aug 2025 17:48:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 00/12] KVM: x86/mmu: TDX post-populate cleanups
Message-ID: <aK7UghwtKUedh/zm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 54acabe2-0278-40cc-9208-08dde54f0991
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WNAVOeVwJouHXMm/iEu3gguRlND7c1Nlk9aorKJDgIgElx1dLNrnbYCS4zND?=
 =?us-ascii?Q?xHjhSKHNdtV8hdLvqvO3PhIElerBX04jEqR5P+sELU8aKgMhwo4V4QEYck5D?=
 =?us-ascii?Q?4gT9I4V9jPtd+TgWE7go5BPscGGRRKVfI0emxRtO15d4CLbOmCvxzRLlHv0l?=
 =?us-ascii?Q?s610WCo1vDB7kk905QhAiSi/5mpKOEXvvXwTNUFvQP5MUNPxOiNv/QkT7V74?=
 =?us-ascii?Q?7UD6kVm00ukd/9jglYVV0pmo5DLmvTNTmh0rZ9gIgWWtxK8dy43lDfY99WFq?=
 =?us-ascii?Q?crmk1SpdImOCfi9nEZFdzfLlV6pKsxjl1+ubebHI/bBb/Po612uBXBms/F9F?=
 =?us-ascii?Q?u9bfzkyIhQv6aGKziHyawHu3DUbKLt34bACvSm0Pju+2XqINCee2GQV6rkHn?=
 =?us-ascii?Q?AsKaZs+VQgeZNrlRIuAD+GXP5r0t8p0kfXIx9gJCf5m3+J29/KQVwJIN7Vb7?=
 =?us-ascii?Q?WFUANzMNT3nWZ5diAWM3sSLoM/pAxFPzEFQpHnQdp77VOVCnp007H/OCsfYj?=
 =?us-ascii?Q?iGpfsRKbJWnDMtl+HEh1btHDDnFAz2+M5sT7jN319KPQbYZi36h17AMJeYgr?=
 =?us-ascii?Q?Zu8CH6aEjxDmccIFPBUPY6N7TuQmiOdm5Um2D5DrIH9yWy7ts4//wvrzMGjs?=
 =?us-ascii?Q?Rm0p5n3JD/z6sANsiR+cnuDKVb9Zu8vTWrMFj/DzRJ1APpH1iRPIuXoSTBGU?=
 =?us-ascii?Q?mkVw6ZlmoqOw0dRLPgfvvtCVoszNp+9C5c8MGCOm9t87cgC1VwXtUw5xHZkS?=
 =?us-ascii?Q?jTZK05ma5xCReF4e7P4U6b3DMBOmCCIrR/jMUDEGsgEQDjhGoflaiiN0sJAI?=
 =?us-ascii?Q?Et779f3YGFHPX865zLS3JCtEmr+89lbGfeGb/XdLStIhQx61532DLuk4xwUH?=
 =?us-ascii?Q?qNYwwJSPbokI+MFW376nyWOFPkCWXGpiY/jnK5I9GmzspgY4fOOBT3V94lkH?=
 =?us-ascii?Q?nL32mN3eQ0dB2O/alC57GYeJzybxa9MNZrdJPt8+2RlEsGTLBd5usk++NIof?=
 =?us-ascii?Q?L8sV0xyS8ljoy1si3E+K4xGpDzVSAhWtk8oqnkhzOSZxU9mSFhukRKrEcSDk?=
 =?us-ascii?Q?Q0TGjCCNULKbGnOK1vUg/dUQg6tof5rxu4YA35V339ua4mCdNVUTk+7jDusE?=
 =?us-ascii?Q?UWVi3DWu0rqtnFDKBVqoILyw4xyaz1tuyT2N3yaIvQUBvW2wptaj4l//UFnY?=
 =?us-ascii?Q?OpDtCJSuGPOnU07LnO4Stzy7qKHOGPx2oeLcWrGYWFl6Ud+3D30NJodvUW1M?=
 =?us-ascii?Q?0be+f/48lZkcAwcc3fZ1zp+sPF+Xa/M+h2mzDXOWHKCqFeNWzHXbS0cwsfus?=
 =?us-ascii?Q?9U2PTXK4ILs0TRCDsomfC2L90IoyBHI0TMFk5pomP8DN/+0VHQ+XJewfrN16?=
 =?us-ascii?Q?j08byRo4x3XQFzq377CUy3N0x3sOnUo9OdfNJgYz8b/JxwXQktuA71F3Xcpz?=
 =?us-ascii?Q?tFiQKoT8qpI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/G111hWs6a845dOtNaRd+t+JOn/pmmJGAS5OzQDIlvaQG0w1v5RpW28T6Ib?=
 =?us-ascii?Q?a3rWzUWgv+CqmuRBgz5MxjOsqwny5Z2fhG4TVyLY0DwFkP5iCFdF1+2fvxGG?=
 =?us-ascii?Q?iXs9StuujuC+62ELBJEIio5Fs+dSe10LM3EkOJqseHp7nPSjcx06PfBwfFTS?=
 =?us-ascii?Q?kMXHfWTJZjUNX3dNt0Ay49K5TCfnirO5XqmwCrSiV2W645N4mqcwlaYxJ5IB?=
 =?us-ascii?Q?3Q+YVMHtVOsz7Bajh/pUk01mDowhawnNIiVRXQq4G8QxsXDzw2haLZsX+20D?=
 =?us-ascii?Q?cZbcBWy9VZV/2O0seyMFoHrpcXt8dZWF/U3+fxbgPFXodugnTwg79QeXFUa7?=
 =?us-ascii?Q?bPV3HQsS5HF6DIZHWFCMBxasTTDgju9DOWKGSy3eHHmVUCSTQI7dn/+4NoGu?=
 =?us-ascii?Q?KAykBCYWbIrr0zWK1lzN//QbUE5zZDU2xhdDwlhqZL1DzHTAnbm8FFXnRjqO?=
 =?us-ascii?Q?CXA4YGvjOJkovu1cSw6zyKr7WPy4rSWZeZVqyhm734xe+Kt8XaTxxO7SGGjJ?=
 =?us-ascii?Q?Sjcjhw29qezFYXwIakrikB7o46LhaFMsRzuiWtyDCwicO5Rr0Ted31gGlHPn?=
 =?us-ascii?Q?LadCaPXBW4Z1L7u04viK64UVhyLW6/FG68lDF3tTplY7nO+Yq6v2zZW7AqHx?=
 =?us-ascii?Q?pOM12wgV5wDN2czcpjOqf6Z4Xwn4JmH1p2J8e7dYAsk2EuQKUpyVAw/qwRO5?=
 =?us-ascii?Q?WCRaYBxLojJ+coek7aY5+K/GCerrY9CL2x3Z8MBk27eUCZj94LFcFzl4L2UD?=
 =?us-ascii?Q?5w3jZdkj9vkQHGgxWqd/jKGN24buNitkaS2DuSDuPbD5t81P2G6tknTHavVy?=
 =?us-ascii?Q?1vW/NovBBqBtfsgDyQRIasqNgHtKa9cmk9h6+8+CmpsRe1cCz5g0ndpkzmf7?=
 =?us-ascii?Q?xPesgZ0L7xkhRw/6dTscBgiL80zTengZTdHNjc87Y1jv1KrhshfiRR7nUG88?=
 =?us-ascii?Q?WMuVZpX35C3k4jHNzVsQKsl2Nwer5szytamzCuSaRKEAcKAJjuTUqLq6LhT9?=
 =?us-ascii?Q?39XR8TYys2Pfnc9tWOq5T7oSNY4hv9SIk9KpUIpnc357TQ27oGMzwKjwkkKH?=
 =?us-ascii?Q?89K5UC+njV992aje4EGWCPGKRsqpb0152Wi2NEDeBZp9diP/5rGOuLsiuVT6?=
 =?us-ascii?Q?AlXW/bFbkKRnNC1F7KBwxnAejJMbxJw1wFkI3OcdbhRkg1zjeWGEc3GmQ619?=
 =?us-ascii?Q?iSVIJ9eIEIHGj1xH6eW/Ow9t+onbYpIVdnK3Gm4kbVNugxZKFkpFSLGoBTjI?=
 =?us-ascii?Q?bBmgs89caDvdlk9FQmei5wkYD0kgEJvYSqcP8kk+8N42pHuffWYFJG4z8UK7?=
 =?us-ascii?Q?9FM4xwTCT1gt4R9JwhefwX/GVkI+Kiwnwe3TZRuojffT1XD3dTEDThu57MON?=
 =?us-ascii?Q?WKccAzk1H09ojy2InduFYfFlxnQwebzVsyAGZqFRhBS73Uzn3hAPECwT6dt2?=
 =?us-ascii?Q?WeJUJaKrzilO5Q1dR7n/u2bNzLeSeU1Bt+I4NX6dIq790PeBo1EiuZTaJf9I?=
 =?us-ascii?Q?A1B2MrnLFHv2tGX4JK+LybGEBhu6LSBxREKz4e+sG26XOchmVnUi9GKELuxq?=
 =?us-ascii?Q?2vZPnY/G9Rb0QSkcXXad5S97OMw0hK1C0ks5mSWu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54acabe2-0278-40cc-9208-08dde54f0991
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:49:38.3532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xh51bM05vMDSIQDABwW2ww324D77gQggDN4nAfrhiXt01/Hm0b3aBHVED0DaZHzxFZdKSscWSNzmNFF6mR0CAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9445
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:10PM -0700, Sean Christopherson wrote:
> This is a largely untested series to do most of what was discussed in the
> thread regarding locking issues between gmem and TDX's post-populate hook[*],
> with more than a few side quests thrown in as I was navigating through the
> code to try to figure out how best to eliminate the copy_from_user() from
> sev_gmem_post_populate(), which has the same locking problem (copying from
> a userspace address can fault and in theory trigger the same problematic
> path, I think).
> 
> Notably absent is the extraction of copy_from_user() from
> sev_gmem_post_populate() to kvm_gmem_populate().  I've had this on my todo
> list for a few weeks now, and haven't been able to focus on it for long
> enough to get something hammered out, and with KVM Forum on the horizon, I
> don't anticipate getting 'round to it within the next month (if not much
> longer).
> 
> The thing that stymied me is what to do if snp_launch_update() is passed in
> a huge batch of pages.  I waffled between doing a slow one-at-a-time approach
> and a batched approached, and got especially stuck when trying to remember
> and/or figure out how that handling would interact with hugepage support in
> SNP in particular.
> 
> If anyone wants to tackle that project, the one thing change I definitely
> think we should do is change the post_populate() callback to operate on
> exactly one page.
Not sure if I understand it correctly.
Do you mean something like the tdx_gmem_post_populate_4k() in
https://lore.kernel.org/all/20250424030500.32720-1-yan.y.zhao@intel.com, or
invoking hugepage_set_guest_inhibit() in the post_populate() callback? 

> KVM_SEV_SNP_LAUNCH_UPDATE allows for partial progress,
> i.e. KVM's ABI doesn't require it to unwind a batch if adding a page fails.
> If we take advantage of that, then sev_gmem_post_populate() will be a bit
> simpler (though I wouldn't go so far as to call it "simple").
> 
> RFC as this is compile tested only (mostly due to lack of access to a TDX
> capable system, but also due to lack of cycles).
> 
> [*] http://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com
> 
> Sean Christopherson (12):
>   KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
>   KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
>   Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP
>     MMU"
>   KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_prefault_page()
>   KVM: TDX: Drop superfluous page pinning in S-EPT management
>   KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
>   KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
>   KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
>   KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
>   KVM: TDX: Assert that slots_lock is held when nr_premapped is accessed
>   KVM: TDX: Track nr_premapped as an "unsigned long", not an
>     "atomic64_t"
>   KVM: TDX: Rename nr_premapped to nr_pending_tdh_mem_page_adds
> 
>  arch/x86/kvm/mmu.h         |   3 +-
>  arch/x86/kvm/mmu/mmu.c     |  66 ++++++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c |  37 ++---------
>  arch/x86/kvm/vmx/tdx.c     | 123 +++++++++++++------------------------
>  arch/x86/kvm/vmx/tdx.h     |   9 ++-
>  5 files changed, 117 insertions(+), 121 deletions(-)
> 
> 
> base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

