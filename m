Return-Path: <kvm+bounces-24066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9473951052
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98A731C22226
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9A91ABEA7;
	Tue, 13 Aug 2024 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9NsSyFf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1442370;
	Tue, 13 Aug 2024 23:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723590709; cv=fail; b=agS5Hf0HA5gTMryFPg7WYbDHG85ANnO6SCKXdHgHPNdYC7mj86sE1O8PRQ3+ECpk/w88ju05qhDA2+gZhuVUmcjFGqidQ2+zYbOl7o0aepkXz8GAD9DIZDW7Ym+5qW0Xw2p9fRIZhcs2DpxvbaxXT+Po3Oevjz3r1WOo7FIcMiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723590709; c=relaxed/simple;
	bh=Wu3z+BYaGaXggAtoh2qLCIz2Vn9M2I55D46Wf6Pt8gQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dY+s+9X2dR3mGFdl2ut4ViHUPCtA8pZh70GebfaNyBXNtRFSaizD4lEj3hv2KG7ZaB7EgLMtg3y9HtLvQhUxO0YmpMlIhTxqmd4XMMRzRgqAMOBCBixy2tQ9VXG3hBuTOG8J6r9iYFw81/3a/0a+p+wdN8JhGYwJI8IHtLilQSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9NsSyFf; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723590707; x=1755126707;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wu3z+BYaGaXggAtoh2qLCIz2Vn9M2I55D46Wf6Pt8gQ=;
  b=f9NsSyFfwST6i76vBZ7OTLoN9wRt5sUu/TppglfrjEAEYxlxfJScWsM0
   A0Rs47Uoc8pLystewF42/jIVdhVgdf9TSvVmRAnuEweX35w2uMcTv43GH
   4qiT5MPNwj5IhjaDGomCZFmJbi4Mer+7KlmLuyA7hpCS/UJgB+DCbZIOc
   ekgYJ7lvZI29oViAYZ6TPIOSUqQI2u9Ef0A7+/3ZMfVpckPBBGWZa4Ygp
   dS0EoPF/DR/MU3iec1cmEyLshp2JIkCrIQ6R/S6oTtrKxKqeFngmT3psM
   Nan5y1/CF4GKqAu1Bj1c5THsO8G2Gn7KjuewWUS7bwcXu7Oe5fhpPCT2G
   A==;
