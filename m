Return-Path: <kvm+bounces-4547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF08813FCA
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 03:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EBDD1F22DEC
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 02:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D77A2101;
	Fri, 15 Dec 2023 02:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdhJWOq7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E0EC9;
	Fri, 15 Dec 2023 02:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702607415; x=1734143415;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Buhq9whFZdTOyUFKdd6TCRvjnIVUDgnY24z5U2V9J94=;
  b=YdhJWOq7WeR4VU3KslCwVcZO4dSAIHKA98kyCgwncupuScz0cTWRjHTj
   vDK1wptylUW5no+DLEUz4ohdxBd45x53EZ1vnrozdOWDuJ3AQ/iyd7Nen
   qRY4R4b3s1sDvhtywpXDk3KcqJUgSLd4kRCThMOB97IMsEZkhSSuqyBx8
   3VhPFfTTA/sgAQAGMsiMdRX0NXCXgAoA+u0KvwgxTC2RwCesQQWE7PSC4
   kpUgoBE6gIW7RQhcsgmk40vEUdFyOWUNz8cjQHwAO30QoAB8OHaGAywuL
   j/35pougjEEafXuYU9o9XqZQZAHP4rJt8qw3JsmBk/XsGk6Vr2frE4zCS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="2308568"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="2308568"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 18:30:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="918274215"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="918274215"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Dec 2023 18:30:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 18:30:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Dec 2023 18:30:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Dec 2023 18:30:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMcNjEjLgpHFUqvAoXcXKGO3nckm23EExucvD9kjbKP3Hfx04EjaP5L6Pr0XLJotmUDhqyYASY4g3/w7ZLFmaGjctN6xGhOfeS24qCa10KitcbYbnnedjrCkY2jYZG0NzS7M3fCtQB5sEU2IkYbn3dLdIhJ4YUkoZvX1uD5LYwF0Bl27Y55X2m6k/Muzc1S1Jo21YmNe506YdqYhIEZniGW9rTZ9Xuq4g1+T6wR+uAk6/Elf+/ktr6x+GCIlsLRXOzDLyDVynOn1qvK0wUORF+YV5AdEx2hvt/pB3lDDFRSz7/5Z8U2y+xX2wrr9hfJQihkfpbm8AyZs0Tv6NjSmpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1BvXvnYkxFqMagtFb8uxQkRcaconejm9eGUvu52+S0=;
 b=bGdkpuRc96jZAFx1+uWwS52+zEwVc0GQGfjVUBb9gNSM50sUdoRs91bWAEm/Q9HNts6gqlhA7G7IPHICfYPJbOWLXDuOAjhuTl+eHREHZ7NKIanZ22UYL/kR3v3uW8QDTCze8xOZDANhgswVGaW+00rVYuJYn94n0VwuBfHngEZyiDbGRCKolfZPpZsI6yQT4gS00DWb7SmiWymxEApTZKo0e/SEhSNRDPzWuj7PmNwxDiC54aFudHc/F8KFCWSfv0UNlIfdsiWI3Q6ePtOHggaWFRZ0Im7lliXlaIBQrf/s7l0LZtoAgFr7vXRZ/SEAscNcbEtD+xik+UbPpJ5Lig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7919.namprd11.prod.outlook.com (2603:10b6:208:3fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 02:30:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 02:30:07 +0000
Message-ID: <9fe42947-3962-49bc-99f4-8b09954fd598@intel.com>
Date: Fri, 15 Dec 2023 10:29:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/26] Enable CET Virtualization
To: <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 8639a104-e3b0-478f-d091-08dbfd15c068
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETULNVyEYHJZV/2y3EPsE81s03ZbdUFefoFo4keEkOy4wlSFgeLAgWMt6tkK9gqc3m3MASa1QUcQ1JHWac30+qcOiJCaDvknPY0Gvwbo/8sJvip5C0Il++Eh3b7zfty3kO+c0fLWk06OHIoGwI/ZogUuk8PjODOiQcZN4/CJ9S4yUe3TVgC1msjwZsnAcw9pFa8Bi5Pk8qpFAA1bY1nMfaKEUcb6cGQkLBPrBi5Sh/2X5rUl0agfWE2UQsmkmx80pEP4lSONCZulyloma1kn4LXGBD5RuBNggLd9U0OcAz5rG36HqemWjA4NP7f+okhuHp9ieBt/xZdIosfQUyJ8uOmB59NN0Sfps5ohEEb9QO5GYXsXkQAPvxdZEHe/9eEAoSNMUcBKFcEP+pD+osXXx6KRQd1smMRKEoKIZwu+kmAQwV9B8j5CzVYKwmLSOMNlSFG0n6V70IWnS1sXXcFN6FTGdu52Mu7crX1DaBHFoDjICe8vlm3UywlvsOKGvtRm1WMfTp0EOBLypbIvFoFNg9W4F6P+8EMcw1KQ4XVrLetc2YbynTx3fOqRpGGgSMqWvB5z0Y0PHwKMm+RbQqRF3eECMByREJSUCMU3vK9VsxGKZMiGqei35v7Xu5Es8c9ZWGIanSUMyR3v+9ApFKS7StNVWy3fJsaUL/WRbYQO/lTQv/lnPCdlEz3IPPKtoIJt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(376002)(396003)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(8936002)(8676002)(4326008)(316002)(31696002)(966005)(6486002)(478600001)(66946007)(66556008)(66476007)(6916009)(41300700001)(2906002)(5660300002)(36756003)(82960400001)(38100700002)(6512007)(2616005)(26005)(6666004)(53546011)(6506007)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QllHa0x5bkFwN1VQWmhCa2tjbWNaQ1pYZ25PQlhGVXRGem5YVkxqaGpOSDVN?=
 =?utf-8?B?bnlQVlNWcWNqczBUUzVES25ma1Q2b09FcEZDdUNoSEdIRFdNUE1qSTZUY3Jq?=
 =?utf-8?B?VG1hcUd3L2htK2RsOU02ZFBuSktCdlI5WVZmcUY5RHUwUVlIZUVPRmFQekcr?=
 =?utf-8?B?L0xmQjFuZ0twd1VrT3Z4NUN1VElpRGMySGFMa2dJMkhEZEtXN0MydmNTL0c0?=
 =?utf-8?B?UlV6SFJaUTVQeG9TbzJoY1dJNU1aTnd2VEQxN1VzSEJMQmNvSkVabUpGNSsv?=
 =?utf-8?B?ZjJVaklPN0I5NkxDcVpMejBTYUg1V2hGZmJ4QkhXT2JKZG4zRmlhZ3R2Uk5I?=
 =?utf-8?B?QzlzeVN2L3JFdjFXaUdqbUtOQnF4OC9XS2pnVnZpZ0xCbmFEWVV5TWtHdDVO?=
 =?utf-8?B?ZHhWbVgxbm5JK094aHdJWkZwNGFZMXpHN1h3Tk5oSy94emQ0MEZuS3Bkdk03?=
 =?utf-8?B?MVI0cnd5KzZQRlVSVDhhS3ptVFBtbG94ZWhiNDlUc0NkelJEVmxrNUtGd0dZ?=
 =?utf-8?B?enBIdzdIZDZGNkpOaVIrN2YzL0RicjREZmFhMG11NWRVWmZXS3FwbXQrNUVy?=
 =?utf-8?B?VnhHYUlsMVdQUFZpbjQvU2NJTzhHU1FnRHphZnB3MzEya2pLSGJQY21QaGRX?=
 =?utf-8?B?citsdkNyQ05uMjhVOFRkaVFzMndpdFA0amJXSlNuUmM3bHZ5STNTSkdjRVlW?=
 =?utf-8?B?QlNQL3JXN2thSUxFM3lFY3NiU05wZ2F2NXpZM0txbEI5VXVjK2UrTE1nTVdj?=
 =?utf-8?B?d3hTU1U0MG9FcnJaTXpKVDNPbnpXVUVvZUxLQW44M0VSSlBMeXRPUUhGK3N5?=
 =?utf-8?B?TjhXR20zUUtNSDlHc3RCYXRsTmRadXhDOWxMR0Q4NkFBMEt5VStWTGNvbHJo?=
 =?utf-8?B?Ui9rWjNNSE95TUJrd2tDY0RvVjB3TUFDSExudlcwVWt3VEh6dndIc1BNQ2U4?=
 =?utf-8?B?dEdaalFPdDBSK2JOV051RjJuSEtjVUVldWlsODJHbTE4M3lxemhtSlhTdng5?=
 =?utf-8?B?THIva0FLT0I3b3dleU40amNXQTBqVUlJd2ZuajFaZUFZOGpURmdLdFBLVEtU?=
 =?utf-8?B?Qm54RWlnVzBXbU5veFk3dDN2QjlBTWhFQm81d0dtZU5rM25DcVR1aW5VU1Ur?=
 =?utf-8?B?a2lHOXp2T0FOZjZ4WEVuMTE5TU5WdmNDaU9LSGU0TldjVHdoVEltRyt1Umlk?=
 =?utf-8?B?amUveG9EbFA5aVFnVk9wWVpwa2w1SHdNMWpDSCtrTEtTS2tJRnRiYkl1U3RU?=
 =?utf-8?B?N2tveG9idTFJb3pIRmhVZCs2aFl2c3JLWklTV2Z5MHVEVzRvYXlTeUdFbnJi?=
 =?utf-8?B?VDNDd1ZjOHBFY2F4eWlkNjZXSkN4TGQ5eHNoL2JjM1cwOXI4ZE9hZnY2Uk5r?=
 =?utf-8?B?aDJUN01IbzRZRDFsSk1SZ1VNejhzeTQ5Ti9TREdZeTR3Mm14UVlkUVF4cUlB?=
 =?utf-8?B?Q0RpWXBOUW5MWUhjT3hBVi93OGsxbXNac2c2YjI2c2tJb0YvRUpBeHplekpa?=
 =?utf-8?B?cFpaTkZvT2FCRndPbnhRQ3pzY3pkTHB5SXEvaStWL0FJZzNoZFZ2NHJ4OE5N?=
 =?utf-8?B?T01GbVFtYkdNa21BTnp5Y1pDMThJZkJ6c1F1Qi9CNXo3MUwxOGMxa2ZTNGcv?=
 =?utf-8?B?QVlaRnU5K0ZRSDRCSkJCclROTlpaaVZzUW9LMFRTZWphdVFPOEhBYXp4RnVI?=
 =?utf-8?B?QlI3UHBQbUFUU1JnYmFNL0lhc21lWWFSRWxiK3ZXbDgya3BuL0FBM2R6eldY?=
 =?utf-8?B?SHBOWnhBVUNkQVRHR0JOQ0pnajZjNDh5bFhjU3N6bGNHZytnSUIvT3MxdW5W?=
 =?utf-8?B?bm1TeVJaanB6aG90RFZBbi9pZ2FRY0s2OHptU3FoeDByWlFSTWkxWk5lenU0?=
 =?utf-8?B?OVhoUEpMNjVISFUrMkNyZG1ZSHBYa0tjZkhYRVgweTFYcWJ0OGl6ajU1cEw3?=
 =?utf-8?B?TTl5VjR1R3I0UCtOUVVhVlM4R04xSEg0c2pGbUFnd2hnQUtXYWNJcW5jb3lR?=
 =?utf-8?B?TTVLTWxzSE9yTjVsdDhkN3ZDVVcvMkY5T254MEZHQU8zWElZM2VJdEdwdkVN?=
 =?utf-8?B?UktMNHBZUDBrZ0Q1bW5HWjlzN0NyNGlkbnp2ZnBMRHFFVWw1ZEFiTFVUZ3N5?=
 =?utf-8?B?NzB5U01XaFdySUlSZ3ZKczVQNEtuOEphMWNPZVIzbEdCWlFJOHJXQlI0NHRm?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8639a104-e3b0-478f-d091-08dbfd15c068
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 02:30:07.1032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coQ5irY5hFokgo09+MwL8kuet4cML8aiAtZiC5WAJWnhDBBYM9c8tCKD+ReZHsdQOLanTogkKtflKktPH6F/bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7919
X-OriginatorOrg: intel.com

