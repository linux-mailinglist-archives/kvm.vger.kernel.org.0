Return-Path: <kvm+bounces-26783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B622977855
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 07:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A11C2B24E9D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 05:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3655185B7D;
	Fri, 13 Sep 2024 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJPgctPM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D52A17D377;
	Fri, 13 Sep 2024 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726205364; cv=fail; b=Neg7m1tzxNuiXrImNVJEmOS+gMDL/KphfF77rjFj2BOc4+FDPp4HwZ7wZe7Nj3G1nOLRemv/8S8I6tsRe7dQaTIAiHsjpwEmud37i34vRTgiAGeCHBPiyw8AWTUWhxH8igrDoItRZOqpg6p06KRSiAPo5GK6BD3PPKNu8xabrqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726205364; c=relaxed/simple;
	bh=rb5cnmCHtKb0e/Rk0nsRao8ZKWuwZSIjMKxVrPrpD6c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ee2xbNr2QdtZYdx9OgT0BPlMDEYx6sMKXTL6bL9qDEYSawrprcddiSewfLvPmY7dZTF/UwkXL/qLjNAByxgbG2u1/p/DMmEZDl0n0t/LxLsI3CyEbdPOCPOCIZ/4+6jYvcpd+lVGEZTsJRY81+XqYILo2hMZrBJkGcstoW2XveA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJPgctPM; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726205362; x=1757741362;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rb5cnmCHtKb0e/Rk0nsRao8ZKWuwZSIjMKxVrPrpD6c=;
  b=SJPgctPMBJkYf231S5sKqIWDU1khVDz3aVGDB9KdOU/XBPOiSQwnkmul
   XNTU4jAlbfMYGV8vWKJtkiVyIxKjXSq6XX5oUOnfBCTJVpQ67DdU8d1Wa
   lwUauwCEOF9SXvQnSP3lXpGDYZBndLmoEqaV+Jq8Y9zsgnsGkfVqs8UOW
   0HOfy7MFeEiPsDlm4SMC/MKPYmM43kUCESepWqgm6cwy+/FZRTaJbyO1d
   TGW3OJ5cU8Okzox5MmNOD4iiG1iOhgcEsXzPhPOTpejyZEaX6Rvddfwb4
   o4kpxd7/flTFwPrj2tE7x0c5FZWsAfjq7FTvkzsRSQyEDRRU7/FXhrvpc
   Q==;
