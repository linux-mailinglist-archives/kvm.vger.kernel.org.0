Return-Path: <kvm+bounces-25329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D34D963BAC
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 08:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72E54B23008
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B34016D306;
	Thu, 29 Aug 2024 06:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INvh+kCe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730D158556;
	Thu, 29 Aug 2024 06:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724912993; cv=fail; b=jkw2pAMxM4INZeylB0mvHQQnjJkAh2Fmxew6vp/76XkwmAMUDjTgG3FKqVSTtSxljo/gCC0Y48MiaFPgd6Odp5r/KHGGa2ady3WG+lO//2oRNO3Vp8T0DQCHOL/awTRsVe3+Oyu3nvr40r8kBnRFYe0dC5Mr6RwCPSTmFOyPiDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724912993; c=relaxed/simple;
	bh=iFUf2Bz51pnCKdmvmuOfaZ+9ZRra6BWbVTHpFI8Tqzg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jfeQkmBkG3mUVCM8YREpN0a2WpjFCsdjAmg+/25uq4leGBF8H6fn9tudZtFsuPaGMMic2a3R9LWkhxPNUmgnfRKgV7JVmiwu90sN02BjQl398qfXNld5rEjLJvllY+kg8XgXNK2TdUwkk/FDih8DuGGTUytYSIugrriS5L693Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INvh+kCe; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724912991; x=1756448991;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=iFUf2Bz51pnCKdmvmuOfaZ+9ZRra6BWbVTHpFI8Tqzg=;
  b=INvh+kCeerXIR+SuC2lwsKR5ItIv4S3PFkSJ9t3sCCIn4+U8cJNFSq7j
   SRWMJP4jGvvtswdYL9eEjiGJcPXaN0v5Qu+sKNurhHA9STYMRGOrOhNxR
   70YbtYb4h/YpF1foY0XDxI5d9quY8u0N9V9HEvlwFl93HgDUfOCmu5m9O
   ZOGnYbxAKkf+aQYvU0/iPgqS6r8UWYHfpUZivsCo9mA2jXFt27TblO+ci
   9Sh9Oo4mKzniz9tvMe3Jr+vNMAbOS2LcAnK4nq0LevbeIKZqIgAaVwbxX
   TngUTrspfZcnCsUtQhRJar8VIkKSpY/rvrZraGozYJ/YyUK9woTNLVLvH
   w==;
