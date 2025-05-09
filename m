Return-Path: <kvm+bounces-46023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E4AAB0C69
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 115C51892AC3
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 07:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C274727056F;
	Fri,  9 May 2025 07:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2BqrS3h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0B124418F
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746777358; cv=fail; b=i7YWjoI99zx/o/TvVITCyHGHNfOyMcuz8jG+BWX/ghLANravaBQNYlJPbvLCWke1nobBLKBPfD93bM7nM4fb8e2l94lSsJtPiR+0dC++7U90pswap++RcDSgzM9j4TWSzfOiR5Z9bTzYqQemkRK5NwWFutnugGGQjEwgELJiskg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746777358; c=relaxed/simple;
	bh=mh9aiLKgDMczB8gXk0XDUd28rcvLQt9NWGWYP/7IEaI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dnPJRPQbTP08s6RsLsngL6nl3WRzLxO67hysa3tSv0wHwJfKsyXGxhh4dO5TGbkbLT17dp2p6zeGjAqSlYnd/OIPhUxx0oWWtgdKxBgYdVcWQzlX+kuhvXukh1MNwyxeCBZU88zItlMbsTHrHEn08zRGBtXbeYjIUVsnBY5RlJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2BqrS3h; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746777356; x=1778313356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mh9aiLKgDMczB8gXk0XDUd28rcvLQt9NWGWYP/7IEaI=;
  b=Y2BqrS3hST/58hPZmAdDldy5zOemXIAkcoqV5QmJI5WRbfYNIfgqrVoV
   jLvBtwJb3cQbCnB+sUint8f5QqB7K6GfbzVOr9J4/c+hjT8krGjjHBTB3
   HZAu2HEWSGq2aODszWL8btV0ch2zmj82QV3xpPgSWgYl1UoegZJh5TxZy
   TnH9sJuRaQ2agFU1nTdIkjtMiZ+H3uxBPWzTxqOD0zImuEx7dWZ3Kb3vY
   Ve/3B6XkKqGPGU+aJVG2z7iTStjBom1nzm2kIy9Zv4rDTijRWEUL0hS7N
   XY+B4N4Om5dAug+1gCFsosz9uGtcGtp5tOU1t69O1YYqwOkGvh3hl6Pru
   w==;
X-CSE-ConnectionGUID: 9VlUsthsT2qeM5FMfNlN+w==
X-CSE-MsgGUID: VbQTz3FnT3yYU9VnutamIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="36222689"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="36222689"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 00:55:55 -0700
X-CSE-ConnectionGUID: ubt9EyDtQrKF1t+9aqVxbg==
X-CSE-MsgGUID: Tog5l2HgQbqeA2w4q7dzSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="167477146"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 00:55:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 00:55:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 00:55:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 00:55:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6umgi6ZEzyemu16yCrv5IOQBHBpJq7hwQVJTl05Dn100UgqTM6sencLgzg4xKmtH2M8Zg5JMpBHKCv1St4Nh7+h3ur78EDDbrv7WANYhsHTZ2oxNbU3pTx7BzME0j1FFwG4Vt7V1McYQBj5w2i67K3tlXzH5nue1PjHLB8dmbIIRbT7ZXTfpEfSA+cC7Omtsmwc3pVLYII9c+pqPoDb2z8C3hVmInluHidMLq+irmuvgpn7hs0r3AIoadU5fMBNyCHGGV3gw0fMD0kxZLgPoMfNCbUjpU7QjRnDrAj9Jeg/Uj6iEm2JuFXSYqZF7NxklCZJNFZmslq+ctUIJhoNcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKza2/zjwvNQkyfi7MlDs4wqdUNlKWrEwTh28rgzD54=;
 b=pViX56hVfCCevInsKqfFXY3y+hvSO7syFxa1k3z4i10H91/JPhvCdyoZAYbd612VnLlUbRKHhQWMDofEgPdnw9MlEn7UvN8t4jwmigYpzGtqSbFRJMlGHsHrA1ydfoevJqnwWgNfunzcmSPba2B/ztAP5UhNwQjxnGEq0A/LmtyEECRpkTVS4mTJEn9Y4xbaK3Tx9AtN+oEuE7Z8nKJm8ni4VmD0w/axejKMZ+CGZtV/jVxJ3oDf/fF2RlWyEpAjH/2NjDCaF4iP3b6ZvKGIqaQ5yKQDM/y1xLRPF8qbKqfR4f2YpO2OflOhCEIUQ0DvImRAU9AfiC/eOdj/qIpgag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.26; Fri, 9 May 2025 07:55:51 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8699.021; Fri, 9 May 2025
 07:55:50 +0000
