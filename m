Return-Path: <kvm+bounces-11480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9561F877964
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D2F72815C7
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064A7EBE;
	Mon, 11 Mar 2024 01:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyoRNuSQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A202F622;
	Mon, 11 Mar 2024 01:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710119168; cv=fail; b=MYKH9ntRx2SNrcaOvH+d5kN7Sgfz9knLBFwrmOJpRT+bBC6V6/hCc2VkuhSlwaroikkHNF8VKvXL9Q5FMEy7a95a6W6RglguVM+npEuTVGqrDDuJjohg/DTqoYrT9tbMzQ68eh0/kfzm/8yWIK62ZkdLTYUWxJIgwN5/Y/zUKn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710119168; c=relaxed/simple;
	bh=OONRVkX0PZVJ4PuoJmZtdp8alj1Xdr+R0qrqblqJmGw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HJxFBvgnRWp8xH0o6Vf6nQqEMGGeHrp1Z6fz++31L/L8VBMEue5veKvA3n/GPb9ZUf/n1Ei6hYkU9by+JOqTPjl2jzYqcEjKWFycm35aJPEWtqF5TwHXjPQQVSLcVTsejogU/90hC7CMtaDjnftdjl0RO5diyG1EDO9W3HUmkP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YyoRNuSQ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710119162; x=1741655162;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OONRVkX0PZVJ4PuoJmZtdp8alj1Xdr+R0qrqblqJmGw=;
  b=YyoRNuSQBlL+P8l4ja7RuBCR03ZjR58YXcRTCu15zYgoDECcYqUbCb8M
   Fag06rwMNtQHrtawW6WMhffadQpZHjpQqX/C2f6ZIQMum0GkZ1L13gJtM
   Ol/aO7uatjjLDZPwe7UEwWBfq15kRW/xyHdEfn3Z+Rae03AlibeW663Z+
   JR3eAaQqH5qIC9zr4vT4Jp7PWX+ehMdWi/f9zpwVgaIDnu3+raA9E76++
   uZ71JhasbzpyFA9KwuHvD2vmIlTx4zrTlPiWNdUMyByDafFhoRPEdQofi
   h/O74NJcx1mWFvPqmrnketPZgSHCNqPoVvAadVLb7r1MeRXPhVQL+VRpM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4906614"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="4906614"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15568992"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:06:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:06:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:06:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:05:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:05:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUBYsL/B8we2IG32W3WGUmYpA6i7imsF2F+ORpM6lz67naBCPn+pVRkFSMm0RD9efaczgJuPXEyx9C3y4u7Gs//+viek6GbdvZZmwITItGKiKzi8vmUhiuIXAPMjvaGo3pF7s9KX5wLV788o3phyIFEcoGTx7FFjb3IdUax1FDuH5FAT80fu2z86z1+DD5DEWJBVoAoWwDduTrpEIfXBxU6bVzg70j1qdW4sC38y73JEw+dvRSKBgg61OJLEL1ajexfxJhdL+qZCwdw5zQLYDIQ9Y1Vvpc4O43mzhhEhGKjFoAFFLHiTfRvwve+qpUJXbbq/eydAhwb190wO0E7LLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8evOOAg713Yk/Soyji1/t+50w2roVIulAdWMO+N+kI=;
 b=DkVrgjNNAHnrwc93ucCwkQXaW8PYBiREmPF3c2o9tUiCLaT5n3QeskwT6/0PYp323wOdV9xjNZWlEJKfz1i/Jw7PL9nHI/QYfAD2IQrKTnKKdPxDD+Xx9Vxs4ZZ06amkYckhKpdO74l3lUQEIjaGqdKyC2u5M884YFVI7Tyc+toHQXnJ+KVEpomasdbP70UbhbtFvbFccGNlTOrwgWDv3Vi7uWwo3p8lwp8pnRNDNBWDn2bHuziKgpTbQoTQk9rBd9yghVyUuYB1ElSqlzCJooNDBNCyj35FXMy+r8YvUTnjoOlUmjnHqwCN5Pfb61ifJC51pIGhuIWkaoUBghOfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6441.namprd11.prod.outlook.com (2603:10b6:208:3aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Mon, 11 Mar
 2024 01:05:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.014; Mon, 11 Mar 2024
 01:05:49 +0000
Message-ID: <296e1196-9572-4839-9298-002d6c52537c@intel.com>
Date: Mon, 11 Mar 2024 14:05:38 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: David Matlack <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com> <ZepptFuo5ZK6w4TT@google.com>
 <20240308021941.GM368614@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240308021941.GM368614@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::16) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: e87fa1fb-d0d7-41f1-ef20-08dc41676416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8ARH9UaGGqVwmJAZh6IxzzK6VGcwzrvAuZXpf0yInioUCbFvM0Ylk8o0OEz92YtDjpOnit0LJlSCYekV9TkSZFvvzA1YZaAr2Vf1hSBA5pHCQBHbSPBr3yOWjkdmj+tEdgOuLrXJBprD6d0gUDLFbKdqXVTbvNs3paakw/8fo94CbIge9szXDndPwUQ9TbS1BJpqP0gm/b+hgJHXotEBS3bcgCYPAYLICBBHlmMvNfoyLtjf6v2a/qS5rc70hi4SMEyvfplA6oAULfMUs5gJgbgd5VVKMm0oXbzv8Uviakx8mbtWBjyek7fbxO+3Ns8QPBbGmHD2i/MlVydrkgEwWIc0OvzxcSKckeRB8NRTQOjoMo55Ce0fkNqQcHJmVwX/pP35ufTJm7enG6Aezyg5Dxam++f8gdQCDcbr+aAuLBegmAY8D4btSsBTV0vRySG5c8/AAhxkCzVELpetmRXYxtcu85o9OXXlXl63URzo9DG7bmyhn2BQTXYLztUhbNxULgWiJoOT6nCn3lU226hg6Idd+UtUnD6nJp/b8R3/SL+P48LZxqTrQXAoJ9zh1lOV91lIcQyqk7N4+b6vNurkbWvcuPP2ABpidWYyrm/tfwgjZP6w9hMNHX6KJScN43GW56CRNpvkaLS7CI2yyyJBVJoZqYBfk+TwPSSBXHdfyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmNrQXhwTkUwQVp4K1hHWFR0UzdoeDdYS3c4SHlBdWhyRWpJcFdwbnhtbnd3?=
 =?utf-8?B?SkJCY0Irc2svMXRzWVlxUFBOcTNkcEhFZHIzMHpHOWZmYkxmc1J5RnNJQ0VK?=
 =?utf-8?B?NDZ1NjRiaXhkV2Q2dmdBbU12bHI2RlVxRHR6NUg5UjBhUjVzSE5qbG9XWjRH?=
 =?utf-8?B?TW9yTEJHZDJGMS9iQ3hEcE5NTWIvNEdBQVNuUFRTaEx5eXlJQlRnZU42Yk1q?=
 =?utf-8?B?SzQ2MmxvRFdKU2N4dk0raUFxKzlQeXVkek16ajZaUGVuNGRqTUxVM2FUR00z?=
 =?utf-8?B?RDQ1cnhkdS9PL1JiV2ljU3JFRWdXdlozd0R5NFh6emxtWkY1cjFDM1FPVmpz?=
 =?utf-8?B?ZU9IZENBWXFka1RRdm1YbDBKUmdZVmF4cTZmNnNmdUlKK1dCdHZrZ1gyeEEw?=
 =?utf-8?B?Zm9teEwzMndVYzg0SWc1Z2IvSW9NdHRINThUekVxQTlJSTFNUDBWRnViYTFX?=
 =?utf-8?B?TkR5eG9tZFZwYWpiQytMOFp0N1Y4dmNneG91V2VibGx1ZjVoTkVlYjBTSytW?=
 =?utf-8?B?N1FFTVNPand5NWdXRFFGSE9tYy9Eemx6eTN0cTVDTXZ1YjVDdEJheUxNYXA5?=
 =?utf-8?B?YTVRYnF3SytCZFhWZ2NUYXppVWFmclg4WEVuMEhOd0V0aGFvYkFCVkRGc0dO?=
 =?utf-8?B?b0JKQkMzL1dOWnkvZ2VadmZXelUzRnpWR3Q3NzlrK3JoVHpRQmszOXZsUEhE?=
 =?utf-8?B?Q1BNZzhYQXRYQnVCT09EVCtveGZxMkVaYUJTZFliRUNXTzdqYUdwY0FyTzlS?=
 =?utf-8?B?V29zOExSMERrV2lPT2pYVHNVUlpWNVVLbm1lejFjdjNEMHVyS1cvRE9uemll?=
 =?utf-8?B?bkRTTndDTHBZV3k2RzUwMEFkc1IrNS92RTZjbTdjc2tNWVhhT29XRno3c1Fa?=
 =?utf-8?B?aUNjbXd5N1pNK3l6am1RQ3ZZRm1FYnd2bGE0MEJBOHp1dmYvVk9rOGdDR1hC?=
 =?utf-8?B?cnA2cXdFUkVsaUJhWVl4MlhaOTgyTm5paHRaVUQwTTg0RUJ5ZG1LMk55K045?=
 =?utf-8?B?cDJkcElDM3YrNkxlZ01vbE5GTzlLaGlXM3RaTDh2TUc5RnZxTG02YVAyQ1Fo?=
 =?utf-8?B?bkV6Y2pMWjhCcXlOVTdNL1ErbmVoUERwMDVDVkJpN2dqWjVOM3lEQm5hZ2sy?=
 =?utf-8?B?ZmpYMUJueGp1TUVkVGxJb28wYm1MREVVaWkrTllqQnAybHdNZno1RFg2b1pw?=
 =?utf-8?B?YkVBdjhpbmNBaGVrTjRnWngxT2lEdUFXU1p0ZTltOGZFN09OOWxwdGNmcmZt?=
 =?utf-8?B?L21LR3hpRU96RCt6UTYvV2NOdWJ2S2hYSXhqbzZPSG9kTFcrcGxjd29XNHdn?=
 =?utf-8?B?M1N0RlAwUm5lVTVsUVJIaFNmaEFMMmZ0Q3Fnams3WS9nZzREeEhRbkpMeXl6?=
 =?utf-8?B?ZlJWek1HZTQxN0RCOERsN0dXMjduZVgyT0U2N2VNaFAyYlpzN1RObFJMUzZG?=
 =?utf-8?B?ckNISDhCbzZwcXA4R3hRNCtLNTZhOXd6R3BlaTNvOUpYckJUbVdySWJpd2tL?=
 =?utf-8?B?eCtUTzI4TkpOa3RvTkN0QXJVMUgvS0tmSGNLcGhEQWFaUGFXYUVuSHRCMmNw?=
 =?utf-8?B?Z2FuYU1BdEZLaWpndlMwWXJlSHFudEFNSVNyUGNoaFNmY2o1dkhvWWR2WjVO?=
 =?utf-8?B?VjZLQVg5a1pDWENZUXNiZVQ5MnF0blhseEtxR0MybmUwQ0VEcXZrWTd6ampZ?=
 =?utf-8?B?dTQvdUR3WDV1V3NXOVNyUGFtRjFINXNoeFlPY3VXV2FDcjFzQ3VBaEN3MXpk?=
 =?utf-8?B?U0FMeS9vc0hjYzBzUzUyWElyNkR1a2dRNVM1THZERVdWazEzNDFqcFZNTlZi?=
 =?utf-8?B?eUdpRzJPUmZIUG5XQUhrd0dsOWxFYXE4dTU4WWZEOGkwNkJhY0cybXMwWEV0?=
 =?utf-8?B?RFRXM1JuaFkzYWxJcDZ4ZkFSVWVQMDBpRDl1NXhsa3BiSzVLUDF1Sm1UNW83?=
 =?utf-8?B?MGVWZHVsSW1XdFVkOUtnQlRvTlV3WFQ2Uzg5SE5PQ1hxNEFUWCtzTnIxcnk0?=
 =?utf-8?B?ZVVDZVFMQWsvNGJvVU9INllRcHRFR2lLSmxIOHhsQllUcGtGK0lqaUpIMDFo?=
 =?utf-8?B?RER0QUM2MlpKTXNyT25tWFRnRHRHOTFsVHpFWmlFN245aDJxY3VMblVPWmpL?=
 =?utf-8?Q?6u6I3Nlm4OJ6yDy98K3g7HLKv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e87fa1fb-d0d7-41f1-ef20-08dc41676416
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 01:05:49.8015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBO4bEEihIJb7Qs+LGD+FR94rQiJu65+B5g9ZwcftZMLyOjZcgEQC+mZnvgewHgfin1ugUaaY/GVtqx6wBuIlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6441
X-OriginatorOrg: intel.com


> 
>    struct kvm_memory_mapping {
> 	__u64 base_gfn;
> 	__u64 nr_pages;
> 	__u64 flags;
> 	__u64 source;
>    };

 From your next patch the @source must be 4K aligned.  If it is intended 
please document this too.

[...]

The backend may encrypt
> it.  

To me the "backend" is a little bit confusing.  It doesn't mean the 
@source, correct?  Maybe just the "underlying physical pages may be 
encrypted" etc.  But it may be only my issue.

