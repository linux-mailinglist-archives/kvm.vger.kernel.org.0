Return-Path: <kvm+bounces-16977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 320B08BF6AF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 09:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F002B22477
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 07:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11FA2838E;
	Wed,  8 May 2024 07:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n6GCa3I4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E497025632;
	Wed,  8 May 2024 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715151628; cv=fail; b=gN3TysaedkUiIIXYw92RIvMAGVlOHUdIOdj+diarg4I+awVoDwWcbDh9E4uvfOqsudw/zhpxmh7J1e+iMQYqdVnJHtV7B2xx5gCp6vJ6IqMYQ5shCQjMEwdjoMF102aM3DtZuVXmOM773dVK+vlL619Q7cBauCGsX6eYKtJ49Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715151628; c=relaxed/simple;
	bh=FCueRtO6Kp5Cv8CgxBItMXRV51zDRays51t2ubsScRk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gn1mCsKzX6zlEj5mgF0hcxHRrnozZ75BBItQi7V3SUxolb8nvj/0Ra8+nOWOKkF5NSid+5cbbrVOW8k076NaGDmsc9BGrZWaXhtdAP4d/sBJraHcvx1/rjnSCbAy+eVLGmyeKCAAEmeD/8y2KS7iJa4ZBaarvjyY+FhR2i+c3Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n6GCa3I4; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715151626; x=1746687626;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FCueRtO6Kp5Cv8CgxBItMXRV51zDRays51t2ubsScRk=;
  b=n6GCa3I4bv+1ovx7bO1Y3c7hNyHtzG07xTleLuzEG5o9tI8Jza54gGz9
   NZjd1jQEhpmGG+HpcRgdPeEPgMykdJdMCbJ4MUAXj5o1hxz8Y2idgTJp0
   sTCOJxh2gUHL61x9Ry3SGkkJ25VyobtL1FsPgixxInO/iyHf2ughWreuO
   pStSIZ/Zup9HRyOMZatdaRXFIH6Ul+QEpL2hwwWHp3ES6bQBY4JYP61N1
   XdNGVaF6NQy0YDidyOtBmpWc8tOOnSAjGrCzBiSyYkGZ2lXAoe+l/30tC
   1oNNsG8yPObpftt0Cu67k172DBKnoh8Auz6LEUvTlz0ZVhJFAwepyt1Xi
   Q==;
