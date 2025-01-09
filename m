Return-Path: <kvm+bounces-34886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1A2FA06F6D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:54:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1703D3A407C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9993E43169;
	Thu,  9 Jan 2025 07:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+1MGxQZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388D202C31
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 07:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409177; cv=fail; b=CzrbrNWFUTYUTH7Fuf+8wL17swf6U0CgRo/bkPKNrBbU2HPZl2IGHl6RW3ECxvDF1iBHsiYZH/JD5/k75S354ZdtUep9ezIfbGpvKRPUujonkLqX5N47jfTMlGMHQn/6cBGWzcau5DyMXW6Ew79xya29VrdEIfPh8gE1RKqzg60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409177; c=relaxed/simple;
	bh=K03OVT706panyDqqeOvt1dcyUn6rJABt70fJI5wtjcA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bqrLPtNkTdUSINDMgYlulNxiPF+WzLAviXMpLCoxp2r0V7ycoWDbCvegsjh1IwEQ9Vq5w3QhJ+O+7+1y9mqlKsphaicSjyfx5B+iWCPsL7KTY39dgkbv4jJj57o2bD7edl5idajsgy11o5GZsY792L/0VbIlsgh4whm84isNvrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+1MGxQZ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736409176; x=1767945176;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K03OVT706panyDqqeOvt1dcyUn6rJABt70fJI5wtjcA=;
  b=G+1MGxQZPQHdUEBjHv+NXA0cu7oJWlvyh6FZpnUgk5Epj8H0FPL2yc1F
   LOHQgnK9qh1kcM21KXuQvguwjRKKuzqVieewckLrFNiDGJmlotgmGirxD
   E28cykIxi1jZ43NbMylt6rRm5xZD+vv7cARE8XJiR9TY7fvErKbpOA93M
   lm+EcY2EFhShMjWjMB9YhqLsYYhafGK2pi/XDkzwvT1nsau4GGT/u6Zew
   LAMo2U3uJXzdiq0olqslb61vYuLkeoDzNrB3E+iwM7quHJV38nP4Wh4bQ
   zxfc886oT5zmm6Rvxym2J85PTD1M0zIe7avr3Iv1oxnqT1TOVQnCctzH6
   A==;
X-CSE-ConnectionGUID: Fv7LUt6SRsyTibLXsBRwZQ==
X-CSE-MsgGUID: OJ0m56ZXQb6A2e9hauRhSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="47154568"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="47154568"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 23:52:55 -0800
X-CSE-ConnectionGUID: rYHQ2KmnTQqjQNcjA+QRmg==
X-CSE-MsgGUID: EA4toFVHTc25JjfG+J7qwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103138174"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 23:52:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 23:52:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 23:52:54 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 23:52:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cA5WResk1FcfTyqgIe1EeEYtO3k4urE9kOA9v5srXmtG86QzZwJpTIN5+6iBgZ3jAyOnoMfzhCWSjUhfFjt4txiIqdvG7uwoZTxhyxduA5MNhU1jq4q8n2j5dwuLPLzKCxKKKbyrOl0U/YRZETM2jFiqUUen+IANCd/VAU0DrQUqoLNDl1lGbCHTVLq/NsuCgzYRCtj77G7UqxgdbigqhSv8ciZB4BnKwQERUAoqzqaGVxnYvSF3i1MsbFyAvYzVVSF3qT3JO0PFlppdcSeU1PjJ3wzXwmz3eOOrbOfjFjPmwZDIwqCDMufbtmZQLcpBzlZPMazgNnzQAzV6Sm+KMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkjWNbisX8f76H2aa3uIaOSBX+lY7kpvs7F82Ys3b/I=;
 b=R5/Nm4LQt+D1kPvq92ChQROoB++3EcqT20ZDS4dXDmPLvnIB5mXJwLeGUJPV8peqCVe/Url9sxRHazgl8Xo6HqCVqeIwtEPGle6K5lPxHPJxyo6awy6OQMiKWdDP27M42ZzdkHl5K1vl7MBi3fZb4oJBh7JA3ufUa9pJYmOEIyBSkGUPmYEIvpiXK2xPXgaVA9gaCJE6TXvFBMYsIFo4fDZtxT/DNvLj/yxwJRte93Szzls7zpycr+/tInbbbOJzPOc45pCXlB9MEEm4izkDRkmbwCKgUMS7zmfi60VFSOf1V8hKiA7uw3ip/I0+FX2/xbqVIbOOCg4w5iV/9kaiqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 07:52:50 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%7]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 07:52:50 +0000
