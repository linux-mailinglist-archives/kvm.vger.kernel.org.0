Return-Path: <kvm+bounces-17867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B637A8CB576
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 23:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 429B9B21063
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 21:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC4E149E11;
	Tue, 21 May 2024 21:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Txah4keC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B2014885C;
	Tue, 21 May 2024 21:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716327798; cv=fail; b=hbplzub2X/9mBACCA/7x7CJ5QjhqqQqVSulAklOdeGA7zAkp7SO3EDt4FAtkKrP1qg/znNPIuCYKveoC1RdGuTGIRi3YGHDm6FUkCJuTopIi824fXzr6EHywE0IKBItA7QSvlgpeKqO3bN6JPDasLdgsomFxqkzNXn1p6cyJNrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716327798; c=relaxed/simple;
	bh=1BUfZYhR90P5KYw5sHenAVS2nVK66uYH5E6It9qe1TU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gprggI+7mg/K/SnaqrNFiuqnjnVaTMYI7phe8bC+VDvOa36HB2r+9hMZQUJvQoPYRCk6Sw1jkrYgpdGy6YjcnxxGjefmXLTg3tJu2W1t3H0Zj1ArX6GkwLwqB8YJqc9qIzBmILEIMu3zB60YOlBxYJX3PzP5HtunZAIsLFC4cng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Txah4keC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716327796; x=1747863796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1BUfZYhR90P5KYw5sHenAVS2nVK66uYH5E6It9qe1TU=;
  b=Txah4keCl6ywIrN4OCt3EN7asCLNlFH+VAV7Kj5VCz1VYl4n4pME6Y1X
   G9taYexzQzJ2anVXr4UCKelfod/awV81mK3K/FRfUkn5K920AMhqN48dk
   d6AWI3H0RVU33OqBQNYqIsxA5AwQxOdeOEdUwtMw8V9U/vMuyRvqlnYOi
   OB8O0KSwFNVsPyI1qy28tvuz2uvjkRgHKSIAUkfCWN7qIKUrRlp+ke14E
   ufNhnLLXouprysSLIHFl6csbNJvtYZ43/ZEgsqomIZciuLK1E2yLeCxbx
   kmVtHr+Gep/sTtEn+prOenXlDol1iiJRcgX17AIAKyWV3KMK/z8vPwurG
   w==;
