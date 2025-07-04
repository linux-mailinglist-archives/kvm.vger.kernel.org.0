Return-Path: <kvm+bounces-51541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D72C2AF875A
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 07:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6861793EC
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 05:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50E12066CF;
	Fri,  4 Jul 2025 05:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8izv3lo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746F45464E;
	Fri,  4 Jul 2025 05:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751607502; cv=fail; b=VnIIDjYxJZNH6Gf+ZyJX2dpv8XGvwzMKVJtaLd30jrGgKl9G98CYekfEno//wmStgBHoclsWfXPOAcqrIu0WQlqg2nvR5faWmqWErT90e6FtZZVdO2lQrrJul0hxEPyzK81iE9RM76spd5leKs+dJ/J0rOXCK+JCQYNkO8Si0Y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751607502; c=relaxed/simple;
	bh=BRPVbQq78r3G6MO0eSgRuBF0+qMjOUrJjfmHU2MSG+E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D7vtYUSolQXXIYMZU5m5YVi0qMBJonJS1z6JYPM/lY/A57dVuxpyrNrgBJi8T1QXV9IPbjRhumK5aUPm1Piy0ZHu/RMPfJk+xpKb0Ec7oiDHrr/FpEDD30bDXN8VzV+9BmhlzMIZpfiJ+FtAS0yjDVjLBV+rAKkU0nURhQjvLWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8izv3lo; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751607500; x=1783143500;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BRPVbQq78r3G6MO0eSgRuBF0+qMjOUrJjfmHU2MSG+E=;
  b=c8izv3loLkM4VHUS1/btlBOV0xytC6rPIvoNm6PZmh4wHhx0Cs1PAFfA
   oEciuVXxwCbw6gZufR73NK7R4cItE33u1LG94VXcKrrKhnUw95xWS9opT
   Xu0b1SsoJajr6JasIan4r2fnLiXf9bjyo5Qd85T1YGd8Eu678Dj9SngMk
   jxewxLTGECVTqPbjzBvjHyP+IOUUomn4r5xUAWdyECg9omh5XqGO/05rz
   /VFmrkvKSmRkJbpUeS7OpU0cpDHRipCrLSMXd4zWZuSGBuAw49Ugljfd7
   h/7aPDLq7+i7pMjzWhJOjmBJWp8oLzkQp6yZDdxcK6ISAj4UOh8rnDXtX
   g==;
