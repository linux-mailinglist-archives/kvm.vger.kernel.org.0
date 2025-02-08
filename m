Return-Path: <kvm+bounces-37654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89059A2D35A
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 04:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CD3D3A3AAE
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 03:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800D615442A;
	Sat,  8 Feb 2025 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n4Sah7x7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D632913;
	Sat,  8 Feb 2025 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983776; cv=fail; b=DzwIqdM99Hk+hoBaEMhVbjn17Nf+4S1u/KQ5SnYYT91Qn311IC9jiq0x/GUmTJdJmp1ge7wZmoqt8dgyylMgh475XpQ5GaQcqWpEc2Z3CN8k7QNIl4+Q1+HjID6NU16/ayEdBneP25VtWBu9vAlcgN1QIVDyxeR3v0Vpo568Djc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983776; c=relaxed/simple;
	bh=PCiGpW6Ny1qXCUJlV8lp0DZdxVnMAkqtGgARReTvrVw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KUgDX5p6zT4R/+k1UyRE+iX0/gHqWT0KEfvpMd1QIa2jhSC5jqQsGUD/dTs3TS4Y8UapqUvRqEaclHgYK6hd6S2LqJ8py4pkY6DDVoqRd9mvw/hIc5ohtSflPUobx4dxFzAyFiIYFNyaCN9uwUHK36L/12VfNHhYEcnBBu32L7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n4Sah7x7; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738983774; x=1770519774;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PCiGpW6Ny1qXCUJlV8lp0DZdxVnMAkqtGgARReTvrVw=;
  b=n4Sah7x7dPMSVPzQQtF0SU4hIty+/ZJqrRcKrb6eDQwcVguiZxyMTcKZ
   AS+M7ztr0Ca+S/rQokRAhZdOR3ZeNyzQViXM3HT+KQaeWTo+mhk7VzQ+M
   6hJPEMp/2aceN/OXeVhaYlC2b09CFh3LJ35w3qcCU6q2TxgRTTIQYY6YE
   KH/G9lNq5wxjb2IlbA1m3kV5fgcfpGwfeD+SFr6kI4gWBUeakfb8F+Roz
   3NdeaUIjkDyiROBvSa20A9A0QoFZ8UfkWDIp283e7JQoh1MXhKT3Ok7i5
   eq2yZf/Q2Sl19vEqZtzbBwNjj1r9Dt1WItR8qdsH/pigVsXqz1QH5wcQb
   w==;
X-CSE-ConnectionGUID: sPXYnu3lTHOhyGONXNTf4g==
X-CSE-MsgGUID: 4CU6dzg3Q1mDNJ9TzGlHZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11338"; a="50617781"
X-IronPort-AV: E=Sophos;i="6.13,268,1732608000"; 
   d="scan'208";a="50617781"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 19:02:54 -0800
