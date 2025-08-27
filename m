Return-Path: <kvm+bounces-55862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53766B37E44
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07985687DB8
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B2B341646;
	Wed, 27 Aug 2025 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBn6WacV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B92D1D7E5B;
	Wed, 27 Aug 2025 09:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756285389; cv=fail; b=oof4DpZBN08oGawPVfz8NWrVyZJ/s0qqkeFyDfJWnbmfB9XdgU+wMwjadM7a5DYH5WsC9bUBvkGRgNLxn9ZwbzVZTl3U7TNohjMWuQLShSLO8vqnfKI/To6pNAJm1setsC6jjcYZxSyO3XU+XsEBVl0KqDEokVXrQpLHQH+7zAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756285389; c=relaxed/simple;
	bh=stQYtV4yhOdJNq8bKo4lcLMPrhwb3CkAOZNjcJX7rYE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fP8C8Ju2ccZu+6nU0JVXA9MfOY5kBvSX4M0e3RtFsceQMQmeDdAZdxPvxKqWV4sKcVdcpG3WNBqcqEMGNnXDs88WUPpXyH56haAeC5qpOTRWs3+sxgYhSm7zjmtvEBeQ4VADuJnYkY/mAlt+WRwjl/9E53S5/yjL3tL7n50KAe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBn6WacV; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756285388; x=1787821388;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=stQYtV4yhOdJNq8bKo4lcLMPrhwb3CkAOZNjcJX7rYE=;
  b=XBn6WacV4dpsJLUaAh6ZSZXWgPwVsmQCh1ozUL66Hc9UjiwU0Zej6um0
   pNG1a6KwNzk/kPxKSHhU5eMFuDxUPDjYKMbgqTLLDdIOCCOpP143JJusx
   BgRN+eKcM+iv1Bzs9pjFOaQpg3nf9KqCxsUBZKRcEipMHa31KAgZQ46fD
   vdXFbKMQJWIiixW2Op7z69f3cJzO/4cqeaKDhGxiXlH3c/pqt0CBcOHa7
   txrD+exCd4pTcROlbCwzdMeVR1ukeQomMGLSRmFWp+m416byJHSb68IUI
   m6NANnwGHwPD/vyGLdk94VhHOLY/qbLGewvHnuqMxlZ6dAPijxFKW3p5O
   g==;
