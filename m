Return-Path: <kvm+bounces-63414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C391C66067
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 39B7F2978F
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371C0316909;
	Mon, 17 Nov 2025 19:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dxXzJjyR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A025782A;
	Mon, 17 Nov 2025 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409123; cv=fail; b=CE5fra3Vcv2kHoDOBLeh9p3ieOC9XLcbmLAYK1UoY+nkSBeqIFEYLPeypyerl2ZqmI+Se2+uhq2vYjEeGYSHyI+PyTA+X1u426S+ZfLONIbopTmJJAd1Xfbcm1wYFUX9+wvw+QP2BNl1F8bcNuoOxUVymQeAGHpk5oKtOqE7Mjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409123; c=relaxed/simple;
	bh=MPHR/OkyfFzx0RwK99vGvdhp2BtTHj/BoThbCxJlevo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fvJRe7jl/1dJhGTz8/3On81ArkNeBMTf61XqsFTVdmkHTmBADrp/DE61RFQsSyOMHxeGRaId3S5UbEYx/hK9IhcMCYYvYj1y2F5wdI/blvIWsV5YccQMAZzeL2hhTsc/zvfV7YtEor4lyWg+0AzRAn159y7lvhX6haU2QwLfnQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dxXzJjyR; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409122; x=1794945122;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MPHR/OkyfFzx0RwK99vGvdhp2BtTHj/BoThbCxJlevo=;
  b=dxXzJjyREql6zlcoTySYlSdVWJRI/uNB/tXKsySwUM/AiSsV8lTtdH/X
   BV9e6J7FEOVMzfsVg1FwbM50yhSl3RrY4yodngelkIjQF8vpIzmPJfeF+
   Vi4/gXZrB8FisX9liymL/ZMHKW9s2wXx2qtzbNUeDZVd5cJyIMHyjwiGi
   c6dB5h96YTtuvfh60kEcwSfb9W9cdV2FY5x7vhRU0ySdro0Qgsthpb0yS
   GZREgP3Gcu/8GJWDE1RuIVHk8pkvNvIOZcTX/cEbnS8oJ8bnShvZk/XNK
   kPHx5C/wCq3jBMbOnOpdpUUnxxJz7QlOZXeHsAqwxjHzxFafihRWmj618
   Q==;