Message-ID: <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
Date: Thu, 9 Jan 2025 15:52:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|CH3PR11MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 9919b682-0854-47dc-9612-08dd30829d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Sy93c3BGMDd4QUpWTm5ScDc3ZUFmS0IrNVJVdk9Fd2NlR0E1bmpYS1NLbEly?=
 =?utf-8?B?dDlSeUI0bnBSQ2hEOEMrQUUxOHJjUGNKd01jZ0NVN1RpUEpaTXZWVXpaMnpG?=
 =?utf-8?B?UU0wTFhNem1RSi94SUthK2J1eUpocE8yUTE5U2VWakcwNEJVSitka2psTXRt?=
 =?utf-8?B?c205VnZnWFphVXRrWUZldmhmTlhZRmx6ZVlKVjNFQTNxUjY5MWVVVi9YKzFz?=
 =?utf-8?B?RExqYWpDS1R6REMwWkpBRWNIUXNCZlUweGdyZGdpWDZEQXpOUFhqb3dUQlY3?=
 =?utf-8?B?a0JPUHUyU2x1VVF4dHZ1NG14K0R4L0xZK1pQc1Y0SnlTVUFjeTQ4cTEwZUxI?=
 =?utf-8?B?dDNjbVhyMHFFOEdrL0Y3dFJVOG9ucm1hSURGUVhTTytpWFkrQ2FUTWZKOHRz?=
 =?utf-8?B?YzVXcDBCM0Z2S21PYUs3OVdnUHBxRmJTazR5SHBtWmZOTXdPZGVzeW9EOXlB?=
 =?utf-8?B?a1ExS0IrTW52TDJSd2hmYS9mU3NiU1ZIMVkvM2RIRzN3R2NCVHFqa3IvWHNI?=
 =?utf-8?B?ZHNLT2tVMWlHNzlOZW9CZjhmRy9uVm82U3lhTFhCY256a3VQNHlyR2hxZnhw?=
 =?utf-8?B?ZnVOYjdzb2ZxZ1JXNXpIcFZ2UDdzYysxa1F2SmJUdk9SMThJSnJNN1M3ZElq?=
 =?utf-8?B?djBvd2krY3RHSG9TVkZKZmZIM2d3MzFIWmFjSndlbGZjOEd0OERUajRUNjBM?=
 =?utf-8?B?dEhreTYzcHhWbGJpajFIVjZjN24zYWs1T2NXVURLakp2cjZzMldaV0Z0dEc1?=
 =?utf-8?B?SUF2WUp1cmlFQWpDak4wcnA1dUJkb21BenFpVW1zVklZY2ducjR1UUVhWXNT?=
 =?utf-8?B?dndCaHdYOW10VHk5M0czM21JTGZJcGFlUndnTUdkV1gwVlkyOVJOdjdaNW94?=
 =?utf-8?B?TmwvMEUxYnV2VWlxWlIwb0pRWnFKRzhmNWZITjI5V1ZGSW1MSEVuTldoWTA3?=
 =?utf-8?B?RlRLVlJjZ0J3aHlGUitjdWsycDlYVG5JQVVka2NuV2NKRXNrYkVyV01JdmxE?=
 =?utf-8?B?Qld3ZGJsMEo1Rkd6OWJzL2ZrMTlKSEwxSG9vVWZ6L3hNSmIyNHdRVUU5Tkg0?=
 =?utf-8?B?YnZXR2RSU0JiWEU5VDBXdi91SmliWDJweS92YUg3clpqbVhJOEFkS2FBaDNX?=
 =?utf-8?B?UCtILzdLbFlOTFZvV2w0ZmgvWWNORGVPbkhlSE93TWwrSGo1dGZpUS9tL1RJ?=
 =?utf-8?B?b2lOdTI1ZWFRZnBNVEQrY3RHSDZ6THF4c3F5QTd0amNWQzFSK005eVozcGhV?=
 =?utf-8?B?MUg5MDIvUFo2Q1hUcXMvY3NrN2VXVXFITC8xSWFxWE95K20zUnpMeGFxNjg1?=
 =?utf-8?B?eTFWV3RRSnViMVBFZDdsdEh3UWpVYjhZVURVdkRIT2twKzlnYzlzcDdybGY3?=
 =?utf-8?B?TGFESWZYNkJENDVudWJ3UlM5M3JUd0VZT0Z6T1pLNFRCZGMzclRCbTZOc2VV?=
 =?utf-8?B?K0g1aWEzNWdBeWh5K1FsVmJ2Qk5XOFA1VEJiSWNETkhZOGxGNXZ0WVZGSFhX?=
 =?utf-8?B?cU5BR1lTZDFkZUVrN2FKQzRjdjdhNUEwd3V0dkwwRkFHREd6K1Q5WWRFR0g5?=
 =?utf-8?B?eHk0MEVaMG0zTnV1cE9yRzYxZ3dKREtxd3VMV0NoZHExSTgzU1V5cVZTRk9H?=
 =?utf-8?B?VjlhdFFsSVJLUDFvUENaZGdtOVRtUS9nZ0ZGTnE0N1BSRkhocEdJTEcydmhR?=
 =?utf-8?B?OE0wakZETFZuM2w5UkJ2aEh0QzNobC9icDlOV3A4YjZVUkFkMXZValppL3FM?=
 =?utf-8?B?dzBEd3k5WDB6dzc5c25CNTkzWXc0aERXOXI1WDd1VlRuYU92NTdpWUxjZU9v?=
 =?utf-8?B?dGR5NVFDTC9QSVBjWmZaUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlFiY3UrQVpLS1h0SFg2TXZVKzQ1b1FpWXpzNjJlN0thbnRrbnQ5b2UwVmI5?=
 =?utf-8?B?NXdndEpzejF1R085RFVTYWk3WlE4bEpFWmt0bkE1aVJkck1Qd290YmV4emlQ?=
 =?utf-8?B?RTZlL1lwalc2L2xqNzZUait1a2RFRURmOUwvcGIwVjRSRlEwYlgxbysva2hO?=
 =?utf-8?B?VnRacFFSTDhVNFdXTUNGYWw4NjZOV3V2cHUvSmFzZi84RHFmYlUwRjJNT0tR?=
 =?utf-8?B?U1dYRzkzRmJ1a0Z0Qml1dGx2MUhVSFJOTmJPZ2FKYW81V3dIVnc0SFRoVEMr?=
 =?utf-8?B?bFJmT09TdS9Na0Q1aUZTOG1hblJXd0JEY1NiN05rbm5sR1d5K3p0MnVVYUx3?=
 =?utf-8?B?ckhYZW9oVkpPOFNqSVZ1VGJvQzluNkVQaDkzRFJsYjArRTdKUGtKMS9Fb1NF?=
 =?utf-8?B?c3czRnV3MVFZSVZkeXNYdWpOTC9OTlBoQjRRWTVEdVRDWFB5cEJzNS85eFg3?=
 =?utf-8?B?L3ZBMmc1UUUyREhvT1F4bXVrRHRiMVF1djBRT0YyT2lqeU16ZlZJQS9UNTRZ?=
 =?utf-8?B?YnQxdnZ1amVXdHJRUjc3RzJPazRWTU9qR0VxRjFVclVrMEhnVE8zMTB4MGJU?=
 =?utf-8?B?Ujhma3huTE5HQSswRkJkZUIxZXBVd1FNU0N5UWdvVEQ3RWQ2NDFVaGp0bEhP?=
 =?utf-8?B?ZjkvQ0ErZHlqNTRYMVorZE5TVGNUWlp2ZlFZMDJnbi8xaVZVMG5aSExsYm8z?=
 =?utf-8?B?bjlJeVZDb0ljTXZzT05rOW85dUlNNzY0Y3BCaFFGVVB3QmNib0tGdWFMV0h0?=
 =?utf-8?B?bldNUW1MOW5Bc3ZlVkFJbksvRUR1cTh6ZHdKVEZ4OG9qVnhGYlNLdE14dUl0?=
 =?utf-8?B?bWFqYlNzU3V1VnlzdGY3eHd3RlNJaTRhcDFZK3pLcXhUcm5ET1NoK3E1ZGdR?=
 =?utf-8?B?ZWdYK2Y5L3NGOFRiMm9NMm1MSUlJZnc3L0dKdGxLYTFvNXZzeURmd1pEcnMw?=
 =?utf-8?B?ZTJZMGRtQndJZG9wQUFaM3VQQkYyZEd2bVIyeVRtRkoveWY1aHhaQ3praWxP?=
 =?utf-8?B?R1ZxbDdOdkRvTFdHQlFwUkFSbENlcXY1NnNKcjViZmxoazI5OGRFdlVRY1pZ?=
 =?utf-8?B?b3lTbmJ3eTNnRmFOOUJRTG5xQjNjdjNKMWwwR2MvVUVQWWsvZldydTdWMDgw?=
 =?utf-8?B?RzA1N3orRmNhK28zZnlnblNnbFg0bzNhT0IwUGlzTlhXV2Z1SzYzL0xJVmRP?=
 =?utf-8?B?NjhBRS9BVjN6OVFrUlVoYXhnVG1wMTR6QTlYZmtZOVhwK2oxd2ZHYzRYcmJ0?=
 =?utf-8?B?VHZHT2swclFpN0JqT3dIK2ZOdDN0TXVTNDBFU3FYTkNlZDJOMjZUWEozZ2dj?=
 =?utf-8?B?eFFHaDB3MjhrTU90R2NSRnJTaVJ6THpvUjFiY2V6ZWVCRVRsVnQ1aDZpK3Zq?=
 =?utf-8?B?NWlrbExXTUlwVlhWcGphNzdQVWxRa1VDY1dTaEdIRTVRWnlUZFFZbitGNXFk?=
 =?utf-8?B?TEtmcTNXTEdUMmdGV0FxQjBLYnpoS2hLazhpbDRISFVpbk9jbVRiWm9rTmFL?=
 =?utf-8?B?alMweFZOa1BwQm52ZmsycnF1RFNFYUJ6S0x6clNDd0pWS29hQmtydm9nSE84?=
 =?utf-8?B?U05wZnd3MldXUnRiK055NjljMmtSakhzZzhPQ01pZFFlcmxRVDVDcWxVTFBw?=
 =?utf-8?B?QzJ1MjZpKzAvcVF2TUk0M2d6b3FnaTJMZjJNT3FlK3Rxb2FKQnpkZ2VPdVg1?=
 =?utf-8?B?L1Z4N21mMDYyVVU0VW5JU3VxWmFsSEovYzdDRXRtQzkwdzNIditUbytmVVVZ?=
 =?utf-8?B?NnJrSVdNYldlazZabkkvR0FBYzlLQ25xWTBROUUrY3BKNWc5eFdYQlNwZU1H?=
 =?utf-8?B?MTdPbDRFS0pGejh5TVVXT2FkaEh2U2ZSSENoalZaTnFua2hNcG9BZmREeStD?=
 =?utf-8?B?enZZTjhyMU0xNC9aWFordXQxV0R1VHhHSHlIMFQ3YWg5UFkyL1NDWE1VYmUz?=
 =?utf-8?B?UzR1Vk5vanZHWGd5cGJTUFAremdjZnJJWDJQQVZyWkRIVmZFRkYrRVpoeTBk?=
 =?utf-8?B?SUFXbEtNOHpPTE8yTythQTh1S0Y2MjduN1JxaXhWMzJwdVYweHg2aXo0R1J4?=
 =?utf-8?B?TEMveGtTMVlKY2xSUVJjS0VEZjI0MjUrcXJKclc3UGlQZ2F3QkdRUWFzU3pz?=
 =?utf-8?B?aVk0dXUzcDRnUDVINWtZb3ZnU1h3cy8wNDRIVTgwRVMrZW1Pd1Bxb1F5Rng0?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9919b682-0854-47dc-9612-08dd30829d6e
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 07:52:50.5621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAlTw3Pdb43VQwWTqbGD82xgi5VJ7r+mh/HxVjgkdMu8ZAA57OZ8MQF6Fhcdovgkkbrob7e9tB68sLgMc8PEiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-OriginatorOrg: intel.com