X-CSE-ConnectionGUID: 4I/Fq4zOSfqjI9Kvsw+A1Q==
X-CSE-MsgGUID: STABUqYoR6KYsEERW4DzkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="36471835"
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="36471835"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 22:29:21 -0700
X-CSE-ConnectionGUID: SgjzNb83Q+GN2CNItm/DAg==
X-CSE-MsgGUID: b1TZxvo1RVKxCE9YhYOWVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="68242359"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 22:29:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 22:29:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 22:29:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 22:29:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 22:29:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oakh/cKFWT4VnBw4b8e7xOICuBCWOKUXDAMoJx7BwQi/+BtvqUSDI98uMpvjMGOBUEK6aoztZGNucaXDGazmqIO/NFEJX3LRFHA2DH3+3hkd5sA3VT7pyYegeNj8PxV1oCvJ4GeS4qyqHmiqIV8O+7exC4v92O1U7ERwrGIfRiP5Hr0T1SgAoBHT1IbC1cHVsw9PVGsyS35HSjwcXiecUbg0KkkTBrrpeGt1ARcGvLYrdLEcaPa3PHT4eCVyfD99aSTo6wN9kGPewVvqQowirU5CRYhcEAZhjVmKwpVqUlATzY40MkjB+G7GE4oVgiBYvlYNetnUTOsWNmLVnqFSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3YY8c0ibOlIxpQNjDB4ll4DzuPm9eDVbygy9T16yU8=;
 b=qhBKkOWJEtSG/hxJSTzgt0P02bVqOoWSOmCDmssQdxJ3gqm55gbG5eKF6yx6aFjpjAeKueef4bWSK11uGwKy3osdDiAIpKkgNFBzJD4GNuk0Drq+ZULgtOWa1qfnKkUNCFQADGXL4cVmrWVBqjldLQDJ0M7IWHpfF8h3u4UvDqtV+nsa7hlVlPJujTNFsSZxQ4M2y3BbkNuZ0wCj1S8GblV2ZqyjNKGDtkC+bSFJdvqc9ttPPuufxlDiUqQZvNv/UgIo6USM4fLwavCb5yU8SMx5TkoO4Rg91gvnPptCcgaWlb9ovx/s8UWTH6x/vHADIetBj+eQLNAi0GSkI8QCIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB6819.namprd11.prod.outlook.com (2603:10b6:930:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 05:29:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7918.024; Fri, 13 Sep 2024
 05:29:08 +0000
Date: Fri, 13 Sep 2024 13:28:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, "kvm @ vger . kernel .
 org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <ZuPNmOLJPJsPlufA@intel.com>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
 <20240912162440.be23sgv5v5ojtf3q@desk>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240912162440.be23sgv5v5ojtf3q@desk>
X-ClientProxiedBy: SI1PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ad930b-c855-4e6c-4184-08dcd3b4fd93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1ZOM29WZmRlMXVKTVhGakY3QTJ4MnlPdlk0Qm05Mi9jLzdTeGx5aFZwU1cy?=
 =?utf-8?B?TzVxMEF4RWJEbzZMcDhiOUVjU0oxYkZNaTNaZFJwdW0vUkxqeldUa21DQXE4?=
 =?utf-8?B?cVB1MFR3TUc4d0tEUkwxSUkxblUzcjNXM1VTMkpzSmxodmQvYUQyZ2VPVVlW?=
 =?utf-8?B?WDFrdjBJU25hbVVWMGxBUnlJZlRMdVB6OCsvKzZ4MGJDMWt5ODg3NFBCZ0xO?=
 =?utf-8?B?bEZsVUsvQzYraXhlVXZyS1ovMEpKRTVLdGRySUs0SCtTZ3g1VGljRGpJQnB5?=
 =?utf-8?B?bEFmOU1jTVFqUE1UeWFmd1dCNk9LaHJWTEhLWVFaeU9SOTh1NUtmSzBRQ0tV?=
 =?utf-8?B?TDhHNEdnSVNEaDRUb0M2WXNUZ1BxZy9GUHJZSUdXMlhVeWZ0akc2WlRJcTFM?=
 =?utf-8?B?a2F6T0VXNEVWTGEvbzhDMktOZzJzWHFHcElmTXUzL25BZmRseGRlTlBwa1Vk?=
 =?utf-8?B?dUlOMTU1c2syUVdidXJHQTd5MEhFWkwxZ1V2MldZVjlncmNBSUdzYlVxWE9V?=
 =?utf-8?B?bm95d0F4cUVmTEppb0RybHBlOTFLbmFpM2oxN3JTcUlnVlphVkJIQkllazJH?=
 =?utf-8?B?aHNJS2MvZkV4amgzRFhpcGY4N3B1dWJ1ZGpXNXFrQXcwd0VrMHhkRCsxdFZl?=
 =?utf-8?B?eHExWW5CYzZRNzJIaXBpUkNRdURSYTU2NE13enZQZHJGOC8rZHVWS0RFcWNm?=
 =?utf-8?B?ZEY4NjU0b3dzTjVmdjFndURrc0lhR1ltZjEwM29DR3NaQ21wdVo5Z1JKMVpS?=
 =?utf-8?B?TWRKOEtGbkloZTY4ZFNSTVRHaDg2bmRlcThsV0FXZjcvSzdORG1ocUFVWDdi?=
 =?utf-8?B?T3lZTWN6WitkNHkzRmxleEVZYXRPcWhxdEpDY0F5K0pTcVM5V1lZa2RlR2Y4?=
 =?utf-8?B?a3dnMXZlNm9SL3lGS1RUVXpQU3hhd3BQOC9EUUNNQmRRcnRoRlBqLy9pU29L?=
 =?utf-8?B?TWtScTRSa0xTcEZXQmlxSE9rZ0ZjbysxYVR5VlJDT2kzUmZ0L1RheFdRSkdz?=
 =?utf-8?B?S2NUVXhnM1U3RVp4M2FKbitrU3hlVUVKUUZhR3JLRW10VUdGOTc1UnpLR2p0?=
 =?utf-8?B?Y28zKytuck13TTBPcWVCY0pMUUpiMjVocTFHRk1PdFRCK29ZL3A2WitIMmEx?=
 =?utf-8?B?V1NheEdud2E4ZExsMWFzdXFycGUwekZpVDR1dzN6SFVYS2ErZ2s2QnhYTmp3?=
 =?utf-8?B?SE9GdmloY2g3S2h2NHJnSmQ2MHNwZ1RxQkJOQnVCc05DQVpYMUE5K3BQNXlM?=
 =?utf-8?B?TjdCQllNMFRVUzNrbWdRZ253aENUYk5lcXBlcUZTZTVkR2d3OTAvZnZNYTli?=
 =?utf-8?B?NTk5STNYNWdBSGhGQlAyTDN5OUdyaFp1K0IvM0h1OWs1QzdQL2NBR01NMld5?=
 =?utf-8?B?eDcxVnhPWm5UdHZFNTByQjJ6VXpzM0tpOHRJdlY5UFhhS0dGVHNZdUd6WW8r?=
 =?utf-8?B?TlZFYlFOTERlSUE3RUxmYzFSUnpmV0ZlcjBuZCtHTkJnNThnZDhkTU5UZjQ0?=
 =?utf-8?B?WFFhUjJLY0hHRElSMWV5ODhHaFVmOG1mUmdFNU5zTWJJbzd6V015bHpuaVpr?=
 =?utf-8?B?R2V4bzdVK1NwQmJMS0VQdUU5ZzJwVkxjVG9HSVR3b0w3azJiU3A2dXB0UmFX?=
 =?utf-8?B?UTRodk1Da1RnMnI4NllHZ2pPdmtDZW5nVHoyWGZIQ3YwRVpUSVl4R3AxTkY3?=
 =?utf-8?B?RVJRNXU5R29WWmw2elJ2N1JoRkdnS1hDNE9yQTZyVGMvMlpjNitZSW9KVFhI?=
 =?utf-8?B?WEpucmxsTHNvQlZiMzc1WFRTRjF3OHhoRmdaS1d3d1BtdXlKbnAxZkx1K1I1?=
 =?utf-8?Q?Esah97Gl171EPMaoje/j9XezurTrNYaDXeC6k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckRjaGgyQ1FuNThpUFFmaVpuejFlbWtrL0dBd2I4YWlaNEN6SGk3TWVUZmZm?=
 =?utf-8?B?L3NDNUcvUnJpclQrcmZjNEQ0QnNmeVFYZFA0NkZyYXA4NnJyemdkNGJMYVZB?=
 =?utf-8?B?L2pUTEZCZnVGQ1ByS09CYkR5aUZ5Wm5NUFNwTmpaZGVsdWh1eTRyTUE4c2VR?=
 =?utf-8?B?Zk9QSkhkb1FzT1pPK05DZU56K01MZWhsVlo0S0lRNlN5RGVjNUhvS3NKSHpN?=
 =?utf-8?B?Q0J1Y0N2TFlCdC8zYy8yNU9rRmhHd25VaGxtVlNQN0R3MVg3KzRIM2JIQjNq?=
 =?utf-8?B?czUzZDVHUEVadStVbkpkVVN4VExNSU4zc3FDR3daN1BjckF1aEZpbE9jSEdT?=
 =?utf-8?B?UFhBOHFaOFFjQkRaVU95V3hWcEcwczZHa1pGeVdLbjZQNGs0bmNNbUhlcDZR?=
 =?utf-8?B?TnI2dSsyQzAyYVNWekJyOVBJVGRwUlp4TE8yeWtMd01pL0VGK0taQmczNlRG?=
 =?utf-8?B?K21sUS96dDdKa3Fubk5xMGc5M0pKd2FXVUZaVVA3S09RcTcyWEgvSjJEQjZy?=
 =?utf-8?B?MVFnUm15eWhtSUFjYWdHUzA4am5NWTRTQVNvSFpFemVscEpLR2ViU25hWE9x?=
 =?utf-8?B?MEN2TU5RZ0RYaHJkU3I1OFBWSG1pUG50QVpUS3ZjMTVuY3F6eXFJNmRxaXFn?=
 =?utf-8?B?NzhESGQwZWR0Q0Y2K29wOVpmZW9SM2pveVBRYlh5d3VtTDdSdCtPbDNWb0dQ?=
 =?utf-8?B?SnVWZk9rcHV2VllEdXBNWWxSbEZkVXZNNzFaa21kQ1FZVm1kVFZNTkQ5VVBP?=
 =?utf-8?B?bXVONmdPbUlJQ0V2UHFXMDVDa3Z5ZTRJQk5JUDFVdVRhdWptQUZjeCsrdHlI?=
 =?utf-8?B?ZzZCcHF2Mlp5YW0vazduQU5lZHQxSDMvRFZYa2N6QUhweGxTY2NHWmRyTWdw?=
 =?utf-8?B?eW94SGJXQklaWWdPVDRXNHJmSS9kd1Nya0EvYkxYN3g2bGducHU5b1dBcmJW?=
 =?utf-8?B?UkZmVXZ0bmhGbHhLSWpBNkhnc2VDZVYyenJuc1V6dEFrcnJtNXNpZ0tOUGdt?=
 =?utf-8?B?OFFGU0JjYy9Hd2JYMU5BajFqY1Q3aFVUZmNBQzFoNTgvS3N1bkhGMjM2MXJB?=
 =?utf-8?B?U2g5ZDR6UjdTT1VSdkxwcHltUC9lblFFbWlqbXkxQVdaVUt5MzBkS0NKcm9Q?=
 =?utf-8?B?dzVDaTV3aUFlUmRhckpkNDVQY3dveitORXQyQmtvRFM4YjZBTzloQmtrR0tn?=
 =?utf-8?B?OEJydzhlWWxhcG90R0pDb3JvWlhNWnJLTFJSekpSWW44bkN2Nmc4NnZRQWJ0?=
 =?utf-8?B?MjhXdXRXTWl0QllrbGsyTVdmMjlFeFJWMTN6V2sreHk2R05DVlVaSml6bEh0?=
 =?utf-8?B?cFNKOEVxcHIrMjRITW4zU2ljTnlnVWlFQkZRZHpiZS94TTQ0YkJpWTRBUGJI?=
 =?utf-8?B?N3RSVkZrWFh5R2VvQzFCZndDUTQ4QkNXUDJoY1VubzFTaFR4SFBBeGpPQ0NG?=
 =?utf-8?B?VUgwMXBwZzlzaTdVSEVUN1hqTnV5aDVEVi95UjdWZmpQdkZFK1pTTkZSMTU4?=
 =?utf-8?B?bkhoNU5ra1JDbVA3cjEyNUFSblNGcDhsTVlqWitJSmdzOEJpME5PQ0dqcGZM?=
 =?utf-8?B?N3pUZDJ6dzU1Q2ZZRyt1VXNnUXozd1VEcGsveDBGSTJjQjMzKytvcjRHbnhv?=
 =?utf-8?B?Q0haamF2TVhLbk1mczNGRGR5V0VWc2dpaGtBZGhscE1jaE1nRXVQYUJ2aDlL?=
 =?utf-8?B?bGdaY0lKeTZRNUd5bm82dVgvMHJEMmhhUm02di96aXZ1aHVEM0RZOGppSHd6?=
 =?utf-8?B?OTFBSDFPbGxrOU1Xa3JGd294NUR0WHlvYVJsUmNoWG9HczNPZkJuYzUrN3Fw?=
 =?utf-8?B?QzZMSHM4NzhLaDJqQTMxSW82VVdkWEgxaTRvMzFQQTAwSjV1bHpRSjhGQXl5?=
 =?utf-8?B?M2lLZVMwTHRtMklPL2pYbkFWWVMwLzZaSHU5b0JnSGVlT3pwTWxhVUZMajJp?=
 =?utf-8?B?VTZPeTF2dkY0OS9DZS8zSVFFNWY0d0VuM1E0M2g0OHo5Q2tpaG13c1pzbitI?=
 =?utf-8?B?UDdVcjJuTzRqd1pjcmpRMmluNW91QXpXaWQvOUJ2LzRDSjhCcmxpVno3UHQr?=
 =?utf-8?B?azZRTWFUQUVjc0hoajZEMEJ2cWxNLzJXSkNuOWpSemI2ZFVJUmpZTnJFUm5i?=
 =?utf-8?Q?dK22dm6bF2J7JQQXyIjZKO/u7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ad930b-c855-4e6c-4184-08dcd3b4fd93
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 05:29:08.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3t4Ob1BpnClBLvtNMgHxjawHlQoyBGslvAkgLEQGGpYQ+lLn7ZCai4JcfQ7CFGfxdHAFIhyzkPfDusVSTjFIoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6819
X-OriginatorOrg: intel.com

On Thu, Sep 12, 2024 at 09:24:40AM -0700, Pawan Gupta wrote:
>On Thu, Sep 12, 2024 at 03:44:38PM +0000, Jon Kohler wrote:
>> > It is only worth implementing the long sequence in VMEXIT_ONLY mode if it is
>> > significantly better than toggling the MSR.
>> 
>> Thanks for the pointer! I hadn’t seen that second sequence. I’ll do measurements on
>> three cases and come back with data from an SPR system.
>> 1. as-is (wrmsr on entry and exit)
>> 2. Short sequence (as a baseline)
>> 3. Long sequence
>
>I wonder if virtual SPEC_CTRL feature introduced in below series can
>provide speedup, as it can replace the MSR toggling with faster VMCS
>operations:

"virtual SPEC_CTRL" won't provide speedup. the wrmsr on entry/exit is still
need if guest's (effective) value and host's value are different.

"virtual SPEC_CTRL" just prevents guests from toggling some bits. It doesn't
switch the MSR between guest value and host value on entry/exit. so, KVM has
to do the switching with wrmsr/rdmsr instructions. A new feature, "load
IA32_SPEC_CTRL" VMX control (refer to Chapter 15 in ISE spec[*]), can help but
it isn't supported on SPR.

[*]: https://cdrdv2.intel.com/v1/dl/getContent/671368

>
>  https://lore.kernel.org/kvm/20240410143446.797262-1-chao.gao@intel.com/
>
>Adding Chao for their opinion.

