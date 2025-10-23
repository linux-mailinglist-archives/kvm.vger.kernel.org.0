Return-Path: <kvm+bounces-60926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 816E5C03A4F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F38F91A62CA8
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE03C27B355;
	Thu, 23 Oct 2025 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EX+VJJyY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B28405C;
	Thu, 23 Oct 2025 22:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761257443; cv=fail; b=uwL2vYObHdzDG/ABLhOjyvMRmmYfsjek9zTwat5g1f8OHY04kqE/LYpIag+3ooBsHlJl6+30RRvjxkRuxpisMQ/5qyMgM0getzk6MVTNa8rwk3mOfzp87jrr96DoVHXcGO0kXX34WukadSXl76LMCwpMbfY5/xIvW5Y0js9vB4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761257443; c=relaxed/simple;
	bh=34W7giyJB63ny9+vkqGJ5L3fAf8u2Yqxg9MfyoiAfzA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ww3TvN1jNvhMfCTMZI1Zlk/WwUxgq6skmNEtjjcdsh1MP6MNSfmtxui3fUHp6VxKA4+wWtPNZs4x31DvRpNJj91eHWZroeUGtINWieRIWPeZXooE9lJzP9zQeyl4Sb+nImyX7K+rDVz1T32Kkrd1zgu3Yt5LJMYu+E/mCv2aIk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EX+VJJyY; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761257443; x=1792793443;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=34W7giyJB63ny9+vkqGJ5L3fAf8u2Yqxg9MfyoiAfzA=;
  b=EX+VJJyYY33wEkpvlBuEpSsh7zI8tI912GK5x05zDYmtg1SwN1M8THMb
   TqBIzsw6XlUEVmVBlS4jnpidZfc+n7o18UDO3FyNR/19gE1/In2lFiXd9
   vznx+NGlI3gucXI1bYDQgjSl/l4hS8zXjSS+S5OXYyp/KiiBIOGXTc9lY
   eybJb7sdqlmAoGgogNEDDKzpvSle8UuubnjCM4/CYKeFZbWomsi8i0+dy
   TEYnwfgjAFT/wlokHNohb3nCt5fHX0e5NTTvJSI0VDh55fRKL6doVRLcg
   0dtzjKvai9e5LJtJwulGJPKcz4H94xvFYKrrSG9/7rPfxHkXL1KvE6IjZ
   Q==;
X-CSE-ConnectionGUID: y9VPs7RYSrWNDd1sRaRdcg==
X-CSE-MsgGUID: PyvjY2dLQqaaJZRZWay9fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63480369"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63480369"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:10:42 -0700
X-CSE-ConnectionGUID: Qm+sgfpUS8aflkMhtAlpQQ==
X-CSE-MsgGUID: hakQM7HqQQKa8bf106rsHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="188663117"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:10:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:10:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 15:10:40 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:10:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GwCejcQDTG/r+DHRI4yLwO59L1AjfoIIsuMBHoSqkIU752quNC8/AMjIB6a/wTZAD8ivcIWRbwtm7OPVzf2TXuYU6Tnsi6FW3+4ZKN4GLwkLMaioaknt+oYh0vdIf0Z6wkm5TXufYiFmbs4YJig41re00Z48/Ys7QH2xtEF1B+vQSPg3sWl0mg+lyD11KoNkPbBtjPlTLhl18Gfn6biXUCnJvoZ+/0EDYiZwN2mqI+tWL45g47Y9SKcmcP+xRkqa6ObP9lY6cFJTXit0xZrI+qXN5KP6HoPC6FmYbgTI5XoyL7XEUTrcToBWUaiYkE4qucqiiaaD9UfeYILW8vHZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDh7+5uIU7Kiu0mvJyztwyAoim8LyYnMZ7vNKx8lPpc=;
 b=EXkK/CvBLMEqsE8F+D3F1nmK4NszjbjayFfTKfGN1ciTg7oPOEj+bA2gKR/0nEiCzAnrch9236nEjt3D8xggAGI74yT07mdANpB4krS9KKBKsKZBzIS7vd7p2KgUOFNylowrP2HHbIS36p8HLleJygijZWbWjdSNLFENlleyCKD5PBsEjIMEamYfWC+O9WG0UJXqUlVqAu8+lQpv4RJZ1BObBbd9oigieip4HUJQG3pyrEUC7FP78QzHzI5498iuf+yxNZU6hIdO3vmh2hF8VS1JXr1Y/DT5jLzdCWuuE+JRRsUSvsDab0DTVtHHNnR+zHxlopnpI4uxcznNKknGtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6)
 by SJ5PPF8B3F23403.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::842) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 22:10:38 +0000
