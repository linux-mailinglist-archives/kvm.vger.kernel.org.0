Return-Path: <kvm+bounces-46775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70201AB9725
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 10:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC0F3B78EE
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E0822D7A7;
	Fri, 16 May 2025 08:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f4GmRInI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1B71F866B;
	Fri, 16 May 2025 08:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747382750; cv=fail; b=qVuX57LVq2Ma/51DW6m2Ix152WMJ/aTr/SnjjV0OkYqOMdm6E6w6PEzmXEN3lEQ+eG9V2/FV+QKUrHc+KpyspiyKNXfVditMizog6LOW1kbfH33ChTCJgj8P0rZAIj/AwBAASPD+d6ckoDVDZABMGw4MJQQPa7tNeoxonuVBNt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747382750; c=relaxed/simple;
	bh=9DfGFkJn7HVUc1GK+9mbDtIS2Vu+vkRNsyq/U2mCOVU=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Va2pLqqsUuw+GkCqjjQKHyMl1hczTW18UTQVqPZlhR2AzwoCYSpOIPL+h0xdHZ6iq0JxJBRqR5/kvc3TLmSVyjhZO0oZ2JjJQXtvvNuVJDnCpkd/zG7KA/0oekFQ3poVmulOUXh6l3oMLarKFokS+D/GD2E+L4VD/N1YXF/FGp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f4GmRInI; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747382746; x=1778918746;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9DfGFkJn7HVUc1GK+9mbDtIS2Vu+vkRNsyq/U2mCOVU=;
  b=f4GmRInIP7AiD/B3n5kcjbrpgU1t+ueMzDHVVNDRGK/at9xj47m+s9IM
   SvaYVU9UU/lk4D5MZ8V/zc0bd+cnLQAK4I8fBY5KgB2lkvVN/9S9aXWJ/
   i3bNWVP7gACeY8DvxLtepIWieOXGgt0VBPmqGrQdCgr94+jvk+YGHVYao
   FhWwPeHJ/6t06hTIYP8FwTeIhmYQWDfMtlcWRlIWA+62WhoRO/5CW7XtW
   Xvi4x/lyBnxJDpO5Z5OnR4gguFpChqBe0jB9zkaaS108v8159wTHs6FMb
   u+X7/BmNV38DDJ1tc7ohE3KD08U7ZVNdDnmj3aFOW0Jj9N3F5842/96eT
   w==;
X-CSE-ConnectionGUID: 4oKZPRQKSCe9EdUbXiTzwQ==
X-CSE-MsgGUID: Rv9VKFZnSPmAtlqnIK+mJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="71852032"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="71852032"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:05:43 -0700
X-CSE-ConnectionGUID: iEOndRLlTeSjsmG2NJBfhA==
X-CSE-MsgGUID: sCyO9Ye5QUyrPZ+wcK4CsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138514926"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:05:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 01:05:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 01:05:42 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 01:05:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asjN/Zwsb2gm2z3TTEg7Nr8hfQ4pp8X1CMRV9lDa96bbSxC4pKRpEIOBkEBgCOzXEO76TSS9IGJmOt/4cmWOnnlKzde8EHP6WYdvHNEI8hntZf1iYM71mf/hQdeEz8NZN6HC12pJ0PzM+GSnJkx8SWTrMLAKGnWuqAT/Qg2xutI8UlpxMHmQjWq6IneTE6g6HBSgV0ROi6S6U20cnJBW+5VgZFbk4DiL3Mghgdz/FiU4Xi6d33RhxGuFaK5LYzncIzkewu28yQLmWdLXSJIfhNsf70dokMQ8ipfENR2eZCCKDRoAx5I5ETCM2kE2xTnuLzOKuODxLmIZs3oLnoeQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fYHleufM35FN/0qDSw1XTMhNHsqTODSVCBqcc4KkMc=;
 b=hmq7gMlUanvYaS5OZOWS1XFHiwWYLVWZLoyR+62VyA0zamzNKHm7ng17Nwlssi5P3E+GhsMNbSEt37xqImEIS6oZF7wmtKhzsMKjvs3RV8poDAqFwnW/bX59rD7SzEgG0xli9mA8l8/vdSNywQuKAhMNA55/0ZS1jT9Pp3MrpXzlxTdLMJPmfMolGxM/JjVFaYAv//JaYADLqWVQsGgVEG3RgM58IjD058pGti6u2bPNbFIng6WVm5RHy0B9woVAHzylqOMK6Qfkp7k2eOvX4CAqKRHRqf+vC/g7bQ0RK8fVfzLguWpL0P3NW7ZOLiveQVDAJtiuiaIjpTv0qNI67g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.33; Fri, 16 May 2025 08:05:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 08:05:36 +0000
