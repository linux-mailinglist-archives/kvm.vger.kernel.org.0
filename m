Return-Path: <kvm+bounces-40690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF64CA59EB7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 18:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71C511645A7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D0C230BD4;
	Mon, 10 Mar 2025 17:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HwGWmr5i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36D922E407;
	Mon, 10 Mar 2025 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628009; cv=fail; b=bgVTZeXrsPZ613a7D2hHJIXZljrEpu5ycaMGxVdktHlErbs97oBlEjHnQkmthii2CvU0or8BxTV9V1ZiFb3Sq69P0hkx4FxmLUBxW+JZVvCFfoS/JahMBCD62IUtwUeKmbHzqF+isLOe3MsaRE6AmIBmUU7BORnxPUUd4WifM7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628009; c=relaxed/simple;
	bh=TgRcgO2mXGsBRaWD6PLAHXeguyyPv0S/7qCWlD4ssOU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oHlbzq0jEsGpYUe2+/ylJGL2HWfQ974yHoWfXZAKDrNisTXhlqixE1kgK/hRYSlLW7eYiE7FDlhstxTit1vWlpoLjTSfT1KjrQFGtzAvsL0kaEJGKosr2Z7FlX+uK9fYRITCRCJxAWFTubgjNQax5bq2h28ZEEKA1El2fT82SXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HwGWmr5i; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741628008; x=1773164008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TgRcgO2mXGsBRaWD6PLAHXeguyyPv0S/7qCWlD4ssOU=;
  b=HwGWmr5icmSE+b7FHDBSSI6n4CY93HBzVARW5p3u6HYIRHoxpj8UI80v
   VY5U0dn8NvTw25wLBP3CHQBpgX6wzcz0HjPXZ7r0rTIHEzeGX6sfAX2EO
   WhHm4O9+9IwO6WhFjV7gVcmIbXvQ6mnSt1xZVVV9P8EiqMjG+7IDt1MV/
   hThPtoth3ADh6eAug2fu44Yx7rQUdezCQ+4hmFBMWQacxGb+JvUFZRXfY
   hM2DNLAdBMD1jl+8M9kr50ug4lAxLcKPjhatxReov+bPOBXgc8Yxll4tY
   1c7EgfW9mYyMwq3aUJu7HFQsrzzXpztg2F2oPeZU61S67ce599eCfmRkF
   w==;