Message-ID: <b547c5a7-5875-4d65-adea-0da870b4b1c2@intel.com>
Date: Fri, 9 May 2025 15:55:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
 <013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0019.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::10) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: f95ac909-5ac8-46fe-e734-08dd8eceea5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXBGaWo3ZmdPejJrN0lqVlJNc1VXRlN6VEUyMEpRbm1OcUx1bUpQRDh4ajVF?=
 =?utf-8?B?NGlVQ0VRcVJiSDRvNTVNNWNEWUF2QjFWZ3U0ekVaUlVqcHpSRnZDRlZscE5Q?=
 =?utf-8?B?NlVSN1hSN1RONmtWZlh0eldxM1V2NDdyakQ5dlhoOGlkZGt6am1peUtDcHp3?=
 =?utf-8?B?TDJXWWFLamJmU3M2NS9nQkUxaXpHRUNNMFY2SHNZNGZqR1lkVlRqNWZVQUJK?=
 =?utf-8?B?RFRNNlFSR2taaFNMUVFnQXEyVVZvTkUzZmpYWHZXTmN0bVE5RVh3emVYMWV0?=
 =?utf-8?B?SG9objdoZVV5cVNGSWRWWlh5V3JMWU5PMStieVJ3T0xKQW5DM2dIUWhXMEFG?=
 =?utf-8?B?S21STzNKazJMYkp4RTN3VzhtSzBkTnE3cW1xNzdsOHZJRTh3VkNaYXgzYmVU?=
 =?utf-8?B?R1VEQW5uRlJIa3VveFNhcUt6SmxhVDZTVWJ2MitCdzdxajlVNjc4c2M0VXZF?=
 =?utf-8?B?clR0S21rRytBOWNaTWhaS1JEclFOelFGS3dhakhmdTc2a0F3Qm04bGRySjFi?=
 =?utf-8?B?RURlQmtRWFNySHdsZVZEb2pmR24wcU04OS9qR0ZpU1NBVzUrdDZCMGtXNUNH?=
 =?utf-8?B?OFdEZWdBUlczMnZ5bHVidmhqeTFuc09UcGtVamh2VWJFa1E0a3MxblVocUE3?=
 =?utf-8?B?NnJkbGM3MTJmODNEWnFHczAwdWJLMFhTV29wb0FGdVkwTVc0ZmhyMWhvV2t0?=
 =?utf-8?B?YnphRVA2OXZpRTJwZ01uZ0FDeDBnQU9rMFJUdEtNT2gvTUE4SVRmaktoZDVD?=
 =?utf-8?B?ekxldnhQN01vd0o4YWZHUkZyUXZmM3FtYjEvbjlTRFVlVDQySXZoR21KOTBM?=
 =?utf-8?B?VURMTi9DZ05YU3ZnV0VuN0pGSlQ2RGdvYS90RVA3UWNSZE9RM1RJYm1PTm5R?=
 =?utf-8?B?cVg3VzAyVEIwNTBHZnpPbWNxNjBoNFVSejZLOFFDTDB0VVdLZE5DemR0YmdC?=
 =?utf-8?B?dGs4UExEeVAwVWwyOExMMEtVZElzaE91T2F6RXpNRmFicVBuNGpmSlZ5dFdM?=
 =?utf-8?B?bzB1dU5SYm1sNzRnaXJjS2xJTG9ySGxnTCtJZVc0cjRRYVVGR1FhY2lMc1FB?=
 =?utf-8?B?S0pXMFN0QXRLZU9TZUpIdTVMN255emI1eXd1VzR2a3dKUVR2Mms0RnFVRUpQ?=
 =?utf-8?B?QkxWM2xvdnErbGxydVhseFVkeTlsUVRiWHJ2N0pzUytKRmZtRm1ha09lQ1ZV?=
 =?utf-8?B?WUZ4Ykh2Z2hKR2UxcWJhbTRHeWE3UVJhaVNQT3E3QVBlejNkWklOOERzaE1X?=
 =?utf-8?B?emN5R0VESFU3NzlFc0RrdW81RGVqK3BjN1BnZEtsMHBYVlBiZzZWOUdiWHk5?=
 =?utf-8?B?N2JEV25vc2ZPbWJIMUZ5NjA4UDVleXJXMXB3VFVobGNiQ3kwNGtrNmQ1NEtk?=
 =?utf-8?B?bGN3VWYrL05jeU5GM3ZJa2tid0pqQlRnVWpuZXFpNWswaWkrSEg0cG1SZW0z?=
 =?utf-8?B?Zm1hTWw5ZWtydzZxREkySUQrUzM5K0xHcTF2WEZBcWFFb3dncThvZGFqa09S?=
 =?utf-8?B?cmxGUlRUWFJRVncxVzZGYXgvYnp0MHEwSkNobDRmaG03N2tiOU5BVFZoUG1N?=
 =?utf-8?B?YU8vSVUxbEZPTjZaQm1GUExhM2pqb0VCUkhJeUovL29KaWVXMG4xZU5xcGM4?=
 =?utf-8?B?TWJNbzVFN0VFNFM3eEZTdWU1eFRXdUhrRGtQT0NuTnExSEQzU09YMVhqbU1D?=
 =?utf-8?B?VHFPdDFFR2hpT3psTndKNzJiRlhXQnlDL2lKY05TbUYwbk5meUNKd3VpZzdY?=
 =?utf-8?B?SnlOZXhRNmJjeEt2LzVJQ2dkd1ZCcWg4SmsvU0JlWnRmL2J2a0xKWVhmVG9l?=
 =?utf-8?B?cG5JNk5NRGd5M21Idm5SSmxWRjZrZEFrZTJFemkvaWZMMXdBV25lQXR4elli?=
 =?utf-8?B?ODJVMk1qRURBcWNiSHJxSVRTTlBzLzFUMGdTNzhISjlEMi9paUl4ZjhyRHBO?=
 =?utf-8?Q?mB7hRDcDGhs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnkxbzRQOUpGcWw2SmY0LzlUTTB4SFUyL3FrbHVIZC9XWW1YNSt0OXhsaTVE?=
 =?utf-8?B?a21vNE1mMGU1dzdTakFRSzNIcE1VVjB1aER4czlSSkl0dmM4K3hsaUVKcm9M?=
 =?utf-8?B?L0R1SDFlL29rTUN2cEdyTTJxMWdzNEVVVWJoMXJEM2ZqQ3R4VmVzQld4Zlg1?=
 =?utf-8?B?dXhxOGlFaGtVTVdJUlZhdnY1dU9yM2RKZTNKQ3l2YzZJSmNyMWI2VW1uZE1i?=
 =?utf-8?B?Wm5WY3BCNTNxeGtJU3VtYTBaS2xaeGpHVnVEYjZ2WFNxcnFpZ0xPV21ySjhW?=
 =?utf-8?B?bUJRVXNOaWFCWTlTZ3M5Y1Q3bUN5Y1FKWXNlSitTdzluMFRRUzgrY3FuSFE5?=
 =?utf-8?B?ZTdPekQwTTFMWlduWGtiSE5FWHErMklkUUlkQnFkdXA5RnRtMTR2QzM1UFRm?=
 =?utf-8?B?emJRZ2NtUkh6RWlxbTRkTFZaTEtXUmZjVUd1YUN6a293bFhqa3ZhUlNjT2o0?=
 =?utf-8?B?Y1pqazgzYW41b0k0T1JFYVVsTUlEckpvWWFWUFFzcDh5VFdINER4a1pJdHhV?=
 =?utf-8?B?ektaUUxyak9JMTZZOGt6UTlGY1NYNzBZa3hGVExML1p3ZHloUWVCenB3NVFj?=
 =?utf-8?B?MGgxK1JvS2d3bjE3a0xUSTlpVGNrTC9XOFJ2R2ZjLzVLT0NLNUN1M3IvemJs?=
 =?utf-8?B?STR2RmlEVE9hNHk1WWtyODQwN0VPZkxvd2doUDNnM1JnN1FGcGFxWkJIUjBY?=
 =?utf-8?B?cmdPQllWWlVUTFY0bDVGVzhtcVMzaDlqdHIxdjFBUjRVcHRQTFNiY05rUGVJ?=
 =?utf-8?B?N2JnQi80WTI4RTVYYnpGK1JWQzVrVHZEU3gzajB5czlDM21HNnhkQXFoOGw2?=
 =?utf-8?B?ZVdPNXNySGYxY3d3WDZ1bm5Nc2REOHdOZFNOUlh4bXVqVGNKYUFJaGFKeGNy?=
 =?utf-8?B?akgrYWpSVzlZbVRNZGNUNFdMSW03eW9OcDBtcVVZM2pJK05QclZSZkhmZTVo?=
 =?utf-8?B?Z2NTQjFWQmxlV2ZKNmRtc3ltcVV3WTMzclVQMkNCRlVVNEpJNTF4RXdTK2Jz?=
 =?utf-8?B?UHdxVXpTeGFLd2E4VTBOS01OMkZ1M3dTcjFBVU8vMnhiTVUxVU5EdFd5MDlp?=
 =?utf-8?B?cXp3YndFa015UFdOcUVRWFR3Y2o0WlVxYWNGQWxzSy85cEVzN3RCcE4rTUR2?=
 =?utf-8?B?Y3pTQnFFM0FrWmgxbGRMV0xabHU5ODJNc0RYQXpUNDlWcmY1Q1Rzcytnb1V5?=
 =?utf-8?B?SFRMQkVQNVdYT1Fyb2ZxSTloUlcyanlKcjBzKzBMTUdGZ1NHVUF0Unh2VFNY?=
 =?utf-8?B?OU1qeUlGM0lSQmNxb0o1WDkxN2wyVEd0NkpiQU5UemdpQStqNnhoUUJ5ZHlK?=
 =?utf-8?B?dU5mYWplVllOZW0rcHJRWXZ4SG5hTEEvc3BCNjErMjQ1VnJHbC82WVZWMlFQ?=
 =?utf-8?B?NVQ4aXd5ZWhNME5SQnQ4T2d2NCtJMnJEUWhpSnpUdXVYWVdnWm11WXNVdStB?=
 =?utf-8?B?TE52aWlVbzROcEpoSysrOThhSTRSWnJPTEZOT1RiTlpSN2trWEhWU1FZRjVy?=
 =?utf-8?B?RHJFSlpvVWdkUFZHTk1qd1BjeXFDL2JSdnRQNzVpakNleTFNRWRyQmtOZkI4?=
 =?utf-8?B?ekJEZGl2MGptd3prOTRHU2pEdkRTWFkzUHk5OW9kVXEvTzFHM2JVcS9XWlgr?=
 =?utf-8?B?TS9ZOGFqYU9KZSszUGcwZWhXNFgxcjhacXJvR0l2TStLQm5Gem9JeENsWk1S?=
 =?utf-8?B?N211NWZxelNnZUx4NVAwa3Q0anNSZ0l4cjBBem16aTFnQlFnaE8zc3hvU01k?=
 =?utf-8?B?bVB5WXNsVTFtdmdvcGpvbDNaSDJuRThuR2E3MmJFMGNzN1lPS0JaTEkzYllN?=
 =?utf-8?B?V2NLS1kybHZiZEI4L1hKNzJOQkRUU2daV3ZselViUVFZOWNzR0ljT01SZEI0?=
 =?utf-8?B?ZTJGajZZcjMya3A1c0kwbkFBaWtWcjQwbnR2Zzh5dG1tRjNYQjdObHRaYklk?=
 =?utf-8?B?am9La2lZTkFIQkptWTErUXBNeFVuZm1JajBBdEJnNjRhQy94Yk9EdzBiNklL?=
 =?utf-8?B?a0pYZm9nTWp0dnpBOXpaejlIMGZwZXdaeUFpdEJSNjdVSWdkRHVGcGYvWEFU?=
 =?utf-8?B?TkMxUzFvaVFzSWFLMTZoM2djTGRkNE5aeDNCMW0rQlp5ZWZocjZzRGpMQ1RY?=
 =?utf-8?B?UUY0c28wSEJZZ1JHTkRKMGFqNXc5MU82VUJLM1lMUlJXS1c3YmVSQ0JGTGFt?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f95ac909-5ac8-46fe-e734-08dd8eceea5d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 07:55:50.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZ1JWGt3gMNGU6Af9ReX16r1IbADFhF9mftHm9NWajRNS8XAdDw7xoPppadAL0xjl02j2xKhlgbr+eVWRDU5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

