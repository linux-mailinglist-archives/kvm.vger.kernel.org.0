Return-Path: <kvm+bounces-40808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8E5A5D3D3
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 02:05:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4512C189AD71
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 01:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02598126C05;
	Wed, 12 Mar 2025 01:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvOJp6/7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945B1A921;
	Wed, 12 Mar 2025 01:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741741495; cv=fail; b=DWpUa1RudxiDa0X+uTJg7AAwUeJbyrqjPTFf9ioYWFQ0a2sY8TOr1hwWlFYhJn++5KjcyuxnJVNHULg+v9AyxUjG5K9f8Adi0g2a33oQ/mfKtjuIVNJcaox6QqGjb7rOHHZfCr2p1q0a7HDO7SVBQn+ZMUldWvMy0oPINDgaaPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741741495; c=relaxed/simple;
	bh=Y/jqXva++qDHTH9RlzdnV+r7klHzcjQ1s3koAD23raM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CljgVx21MQ4RMpc4NhBxwPZY3bL3WRWo1vOZv0ker5SxO57PJ61Qs4iKAuO+2ck0w27HVVX4F8l8qkka/O8fHHmT7mG9e9UkEUyI0+/TrZnWPZ9WQs3e+WJxffCg+14pjq6w+PLDNN9Fr4H772h7rbfgXdfEVmUUIRIYccrNadQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IvOJp6/7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741741493; x=1773277493;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y/jqXva++qDHTH9RlzdnV+r7klHzcjQ1s3koAD23raM=;
  b=IvOJp6/7rsCuWc5Mws8+9qhfO7yim1F7ucWp2cQSGKFJT5InjVUGiFOB
   KBuNboRv7Gb0mfLkF3RHiOvzbprJ3WTYHfbHaE0EHvyjPUo6gyOA5eA1S
   uuLqjlhgL2pgDz0Y+W+C9pqPC1VwssbutGZGEI+L/YE36JiMyF2cHe+KA
   ptjWGNlob8nEmlGevLemuPPl9MOKaQW0YXbaipxyTVg8Y7OJzxXkUp7kH
   CkYItHc/wPQVjujsAMvN69p5gGhPA8VrEDxTSZ7oT44pNKMOs9Ru+cbta
   uHluRxjIjLOrODqPIjwkcNoIe+wORGtQ/pFIuiXGGd0LJinl8r34UxCUR
   w==;
X-CSE-ConnectionGUID: 5VCNGFoaRfSVz5K4xl3VrA==
X-CSE-MsgGUID: nMfFLnwbQISGYnERSZUDlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="46716585"
X-IronPort-AV: E=Sophos;i="6.14,240,1736841600"; 
   d="scan'208";a="46716585"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 18:04:50 -0700