X-CSE-ConnectionGUID: JiMgNka1S7GO7L8TSca0iQ==
X-CSE-MsgGUID: IVk2+BBBSQyVHZ1grFx0+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21644432"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21644432"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 16:11:45 -0700
X-CSE-ConnectionGUID: QQ2GukhGT5+dn03044fMfQ==
X-CSE-MsgGUID: lIUh2x54RKqvrYdXJaVdDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="82043261"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 16:11:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:11:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:11:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 16:11:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 16:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwRumb+nmuKEzKGItp3hoOLHsOCQis0VLhuoJndrCAod8FXkQZpoJDGcwrPvAA73gCU6FKC59lzOLrJBctXHMFZL+HLIRBdmJip3rEaA6MM9ZJA/RCSlts/PRYNjuAQeC04b/MrdT4gJVfKRqdfEsb/APkqfpPMXHij5GbOcnajcu6Ytg0LnSN6biKkrjjhZ5kPp4HD9Ozsw7u3SsJJPALcHgWDJTSC8Z+9lifisaHwIBFtAIlfnzITmEUcr+Wg6weo+DSvw2rAIRSpbwvSf19CD0P8/X8i6RaVRfiJofD1Cf0FMcVnXaZNlv6Jb8Fl33tsTA0aNoEZUCt38m4T3Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4Q1lC9ZovKdk+HV+sc18v91Y7Z1fI25eUjfjy2/GGE=;
 b=xvGx1lhZMfg1KFxroCyiZaTUH019AHDme4ojuu5acXkdMr23JQVJ0G6J6b/NMNF009+9DFZqkQSIglTRnnc2ZIseSPR6m6t71Di91nzzNgIqc9W85VJhQq7MlNyaXKqNEmepSXQBFwee0MXsmfZKK5oVJZdEukKCIaFYjkizZYjoaYLMj3nqGAP/VRcXbH7g5WdRAjSCKrIyQ7CWACADkhy2fPtS8L9izA1xR2GPnKtcffiE92Rul4XJymTEUCJHIdcp0glQ0X9PVbHAGS/Z4c0ZXYFX4iduzg6p7wl+b6hR7TIQ302A8RhzPhUfp3DXVm82w3rpnlqacujCE5YwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7026.namprd11.prod.outlook.com (2603:10b6:510:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Tue, 13 Aug
 2024 23:11:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 23:11:37 +0000
Message-ID: <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>
Date: Wed, 14 Aug 2024 11:11:29 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Isaku Yamahata <isaku.yamahata@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<michael.roth@amd.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 61660e7e-acd5-4be7-505f-08dcbbed480b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TS9TeE1yWjJ3eVRsbE5WWVJ0MDRsNHdpOW9XcHdMRllVTzVtKzc4VzBJOXJJ?=
 =?utf-8?B?OWxqV2VmalRJMVg5alJYQVNYRWNYTDFsOW40cElvMEZ4YTFGT3VCRXBXKzcr?=
 =?utf-8?B?SkFoNE5WZms1QUlXZHBDc0I4QmZpckZWUGdpbGpLeWtqVWtORDFlZG80UjRL?=
 =?utf-8?B?WU9Hb3BHRE9tb1dKdlltRERuNmdScFNnTFdKYjBvay9NdXR2UFJ4dnhpK3FR?=
 =?utf-8?B?bVArL1RlTU9TZllGRTRWd2xzcG9sM0lnZGpyempuZkVLUXVGQ1d4WVNTcnNC?=
 =?utf-8?B?QXBhd0ttZU04STFobFFLOThSTkVlZmNQTEFnVFhJamVpRXF5aVpGNTAzMEhq?=
 =?utf-8?B?T0M0RjlMdXQ3ZnE4ZHkxM0ZET29RQ0Z6WDVSMUdkMVFBR2xtRzVidy9MR1lx?=
 =?utf-8?B?aERjR295QWZpcDFCc2dmSnhFQWhCMmRPRkw5OStQTlQyTStzdVpMemhWbGdG?=
 =?utf-8?B?eDNVU3ZlaDZHbjBPdmtQQTFJeEZhN3pOYjhWRU40a045REJFaDcxQktmbGQv?=
 =?utf-8?B?RzFnUGpzRlUzRTlhNFgxTkp5aUtBWC9TYVR4dS9CV1R6YVBsNENxTHd2TE5o?=
 =?utf-8?B?OHE0amhTNlFSUHY5VU83aEJabzFoRG9Nc3VmMXRnL3h4WFdjZkF6Y2RvZWdw?=
 =?utf-8?B?WFlrUzFaSnU0c2swV1lac21KVHExeTgxbVBETUpTWG5ZMjZ2eSt5cHh5UkpE?=
 =?utf-8?B?MXZ6TU5PZlR0blEycCtVa2pTVStWV2ZTcjFkYWFmdjY5dDRtYXJEM1JqN0J2?=
 =?utf-8?B?TDVSR1pzeWVFK3NoUXlQdStwNGorZVhiVlJ0c1ovS3BTZHJ6R3d3RUNUTjQ1?=
 =?utf-8?B?ZDBkQ1M3RHlIWk9IL1czME55N1kzVk45bzd0Z3g4K0JDSCs5N3NPYTdjSVpt?=
 =?utf-8?B?MVYwN21RV0ZFajlFdTBnWEo1aGFWZUhnNER4QVU4Q08zeENML29YWlVNKzVS?=
 =?utf-8?B?K1N3ODJWZWtvVUR3aWhidjlJZkY0QzlUSmx4ZDZWOHQwbWh1UUxob0h3Z2c1?=
 =?utf-8?B?bGVDNzhDTHlQZlE2Rmt1bDN5VXBMYTZTc2ZGZHNsLzdvREs5U1k1ZWdPZVJN?=
 =?utf-8?B?MEtuNFRScWZadXBETXA2SzRwWjlBT25mdFVXMlJiOXpHWnBlckQ4azRzdU4z?=
 =?utf-8?B?ejNLOWE1V1JJS3VFOGYzdUlUekJPRDUzZzVNY2RIQmtoc1krYnJ6aEx1Q3BY?=
 =?utf-8?B?SUVUSWhwTm8vcXkyakJucTFPWUZJMHh5VFhabHFkK2VpVXlUZnZTdlFmdDgy?=
 =?utf-8?B?enB1VlE2QWc5ZFBXYnB6QkF2SHRrY0s3ZmxzL3FkR281VmNUOTNGUXVLT3g2?=
 =?utf-8?B?aENxejU4V1lnWkozSHd6cDMwdUJmQ3UzdzFNODczKyszZGxrRlo0amlPNC9D?=
 =?utf-8?B?ajNwNUp2alRVYmNMSnRRS1RxQVdWYjgwNXJoZlRreVpiN3A2dXRVS0pPcnZY?=
 =?utf-8?B?eXRLNTUrN2EwN3dKeHZveFozaTQwZStwSVozSDhpbHZ4Njh1WjNjUXh1VXhk?=
 =?utf-8?B?ZWI2TWowbXhneDBHUWpBM1cwTHJXMDJPRkRYeTVibjhSK3dOVWhNVGpPMmw3?=
 =?utf-8?B?YmZ2cllma1hkcjZWUkF6bEUxU1VMbk5vRVRZS0RPVTRHRDRkR3ZtNnU1QU1D?=
 =?utf-8?B?aS8rbE8vSEd6WGp2cXFRTE51UXhmN3lPVFhBSHNTUWJVTWZvajIzYXJkQ2Zp?=
 =?utf-8?B?RTRHak5iM01BQjhPemdVQ1NCNkVoaGFNWEs5ZWt5N3VVekhSbXNvR21BLzBT?=
 =?utf-8?B?YUU2THIzTU9VU1NtbE1jaTlUV2w5VEdnTDd1Y2tURkpBdHJMQW9tcTdBMlg0?=
 =?utf-8?B?ZWpKWmpvL2pERFpUTjNuQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkRWSnlBZ1pnVXgwSEpBVCs1NjJRTkMxSUpFQUJZN3ErdzQxbk1QTFBhczRH?=
 =?utf-8?B?TmZZK25IMEJYRzVrMk54UW5BZkxXd0lYVmN5RmhTUS9lajhtWklkNVhteEJT?=
 =?utf-8?B?bHlxZHhtb3NPL2NHKzdXS2o2SnlMMGtWTjFUSjVKNUFWYk5WMEtnMzFsM3Fl?=
 =?utf-8?B?dTFpc3plMEthZVNoR0RPaE5hU28xR2lHREUzMEQ1V0RCYnF2VDBVSmRYb1hG?=
 =?utf-8?B?R2VzdnFES01hL2VPWnF1SEhqSkdXRkQ1NHlDZGhHbGFrREpzNTk1RWtzODRL?=
 =?utf-8?B?ZENJSzNiUGhtVGtMV28xRFdmVEpNQ1ptdlRjcUlxUU5jWThaUnJyZDIyZEtq?=
 =?utf-8?B?bFFYbmFSVnZmZzBhQVAxQWxLczZMT3NDVmJpVktMaURoMGtHRXJHUXZNOEFo?=
 =?utf-8?B?ZUYrL1FiNEFUbndSUlZEb2hoTU82dDBMa3pwc1N6Z2lQYjFja0JNbDdOL1Fx?=
 =?utf-8?B?L24vamxaQWY1QWVFVlZIbExqWDg1WUNBT1ZlOVMwS0NhLys2eXlWM3dDdHBP?=
 =?utf-8?B?VFdKTVpqeXV6dEhhemNwdzZVYVRqT2w0OG1DdVU5UklPcUNTRjJlRlAwcnRm?=
 =?utf-8?B?dkFWVXF1VklqSGx4TEtQUmpySSsra1Z0bnJLUzAwdUhCS0lVd3d0c2JmUEFN?=
 =?utf-8?B?R1lmdEJML1NpamIxbGNuU0hHenVLSmEwNW96b2xUQTVMa0dHVWhZTDRXVFdq?=
 =?utf-8?B?U2dCUjg1UXErbmoraTA4QzNIS3hxN2NXbmxyVUlIS2YzZ1RqemhrK2NmTXpG?=
 =?utf-8?B?UmJURVorWEUrVGNUUjBNYTJNNFAvMW5sV3JvNmJlbE9OclpYSGFlTGM4emZR?=
 =?utf-8?B?RG9oaE4zNHZ6NW13eUdabkhia1BzdWVON3JsbHRBdXdBNkp3bnhZSFVwSW5X?=
 =?utf-8?B?YUY5TzIyaVRaQVdvcnh1S0F5RU5YcUJIUmJCNm1YLzR1ajJDek5iV09KMjlx?=
 =?utf-8?B?NlhwUStoQTE0Ujd4MW9HNm8wR2FJNE5lcmpQdzdMOU1oeHk2ZDRMREJzZVB1?=
 =?utf-8?B?RjZ3Wm9nMEFOdWV1UW9OV2VZUkgvOSs5NE5RVGlwT1RGY1NrdUg5dVZ2NklC?=
 =?utf-8?B?ODRoalVORm1Tc1RZTWgxbk5meHpmaFQ2NlljcWJpTURoeGZ0MllVWDhpMnQw?=
 =?utf-8?B?ekJjSmcyWXBSOCtHckNpVS9NN291SnBSRnBZbVNpWFRMRHIzbVdJb1Njc0Rh?=
 =?utf-8?B?NVg0Qjl0d0QxY0dzaEJIdk1RdGQ1My85VXZTNUpMOExzNEV4SnRTU2JuMXpt?=
 =?utf-8?B?VFFsOW82NTFaUEY2by91R3JiYytNWHdZVU9KRmpkUVd0K0NEZGJaeEhvZlRS?=
 =?utf-8?B?OFNhR1BVWDhsUC9hRFIwUGNBbTVlUXh1VFJOTG5BalQyRHhudzVpYlJnSzJ6?=
 =?utf-8?B?MXhrbWVTNVRIWWVmUThlWmxETy9VMk9sRXBoSzRJOGwwZUd1TnBqNjBGbVF1?=
 =?utf-8?B?dThVUkFsK0dkdEtHcUpGaEE5aXpBdW1rbE9DazRwb3h0dEUydFpKVDI4ZGgx?=
 =?utf-8?B?aGkwWDRwMzdqb3ppSTRQNFJDVEJxN2FDalhVNG5JMmxsOTA5aUFJTTk2UnFt?=
 =?utf-8?B?aG16ZzJ0Mll6QkczVlRpc0lvclJFTUovK0hwd3R3TXViTkROWkhWWXhhLytw?=
 =?utf-8?B?cWdnUTlqeGxPd3NLV21TNjRtY2VYdmJqOEhxTVFHNmRDZURDZTFWb0JtQUZU?=
 =?utf-8?B?cTd1aGs1QVZTd2JvbFR4MmpvUGdwQnkvUW1JdWxSdDlqdmVuMEY1TkNrQ0ZD?=
 =?utf-8?B?UXFSNVMxQlhpdDFHL3J1eE84SmVyRjZqVzBEVVBWVWxVck5KTVduT3VYMmZR?=
 =?utf-8?B?U1BzRDNxVlRWbk4zdGsrM25OcjZBYkw1YmZnSGh6RjVuYmQzUDU0dmNYeGdD?=
 =?utf-8?B?K3Z1U1lDYmRFNWVsRFJUSnFCelkxSVRFYk1mUVREMXVqc3hUYWpsQW8wYi9a?=
 =?utf-8?B?YUVxOVNtdUp2eitDZENWMkZ2TnUrNE13MzcrYkFEWVBRWDJSKzc1bGhDUDhW?=
 =?utf-8?B?UzlwbGpxSnB4NlRaMlRxMmYvdFVVbVc3NGozSFMwWHowWVJxK1pnZzE3Q0JB?=
 =?utf-8?B?bVVBeGZRakFnenpUZGFwQ3pocU5ER0FNenNzcFN1QU1wc2pZNXFaZ2o4T3BQ?=
 =?utf-8?Q?c9VRtagLE2cIHcymo7KaCuV9X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61660e7e-acd5-4be7-505f-08dcbbed480b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 23:11:37.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUtQtYsjiBiZ6b3NnuqRh+S+fFgCvTc7zDfRPGVoSUgCcON5HXrx9EUfdDOMMbIfKNveC79ADM4ihkK9IATcXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7026
X-OriginatorOrg: intel.com



On 14/08/2024 5:50 am, Isaku Yamahata wrote:
> On Tue, Aug 13, 2024 at 01:12:55PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
> 
>> Check whether a KVM hypercall needs to exit to userspace or not based on
>> hypercall_exit_enabled field of struct kvm_arch.
>>
>> Userspace can request a hypercall to exit to userspace for handling by
>> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
>> hypercall_exit_enabled.  Make the check code generic based on it.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++--
>>   arch/x86/kvm/x86.h | 7 +++++++
>>   2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index af6c8cf6a37a..6e16c9751af7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>>   
>>   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>> -		/* MAP_GPA tosses the request to the user space. */
>> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
>> +		/* The hypercall is requested to exit to userspace. */
>>   		return 0;
>>   
>>   	if (!op_64_bit)
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 50596f6f8320..0cbec76b42e6 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>   			 unsigned int port, void *data,  unsigned int count,
>>   			 int in);
>>   
>> +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
>> +{
>> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
>> +		return false;
> 
> Is this to detect potential bug? Maybe
> BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
>               !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
> Overkill?

I don't think this is the correct way to use __builtin_constant_p(), 
i.e. it doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().

IIUC you need some build time guarantee here, but __builtin_constant_p() 
can return false, in which case the above BUILD_BUG_ON() does nothing, 
which defeats the purpose.

On the other hand, albeit WARN_ON_ONCE() is runtime check, but it is 
always there.

In fact, the @hc_nr (or @nr) in the kvm_emulate_hypercall() is read from 
the RAX register:

         nr = kvm_rax_read(vcpu);

So I don't see how the compiler can be smart enough to determine the 
value at compile time.

In fact, I tried to build by removing the __builtin_constant_p() but got 
below error (sorry for text wrap but you can see the error I believe).

root@server:/home/kai/tdx/linux# make M=arch/x86/kvm/ W=1
   CC [M]  arch/x86/kvm/x86.o
In file included from <command-line>:
In function ‘is_kvm_hc_exit_enabled’,
     inlined from ‘kvm_emulate_hypercall’ at arch/x86/kvm/x86.c:10254:14:
././include/linux/compiler_types.h:510:45: error: call to 
‘__compiletime_assert_3873’ declared with attribute error: BUILD_BUG_ON 
failed: !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK)
   510 |         _compiletime_assert(condition, msg, 
__compiletime_assert_, __COUNTER__)
       |                                             ^