X-CSE-ConnectionGUID: iQFuOAzDQ6qgd0Q83Cyy1A==
X-CSE-MsgGUID: eU0Wwd8/Rtqu+GoIII4aGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10927570"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="10927570"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:00:26 -0700
X-CSE-ConnectionGUID: oGvYpUjQQaylPBoRvhJOZQ==
X-CSE-MsgGUID: /PugYiMFTAWiaHvNMxrO4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="59642427"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 00:00:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 00:00:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 00:00:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 00:00:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cha/WsaxGq73cDm27//DonnhK3XK0FJeh8n3w2Vh25B4MTC1SJHSKu1FgCknTbLOueBoUQHIKLZuwpUNRsHApuC1xUEmnO5IUENlba+67R94HZfmCHZLeM1tbLtddi1+8dnQ7XO+ZSRDNIEf2xDCO7F2HRZendswJ7r0UL3VsOsayAOk5PnCZlXUz4hZuwjx//LiBOQlO5fKke7bf7wYU3WrPpVGOBfulhBcUDbcTP0NjjClM3wemz7zVW0ISka/JYu1twAB7/cQjLv0i/eJAMkdHSFvyh9C9xGD7ggyhWpcehTr4LnB4IU7kjgjvTuJ9t4aU+TNpyl98JUZwSkiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gvg61DchbtxHXun96jskfmn44vIFMDx5vaRM8S9nrdU=;
 b=LCXEOBnoeCV+Pd5bci6uGxbceVhAkv6jxwHetdEm/UIJogJ6SkHFk4q4PZzQU/zrIgr2vKpECI4kAgXwo8aG9W+1CRcSWHwxNOOYmbG9gTY7kxRrTG6JXKEkDALiiv65NFnRN6SpTMLOM6tW5imV4zzD2bMbrNvJNonpqzxr/IyYF5nVO7LSqrT9kuO6UzZlpJTQ5nuPyhgkaqsJ0p1KhK7rzyZcZyyGnJAY6+JQx2BFhd/9rwqw7Qt7AdCMzDEtdPqwx19C7ATyW2c0mE0hghE32amW7AoHWM8KDiWeIIA11IFQiLCGXxKE+XR/OA9zigvXFKCEh9+3+rE+6XzAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB6152.namprd11.prod.outlook.com (2603:10b6:8:9b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.46; Wed, 8 May 2024 07:00:22 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Wed, 8 May 2024
 07:00:22 +0000
Message-ID: <5a8c31bd-0fe3-48f2-8ec3-b143fe289827@intel.com>
Date: Wed, 8 May 2024 15:00:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 17/27] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-18-weijiang.yang@intel.com>
 <ZjLE7giCsEI4Sftp@google.com>
 <4e034aaf-7a64-4427-b29d-da040ec7b9f0@intel.com>
 <Zjpkl0U23qEOO3DY@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Zjpkl0U23qEOO3DY@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0141.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 779171b1-e20b-4cf4-d903-08dc6f2c86e2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2RNZis1RW43b0ErRW1SOEc0ckxNWExRakpNWUkvNjVTVktZQmRQQkJDV0Jt?=
 =?utf-8?B?aks3K293RVFaTkhITFBYams1TGI5Vm81YjllOUdEalBQWWJjZmVTMGhDV1RJ?=
 =?utf-8?B?NW1DYjlpRmgvUVR6QnFoRnBTU1JVWDE5WTMvZVF4dmVSS3NySGxic041Sktv?=
 =?utf-8?B?QjJCVEkveitnYUdCOEZQSWVHc3FTS21jU0wzNmhuSFFBU3dkV25WZlVQelNU?=
 =?utf-8?B?MUNtZkx2ZHU4NUszSGxZcy94aXdSelhpNnFiekZCdkwwMXE1WlZDZHZQdHM0?=
 =?utf-8?B?T1U3bkU0UXZ0eEtBcDdOekZVbjRPL002WjRueHdwS0pIZlpJajVzdkpibGVt?=
 =?utf-8?B?UmgwdXpMenY5SUZjWVVVaWwzQzJ0TFhvRHZTdkEzYlZVaHNlQTcwQStLYkwv?=
 =?utf-8?B?SmJ1VzZ0N1Z3amhBcmJtZGF2MXFEVEw5bUFaRExNaXhCRlN2cnhsVzVDQjZK?=
 =?utf-8?B?YWtHRDJMK09kczh1MFBkYXBMQkpiMFlUdkZVUzlmQ3RFUkFXcktxRzNvaWh3?=
 =?utf-8?B?eEVFZ3BtQnF0NnpyMG9JVzdUV2RhV3kxM045Qkp3YUd0T0JoeVFORzJHeHRT?=
 =?utf-8?B?V0NZRkozT21jK1F5alJHVnJERjdsTzQweDgwY3F0MWVLUnlGbGhpbTRrUSsz?=
 =?utf-8?B?RGtzbDB3aUFjZEhROVFDTXpRdmxBTTNxOUZmVkpHS1FWd1FVajZaNjV4N3ZM?=
 =?utf-8?B?S0R0U2Jrd0tKWmdVZlp6Mkc1dy9XdGpLcWN4Ukc2a3Zvd1UxaGFzaTg2V1BK?=
 =?utf-8?B?cWlMRGQzamM3cjNkdUozbWd3bURiSDd1SDFXR2Radko0dXR2c1l5eVlxY0xw?=
 =?utf-8?B?YWh5eVNRMmNoNlZ6YUQzZnlUZmJvbHhTblJFV0ZyaXJhSGlaMXhoVCt6Rm11?=
 =?utf-8?B?bThQREJUbGdPQjAvdnBPOEdTbExnTTY4RWs0dHQvSnpnbXl6YVJXeTVtek9S?=
 =?utf-8?B?OFNNR0ZjYTFvOE0vUi9JNWQ0amxpd3A5L0l0Y3pBK3kzTWY5NWdzZEFIeHZW?=
 =?utf-8?B?NEpVejVyOXNxNGhKREMwUVpucEZ0SE91M3duRkVXaytHRzd4dHo4TGk3bnBi?=
 =?utf-8?B?QXc1a0VkaXdZSldtSVBYbE9wT0dJbmJpMTRTb3lzdHRxcjFlUzh6VHJYMC9S?=
 =?utf-8?B?YThuTUx2clJFSEVwcmV4aHFQVjZhTXpaWkxHNkRnL0JwMkhWN0VLYlRZTHdx?=
 =?utf-8?B?OFEyU2N1enpNWldoOU9ZaHpFOHdnV0hWRldZTXlzMTQ4VEhTNG45MnZhMk51?=
 =?utf-8?B?TFRySDluelZWS2xoMzZHZ1VnY0ZKZEo2UHdoa2RlNzVJQWxZS1RGWEkyNVE4?=
 =?utf-8?B?YkZLNlJtR2Y0NVZNVTJERnZTSnpXWldpWm11azY1STJ2cFBmS2FTR1FkRFEy?=
 =?utf-8?B?bTFEc2VwS2VjejFRdTNMMk1UV2NZQzVsZmg3SDNtdkZLSC9adDA4VGVDMkZi?=
 =?utf-8?B?Rk1RMS93RUhjdDZnQ3JtOGR4TmRjeUd0b28wTmhQRHBQUUlJVVBEVkg3T0pt?=
 =?utf-8?B?RC9GV25naXZSMkplU3JDV0ovTmhnNDlqTHV6TnYxVHo2QUR3RGN4eDZ4SGdr?=
 =?utf-8?B?ZENzWTRDQkNoYTVFZWZub0YwK1N5T0VxRXpUTndaM3FpZEU3VXZMY1lhK0hm?=
 =?utf-8?B?S1YrKy92VU03T1BJWG9QODFiTmMwUGRyNjBNYVJJcGljNm5zS2xiaVNKN2Vj?=
 =?utf-8?B?ZTlUTlFRRnJRMUtZZEZ3eU1hVm9RcjNYYkFmeWRwUEJGZFprWDhUdURnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0dwOS9HT1g4UHRUVkpQVVhNM1FhT0Z0T1VYLytlUGx5R2FqcmR0azl4Ti9y?=
 =?utf-8?B?S25pTmJJQVhiNlVZQUc5OUNGRndCRm5ZWnJxMzJpNlRwdCsyMXMvNk9uU0N4?=
 =?utf-8?B?SkFsYTZWNzJnYkdBSDU3NlU3dWEwQ0tYT3MxZmpxY2QyMTBWaC9Xc1h6ZktQ?=
 =?utf-8?B?Y3pqR01MbGJLOTNvKy9laVdEK29GQTRCS1B5Z3FsRlErc1E1V1R6WHN2b3lQ?=
 =?utf-8?B?LzVwMVJMRGgzWDQxVUVlSFRNZkRFMUdiZHhEdE1BTm1xNnFpS0ttS3REaXNl?=
 =?utf-8?B?TFJnT0dValZMcHEvQ213eU5xaXI2dWdiNUVaY1lCNjhJRU1nSVozTTRxN21H?=
 =?utf-8?B?OTk0T2cvTkNwUC85VmNyTm1tSHQzYjJSZUErL016SGNRMXI0UkQxNCsvZjIv?=
 =?utf-8?B?MmJ5c1ZXQjVERXFIY2lvUmVIc21zaGk0aU1adWVyMHZMWlJmNmdueHlBNjJp?=
 =?utf-8?B?c0VMNGVwRnNkOFA5WGJyMWR5VWtFM3ZFWU1iV1hPTkdPNU53V3pubWdnb2lI?=
 =?utf-8?B?cU10NlU0Z3lqdWF0MDJvMFhPNWFqS0hEY0FyYkVQbXUxcVV0YkVXdGxmSFNR?=
 =?utf-8?B?Tjh3MjFZb1NpT29OSlZnMWUwMUZvVW90ZnVHQ0djSk5TMGhpeERYellYdS8y?=
 =?utf-8?B?RFRkcG8zelJ6NEpRaWtRRkQ4cWVwc2RYcGxtOGpNTmQvNFJxRXpkMzdxaW5F?=
 =?utf-8?B?MUV1amVsOG0wekZ6SFMxdWdFYVRMaFlJMDdETVhxeVRoRDdPemhyRmxNYkwy?=
 =?utf-8?B?YnlERGYwQ2xaclovN1M3T2lnMVZ6M09YdGI3NXQwWkxMK2FCTE1waXY1aDlE?=
 =?utf-8?B?R3doblZPVjBPTkdCZXIwVWp3Rm5LYmpKVmhOWmNJK1h2d3pCeG84bzZVNWlX?=
 =?utf-8?B?RTRnTnJOSm82cTNIRFVEMUxRTWdVc2hJTlJOZklQWFRxY2MreTBINkUrSFZX?=
 =?utf-8?B?aW5PemRmdldaMVNLcGtwOGgrSy9OTFhTdGdNQ1RwUFJkNklhUnN6ck5iSnhp?=
 =?utf-8?B?V3AyN2cycEtPY1J5V0xmNlBodTZJZERKS2FKOFNaQksyVyswRTM3STlDT0lM?=
 =?utf-8?B?S2lTKy83cW5YaG1rUmxOS2g5ZGE2dy8xd2RIejkzbUlUbC9ZZlZ4aDZtUDh0?=
 =?utf-8?B?alBPV2lvUGw3anFiL0RtWnNjL3ZEdDc3VEE3N1p5K3g1dUIzMy8rZ1ZlUnV3?=
 =?utf-8?B?SU5BWUFWTDNtdmlUS2hCSUlLSWtzUXhDOEdNaHhJK09INzVCYzE1Q1gwNVpM?=
 =?utf-8?B?bkh1NW9aY3loZ1cyb1JjTGpLcDQ3WGdjUmRnWW5kcXZOdjRpV3ZkZVZtcGNs?=
 =?utf-8?B?aGpSZzFycmRDOU1lQWJqSlNpazZ0L0VVbVZuOTk0YVlzNGhUT0lmZjU4T1Bm?=
 =?utf-8?B?dlUrWG9DZ1o0OUxscjZHSHFqdVVzV2dwcGZod1VYTy9oNExnOHkzT09WWGE4?=
 =?utf-8?B?YWpvVXZSa3h0L3daanJjT3pCTy9vWUxZUDFJa3I0a0d2NXgzUVZ2RjZvVUVP?=
 =?utf-8?B?a0lMc0ZrZTR5aTdYbjJ5NDd3bVN4bXlQYmdFZzJweXloaWsxdS9zTGIwYXdx?=
 =?utf-8?B?Rnd5WUNUaUgzL2JsR0d1SFpxTGZ3MDB0dFBRUXc4MGFwaVJpanZwODhrUjlX?=
 =?utf-8?B?MVh0ZHdYVy9iSHlCdm9JT0tYTTVOeTNGcGpLL2ViMDE4YjVBc2RlcWc0clMw?=
 =?utf-8?B?TlhLdUYrcDh3RG9PWElLM29nemtQeGJYemFTeVJ4OGlLRS9FZXl3N0lEV1Qz?=
 =?utf-8?B?ZExvS2pKd00xK2pObnNwcVloYTFYbEZVMExyV1VvMVBjQTlEUExnZXlxdm5D?=
 =?utf-8?B?bzZUREltcUJnMXF6RDRnTUV1dDYyK1JiK3l2bjVsSGNGbDZnMjBnYU9UMGRH?=
 =?utf-8?B?dkN1dEh6R2hrY1VKcHBRT29yQWE2MTZ0dUEwMEFzMGcySEJTeS9ONS93cnpy?=
 =?utf-8?B?elA0dER3MEtWUUw5NEhLbFQ4UGdlall6bUF6TlJkUnhlT0hTTzM1emN6dVVC?=
 =?utf-8?B?QkI2ODBoMkxHRDVwd05lVUFFWkhERm5lWndFNkVyNFRTNlpUWlF2cHdweEJy?=
 =?utf-8?B?bDh6ZG9OajdNZmZOUmhiRjZ0dk5CanBYWU9qZGNIOEtBbWE2OUJFazRKNWZP?=
 =?utf-8?B?S05CWnFSUzgrejZzMi9VZTJFY2ozQUwzNWhuNEdXdm9sYmRqM2tpUi85aEk2?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 779171b1-e20b-4cf4-d903-08dc6f2c86e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 07:00:21.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TA9OO5Ij9nSx94v1eSGZwKxwVy/EdCucoU4GGTu45lBVDk0o0thIFO8TzURyfvHunv73AF9kDiQig/eBXUgcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6152