Thanks Baolu for your review!

On 5/9/2025 2:41 PM, Baolu Lu wrote:
> On 4/7/25 15:49, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this, it is crucial to
>> ensure systems like VFIO refresh its IOMMU mappings.
>>
>> PrivateSharedManager is introduced to manage private and shared states in
>> confidential VMs, similar to RamDiscardManager, which supports
>> coordinated RAM discard in VFIO. Integrating PrivateSharedManager with
>> guest_memfd can facilitate the adjustment of VFIO mappings in response
>> to page conversion events.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> PrivateSharedManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttribute to implement the RamDiscardManager interface. This
>> object stores guest_memfd information such as shared_bitmap, and handles
>> page conversion notification. The memory state is tracked at the host
>> page size granularity, as the minimum memory conversion size can be one
>> page per request. Additionally, VFIO expects the DMA mapping for a
>> specific iova to be mapped and unmapped with the same granularity.
>> Confidential VMs may perform partial conversions, such as conversions on
>> small regions within larger regions. To prevent invalid cases and until
>> cut_mapping operation support is available, all operations are performed
>> with 4K granularity.
> 
> Just for your information, IOMMUFD plans to introduce the support for
> cut operation. The kickoff patch series is under discussion here:
> 
> https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-
> iommu_pt_jgg@nvidia.com/

