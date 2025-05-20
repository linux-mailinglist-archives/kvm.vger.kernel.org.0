Return-Path: <kvm+bounces-47064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5839BABCEA3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0A483A49FD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 05:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6CF25A34B;
	Tue, 20 May 2025 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Az2weJD/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDC825B1DC;
	Tue, 20 May 2025 05:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747719004; cv=fail; b=Cf6IpNh2RDyps7rEtS81XaNbwwfEWMXSJHL7+zLxCa1pNrmV5aUZAD4HW9a2UvotwSkeSxBwBvll/nORkzR5ubSyJIHnd9DoUv9UYvtgA4DWq1PdQdd27hpZ/wLLmkGii3t7tc6itpmfJ4ex7I93GY7ygHY4b/HaawFxSPjFesQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747719004; c=relaxed/simple;
	bh=w6C1KnbEqIowQv+WxrT81Y8qctIv6FZRYMQ3Yd85BKQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YMPDVJZHiGW4XqnciKsoyI2F+B767kyQklnrNwhqBdlzJlFnrQYk57acakZyQAA86R6oXS+dfCxyxPGtIP7Q0S1W/bXonveKlYxwGv4rNBHXv6HSuN88ytaRabR0ABz/A7Cq1oBaSpFsgI2OyqzJAE8DDPgjyWu9QibFBKPaEGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Az2weJD/; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747719002; x=1779255002;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=w6C1KnbEqIowQv+WxrT81Y8qctIv6FZRYMQ3Yd85BKQ=;
  b=Az2weJD/CGOe1MsMwm5rl9aOGYvpX0H5mMCrMHWw28DFJ1F+MYaLdAwp
   RNU5SCZA6G1h7ODCfb75PYnte5v4tCf7WnxgAkZMq+vIEGUw2tmW37vGu
   7WteIFakRJU7DcQokFiUnnZRYRKs3AJuOiNoLXeWBfKiKAFAYecPFxppK
   UuiK3nyNJ2ii5KAtqC61Zs/DeNKXb4kiu0Q8C0lOh9GRINfZUuqkvwS4S
   QGuR3ixv2DTarQKr0qG+3Tn2YcEXUx+OhbgcKHwTQItzFn5BAcZ5GJ2zf
   djrZdnsFzoHovNJfGaDlGbdUfOb2fW2YHHuymNnh9ZujR7LO66vGaPzYP
   w==;