X-CSE-ConnectionGUID: jNFgLUEzRXOHJ2Z8F7Ru5w==
X-CSE-MsgGUID: nEOMmJFoRTykRKjVC9ajpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="64632882"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="64632882"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 22:38:11 -0700
X-CSE-ConnectionGUID: PuqiLzh/R0iy+zxmQdFyow==
X-CSE-MsgGUID: gC4bTtKoQp2vW/CRwVbphg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="158902215"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 22:38:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 22:38:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 22:38:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 22:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOKIK/mHd6yFuW2H3NYG2lLNmA9PppJJc7k4cYEjF+l/GD0MRoX0kyHRxDGjb3rjWAAeBV6OqcYyjBl9s/ljsdOdugpRFuKCSYyeK7pymcXVfZTDunRuSXlvODPbhEy3Hl52JyEIYDADLwD1sZNZsAtezWnFFU7XRC55JF407kOP1EarFDQGOhKv+OsEPvECg25bPzkNIOQN+Zs80Po3RhL0k5+4K1f53+5i05d1ZfbluJ2vg4TBm6h4piIuPWvfv22Z3cHBTGXOBZA15ftRTYBArfXaVNDnTeqAM37Zya+iiQkBZi045aYede7p66PReBvpVGQqOfn3VxabmUJ23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saYAu0uZ63nS3c56hvMf+svZWbjgGUk1tR4WcKNSnw4=;
 b=l1z8d+YKks18Sod6M58+YYBYUiCjr4oSd5eo1ybOtyUhdny2YOkKZRt7p2VJqhYbeIfDxmtX0jAXGK3QmXEB49x4KRzPlfvrfURd5EdSOxGZ72W8K1lGLCHwro5caa+OIy2uYKkVqIhYtkoVlRUc2H+mHLAz9brW5aYmcqUBXIszoklCgixggqwYZuMKVK9tSSRCsRtDtT8uFtG6vIOsrm2WXyHJnLsU+CVWm7nV8DcCMyNSkxpmDRLOWHQC2P+26TJ0+1K01pjy9yBHSObgiFhBn5hKg5Obqz4RWhgezx5U4n0hRomiDJsz440lbf2h15zwg0gtb2/MPZe+pWxpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by DM4PR11MB6383.namprd11.prod.outlook.com (2603:10b6:8:bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 4 Jul
 2025 05:38:02 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8901.018; Fri, 4 Jul 2025
 05:38:02 +0000
Message-ID: <2e444491-f296-4fa4-9221-036f9b010c1d@intel.com>
Date: Fri, 4 Jul 2025 08:37:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Vishal Annapurve <vannapurve@google.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov
	<bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
 <CAGtprH8boLi3PjXqU=bXA8th0s7=XE4gtFL+6wmmGaRqWQvAMw@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH8boLi3PjXqU=bXA8th0s7=XE4gtFL+6wmmGaRqWQvAMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU6P191CA0063.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53e::19) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|DM4PR11MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 192eb06f-5ddd-46cf-0a39-08ddbabcf135
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWpwSEFzVjJWTm54ekEwazlISkVSQUJTYTBvVGZpVWwxWDZlZlk3SUQ4UUJJ?=
 =?utf-8?B?SlduUTJSWVFWbUcyVmdNY2xYMjJKNXlhRWw0NlFhZ3lJWjUxNUJYSlRMY3RW?=
 =?utf-8?B?OXJuRlpKTk9sekhjYlByd3N1QU1hcWY2aG1zNDM1WnZGMDQ2ZWxEcGFUSUU1?=
 =?utf-8?B?RnVETC9WOUVPUG1VOTZxeTZyVnY1RFl1eDJDSmpFQmk0eVVaNWUrWE1JUTZz?=
 =?utf-8?B?UVduMi8zNkZjcVprL1NDZld2Z1VTVXR0YmNPb1JPR1ZHVTBxTkRMTWFOMENs?=
 =?utf-8?B?M3o4R2tkU2xLcGFzVWM2L3lCcDZoUEFsblh4V2xMeEtQcktlNHc4bVpJQmZ5?=
 =?utf-8?B?Rnc0SnA1TVFWa1B0dWF5YTlqWFNWc1FqRlQ0SmZjSGVNQUdlWmFxTGozMi9j?=
 =?utf-8?B?NGhvRDdpczFkZHBpRVhyUGVCamtMUS9LZTFQRjFSSjBaWWZ5eDZlM3p3NXBl?=
 =?utf-8?B?eWQzaVdTejNGT0xOaElOdDVCTjE1TUZhcnp2Nm0vUEQ5UEt5WG1XOFVyVFZJ?=
 =?utf-8?B?MC84UmdtLzhCc2FrcHYrUW9NTit2WHN3MDF1Zk44aGYrcGloYjk1NmNrbmZG?=
 =?utf-8?B?QUhSZDRyU1BJS2tzZ2pCTDY5N0lDVlZHcXY4U05SLzZ5TFBMOFM1SUU0VE9M?=
 =?utf-8?B?YnVKVTduQk5rUEtVSHZDMERQVURFREswcllhRjlQRTVkZlRRV2pKU2NkdGNH?=
 =?utf-8?B?SDY1K3QyZmtzMGttZE94bjlVUVZrVGg0enJXL3ZMZ2NDQWFZVk0zQW9LMENI?=
 =?utf-8?B?cGNhOEZXWjk2TWY0d3BDY00rUG0ycThZTnV3MzBUQ20zMnlURFlVYU1mZkNn?=
 =?utf-8?B?eWx4MFV1ZDNnbWtLMzZhQVZpNm53UnpoU1FLN0N6ZFdINGp3T3NSZUJGQzR4?=
 =?utf-8?B?SzJCZ2wrdFZ6b1E1TWtLZ0p3dEZBRHJoQkZHdXk1RmlGWllZSWxYQnJhSXQy?=
 =?utf-8?B?dkZrNzVhczJsbDRONGRKb1Z2Z2NSaUlCSHJtWUpFdGhTc0F0VVlJRlA3Ykgw?=
 =?utf-8?B?VEIzKzYycTYxM3pENkcwSSszQmRRdnFza2tMOHFKNnlsdHhCWmZuQjhGMXFn?=
 =?utf-8?B?SDhkbC8wY1R3UExWKzQ1cXdOMTJjZHlmR1B2Sm5HRUs2VDhFUW5JQWVwV0tw?=
 =?utf-8?B?dk02VkZQVFRXemVOcFZJUzlUOWN3V2dDeFVwLzhUaml1NkQwUUNQT1UwUWtX?=
 =?utf-8?B?a0QwYmJhRUdxSWxRNHZQdG1vZ2dEU05LZ3BKZUJjN1N0V2w4Yk1qMDBTM3JZ?=
 =?utf-8?B?Z3VOWnhYL1FETkQ5ZGptcmJKNzlOVVBlYVFhWFVIczhhQ3RscVZDc0JURGty?=
 =?utf-8?B?bTc4eFVnd1huMGhqRHBCZnZZa1VGT2lnV2h4RFB6NUpDUXF3NG83bEE5NG1n?=
 =?utf-8?B?b29zU3B2REw3SDlFZVA0S1JJVTVnSUQ2cHVOQUUxc0lMM21mRXUrSkMyb2FX?=
 =?utf-8?B?MDJsYVJIQ1VxTEI5VVV4N2FMdlpaSUNpTkgxdE5iUG9ST0YvbzZKbkFqMGFK?=
 =?utf-8?B?YVFzUDF6R05HSks5UWNGT1JpU3k0ZFNsY0xtMjFZS2FJc1hObFZzUGNWOUty?=
 =?utf-8?B?S3hEVHIrbUJ6L01BSHhXLzZlSnhST3NRRkFpQlNEa3A5bzNQTmJlRE81WFFL?=
 =?utf-8?B?UFBuckl6Mis2UU8vV0YvZHE2Nlhlejl5aXB5ZnJQeUV1eTU2YWV2WG1TYkg3?=
 =?utf-8?B?cXNEOGZtd2lKQ0dTR3VnbjIxTWlRUjdQU0x6U3hlZDc0R2FmT1lNOVVzQVI5?=
 =?utf-8?B?dE96M3hBMEZQQmgvMmNEZVB4Z01ncG01dTh0MFlhdVc2S0kxN0pSTTFrMTdB?=
 =?utf-8?B?amJjZS9xUW9xQWx3OFh3SmlOWEZWcHo1Y1BrenZLYk4xVjZOSjhtb1JUUEwv?=
 =?utf-8?B?WkdyOTdwUUpLb1NZRCtxdmZ5MDBybU1yS0tjdWZLWElnQzRSZll6c3dvY2FB?=
 =?utf-8?Q?j5KZUpcJb0U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z09PVXQxUFlnMVd5Z3NSdTlBUG9XdmlNb2pvZ2hZb2JCRVJxWTBBRGdGenlW?=
 =?utf-8?B?T2VZU0tiRFNpOEhzUEdySll4QXVWaS9VSGZheFBpNWdNaUlhV0VVM1U1b0Zw?=
 =?utf-8?B?aU5mSzNMTDh0WGpLS2M4YkFhS3UwQXJUZnhxV0w0cE9IbjZENlNzRlhRWGV5?=
 =?utf-8?B?bmhZMWp3b2Z5SGFBUGQ5Tjd2dEttekxPQURBbWY1YklKS3Rvd0VickFzVy9y?=
 =?utf-8?B?NFdGTWsyd3lqM1RUWEUveEw5cVNFT05SWGNzU000aS81TTlzZ1ozYUpqT2tN?=
 =?utf-8?B?OEtkeWF2UFlFd0hrY3NXSTZMZ2FJUG84Mm1aTGYzSVJ3bDdMR3B3YXZGRWYw?=
 =?utf-8?B?MjZTOG9QekdMUktRaHlWY0twQzUra3h0cTh3NkNjbWcydjlIdEY4eThqY1Nm?=
 =?utf-8?B?SVJVY1hYc0tyQ1gzTkVwQ3AwelBWT2sxQ3BmUjRKRVB2M0twUWtUVktiQm9D?=
 =?utf-8?B?U3k3TVpWZVBjdWk4RE9sRGtKV2FWQWJ1bVRDTEJGMFVEWkVoczNIbys3L082?=
 =?utf-8?B?anZKOHpRSmF2bk1xVUxBMU5Fc0drQ0I0enlTbGN2eFh0d25hdWxuZXRHYytv?=
 =?utf-8?B?L3V2bms4ZURoSVNtalhHMmRmSDZwa2tBSkdPNDBoY0xXSy9YMEFlMVV2L0dx?=
 =?utf-8?B?QUIvS3ViNW5pb0IydStnQ1B1RjcwbWJwaEhsZUZVSHlsTWc4dHVDVk90Y1lG?=
 =?utf-8?B?UlZ5a2NPUHJtT3Mvc01UY1FIRHRrRW1reUpJY1ljaXllTitZaU4rUy92ak9n?=
 =?utf-8?B?TkhwbmxSWVk5QXdUNHN4TGNwRWJPRVhUU2hIczRIOFJ2NE1qUEtITG9SN0Zk?=
 =?utf-8?B?RnEzVHJTRURxbE9SdEduMlFudUk2RktiREpsdzVwWjk2T1hOZEtlUTBRZGFL?=
 =?utf-8?B?OHJXQk1OWFlET2trWUloVWVob1A5ejFFdjJOaDBLOERiM0d2bXk2S0tBUnhS?=
 =?utf-8?B?d2drTm1wQnhEdjVkWWFKMXZwalp6UDdSWEJaMnBDM2I4UUVDL1JRWm91cmZ5?=
 =?utf-8?B?UzNRNDNpNlhFdTdPMTFlSmVCdlkrdzVLVnNnZUE0VS9Rd00yQ0Njdm1Ud015?=
 =?utf-8?B?Mlo1ems5bmovNSsyWHVrUWxrYXlkK1Nxc08xcy9sM2w2bzZQaHl1Zlg1Ykov?=
 =?utf-8?B?Z3pZUnZJUW5Pdm9FMDRobUNXTHpRSSsvaXBqN0pmMmN4Z3loMnQ1VG1NaGh0?=
 =?utf-8?B?ODNIeXZEWnRma0dMNndZdzAzc282TGFNdUlWRzl3bWJaais5L09kUmhBUUpx?=
 =?utf-8?B?MmFJeXdYbldSblExTHZNL1VaZTVGdDZqQndkWEZ0UXA4VzBLTFB0cGx3ZzM2?=
 =?utf-8?B?UzI2Y2phOXhzdStvWWU2TmFFSFl6ZDFSRWlhN2ZWcHBaUlp2MDQ2MThqS3dt?=
 =?utf-8?B?QW5nZWZKODdEOFpYbmk4a0pBa0xPdDZsckFLeUpGNXVpL1cwNUVsRGNJT1ZR?=
 =?utf-8?B?d3ZmWkt0SjI1Y2U1ZHYvQURKTFRQRzNWWHRBQjlXQ0p1dXhBRlhSY3R3RHZm?=
 =?utf-8?B?dkYvL1NZdVhJc0Rud21LQWNVczJYNkdDSUR1K0hWRDA2YzVEMWV6R2JLVllR?=
 =?utf-8?B?TEpIZGx2RFlMcUFSODFFTk9RY0FPcTdkZHFMQWtDVXlXSEFDOHNlU05xWUJH?=
 =?utf-8?B?ZFozWGlXVXdLeCtuVDg3aUMxUkpiVS9PdTA0ZUNpYnA1VHhHQ2llV0FjUm9R?=
 =?utf-8?B?bm1ETnhPT1gyR0ZLNkMzQVhWaXVkMS9DY2cvSUZqRCsrY25NVFlqWFN4Q0g5?=
 =?utf-8?B?dXFnK0FzSlIrSGZiYXBmNFFQdkpNaTBBTmdFVC9VdE5DdWgrcDhveVdRVGtq?=
 =?utf-8?B?NHo2NEtLbjJhMGtLN09CWW9tMDcyMlRpcExVdUJESzRwd0Z2NDU1RDM1dXF1?=
 =?utf-8?B?V1Z0WWx1dmJRMXpudzFrQkV6MzRFSyswT3pvOUZKY01JQVY2VlFPN3UwT1FE?=
 =?utf-8?B?SFNDMEx2SzRNMWpMNXJOSVJqNTUvU0RzZ0JjcDFxLzdhdDdvQTliU3RLWFhm?=
 =?utf-8?B?dFdaOFlLcUpkYWxMWE5LT3Y2emhhNHNGU1ZQZkVlRGFWOWNjTHZ5MTBQclNu?=
 =?utf-8?B?QlhEK05uTFEzTCtVK0g0cmI1NWhBK2ZESjdCc3dHS0pJUGlVOTN0blV5RnBB?=
 =?utf-8?B?Ni9HdlZvRjR0QWlzRkFmSTA4ZittaGxCWElXRmRtbEZuWUEzWWhnbVcvT3RP?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 192eb06f-5ddd-46cf-0a39-08ddbabcf135
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 05:38:02.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsRW14gWwSmGSUkgqmZrYhqfbskLVmMQucKZUXb8E9pHrifgHqPiJNyUaw4tlgASgOx1iUJH8GK3Q2hCwbtx5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6383
X-OriginatorOrg: intel.com