Hi, Sean,
Do you have additional comments for this version?
I'll enclose Maxim and Chao's feedback in v8.

And what's your plan for this series? I'd get your direction for the next step.
I'm appreciated your persistent attention on this series over the past years!

On 11/24/2023 1:53 PM, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) is a kind of CPU feature used
> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
> style control-flow subversion attacks.
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stack
>    is enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT introduces new instruction(ENDBRANCH)to mark valid target addresses of
>    indirect branches (CALL, JMP etc...). If an indirect branch is executed
>    and the next instruction is _not_ an ENDBRANCH, the processor generates a
>    #CP. These instruction behaves as a NOP on platforms that doesn't support
>    CET.
>
> Dependency:
> --------------------------------------------------------------------------
> CET native series for user mode shadow stack has already been merged in v6.6
> mainline kernel.
>
> The first 7 kernel patches are prerequisites for this KVM patch series since
> guest CET user mode and supervisor mode states depends on kernel FPU framework
> to properly save/restore the states whenever FPU context switch is required,
> e.g., after VM-Exit and before vCPU thread exits to userspace.
>
> In this series, guest supervisor SHSTK mitigation solution isn't introduced
> for Intel platform therefore guest SSS_CET bit of CPUID(0x7,1):EDX[bit18] is
> cleared. Check SDM (Vol 1, Section 17.2.3) for details.
>
> CET states management:
> --------------------------------------------------------------------------
> KVM cooperates with host kernel FPU framework to manage guest CET registers.
> With CET supervisor mode state support in this series, KVM can save/restore
> full guest CET xsave-managed states.
>
> CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
> and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
> xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
> CET xstates are loaded from task/thread context before vCPU returns to
> userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().
> So guest CET xstates management depends on CET xstate bits(U_CET/S_CET bit)
> set in host XSS MSR.
>
> CET supervisor mode states are grouped into two categories : XSAVE-managed
> and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
> controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
> of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.
>
> VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
> facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
> bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
> equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
> states require no addtional KVM save/reload actions.
>
> Tests:
> --------------------------------------------------------------------------
> This series passed basic CET user shadow stack test and kernel IBT test in L1
> and L2 guest.
> The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
> failures have been fixed here [1].
> One new selftest app [2] is introduced for testing CET MSRs accessibilities.
>
> Note, this series hasn't been tested on AMD platform yet.
>
> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
> is required, e.g., Sapphire Rapids server, and follow below steps to build
> the binaries:
>
> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
>
> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
> (>= 8.5.0).
>
> 3. Apply CET QEMU patches [3] before build mainline QEMU.
>
> Check kernel selftest test_shadow_stack_64 output:
>
> [INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
> [INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
> [INFO]  ssp is now 7f8c82101000
> [OK]    Shadow stack pivot
> [OK]    Shadow stack faults
> [INFO]  Corrupting shadow stack
> [INFO]  Generated shadow stack violation successfully
> [OK]    Shadow stack violation test
> [INFO]  Gup read -> shstk access success
> [INFO]  Gup write -> shstk access success
> [INFO]  Violation from normal write
> [INFO]  Gup read -> write access success
> [INFO]  Violation from normal write
> [INFO]  Gup write -> write access success
> [INFO]  Cow gup write -> write access success
> [OK]    Shadow gup test
> [INFO]  Violation from shstk access
> [OK]    mprotect() test
> [SKIP]  Userfaultfd unavailable.
> [OK]    32 bit test
>
>
> Check kernel IBT with dmesg | grep CET:
>
> CET detected: Indirect Branch Tracking enabled
>
> --------------------------------------------------------------------------
> Changes in v7:
> 1. Introduced guest dedicated config for guest related xstate fixup. [Sean, Maxim]
> 2. Refined CET supervisor state handling for guest fpstate. [Dave]
> 3. Enclosed Sean's fixup patch for kernel xstate issue. [Sean]
> 4. Refined CET MSR read/write handling flow. [Sean, Maxim]
> 5. Added CET VMCS fields sync between vmcs12 and vmcs02. [Chao, Maxim]
> 6. Added reset handling for CET xstate-managed MSRs.
> 7. Other minor changes due to community review feedback. [Sean, Maxim, Chao]
> 8. Rebased to: https://github.com/kvm-x86/linux tag: kvm-x86-next-2023.11.01
>
>
> [1]: KVM-unit-tests fixup:
> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
> [2]: Selftest for CET MSRs:
> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
> [3]: QEMU patch:
> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
> [4]: v6 patchset:
> https://lore.kernel.org/all/20230914063325.85503-1-weijiang.yang@intel.com/
>
> Patch 1-7:	Fixup patches for kernel xstate and enable CET supervisor xstate.
> Patch 8-11:	Cleanup patches for KVM.
> Patch 12-15:	Enable KVM XSS MSR support.
> Patch 16:	Fault check for CR4.CET setting.
> Patch 17:	Report CET MSRs to userspace.
> Patch 18:	Introduce CET VMCS fields.
> Patch 19:	Add SHSTK/IBT to KVM-governed framework.(to be deprecated)
> Patch 20:	Emulate CET MSR access.
> Patch 21:	Handle SSP at entry/exit to SMM.
> Patch 22:	Set up CET MSR interception.
> Patch 23:	Initialize host constant supervisor state.
> Patch 24:	Add CET virtualization settings.
> Patch 25-26:	Add CET nested support.
>
>
> Sean Christopherson (4):
>    x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>      __state_perm
>    KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
>    KVM: x86: Report XSS as to-be-saved if there are supported features
>    KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
>
> Yang Weijiang (22):
>    x86/fpu/xstate: Refine CET user xstate bit enabling
>    x86/fpu/xstate: Add CET supervisor mode state support
>    x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
>    x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
>    x86/fpu/xstate: Create guest fpstate with guest specific config
>    x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
>    KVM: x86: Rename kvm_{g,s}et_msr() to menifest emulation operations
>    KVM: x86: Refine xsave-managed guest register/MSR reset handling
>    KVM: x86: Add kvm_msr_{read,write}() helpers
>    KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
>    KVM: x86: Initialize kvm_caps.supported_xss
>    KVM: x86: Add fault checks for guest CR4.CET setting
>    KVM: x86: Report KVM supported CET MSRs as to-be-saved
>    KVM: VMX: Introduce CET VMCS fields and control bits
>    KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
>    KVM: VMX: Emulate read and write to CET MSRs
>    KVM: x86: Save and reload SSP to/from SMRAM
>    KVM: VMX: Set up interception for CET MSRs
>    KVM: VMX: Set host constant supervisor states to VMCS fields
>    KVM: x86: Enable CET virtualization for VMX and advertise to userspace
>    KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery to L1
>    KVM: nVMX: Enable CET support for nested guest
>
>   arch/x86/include/asm/fpu/types.h     |  16 +-
>   arch/x86/include/asm/fpu/xstate.h    |  11 +-
>   arch/x86/include/asm/kvm_host.h      |  13 +-
>   arch/x86/include/asm/msr-index.h     |   1 +
>   arch/x86/include/asm/vmx.h           |   8 +
>   arch/x86/include/uapi/asm/kvm_para.h |   1 +
>   arch/x86/kernel/fpu/core.c           |  62 +++++--
>   arch/x86/kernel/fpu/xstate.c         |  46 +++--
>   arch/x86/kernel/fpu/xstate.h         |   4 +
>   arch/x86/kvm/cpuid.c                 |  69 +++++---
>   arch/x86/kvm/governed_features.h     |   2 +
>   arch/x86/kvm/smm.c                   |  12 +-
>   arch/x86/kvm/smm.h                   |   2 +-
>   arch/x86/kvm/vmx/capabilities.h      |  10 ++
>   arch/x86/kvm/vmx/nested.c            |  88 ++++++++--
>   arch/x86/kvm/vmx/nested.h            |   5 +
>   arch/x86/kvm/vmx/vmcs12.c            |   6 +
>   arch/x86/kvm/vmx/vmcs12.h            |  14 +-
>   arch/x86/kvm/vmx/vmx.c               | 110 +++++++++++-
>   arch/x86/kvm/vmx/vmx.h               |   6 +-
>   arch/x86/kvm/x86.c                   | 254 +++++++++++++++++++++++++--
>   arch/x86/kvm/x86.h                   |  28 +++
>   22 files changed, 669 insertions(+), 99 deletions(-)
>


