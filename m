Return-Path: <kvm+bounces-34720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C96A05080
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80458162E8F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36401158D96;
	Wed,  8 Jan 2025 02:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="US0SMvnC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1496913CA81;
	Wed,  8 Jan 2025 02:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736302578; cv=fail; b=hRDYv5jlWtY0w1ZzIe24viiFULRA907MAsjZBN2mtt/6L6BJFrRaj6SKNW8SiYeaCHU1mL/eBwzxfhoIDFvgiGtJ7S+ROTdQUCyvZuyheivAmOGMMNdXNaJ+uc5wAatQVyHlqby3Hp6uUkoS3Ni+N9V/ZYxo01doC8l0mdntTaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736302578; c=relaxed/simple;
	bh=S2ErKCm6UuARyj/KZHBdPnz3cv8pzLQKDkcIp4WzKhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PX1lfaJOXG7pWHyo/tV3bijew5ZeqenKYsvoeMyPfHRKa4fPAW7cdZ5pFZH/4vcgW3WTjqGFQXh/0GdpAefIYWpJb3LuLJgV7tuq+qlaLJK8mLqyPSLhFP6+opTetRwvL7r3BJDiG0i2VgCuNHXFcG1zHgxHuzNyTqczCX3EweU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=US0SMvnC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736302576; x=1767838576;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=S2ErKCm6UuARyj/KZHBdPnz3cv8pzLQKDkcIp4WzKhg=;
  b=US0SMvnClr4Ue3RtFtfvBVS3m/izdlkyrCytCfC8nMYnK9KnZdsgucsJ
   deJajjBunq4loOvwYhiG1pmnQm7eyB4c/HW+q1VWzUqMaXK2A9u1CEj7B
   5xWQyaNHNgYiiPI6hfYtwtxwZXMCgcO0i6+hsBsPtUx/X8lZYhQ6zB34G
   AmBO9bgEhLBiD4P52SbtWEfdagDZ5MD+v8UQC2PY++P4tn+BvwCNVoUjB
   hXLB8XCgpo48BAQn9pWG4I9lT0liz3Smym7meEjZjKnspmm938kAb/SV5
   B5OvR2uDcjkVibNRCPtZIIW+ewdfHjyIYJ31GPUDWCP+Ho8d3qe3+JdXK
   Q==;
