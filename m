Return-Path: <kvm+bounces-41037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E007EA60DEC
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FB051B60074
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739F11F1537;
	Fri, 14 Mar 2025 09:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HC99k4zN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB49A1DE89E;
	Fri, 14 Mar 2025 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741945924; cv=fail; b=nws4n14IK7hqYbGbtZASMYHb37SpqYUUKrk+XltC+J5eOZQcsYf3Okht8XGviodxENKlZ9JDe9pzOG5diIjD8gh/HC3G6tC24Lh7uxm8sxa6vPDP7UIOgmDY9OLO8KD3Bf5H3zMHahrl5WeCMHfNq2pMpqYMMAQZ/yyMK2n7v1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741945924; c=relaxed/simple;
	bh=NtTaWgGXEdJMcTNxbDoOfahqcLuH3Cx7vl2elLox3v0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qp3zbTXL2DidMjeeszHj0BncSQPeIjTy5pSJrA8+MiNsGHsSkLU6kJIOokU81EnOgW4pUnZJYAH75TL14gkvNEu4R6smcjCZX38+iyRf2AWR+jHBUMXy40bECEvqGTn+g8o5HnntrnK2ZdvKV3lMDf/ojRE5QFdv8HjLO5QfMTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HC99k4zN; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741945923; x=1773481923;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NtTaWgGXEdJMcTNxbDoOfahqcLuH3Cx7vl2elLox3v0=;
  b=HC99k4zNvAK0YPFxXoJKLLGm2SutaR0wTrPj6WQRm+Vj/nYRSPoIzzrX
   RlbqIFjGQUqs6Dc1/Vz2vCYwWNJ4rZ0coJBIt6EuuIGM71abA8+OlmlBC
   JzcFO4agMxwHFvW11W7UvVOxxjrbHenY9BbWbJpzvrgLRD6jyI8CqFlzJ
   Ve8fubtBnGrKBuzcwf5Yg+ti5CKKjl1V76Mu9scvJngIdXLNZDIzjSHM4
   wH7c2MHQtZhIfobUx/7du1NaY0bjYYf/Zv/EGuxaUJb2i9iNLzvyZZxx7
   Ud77vLi7clv5OVGXESI9M/ZdXKKSZR5w6uO+u/xmOlaAhzWHlqkZGRJCd
   A==;