On 1/8/2025 7:38 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 8/1/25 17:28, Chenyi Qiang wrote:
>> Thanks Alexey for your review!
>>
>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>> discard") effectively disables device assignment when using
>>>> guest_memfd.
>>>> This poses a significant challenge as guest_memfd is essential for
>>>> confidential guests, thereby blocking device assignment to these VMs.
>>>> The initial rationale for disabling device assignment was due to stale
>>>> IOMMU mappings (see Problem section) and the assumption that TEE I/O
>>>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-assignment
>>>> problem for confidential guests [1]. However, this assumption has
>>>> proven
>>>> to be incorrect. TEE I/O relies on the ability to operate devices
>>>> against
>>>> "shared" or untrusted memory, which is crucial for device
>>>> initialization
>>>> and error recovery scenarios. As a result, the current implementation
>>>> does
>>>> not adequately support device assignment for confidential guests,
>>>> necessitating
>>>> a reevaluation of the approach to ensure compatibility and
>>>> functionality.
>>>>
>>>> This series enables shared device assignment by notifying VFIO of page
>>>> conversions using an existing framework named RamDiscardListener.
>>>> Additionally, there is an ongoing patch set [2] that aims to add 1G
>>>> page
>>>> support for guest_memfd. This patch set introduces in-place page
>>>> conversion,
>>>> where private and shared memory share the same physical pages as the
>>>> backend.
>>>> This development may impact our solution.
>>>>
>>>> We presented our solution in the guest_memfd meeting to discuss its
>>>> compatibility with the new changes and potential future directions
>>>> (see [3]
>>>> for more details). The conclusion was that, although our solution may
>>>> not be
>>>> the most elegant (see the Limitation section), it is sufficient for
>>>> now and
>>>> can be easily adapted to future changes.
>>>>
>>>> We are re-posting the patch series with some cleanup and have removed
>>>> the RFC
>>>> label for the main enabling patches (1-6). The newly-added patch 7 is
>>>> still
>>>> marked as RFC as it tries to resolve some extension concerns related to
>>>> RamDiscardManager for future usage.
>>>>
>>>> The overview of the patches:
>>>> - Patch 1: Export a helper to get intersection of a MemoryRegionSection
>>>>     with a given range.
>>>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>>>     RamDiscardManager, and notify the shared/private state change
>>>> during
>>>>     conversion.
>>>> - Patch 7: Try to resolve a semantics concern related to
>>>> RamDiscardManager
>>>>     i.e. RamDiscardManager is used to manage memory plug/unplug state
>>>>     instead of shared/private state. It would affect future users of
>>>>     RamDiscardManger in confidential VMs. Attach it behind as a RFC
>>>> patch[4].
>>>>
>>>> Changes since last version:
>>>> - Add a patch to export some generic helper functions from virtio-mem
>>>> code.
>>>> - Change the bitmap in guest_memfd_manager from default shared to
>>>> default
>>>>     private. This keeps alignment with virtio-mem that 1-setting in
>>>> bitmap
>>>>     represents the populated state and may help to export more generic
>>>> code
>>>>     if necessary.
>>>> - Add the helpers to initialize/uninitialize the guest_memfd_manager
>>>> instance
>>>>     to make it more clear.
>>>> - Add a patch to distinguish between the shared/private state change
>>>> and
>>>>     the memory plug/unplug state change in RamDiscardManager.
>>>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>>>> chenyi.qiang@intel.com/
>>>>
>>>> ---
>>>>
>>>> Background
>>>> ==========
>>>> Confidential VMs have two classes of memory: shared and private memory.
>>>> Shared memory is accessible from the host/VMM while private memory is
>>>> not. Confidential VMs can decide which memory is shared/private and
>>>> convert memory between shared/private at runtime.
>>>>
>>>> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
>>>> private memory. The key differences between guest_memfd and normal
>>>> memfd
>>>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner
>>>> VM and
>>>> cannot be mapped, read or written by userspace.
>>>
>>> The "cannot be mapped" seems to be not true soon anymore (if not
>>> already).
>>>
>>> https://lore.kernel.org/all/20240801090117.3841080-1-tabba@google.com/T/
>>
>> Exactly, allowing guest_memfd to do mmap is the direction. I mentioned
>> it below with in-place page conversion. Maybe I would move it here to
>> make it more clear.
>>
>>>
>>>
>>>>
>>>> In QEMU's implementation, shared memory is allocated with normal
>>>> methods
>>>> (e.g. mmap or fallocate) while private memory is allocated from
>>>> guest_memfd. When a VM performs memory conversions, QEMU frees pages
>>>> via
>>>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>>>> allocates new pages from the other side.
>>>>
>>
>> [...]
>>
>>>>
>>>> One limitation (also discussed in the guest_memfd meeting) is that VFIO
>>>> expects the DMA mapping for a specific IOVA to be mapped and unmapped
>>>> with
>>>> the same granularity. The guest may perform partial conversions,
>>>> such as
>>>> converting a small region within a larger region. To prevent such
>>>> invalid
>>>> cases, all operations are performed with 4K granularity. The possible
>>>> solutions we can think of are either to enable VFIO to support partial
>>>> unmap
> 
> btw the old VFIO does not split mappings but iommufd seems to be capable
> of it - there is iopt_area_split(). What happens if you try unmapping a
> smaller chunk that does not exactly match any mapped chunk? thanks,

iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
disable_large_page=true. That means the large IOPTE is also disabled in
IOMMU. So it can do the split easily. See the comment in
iommufd_vfio_set_iommu().

iommufd VFIO compatible mode is a transition from legacy VFIO to
iommufd. For the normal iommufd, it requires the iova/length must be a
superset of a previously mapped range. If not match, will return error.

> 
> 