X-CSE-ConnectionGUID: kN8+znKGTcuO63n5wr3pbw==
X-CSE-MsgGUID: uRzxJu4cQtGplZ6sE03cxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112577133"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2025 19:02:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Feb 2025 19:02:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 7 Feb 2025 19:02:53 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Feb 2025 19:02:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O455Bw+gq0a7yzlYqicjymshtkcO7I9NKhW4SBNO4KnREZff7w9/bNPkPiWlfvKtQ20GK5nTrtdvqOX/Hwh0jh5V64QdulyRishlCtZDKOwCB9PjYtx5fBX77/YYDt8RoxqAZiYnoE+ycbPkpqRwgDtI1nNoUNP9fZQLdTa/qeJsLBY4lGPapdaLS+D/qfEZIpFQu2IsnaIq/LL5ofv7lSJtklPNw0JTXHLnZ1c+H2tTtUCnFmQ3SQEqaMc+RoOFS6C9hBAwDz8reiP81IVD1fCb7pq91Fh7B9o3Id2lQ5xRwsFUz5hwtEc/QrtF8TqspztW+tSrzNmQzFBVVkQw+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCFowSWl9tjP8UMN7KYG39WxNINn3ACw+rn57nJzlYo=;
 b=a/w5/rr1Taf5E7FKAVyIG1Wjgv2hgPfJvBwwv9z+fmc3ZGfG1FcRV59inusM1XkkpNZp8za3ChQQ3onvvahkeoJqP93HztjZjgpa1QYydaPo9y2jowj2zf/aan9e1StB1BP0mTfgTw0Hsq8M9bFEyChNnj+MJoja4WSK8XqCDKIfz1ap+c+5VDxswI22zl/QWowQJjfq1Pc4EOvIRwLQWw9YkhjI3j+Gp5YZypia1+lkXe8cuWHddBlFOjDMY4N9fxoagWxQyrFVh38vIS8QGsXTvdSxZkGc4jvewScg2ZJ029R677xucJ7X1+CVGSgMj3FEBOgNGcck/rmB9v8Jpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4866.namprd11.prod.outlook.com (2603:10b6:303:91::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.15; Sat, 8 Feb 2025 03:02:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.010; Sat, 8 Feb 2025
 03:02:50 +0000
Date: Sat, 8 Feb 2025 11:01:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Free obsolete roots when pre-faulting
 SPTEs
Message-ID: <Z6bJF8uA9R0x3QGp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
 <20250207030931.1902-1-yan.y.zhao@intel.com>
 <Z6YixPh_j517vqcP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6YixPh_j517vqcP@google.com>
X-ClientProxiedBy: KL1PR01CA0111.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::27) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4866:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e4df49-0d04-40fc-3fd2-08dd47ed12e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?//QFYSY4nX2DMtQKkiRkD8wJPgCJxlGeWGRtXr0EfoCIXfsjotswUY27q3QY?=
 =?us-ascii?Q?+WyYOtjMXOq1RzfVSYFOlKJqTfx/cGhfe2MV6YjWQYOAzb79B94uBmk1/nRm?=
 =?us-ascii?Q?ZMjRNsKLfiaq2HiKsF9lN9G6567Yndukh20z94zeB52Egad2rZPwYrjjr+R/?=
 =?us-ascii?Q?vH9lKC8OnYftWBCB0CVxN5OO4btXdJHaL3ESxy5Jvt756R9A270QNGHzhWHD?=
 =?us-ascii?Q?6G37opRVe5paJhd1MUc5iuOTBruwtiz++DhM8giOc/XtKne+2pMBqr5nOLGZ?=
 =?us-ascii?Q?i6HcNaBht3otzIL9L1feTvy3AGyJrgXAK3creL1TXpC6B8douUc/ClTZkxGO?=
 =?us-ascii?Q?RcrJm0NmcCcn9AG6fCVhNDePGck5blNOWVZfAWgFFKdFN8llg4jChoeJRPAy?=
 =?us-ascii?Q?8NJZUvCy6DTZ57Od8tu8cqy1tRyiBdrz2qmJXWJ76H37PYHY3ujIfufKYyco?=
 =?us-ascii?Q?Nucb0OyGYEN6MMwdcsfuwYh69cUSjoS696LVonPdQxWwrsDaeWAUv4EUe6u/?=
 =?us-ascii?Q?luongrPzi+69vhyD0jTtoHvdlcQOtoaColBwCBcF/GGdBDs+wq6KjtDO6Xly?=
 =?us-ascii?Q?mDfgU96WuJp9IIuSwHm0ONUEJGL43tYjasVQdQl/gEFK0+q9hbzZ9aF94CPq?=
 =?us-ascii?Q?Y7h3be9qx0GAn8A8AhzLVOBuyo7rRc6wh7UZATxoNkI+wF2znSDvl9id7s4B?=
 =?us-ascii?Q?g3vTzb0vyeFv/J+k2YMJs9BQPIQoiNxc+i0qJ+DMrUYOkd+xF9qZg++JiRYj?=
 =?us-ascii?Q?Neuxc5MdIAC5LR3yVoagN1i5PnTCmYQYicA+iGrRTYBrR9GFzrer6lLM0S9C?=
 =?us-ascii?Q?Tq+9D80+l1z1E8qY3cu/rc7D1FV0NPq4M7jbcJhfZHsUCVuRgMnfxmX3+yL1?=
 =?us-ascii?Q?7UnCcL2dEJm8yFyXH6h+hjY1+vu7z14o+ykiGmgd+5sCAew/j861DCzASwW9?=
 =?us-ascii?Q?hyjDy5J9kG9L9N91pu2uF3TEqdDdvZwuhlYPr4ZQm0L8i41Y3kedUK/oAWnC?=
 =?us-ascii?Q?yzEWWsh0QCN9LU8WPAuqjYF1z5yfJfdTGANm3iJbd41dCsTEgD8zOGmAHJ9I?=
 =?us-ascii?Q?qMs4SkV4a7QuAplO0qmvTu7K9M2lcjj1ZCwMworx8AtDYmYDZC+xJI+KirNY?=
 =?us-ascii?Q?AiSiivPhSSceHkcDlSALp75IgCZBHPwflnKde55pBkMbEYuCaeS1PU9ur0O3?=
 =?us-ascii?Q?3qfyWG5pGV9EeSJub8YKfYmURPnGeW/8krplGGRjLdOUAArLMaolcMYIs2eq?=
 =?us-ascii?Q?FaViDe1+Quvz/amzavDRi5574CPRf+t7Yn+QjqDZEuOyTafwiFBOGuWjScqD?=
 =?us-ascii?Q?+muq8TznNRDWQD3UzcuKsUJa3eXVPaY1HkD0BTgZDyjYhYPOpadH5PAsfSMx?=
 =?us-ascii?Q?hVmLddk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ldbNZZQA3vyxtzfg2n92XndPkHbXXDkE7vw+jYQ8sfkskC0e8FQcBoR31P/9?=
 =?us-ascii?Q?FLivlgZ4Uqgfgp7jpXF5smxIM5Hgsh6oVxwQAD4CSev7LjSeIb8h53NiwJ+I?=
 =?us-ascii?Q?Bb0YpDU9HDPK2t/LocR+hLZ5M83ZmFx7k4ldHpPxYDaF5o8OtkBnfC/CGL6B?=
 =?us-ascii?Q?czc6brilhLQ71MNDx96E/UXxEf4Ndl05vW7T/L/dMseGDGxfpdDYS6s2N4T1?=
 =?us-ascii?Q?Mf5HzlNpVi1IWNNKF75b14Vh3SrwZilS6FKDsLIYwiaSMLFvXUuHOfFHOynY?=
 =?us-ascii?Q?xPPCXrZ1O23Ck9uuCB2MCR2Q0W3YGBBpwoEieD6+zuX9ZN0eqjbCoHemmxxu?=
 =?us-ascii?Q?XNB5NpTQTmObcvK4saXHrLUOUGELxJdG4fq7uUzBmYeS7OLRekkjEPR0JYMF?=
 =?us-ascii?Q?Ypn6pzLOoSsQeuUMJ7sx5EJE7p7iubr8medqTYvVSW/koOkM36HqxsJVS95w?=
 =?us-ascii?Q?uTXbp0Uhy7JkY8noGQGbIsYWG+hSIhKaC4KNw9+rX6UquKbKdqHsVoRA1MJU?=
 =?us-ascii?Q?Yh9dVzcKiC+mfo0t4bXdG/bUBR4HIqg7XsuW3ORaWYyrlqTNnTZEmGAG7MkE?=
 =?us-ascii?Q?sGCWYBtW0RagqlNc8sdQPaYYcLJsw0xbxjh4Pzg7v76h5eOhlXCl7A2T1AZp?=
 =?us-ascii?Q?R4InzgltjksddbNkt7KVAeYxRwoSwezqfilW15hHAdvDuIjP9WEKmSPifCwS?=
 =?us-ascii?Q?QQYB9nyTWazGQ6Z2v7siSbX85eYkXRoxBvZhLoe+fX3vKLfUPrn2N7uJxb4p?=
 =?us-ascii?Q?3a/W7robXbJNi6DZuGnL2bjGszs9J1KhSfgZWUe/grvkWNokVfRh/eR3kN3v?=
 =?us-ascii?Q?OqtRex5zlcwQmUDF20kV0JDDwubSSpOsc8s36TeCUUDtWpT5ZV2zXA0FA5Pq?=
 =?us-ascii?Q?TR2j/WgkpYQgEMc97SVbbI4XwNAYMnUAq6Tpefsxflcc2Xszb7ODjBR4In0J?=
 =?us-ascii?Q?4hrlReJtTcT8q6GOu4fVuyrX3GwK47iZPhA8wdh0eWeiN1bhRmrzoGiJpQ8t?=
 =?us-ascii?Q?1cB2IM7HSqn9AV4MC3IzNdxltM4uzST2ND6zUAQSmp/VigIB9jPlX5VLmdpM?=
 =?us-ascii?Q?+E/1LSpI8cJpnYBBRYFdHZa0os3UgB8da9Wr0zd85BAaOhb+xX7f5GSOYdvZ?=
 =?us-ascii?Q?kBFcgxhyQuwCe7trsJFYd81TEmHE8hKTbo3+NXw+y/LDfY91ouEIOk+JlxjV?=
 =?us-ascii?Q?vYbNSs8YmSg1Yyej9PF6nBj+oame2Re8gaNmtjtC0vm3FOiFAej+i+qA4yKc?=
 =?us-ascii?Q?wU+1Pff0MvYOSRav1+7bkKxUso05ltnhVkUvn2hVtvk9xxzQbCLg3l5bZNtd?=
 =?us-ascii?Q?R5IOOh7/iiMEHTISVJpN9Y9TNuM2E2krm1qZ4jjYvnJwfECBnQwWds0OXRkk?=
 =?us-ascii?Q?hu9S8KiOgJPxl43LnalMG1L9V7WTfd5QL7IqsyOmIUPD/pOvMKg2IuRF9Ca2?=
 =?us-ascii?Q?Otewqe76qoL/ZFMsZ6BE8k35HvULPSEargKsIl1JJ4IXlWsuw7h6cxc9zN8m?=
 =?us-ascii?Q?PNPTX46fTU6mkOKIu1tDRSpxUnGGTO23ze+5N2cl4ebRhIlKM2s/mIW0FeGO?=
 =?us-ascii?Q?94HEiSgwDfWh0+sC2Tf2y4kF9knbPLB7tE43FUkg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e4df49-0d04-40fc-3fd2-08dd47ed12e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2025 03:02:50.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KnAUHAndc5ralfm6j1GNWas0j4pRRHR8I2qNttGv/cRVaBi+vbBBlbInf3tJMZDJa/qSe8Pg42OYgYYYGHbdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4866