X-CSE-ConnectionGUID: gv6GgW7sSmKmNN1oxM6LBw==
X-CSE-MsgGUID: EQOnlobgTVKXD5sTDstOlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="53448920"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="53448920"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:30:01 -0700
X-CSE-ConnectionGUID: MPFo6HAATV+JTytlFnomag==
X-CSE-MsgGUID: QDVEzDVXQuauYx2WVatCow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144445071"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:30:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 22:30:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 22:30:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 22:29:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRdVrvElGfElvZWFVvfCKG4pFRZcD9yyxz+BkDVbS6uzfwSL9LcFMB5N9WGtSVKnP4UnSrLVvnWarkiYyE/jbto/ia0XkDV5rmNdN8rzMHfea0fE/q0SOg9O9E1eZgsny2+reIZUBKvkXWWUbvRhu4D89bM/cIqGX++rEVX3kM7U1r5cWSV54cYYBKEV3Vf97HeTbQ87Rgh1RPN6p2eFKHelfivHcLIVqHcy/W0dj5J3jGACmrUbyCiXTkteKfN/sFMxz6E/rPXTeoKsk09NCsdSIinwGenvM+WTGsRS8O0g25tm6/0d69y0/NMNa5+BMaSB0dfyBP5qcD/broL9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUAwzlHehgZYXuZB6RniR2PCi194Gj8tBf5y5c/txuE=;
 b=YwR/H1eTFVOgR5GhQnSYddlDO+NI1XrQ+m9jRFAUwScaBsu31iH/9bTnJ1qFq+JJCluVkyZoYCnNpKPZR3PZ2loFy0VnPPM61J05ukyNemt1c68RdHkjVRi1zHzmZLRFkurFzo8ShoCvu49W93uCwP/uMtj0TH4iWqtHe7cCY29uTgYGBOcVo3iXx+b01XMlgVNH/q/6JJxMXiRLQxfj8v/2lj0OfnPDPqPb0RU6ayeFz3pIjWJTdBV66mf2E686onVLre7agjMtFcvtNNaUefaMJNuvT9mhsUcPQhxOIIsvNJACir3gUJ/sI8WpwtvXPsJrxFofz8dnkSovD5FHVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8480.namprd11.prod.outlook.com (2603:10b6:510:2fe::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Tue, 20 May 2025 05:29:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 05:29:52 +0000
Date: Tue, 20 May 2025 13:27:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <reinette.chatre@intel.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Message-ID: <aCwSzxTzB7P/wjqp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aCsy-m_esVjy8Pey@google.com>
X-ClientProxiedBy: KU2P306CA0021.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8480:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1cf17f-a6e0-40d6-babe-08dd975f58a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P2kofsDzX8tiYdxMiUgvhwF24/zOeDSM12D2+JFbuEsZPQa2OQjCbB38gLpE?=
 =?us-ascii?Q?IA4ykdiYCSJOixRoVhXBc5G3Yco4PG7e0imybgyWu7YrDjgDRHOtymq+irsS?=
 =?us-ascii?Q?sRxcFEsNJQYjRgScNXs9LAOyzD3twXHAPH+SBsWFSZ29NIbexvE0HPj5O6qD?=
 =?us-ascii?Q?oDzNFKjbwPfhYce7wnbXhYo9hQzk9u6bXrQybA4llHoo8jIfGpEtVAX3PfR0?=
 =?us-ascii?Q?/eSSHX2Q2QYVh2VULjnodXYsmGFuswqE4d0g5pP7ZxmFf/aawMKGjKyb9lHd?=
 =?us-ascii?Q?vSYL6NqdWtks4QmkeLATfWJh+muR6z8KRFYXl4WICHR3FD3VKgzW8SqESviG?=
 =?us-ascii?Q?zAjMLDzaumM9LnofENz5YBHCheExSgLCHW1ykPbMLNI9j96nnu1ISpg1FXCH?=
 =?us-ascii?Q?48tvGiG642EljRfFVec4j8EGT0l8mXgQgydS6LdgCm/OitsMb3uN6L/3PUsd?=
 =?us-ascii?Q?WtO2wUyaw/GIgmfmP2Qb9CVHBZpdDi/zmqb77M8oao7Nk3YxXS52sbrHZBZt?=
 =?us-ascii?Q?MvQHhgrdIt/uQ5NzSo1dVC/YWP8RMD8327NPYVtrwmduS90gR56UyF0aZTS0?=
 =?us-ascii?Q?ZbzSp/ejt1U7iUoF7W5fxmB0MTOc6HENtOthHdRKze8a9g4sJfedR7f8eG0v?=
 =?us-ascii?Q?fCxeKqlOsgqMwTfiopg6onADdUZrzFYhCo8a3uWYTnUI8Q/q+dAwja4x8iTc?=
 =?us-ascii?Q?PqSouKE11B5B8ZdSb2jwYZBxh2u77/+vMYlwIsBPChyekniaITZiyZqnnuD2?=
 =?us-ascii?Q?KKCQUVvGIGPQWjBHLXX2W9RrkhYO2orf3cLo2uquOzUcAq0MEE8/o6Ex2yiC?=
 =?us-ascii?Q?E9GgFWRrX7Zpmj7VLDvet3I56BPJxyrovCq2yrY2Km/6BdQZYbITqL2c5nQT?=
 =?us-ascii?Q?ffgKjpth4vGybMGFX3AasaLkILb35PEVUt5beQIMEVmvtheVKqgRcsKMc9sw?=
 =?us-ascii?Q?deBc5TmJ6YkoeHtCWbeyPhyg/U1xiE16l70uiDalMRHUbDlkL5EmgOGbqLgr?=
 =?us-ascii?Q?T3Wu/0kP1y7g01dlV7gnQmkNb9XIehnoWfoI4uh9YMxusc6c6AVMkU9gDL94?=
 =?us-ascii?Q?eKcSBShe2Q04rg6V4LQDIJpjfR4tpfS1eHe9G59f79iXU/w0cuwdeqnm031F?=
 =?us-ascii?Q?sekuFQcAXwevQ1etpxJvLypUh4VZj0db2xQBv4R66puHvzwITP1rzkCjrmZc?=
 =?us-ascii?Q?1jzAk9uEQWCNKYPjBSduplYSdhKmSUc33iB2fWpMLfpmrBBwk6EI9nJj8BDj?=
 =?us-ascii?Q?rYiDq+AAalcUqOpJnNdJfBsHs2m6ur9uvj5dztDNboMyP7mlR1Kps4foLX49?=
 =?us-ascii?Q?r/R83dnA1spK4sV/5XqqT8qzf/ugIOgFeaZgLk60XB9KM16fHc+nTLmNqJBJ?=
 =?us-ascii?Q?iAIEnsiw9gQC0jK8ZMftsaFei/LRkTmfsLB9eZgNAUOktRzDpGY9ieqBodCx?=
 =?us-ascii?Q?iFzc2++22hE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GpAkk8nDz8VWxnHmAgoOcQ1Xy/HNrqeNBq1WiVpDSwFyiVJM5zw+VTx/XuNs?=
 =?us-ascii?Q?g5+ykR7+8Bnj5OZOLzhSWb1NvdV7WhFh/46H2OTMEenjZrwbqcf65gRvkCfc?=
 =?us-ascii?Q?09jr73iMbwiYWPVe+48ZZBwluynUuGlBSUI4B6LrlSv6X0sT8DVV1yCPp+u/?=
 =?us-ascii?Q?/vDZMYsBZ0oOzv9hlnzSCddi/RNjD6zS5wnB+eIeNOOfy8Q8GZNeGm01ZXrQ?=
 =?us-ascii?Q?Cc1fIPe7i1fJzihvTsTZie/QR61jUp9FB3A79jHLFxwWw4hBtee4O0iZO5nC?=
 =?us-ascii?Q?ZdQQR52MM5ghWAyKCMicG98wBX8Hv+xZiBD3cdhFg1JL2sV76sWIpl1jClEA?=
 =?us-ascii?Q?dYHKtVYUWPCDSEfwxCCKpmKE6NbkU36hQelCiqr96qfKNoSvTow42iFNJoB/?=
 =?us-ascii?Q?RKPSUYwB4eep5GMw3+8gE5wNfAZF41uNk3WrPgdGYyxPoXcX8wWTgUGQZHGf?=
 =?us-ascii?Q?uz430HnFwbYNosmE6YBOSoL1kbUiesKrmVfIHqEFApiCKwYVSoIqZ3jv/1S7?=
 =?us-ascii?Q?vxfFWC/hCjjcy7WbF1aHSqot7GOYE89CowWkNs1T2+Y6W+K3vmSNXGaJBI3a?=
 =?us-ascii?Q?6EZfcPvrQ1KsbGLzXRQ0aK7ZKlM5ZkN4skvXlDCvRn94BbLcuzFD304T2F3S?=
 =?us-ascii?Q?tfT3khLhhQGqhBMqQLRX3n5a2gk2Beq+/IAIZMYoSxN5coarZLhz2EpjhB29?=
 =?us-ascii?Q?tivu2FDfKKWHbXn0yB7kuTDl/QeWqAQJLrwNMWjX8ZH91ETOABGQrocwGtvc?=
 =?us-ascii?Q?pFyHgNXk4KHHnP9IhDYKBb1775X3K0tpzOD4RWKkzGOYPudM22Q25U+4KHNq?=
 =?us-ascii?Q?SZN2ve/YV5Fc6GfbEULrFE+kqf5AEFvIFdZ8/RdOtCw3BMqTLNkvmsaXeuQS?=
 =?us-ascii?Q?nOPPDS9zVBtgTQVsSxA2ZoGEkmmm/R2hL1CM/pSs7t2SQx2lkTXYxgADgopF?=
 =?us-ascii?Q?jtAOQ4NH0o8uQN6PlIqvlrKIprNjr59ywK/U0qS5FwPXqg+/LqJiLr4kzQ50?=
 =?us-ascii?Q?iFawASRk8k+dBOb4EbhHBGk0ea0efZ1nf5tKg1XPF8t0+oFhYxPCbXTJQbfl?=
 =?us-ascii?Q?3uWtmdQ93zKl4d90lQuiBC8/OgfvSsM7+eDZ0Rah/CKFCKWq3l4VsRthK9Wv?=
 =?us-ascii?Q?IyV7WX9xjyvGKFgotBNoQYLRvh6qzv7UH+m6kajA/LDcpPrsOyABDlnvOSBn?=
 =?us-ascii?Q?9TOBLAhHMqNaZKjsjPEu/vK0z4KBFCA9dBF5VhkS7wgFxjtxrxY5Q6HGDRxR?=
 =?us-ascii?Q?SZoCeAgD/8XrdjAPL1Gs/jlgHrpzPJVX+n9Z7oe98YoYUSpwbY1jMHa32+ve?=
 =?us-ascii?Q?eS/ZGk4Wwppl8ZquwAHNp67XAg9nI6gnDJlv8p2xS20I+ohd+mazakvnrDOA?=
 =?us-ascii?Q?IB15x3g30jzT1CDco0AyXRufAzZu1OlRHQ9Vp2N8bhEblgCW5LbvxI2AkJuI?=
 =?us-ascii?Q?DFCv+pkR+c6BehqflN1o6ZmZqblz0/lDYagWwRudGc87cQ2+WUOlWkyJeZra?=
 =?us-ascii?Q?aoBw2GpgPrzGVhAsFXbIVYGDhbaqKK0FbXIlSPXiZ9U8OuJBpb+xJwDI9+eK?=
 =?us-ascii?Q?rUDmS+iPPVjQSBr/fTjeAAq+1sMTpzQwQ9FEP6pR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1cf17f-a6e0-40d6-babe-08dd975f58a2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 05:29:52.2754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiU09w5QNP1W/naunlc60ZKXtREHJztn8Lv39XqEF3pR9zJ2fefhbDwZZiOQKlPHRHWM31K5GSpZmlmd7gA4xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8480
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 06:33:14AM -0700, Sean Christopherson wrote:
> On Mon, May 19, 2025, Yan Zhao wrote:
> > Introduce a new return value RET_PF_RETRY_INVALID_SLOT to inform callers of
> > kvm_mmu_do_page_fault() that a fault retry is due to an invalid memslot.
> > This helps prevent deadlocks when a memslot is removed during pre-faulting
> > GPAs in the memslot or local retry of faulting private pages in TDX.
> > 
> > Take pre-faulting as an example.
> > 
> > During ioctl KVM_PRE_FAULT_MEMORY, kvm->srcu is acquired around the
> > pre-faulting of the entire range. For x86, kvm_arch_vcpu_pre_fault_memory()
> > further invokes kvm_tdp_map_page(), which retries kvm_mmu_do_page_fault()
> > if the return value is RET_PF_RETRY.
> > 
> > If a memslot is deleted during the ioctl KVM_PRE_FAULT_MEMORY, after
> > kvm_invalidate_memslot() marks a slot as invalid and makes it visible via
> > rcu_assign_pointer() in kvm_swap_active_memslots(), kvm_mmu_do_page_fault()
> > may encounter an invalid slot and return RET_PF_RETRY. Consequently,
> > kvm_tdp_map_page() will then retry without releasing the srcu lock.
> > Meanwhile, synchronize_srcu_expedited() in kvm_swap_active_memslots() is
> > blocked, waiting for kvm_vcpu_pre_fault_memory() to release the srcu lock,
> > leading to a deadlock.
> 
> Probably worth calling out that KVM will respond to signals, i.e. there's no risk
> to the host kernel.
Yes. The user can stop at any time by killing the process.

No risk to the host kernel.

> 
> > "slot deleting" thread                   "prefault" thread
> > -----------------------------            ----------------------
> >                                          srcu_read_lock();
> > (A)
> > invalid_slot->flags |= KVM_MEMSLOT_INVALID;
> > rcu_assign_pointer();
> > 
> >                                          kvm_tdp_map_page();
> >                                          (B)
> >                                             do {
> >                                                r = kvm_mmu_do_page_fault();
> > 
> > (C) synchronize_srcu_expedited();
> > 
> >                                             } while (r == RET_PF_RETRY);
> > 
> >                                          (D) srcu_read_unlock();
> > 
> > As shown in diagram, (C) is waiting for (D). However, (B) continuously
> > finds an invalid slot before (C) completes, causing (B) to retry and
> > preventing (D) from being invoked.
> > 
> > The local retry code in TDX's EPT violation handler faces a similar issue,
> > where a deadlock can occur when faulting a private GFN in a slot that is
> > concurrently being removed.
> > 
> > To resolve the deadlock, introduce a new return value
> > RET_PF_RETRY_INVALID_SLOT and modify kvm_mmu_do_page_fault() to return
> > RET_PF_RETRY_INVALID_SLOT instead of RET_PF_RETRY when encountering an
> > invalid memslot. This prevents endless retries in kvm_tdp_map_page() or
> > tdx_handle_ept_violation(), allowing the srcu to be released and enabling
> > slot removal to proceed.
> > 
> > As all callers of kvm_tdp_map_page(), i.e.,
> > kvm_arch_vcpu_pre_fault_memory() or tdx_gmem_post_populate(), are in
> > pre-fault path, treat RET_PF_RETRY_INVALID_SLOT the same as RET_PF_EMULATE
> > to return -ENOENT in kvm_tdp_map_page() to enable userspace to be aware of
> > the slot removal.
> 
> Userspace should already be "aware" of the slot removal.
Hmm, I mean let userspace know there's an error due to faulting into a slot
under removal.


> > Returning RET_PF_RETRY_INVALID_SLOT in kvm_mmu_do_page_fault() does not
> > affect kvm_mmu_page_fault() and kvm_arch_async_page_ready(), as their
> > callers either only check if the return value > 0 to re-enter vCPU for
> > retry or do not check return value.
> > 
> > Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
> kicking vCPUs out of KVM?
Not a real VMM. It's solely for stress testing (or maybe better call it negative
testing).