X-CSE-ConnectionGUID: +aCfRHaFT4aW9fr6fCSOvA==
X-CSE-MsgGUID: 8kbz1pScSFCoAcnaFSw+pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43196074"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="43196074"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 02:52:02 -0700
X-CSE-ConnectionGUID: Lyunp3ZPRTOYLUjuRkEbdA==
X-CSE-MsgGUID: qDyEwWU0SDeQbKGspd+IKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="120941813"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2025 02:52:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Mar 2025 02:52:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 02:52:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 02:52:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9/4VxtFIF5NiZvCxL19edJ805yfV/nC61P1Z6uEw+eCKDOF3vivCw6eQorKLStzICDGeewSBRUssursMxClFi7Kz2R4YbSoPgLZ3N8CfxeV3kB3l+ozszhlAGN4fjYqrCSQgA73CXNEuCdM8XSafOBRMrK7G1tiXPMWIsCEa/AhiGxhdfsimNmuBjPTSolc5rQbPcXWipDMLf96tF/feZn3kuOAsw2AoiUJrypBGTxUxdmNK+hoJbNWXjW9SZo+7mGcu/yNEoF//CR5Q+QaCo64vfDaBah5h5bGVjrPZzMceNJFYlmwh/aUUgSOmdPLP1wKJdetM4XXPdgk0BETJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onT957x0HHOF6wNCsejeJJ0Xt9t55HU0mfpnCnLSt90=;
 b=iyGBniNtyw7sBpOfVKX3kmB25m3OnUrMP5sKauW3hI/b7Nt43ZbAMer1Aruh8tB049y2qR4qfqKWvdWx0Ozr+hTkKzOh0kcAdInRUduDMoZ0nXOqdcrzQtfyaGBZCAQwgYddsSZLU4PMgVC6jFr7fPmmygXkUBrmxPVJDpklDvGMF0iXKIl/s7pkKC2PX/kTUEUaIml+fSnKJbKkZXxjRxOoUeSQ/MiB6wN8wvDiO5mkxu68Dh4ZbE5jseyyb5ojf5Kqc7fmCZQs3ETeid6+nfpHDvWf+DMoKiyR8UsLA/EPXQoTDGmsf1XsJ05iFFZSnqb0IB9lnRAiOzc3dbczFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5831.namprd11.prod.outlook.com (2603:10b6:510:14b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Fri, 14 Mar
 2025 09:51:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 09:51:58 +0000
Date: Fri, 14 Mar 2025 17:50:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 5/5] KVM: Add hugepage support for dedicated guest memory
Message-ID: <Z9P74jUTsWo3CHGy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <20241212063635.712877-6-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241212063635.712877-6-michael.roth@amd.com>
X-ClientProxiedBy: KL1PR01CA0158.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::14) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: b5078ec9-60b4-4306-5c97-08dd62dddc1b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JlCxJMzACrsAwt90RPliZKsa1fwak1cdmwvwLi8fmx8bAvfVfJ9bcLyqENJL?=
 =?us-ascii?Q?cucb49+9gYrzruVlNTw1IoASkBqAuDM63LpYB2cnAX/l4jGYZnZq+NpTc63D?=
 =?us-ascii?Q?bSGTPGdfp2ePKYPP78fgg9P7chzTuiy4A2VSywU0g2NkeHLgAG6oUgxt/ejv?=
 =?us-ascii?Q?u+qNYRtQQV0d0hlMw+6OCxB9YnRPjxic5eFAygCZ5b8uawOXCUI3fPcj0hIu?=
 =?us-ascii?Q?ZPsCsbo+IO02PhA/ybnwm3jU2Aiw6ODbb1V91lpGqU42Ra4aZukgeVuZAp7L?=
 =?us-ascii?Q?2dnmD2XMgsVPfcfYJzgpEhRBrewA4J+2XZbgLSF8GarwbMKJaEfoAiS2vZdW?=
 =?us-ascii?Q?ssLBBmlQRcOQPFHUH3irNI9jv0T0xv2NJ9Q4TIsp8lCXDgKd6u9OLpambZMz?=
 =?us-ascii?Q?D1DOMYLDRUun36AG+BIWW+rUl9nVVhpqdkGD9V3JdL3tqLJkFwKQoAyBXkp4?=
 =?us-ascii?Q?LPBmcyNgukmJKO9OcbO1+SX+cH2jE5AI/HbIF1Jiam2vmYN8+7oXxB58wllJ?=
 =?us-ascii?Q?1EzCbep3uhs25yEIOOt9b4PqpKZ0DKzbUhtlN9TbmT1bT+xMciKE2wjx0fSt?=
 =?us-ascii?Q?X16TJfeYL4EEuJqzQ2EBLAfFBls1xkxp5efu3Bg+R2mEHDjgWCaB2AEGDyzF?=
 =?us-ascii?Q?u//7Y9hwEYAqx2/GTuo2hXjqgZyKfsDtzWp7zyKiajHQQKxQXeWAi5Myrpol?=
 =?us-ascii?Q?LTmVT1757tTH7dLdXrF9+NOX0oiJxmM7T3zC1EFzgfaFcwCjwPsG0OSIYxAg?=
 =?us-ascii?Q?/JFkWkRm0j8Yohi7S1Pr8ukfKf3aKf6uVrZhvE/GJq8eQq++WA2Yeq7cJVOZ?=
 =?us-ascii?Q?oruItnKLyrcsKB0vlrQQ+rzCjswn102lTAPRuvsV6bfMUZdms3CPyXJqBqTc?=
 =?us-ascii?Q?1/UFsmPuJj0piezywmP/Ye7BMCGtkiKp3LDVMQeJTWBVN/sg7tMtAQc390Ks?=
 =?us-ascii?Q?6edOuS+nH69Au9K70FMRrR0w2y7/avTC0DSyX5BSBFzNSxxx2XQz9+zrPtpH?=
 =?us-ascii?Q?wRTOjZwbNnuj3JOTkaenmTmT8wFHp3RJokpPZNNCNlAVx+A+10A3SgkVUUvH?=
 =?us-ascii?Q?7q7ggtnEnVUkSFYri4zOQokr+2W8pGE3hOMAA6TTvnqjcYQoleXRMqKtE/Sp?=
 =?us-ascii?Q?t577/JGFIByYGPg70679oST8b3YnpM5TELJhkgAOqWeBcfypGttGzvzBJw7g?=
 =?us-ascii?Q?iKvH06Ms+Yafbnh98Hm+3atMVnyXQ0oK5eM3g43hWOyWtwSPqF6+ZJPRNB02?=
 =?us-ascii?Q?D5JHbcBkfqsggBJKBh2qDJtamk8nwDx48NOfoHUuQL+L0IAScXpZ/0ohSNod?=
 =?us-ascii?Q?EcHvx12E9EJDbU64Pqdi42ewnTkjB3COjV1SWUzZTfIeRMpvC0w9aOz4R51u?=
 =?us-ascii?Q?WpXDPc8Mj9ODmMRp6bVbjNRvxdN2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KpaUFv0LOPDxqGoMf3Y85QCZg9jUfrpTeh7j8Vl7eyVD89jDjn2FJJp9D3Dd?=
 =?us-ascii?Q?AYOlfFHl0hlr+9n9vDd63yOY4iKEb9X0DYht/CozcCVjcr/XK7jpR6nTDCxI?=
 =?us-ascii?Q?AvTViV7VucQhtGig/XgvfK4OriwVD+k0w0vXeGyxCFV4bU2+HVqroviwmwC0?=
 =?us-ascii?Q?4RI8ZIeJREFZPrJykSMRWbJKZ2Y/xsZJEG7l4KUFtNmcRBkJYtbWMjzhusrL?=
 =?us-ascii?Q?k0vj2cN4mPbHKr/lWPGuDgDeoERsxadCQzK4NZx7vMoFcrR7BI7I9Rs2il8j?=
 =?us-ascii?Q?V9zQhH5GCc+KMvStsZVHCDwnuZ9yF1eSLssCZGO9AKAj8Jyc+grmPi8XAuku?=
 =?us-ascii?Q?ST519QlSoVbR/HZeI1RNhQl6roAdtCyho4JtuPbHgdKYZzXelNqHOGKGcZQ7?=
 =?us-ascii?Q?TauUpyBQokR1+YtQ19ZMnYrTm4dmBfn4CweF0N3zlOucxSJoJe/VgXSPhB3J?=
 =?us-ascii?Q?Aa+ZiMeGs00CBugBXDsrhbgKB2MNNgcyhZoswt26Tmn/JLPDfdCV5bzrCJcV?=
 =?us-ascii?Q?83OUoGvzB0jzJU4h3W6IwNhjn1LL5AMq14n5KcoHTFdVxfxCVlU6hEd+sg3p?=
 =?us-ascii?Q?VzqwRyMPDC9YCNh54woaZAzQ6M4xVvwhBIsWT2cWe3AVDL3s4TlhmHOc0n9f?=
 =?us-ascii?Q?6KHIukYeiSLQkLBVCgk3bTcG8dREEnQr3ts53TF2TtJdotm+s2jGAy82kLpK?=
 =?us-ascii?Q?D30pCPU3MJfVYfniCFLEIPfgWpI+bItAOclxJZ/Zxk2CSka7iLJEJt+SjJIW?=
 =?us-ascii?Q?O20xixX5kkn5Q4zDEBAjc4fj3zNc1pL8Bh/scsnEirKeg6ACsCeESen3MXfo?=
 =?us-ascii?Q?meZv7plu4uYnSFoPwNykU6CKJ+tb2uE6GNOBP3eKZRYmiif1IYkzPs8JXcBq?=
 =?us-ascii?Q?dIpmfkAvy4Ue1Kk/ArmEkWmsrlYPcuLMNIZsFiKEwRVSsH8RzU3kKPoAxFv9?=
 =?us-ascii?Q?WyCRegl8O7FRXlY3JJaLmHD31rauV8SwCoL/VFtGkF6GT0PAtqCSqUqxzQYb?=
 =?us-ascii?Q?ff6nE6KejuF4hXUzcxRu9vcyxnZb6D0+3JtCWc4mkNV9dWIrVVRXSrCXl73Q?=
 =?us-ascii?Q?ovZZgK6yNppYGpkQazwKFVjFG0vBA7NhfSHUto6oM9jJuOijZiMO33o7GHc4?=
 =?us-ascii?Q?teFC1Xo7lrvcNGGq5+pqXvV+C9/nJWt2Kyn+UJsC/+AI70yWHCl3qVmQKFNh?=
 =?us-ascii?Q?4S2Uw3/VdVt34M9ufI1U7g8cDO3XbJT/TgNeOBjTa8FNYdtVzzYeI9tUctiD?=
 =?us-ascii?Q?mguMhZgXQlSCT1LNTpxBq0HAGFgUW1WzbZS9JKDPfrS1Brj/DZBchwj/+ORx?=
 =?us-ascii?Q?DQUUZSFLVeqDeCGDo/g/wqyS+qSuFZfskYJ3i96LA/goZHB8JCN24hBM+T1q?=
 =?us-ascii?Q?i2yObv8w0txDZKOfE4kup70T7NNqBoSIz+EYgSoYgSekH7wkztDEk9ScTWW/?=
 =?us-ascii?Q?4/86ymSnC3X8BH4J1JZGoZNWkHMLQrESCOOvgPhjdEM2piaoWWU4R2CbkqO8?=
 =?us-ascii?Q?ig4c1ozxZo2Kx39rv70Iw4N1H5ts71jxxQ0nnpeRf3BiCTU58PdF0pjRQKmL?=
 =?us-ascii?Q?S0gABysncakl3XTVuz71DDzpLGPYrmuysvF5Mymv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5078ec9-60b4-4306-5c97-08dd62dddc1b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 09:51:58.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6hSVg7Hm9Fpz1V4wxkKrr6MulJjJ/0Ow9Fer5XxcD/t2jBActaNPP1qvUBRKQ59XM3OnsvKUtCLs557idVv7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5831