X-CSE-ConnectionGUID: 9caK3fwPQuaL2HZD0thqVw==
X-CSE-MsgGUID: 9HqpZCJyRYy/xU1gqwR2gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="90895683"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="90895683"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:52:00 -0800
X-CSE-ConnectionGUID: XaS5e0jwRaK909JLeWR91g==
X-CSE-MsgGUID: w4TdVmDcTG2F1vMa+ENm5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="189808971"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:52:01 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:51:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:51:59 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:51:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKcooimNQLRtlhmP89yTe1q0sTziQFINuq2lbTsHJr7ePqdsrWfALVtxTN1PMqQJavEBXDGcSQBWtUqRJs+gntymRdKMO5EH6gnOOMTISv767ExTvUw1m3G1rlAP1IyaJqoSjscUfYPzIXHaTuVIZvIonJPNIHKkMCc/O3pAu5FwrxiiYnuEC5XP23zCx4trdlxSKYtQaQBha/+/vGCVBqn4eeG0oqQhpLbSeglMCkPFf+kLDnpCefUUh5rU/XGt7ETjaGYYsJd+QnpoIcbp+S+aEnziNyrCovH2t8AFbvDMv+5OuyimAkJaVD3HhVbTZ6pf/MrFkF30ZcUxEJZUCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEe5WMiruQfFfNpt/Wdcm6RwI/4614Ri04u0An3R4C0=;
 b=SqihO2OlnRIUUFl1/XVtlK7wrzZgWSjQUxV0oQZn5ZlzPs2085ruJfeZsH3Bac6eWQwpAONsPLJ6ccOEjdZ7JHjFfrFv0Owl1boTI9E12eg4xUUGe3kwbrY/Gp+c/nKeXGHesnD0xdIi59JkB9TDno5DNUzCXYaithd8qrUA1WmYRoQAlD2btUZoOUMGAEX7bqfvHuTeXcQsxBKk44V1D5e70adU9WI6n7lp82dSgo1+FpiSQpdw5lfGGaavgu7UqZWI8Fx8HG8vNFk9XnkUTg9KIVdtyZTWvd1tunitVluLcH0ct2cdgPRf50FYmzSm1LdqahffQETrWyFQV40AKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH0PR11MB8166.namprd11.prod.outlook.com (2603:10b6:610:182::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Mon, 17 Nov 2025 19:51:53 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:51:53 +0000
Message-ID: <1ac436ef-f625-415d-952b-a88cfbb43737@intel.com>
Date: Mon, 17 Nov 2025 11:51:51 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] KVM: emulate: move Src2Shift up one bit
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-3-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH0PR11MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: ba3166c9-861c-4d21-7b5d-08de2612c17f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXhTZmkxUlZ1UVlPajlTSFZqUlUzUlBpd01WeUZSOFZONlVMWnVZcUJPTUF3?=
 =?utf-8?B?Q1UrcUpXUjI0ekk3NmpGMSttRG5QcFhyNm9mU2FsZElnVjBPVGlzcC9namJ4?=
 =?utf-8?B?Nk9iRlBNZWl0ZEJjTHZXSEh4QzFBZ0VGMzBxRktHdm9zWGxWcitENm82TTRZ?=
 =?utf-8?B?Q1ZBN0ZPZmdSSlRNa0NrYjNRdTBxY08zQVR0cnVmL1VGclBZMHdkQ29ZSTZh?=
 =?utf-8?B?d1E2cUloWmpwU1pEREFoUG43eS9ncU55RUhaZElrWU1uZURzK0VieWE2b3g3?=
 =?utf-8?B?MWM0ZS9hUEhIOWZ6MTh0RmpUS2xVVnppL0JLV05wZGVqSkRvZWtIdlZDei9q?=
 =?utf-8?B?anFwd1RuNGhiM3gyc1NuNmYvVjR6Rm1NeUZTNGwwczAvN0VxYWFPdGJoUmdz?=
 =?utf-8?B?d09yTWo5SUFhWXdPdG5sQ0FHS0ZpWWMvbkhveXRreFdpcEVlenJuQklYby9h?=
 =?utf-8?B?d0s0ZzAyMkhxdEFJSGJoaEczaVA3M1lFY2F1M0xVS0E2ZEpmZGI2cEVXSDVR?=
 =?utf-8?B?RVVDN2JNL2UrUWw3d25SRVJHcGlpKzhEZGw2QlFGY3VxM29YSXpDNTlxR2FP?=
 =?utf-8?B?eXdzUFRzb0p4VjR5QVlJUkNJVlh2dDBHMTF1S3Vma094WWZhWS80TXl4S0gv?=
 =?utf-8?B?N0xFUFdhcWRvUzI0b29JeW5aUXUrRm9nYXpPblIrQzFDQURVK2twSDBpV1Rl?=
 =?utf-8?B?cWhSK0ZEaEtpUEk1Wkx2NzJWVDFnL003WUVIVU4zYmhOOGxmTTcwUFk5M2pN?=
 =?utf-8?B?VFVDc1BJS3krM3RVWHF1ZEFxZkVKY2R3VzdEQlM3cloxSHh4aU85ME5ta3NX?=
 =?utf-8?B?UW9yS3dCcXNXeSt1cW5nTVVjZmJQV3V6bEJDWUlKaGo4dndGMTJxSnFBQjhZ?=
 =?utf-8?B?djBHSFdvallqRU1vRDFtUWdKUXFTdU8wMnZDSjZWSW44U2FOc2ZKSStqWjcy?=
 =?utf-8?B?ZlFvN2cxZFgyN2plWW14ZktCbko4WjJUUjFpR0dhTFFFSU1nYzR0TlhtWEpW?=
 =?utf-8?B?YURmaXFMQ3ZPOHJMQ05lRkdpRVJYdHRjZXBCcmZWSlNmSjdYRWpCWjU2Zitx?=
 =?utf-8?B?VzRiOFRWT2RLYTRNaU5wakRJMnV4S2RkaW5UTU05YTVZMTJSbGxucHZqdGJM?=
 =?utf-8?B?YzhtQk1xOHFJTDlhdUxUSEFyK1VHTVhwUHRaQkRxdng3a09zekMvU3RHS0ZG?=
 =?utf-8?B?OGpPRzVsU1VNbFI0M2NLMnVndzlZcjZaWnpnenU1RCtNWG45VzdFdDl6UC9K?=
 =?utf-8?B?TkoxN3ZtdHZPQ3NDZEVLUmtML1pCQmxvc282U2o1c2N0dVlmN1NseDJZNXU5?=
 =?utf-8?B?dVprbmxFUjBFWCtRYTZMcTBVYTN4U3FzazR3bFM1ODdEMDI1MjNOaHVEaHFN?=
 =?utf-8?B?bFVzVkQ3NjlvakRRcVBhcEhyc1c1VFBNRmpPN2FiVjU2aFBxTnJNWkZkWGFs?=
 =?utf-8?B?bndHSUx1RHY4U3ZmaTQ4VXk1cXdISlpGZUY2ODgxbDNiMDFhQTBGVjAzSnN3?=
 =?utf-8?B?TVhXVFE1TlliTU9GRUl5TkRlTGtWTFNsY00zYWh0cHdzWUN5WmdBYkZIMzFO?=
 =?utf-8?B?VldYTjJsci9nM2FFU2YwaG5FOHlQNjBLRFJacmF0aEMvSCsxREU1TEdUdUsx?=
 =?utf-8?B?T2xFRHcwM1ZoaXpyY2NFTW1OQTdpaWoyMWxYaGdsZFM2RzdxVVZKUWd0RnFP?=
 =?utf-8?B?bU9LcGkvUXVxcDRpYXNUOTVGTTBmclJzdi82bDEvQzdkZUk3YmRxNFNTRCta?=
 =?utf-8?B?NDBkSHBPUERYcFg3QkcvWmtDcFVIOVZ2dkcrYlVxTEdxREk5K2pVT21NUDdu?=
 =?utf-8?B?S01oTDl1bnRYbmZtU2lITmpOUGZkVjF5TjhjZmxsWEpWMUplcG5RaDZhSmNI?=
 =?utf-8?B?N0xpSGQ1YmtHYnk0M3lUdkpvSnUzOTNMRllnYWY3TWVxZTdTS1FZMndnbURm?=
 =?utf-8?Q?qfhLOXj2qHsTOJ3ITlw1b4TFABXIiG0/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTNIVTh3UlZaRCtleWlkSlp4aUthL2xTRHR2RlRvNlJBYzJreWRZeDJoejN0?=
 =?utf-8?B?Rm5KUHpqZ2lUTExGV1JteWQzZHhRcjdwK0xsQXpCbkpoYVRneDNYLzVWazFO?=
 =?utf-8?B?QVoyS0NKTjQyZzBGRTJwVDQ2K0oyYVJqQTRjQmp0L3VjQlEwVnp2eEQxOC9K?=
 =?utf-8?B?K2RZMlpISkdJU0p2NTZ4VUdyZ29uS1RzVVQ5NTVlZWFhS1hOZ2YvNWtHTXJp?=
 =?utf-8?B?cDl3QU5ha1Bpb1Z2NWFFYm8wS1h6a3Rya2lLN09WcUVxM1p1cGNNWTBodkFl?=
 =?utf-8?B?bGtRalNZQUhDcXFudmtCY0toczhDd1dNbS80TG83K0p6Y05ReXp2UEdZM2tz?=
 =?utf-8?B?RktzQTdEYnBtVXkxYnU3OFpNTWZ1UzRySlBLa2xTdmV4VjBNWXVoYUxkeE1s?=
 =?utf-8?B?Q3VoVnRnK2RLNVpyNDdCd1VJRW9laVJ2K0J4Q0prUkhjZkFGb2xiMWV2d2RU?=
 =?utf-8?B?cW1aWE9scU91MkFmK0pTZmtKcXdkcXY0eWEyVTdvS2xnT3dBWU1hRmhVWFNG?=
 =?utf-8?B?S29iclV4cDUra3hUWExXcUQ5TVpITzgxblFVck5IVXoyMGVOREljOFdFaVEx?=
 =?utf-8?B?YzYxZUdBaElmSldKSGRoRS9ZUXozd0Q4Z0EzVlNId216U0UyaW5TOENXZ1BG?=
 =?utf-8?B?SmFjeEJxR2pPd2ZKWDg4K2tJUkN3SVNKelFjbVNIdFVIdlMxVDZZS2JpQncw?=
 =?utf-8?B?M09LWUVkVG1lREZwcXN6M1BLOXFJSEV3a2Z2akNXQ2lZZjNIY2tVWXpNNDJ1?=
 =?utf-8?B?ZWxma1QzYUJaYklCRStzL0N5UjlBRUROYUIvY2JyNFJvVW1SMTcyQmJKa05j?=
 =?utf-8?B?dlNRd0FIY0hGRXJPVlhIVUVQWjdOSlgzaUtJcEU4bDJQbnROR3JOalFPTW9s?=
 =?utf-8?B?b0YwOXFYSXN6RFJwbFlqdUlHVWtUelhtVDYwZXIzL1dOL2NIbGhueTBEbVYz?=
 =?utf-8?B?bk10WU1EVzRjUitTVzZ0b1E0S014RVVNeWVGWFJjamVSakxXRmN2cGdJMmJL?=
 =?utf-8?B?K2ExdHlGa3BmMmJzdEg2dHE1bzJSaFRYREhiZDdFaUVLb2dsZ1BCQkp2ODc0?=
 =?utf-8?B?eGdYT3ZVdmdDeUQxemMyZ29ydmJVeGJYbFZ5MVlwRmg0TXVBaGpXM1pKdXda?=
 =?utf-8?B?bURYMmFZZzVJMjlyS05jNjdUTitrOW1EWVovRno5S1hzYks2R2tqbjQ3TlRI?=
 =?utf-8?B?eCt3N2c1TzNhVWJ5Z29YbWF3REVpaFRKbU1HZVpiUjFnMDJ1WDI2NXNsNnhp?=
 =?utf-8?B?Tnh6QkkxZkhpU0hkL3RjcFQwTnViZExWSEtiM21tUUxJekJkSXlGcFhDbnBz?=
 =?utf-8?B?bXNUbFkwbUFiREgzenhmSGxMSWZqRGVMZ1RiWHVxdkNjckZsTTNkRXRjYXow?=
 =?utf-8?B?ZjE3c2o1dXpZbUd0b2pTcFFpQmhwcnNyWDRoSjQrcklJb1pIRnlJVHVNZlBp?=
 =?utf-8?B?MkNUekFyYTdySWwzQmEyRWJkaURHWitNSDRseWhtQzlCYmIybGpoUkhIM2NV?=
 =?utf-8?B?cWxHSVhWN2hBdTdkUWZmQks2anlXNis4SDEzZ0dJQnowZWt6eHJXbW5mMjFh?=
 =?utf-8?B?OU9FYjlaMVVHbERDR3pEOUlRa0xXQmp4QnZCWVFGQWlSbTM0OUFwVWUrdnBk?=
 =?utf-8?B?WEVHRHdIakxHWkRyRWhETEQ1STI2dHVLV3BURm92cnBkQzVJK3hZMnFOQXds?=
 =?utf-8?B?SklzaVQzVHJoSnkybkdSbjBFaWNiQVBmOTRDVEJ0cHAweTZiNjZQZTBSaDNo?=
 =?utf-8?B?dXRHMmFNamFxSFk4ei9KV0dkN2o0V1ZTNzArNGJBN0xhTGJMQUpxSENZbTRh?=
 =?utf-8?B?S1N6NmtlQnlkbk94YWFpMG9oVFVySHBUd1VSbkx5QW9mNGpoVjAvb1Bua3U2?=
 =?utf-8?B?Y3R0SDMzY0RJMldBd2Q1YXdlZkVZSHY4N1RQcVBOV0RyeWxOWGNUTEVDVzJs?=
 =?utf-8?B?cVdwR1pYWHNQOElZMStOZXJLc281SEc2N2VISGJjaTRVS3JSSEJFZVBGOTZk?=
 =?utf-8?B?MFg0WWJNN0hUei9XVnBFcjIxNGttcmR0enZJTGo3ZzJCdmp1Yk1Jc0M0TExT?=
 =?utf-8?B?NHFtaThyUmdYOWo1UTRKUGE5amszOGN1Z0R6blRnQmc0SWJzK2NDOWdDOGRa?=
 =?utf-8?B?Q3JaVEhxdHljb0Zpa1JwaWlFRW1TbkpQc3ZGZlR0ckx1U3NlOVlRM3UvbE1J?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3166c9-861c-4d21-7b5d-08de2612c17f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:51:53.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HA7eM07BiYDnJmCBwKt2dtM7aKmimRSXsymLyXWjRY1hgw6E7pY75T2cESLSsRrGudYlizB2GjDEz3dZrDK4grVJmH2mfqT5A9iVRQxeq1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8166
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> An irresistible microoptimization (changing accesses to Src2 to just an
> AND :)) that also frees a bit for AVX in the low flags word.  This makes
> it closer to SSE since both of them can access XMM registers, pointlessly
> shaving another clock cycle or two (maybe).
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Yes, this looks sane to me as well:
   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com