For TDX, now the only memslot removal case is for memory hot-unplug, which
notifies guest in advance.

> Regardless, I would prefer not to add a new RET_PF_* flag for this.  At a glance,
> KVM can simply drop and reacquire SRCU in the relevant paths.
Yes, we can switch to SRCU if you prefer that path.

Previously, I thought it's redudant to acquire SRCU in kvm_gmem_populate() as it
already holds slots_lock. I also assumed you would prefer ioctl
KVM_PRE_FAULT_MEMORY to fault under a single memslot layout, because
kvm_vcpu_pre_fault_memory() acquires SRCU for the entire range.

Otherwise, could we acquire the SRCU for each kvm_mmu_do_page_fault()?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..15e98202868a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4859,6 +4859,14 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
                return -EOPNOTSUPP;

        do {
+               /*
+                * reload is efficient when called repeatedly, so we can do it on
+                * every iteration.
+                */
+               r = kvm_mmu_reload(vcpu);
+               if (unlikely(r))
+                       return r;
+
                if (signal_pending(current))
                        return -EINTR;

@@ -4866,7 +4874,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
                        return -EIO;

                cond_resched();
+
+               kvm_vcpu_srcu_read_lock(vcpu);
                r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+               kvm_vcpu_srcu_read_unlock(vcpu);
        } while (r == RET_PF_RETRY);

        if (r < 0)
