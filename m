Return-Path: <kvm+bounces-16668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE1E8BC733
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43AC7B20B70
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10BA481B1;
	Mon,  6 May 2024 05:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pbkza7Qa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB147F4A;
	Mon,  6 May 2024 05:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714975130; cv=fail; b=N9YXJ5xcx3gb50mNcJsnH7Y53ZnZr5BA/unl9W2XHx+lGjL/ddW9C3mQf2wD43sRLLP1Y2XcUPxLY6WOsV1iVRhxFoPOE5yj7RLFb6q1ifeHT1CXT+BQtHY9gKqmaS8jr3wu/RPyc5Z/zoSJhmfLHFVHNt45ulswk08TZely6L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714975130; c=relaxed/simple;
	bh=tTEgSQaC6uoYqEkxJK/SwsCsyuYIvaqTSSfx+Epn/GQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oZoDzx9T80fKqx3EpQQ5eLAqCK3L9Mr8M2kgSJ1Gex8ZnLYq71BqgrNAsx7XOQrXbafdVlftpOBNxC318ocJQLP2XNZDPpqu1CUpmq0EvPkG2K/lE/et6viDwhmBeTwybrdCHrkV4w2e9UfzQ0eqEkmAHkhJbhT2lhQsgnkCz4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pbkza7Qa; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714975129; x=1746511129;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTEgSQaC6uoYqEkxJK/SwsCsyuYIvaqTSSfx+Epn/GQ=;
  b=Pbkza7QamDjCpbwLUM8/Wdfc5Tu04pWJDZSvrWRhjCy2FOLG2ye80A3V
   XW1to1XcI18ZOEQI/cH3SFgkCL1eXE4ESFne1Sy4o3jIr5v1YP+gFOelA
   fNenlXvF0MLmhVWWeMl/+GEPGiFcsdcnbTBNALXOPI2cpRK89BrysMWIm
   SmwKvPCJLGW4aOV5jKvo4YcX0luPMZl3XcKRvS/+orlJG/bduUsBUyWU3
   2EMItzQtT8oVBKfhMFr4XaT/GpeeZ8x/6Obe0ALGnRuA0obQxctW41CGS
   1Wdovw3uri2v8jqmu9rhOpa79a6kGZinvoGeFJ14PJ+8L8tSHZJo5Nfu0
   w==;
