Return-Path: <kvm+bounces-62975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5D2C55DD7
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1F27D4E3068
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 05:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0071304BDF;
	Thu, 13 Nov 2025 05:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QeT6J7aC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7953D2AD1F;
	Thu, 13 Nov 2025 05:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763013349; cv=fail; b=idNnMsLl315CI/Qr5NAuG+DatPBcOAEHPUXfdHVTN0d1biIW4ajuIGQ5ZSdrPbE14iXp6/bIwj2XguAAVToKlAQrDYjI8Q1AoEy4lMJ2jAfpyqddJrl580JovAjIVv8/f680oZL+OpuOcM690S4nxiTOCv/DKZ13HCtlpgDzWl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763013349; c=relaxed/simple;
	bh=P9c4Cz6TnX8I9itwr0N4eC4kTYcilrVlisr2x+oYlgI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iW8RGvkiS1PYHhfml+R8cTmxXan4uW5VXmpTdYBmoeMQKfEsTzN+jb7uEL/FzvxJVbSJuM8jBnol/5arJjpG5sIG+0s+7MFdpzjaNJwIRl2JfH0HyKdRIRX6DzflkVObob1uxnh1k0XIPf162mXPJWoaJjvyjH5EFtwVUMF/8AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QeT6J7aC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763013348; x=1794549348;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=P9c4Cz6TnX8I9itwr0N4eC4kTYcilrVlisr2x+oYlgI=;
  b=QeT6J7aCObAyeMcMdXSw1Ez3wqI8nH0sDUxL/1qUAPeOBHzKi/TFbcmp
   57xIuFIVuAHpQPXvhhnoJhFHX7gB3+RKf7g8i6Dx08pAfsRzDXDzHmgSG
   Uqq9E+e0oKd31vPgbNeFnnjeVbfQhg1NVz4P4h7ykFAeYvK3MwtIAUTqg
   cqvehZHLZnBXad6GWNx+0aF7OrnOm2cJKjzRzRTb6MYc42kCRVxuHyhJ4
   I9omrirJ29D2btqpAbAYBXfoEtcxXpUoS9fqXef0QmwPMbP5jGbhQOYFA
   Xp0KfqWvL4i85r55lpYmSqC+BY2XnZLXFf16hGnjDKi5EVuT6jOBlihvv
   A==;