X-CSE-ConnectionGUID: yiginUrzSZGXVaDACG3ZwQ==
X-CSE-MsgGUID: vRjbauenQomfk0Nm9kGovQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36414602"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="36414602"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:16:16 -0800
X-CSE-ConnectionGUID: Uu/8bZ+0STyZeAibpiq13w==
X-CSE-MsgGUID: X5hM/cwvRbGcUhTTd+hi1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="103012585"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 18:16:16 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 18:16:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 18:16:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 18:16:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EK+2W7w+LPZ5hPBjU9ND1pawZWGEGjSf9tpzS04RZomnEbH8VlOFVxvXRuM+lG5QvNif0HEs3tTPtkAfPPNo6WVp6m2JLQGHAXWpwkPPyKPx+UMC9vMQjXeL4vtPQEoHr6ElSeNIdGM4ROp4W8g5BZod3LcJ4z7vHBn/Ka/bDiXfm5NUZXXR6aAertyGY0CAOTjSLMXWRMy6wOTCb6Ff75SqNh7tpeUhfNOfXubAbSsK+XuvvioC/ZBOPFv4nAqqGqQ3nA4WGkmKWzsJlCenA5dYrDFSOqQZsoqqWPw+yrfir3rUv6dqrYRIiA4cw6fNk8ypbRwjWnaoj6Ujgy/XEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN5qepvU3KpaZAf0pZ0uslwhYAGamg9az0HJEGJGtok=;
 b=soCmZgP+y/CmKWcSF4Zl1hjscDUdsde7+fFFpuaw++K/eFYTLR7zRkoBi3+3aMi9gnwO0ViDpa+6csXFGCQcKeKb5sANMwawpZ9uPk3V2OULK0tuCaAAz6q7v8OMQ4KTEER8nkG8j8XVtgZK+fwvcWeTZkwtOMYv2cex7dKt2/NwZikMohfxzZHK1vLrtaZTj8ObC6I9nFRQeEmLXCvbkxo0ifPElG5zrc418JESxS8OZ1N9k3NwtGPpJ5cGXDoCxmkPdA7+YmkmCisuBD8YNZJPuP6v0T4F4a/NJMh8kFB6aRMbSpGn/xrMYqXWn0vDBvQoVtfoi0J/7UW/UKkg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6112.namprd11.prod.outlook.com (2603:10b6:208:3cc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 02:15:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 02:15:44 +0000
Date: Wed, 8 Jan 2025 10:14:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Message-ID: <Z33fmRV5x8QNQtXZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-8-pbonzini@redhat.com>
 <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
 <753cd9f1-5eb7-480f-ae4f-d263aaecdd6c@intel.com>
 <Z33Q/4piC/QMdPFQ@yzhao56-desk.sh.intel.com>
 <5907bad4-5b92-40e2-b39e-6b80b7db80d8@intel.com>
 <f92121f411209152f2ab22b5c8dfa9ec74831499.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f92121f411209152f2ab22b5c8dfa9ec74831499.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 190c57d4-7b0f-4674-b3bf-08dd2f8a5b9e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SFqmDAI5DqcgDKAg1C1XxZK5tWVYKBQCDXdVbCmYWnb6Zi16ymlTc8OXkfwj?=
 =?us-ascii?Q?ooOEiY1dWXH6bbyxIt+D2h60Odf6wH12y0wurBMS8D0CmfZkqvz0ptKa1X2O?=
 =?us-ascii?Q?LhyV76Nh7JcO3079a5d22Vun0A2aFo0gKudaRXMwMvOi6SJxueeMc+KbpdOe?=
 =?us-ascii?Q?aKIwLgOmOuj890YdcxEOBJmR/pEfy0Y8tJWe/a6+uuZNCw+XXIM1v9zgCj+f?=
 =?us-ascii?Q?Nr+9y2o6EVzGtZ89ObNMeYoDGgI5SQqOGxX4zBfeMqwarWgwIM+0lYNO/E++?=
 =?us-ascii?Q?8VpSMpMvFFsoVos77hqj56ztS7KG9VlAcZ5iiqAzCXJHTlwiwsxqLrmB4xh5?=
 =?us-ascii?Q?zlbXRPixq2vTMPKq5PCIVC8aPzboft6waHA8Bm268JiRIHVJ47kcxX2HUZAs?=
 =?us-ascii?Q?LTqAMHnQ+qQsWQs6MU/S7BFafgGx8JeF8IXODfzUtCOwJUvKpcQtW7F20Tv/?=
 =?us-ascii?Q?9Uv6jUow5iynTj14GntrVKYTIFL9aCmIfBKcJtwC29xTWPrDtu6vKvncx5jK?=
 =?us-ascii?Q?QH55xwhUOgtUSNEDno/6QpQy00loySR7flaCCsSaxhf+zMMe0pOL0SdHooWQ?=
 =?us-ascii?Q?z2TLT/i3c2hbQqK88WoQHBX3xkrOuNnWnDWFMKp1NBQqdvbu+61wKajabVnG?=
 =?us-ascii?Q?cwvr9wWV7xubnbOYt7Lq/9O9AZKoRI3mF8Y02oTL/ytMZxhvjVxwPgTD9q4J?=
 =?us-ascii?Q?ciqVtUlGj3h4aXUz6V09dQwy0jyrWvJf4VGhn6/UIFZ7ET0eEGNV5ZyJLwUR?=
 =?us-ascii?Q?wTesUakExwC2Hin0EgHmez1J5xcDcBTZtRgC1KlqgZqr9pQyEnENLkEwQmkw?=
 =?us-ascii?Q?K457rruBYlbjhFjD9Z0LAK5hm8l8MA0pbIb0HSPGUOniX3GgVBtP0YVyO2Yy?=
 =?us-ascii?Q?7yrj3JjqJTgTvsgpDNvlwrE2uwxoQQd3V3KFyomcXVvzmaGTF5jWoc+MpMuf?=
 =?us-ascii?Q?7j5BLnxhSsrsdfA39TdAhCsy64FmbCQHlDKxzButGZT6TIfE1I2o6ULwZed/?=
 =?us-ascii?Q?o6/T8gyuD7AiJnCGMoBbgwtLI1bxae8N6PSwiuCtqOCbrjFsonjszXgvirB7?=
 =?us-ascii?Q?pPqVCp6DS/bnj45szYs5x3eJLrkvFr9BdvWC2mjUzHJPdSipCFY/jfnldun9?=
 =?us-ascii?Q?UXfWl8Lgkpt4k36YWktencJRjyrMdFssVkjZzfGLcElTO3HmIA9rhN/zFOyj?=
 =?us-ascii?Q?9FUJwE5zV5mQ6+A3/9hbg0UspVQ/sr4mKLgTT/3K+Px9A5BwDuUnArb1fUaf?=
 =?us-ascii?Q?/uoTRBoXTJXCpQkjdyM9HQsmeGyGyXawWXZ2OkaKlavaF1rYcgyUZQIz27Pk?=
 =?us-ascii?Q?YkqjaUl7g8FPSt+ZBpZe/XGUG5FCgRW0rQCRTbE3MMv1Or7JbtuSpZ2BFZM0?=
 =?us-ascii?Q?uKYQKAHPtl8mi08PciJNIeAAzoNx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yzK97UGmm/dD55Z5U6i36k/wuJkjgWjIbzr+sP3fqdkYw+A4u/828GuTpRrP?=
 =?us-ascii?Q?C1n1Pj7v3B22PI6GPgBQsun4227AEgICW1Y+zOsV9bXj+6OKMRbTLWAHdAMU?=
 =?us-ascii?Q?DHdiOryRV0jybDW4UO2tA5Z2poFqXQ8fNS1BoJo8VpCd7vKO6twQIZZKrzYn?=
 =?us-ascii?Q?yLm+sU8wgbUr6e9DJR0bpnN+Umg2T22o4oVqZVNBQU4Gd1xecg8B1Ti2Dfp+?=
 =?us-ascii?Q?wsOnsXALkVKzcis5o3Sb4FXoDs4Z4TJJSOhJOiWUJS6k+FUvrXhHphktuxqU?=
 =?us-ascii?Q?U32JqmIbcR7x7peZPLFlMu3PmaCBlnJ8vLSwrxFHFBe4cdPuMorOscFY38mf?=
 =?us-ascii?Q?iYgqjszp2UTnoKSmKBUvRtGPavH+Ftz2ZzXLzB4yAsz4t+dOLgmMYTvGRbjV?=
 =?us-ascii?Q?i9zOOADEptwHCMvpGaT7IRONwPcLj2Dji8dDnQgbAsjPbcR07GIt53HmzJuk?=
 =?us-ascii?Q?Xg7hoq5MQYP3g81k589oPCAfhZKbrWmWm0558ufd3oLbd6JozDw3eLa/Pnjj?=
 =?us-ascii?Q?o/k55XZ9EMV3FFSQbFIUnoB9rXag1UoUp5yqT3595f7WqEfh8SKbneh8zoKQ?=
 =?us-ascii?Q?BGrobYyjByRjfKGjp4T7mhxWJ6morylzdyJNnmUx7yv4FLz7bSYgKyV2DsV6?=
 =?us-ascii?Q?YUrw5elOo9Y20zVZp6f14yqBvKikqEhCk+/BkCItIwnEKfGGRbycSDvIrdB/?=
 =?us-ascii?Q?QTqaxNaBXarjfflStDZwJDy2SjM8K9PETTqCWH7rwfCROpB+0UcNZh32UM+U?=
 =?us-ascii?Q?pFOItyZDToEMs5T6WviH4YXQrUaLAuVJMucVOFlWebp5DsqI+CX36U7iRGed?=
 =?us-ascii?Q?zWV1TWGavYjf8frEt+dMiq2tE0zE1Io4R6tf7ZBIrUZMWA6K0ie0O25HqTvK?=
 =?us-ascii?Q?AhULkvzsEh+uk2Uhh+9PN6cJDQINovxhfT4eO8/BlEiHlfHfGDJO2pJxeiEU?=
 =?us-ascii?Q?082UnP5fk5FOozqwa4kf4hhGNLcJ8dv31UN2yxf/DhSakgQlFa6IGoWYCTet?=
 =?us-ascii?Q?OhNlMx4fuzVdwQJCs4IDhc9UHm2B1OM3m5J1X/gbNW/FzSPL+LIc4oj4XqRb?=
 =?us-ascii?Q?glTFrj55my3q09J3Tdp4jQ1ibzNKwr1SItJEvqMXMnUekDIFVu6CC+vYvyjF?=
 =?us-ascii?Q?3uw9HjegHD9XZJOnZ+z5y1211zHb8DWLdSEfh0InEChgBJbLHo8LY5HFLLtD?=
 =?us-ascii?Q?HGm/Afpg3DmQoYnXT4IfQzTJHBbOKzjTLbr60ajKwSGfd4RHSyG916e/adRO?=
 =?us-ascii?Q?6RSEhszI+r3sya5J2QO+yGIpXXfKRUm+jqwZwZ17mwP4+dKUlnOVu/mskrLR?=
 =?us-ascii?Q?wjv5xPzLouQtOJdaytBFwmE4hpwqgWYErrxt4CMl6PqQ2DZ89JKlJRTQafGU?=
 =?us-ascii?Q?qdVt3XTqCY9lS1WQtCpTCG8shIft44d+Hl3vlxSw3Qq90jkhaaPnfejfd9kZ?=
 =?us-ascii?Q?zXlcHXSdn8P5YmuhqwcLzPvk5ih6/m9wwEwubVL76JVp9GIAurNBxEbIlCXK?=
 =?us-ascii?Q?7aCrpzHxUzWhjHyZPVhHuw4LZw8mf8YznmT3CYPzZ5ga41NfzDiNVxoFIBin?=
 =?us-ascii?Q?eskLU9+PnCODmMWXHtr1PNyMKXRsSKCogzbc+vav?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 190c57d4-7b0f-4674-b3bf-08dd2f8a5b9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 02:15:44.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pILsY3fz+wtPSwTdEUKvDzTPCsl/dYVO8YOTvW3B43v6v5Z0un3xYJ5EoKI/ygOzt0oS7wff1rIEfikvMc/AXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6112
X-OriginatorOrg: intel.com

On Wed, Jan 08, 2025 at 09:43:37AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-01-07 at 17:20 -0800, Dave Hansen wrote:
> > On 1/7/25 17:12, Yan Zhao wrote:
> > > So, why does this bitfields definition make things worse?
> > 
> > Look at the kernel page table management. Why don't we use bitfields for
> > _that_? Look at the link I sent. Bitfields can cause some really goofy
> > unexpected behavior if you pass them around like they were a full type.
> 
> Huh, so this enum is unsafe for reading out the individual fields because if
> shifting them, it will perform the shift with the size of the source bit field
> size. It is safe in the way it is being used in these patches, which is to
> encode a u64. But if we ever started to use tdx_sept_gpa_mapping_info to process
> output from a SEAMCALL, or something, we could set ourselves up for the same
> problem as the SEV bug.
Thanks for the explanation!
Sorry that I didn't clearly explain the usage to Dave.

> Let's not open code the encoding in each SEAMCALL though. What about replacing
> it with just a helper that encodes the u64 gpa from two args: gfn and tdx_level.
> We could add some specific over-size behavior for the fields, but I'd think it
> would be ok to keep it simple. Maybe something like this:
> 
> static u64 encode_gpa_mapping_info(gfn_t gfn, unsigned int tdx_level)
> {
> 	u64 val = 0;
> 
> 	val |= level;
> 	val |= gfn << TDX_MAPPING_INFO_GFN_SHIFT;
> 
> 	return val;
> }
That's a clever alternative :)