On 03/07/2025 20:06, Vishal Annapurve wrote:
> On Thu, Jul 3, 2025 at 8:37 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> Avoid clearing reclaimed TDX private pages unless the platform is affected
>> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
>> time on unaffected systems.
>>
>> Background
>>
>> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
>>
>>    - Clears the TD Owner bit (which identifies TDX private memory) and
>>      integrity metadata without triggering integrity violations.
>>    - Clears poison from cache lines without consuming it, avoiding MCEs on
>>      access (refer TDX Module Base spec. 16.5. Handling Machine Check
>>      Events during Guest TD Operation).
>>
>> The TDX module also uses MOVDIR64B to initialize private pages before use.
>> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
>> However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
>> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
>>
>> In contrast, when private pages are reclaimed, the TDX Module handles
>> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
>>
>> Problem
>>
>> Clearing all private pages during VM shutdown is costly. For guests
>> with a large amount of memory it can take minutes.
>>
>> Solution
>>
>> TDX Module Base Architecture spec. documents that private pages reclaimed
>> from a TD should be initialized using MOVDIR64B, in order to avoid
>> integrity violation or TD bit mismatch detection when later being read
>> using a shared HKID, refer April 2025 spec. "Page Initialization" in
>> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
>> Initialization by the Host VMM"
>>
>> That is an overstatement and will be clarified in coming versions of the
>> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
>> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
>> Mode" in the same spec, there is no issue accessing such reclaimed pages
>> using a shared key that does not have integrity enabled. Linux always uses
>> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
>> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
>> description in "Intel Architecture Memory Encryption Technologies" spec
>> version 1.6 April 2025. So there is no need to clear pages to avoid
>> integrity violations.
>>
>> There remains a risk of poison consumption. However, in the context of
>> TDX, it is expected that there would be a machine check associated with the
>> original poisoning. On some platforms that results in a panic. However
>> platforms may support "SEAM_NR" Machine Check capability, in which case
>> Linux machine check handler marks the page as poisoned, which prevents it
>> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
>> Implement recovery for errors in TDX/SEAM non-root mode")
>>
>> Improvement
>>
>> By skipping the clearing step on unaffected platforms, shutdown time
>> can improve by up to 40%.
> 
> This patch looks good to me.
> 
> I would like to raise a related topic, is there any requirement for
> zeroing pages on conversion from private to shared before
> userspace/guest faults in the gpa ranges as shared?

For TDX, clearing must still be done for platforms with the
partial-write errata (SPR and EMR).

> 
> If the answer is no for all CoCo architectures then guest_memfd can
> simply just zero pages on allocation for all it's users and not worry
> about zeroing later.

In fact TDX does not need private pages to be zeroed on allocation
because the TDX Module always does that.