X-OriginatorOrg: intel.com

> +static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
> +					     unsigned int order)
> +{
> +	pgoff_t npages = 1UL << order;
> +	pgoff_t huge_index = round_down(index, npages);
> +	struct address_space *mapping  = inode->i_mapping;
> +	gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOWARN;
> +	loff_t size = i_size_read(inode);
> +	struct folio *folio;
> +
> +	/* Make sure hugepages would be fully-contained by inode */
> +	if ((huge_index + npages) * PAGE_SIZE > size)
> +		return NULL;
> +
> +	if (filemap_range_has_page(mapping, (loff_t)huge_index << PAGE_SHIFT,
> +				   (loff_t)(huge_index + npages - 1) << PAGE_SHIFT))
> +		return NULL;
> +
> +	folio = filemap_alloc_folio(gfp, order);
> +	if (!folio)
> +		return NULL;
Instead of returning NULL here, what about invoking __filemap_get_folio()
directly as below?

> +	if (filemap_add_folio(mapping, folio, huge_index, gfp)) {
> +		folio_put(folio);
> +		return NULL;
> +	}
> +
> +	return folio;
> +}
> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -284,8 +314,15 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
>   */
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
> -	/* TODO: Support huge pages. */
> -	return filemap_grab_folio(inode->i_mapping, index);
> +	struct folio *folio = NULL;
> +
> +	if (gmem_2m_enabled)
> +		folio = kvm_gmem_get_huge_folio(inode, index, PMD_ORDER);
> +
> +	if (!folio)
Also need to check IS_ERR(folio).

> +		folio = filemap_grab_folio(inode->i_mapping, index);
> +
> +	return folio;
>  }
Could we introduce a common helper to calculate max_order by checking for
gfn/index alignment and ensuring memory attributes in range are uniform?

Then we can pass in the max_order to kvm_gmem_get_folio() and only allocate huge
folio when it's necessary.

static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, int max_order)
{                                                                                
        struct folio *folio = NULL;                                              
                                                                                 
        if (max_order >= PMD_ORDER) {                                            
                fgf_t fgp_flags = FGP_LOCK | FGP_ACCESSED | FGP_CREAT;           
                                                                                 
                fgp_flags |= fgf_set_order(1U << (PAGE_SHIFT + PMD_ORDER));      
                folio = __filemap_get_folio(inode->i_mapping, index, fgp_flags,  
                        mapping_gfp_mask(inode->i_mapping));                     
        }                                                                        
                                                                                 
        if (!folio || IS_ERR(folio))                                             
                folio = filemap_grab_folio(inode->i_mapping, index);             
                                                                                 
        return folio;                                                            
}