@@ -4902,14 +4913,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
        if (!vcpu->kvm->arch.pre_fault_allowed)
                return -EOPNOTSUPP;

-       /*
-        * reload is efficient when called repeatedly, so we can do it on
-        * every iteration.
-        */
-       r = kvm_mmu_reload(vcpu);
-       if (r)
-               return r;
-
        if (kvm_arch_has_private_mem(vcpu->kvm) &&
            kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
                error_code |= PFERR_PRIVATE_ACCESS;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..b1f20c7fd17d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1920,7 +1920,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
                        break;
                }

+               kvm_vcpu_srcu_read_unlock(vcpu);
                cond_resched();
+               kvm_vcpu_srcu_read_lock(vcpu);
        }
        return ret;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b24db92e98f3..c502105905af 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4266,7 +4266,6 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                                     struct kvm_pre_fault_memory *range)
 {
-       int idx;
        long r;
        u64 full_size;

@@ -4279,7 +4278,6 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                return -EINVAL;

        vcpu_load(vcpu);
-       idx = srcu_read_lock(&vcpu->kvm->srcu);

        full_size = range->size;
        do {
@@ -4300,7 +4298,6 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                cond_resched();
        } while (range->size);

-       srcu_read_unlock(&vcpu->kvm->srcu, idx);
        vcpu_put(vcpu);

        /* Return success if at least one page was mapped successfully.  */