X-CSE-ConnectionGUID: A4hVJGHKRD+K0GUijwNUmA==
X-CSE-MsgGUID: ArDyNZkDTcudjgvLbsr9qg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16389779"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16389779"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 14:43:15 -0700
X-CSE-ConnectionGUID: ZnHPLJ/DRYumSQmspP19NQ==
X-CSE-MsgGUID: kuh+BysoTRm/AFYB4f8Ucg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33599120"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 14:43:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 14:43:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 14:43:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 14:43:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 14:43:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx3KdGCpAtMcrZd3sslXFAFHFYGCehOMlOL0Sp2irRtIlk3aGtEKbFmCovZMu3S+ax5QjJWidA8yAxW0vi14Qt8pOJkxfHgyRomWL5w06X63yV+7nRQyJKdyi2+nA1FcB3CIljeV7iP8PSdvVKw4Wo9nOHhrW5kCWZvPdpGKuLmOTcGUqvf5bsmdA6xlT964eSBacB3btiyC03ysB+8aDB1K9eM/Ck3rs3mYOCmbdlrLctDipSBKoCx3vFFIvPK/lrG/RAUqoJpATuPmOYFSL2Crk0tEYGAE61nPsOE1tWE7D1LCMotQ5Q4uNlkHUxYSlWd8KczKMxV2kqCf+QVaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95Vi66B625jSpCeiqW3rhdDoQ52g0tkBbib8+SmVZKU=;
 b=mzSX7/iaRuXx1GF2DtFOGBWXS4PHguLofvIVP3YWhaYdmjL8nQ1NY4+VaRnXGOInlDY+EfzBbau/Fw5aFcAFSlDbX2PYgYcxGWhqubYseBSWrdbGy/GdP6uvg1sYgocInhk8yik1EOPutaVqzr78J9yLLeUZXw+XYGka+GWlrsYgpghOw+1xb8LGb5nYAymQ7VIO6DSuq8fdfyJY2hF17F2m44cdKSpEUKsuzNiPvdNlQ7e0ADQ7o1T3OmbQqSaDZ6dFaAyE9iqfSqokTR+e/B18UG4TvS/+/vp8s2Ta6JRgin2qjkVW162YutPJb+8W/c7F2IX1KX7BOdfsaHFQ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW6PR11MB8440.namprd11.prod.outlook.com (2603:10b6:303:242::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 21:43:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Tue, 21 May 2024
 21:43:11 +0000
Message-ID: <00c59dce-e1e4-47cf-a109-722a033b00d8@intel.com>
Date: Wed, 22 May 2024 09:43:04 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240425233951.3344485-1-seanjc@google.com>
 <20240425233951.3344485-2-seanjc@google.com>
 <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
 <ZkI5WApAR6iqCgil@google.com>
 <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
 <1dbb09c5-35c7-49b9-8c6f-24b532511f0b@intel.com>
 <Zkz97y9VVAFgqNJB@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zkz97y9VVAFgqNJB@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW6PR11MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: dde6ea4e-7d6e-4567-9ec1-08dc79df02af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MXF5T0UrTU5NcEpjYy8wRk9IeXdUVUd6SnZVUStqMkJGQlBsMzRhTDEyNmQ2?=
 =?utf-8?B?RE1IdGQ3NXFVMFY5bXl4MUVBTmhTSWFlVy9qMFhiTXBrdGNGNWowcW43NlNJ?=
 =?utf-8?B?ZTlJc1ZUa2tGVGVUWXBUWkdnbisyL2l3VEw0VVArYmkxRFNSVVRWbFA3blJC?=
 =?utf-8?B?RzFIbmY5VFFvbGd0ZmcySkVOcnVVd1dqdkwzS25OWDg2MmJWayt2QncxbmZv?=
 =?utf-8?B?MVBjZXhOT2hQTGhwb1ZpNVRqblBuVkI1N1Nwam9DQnQrU2VNeGVuY0FhYnRF?=
 =?utf-8?B?N2FXalZxa1l1Z0VUcHlwaDFXVWtlZUNvQUMrdmFUUDU1RVcxZ3EybUZ1djh4?=
 =?utf-8?B?NlQzTGxzYnZtdSsyN0g2WlFDMTBiRTJibzJhQmRMT2k3blJqbm1YMlgvcHBM?=
 =?utf-8?B?V1BlYkp6RjlsRVo5QnRCWXhnYkROM2hWeTd0ZTlEaWo4eGRFZHcvMHl4RjJS?=
 =?utf-8?B?dmY0c2s2VHUrY2RtK01ocDNCSjhpRlE4dUZQTnN3Wmp3eHNrUXoxL0ZXMzBh?=
 =?utf-8?B?c3Era3RaMHZFQXJtOXBhL2lYL3pUdEJRYUFQWXQvbWIyOWJaSWZBR2YxZGZZ?=
 =?utf-8?B?eHFqU2N4QkZQdmF4aVBadVhuMzN4Z2s0RVIzVGloOHkwaU5nczF5M0twcS81?=
 =?utf-8?B?dE1haHNqK2FHc0pOZktwd3U0eTdTbnB6TmIydlJta0d1bVI4SXB0c3lXZFdM?=
 =?utf-8?B?YmZncEpjOWlvTzdQNUUvUkhhUHhXT2Q2dUo5UGJjM3N0WFRuZjNGUkVyb24z?=
 =?utf-8?B?V21tbUhrejRTdHZhd2hnVER3TjB1Rkp2bngyRktBQ01oNnE4Z1ZvampIRjU2?=
 =?utf-8?B?SEdqeGV2QWhkTWx5a09tSVJ4dmNRanArMTUzV0hHUzduU1E4c2d4QXQ3clBL?=
 =?utf-8?B?QTl2d0F1NDljbEgvb3RJUG9wSWpxb0hDU29rNGRVRTg3azlCNmZQTlF2WnNK?=
 =?utf-8?B?ZElNY1poZlMzcG1mbFRFa1RXQ1ZkUEIzdTluTDRldGhwNlZZaXE4U1JLS3ZF?=
 =?utf-8?B?NEhFTTMzT3dobUQwdUh6VXZSeUZnNjhCTE5LZit3NXVvUUdrWTdBckR6b0ZN?=
 =?utf-8?B?RHBjWlNBQjFJOHU5VTUyaGduMHFTbmIwaFpHQlFJZ3Z3akxsVC9TTGVvc1pH?=
 =?utf-8?B?TXJnNzdsNktEQUd2cmV5VjVoTkVuK2k5ZGd2UFZEbG5UZXhCZlNVd1FsaklB?=
 =?utf-8?B?WDN4QlRCc1h5TnJBcVpyUGJhUWx2dVpDVFpGK0VrZ2pEbWNMTkpUK2ZBSG9Q?=
 =?utf-8?B?OEtvYU5MUm1hUW0xSjJDRUU3R1lmbVU3Q3hsOCtWOWVROWhkMGlGRnR4N1Rv?=
 =?utf-8?B?MXZFZ2ZzUEV0Q0JtNUU5SUQzU3c1VWlVVVE0UlZxMDMxRnY4bUpvTEZpNVE3?=
 =?utf-8?B?ZkVrdzlhNzBvT2xxSGdLaUg2R2hZWnVKME1QRDIvOEdPRXEwM0VxNUt4cmFq?=
 =?utf-8?B?RVZFT2o4UUU0c2lOOEpmOHBtaVVueGZLajdTTnRKcmtEamJCOU9UT08wRzlW?=
 =?utf-8?B?U2J5YllrQ0ZuVkhvZW1BMHZjQzlVNk1YQWxwRTJMdkMycGpGWlArd1Vld2tL?=
 =?utf-8?B?MXpQWEVqNUhTRG0rM2NXS1BGNnkrRHlrN0FGcVhqdCtsQitoQ094S2UrMDZV?=
 =?utf-8?B?QkFuaTU0Zzhlcm8xMWJkOVgwZnVJMGtvdjRGOTdaZ3dNMEhROTdjaDZwaXBI?=
 =?utf-8?B?dm9UNi9LaGdJSmg3dmFLazc1b0dwUlJLSFRpVGRlNVl0RzN2a3RaU09BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3JTQ0lUOFNnWmx1UUZrMmtpRGFEcWN6M1ltTkI3Zkc3RnF3cDJVdUE5S2ov?=
 =?utf-8?B?TktjRHVXZUdrbm9yT3dhMHZyUUs1MS9QMjZLNTlmQTcyZWwvSU8yUVphS25u?=
 =?utf-8?B?MENkVEJGc1B0dGVOeFg1TWpGUDR3QTU3RzhaNXV6TlBsWjBDdzJTc2tjamF0?=
 =?utf-8?B?aUcyaUMveER5ZFFpR29raTFOR0hzd2h5SlZTUTNoOTdYOWdiOWNOOUZnVU5J?=
 =?utf-8?B?MkN3Qk51ZHdBbkxiNmw4R2x3eUVLOEx5TUFmV0dwTkpPNnVVQ0xuUk9lVkxE?=
 =?utf-8?B?K2ZFMlNUeFlCTEloMG9PaVNRaTFWRUhPeWQ4QjlnblE2ZnB5WDVSVGRLMjV6?=
 =?utf-8?B?aTVCTC9Yam9OUEsxelNVeVorWGtwcGpuM1hVSDR2dTNVSjRYaEFVbUFUdGJG?=
 =?utf-8?B?TFVnNE9zemtqYVpUcDB6Ulg3REpLenJQbkkxWjR2Z28rWDVnTm5sWUl0dDFa?=
 =?utf-8?B?Y1ROcW5BK2dXQmhsRk9yOUxsWFdCeUhLdDRCalEwL215RGxVdENnY0tLVmd3?=
 =?utf-8?B?MmJHYU0zeE9Cd2Y2cXBLMUZQOUVpcTc2bUJMY2VpR1IrenpNOHJPUnZ5R2Mz?=
 =?utf-8?B?SDF4RmN1RDVIZVF1Qk9wZnpPQ2dvYXlLSXZZdmpvZlBNY2xpWnFzK2JjcVkr?=
 =?utf-8?B?MXI0UUtFdWMvblM0NDBYV1RENnp6M2ljUitTQnBIOGpZZDN5dTJldVd3Z3hy?=
 =?utf-8?B?ZDNTVnBvajA2cFdOZTd5MGgwRUkyTFgxOVNwMXJkbTZRU285dTVBU1NTSnFR?=
 =?utf-8?B?RFFXZ2JLTDQ1ZFBld25GRmY2bXlaamMwei9mQnJwaXR2d3N2WTh4K25Lb3Z2?=
 =?utf-8?B?ZmFSVVN4dnA5U045SU1FMWdSZEFyRytEWmtjVHhyTlRWbGtHSnRBajZJbDBN?=
 =?utf-8?B?UExob0ZxM1FxS1RIODJQYnhPTm5GdTJ6QzlaRWc2NzhHSzM5cTNXQTlLeEtj?=
 =?utf-8?B?M3FLREVQOTRZRlRKN01xaFd2L3VzdE42bHJkN2g5b3JTam9TekYrUVlkZGd4?=
 =?utf-8?B?OEovT2Ura2x1bkZoZzRIbkJXSUozN1VjTVJsVWFxaE1SQW9GbXpJeFg3djJT?=
 =?utf-8?B?RnkzRXllSm8rbmxwQ2RMRVczcE5KSDFVVytWNnJmdjJPRHNpS2g1dHBBc1FG?=
 =?utf-8?B?aVhlNC9zTk1QQ2tZdk92dVV0NndkQlZnTDg3Y3E0aE10MEV3YThEblVHZmto?=
 =?utf-8?B?aFFGTlFTWkZCcXRyVEUxd3BBclFUVnkxZ2pTaVhpN21IOEZhTm1BS2c5QzBw?=
 =?utf-8?B?bDBuKzFUS0xuYW5tQndHSmVnemZNQTd2UXRtWjc0MElZemZPcEdFQ3JrZmxY?=
 =?utf-8?B?cXhXMFdyaW5RZmxRaGZSM2NlK0Rsd2FYUHRnWjY0ZlpoUHJWak5NaWhweTh6?=
 =?utf-8?B?dzNzU1NCREkxd0U4UGR6WG5RbVptWnVTc1ppcEU0Q0s0akFYT3VlU0gwWmlX?=
 =?utf-8?B?OWhLNUVMVUhwbWZ0YUxLR0JPQnh2ODFsTzNXT2s0NkY3YU9UMnBOYXFzVk1v?=
 =?utf-8?B?VGtkdFIwME9FRGVubW5SN1diODJyMkh2VXRqVkQvbFU5cGtNUXFYbEZ0OEsw?=
 =?utf-8?B?ZVNodVBpSU92eDRkQ1h6S1pZZ3c5SFN4NEZlSHM3MklQakxYZUZWNEp5K3ZP?=
 =?utf-8?B?Mi9SN3RZZnBaZGFKU2prY3ZJK2EwRnNhODgvTXRIWmxKVGN3N255dVAvRzBr?=
 =?utf-8?B?emZ5Q2pJWU4rcFI5RFRKcWtMOHlkbTVYWk1PZ3EzL2xvVmhmajBwNEFqa0sr?=
 =?utf-8?B?ZkxHS3BZb0ZvMHpPYkhLWXRtWkQ2UWJXYzgybFJrRmw5cTkyZG5UV1NhTVlZ?=
 =?utf-8?B?U1ZWTGlYQWtWRk1BTElxNlRBTVU3Y3g5TVJXS0dGYnFMOU9iRWNZZWNxY2Fu?=
 =?utf-8?B?U0tGK2VDcHlDTVZtbUZjUGhXWEtPM25zdTliL0lmRTA3MFpwWjl0WDlVZFQ0?=
 =?utf-8?B?OTdkTVB3N3I4VklHS3A2dndhdko3YUx5dmxxRW1NOGE0NjQ0eUlCWkhDVmJq?=
 =?utf-8?B?cnNIRGZlMWZiYy9NekRpeVR5aHBrbzRHMFMxc1RHSnUyUHdQQk5UZW9IT1Jy?=
 =?utf-8?B?ZWNIRlJlNktxZFJXQzlEaVJpd0JRR28vSzhMOWdFUHZ3RnVrUjNrY2tFSmkv?=
 =?utf-8?Q?BYv1ZFG7G5vzE8lkuxmV5s8rO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dde6ea4e-7d6e-4567-9ec1-08dc79df02af
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 21:43:11.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xN4BF/LabgkheWud7/47eO8cjaks8PwF7tB50ZZT/2RbhkUxkWw1tYKdIgj2C3bu/5yRLwuckDYZ71AMB5fmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8440
X-OriginatorOrg: intel.com



On 22/05/2024 8:02 am, Sean Christopherson wrote:
> On Wed, May 15, 2024, Kai Huang wrote:
>> How about we just make all emergency virtualization disable code
>> unconditional but not guided by CONFIG_KVM_INTEL || CONFIG_KVM_AMD, i.e.,
>> revert commit
>>
>>     261cd5ed934e ("x86/reboot: Expose VMCS crash hooks if and only if
>> KVM_{INTEL,AMD} is enabled")
>>
>> It makes sense anyway from the perspective that it allows the out-of-tree
>> kernel module hypervisor to use this mechanism w/o needing to have the
>> kernel built with KVM enabled in Kconfig.  Otherwise, strictly speaking,
>> IIUC, the kernel won't be able to support out-of-tree module hypervisor as
>> there's no other way the module can intercept emergency reboot.
> 
> Practically speaking, no one is running an out-of-tree hypervisor without either
> (a) KVM being enabled in the .config, or (b) non-trivial changes to the kernel.

Just for curiosity: why b) is required to support out-of-tree hypervisor 
when KVM is disabled in Kconfig?  I am probably missing something.

> 
> Exposing/exporting select APIs and symbols if and only if KVM is enabled is a
> a well-established pattern, and there are concrete benefits to doing so.  E.g.
> it allows minimizing the kernel footprint for use cases that don't want/need KVM.
> 
>> This approach avoids the weirdness of the unconditional define for only
>> cpu_emergency_virt_cb.
> 
> I genuinely don't understand why you find it weird to unconditionally define
> cpu_emergency_virt_cb.  There are myriad examples throughout the kernel where a
> typedef, struct, enum, etc. is declared/defined even though support for its sole
> end consumer is disabled.  E.g. include/linux/mm_types.h declares "struct mem_cgroup"
> for pretty much the exact same reason, even though the structure is only fully
> defined if CONFIG_MEMCG=y.
> 
> The only oddity here is that the API that the #ifdef that guards the usage happens
> to be right below the typedef, but it shouldn't take that much brain power to
> figure out why a typedef exists outside of an #ifdef.

OK.  No more arguments.  :-)

Thanks for this series anyway.