Date: Fri, 16 May 2025 16:03:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Message-ID: <aCbxSyLUhjyeB+05@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030816.470-1-yan.y.zhao@intel.com>
 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
 <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MEWPR01CA0039.ausprd01.prod.outlook.com
 (2603:10c6:220:1e5::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ef1e2c-008c-4e9c-6fe9-08dd9450709e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aC6/7YOMiOzsx/TmhPFtXgaDXF9YwdpFUNwVOtZZtXGceuzDnafI0H5rrgFh?=
 =?us-ascii?Q?7gOMwE2pXQz/DC2qhahqNxN+9Qm1WDYdE3cZcQdJTIZeld7CEVGQ0x0YoduX?=
 =?us-ascii?Q?owT3MxA6VEWbUs5TkssuhZZWEx7R4XhtK4KFHcdscCWYKGqdjzOT3YVxvCWQ?=
 =?us-ascii?Q?Qo5ZJYEm/moTp696T4Qxla3qCjG3oALkh9k45NNtw4yiBbjbZlXz/6Srgq/b?=
 =?us-ascii?Q?+6nsDgLcCOReXghtzHmpCfLtoaga6Gz5Qkgpu3KP6GcHhasHA8qrirnbMXUQ?=
 =?us-ascii?Q?knC3Vfok+KvnIwFXNxTcdWr93VLhDTeItNeEViOGHsUCWcaTQ5cOJ/mt8bWC?=
 =?us-ascii?Q?QCxP7SCSt0RWoS3iYP6xD0x35wUPm4W0iQO1VNzpbuw2RQpqtnG+5hJy3fbB?=
 =?us-ascii?Q?81wLZXuxkSjmrHyse6bLlFRAA5w+g5A5RXwlvEuEcWVElGXtsnZqGVzdImg1?=
 =?us-ascii?Q?oW6qu/nU6/Q7n2hP1vfym3KCmbzUQe69v+60X06GZfDtlCeurOQExFsp26py?=
 =?us-ascii?Q?cgy31bFElFSfRfm3fuhLu0rdM/jpQcY9FmhxApv5xypXvnwSy4/Hjuir+Btl?=
 =?us-ascii?Q?Qm1j2ptdGHLmHL6a2zNCW4kKvWeQZhO//bz7yHmFTsRUIoZt0hJ+e2QgT0m6?=
 =?us-ascii?Q?BC5rzBbjHjkF130JKnks8siX5B3QIzy+/7XCwWBXtLIGjFC0w57HBaejkoUp?=
 =?us-ascii?Q?sJVsrdCqapO4gZe36LU6SxyUrQd0L8tLFk3VJp4e1owpu8brneS4Kmi7fY1X?=
 =?us-ascii?Q?lSzIMALVj3AomFArCbohkCzrnixx9TKz5fwW+X+c47ExT1Sa23csx9rnf9ZH?=
 =?us-ascii?Q?0J3DblGUEW9p0422A9ED5CRDQ+eQxEzLh6/tqvcH7sb5U8lc8URN8WcfFD91?=
 =?us-ascii?Q?6CuNPIJy83fdMnEpOxKY41uS+mgKPWVLGO9yLtQa2RzsgTf5Dj9ILwTzBBiW?=
 =?us-ascii?Q?+zlQuW30Jswc1aLhrdrjAxzadvWRdqKI27z/hbI2hPo98rQ+/+sEDfEcUTQE?=
 =?us-ascii?Q?IXuSDitgixYNbLI9ijSYbDVlNZfT5L6sj1xM3v/5rFOU2Opo3sT9zQXgG+Sw?=
 =?us-ascii?Q?REP5Y/kgu1aeOs80rIrtLALhIHYttmBT64/f13FxHaFGw9V2yJlfa1woBuJs?=
 =?us-ascii?Q?CdpJkW7kPB+4GTLCpbqOcDn2hlfLVl4Jg7o9lHD+oa6YB2Od4z1850Ng2xV8?=
 =?us-ascii?Q?hpLlJ00/QOEUsFm44qUuzKHst6DwWJTjg7rHOnDOSYNd1cWbV0C0WQzcqrez?=
 =?us-ascii?Q?UfQPPLJ24zrwCIzrZVIBZWubRE8+Iiyxcd6XxXmTZxj/o1/B+bOu54jR4sS+?=
 =?us-ascii?Q?1htKC99IfIoQ0ZUJ8rV3MLTTZkbNHjblZaLPjW2qFQYiaj7/qqSqUpFZfQl7?=
 =?us-ascii?Q?1VZQV11fkrHJJMLxsrlTKqs3WNgYwm5rJ7LPJ3VTqOqRBuSeR75slrf/Jm9S?=
 =?us-ascii?Q?Z9CflosesWUhpoFrzSABG9pM1XHHCcphDW3ZQHfUBpJG7kDjq6hY5Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GP6lGuueoyGPKjqu3kzuqEjrCiy52AJVxKmjaZ0+5qzisJ8cxfZlA7Swmv8n?=
 =?us-ascii?Q?qzMTNK3tE3hzgYRUMctoP8Ih0mCxwKdpFBMtZ0Dkcu6G63pcbzGCueqy4up2?=
 =?us-ascii?Q?yLk8XShUG6sPKQWnl22455NWDpm5byaRr10yyyrjoc9SYzvBH55DdF/2WHg0?=
 =?us-ascii?Q?aiOGB91aRdehdkqETqKXOPXe6pls7NMwUYrNWG9pldZ8beC/VBSuEJqarHmC?=
 =?us-ascii?Q?PgN6M9v+Fh4p+w1cXEfFucdv/savwQoK4th47QbEErMvC61zSzkbgLq6GEW7?=
 =?us-ascii?Q?LBmJjhPJDnDM7S3GHS3WdoZT2wX/3rXSqGioXN0mKyIHNJGK+60DBudKKN4X?=
 =?us-ascii?Q?jqP9Tmj29FK5zEF/n/0CKbRID/o9EJoyqEPeDPz9sUp7E3bvUXcIXvw0Da1n?=
 =?us-ascii?Q?C3Ejb7fbR9gE6eFmpy+ETE0j74liAcMInnvAXyBaIe6wOwn+91hxgvWLpqkg?=
 =?us-ascii?Q?iOopgaF9JlPP4o5BAuiVTjdnYmbS/sm4MDTVKhDC3kTWjJc7g0NY6bVnyEqr?=
 =?us-ascii?Q?9gUyxn6vNrseqAzgDASKqp8uBmfjK6VXyHcmitLspiwtqmoDV+qkCuSXKiC1?=
 =?us-ascii?Q?8FC0KqTx9CQkVyuD5eFZ0z8jKc9kGEiAomRMYKepAmuhDe3u7XBrYzBbUq16?=
 =?us-ascii?Q?c8zKEf1gA7ZoMWCJHH4g+uwcVKlbH4Hq2wQAld+tsBpgkB6abmB6+hnVna8K?=
 =?us-ascii?Q?/voOJjXCQ2Vr9tOyUHIyjL3GmxHzIYNXOQ+udEWuhTBneHYNgHNpxY/nSRx4?=
 =?us-ascii?Q?PsUw5s7QP1ef3oRwLA7illEha8tvXS3xBtIItnN7eLFC1zIltXbzwFfS7SP7?=
 =?us-ascii?Q?jJZt22dWP6rcXuU4nf6wBQx7TazJWZzgt6IJ87N1FN7XJxRhLv5cA0k87l//?=
 =?us-ascii?Q?ceMImHwnE8sjAVWkrG6ri0WVwUvTff2658w83ojifl3CWO0nolYQthZihUz1?=
 =?us-ascii?Q?jeF7LBU6lyHML8CpTdyl6y0TkGdgm9GaOskz9Z0LCAT/rGDTmbs4uN8dHA7D?=
 =?us-ascii?Q?XIc0e0MCaCK37EBt85CW7te6DshfurwTnSTSz25Z4igRTygqOZfUdwNYbyB/?=
 =?us-ascii?Q?EqjmzHcSJAgeTpowDisis1gehOz1ICgJitOtFebHR3siXHwbcb2WdVCi6e5J?=
 =?us-ascii?Q?ZTX3w6JOQRc/z4kGVAoSN+juE0psRpsWvsZ3/QIQ5ft0zbkj5ERFC/c2chgf?=
 =?us-ascii?Q?4XLYNFgx5EvGMPrgaYNafSZFOzFHidNLpwJG3W4B5ro9J2wQGKyGW7Hsq8qU?=
 =?us-ascii?Q?oyYDQHYUQGEWBj8RbgDOV0ErRU9iQ4IyARu647BXl1kCWjfPTfwmHpVjBbXE?=
 =?us-ascii?Q?+aFMKUHLP2m28YTqA1RKILavVm5YL0FG0pWElfgCnjU5OgCFM2gtPmNwMsfI?=
 =?us-ascii?Q?7Mi8AD8UcGmSj9J3xVcxOohEUjVs5fV6UPWrPIVzR+GkMGfVzMHwD7lmcwb5?=
 =?us-ascii?Q?c+IThC2h++aUz+STvOAB19ay10ogLWI76zT92/zmiYw+kVR8iLwUAh/MvhZ4?=
 =?us-ascii?Q?/S9L1KIPy6OIeLJR2VEDzkz747751Rtn8uhTrpH/nYrOv18u6C4pDfiJbhTM?=
 =?us-ascii?Q?OrI1nVlIBh8ddb5B9ngEvGqKCwqcuykYfbgxbYr9g/tFJaLlYqeeo8pelF4o?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ef1e2c-008c-4e9c-6fe9-08dd9450709e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 08:05:36.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfvf3IzCP2Z6fa9bpniGpSgCK19ORuTbLJ721o/SHjc322H1GCwiHbiYHHtBC18D7z1wb08EjGlM099lTuzX8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 03:46:53PM +0800, Yan Zhao wrote:
> On Wed, May 14, 2025 at 06:56:26AM +0800, Edgecombe, Rick P wrote:
> > On Thu, 2025-04-24 at 11:08 +0800, Yan Zhao wrote:

> > >  /*
> > >   * If can_yield is true, will release the MMU lock and reschedule if the
> > >   * scheduler needs the CPU or there is contention on the MMU lock. If this
> > > @@ -991,6 +1006,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > >  		    !is_last_spte(iter.old_spte, iter.level))
> > >  			continue;
> > >  
> > > +		WARN_ON_ONCE(iter_split_required(kvm, root, &iter, start, end));
> > > +
> > 
> > Kind of unrelated change? But good idea. Maybe for another patch.
> Yes, will move it to a separate patch in a formal version.
> As initial RFC, I hoped to show related changes in one patch to allow a whole
> picture.
> 
> > > +int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct kvm_gfn_range *range)
> > > +{
> > > +	enum kvm_tdp_mmu_root_types types;
> > > +	struct kvm_mmu_page *root;
> > > +	bool flush = false;
> > > +	int ret;
> > > +
> > > +	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
> > 
> > What is the reason for KVM_INVALID_ROOTS in this case?
> I wanted to keep consistent with that in kvm_tdp_mmu_unmap_gfn_range().
With this consistency, we can warn in tdp_mmu_zap_leafs() as below though
there should be no invalid mirror root.

WARN_ON_ONCE(iter_split_required(kvm, root, &iter, start, end));
 