X-CSE-ConnectionGUID: UxSBi+CNRmO8Ca3GJHfFOg==
X-CSE-MsgGUID: oPYdY46HTHyeoWXgqk6JSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,240,1736841600"; 
   d="scan'208";a="120509210"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2025 18:04:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Mar 2025 18:04:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 11 Mar 2025 18:04:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Mar 2025 18:04:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIkcflEErjSaTPbfm7ST4lGYzeQKKsqE9K35TO2TdQkaYAN1P+lI/syIbJFdnigF5lQ3yqhMWW0HbwF3qLgOUmHoNjQJvn7CoT1W35gxT7RYpmIVbEg822oQy1pquEkrvwh35ewR6ckQ03HFd6FDg9g99GnNCISFFe7TVOKjf8lxi3eR89jHqteTI95+I8qiCcvwEvuofcYPanC5NElkuRWpl05y4KNUyBFIZ3mmz7+iSYhP21YkOt21faZtX3Ajy/NyO9ymIynevaE6BQX/Ovd39Z9HuVHTcjDBHpCT/VRYXDPzPU98w3bLhfl6xWzU0kBo7uOPsjMN0GrdhMP2FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcivxX29vOkSqTAwgzMznaeJ5IEcqhyO/sPYJk3wa30=;
 b=UiVUlOcvcED3uWKAX8DJDP7MEt56hzBJlqz/Nx/EcnSAahBxqH+63OfTfdoMsXiIk70HgMPwjsLm1JPjoSlfh5ZBWIJsqsvg6BhH4sC9zofAZJMU2+/Vw4uHb/E+O8zWHJI0UGwD1SNiXDXkbNJJwMj/2h9wRe4HdF7YmtpSTDoaQLQNFrAjo4j4NBtMqThd5imY2qnKkHtQ6BPvpIynYki0YCLUr0ZTj+6fBKoRliUxxnhq2YKmSMKcJrLFRianpgvvzULX5/wN7lYzIBtzismYM/GI6H6hzdT3SC0b/oCrRVdpGwchmYOjHQHZQjwo0/vNCe55+tY6NF6K9tgpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB8206.namprd11.prod.outlook.com (2603:10b6:8:166::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.27; Wed, 12 Mar 2025 01:03:51 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 01:03:51 +0000
Message-ID: <0c3d9869-5d5f-434c-bc57-f91526da586e@intel.com>
Date: Tue, 11 Mar 2025 18:03:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
 <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com> <Z85hPxSAYAAmv16p@intel.com>
 <7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com> <Z85+PPhKnkdN9pD6@intel.com>
 <Z9AsGFF2Rs0lCC9/@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z9AsGFF2Rs0lCC9/@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b5b301-3596-453c-da87-08dd6101c0e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SXQ1dXZlb2p3NWVwdVBpejVEeUFPL0lKanp1dzJWbllBZTlVUDYvWC9KQ0JN?=
 =?utf-8?B?QkpvUWRubGZzVnN4T21aRjRtamZQRzlkaHh5R2d6MFBGcDBHTkJTMmZtci9o?=
 =?utf-8?B?NkgybnZ5ekwybUszemJjUExIUkluUFpxbjB0a3E2YU93VTdneFJXUndNeXR3?=
 =?utf-8?B?UHhtNVQvN1VSWXVEdEJDR0x3RWI2d3JmK0lzdXRpSzJ2aTBLNEFiaDkyektW?=
 =?utf-8?B?eXB5UElhOGFWVURzL2tWSzMrN2lBTXlWSzUxU0VuTGFHTlVYNFBDdDgramtS?=
 =?utf-8?B?SjZzTHZ4T2hMOHoxdDJtZE5YSFhpSDZFZXZwZG1QbUQ5bU9uSnpFNzNSTTNh?=
 =?utf-8?B?bVRBeTNlOGx6bmV0OXdzc1NUY2paczFXbWJNSWpjdTJnM0NDMkM2N2Z1cGRt?=
 =?utf-8?B?TnFxcXFZVVAySjVuUk10eUlWR2MvWVprUHh6QWM1Y3NITkhKZlMrMDYyeXRV?=
 =?utf-8?B?OTlXZFFVRDU5cUtZbmFjRnRTaE9od0tUeFdOcU00UFVIVHNiUE8zUEdIK3A2?=
 =?utf-8?B?UG1tK3A0eElXZkFtMm5kM1RiRmZZVmpwbUFEV1BBdzJMRmJyQkMzakpJcG0z?=
 =?utf-8?B?akkzT1BOTGZ6MHZuKy9xelE1TDE4NU9QNHg3K0pxMHVlN3hOVisvZzJSMi9l?=
 =?utf-8?B?SmN5YktSNU13clloYUFUOWF6a2Z5YW82L3Y2TDAyZzdIT0xoV2Q2UjFxRWdH?=
 =?utf-8?B?YWYvTkFyWGhiY2czVnlFNU93YUJhcWFtMlRkRVNNYjFDeGlKdml2cXlsNHBE?=
 =?utf-8?B?UWZ3My9ndWFtci9FREg4TWREZ21yMEIyblJTVmNLeC9DVG1aYkVXOHpVS0Jk?=
 =?utf-8?B?Ujg5RDNkdXJUenBUNml4TnhUczdTMDFZZzRoNmQxcDB0YzBWVTljRzNBc2xo?=
 =?utf-8?B?eFJ6YjhmbXRDcFZRS3VsekhYOTdJbjhmRFNpTzdVOFgxSkFrMUU2UDNHSk1W?=
 =?utf-8?B?dVpNK1dlZ3FQblZ3bjJ5Rm5HS1JmcUFHMm1BcHI5bk9FaThZTG4rOUlyK2pG?=
 =?utf-8?B?aUNPd1JFZGFHeGg4ZmRJQno4K3NxMmhQNUVpSjRLZFJZM0NJUFdJd2d4dHlU?=
 =?utf-8?B?dnNSS2xXTE94czJGbVV3eTBPUzVGRzhLTUl4ZzRGSk5yNXIrTUxoSTFmakUz?=
 =?utf-8?B?Sk5CdXQvUWptUjYrNnAyY2UrM01yODBxdzd1dUlFWEt1M1IrZis0Z1NiQThp?=
 =?utf-8?B?ZzhneGhUbWtTZk9LUVZEaE9oK1BTa1ZlVXlYanVjTkNXanFUNUJYVlVPbjdH?=
 =?utf-8?B?MGRza3cyQ01HaWY4aGQ4SXBxT0QxVWx3WTBIVnhFalJjOWEzSW91L0RORitw?=
 =?utf-8?B?RHd6bFAyZUQvZEtYbXhaOWUvbm54dnFCZGlhREp0M0lqbTFpRzlDQUY5UW9J?=
 =?utf-8?B?aGJQRWQyQk1xUHI3LzRhUGsrcVB1SWVBR2lJU2VpNVEvYkQ5YWFsaXRWK1V4?=
 =?utf-8?B?Q2pIODUxRExKUzZQQW5kdEZUeE1WNzBiai9aWjlVUzJZSEwyZTlKOEpXVEJt?=
 =?utf-8?B?d1JjWXBxK0JsL1FnWnVkdzN4Y2lPSnhQNURBSklndStrV0hnTDRPSW5NNjhh?=
 =?utf-8?B?a2Zscm5UQklVb05KQ1VFMWdrUlYya2tlQkZKUWpZTXdGbmJrK1BzTVlIQkNs?=
 =?utf-8?B?dUFycGtnZTRkYkFtR1FxSVZKWDRhVUJxUlh1bVNEUWx0ejFsVHJtN2pCSklU?=
 =?utf-8?B?WDZGRllmSEp0L1V3b1VqbUkrbUZ0T01JMWt4NnVUL0o0Z29RcHkvdDhabEV3?=
 =?utf-8?B?UUZHRlBhcG83TUN5OXc1OXpYMWtRcTZHVHQyQVEzY0NvbkpVTG9Td0ErM001?=
 =?utf-8?B?S3poTVFKYUJYMVgweDJOdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGJjQ3JIa3pzT0tOMkNTZ2h1WndSZzd4Vk5nbCs3T2pVL1hwZ3hLUnlZWEVD?=
 =?utf-8?B?dEZ3MTkwWjdyVXh1YS8zWjZ1b0E1NEpKOFJGYm8zV1MwREtjTnc1NDZ2c0J0?=
 =?utf-8?B?V3VLa0JjMWpieVNlZFNPb2NLQkhRUjRFWXJJWHJuNEh3cVNKMDI4SWxpdnQ4?=
 =?utf-8?B?MUp6aEtJN2VLUGNma0tDcDliVnFBOGxEKzdkRHUyZUpHNTFhQTVjOUlzZGkz?=
 =?utf-8?B?bGh4bGpnd2VRcmxlUDBaQis3d0QvQVhFdU82aFhvNWlpZzM2QzlXczdPaU9V?=
 =?utf-8?B?MndFMmVQdWRDdVBld1dyb2owa0t0N1lzZGsyNnR3dzgybjJtckY5V0gzaDM3?=
 =?utf-8?B?M283eSswc2JjWUxOWE41blUwTk5rU1pndVROVHZJU0pMRDY3ekhDTkVDWHAz?=
 =?utf-8?B?VTFmcnFra04rUnc3dDlBUVlYSG96ZXF3UzBMVFhrb1VsamkwTk5aWHVwS1Nl?=
 =?utf-8?B?TXZRU0Jqa0RzaTdRRHJwQVFXT1dCclJFOTdFSDVNaSttWGQvay9ZVmttSS9n?=
 =?utf-8?B?aHA5d1lMenlDK0l3SmUrWm1DNGZsQk5zcVk4U2V0Z0hyWml3bThkQ2N2cmQx?=
 =?utf-8?B?aUloRzlyL2Z0WFpsRjdlaXdtT1NRdXl2c1hLcGR5YURJZnNzb1JVQlNZbzR6?=
 =?utf-8?B?eUl2ZzRyM2N0cVBqUkd6aGFFVFdTeUpjQmZPRmJob0VuNU5kM3pISUhmVGxI?=
 =?utf-8?B?TDlGdG90d01QeTBLTWJZV1BxR3NtbHoxRjd6ZWczQmYwRzZJeEgwRk54eWRY?=
 =?utf-8?B?a2FQbTlURmtEVWtTelJMeUhPdXNDY3lKUGlSUHRnV0ZobHRIeTFMcG14VUR0?=
 =?utf-8?B?cWEwQ1U1d0VZVS9QMnRhaVgxbkg0L2tQR0x6NnVLWHJZOENmR0hpSGJncklS?=
 =?utf-8?B?QUJ3TUxSb0w0Tm04dml6Z1JWLys5NmhxVjRLN1Z0MkVGRmlra2Y5NS9GZkNw?=
 =?utf-8?B?REpxVWdZY2RJVHc5V2RheUFKcUVqSDcwQkNpdUlvejNQSlR1d285bk1aWCtL?=
 =?utf-8?B?dG1ZZ0tvM1E4TjdYdDVaR0hNM2lPWmJCYmVyVUl6L2o2ajN4bk4wYlRtN3ll?=
 =?utf-8?B?MjhrS0loSmU0dkRDdmV6WTZtNzFaQjRxclRITEgzd1VXaDl0M1BERnFRUVlm?=
 =?utf-8?B?ajgyZGZJelVKMU5ZNk5tcU1FbkRodlFDZml6YmJyWUZNUnUwRkdTRDUrSzVB?=
 =?utf-8?B?MFVGbnoybkJqN3V4T1RvODRkUlJjZVNPbURlalV5bEtaZTVjS1pRYnpKRk9J?=
 =?utf-8?B?bmR5aHNaVkp6WWw0K09GRHI2SHBMWXkzRVdsYXl1ekhoVE5YcnpRYUVZVlpq?=
 =?utf-8?B?bHRlWDYzQVV6Wms2UTNGZngzUUdMeXRjN0xWTzhvdFNEWVA5bWdMQ1Zsc2Q0?=
 =?utf-8?B?TzZXZDk5Z1RlUkllV1dId2ZOaEpxUVlOc2NsTkhOcGhaS2k2S095TVdoekpm?=
 =?utf-8?B?NzRPWmhmR3lDYS8wUVQvYmtLMWtXcnlZWjF1N05hblhuVXE3VXFmWDFhV1R6?=
 =?utf-8?B?ck9tdW9jRnlvWGN1a2wrVlJvVmRUQWtvNGQyRDRMeWlhM0lKTnBsbHlaQVMw?=
 =?utf-8?B?VkI4Z29jcm9JaG1jODBxaU9wbFZlTnJXd3BjdEIzMDdZKzNHWCtIUUVGV2R0?=
 =?utf-8?B?czAwWktMcHlpSlg5eVo5OGM0aVhmbE1zR1FnSlNiZTVOVlRMZWVTMUhoSXdh?=
 =?utf-8?B?cDFneStJd1d3YW1mbHZRVU52RVMxdzNXTjA2MnZmaGV3Z0RTQ3VKL3cvRUlH?=
 =?utf-8?B?ZmpxUDgyaTFCYWhYZ2tMTDNGOGNQK1JNNENoMUtvVEtvbGFiTlRlay9TUits?=
 =?utf-8?B?TFJNUWdqbUdDM25Wd1o2M3Q5VzJpV0NjN0pXazF3bXl1ZTNQQnZRM0psR1gz?=
 =?utf-8?B?ZWhDQWtpYkZPVzFOMVRtaUZWNnB3MkFXS0dhY3Jla2hJZ1ZHSURqclkwRGc2?=
 =?utf-8?B?RTlYVzJLUTNBTU9UTk5CMUpoWXhsd2xXcmNVUFMxaE5RTC8xSERxN29KNGZy?=
 =?utf-8?B?WC9HejlxM1ZnN2xGWlFnN1lmaUpqUVdZeFlzdURvUWdsTlBXUjVNcWNoUTVr?=
 =?utf-8?B?NUN0Z1gydmV1Z2x1TjI4NjU4aUNoUDZpYjF6L0J5U0x3ZzFFRlhKdytUSHBr?=
 =?utf-8?B?RjYwQklhLzVsSmNoenRTWmFWR3p2Nm0zcFIwUzJ1TnBzbnNqZ2Q5RkQ0Sitn?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b5b301-3596-453c-da87-08dd6101c0e6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 01:03:51.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFtztkX5aHUgDtiTZTyjSPwdmbw7xcxPuG5IcowPKy6ZPSU21/KWEj6qkgY/VZoUtKxVB/XTvUT8kwjW2ib8pKWBiIVJ8CEPEupyIJIU8TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8206
X-OriginatorOrg: intel.com

On 3/11/2025 5:27 AM, Chao Gao wrote:
> 
> I dug through the history and found a discussion about the naming at:
> 
> https://lore.kernel.org/all/893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com/#t

Okay, it looks like you've finally captured the full context!

> I think I should revise the changelog to call out why 'DYNAMIC' is preferred
> over 'GUEST' and reference that discussion.

You might want to take some time to think about some code comments when 
defining the feature. I think 'independent feature' is a good example to 
look at:

https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/include/asm/fpu/xstate.h#n53

Thanks,
Chang