Thanks for this info. Just find the new version comes out.

> 
> This new cut support is expected to be exclusive to IOMMUFD and not
> directly available in the VFIO container context. The VFIO uAPI for map/
> unmap is being superseded by IOMMUFD, and all new features will only be
> available in IOMMUFD.

Yeah. I would suggest the test step to use iommufd in my cover letter
since this is the direction.

> 
>>
>> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>
> 
> <...>
> 
>> +
>> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion
>> *mr)
>> +{
>> +    uint64_t shared_bitmap_size;
>> +    const int block_size  = qemu_real_host_page_size();
>> +    int ret;
>> +
>> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +
>> +    attr->mr = mr;
>> +    ret = memory_region_set_generic_state_manager(mr,
>> GENERIC_STATE_MANAGER(attr));
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    attr->shared_bitmap_size = shared_bitmap_size;
>> +    attr->shared_bitmap = bitmap_new(shared_bitmap_size);
> 
> Above introduces a bitmap to track the private/shared state of each 4KB
> page. While functional, for large RAM blocks managed by guest_memfd,
> this could lead to significant memory consumption.
> 
> Have you considered an alternative like a Maple Tree or a generic
> interval tree? Both are often more memory-efficient for tracking ranges
> of contiguous states.

Maybe not necessary. The memory overhead is 1 bit per page
(1/(4096*8)=0.003%). I think it is not too much.

> 
>> +
>> +    return ret;
>> +}
>> +
>> +void ram_block_attribute_unrealize(RamBlockAttribute *attr)
>> +{
>> +    g_free(attr->shared_bitmap);
>> +    memory_region_set_generic_state_manager(attr->mr, NULL);
>> +}
> 
> Thanks,
> baolu