X-CSE-ConnectionGUID: OAZRdJdlQ1WZ7qy4Nz552w==
X-CSE-MsgGUID: 8+McETo/Qou7wF9FH5Mjtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="65118682"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="65118682"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 21:55:48 -0800
X-CSE-ConnectionGUID: 0lgF6GPIQOaXGsrSU8fjnA==
X-CSE-MsgGUID: TuwdTi6tQ/uNATFkSEpJjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="189079491"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 21:55:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 21:55:46 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 21:55:46 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 21:55:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOiyconKsp62MuvR0hIGVj3KOi6nwI/RYOK2FnExISLSSnv2ucx8hd6aG56jAtX1518saxAUS3cTfl8wpEkHev1PaepntVlYfzbWHPKymrI2Ix5xiposoh0RxQcX1HXGQJZIDPmAaHvyhwK+mvxMWSp5ubFMxriX5U7JAedSZ0dVp2r63A9QSkuuCknfdeBsBYnGXDZOYxyq2YVCpaIRklF7TMqi+8YKornzTG+faUm9yMVKKKppeT468C8qtUV2h2Dm/nDSkGPJzq80qLq1yCOOu0/qFQoLq0X5clvku/TmpJAC1g/vpUqGjGooFDbEihZqpYs6MCsoS38fjzTbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vq09O+e9dn9+++MlpRRRvRY+LYtycoIkw9obtj5XfHU=;
 b=fJxUA5YVLuSre6R9npKpvYXxFjaRwDgXpAHcf76h7gOYl+2kSjzgJmXtlmyMwU8aoRL6F1rQ1YUUNH7kKUZG97wWAs+r9ZZz+JuGLNB0eXjAO6ayv49LImg7QWtZ+86gkhNwTbSyv5jf7FImLNm1Fm9fJAYX/Qi0mOOaxjQVo1q6ByglBguWX91PF0qDV9k5YxwejAALdOCJiHKoURFNPIHg9CmMiAMHKTWs5MEDqq+m3MnQfgm22Y34lyd34YA3Wn9QOpLNUjgscx30N+qzkt4cSwKfX5YV8jCrX6/bmBk/rdPMKsmNtq2WURmKn2OP0jmtBcrWAChLls8sSfXnQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFD114713BA.namprd11.prod.outlook.com (2603:10b6:518:1::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 05:55:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Thu, 13 Nov 2025
 05:55:43 +0000
Date: Thu, 13 Nov 2025 13:53:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Message-ID: <aRVyYdBlnS7DD1SS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094333.4579-1-yan.y.zhao@intel.com>
 <9aa8b3967af614142c6d2ce7d12773fa2bc18478.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9aa8b3967af614142c6d2ce7d12773fa2bc18478.camel@intel.com>
X-ClientProxiedBy: TPYP295CA0040.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFD114713BA:EE_
X-MS-Office365-Filtering-Correlation-Id: c360d39a-fe91-4412-2cda-08de2279481a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DRP2/BsFXM9GR2cBIfueuNg/mnxGfSb8xli8OBoQmGBd0zU2uZC+agJfe+Zw?=
 =?us-ascii?Q?5JM0T5zq/vlUViuD4ZqjCCaUrgT08yoXBsGUlfGO4JLNec9djIoR3xgWc2tS?=
 =?us-ascii?Q?2I4T+6VsrST7JtpYgMR+TpwW2mhs6lFNv0f7HsmDjpKSVhAaUTkyxoVMvCLy?=
 =?us-ascii?Q?8UZu7hV7qqFNjFAFPjtY/PbDxi20tiPe1fVjINlXI59uHeObBV3EUbzQh1f+?=
 =?us-ascii?Q?B+Vc7jaRgjf8YHADBU9y/WGjdK2U6sqYlo7UXICgNLpdgQqtlRNrgiinsv1Z?=
 =?us-ascii?Q?ZUupkEPIki5Oe2H9x/6vvUbEoOUQ+Wy3uUKFhO16CY3DvbogQ/tpXblMzXGk?=
 =?us-ascii?Q?7LW/VtFNmfrwtCJAeGKqRw9IyuegGHjrb4Bx1H5mk8w4yv1QQcfNuWDox8k3?=
 =?us-ascii?Q?VU2MQoLu/P7HUe/1VZmDYQHoQ0ImGv4+vlZuxhGiQfO37mfSOujbyk51M7ON?=
 =?us-ascii?Q?ift8LiIVJxAWlXGmFu/01sEDqNqfszerAzI7o4kXowpEVHG+bBHHp6Dvv02U?=
 =?us-ascii?Q?Pkw76pWwUbFk8c8CopWJHv72gckgdrG8ls9Et9g/dzN6bIjom912xngoYP6T?=
 =?us-ascii?Q?PWzTV8ljg73BU0O6tL8j0E3g4xlAtGIo1nt2Pi648VvI7AAGX/xTNXReb33+?=
 =?us-ascii?Q?6RGm4zklo7Bc3WNIGNx5U6AlSsgYelkp6DdN5xMGX8LKAHi2jinV+GDvVHhb?=
 =?us-ascii?Q?DPARbISteOlzt2GM9K9nBxsVDizbcbB1mgs3SklZ9Xv63T2AVKlTiBxqkoDo?=
 =?us-ascii?Q?vTYx+NZrH7/nVo75y6G0F5AjyoA90ekHZ3eEqK0hvKWzm0vlGU9IsLKqprBh?=
 =?us-ascii?Q?/VvTH8DtmG8yySigH8NhDsoPcAda2IGHVstq50Ishb6xmgvonekRnfzj4yBl?=
 =?us-ascii?Q?0fimPBjMSK3SRaDghmItUxzvdw0EXQ5QtoM+xaxnffageYEYnUuiW1YhpgHG?=
 =?us-ascii?Q?YHp5Kkg60LuFIUSh1mGeCfLWwsot456oJfmouhZZehBG3AAmeVCRGoRl+iRi?=
 =?us-ascii?Q?PRNnNY7WArSNDbaPl6cM1SEs3K6hs8S7ClGQQoUXQrUswJq00WvG+9LAzvWg?=
 =?us-ascii?Q?EAdpNyGSBtHHrq83I5B06QoGwSDLxCo+xjjIokMkvpHkni+qohhHTs0hcwX+?=
 =?us-ascii?Q?otyeiaRFcIK4uUMyuS3IqCvZ+07OW48NO/N6quDiyhthP360QPUQI3y2upZn?=
 =?us-ascii?Q?wt6dMh/hiU0aNCb5TIDqwa0oT8SrWJznk3BQihSpgpL/IYnPScRmqstwHuo3?=
 =?us-ascii?Q?1la1KWYrE7yq5VRAKi0cb97Gqi/I/gnufcGQAdpjHSmLnoAd45pJCV/8M4/1?=
 =?us-ascii?Q?AVfH8sHSTEjnRjnFiPqvhUO90sXXodH3L4SVdfIfcyVOijaAGRrW4Cci9ajS?=
 =?us-ascii?Q?BQCMZRwFHer9WhJ+P/Emsnz94Do2IKVNuFEOHcW/riqAK5Ik8qCyrglJoT4g?=
 =?us-ascii?Q?NUqy01pbcGE2kW3+rQ13ksX2CPA4RORQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0qv4IYIejgxefNF95vQ95w9k5FjaX4/aV77uWfWDKMBboT0SovP71/MB1fjt?=
 =?us-ascii?Q?7lQUAIOLvQwEL3wk4aBYx/NljNT8agyfXI5d/ZVBTy0HOvJeFuVSuaE/PV+Q?=
 =?us-ascii?Q?SPjWqBgBJkASHncC7BfPOt4rNfMDQbj400reI6oZOGUO/AFCtLn45uZ2q5Pf?=
 =?us-ascii?Q?hOIxXtS2FutdPyreiIw58dJVDvJ7jMFB6BWYDF4QUyPU6sPtBKmYl4bvM8qG?=
 =?us-ascii?Q?jNL7g2tz7+2NqcozzEeMC21xPtosd32vF49lq/TYySO5/2KHIbY0h0BkaGLA?=
 =?us-ascii?Q?pdV9/FaOuAOa1kt5Mz3NMhxjShe3ALFQyMhkUzPKLY078AHjib3/A3TCKWHU?=
 =?us-ascii?Q?kJrKW3r7rB/q0LgS54Kqp9UjpKZG5MNrFioGMFc3Jmaw8XZd762aNAK8K2jI?=
 =?us-ascii?Q?6hSSRs9Bx0IA0BssUSbIoW3Y7retPQGY0I6Q5002LK5SKFYS+EvBpLHYkh2C?=
 =?us-ascii?Q?dX+iviEA/Df0smwVDqmmuzZso1tQmNhXqyI6mraDoyqu3HVv+N0ehcdI4y98?=
 =?us-ascii?Q?zE/IMr+lkGqpx6PFwx3++T88kvXZ0LRfHYny3QM4p1ggXlrbw4oepwJU/4eJ?=
 =?us-ascii?Q?H60T6qlpwgDz8nJCYA+XImpDuYQYDI/GgULCOuGO4g3TC5g5Ek/MomHefuXS?=
 =?us-ascii?Q?WqXQ9u+YjZ51IYrVa6WJ5NCkB9qwz0Tad3ZUdrrX96to9Y7UaJBWZikSzGrJ?=
 =?us-ascii?Q?32OzfBR08WnM/Kxg0LDMmHe0JsvV+NDT7r3S0aGHTVLtn5tOXKaOfs8qvbK3?=
 =?us-ascii?Q?DrATJoUbfU0PbbHxR5SxTCh4WfnUHJs9+7PbRnL5a2p6yiUUOjYzBCMHy0fY?=
 =?us-ascii?Q?seDe4xsDCUB8/4vDjIyY+IGs4UJEnTlGww3THpLIvwt2e9gVgreCzPrXL/L5?=
 =?us-ascii?Q?23Zyc0bp/1iKddVpXWtTzUF4Uc+UaAbOQDzGbzDp2U2W/dzjciHQnwBXVMzc?=
 =?us-ascii?Q?INMnchYoGLS0xiI30V7SmI+5DeMQ1DfHTfYsYiBi7Nr+8lbR4dAk9lB8Pb/h?=
 =?us-ascii?Q?Gs4ganGptXa5ahr0hkKTt3EJVvoJ7AzZ6eTdu00PLm9K1XFMweJ67fJrYcvn?=
 =?us-ascii?Q?k1K4D+8vdkoxGWGZc5pGH7g+TfLs/RsFG9DeMigpnUptNRb1XYiIPEjGylPh?=
 =?us-ascii?Q?ZEOJu4JZfT5JJ7LjJ7E7qfhWYUgRsFMolpjSHrsLQ7o7D8ALvzTs3JzFg26m?=
 =?us-ascii?Q?xtWMGi5Nb73ST0DRrx1JWRNiYYBkrQ1Orj8SUK7bE591XpSClFAiv9gNUBzj?=
 =?us-ascii?Q?Sl0v4ncscVR5iYftRXN2hcqQKQE/U63tP3OJ3YJ+xAVCp0g7/Rq/VYH3dLnN?=
 =?us-ascii?Q?MRSBTqTpFt9fG5nz5dWK8qjt//LBT4pBZajFGMhk2EOLCp+iOqP0CYPToaKL?=
 =?us-ascii?Q?7GgfO95Q0800MwUiWfV7Iizy7mWNuKiaKl05FOvzuBezqSeOKQbsUIb3NlNt?=
 =?us-ascii?Q?MqEqBEPzFN4oEx6jewpmH/OtsiNLRY3ygom5W+gjOhK87FnornUJPFv4z7An?=
 =?us-ascii?Q?O5n0NFbU2eRufcSWp5W7nIFNW0FKVFNx4BpOVsxsgG4zwx4Jn3lmks5KYW0h?=
 =?us-ascii?Q?92ZXhZI+AsPQVzPdqHxBBk8WEyJ03KAbrS+vBZ86?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c360d39a-fe91-4412-2cda-08de2279481a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 05:55:43.0912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLVfd+5lTg1DL0+EkkNRdwMI73rUolDwIB7QhpdSiETG9dbMzVO2Kk7nxF3R6VCl3RhqjPRM6OeUfqZUMwYjgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD114713BA
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 06:20:40PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > Implement the split_external_spt hook to enable huge page splitting for
> > TDX when kvm->mmu_lock is held for writing.
> > 
> > Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
> > tdh_mem_page_demote() in sequence. All operations are performed under
> > kvm->mmu_lock held for writing, similar to those in page removal.
> > 
> > Even with kvm->mmu_lock held for writing, tdh_mem_page_demote() may still
> > contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
> > operations. Therefore, kick off other vCPUs and prevent tdh_vp_enter()
> > from being called on them to ensure success on the second attempt. Use
> > KVM_BUG_ON() for any other unexpected errors.
> 
> I thought we also need to do UNBLOCK after DEMOTE, but it turns out we don't
> need to.
Yes, the BLOCK operates on PG_LEVEL_2M, and a successful DEMOTE updates the SEPT
non-leaf 2MB entry to point to the newly added page table page with RWX
permission, so there's no need to do UNBLOCK on success.

The purpose of BLOCK + TRACK + kick off vCPUs is to ensure all vCPUs must find
the old huge guest page is no longer mapped in the SEPT.

> Maybe we can call this out.
Will do.

> > +static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
> > +					enum pg_level level, struct page *page)
> > +{
> > +	int tdx_level = pg_level_to_tdx_sept_level(level);
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	gpa_t gpa = gfn_to_gpa(gfn);
> > +	u64 err, entry, level_state;
> > +
> > +	err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> > +				  &entry, &level_state);
> > +
> > +	if (unlikely(tdx_operand_busy(err))) {
> > +		tdx_no_vcpus_enter_start(kvm);
> > +		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> > +					  &entry, &level_state);
> > +		tdx_no_vcpus_enter_stop(kvm);
> > +	}
> > +
> > +	if (KVM_BUG_ON(err, kvm)) {
> > +		pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
> > +		return -EIO;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				      void *private_spt)
> > +{
> > +	struct page *page = virt_to_page(private_spt);
> > +	int ret;
> > +
> > +	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE ||
> > +		       level != PG_LEVEL_2M, kvm))
> > +		return -EINVAL;
> > +
> > +	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> 
> I don't quite follow why you pass 'private_spt' to
> tdx_sept_zap_private_spte(),
Simply because tdx_sept_zap_private_spte() requires a "page", which is actually
not used by tdx_sept_zap_private_spte() in the split path.

> but it doesn't matter anymore since it's gone
> in Sean's latest tree.
Right.