Received: from MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267]) by MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 22:10:38 +0000
Message-ID: <b523664f-50ce-4de6-8d02-90b6938089c1@intel.com>
Date: Fri, 24 Oct 2025 00:10:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/26] drm/xe/pf: Add helpers for VF MMIO migration
 data handling
To: =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-19-michal.winiarski@intel.com>
Content-Language: en-US
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
In-Reply-To: <20251021224133.577765-19-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::12) To MN0PR11MB6011.namprd11.prod.outlook.com
 (2603:10b6:208:372::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6011:EE_|SJ5PPF8B3F23403:EE_
X-MS-Office365-Filtering-Correlation-Id: 261c598a-00f3-438d-882f-08de1280ff19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?am10a1g2eEZvYVRCazlsaTE3QnpIZnhjVy83aDJ4YzVnd2JiMVk0OEZ5dlJw?=
 =?utf-8?B?Y0dQU2FKQWVsMUlqWXpoeXpMZnE4N2pKTjkzb3NsbFoyOFlEZ2dzZlpiTWM4?=
 =?utf-8?B?eC9KaG1YYzM2cU1YZEVYaEo4aWVhYU9vRmRLdGxJa0x6UlRvUE91eDlNdms5?=
 =?utf-8?B?WGdmTVRwNjBUOVBoMlpDK28yTDFVMVdZMXVRbkQ1eHVESk43em1HUTVhTCtE?=
 =?utf-8?B?K3oremdzam8yZDJxZjhVdklsVW81VnhNdC9BMDZSTklHWTd6dUtmMllEQms1?=
 =?utf-8?B?WlZubUk3c0J0VnpIKzdoSlZVMFROSDF0dUZFck4zQ3dkdW5GQ1lLbm81NWJo?=
 =?utf-8?B?R2FXZDArZkdZdmI4ZnJhZXNNWksvUVp5ck1DL2FZb1VLZGtjeXVtdVA0TW5M?=
 =?utf-8?B?dG93VFhRcEVkOTBEMW5kU0Nwc1paeVloMGdjdTRWSS82d0x0TEVHSDUvbm5G?=
 =?utf-8?B?cXNSTnE2WGY0bXBRVFkya2duaTRTZFhCMVRkZ1EvbUZ5VTU1cW9FNTlsMmpx?=
 =?utf-8?B?NWhVYTRORE50bmx2WG5NL1NmVnBkcWVNMkNEWkZLa1lpWEIzNnVSd3hpbGgw?=
 =?utf-8?B?bmNsSk5UekZEZ3E4QWxsRXh4SXFTNmdOT0t6Q0tkS2lRditUUUJiTEpOVjJH?=
 =?utf-8?B?WXdPcE9yYlpmcmM2dllJVjZrdVRtUWdzMFNkSHVDL2FyVW1abGtaY0c3aUhE?=
 =?utf-8?B?UWtJN1FBemxFR2dNK01YUEhUY25uTmlodHcvd2VpRi9HOWVnNnU4a3AwN3Bk?=
 =?utf-8?B?Qm5FT2s4bisrd2xpTzRwQnlNY2ZWcW1TZlRFTzZGYysvdnlhY1htd3Z2Q0hW?=
 =?utf-8?B?OEkxYjNWTy9xVGhwSGFMSjR1UGRwdSsvU2VVVUdKTzJRaEZCQnZ2UEM3RjJY?=
 =?utf-8?B?dWtCREJRZUV3YUxRditEa2JpazJxQjRVb2RYUTdEUHBaa2dtR24yeFFPcUV0?=
 =?utf-8?B?TDNqR2J6RUZseEVYUjNnS0dsOFRBWThXMDc5NXJkQW5PcTRoS2VydncybG1S?=
 =?utf-8?B?RkR3ejBvWGh5VGM2SHVGeVpTWit6ODFrVnpseXJ4QmdFdDhSdWdjM0VNK2dS?=
 =?utf-8?B?NWxKZzZhVThlSjFhTS8zTUtIcjBsbWcyZzYyRkNqQU9qRTIxVmwvNkhzaFBD?=
 =?utf-8?B?bHVnQmpPSUJ6NXJNdDJDQ2Y1VllLRlAwQWJmSDlzSzYwZzRYOU4xRTNWcHRL?=
 =?utf-8?B?V3Rzd2JTT2NuQWlsbHc5Ni9Ba1VhOW9kRlpHQ3RBc3hYMDg5QUhuVTlqb0hn?=
 =?utf-8?B?czJCYmFpTWgyQkxZVGdnenRVcEdmNXdGQ2U1SmJkd1JWTHlxTzh0bG82cFFR?=
 =?utf-8?B?UmpZbW9ya3l4Z0pFOEVCbHRyQXNSWWtqQXZCQUtlZDhqbXhXdGNJTU53MHp5?=
 =?utf-8?B?R0JScVFoVVEwN3lHTzhrTUhnRTBNVWNOZ3VQZDNiTkVHSkU2bTFtbDVZNzI1?=
 =?utf-8?B?WVY2OHRPMzVuSG9HdmMyNko0bG5BUFNSYnRoZGVCbFNwMEJaOXlPZmt1SXhp?=
 =?utf-8?B?WjMzdHJZakVvbnFMMmxsNGhFNVh0blhDK3NtNEpQNVBIQU9HbnFKVlM4TVhu?=
 =?utf-8?B?MWc5OTgxY2VBaWlJSlNXcS9CQmNOUkl2OVdOSUhFL3VJcGNnaG9OTHBqRm96?=
 =?utf-8?B?RUdMUUhqWlVBYnFjeUV2UWpSVUZQSExFOVVPVXI5cVpmMjFBbXl6cHNtc1Vh?=
 =?utf-8?B?M3V6SlBsWDF3WEFoR1J6YnEyYTB4cEk2MStVMitvYnV5THZiVWhXYmR2WmFW?=
 =?utf-8?B?OFZET2UwUUZkRXJ6UUo4MUg3TndkZWhiM012bUZvekdJWHIrSUJpYVU3SWx4?=
 =?utf-8?B?c09MUEdvd2l1NmJNcUR1SUhZMm1vRVVoTll2WjZjOXU3RytUZm5BUTMwNUFm?=
 =?utf-8?B?MHRQT0FIVU5HTjZWY2xqYU5lT2RTV0dlTHlIM3cwcXFMQjNiM2tWaFZjZjhx?=
 =?utf-8?B?SHc1czZvcGQrcnFMVkZZWU9XbEF2dmJHL2ZvRDYvS3JUeHNNckptU1gwNGQz?=
 =?utf-8?Q?swC++/qjNGhKrQWGiKSvXvqZCIZFtk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG1YWitUR1ZSVzhQTmIrTEV5V3c3WVlOM05LNXVISVFKdzBsNjMxMXRyK3hS?=
 =?utf-8?B?Q0pBRXVSekVHazRDM2RKNWQxdzVMOVhEU1ZraWJXQmFLakZFVVppTmdTUEZ0?=
 =?utf-8?B?OUFndmErbU5RU1lwam11Um1WejlUQi9RVzl1MTI3ZVlGb251bzBWU3J0aXdU?=
 =?utf-8?B?MnJlZmgwWWk1SDhSd2N4R0tocFdtQUJtUWt4aW1wYTJmdkkzV1E2WEFLenBO?=
 =?utf-8?B?NHFmdnQwdXh5cVp6ZkNENGV1YUpnRCthbTQ4MlJUUWlqQVpxaHQvQnFUR0Ur?=
 =?utf-8?B?VmUvalBkOGpnQW16UUhXdkUrOEloUXUyQVBPcFJ5bWw5Wi9PbXJ0ZlQwNWVa?=
 =?utf-8?B?SVUrWjlxYzVybjBMNGYrZlY3bzhWc2pURUwyNnJWWHFOVnhacGZ4QVMwaCtu?=
 =?utf-8?B?YUUzY1lqUUZGazYveXBRZGxFZG5pc3ZEZW1ZT3o4a2NxRU1xeUtXd3VqMnRY?=
 =?utf-8?B?OGdSRW9IR1BlSlZ1clVVc29kQnYvWkJrM1VIRWdvMDVTYjNHOGx3Wi9YTGdM?=
 =?utf-8?B?aVNGSWJTN0NEOVNYTXpiKzBCQ0lyZlVnSVRDNW13V1VsMDEzOXF2QTIxWldh?=
 =?utf-8?B?R0N0dDBTYSt6eFVqTzNIN2p5YWhIMVBvY2x2OE9BblVvYncvZmZuNDd4NXhh?=
 =?utf-8?B?SWdmRWk3c0hldUszam44cEN1bzFCTE0zeUJ1aVh6YU8waE0zeUZDZ3FDZHJC?=
 =?utf-8?B?OHJCZ3A2NEtpQmtLYVJhV2dNVFpjdkg0QWtsalRvUFFYSWFsKzZTaXJwN2hF?=
 =?utf-8?B?dkRKZUVXYXR1Y0VDbXNlOFpBdk9KaHdEMmVrbmU5em1GYVp0VjBRUC9LUXJa?=
 =?utf-8?B?UEg2Skt4TCtmR3RIQkl3U3JvRkZmdHZJY1o0NmhpdzZOVm9uRCtJekFxTitB?=
 =?utf-8?B?aEhYVldqczl0RStqdGNYNFB1MDBabURHcE45bjdBM1hJUjkwZ2pjU2lzMkVw?=
 =?utf-8?B?amtYZHlXRERWNUFRUnQ5eFQvbS9XMEpodUdYY05ZYThVRHNuWUlJek55MVBH?=
 =?utf-8?B?T1VWNithNE14clFGL2dPc0s1ZGxkNEJtMUZVRWQrSzRwOG1JRzN0dXdPU1Uz?=
 =?utf-8?B?ZHp4Z0pPNUJ2Tmx6K2cwUENmOHNJcDVHNTRvMHY1YWRSWWUrdVhhMFlKZitk?=
 =?utf-8?B?ZTZqeEo4eXhUcFpGMnJuLzlBTUczSG03aFBnT3JncHMyYjFFakc0MGJhRXdB?=
 =?utf-8?B?OHBLaFFkRHJmVWR2M0QrbHNBOGhWcjc5WHpzU1YyZ2JiSWJjc0xadnB2b2Za?=
 =?utf-8?B?Zk9DWDdqcGZzWGpBcUs0R3lZSUtHTzdZSGg2a0NyOGZtd054a1dpTzJlK2R2?=
 =?utf-8?B?bi84MVh5b0M0amFVQXM2UWFlaitBS2lTbFJuallBOWFHTGJEUGVCb3lNRmJB?=
 =?utf-8?B?TlVVbXRjL3ZTdkt0UjJHL1R2QXA2b3ZuNFBCSytjVHBpbzlUNDBOODRCa294?=
 =?utf-8?B?MHJzYkIvZjQ3TmZlZnhWQkcyeGNnNUJmK1hzZzNlQzVqMTYxMStQeFpoZFgy?=
 =?utf-8?B?ZGw4MVhNbEVZTUJKcHJBU2VRQUtvZjNtaEQxaXBJSW1PVFFJR1pBdGEwTnpC?=
 =?utf-8?B?a1ZNUmVGOVdNVTBrcmNrVHpJNmxTT3lSaGlWclBaZEZ2c1MwQ3pid3BiVldD?=
 =?utf-8?B?RmVKY1NZV2Q2QVhsemVpRWFoQWkvUm5oNmU4MWd5ZTFBa01UbS9vYkIxa1JZ?=
 =?utf-8?B?SW5HZmZRdDZpTFBsY0VOaWhLSnliSUFoYmdnSk9BWHY2WWMxNzF3R0hMMTlN?=
 =?utf-8?B?a1QxZnozZFY1a0MxQWdja0RydGlpU3VrYzRxMzJjSFphR29MYlFKMktvais1?=
 =?utf-8?B?RlVWTk45K0RreUZWRTZabjFIdnBTdElUTGtUSmY2SFFVWWRnZnF3TlVqUi9o?=
 =?utf-8?B?OFhmN2FCNHBnRHRhc25rRmpyQXFROEJGanQxMkhvVWFqUjFQREdoaEduam5T?=
 =?utf-8?B?OEhKa29vdFFzY201ckZSYnVBYUlhYmtyVGt2YW44ZjFVZWVMaW5Ub1RQTmhz?=
 =?utf-8?B?blBqSW5tVGZSaVJQNFB5SXpaelBXY3d3RU9MRGZXSmVGY2t1WmVsb3VzMnNU?=
 =?utf-8?B?bXlyaUZzZkFUYmJHK0Q3c0grSjgyQTFMSGZ4WG0yaE1kTWxmR29GaEt0UFMy?=
 =?utf-8?B?Zis3eWFITE00eWx0WU5VQjFJQUJDbTEyT1ErN3BCcUxRcDJ1bDFsMXNWNWVD?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 261c598a-00f3-438d-882f-08de1280ff19
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 22:10:38.0390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTt47S1rJyluPQ9e4moaJx1r9swi3m3wJ0C3U/PLftZ1ixXdOrdUDMzJA0A55abplkA74sWln1w/FteWvftfCSlM3yJWCHQ5FdbBf5t3Zuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8B3F23403
X-OriginatorOrg: intel.com



On 10/22/2025 12:41 AM, Michał Winiarski wrote:
> In an upcoming change, the VF MMIO migration data will be handled as
> part of VF control state machine. Add the necessary helpers to allow the
> migration data transfer to/from the VF MMIO registers.
> 
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> ---
>  drivers/gpu/drm/xe/xe_gt_sriov_pf.c | 88 +++++++++++++++++++++++++++++
>  drivers/gpu/drm/xe/xe_gt_sriov_pf.h |  6 ++

wrong place for those helpers

just promote xe_reg_vf_to_pf()

or maybe it can be done like this:

	void xe_mmio_init_vf(struct xe_mmio *vf, const struct xe_mmio *pf, vfid);

then

	struct xe_mmio mmio_vf;

	xe_mmio_init_vf(&mmio_vf, &gt->mmio, vfid);
	val = xe_mmio_read32(&mmio_vf, REG);
	xe_mmio_write32(&mmio_vf, val, REG);

let me try check this out


>  2 files changed, 94 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
> index c4dda87b47cc8..31ee86166dfd0 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
> @@ -194,6 +194,94 @@ static void pf_clear_vf_scratch_regs(struct xe_gt *gt, unsigned int vfid)
>  	}
>  }
>  
> +/**
> + * xe_gt_sriov_pf_mmio_vf_size - Get the size of VF MMIO register data.
> + * @gt: the &xe_gt
> + * @vfid: VF identifier
> + *
> + * Return: size in bytes.
> + */
> +size_t xe_gt_sriov_pf_mmio_vf_size(struct xe_gt *gt, unsigned int vfid)
> +{
> +	if (xe_gt_is_media_type(gt))
> +		return MED_VF_SW_FLAG_COUNT * sizeof(u32);
> +	else
> +		return VF_SW_FLAG_COUNT * sizeof(u32);
> +}
> +
> +/**
> + * xe_gt_sriov_pf_mmio_vf_save - Save VF MMIO register values to a buffer.
> + * @gt: the &xe_gt
> + * @vfid: VF identifier
> + * @buf: destination buffer
> + * @size: destination buffer size in bytes
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_mmio_vf_save(struct xe_gt *gt, unsigned int vfid, void *buf, size_t size)
> +{
> +	u32 stride = pf_get_vf_regs_stride(gt_to_xe(gt));
> +	struct xe_reg scratch;
> +	u32 *regs = buf;
> +	int n, count;
> +
> +	if (size != xe_gt_sriov_pf_mmio_vf_size(gt, vfid))
> +		return -EINVAL;
> +
> +	if (xe_gt_is_media_type(gt)) {
> +		count = MED_VF_SW_FLAG_COUNT;
> +		for (n = 0; n < count; n++) {
> +			scratch = xe_reg_vf_to_pf(MED_VF_SW_FLAG(n), vfid, stride);
> +			regs[n] = xe_mmio_read32(&gt->mmio, scratch);
> +		}
> +	} else {
> +		count = VF_SW_FLAG_COUNT;
> +		for (n = 0; n < count; n++) {
> +			scratch = xe_reg_vf_to_pf(VF_SW_FLAG(n), vfid, stride);
> +			regs[n] = xe_mmio_read32(&gt->mmio, scratch);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * xe_gt_sriov_pf_mmio_vf_restore - Restore VF MMIO register values from a buffer.
> + * @gt: the &xe_gt
> + * @vfid: VF identifier
> + * @buf: source buffer
> + * @size: source buffer size in bytes
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_mmio_vf_restore(struct xe_gt *gt, unsigned int vfid,
> +				   const void *buf, size_t size)
> +{
> +	u32 stride = pf_get_vf_regs_stride(gt_to_xe(gt));
> +	const u32 *regs = buf;
> +	struct xe_reg scratch;
> +	int n, count;
> +
> +	if (size != xe_gt_sriov_pf_mmio_vf_size(gt, vfid))
> +		return -EINVAL;
> +
> +	if (xe_gt_is_media_type(gt)) {
> +		count = MED_VF_SW_FLAG_COUNT;
> +		for (n = 0; n < count; n++) {
> +			scratch = xe_reg_vf_to_pf(MED_VF_SW_FLAG(n), vfid, stride);
> +			xe_mmio_write32(&gt->mmio, scratch, regs[n]);
> +		}
> +	} else {
> +		count = VF_SW_FLAG_COUNT;
> +		for (n = 0; n < count; n++) {
> +			scratch = xe_reg_vf_to_pf(VF_SW_FLAG(n), vfid, stride);
> +			xe_mmio_write32(&gt->mmio, scratch, regs[n]);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * xe_gt_sriov_pf_sanitize_hw() - Reset hardware state related to a VF.
>   * @gt: the &xe_gt
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
> index e7fde3f9937af..7f4f1fda5f77a 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
> @@ -6,6 +6,8 @@
>  #ifndef _XE_GT_SRIOV_PF_H_
>  #define _XE_GT_SRIOV_PF_H_
>  
> +#include <linux/types.h>
> +
>  struct xe_gt;
>  
>  #ifdef CONFIG_PCI_IOV
> @@ -16,6 +18,10 @@ void xe_gt_sriov_pf_init_hw(struct xe_gt *gt);
>  void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid);
>  void xe_gt_sriov_pf_stop_prepare(struct xe_gt *gt);
>  void xe_gt_sriov_pf_restart(struct xe_gt *gt);
> +size_t xe_gt_sriov_pf_mmio_vf_size(struct xe_gt *gt, unsigned int vfid);
> +int xe_gt_sriov_pf_mmio_vf_save(struct xe_gt *gt, unsigned int vfid, void *buf, size_t size);
> +int xe_gt_sriov_pf_mmio_vf_restore(struct xe_gt *gt, unsigned int vfid,
> +				   const void *buf, size_t size);
>  #else
>  static inline int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
>  {