X-CSE-ConnectionGUID: JSYFM0o8TxaSvQy58tUpDw==
X-CSE-MsgGUID: CxPcUeDLScm5Nu0Z5eF0yA==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34862562"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="34862562"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 23:29:51 -0700
X-CSE-ConnectionGUID: txqSrVfYQ1O96PdS3kDzRw==
X-CSE-MsgGUID: RUEw6lM9Q/WUvL3AUsQVPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63659749"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 23:29:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 23:29:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 23:29:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 23:29:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 23:29:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSN55a9ggBOuARkE2MYBucw3hK0enDDaCm9D76vcpa4+UH8p+wjsLUgunyfZf+Y5ZN2OOxiFjS/ilD3OKuxmze301QQ5VSdKjn4Z285RTO1WQvlPayEes/rIttVKAC6Yc6Zqonud+RyL/WOFp7Z15DUEsTfaE67hug/hM5u6Ra2a3kS5Hjpg/al7M1fNkfjhDOfw9BfvlUC81vKgIG7BJ5EgaEhM2Ys60tfdH2fHUJLSsNmXOas91kytKkGsY/1AvlHW8N4CQGMivVe1ozT5sQE51r3bqmyDt+uQ4GRIRV5/K6DeXcpkxrG3SSKYwiAcvSnLxcb3czrmg8C+S39RhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4yu528YKHWVwvzZRrBjupnk9Nsx3UrvCzpefAuJm+s=;
 b=UcGsNSyV4CbI0pKUg/hZtgbZiEDO3HxSzE51DtApp8PLKG05NHZdjB/IHbRYuyWhJpy7jgJAQTv335Kftga/szzr6QLD8vDi5JYReTuR6qKq3W9HLGUfwzfxkxU2ujbpoSOELpcfV6S9ubqKr8GnUXdBJdoYAcK6jRoEfNp28IPft2sSfOsrT1iAA5Docg/Btwv+7egPJYCsF8e30HvT0Y2URoE8xqlKk99LfeCi8CF8f18waf+Y1DVHUAPE9I6XFuFJltAOfvtL49ucmBCGxcDNEKl/MA6Cp6YbhIR1tWA6VIT0IN3I8VC/mjz0LQDUz2lAwBWqsSfCGDcQviXsAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5806.namprd11.prod.outlook.com (2603:10b6:510:14b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 06:29:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 06:29:46 +0000
Date: Thu, 29 Aug 2024 14:27:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-15-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7be7d5-d223-400c-4ca5-08dcc7f3f9f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NJZpTj+pyqEOdNBYDCfBld4VBBQ9InZPIdfe34opee8ZjdR6HF8gdP4FO3l6?=
 =?us-ascii?Q?0vYjLgvhBvfHiGVjkhR8laqEbAM1QeFmghkg2BXEGsz6Tj8699BDTWxS8LPZ?=
 =?us-ascii?Q?kj00lL2tA/rpPF8Ih5nAXSRLpHrNiJ8IZSRSRA9Bv9OUAOGbSJdvcWjkPReI?=
 =?us-ascii?Q?YmS74Sp4FYHuX0X9lxir0aVyT7q6ppgK15D/wHxiS4ilC47ZgtUvB7zHiMQm?=
 =?us-ascii?Q?uDCLAmAf9i1Yx3SzMHmftBwnZyCEqJrM89X0YghCPIzGulyBWiiOFjBIMZM7?=
 =?us-ascii?Q?FYSL+EYc88JJUyULsLsi4kLzxShNB1qmsp8CiiLZtx5dBdq03emyIkjSFPmP?=
 =?us-ascii?Q?T6JatwqkoeoooP1h2Jh9vkexGDHNRh8ncCFe2fjoR00lMWz6oKcotCFXzzLt?=
 =?us-ascii?Q?lG8FLsRZT2H2XRzmKT8TxptDqRNj//8tUP7EMbD0yoGy51P7DEcRwZFcqE5w?=
 =?us-ascii?Q?yO10d15WrvF61DynDACPTIjJO9OetHsS9c8OudUzf2zINl6+cCgOeTXaE/H1?=
 =?us-ascii?Q?oI6eFI1iJN3IrX9sRPori9e/qGNnQO52+lA/HpbX+5hLgPEi12+VyctTmKjK?=
 =?us-ascii?Q?n0D/GH9iWC3Pu2DXI/yNgvgAtdZz4xYO63ScNNbP0Eea5gdb+m0DpZEOlbpj?=
 =?us-ascii?Q?IIqp5il/pjkcTOsTMLFhG5aMYukrUXSFSNeyGGx8bT7pnuppUmO0KkUCTkX1?=
 =?us-ascii?Q?IidEeUOgYuf70Cxb6Vp3yhJkOYIelX0xdXp0zcP2vDDOoEAJGXuR4AvmlJOj?=
 =?us-ascii?Q?ZdiMhPsIoStPOVjb4WqPyXK3apfMiy6PFZMoX8IetIwCWnKLe3CrFan5wyLU?=
 =?us-ascii?Q?/uky9Z9gqaSQxUmgOQbwlyRR+jd09ACYS0sDbY3THvsTj0vmSmYcWnVNO09w?=
 =?us-ascii?Q?aqD0nqdvtsa9BAusqeBAaH6BJQ6qdatprKipyNifIi/c8P1Lge7EHJWXfBfN?=
 =?us-ascii?Q?GU0KMV+7rBhEahsqZjTGxepy0VmhPLUJ85aQajv5wLMe5Nds6lCCt3LXUG5v?=
 =?us-ascii?Q?mx4DLEJYeVlCy/jzSKNx5Zv/D2HchrJTQk5O7odDgpz5w1mPtM/P3gy2w+Vj?=
 =?us-ascii?Q?/vlTBoFYeCK1GD/nxOnlqjZHKln44QODVd3ZICQlb9cUGbCd/9JNgCy3YuIb?=
 =?us-ascii?Q?2j5x5Pjfk2lgbztrDjVTnketf7G+SXR4Uuub6cTuWbGUmt9+985uwNYZydI/?=
 =?us-ascii?Q?gBPSdtTLK8RL4CMx2xUtR16QxyntLSroU+ks7vu+DOotGVuv9a44dxfGPbU5?=
 =?us-ascii?Q?noa8N+dEceF+LTQDQF+5nhmow0CdolJJwFKuaAolAE3UXEqnE69dMyVGXE3j?=
 =?us-ascii?Q?ee0UtRQfbKbAN7i470vp85Qh3jUcCZbC/iLbKB8JBXmx6Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zAEIklemdhDKzHfKeJTrxu+p/I7LFIhSiZUkDp3U7HJScZtuZPAwhkaLUjtg?=
 =?us-ascii?Q?sE/6SQhxzoDvuqz9ntMeIT9OSVrb45GmK464jNsE34sbho++9P5OBfaUG92p?=
 =?us-ascii?Q?+q1a0j3mmzS5xvrJuMicziYsxxJEdk700Rk1lR5Cq30mHRcdPP8/h6vpIu/l?=
 =?us-ascii?Q?/feHzmwomxJPNm0KyHcEtfZWEcYzsGVMdTNhmkQ48AWsTMUNNsIuyG5DsCfr?=
 =?us-ascii?Q?9fn1B86LWvik20+A1NYkXH+It+C4OzKsze5w19Vjcospbgo8W+B21EVgjy6M?=
 =?us-ascii?Q?H9D7ziV2GalnhHFCUGlM1n8X18lpzo+LvT9PgEF0BR8EM59uYjToM1v20u1s?=
 =?us-ascii?Q?23oZBqAkGx6NQzRbS3Bxdsl+4jCfZzpYP1nccID5oU1hzMLHNmATv2qRkq8y?=
 =?us-ascii?Q?Pjy1RO1YhQi3NbiU1lmToL5EG3p3xldBrhrCZoMfVdfTLwLHqLK1EClI/z8u?=
 =?us-ascii?Q?QOhafUXi9K4mITEElgLuQCaCq5s7oFn93IGMcgtVzuK2DlkpyqA/JQUAu4kp?=
 =?us-ascii?Q?wNmIlBA/pvslUcj8jNdxIhuJ5xDjWneZ7PMVZp+hHgu07Bbu4Ynn9s/vXdpk?=
 =?us-ascii?Q?/JG+z8Gc4fePYNzcygyEuJZzbTBq9gPtruOYL/v7Yl4j7JlBwJfnzIl3xoxU?=
 =?us-ascii?Q?wxZJbRKx5Tg5L+DHIq/oxE5qQ1e+34l1ccRMrhZrcIBc6truXPWDasBz8WAr?=
 =?us-ascii?Q?KJ40s8HkuQnvQXVmZT+stCjL90y+mlmOC1iPJqtLHEfI0mw6K73bCGShsfOg?=
 =?us-ascii?Q?gC690ziXM/+YVw/jGvYKSVLmeSsrXBTMljnbF787t2SKOLbpHqXe4aS/okoa?=
 =?us-ascii?Q?+Uc0xnoKYmtAPvsH4P7vka6l0j5LtAC0ViJ733G8w01hEV2AbUuLyijyHOGr?=
 =?us-ascii?Q?6rpEHq0XM0krTSBzSH8kPuIzvfvQ+bgpVXakC9gBmzU8S5do1xc1bHT2w1BG?=
 =?us-ascii?Q?ZoADRfwY/w+WqanpjVp7mLlGvRhItGpFrNAXLU8nHCQt9acdcN2vD7B+3gc3?=
 =?us-ascii?Q?P1HISkfcl05Xj/HZO6DYpe7nLKtvYRBlYJiGgMM3Yzx9uROeNpsB3U+ihqOf?=
 =?us-ascii?Q?h4kBH0KfCVnLsi2iUu23APEW6Xg5zMAJZiy23AWceiEPo4YMssBINIJgM2lf?=
 =?us-ascii?Q?zTVg6m8saqdOSEQY+9eOD8kMkGBE+wU1chhxKj2oByqLKeJYp6PjI8ivkjGl?=
 =?us-ascii?Q?IMiLPKBhq4H+aFdRbdD1LQIXZBF9OUUqmLejnvbMHEae2TC/w4UmN+OOP7Pb?=
 =?us-ascii?Q?wRvAo3elI9z8g5raw5UrS7mKsXTG9ku4z5S+sXODknLOZzN01+O9r9fVM06E?=
 =?us-ascii?Q?0oYDZ0uMPnBQzTEQ7+ALVe0k4bOo4DyX4LWe1v8UoGstkP0KpXG961sK2bTl?=
 =?us-ascii?Q?3/xaM4HCSi9HYm3rS1pokG9pknxEpjzB5JR/v/Sllta/XMRRtKVlP+i1qQYC?=
 =?us-ascii?Q?OXO6wMhnmnIKFu++9c4+aGGh2VPfMg6Rwx0yxS2Hpgw9/6j7X5+1WaQB6iWd?=
 =?us-ascii?Q?EvmqfjE5543kQwJs9dGMYYdTaGhQLmpRBZEHr4sm5E73aPaWU1KhAWxKREi0?=
 =?us-ascii?Q?5Q5X9TaOuekdRc+w/cuKN5tVhD0OLFo7NWBBHpFS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7be7d5-d223-400c-4ca5-08dcc7f3f9f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 06:29:46.5605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8B5i0NeMcIYtExt2m9TnQ1qgZbrsJMhxCiQn4ecUFyfU/nKe0RqhzH/UnTtbiMLOT6a3vpCsmkBWcb4P5pn1rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5806
X-OriginatorOrg: intel.com

On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
...
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm;
> +	struct td_params *td_params = NULL;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> +
> +	if (is_hkid_assigned(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	init_vm = kmalloc(sizeof(*init_vm) +
> +			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			  GFP_KERNEL);
> +	if (!init_vm)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(init_vm->cpuid.entries,
> +			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
> +			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.padding) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
> +
> +	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> +
Could we introduce a initialized field in struct kvm_tdx and set it true
here? e.g
+       kvm_tdx->initialized = true;

Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
executed successfully? e.g.

@@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
        struct vcpu_tdx *tdx = to_tdx(vcpu);

+       if (!kvm_tdx->initialized)
+               return -EIO;
+
        /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
        if (!vcpu->arch.apic)
                return -EINVAL;

Allowing vCPU creation only after TD is initialized can prevent unexpected
userspace access to uninitialized TD primitives.
See details in the next comment.

> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(init_vm);
> +	kfree(td_params);
> +
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -613,6 +827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_TDX_CAPABILITIES:
>  		r = tdx_get_capabilities(&tdx_cmd);
>  		break;
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;


QEMU should invoke VM ioctl KVM_TDX_INIT_VM in tdx_pre_create_vcpu() before
creating vCPUs via VM ioctl KVM_CREATE_VCPU, but KVM should not count on
userspace always doing the right thing.
e.g. running below selftest would produce warning in KVM due to
td_vmcs_write64() error in tdx_load_mmu_pgd().

void verify_td_negative_test(void)
{
        struct kvm_vm *vm;
        struct kvm_vcpu *vcpu;

        vm = td_create();
        vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
        vcpu = __vm_vcpu_add(vm, 0);
        vcpu_run(vcpu);
        kvm_vm_free(vm);
}


[ 5600.721996] WARNING: CPU: 116 PID: 7914 at arch/x86/kvm/vmx/tdx.h:237 tdx_load_mmu_pgd+0x55/0xa0 [kvm_intel] 
[ 5600.735999] Modules linked in: kvm_intel kvm idxd i2c_i801 nls_iso8859_1 i2c_smbus i2c_ismt nls_cp437 squashfs hid_generic crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd [last unloaded: kvm]
[ 5600.762904] CPU: 116 PID: 7914 Comm: tdx_vm_tests Not tainted 6.10.0-rc7-upstream+ #278 5e882f76313c2b130a0f7525b7eda06f47d8ea02
[ 5600.779772] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.SYS.0101.D29.2303301937 03/30/2023
[ 5600.795940] RIP: 0010:tdx_load_mmu_pgd+0x55/0xa0 [kvm_intel]                  
[ 5600.805013] Code: 00 e8 8f b4 ff ff 48 85 c0 74 52 49 89 c5 48 8b 03 44 0f b6 b0 89 a3 00 00 41 80 fe 01 0f 87 ae 74 00 00 41 83 e6 01 75 1d 90 <0f> 0b 90 48 8b 3b b8 01 01 00 00 be 01 03 00 00 66 89 87 89 a3 00
[ 5600.833286] RSP: 0018:ff3550cf49297c78 EFLAGS: 00010246                       
[ 5600.842233] RAX: ff3550cf4dfd9000 RBX: ff2c5edc10600000 RCX: 0000000000000000 
[ 5600.853400] RDX: 0000000000000000 RSI: ff3550cf49297be8 RDI: 000000000000002b 
[ 5600.864609] RBP: ff3550cf49297c98 R08: 0000000000000000 R09: ffffffffffffffff 
[ 5600.875915] R10: 0000000000000000 R11: 0000000000000000 R12: 000000048d10c000 
[ 5600.887255] R13: c000030000000001 R14: 0000000000000000 R15: 0000000000000000 
[ 5600.898584] FS:  00007f9597799740(0000) GS:ff2c5ee7ad700000(0000) knlGS:0000000000000000
[ 5600.911113] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                 
[ 5600.921064] CR2: 00007f959759b8c0 CR3: 000000010b83e005 CR4: 0000000000773ef0 
[ 5600.932675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 5600.944319] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400 
[ 5600.955987] PKRU: 55555554                                                    
[ 5600.962665] Call Trace:                                                       
[ 5600.969084]  <TASK>                                                           
[ 5600.975079]  ? show_regs+0x64/0x70                                            
[ 5600.982536]  ? __warn+0x8a/0x100                                              
[ 5600.989840]  ? tdx_load_mmu_pgd+0x55/0xa0 [kvm_intel b63d7b2e0213930160302a21a156d5f897483840]
[ 5601.006321]  ? report_bug+0x1b6/0x220                                         
[ 5601.014351]  ? handle_bug+0x43/0x80                                           
[ 5601.022248]  ? exc_invalid_op+0x18/0x70                                       
[ 5601.030554]  ? asm_exc_invalid_op+0x1b/0x20                                   
[ 5601.039297]  ? tdx_load_mmu_pgd+0x55/0xa0 [kvm_intel b63d7b2e0213930160302a21a156d5f897483840]
[ 5601.056276]  ? tdx_load_mmu_pgd+0x31/0xa0 [kvm_intel b63d7b2e0213930160302a21a156d5f897483840]
[ 5601.073270]  vt_load_mmu_pgd+0x57/0x70 [kvm_intel b63d7b2e0213930160302a21a156d5f897483840]
[ 5601.089991]  kvm_mmu_load+0xa4/0xc0 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.102708]  vcpu_enter_guest+0xbe2/0x1140 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.116042]  ? __this_cpu_preempt_check+0x13/0x20                             
[ 5601.125373]  ? debug_smp_processor_id+0x17/0x20                               
[ 5601.134400]  vcpu_run+0x4d/0x280 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.146657]  ? vcpu_run+0x4d/0x280 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.159108]  kvm_arch_vcpu_ioctl_run+0x224/0x680 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.175943]  kvm_vcpu_ioctl+0x238/0x750 [kvm 2979fa2240d2f299e1c4576243100dec1104b4cd]
[ 5601.188912]  ? __ct_user_exit+0xd1/0x120 
[ 5601.197305]  ? __lock_release.isra.0+0x61/0x160
[ 5601.206432]  ? __ct_user_exit+0xd1/0x120
[ 5601.214791]  __x64_sys_ioctl+0x98/0xd0
[ 5601.222980]  x64_sys_call+0x1222/0x2040
[ 5601.231268]  do_syscall_64+0xc3/0x220
[ 5601.239321]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 5601.248913] RIP: 0033:0x7f9597524ded
[ 5601.256781] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
[ 5601.288181] RSP: 002b:00007ffd117315c0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 5601.300843] RAX: ffffffffffffffda RBX: 00000000108a32a0 RCX: 00007f9597524ded
[ 5601.313108] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
[ 5601.325411] RBP: 00007ffd11731610 R08: 0000000000422078 R09: 0000000000428e48
[ 5601.337721] R10: 0000000000000001 R11: 0000000000000246 R12: 00000000108a54a0
[ 5601.349965] R13: 0000000000000000 R14: 0000000000434e00 R15: 00007f95977eb000
[ 5601.362131]  </TASK>


> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 268959d0f74f..8912cb6d5bc2 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -16,7 +16,11 @@ struct kvm_tdx {
>  	unsigned long tdr_pa;
>  	unsigned long *tdcs_pa;
>  
> +	u64 attributes;
> +	u64 xfam;
>  	int hkid;
> +
> +	u64 tsc_offset;
>  };

> 
> 