X-OriginatorOrg: intel.com

On Fri, Feb 07, 2025 at 07:12:04AM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2025, Yan Zhao wrote:
> > Always free obsolete roots when pre-faulting SPTEs in case it's called
> > after a root is invalidated (e.g., by memslot removal) but before any
> > vcpu_enter_guest() processing of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> > 
> > Lack of kvm_mmu_free_obsolete_roots() in this scenario can lead to
> > kvm_mmu_reload() failing to load a new root if the current root hpa is an
> > obsolete root (which is not INVALID_PAGE). Consequently,
> > kvm_arch_vcpu_pre_fault_memory() will retry infinitely due to the checking
> > of is_page_fault_stale().
> > 
> > It's safe to call kvm_mmu_free_obsolete_roots() even if there are no
> > obsolete roots or if it's called a second time when vcpu_enter_guest()
> > later processes KVM_REQ_MMU_FREE_OBSOLETE_ROOTS. This is because
> > kvm_mmu_free_obsolete_roots() sets an obsolete root to INVALID_PAGE and
> > will do nothing to an INVALID_PAGE.
> 
> Why is userspace changing memslots while prefaulting?
It currently only exists in the kvm selftest (written by myself...)
Not sure if there's any real use case like this.

> 
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 47fd3712afe6..72f68458049a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4740,7 +4740,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	/*
> >  	 * reload is efficient when called repeatedly, so we can do it on
> >  	 * every iteration.
> > +	 * Before reload, free obsolete roots in case the prefault is called
> > +	 * after a root is invalidated (e.g., by memslot removal) but
> > +	 * before any vcpu_enter_guest() processing of
> > +	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> >  	 */
> > +	kvm_mmu_free_obsolete_roots(vcpu);
> >  	r = kvm_mmu_reload(vcpu);
> >  	if (r)
> >  		return r;
> 
> I would prefer to do check for obsolete roots in kvm_mmu_reload() itself, but
Yes, it's better!
I previously considered doing in this way, but I was afraid to introduce
overhead (the extra compare) to kvm_mmu_reload(), which is called quite
frequently.

But maybe we can remove the check in vcpu_enter_guest() to reduce the overhead?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..6a1f2780a094 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10731,8 +10731,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                                goto out;
                        }
                }
-               if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
-                       kvm_mmu_free_obsolete_roots(vcpu);
                if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
                        __kvm_migrate_timers(vcpu);
                if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))

> keep the main kvm_check_request() so that the common case handles the resulting
> TLB flush without having to loop back around in vcpu_enter_guest().
Hmm, I'm a little confused.
What's is the resulting TLB flush?



> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 050a0e229a4d..f2b36d32ef40 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -104,6 +104,9 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  
>  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
>  {
> +       if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> +               kvm_mmu_free_obsolete_roots(vcpu);
> +
>         /*
>          * Checking root.hpa is sufficient even when KVM has mirror root.
>          * We can have either:
>