X-CSE-ConnectionGUID: oPz0Ds30T8G6yFxPGxLtVQ==
X-CSE-MsgGUID: B8eV8eHATeykXNM0MeE/Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69126156"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69126156"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:03:06 -0700
X-CSE-ConnectionGUID: ReEhNa9OSzmS8MBZiW9SYQ==
X-CSE-MsgGUID: UR69k5nWTTWnt6hC5oFDug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="206963558"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:03:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:03:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:03:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.46)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oVyietQ/IyaPoZDZxsMqc+wnQ7up59b90CvjI2d10xcwzhBazLVrpQTvS2Z2Q+Ae+qTI5Z/srs50Y3zaHYGM1hTkB4N++3uF+aZftPddc3O2EG8+8BiwOAhep4tvhLBxgK/A5M1gS+G397c6iL1DEBbBb9iFDhkT9Y+R/3h9WDfcq+HJHnTTx88P2NKZtoFBDUoBiZwd8yl8E9T5NA+BUs+dWeXvlg7p2wSVz/2Lbg/2GFRXZXhP3hEkQDY22EYBlxtXjJxcY+5AFfgxizddZ470FP0KuTBZQI34hOjy/SUIaiooQbqLtSR2okNXVU4c6aSepBFkENe6NIDQKQN3HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MGICE+6sgHIWTwr6yG4EvqsF9dE1hEC4IrW/XxfwQI=;
 b=cqkanzYp0dhXiVkaArj/rmmjUU+EWbdFxIghC+EklSeOGev+ltolpoEI+UWWvHH44n+xv41EEGxID9OvrpU7yeaUYanhjezgQ0iYnLAz7qG/hZfON5bqYUIZ6S3JA0jEnFuH4gAnjUikEf32MxeWDVg6HCqiDaHwihi+djcVQH1Nf48+JGF28mbE+2EDh504yV7X2/fgUe5kqk+kajCVBc7+gxENzJbjT6G3k46TRqT0RZ9QjGhPnHaKaTAIhw4i3LxdIGe4CRwb9jVhyK/IlQaLj3gTrwzmAc4AsTbMWe5ZhVgUf12GjfN9Y/W8fHWtnY/FPZ99RCCrxGSXcaGVHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7269.namprd11.prod.outlook.com (2603:10b6:208:42b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 09:02:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 09:02:52 +0000
Date: Wed, 27 Aug 2025 17:02:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-10-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0185.apcprd06.prod.outlook.com (2603:1096:4:1::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7269:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d004767-198c-40c6-47a3-08dde5488140
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?u+xm1IlM0BW/r+f4n6owbbo7+iNcw1BFsGaWwLEQMLVXcOQeVpjq8VBfDpf6?=
 =?us-ascii?Q?cZ2Pxm4vfCXZyRRD2pPfc8pGkwTdOZahvRA/8r6qsnfZondFjQ0VOQwQukri?=
 =?us-ascii?Q?ULQzpV9fbkvwEprJSej0GVTftT6ssJX3p0YlXY9pLCAVc75axyBOqTxfCx8r?=
 =?us-ascii?Q?eBASACQForB6KmTZItnaXog532MGmbV0IBdNMVTjfodVOOFDn3U/NAavAK4c?=
 =?us-ascii?Q?x/OpO5TiWVAZTXfRPo3ra5AG7CGkIWr2rD5ViUjEEkeAG/4eS7u48/harmUo?=
 =?us-ascii?Q?AcOeUDr+35sDTiywLgzjyriRiJH2rciz7J64AxnHxskWlwvDVvVm1hcRjqyw?=
 =?us-ascii?Q?uymNN2+a0Qx64CBC6H96vo8yl/k1TSjvfr+IdOKdvy8cFRgnp1yNY5as9lAM?=
 =?us-ascii?Q?PxsfZRnUkA29UDIBSRgQN6/s5l8P59A/1av9IcUw46qEjpV0VITOl/s01nAo?=
 =?us-ascii?Q?KoGm9fuls2UoDsRPBoGgD2B0zdj0HsPMlaopfDf6BQI+EbDQHkUCv3H/hNh2?=
 =?us-ascii?Q?IeO7wC8j1heQtXWZd8IigJZTlQ1eVUBIAVnG+eYK1PDPPMe2LEUMJ1AbHf62?=
 =?us-ascii?Q?uaU2iYyaQisRryWYrWgFF5b3n5xb7iW0oSuSMU9x2QiI5adhuly56TXi2bVP?=
 =?us-ascii?Q?RXmRI8gxXAwaROAoPopoHZO6inIqcxmOL1OU/WgoutaBzlgAy/9xSQ6BuNNY?=
 =?us-ascii?Q?NprEuh1Ib/ruc0A8VChqwaFrVKohJ7KaV1efM0UTDlRgz9cjdNrvho4IRJnk?=
 =?us-ascii?Q?KFMZ9OYvk9+q4M0wepDIP22ydktHbM9QzViUV4VxGnP5zQQ1zOjZ/q49sxP4?=
 =?us-ascii?Q?6NUTa/AhxwjZFzNR1F3xtLUsNNRUyVMwFcbZhAVH7/PSA3QTtiDF9CQlKYbW?=
 =?us-ascii?Q?4gue2QXtn/UQWkpM0aMCfWKSG5X5QnygaMnz1u+lVNw/gnGjRiIgP4VlJ6SH?=
 =?us-ascii?Q?qjVEMJHqIqnqntVds1BZpy+IVv47G4R2J1o1IZ1YLFVXVs38GBuk56r0QBCS?=
 =?us-ascii?Q?BHt3AkXNtbZAK8I8osChpBFgX2BTf+LGdBtZmnBvqi7iUmbuxCdJ2FdNdkhI?=
 =?us-ascii?Q?3QHwk5AzEAnjqYnNdaXDaFU0aCJS8VlNHUs8Vox0LYfUBzGGWt6TNcf+xCgh?=
 =?us-ascii?Q?1d6LAxPXgh9cYqLMWd8HMstMcZ6Pm3hjO7DJ8Qk0Eh9kRXeiW9wWr6F1uf8k?=
 =?us-ascii?Q?GUm5fvlSvI5FxsGvDXEoJKvSvtM/SZEZ6Mf1MfQE8c+qj4eGRVq9Go+qpbcQ?=
 =?us-ascii?Q?gjFeDyhnS8Gjm9DB2Q/exKaJU5gOmwaiFgmQicSD83sU6+J8kw1jjevh44OL?=
 =?us-ascii?Q?Ztcs7zYzYJJ1qZtRut+DQlIiHdPVoFSwNyZjO/viUZyNR3zslVu/MsPf1dmY?=
 =?us-ascii?Q?1qXjM4Wb6zr3eDzqhDZukrfGDWMMTwIq4YS5F5CGpEy+wk5o+43jxbTcCx+Q?=
 =?us-ascii?Q?z8NmVby3y+s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IlNp67EMTrGuxlemZ3jNwMdzcd5hgNBZp/4t5ux51fHPWh3pQ6V8vn3e2kJI?=
 =?us-ascii?Q?FqFElsODM63g9w0NsxM3I7xaqf/VLuZJSnl3nIvYpLvQP9Rr/5uYaMOHplmH?=
 =?us-ascii?Q?1BZdaN6L7JqH7y/Ph4hAr/PI1qK4NnfeKit3iUXQ1Q6eFU42ucfAceI7V6ON?=
 =?us-ascii?Q?tPgn7YWiDC2ZPkz+8kYT/QgfC/TT73R4JP7S390C+X434WVGe883UitWsLEC?=
 =?us-ascii?Q?CKIRIFSDcydzAa0ePid1dSulvxZiTc++pCiceVasKc8ziXgAKbYvsy9NdSPX?=
 =?us-ascii?Q?itVM4owBmr9Bhb9HIoYY4E97raI4V7Bv3YlPqwAdi6fSdXE/NA+s/P9w7LE5?=
 =?us-ascii?Q?mSX90xjWIgxszy9CVPZCx5IY8SrcQPq/JLpAPchMnU9rwyYU/vE5cr4Rys4D?=
 =?us-ascii?Q?8tuvfk1RoqaFp+/iKCz6mjQVENhPKmo5ti74pPJtFLFIP/9teIwuM1ha1xlW?=
 =?us-ascii?Q?USaimYAaA9qKj7IQbky0PVUbcYXPPK3DLjMy4T15Q7StufHnhDONqBCr3xnO?=
 =?us-ascii?Q?OLTcSxtKEJYl9SZKpt/pKvbsste1Se6I2iHKEHgwitMOyeJOHxWkTI5PdblO?=
 =?us-ascii?Q?JAkayHXpOdrPb0oCFcWwQMK0VTANUa/9s3nKuVYEwGompNH9k2iWF+2yVCaU?=
 =?us-ascii?Q?ddstDofbNCb12HXCIerYbMHZ9m2wREcCHXpDY+eQVIWkPRKTB0ndyI3b7A6E?=
 =?us-ascii?Q?7yuZuM4Q7ay6HU5Aq3nYy70niLsKjVwNNwvXImHv4oPYF7dvwFwFtkCNfPMl?=
 =?us-ascii?Q?q+RqgUnLgJvnuWXWIozfRrw+8n2exMh12kAlgABsrtlgB30l1DKAkcfw23gU?=
 =?us-ascii?Q?ruBepEH2/Zy/Ksn5w0r4bAg/7DVnA9BVdIwOcfSV9VeQeA7EpQ5oG85iV8vP?=
 =?us-ascii?Q?BZ9odgqITfkzkNk5HvomC6jCDhCmX8raALKVfJOPTWvA2qaR1ttfsDkxCW7x?=
 =?us-ascii?Q?XGp8fB/P6z+fshsQEiU0H26QJ4SQrdVWJd253TNZ87y36lMrMh32FI/tZqiV?=
 =?us-ascii?Q?Dm5WW8VpMuQMan49sUQYNaGDWIxI/fUJ4/GOwSscS2EzGV/YGIWuILDWSgVo?=
 =?us-ascii?Q?8fqH1sVafNuhvggzwJABSkTFfDp30M2yXfxsm2pkCqaYdVKtp8eMtwfPECZD?=
 =?us-ascii?Q?3bYXHv6In7AluBNNGXoGddh/GABpDjo9k2zyrdAMWqGTZJo2qSxtpcxjq2he?=
 =?us-ascii?Q?rc8P7fkOL+6bOZE8zPZLApVb8FHoeTcgt4L3lDgsDiXROW71B7c6a29JAFXp?=
 =?us-ascii?Q?a+284xbvU3TxzbKcMx9NBIigpC+9JpoEmHWTwFiYmCQNB1cQwSMXd/B2U0z7?=
 =?us-ascii?Q?r7vDaDAJnZ+IqWpM1i/lYaQ9qKtyKWY4HYqAof3vT0Jh2jCiIg/swlkmDZuJ?=
 =?us-ascii?Q?acodxncvuRAkJeXiimM0ENKqM5M8pi7NtjuV9HAOpoXcUPrP5cYwx+Mmhlad?=
 =?us-ascii?Q?QmuuFBQnUELs+rwq5nqiVDidslsRKcXm596hUjT1olJyFHXVAEFgLp7JnGkY?=
 =?us-ascii?Q?NM5K5Qn2MXXpYYN8kolOHXi7Vt9YqrZPTR/bFPPip3lJjx6uQeBvbjollMI1?=
 =?us-ascii?Q?0T+TcFbuT8E9Rh7VL5k+GaCYmYyi3OGffBiHy8+a?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d004767-198c-40c6-47a3-08dde5488140
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:02:52.6574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJ0ELxHzw95jd9055sIKcBon16VnYm6mueOvBpfKX0A66wPcHoJngkMwVDgNQwWoOSu2yxfGA8UB2ZBrVhFbJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7269
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
> Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
> providing a one-off helper for effectively three lines of code is at best a
> wash, and splitting the code makes the comment for smp_rmb()  _extremely_
> confusing as the comment talks about reading kvm->arch.pre_fault_allowed
> before kvm_tdx->state, but the immediately visible code does the exact
> opposite.
> 
> Opportunistically rewrite the comments to more explicitly explain who is
> checking what, as well as _why_ the ordering matters.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 49 ++++++++++++++++++------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b7559ea1e353..e4b70c0dbda3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1608,29 +1608,6 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  	return 0;
>  }
>  
> -/*
> - * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
> - * callback tdx_gmem_post_populate() then maps pages into private memory.
> - * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
> - * private EPT structures for the page to have been built before, which is
> - * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
> - * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
> - * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
> - * are no half-initialized shared EPT pages.
> - */
> -static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> -					  enum pg_level level, kvm_pfn_t pfn)
> -{
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -
> -	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> -		return -EIO;
> -
> -	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
> -	atomic64_inc(&kvm_tdx->nr_premapped);
> -	return 0;
> -}
> -
>  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, kvm_pfn_t pfn)
>  {
> @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  		return -EIO;
>  
>  	/*
> -	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> -	 * barrier in tdx_td_finalize().
> +	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
> +	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
> +	 * arbitrary memory until the initial memory image is finalized.  Pairs
> +	 * with the smp_wmb() in tdx_td_finalize().
>  	 */
>  	smp_rmb();
> -	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> -		return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  
> -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> +	/*
> +	 * If the TD isn't finalized/runnable, then userspace is initializing
> +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> +	 * the counter to ensure all mapped pages have been added to the image,
> +	 * to prevent running the TD with uninitialized memory.
To prevent the mismatch between mirror EPT and the S-EPT?

e.g., Before KVM_TDX_FINALIZE_VM,
if userspace performs a zap after the TDH.MEM.PAGE.ADD, the page will be removed
from the S-EPT. The count of nr_premapped will not change after the successful
TDH.MEM.RANGE.BLOCK and TDH.MEM.PAGE.REMOVE.

As a result, the TD will still run with uninitialized memory.

> +	 */
> +	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
> +		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> +			return -EIO;
> +
> +		atomic64_inc(&kvm_tdx->nr_premapped);
> +		return 0;
> +	}
> +
> +	return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  }
>  
>  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