X-OriginatorOrg: intel.com

On 5/8/2024 1:27 AM, Sean Christopherson wrote:
> On Mon, May 06, 2024, Weijiang Yang wrote:
>> On 5/2/2024 6:40 AM, Sean Christopherson wrote:
>>> On Sun, Feb 18, 2024, Yang Weijiang wrote:

[...]

>> For the latter, IIUC KVM still needs to expose the index within the synthetic
>> namespace so that userspace can read/write the intended MSRs, of course not
>> expose the synthetic MSR index via existing uAPI,  But you said the "index"
>> exposed to userspace can simply  be '0' in this case, then how to distinguish
>> the synthetic MSRs in userspace and KVM? And how userspace can be aware of
>> the synthetic MSR index allocation in KVM?
> The idea is to have a synthetic index that is exposed to userspace, and a separate
> KVM-internal index for emulating accesses.  The value that is exposed to userspace
> can start at 0 and be a simple incrementing value as we add synthetic MSRs, as the
> .type == SYNTHETIC makes it impossible for the value to collide with a "real" MSR.
>
> Translating to a KVM-internal index is a hack to avoid having to plumb a 64-bit
> index into all the MSR code.  We could do that, i.e. pass the full kvm_x86_reg_id
> into the MSR helpers, but I'm not convinced it'd be worth the churn.  That said,
> I'm not opposed to the idea either, if others prefer that approach.
>
> E.g.
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 738c449e4f9e..21152796238a 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -420,6 +420,8 @@ struct kvm_x86_reg_id {
>          __u16 rsvd16;
>   };
>   
> +#define MSR_KVM_GUEST_SSP      0
> +
>   #define KVM_SYNC_X86_REGS      (1UL << 0)
>   #define KVM_SYNC_X86_SREGS     (1UL << 1)
>   #define KVM_SYNC_X86_EVENTS    (1UL << 2)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f45cdd9d8c1f..1a9e1e0c9f49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5990,6 +5990,19 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>          }
>   }
>   
> +static int kvm_translate_synthetic_msr(u32 *index)
> +{
> +       switch (*index) {
> +       case MSR_KVM_GUEST_SSP:
> +               *index = MSR_KVM_INTERNAL_GUEST_SSP;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>                           unsigned int ioctl, unsigned long arg)
>   {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index cc585051d24b..3b5a038f5260 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -49,6 +49,15 @@ void kvm_spurious_fault(void);
>   #define KVM_FIRST_EMULATED_VMX_MSR     MSR_IA32_VMX_BASIC
>   #define KVM_LAST_EMULATED_VMX_MSR      MSR_IA32_VMX_VMFUNC
>   
> +/*
> + * KVM's internal, non-ABI indices for synthetic MSRs.  The values themselves
> + * are arbitrary and have no meaning, the only requirement is that they don't
> + * conflict with "real" MSRs that KVM supports.  Use values at the uppper end
> + * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
> + * will be usable until KVM exhausts its supply of paravirtual MSR indices.
> + */
> +#define MSR_KVM_INTERNAL_GUEST_SSP     0x4b564dff
> +
>   #define KVM_DEFAULT_PLE_GAP            128
>   #define KVM_VMX_DEFAULT_PLE_WINDOW     4096
>   #define KVM_DEFAULT_PLE_WINDOW_GROW    2

OK, I'll post an RFC patch for this change, thanks a lot!