X-CSE-ConnectionGUID: zTDhiiESSACqLlA6Yo7TXw==
X-CSE-MsgGUID: C16DzL+cSyCt6dX/fIcMyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10923385"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10923385"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 22:58:48 -0700
X-CSE-ConnectionGUID: /wSWKNGiS/e2lYvDeoEMBw==
X-CSE-MsgGUID: UurDajiGRs+pfWkbCmuSLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28452560"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 May 2024 22:58:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 5 May 2024 22:58:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 5 May 2024 22:58:47 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 5 May 2024 22:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezTeajm+2ceCLLJrPt+Sb4mDAZGX8NSYr3CbXm7Ael2bBdi5fhfTAO9K3Ur3hfK4EFBTPj1461LT0wnoLA3epSg8onaFVekxPhyb+VGlMuevjKDq0Db9+dDNhgjBUQ9/o0vz+Nq9bcyyzh9G+9zJ3eyyhZY1bbNdE3TeHDNjA8aoC6fKaPgMjompTm43w91JpOBB6GImb8VAgY0G+bEBPVSTOdiqyikMpBIKHHbgGmCJpsl2jBu5MfyPSTR4c6Y+kpKSiMx45AfrYxtdBNOFBlX9E6mVECmhHwTvnRrvoWfjQo7XoXZp7AbA351J/qSlfqHqWONcJEx8vZNVfjKO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkBUa0uPuDARQ3He4SnCDSOZjkiXlaEkcBUuy7H9sU8=;
 b=JnniR/LtMsVqTPPoJDjWzXM3k+dsYONorjdj4MUSBXJT7jCcvTjolqFPR9SZirICT1rZTBOtv/hfsewcWkFID/ghP9r+3V/dKTKhzH+Tp+sNyeA1ZSUMoPitwXYP/4E90Xl3QjWpIo26IND8XN8LrxRbmk9CTj0gvS4rcsKORHOnc6fpvDaufg24rUZ+YzG2PljXEfshY1LQ42K+Z/auoLztwF6BqUbB5Q8Kfzz9gpTHi/HEkLK/v6l3FHDftEissNeq546U9N7R4TEq2/z1ym88Hcv6oYhRhywxsKxjfhG6eTWVuWgD6a1UciBvW2319Q8kKZiGu266tPzO1FVoRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7730.namprd11.prod.outlook.com (2603:10b6:930:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 05:58:45 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 05:58:45 +0000
Message-ID: <f11f09b4-03a8-4020-9f37-4ecafce63105@intel.com>
Date: Mon, 6 May 2024 13:58:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/27] KVM: x86: Rename kvm_{g,s}et_msr()* to menifest
 emulation operations
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-10-weijiang.yang@intel.com>
 <ZjKP7_vydkig2FQ4@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjKP7_vydkig2FQ4@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 719e436c-b506-4bb4-9dc6-08dc6d91972d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RFJiMGpFV3RwaDhwRnVuSFRYQURaWkdyc0RxdU5iakxCczVnYVNjNFBpVWNk?=
 =?utf-8?B?enFwaXpMaVBuaGhhd0x6ZTh0bkFmR2d3bVV4emZ5ZkZ0bndCVGluSlhmTWJB?=
 =?utf-8?B?WSsrZ0I1NzNPdGlBN04rNFhKYlh0L0thV1FJRWpRNmI0YTlPMWl2U2dXNVhP?=
 =?utf-8?B?eFc3Z0FJNjcxcitWZno0VmVFM1FMRGVnZkZiRkM3QkNWbmhVWFJDNklzeG02?=
 =?utf-8?B?MDY1VEx5eDB5TFg2OU01c1g3Q2FEMzAxOUZXbkJnNlpaVkdUazVGZFhCMHp5?=
 =?utf-8?B?UWFYRkpwQSsrZ1BlR2xIS3A0S0VnTVFMSzFIVUtaSHpQU1N3Qmt6aVJmbjBY?=
 =?utf-8?B?dEV4KzFJS2N6THM1bmt6NnY2MGk0VHpjMHdUSVBDMktOUjNVbW1tbXNlVVdy?=
 =?utf-8?B?SUoreVBTMzdsb0E5R28xQnhCL1J1TENuWkU1L2NkWjF1enNoTzJ4MGpSa0pw?=
 =?utf-8?B?YzBKSHZiVm02ajV4TENHNlZNRHljQ2JmTlhINnpJRkQveGYzUlE1OHE5NElB?=
 =?utf-8?B?OFc4KzZYV3RndTZsdS8xTi85MUJwMEtRNVA2S2tHVlRDR1huRElwWkxScURr?=
 =?utf-8?B?K1BmRXVJcnFKOHpnYXBJRHdQNWt0UWZzZWVWT0FXdmVnNUtHY1lDTGJOVGhj?=
 =?utf-8?B?RWIrSHNpTlNsd1JnQ2U1cXJnQVNuQnZ0NVdSRXJCVnh4b1JzbTF6c3lRVDFu?=
 =?utf-8?B?VEY0STdCdVRWYzBhS2F6aVYvM2s0aFY2RjBTK2gvNXU2VVZPVm5keFUxYkRE?=
 =?utf-8?B?MytsQS91b29qNlpKVGo4NGNLNW1IdHRjbWJHelNVNHpLVmErb0E3WlVabGE3?=
 =?utf-8?B?VWFBVmQ2dkQ1aDBpdVdYYlpOUHdkRHBjSmtmQ2JZZVBnS0V2TG9mMnN3Ui9i?=
 =?utf-8?B?YUZQa2dDeXQrK1RxVExLOG9VY3hnQzlLcFY1Sm51OWR6emppVUR3VmtpS3dR?=
 =?utf-8?B?dm1NT3VNdFdiL05paVFFdXFQM2lVM002WjJ5WXFhRWdJMnM1QXpMKzIvZ0ht?=
 =?utf-8?B?SjNSeE9DUjl2cXdhZXJScUxGZzZEODlhbnBWTW9pVytYMGxVK2JySlZVSmN5?=
 =?utf-8?B?OWZVNUh2V092Zk1WVjI4d1MrbGNyeGduc2ozYVo1ZjIvcDJxT0J5ZnQvdnVI?=
 =?utf-8?B?cUFOcHJnZERTeElHL3NVTGNkeStybEVKNEd1MUVHMlBDNDR3VWhpWXFBR1A3?=
 =?utf-8?B?YU1wbzlic2RFN2dUZlIrNER5dzVlbVRyZllEcWIrazIwVDFhMHMycHc4RVhT?=
 =?utf-8?B?ejlyQ0V5TVh2TVB1enhlVDdkY0czV3hvUmRld0tSaWVhc29SeUJPeWZRc3hK?=
 =?utf-8?B?YmlCZXB0YkthZE5RUE9FWEVKS2t2d1hDRjNwcS9tN0cyN1JQN05YdStKSEtN?=
 =?utf-8?B?amtTZ3ZkVXlTUmN0NjBUUGZCdFE1OWJMNDZPUkJpOHFOYTZCQnJWV1JON0Zp?=
 =?utf-8?B?RGRIc1RTUG1wWVZWS0t5T1psdThRWnBHV2dORGxFNi81TVU4VE1SUGNFZ0lK?=
 =?utf-8?B?MW5ZSXUxTFlqZlNEaFA2N2tQWUd0ZERyZVNkTG94d3QvNGV4aU4yK2UzaUNU?=
 =?utf-8?B?ZzFJK1hOdTgwSlBFUENLMXdpZGcvYThLWGtpOE1Yd05ycUpEV2dVTkZ2ZWtp?=
 =?utf-8?B?b1hpUlhIRElaNFpBMXZQdWhzUEpMMnZLUGp5WkEwRUJvTzJ0aUxabmJMclhK?=
 =?utf-8?B?RjFEQXJIeDlXUEk3S2puSUhmUkxFY0hreWlrWUhxTnJLazYyZlJ2UkFRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1BXUmxCKy9RU1lvYm1qZy9rN2ZzcGFYLzArNzdQU1pvNVRnN3pYd1diM001?=
 =?utf-8?B?RXFRZkh2azlwNEZSQUVVZUpPU1RnUUpCaHN1YStXZjVwMTBUMDB3Qm9ZSkRn?=
 =?utf-8?B?ZE9NTXRSTnN0VkFVVXQyUmZzczlad2Rxb2hLL0VMWFVaU2xIM2Z5cDhaWkJa?=
 =?utf-8?B?YktBbGZLZHhFZjB2cUFCMnZCS2lSdUFxb3F1cVlZaDFRZWVTa1I2dzkydmtW?=
 =?utf-8?B?cHNmUzZQelE4TTRzdktTaWtIb0hkU2N3blYvU1AvZDZ3QndsK2lUa0pKVURX?=
 =?utf-8?B?Vm8vK0gwMmxIY3kycThNbTdsTXI5QjNKQkxxTEZ6ejZneFBwZGs5NXRpNmRn?=
 =?utf-8?B?bkRsb2lZUTNBNktsT0ZrU0NkdVRSUnRPZTBIcmhqa2gzcTY5UFZCWWl0Wmdx?=
 =?utf-8?B?VklLbkMwZVdYdXkyTUZid1RFRXVrdVhQdFByQklZQ2FsODF2ZnpRU0xUT1lT?=
 =?utf-8?B?b1IvU2JEVi82SGp6cmp2VURTOFFEVmR6bHptNDRjbWYvck1IbUhSa3hPWUZk?=
 =?utf-8?B?eVFOdWF3YStCZmFGaTFNcEh0aE03QjdQdFAwRVp2dTZFR0tvbU1OVDBaUCto?=
 =?utf-8?B?cXJWMS9LeDc1Rm9jU24yZGRnVFlrZ0M5d0JCT3VidTVjdk1DbmFabzgzdUpD?=
 =?utf-8?B?TVpBM1Z2TkNnOUlRdi9TZ0dNRHorMnJCclJCOUNaaTR2N08xQmRWWWhXbXVx?=
 =?utf-8?B?NlhjTFdDdnNveWNPcjdsUXFxNHRiNUpSbnNJN3FjUS9sQXNDVW5JWHY3M081?=
 =?utf-8?B?RWVaOUJ1aWpQSFA3OXFtVWhqTWRmbkFlN3dVTkx2dyt5SHZ0cktoNi8zd1R4?=
 =?utf-8?B?YkdLTXd1YStIbExJTWFCZmJQMHNqMnBwbXBMNS9oSXhoN0ZsZGp2SUVRbk5Q?=
 =?utf-8?B?UDNPOGloQ2NHQThYeHQybFhFSWRlek9CUWNCRHhaOXZhSFZXYXFhL1hmQmo0?=
 =?utf-8?B?RXNVRG1DZU1zcUZTUWEyeVFvS1BKcHEvcTU5TjZ4clpycGZXdk5GMHlHcjhJ?=
 =?utf-8?B?ZThpNVpOdkFHSVZ6N1NnbXJhdFFEb1N0SlpEMHJXWHpNVVY1WnErMUFYTUpI?=
 =?utf-8?B?VHNKMTdYQzZiQm1vRlpXa1k1Ky9EUzBTQU5NcnVTa2R0YTZ6UTlSV0pQM2tz?=
 =?utf-8?B?SUhRbE5qMlJhdFZGTFlBdUpoMXBKbjhQWG5rOW12ZE9rNThUMnJMN2hVRWgy?=
 =?utf-8?B?NHVhS1Y2ZDZ5V3QydFJUZC80bWNudDVHQlI0SWd1Y1lNUWNiRC93UEQ5czlR?=
 =?utf-8?B?MnFXY3JqbWJHcWVnL281ZTdsQU1aNHJvRFdpVXhyUWVYYysrcDNURS8zSUdh?=
 =?utf-8?B?Ujhjd0xtS1FidGlOblNkbmI4Um5yTWdSaWVwWjZRUnVZVlZCZmd6bktOTXJu?=
 =?utf-8?B?RmhRWWRVeWdXUXppMlpGaGRXRHRVUlk5dWc0UHRlS1hXenJLVEUxdWlCdGVP?=
 =?utf-8?B?T3p3bG04ejc0M1VnU2t1THMwM1UzbUlBS3l3QTZabFhLdmh0UHZ4YURINFlG?=
 =?utf-8?B?MFZTd3M2QTRORmdTY1ZROWFXbWQ5Q2RlQy9BYndKRkU2UC9XWUVHRlUvWUZq?=
 =?utf-8?B?a3FxUVFKTUpkb2xDYXhkMHNhTjNTSVFHREc4T0hkbXFBYzZseG1XbnUzREpj?=
 =?utf-8?B?SFZiY0ljS2tUOTVHTDN5SjZtd2dDWHRQS1JqTWk1emdsK2NOK2FCWk95RE9F?=
 =?utf-8?B?V0h1eHY5UjZJUzU3STNWZitLdDdjQ1dUU0NNWVM3d1c4T3VacU5lVm0wVmd1?=
 =?utf-8?B?ajN0cWxaRG9scmVGZ0s5Qk1JclpocnZjWUpWaDNLRG1PMmZjalEybVBhd0Fr?=
 =?utf-8?B?R1VlWkxmMnM0cnhwZXNPVm9CbnREMGhTYW9YQVRSTlQ4TzhudWVaWndCSjlo?=
 =?utf-8?B?cHRLU2NjZ05qd2p1eDFlOXlmUm9qSEVEblYwQWRQTjBlc2pmRnVLS253Y050?=
 =?utf-8?B?SkxTY2pVKzNPWVFiMXJhWlBlYklsUXlwS0NOQzdUbTk1WXlrSHBhTzNXSTJo?=
 =?utf-8?B?S3U3amxqK0RKOXp4RjBtVnF3UlRWRUc1VTRibkhIcS9nR2FmQXBHYmp3VFhY?=
 =?utf-8?B?US80SzVJSG14aXBwK3F5ZmVVR3dtQWovSVVNSHlBRmRrMmhUaHFWU21KWUtX?=
 =?utf-8?B?ZVRWQkVJbitEYkNIMkZGYUJ5QmxMWlN6QnV2bUZ1S0pmNkJPSGdDdEIvcXEy?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 719e436c-b506-4bb4-9dc6-08dc6d91972d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 05:58:45.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ezlHWEolPHxTctgZjp2EFmVNzFzWul4S1EVcnjDIKlR0rEdsTgO5DCaudLCDuZgqbyZeT6Azk7hZvl9+mL+1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7730
X-OriginatorOrg: intel.com

On 5/2/2024 2:54 AM, Sean Christopherson wrote:
> s/menifest/manifest, though I find the shortlog confusing irrespective of the
> typo.  I think this would be more grammatically correct:
>
>    KVM: x86: Rename kvm_{g,s}et_msr()* to manifest their emulation operations
>
> but I still find that unnecessarily "fancy".  What about this instead?
>
>    KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
>
> It's not perfect, e.g. it might be read as saying they emulate guest RDMSR and
> WRMSR, but for a shortlog I think that's fine.

Sorry for the delayed reply!
It looks good to me, will change it in next version, thanks!