X-CSE-ConnectionGUID: vY3NU78tTE66MWf6kC5jig==
X-CSE-MsgGUID: CzzMhWtcSqy5kJd0FmWkEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="41803701"
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="41803701"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 10:33:27 -0700
X-CSE-ConnectionGUID: 3yi9tdo8RrKM+bKyHh6Hcw==
X-CSE-MsgGUID: xEYFsWCJTFOc4UyFkjJY8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="119890014"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2025 10:33:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Mar 2025 10:33:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 10 Mar 2025 10:33:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 10:33:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jatQtl+ZXJATJCG7sflG6zI2jg74VSe6Fof+bLp8upZ3BxQ5swJVAz0zVwC2FfeuSMXUn0DLEpi+XXDzHASQiX4Zn+I/cS11w/PMj02IE0lWhZ3ZEX4PoOCTlE7ZzQUWrNff2enqHEVOkpAE7jipTRoVX+ZO5iOHoVxWybCNh3lLj8GXi654A5CjnmWKEc53QdJ9dR1j29gp4Iq6K0tHYV9SIdxmxXaenuPrGQU+aiJDb3gWEOpntV+MSIIS8i9VsLhGEJfoT1cBplObePdFmNZUJPDjhS+kOVToKZWBfyN94noxz4mGrPayM0MyCyM/XKaJYaYXuuFEUu4Ilw2pbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktjz3SnAR8bJd7sDCn7cTblPX7O3mODLORaFves++BM=;
 b=f1fAi4EJaW7/vrqRV7DNrwmlMrhDvo1t7KzLAHs6hnDMsSXSUptEZKMeVoIUTvhuaZRWSR5uExsh1H7pj3FQJf0xvXAHkGrN2/Ql2dmx3dgpjJOlRjRbKAy217J9VnRcgPsM4beYG5IC5yMuPe6f/NGNDPi3oup+2QHh1i8lrcRbPldX0Pws32sjhnHMywp3W3eF7GWoTaabN0Oi0JNDvPCI8VNbRsI2qNG4RnXnD1RjaWIMKGBLib+kgW58bIo8ynbxpgZHjdA4WfGUppDuQ5+BFe7OlF0tTSpLg+nhhssP42OLnZ/4biqe2tpIwQzbgmgDvRL+d+FHunC5Xa/IhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19)
 by PH7PR11MB8012.namprd11.prod.outlook.com (2603:10b6:510:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 17:33:24 +0000
Received: from IA1PR11MB7917.namprd11.prod.outlook.com
 ([fe80::c689:71de:da2e:2d3]) by IA1PR11MB7917.namprd11.prod.outlook.com
 ([fe80::c689:71de:da2e:2d3%4]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 17:33:24 +0000
Message-ID: <b624a831-0c91-4e89-8183-a9a1ea569e6c@intel.com>
Date: Mon, 10 Mar 2025 10:33:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com> <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com> <Z85BdZC/tlMRxhwr@intel.com>
 <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com> <Z86PgkOXRfNFkoBX@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z86PgkOXRfNFkoBX@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0056.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::31) To IA1PR11MB7917.namprd11.prod.outlook.com
 (2603:10b6:208:3fe::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7917:EE_|PH7PR11MB8012:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d26fd95-48e0-40d4-7b04-08dd5ff9a89f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTFPZE1tb1ZoSnZ0Q0pGbmtOTGZKbXpVWHhxVUlXNnhPNUI4THhlcVVpSkc0?=
 =?utf-8?B?Z21tREZpVUROUzk5NlZIV2NueXNqY2V2SzJkTEJjUHRYSTBTc09STUlpMFdI?=
 =?utf-8?B?cHRKcFo3NHd3ZkFMRHVCVHdHbmZFS09SdjRBTVplU2JYWUl1SFYwU1ExM0FJ?=
 =?utf-8?B?ZmVVWE4wNHR2WnhSSkRoUDZUbnhtVTF0OTczS1l6WTZONnZmbEs3TWJrQmE4?=
 =?utf-8?B?QkJLQVRDTkQ0cHdsZXB3VHArYWxnZ2pUWWd4OHFDSWpxaStaZFFaVVRpUk1H?=
 =?utf-8?B?QWFzZU10YXpDOVcyR1gzNjNYVjNLdlZCbW5nK3NlOVRMYTcwTWxmS3Q4cFpr?=
 =?utf-8?B?MzZVd29mMTJIcHF0VmhiejFyOHVyZzQwdWhYS21ORjdyU0xKcGRRNWxjL2Zm?=
 =?utf-8?B?REsxWkFydEZVT3V5cWoxbnQzRjJ4UndUcThzSi9ZSVF3cmFENWRvenBBeHg2?=
 =?utf-8?B?YlpaMjJNUmtITDRUNzVnbkQ0ZzJoQXhlWjFHSUVEaFovVXJjYnB5ZTYzK2FT?=
 =?utf-8?B?WUdXbDVQcEVsdmlpNUw2YnRPYUFkcG0vb1VxTnFibGZXelBUaW5RV3RWMFU0?=
 =?utf-8?B?VDJ3N3FGbHlmK05pTkg5TVI3SzBaRkZabXI2NVhIK0N0UlExWkRUbFZ5M1dO?=
 =?utf-8?B?TWlWbE4wbmhramxMUlhpb2tXbWVZaW5UOUxBZ3V1S0w5cXVUTTNhUG1VTmJW?=
 =?utf-8?B?N2ltaGExbEtlbG9Od0NRakZIUzU2aHA3dEkybXJlUnluNTNSWXkvdGxZTHBm?=
 =?utf-8?B?bTZ0Y3hYaWVtVStqam1VdjlFWllsY0x4bG5ZbU5QN2Y1ckZtbzZ5Z3BZWWx4?=
 =?utf-8?B?MXZBZmRwOC9HdVhwcnZOMzBVYm5CSFRkZzVpQnEyQVpYS3orcE1jQW13c3FL?=
 =?utf-8?B?NlJHZEszOHpJWnh0MTR1WU1mU1BBd1JUVmlBRkNnWFhydW9nVG1aaVFSL2sz?=
 =?utf-8?B?RSt4alVPWjZTQVFyWXczSlR5WlNUd1Zzbk8vVmEyUGZBVjhHajZmK1cyS2Nx?=
 =?utf-8?B?VHEwZzZrdVhySVpEekp4TmswK0FmQ2Q3Y0k1OXQ0YUNkNGtmRmlnSmYyUkhS?=
 =?utf-8?B?WHFUeHkzNWNzL09VRDZhWjBjMzAxVmFwZ213ZzdVMi8vTUEvc3JxdlJyMVZr?=
 =?utf-8?B?VWlNRzdmV1NIOGw3djdLTVgvMUZCUEJZUG9BL0pLT05qVUxVTkxteitqemUy?=
 =?utf-8?B?UWlxWHl4RWhVYzNJdlRxL2J0WmtBcGladzFVUjNLa21FLzRib29nWTVsRFZo?=
 =?utf-8?B?ejRmZythY2FRQnpEdVhHS1VaRGdlRFhuN0tHazdaY1VGSlRvU2luQjNuOTdo?=
 =?utf-8?B?VDl5MXZOeEI1RGxZWWhVWGJ1N0hpVW1wbDEvZWhTN1BRTXZ0UVlGeDMwTTFl?=
 =?utf-8?B?VkhxRGtqWjVRMVgvVWlLdVNSQUR4L0NHRDhmclRubklQNzJuTjJBdFJuU0Iw?=
 =?utf-8?B?bmhBNEg3V1VJZU00KzhRODFxNkRCQ2dqTGQ0T0JhdjFYdWpqbEx2NEZhUkVj?=
 =?utf-8?B?OFZYdGxlYVhPNy9FdmZxZ1Eyb1NldnlPd21CdTJidDVjWjlLZnBzZFZseXVq?=
 =?utf-8?B?TjNENEh3NVNOYkZMZGlYZi9CUjJqcXpEVStYS1ViT3FaL2NYdzNyRlAxUjBy?=
 =?utf-8?B?VnlqNVRpajZWT1RBUVh2OHcvTG01ZUFQNnV4WVc4citFSEhHUWo2aEMwV1g0?=
 =?utf-8?B?SVZnYUZlVWVDTVVYNG5EU2psREtpVGI0MDRLV0o3MzVJREdPSVpDYS9CT2JF?=
 =?utf-8?B?UDFUUVBsQldmU2VMS3pyZnBOaWJ6Y2NzQXhtNmJ4Ukc4L2p1eDZQV1pkVWRr?=
 =?utf-8?B?dnJSbnR0ZUZyazM2VVYxeXdzNzh1NlFMM1Awd0hLVS9tQTJrWHU1TklpWU9N?=
 =?utf-8?Q?XBr7sK5EqTPHg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7917.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RERNR1IvVkhOVEZMTmpqcGxpanVvejJCQzRwQkVzRGRLOC9RYldOWHNXSTNu?=
 =?utf-8?B?M21HQ1ZPSVo5VkJBMk83TkRsSVRHRlJNbmRmd1dhZnNPZVp4Mm11eFI4ZW9Z?=
 =?utf-8?B?dmpvamNidWtkT1gxemhEYXZZLzdUQXRsV0sxUE5oenVMNGRJRm44eXhFMncy?=
 =?utf-8?B?SUcxNkVhaXR4NVgxQ05XRlJnOTZNU3JueUt0Q1hmbDBjY1NqeUdQeU15UGRp?=
 =?utf-8?B?RHIvTWhCMUNSQi9uT0t2WE0yRks3RVZVWk5raVViRS8zV2U2clNidzl1a3pz?=
 =?utf-8?B?ajMxSUgyQjlGVTdTYSt5ZXZFY2FJWnhtcERhbHNCQ0pBaEpBOC9HVktYK0t5?=
 =?utf-8?B?a1RQQ3lsN1d1MmZTalY2UDdCeS96a202YzRkSEV1TFJvOEpMQ2hMS0hsa0tY?=
 =?utf-8?B?VVFnUmQ5eDlPQ0ZsNER4TVNYbHZ6RURXVW1TelY5K2NoTGNrcTd2MWxTR1Vu?=
 =?utf-8?B?R3NRM2JpNHA0V25HVzZ1cm5OV1I0b0hFSmVZT01MRFBzUzBFNE95c244ZnNu?=
 =?utf-8?B?eko2NnZ5MStDRlBvT1U5L0JldDEwamV0dXNZV3VRMFFhQk5WbDhKZmdkTFBF?=
 =?utf-8?B?YlFCTnQ1REFPbVlraklNR2hmUk9GY1NabFNvMTNwRkFMeVFqVnpQeDdjeDVB?=
 =?utf-8?B?TzhPZDNwWitmdmVVR1pkbkcvN2xqV0N4dE5GKzc1UFd5TFdYVXFWTHhMejdJ?=
 =?utf-8?B?OTNYWVRDY0FpUjkxRldkM2JWQ2p5cWRCbVJMRVhFU2RLWHlHTlBXK2NVL3JQ?=
 =?utf-8?B?KzBGNGFmWjZuendIQ05vTk4wQUlwNnEzaHo3Y3VpbFFoTGUwY3Z6U0lBVEcy?=
 =?utf-8?B?RHdVazRKNmpCUEFPaHVVVml4L1F3MmZIZkRJUlB6bTBwVHJSeWpOU1N6cG41?=
 =?utf-8?B?RC9ORnlFQ0dvbnptRWtpcHY5YUJJZkRuYXJ1U3d1cXhjamNnVC9tNWZUa2x5?=
 =?utf-8?B?N2JEZ2pSM011STBCdDJhRXFDSWFSSC81Z3JjMytKb2dyOE84STYvb1dUZ2xY?=
 =?utf-8?B?T00zNUxtWFZaOHc5bm9NUVdnbWtObVduWlFUK21FS1FqTnA0clY0MFlCWDQx?=
 =?utf-8?B?amlIbks2NWYvSGRBTWhUQTZNaEttMHM1cDZlbGhTbUQxQmRmc0VoZ3ZNSEwr?=
 =?utf-8?B?N01pb2lWamFBR1NLVjBQTS90V1ZrQ2ppajl3YStnYThTc2xFcEs3aWp3aHNV?=
 =?utf-8?B?cy9wdWdZVS9uNW5Bc0hsenBRY2V3b1pNYmJOeU1PeEo0WStWN2tzMFZIZXFX?=
 =?utf-8?B?VTNUWDZRVVVNMU1qWlg4a1NmZlFnTTFnNjFJckVkUDV5dU52RkUyZFdTNHRr?=
 =?utf-8?B?bHdYbEdYT0hzaW1oNU1TNE1vNktRVXV6dThBaEd3MTVqRzBGWVl5NkxNWUI1?=
 =?utf-8?B?czlmRkFuNFNlTXB4Y3NoMW5ZK2Yrdk9LTzU1THRZejYxNElublJrS3BZTUNQ?=
 =?utf-8?B?TGtvVFpJNVM0WkFtN2ZkRzY5dVl5b2Z0V3J3eElSenFnTnoxRUcwWjZMakJ2?=
 =?utf-8?B?eFdlMnpna2VOVWJSMlpzYWpUckRPSy9vS3BPRG1LNWNuWVA3QTF6ZEJOWXQv?=
 =?utf-8?B?ZkhJTHIyYW9tbDFwa0QzczRxYkFZUUxlb1RPbW82T1hEcTdpdmUxZmhNejIr?=
 =?utf-8?B?eEZRSVRybVNZMldiVjhWVWllMTVjS21mcXV4QnJsSVdBWW9DT2tlbGhiQVNW?=
 =?utf-8?B?MjFlandsNG81ZFpJVEcraXJsMEhMRHhDMVpQNHM5QzhSaGxwR3R3K1F6S3JW?=
 =?utf-8?B?TmFJWlZ3aDJjbDk3NGtuWFNpRlgvekZpK1JPVVM0WG84M2lNTlA2TmdCQll2?=
 =?utf-8?B?MXFnRE5LQ3preGRXRm41eityeThsZEVJOHUvcVUrL3UvdFBMckIwczBSMEFs?=
 =?utf-8?B?azZUZHVIUkkyQ0UvZytidmtnNHJFdk9KNjVsS2MwRU5KbDRHMVIwUDZlT2lL?=
 =?utf-8?B?TUZZRXE0a0FNOEdaelkrd0dZS0c5a3dRYUdVMXF6elYreC8xM3hMWGhMTTdU?=
 =?utf-8?B?QnFBRDBaR1RKaWNSMFhXc0hvNjlON28zUC9xUjJOdFYzY1NHT3U4anN5MEhK?=
 =?utf-8?B?NDMvRU8vTlFGOXVTQjZ6ZnJxTlNxRVg2WGRoQUo3UUR2SzNSMDhaTG51K2xJ?=
 =?utf-8?B?KzE5b0ZBaFFyMVRQdEYzZGxFRytuOUpjV3RSV0wvNTJVRUlERWVub044TTRX?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d26fd95-48e0-40d4-7b04-08dd5ff9a89f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7917.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 17:33:24.0912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhA1fUzRmMYckNCS9fEQRBBSuZjxAftRSZVKmvcAe0v7tnizM5j40jZllkHnaKBO8A6jOW+OJIOS9zCzGdAxMIsdh9FhFXoCy+fFkwMFxA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8012
X-OriginatorOrg: intel.com

On 3/10/2025 12:06 AM, Chao Gao wrote:
> 
> Should patch 2 be posted separately?

gfpu->perm has been somewhat overlooked, as __xstate_request_perm() does 
not update this field. However, I see that as a separate issue. The 
options are either to fix it so that it remains in sync with 
fpu->guest_perm consistently or to remove it entirely, as you proposed, 
if it has no actual use.

There hasn’t been any relevant change that would justify a quick 
follow-up like the other case. So, I'd assume it as part of this series.

But yes, I think gfpu->perm is also going to be 
fpu_kernel_cfg.default_features at the moment.

> Regarding the changelog, I am uncertain what's quite different in the context.
> It seems both you and I are talking about the inconsistency between
> gfpu->xfeatures and fpstate->xfeatures. Did I miss something obvious?

I saw a distinction between inconsistencies within a function and 
inconsistencies across functions.

Stepping back a bit, the approach for defining the VCPU xfeature set was 
originally intended to include only user features, but it now appears 
somewhat inconsistent:

(a) In fpu_alloc_guest_fpstate(), fpu_user_cfg is used.
(b) However, __fpstate_reset() references fpu_kernel_cfg to set storage
     attributes.
(c) Additionally, fpu->guest_perm takes fpu_kernel_cfg, which affects
     fpstate_realloc().

To maintain a consistent VCPU xfeature set, (b) and (c) should be corrected.

Alternatively, the VCPU xfeature set could be reconsidered to align with 
how other tasks handle it. This might offer better maintainability 
across functions. In that case, another option would be simply updating 
fpu_alloc_guest_fpstate().

The recent tip-tree change seems somewhat incomplete — perhaps in 
hindsight. If following up on this, the changelog should specifically 
address inconsistencies within a function. I saw this as a way to 
solidify an upcoming change, where addressing it sooner rather than 
later would be beneficial.

In patch 3, you've pointed out the inconsistency between (a) and (b), 
which is a valid point. However, the fix is only partial and does not 
fully address the issue either. Moreover, the patch does not reference 
the recent tip-tree change as it didn't have any context at that time.

Thanks,
Chang

