Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18433771428
	for <lists+kvm@lfdr.de>; Sun,  6 Aug 2023 11:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjHFJXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 05:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHFJXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 05:23:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928E71BF9;
        Sun,  6 Aug 2023 02:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691313793; x=1722849793;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fEtMir7IX1rQBc+mW5I/QCQLTK0BNJy+gxnG6ePOk4Q=;
  b=OSS5O6UhE55DztNGOTideCGHXly0Pph0xys3bwUH+Ui+gWwEB28KV5Z9
   CuSVA3PZ3eDN/nE07uxBuMOsfCuWT+7nmiWorupF48lZPymjE6mipVNfR
   Ubd4ngvX3ivIliN/Tix/K+G2HKOlY0Dd/ujHS57iKeXtaiz9CrL695Tgu
   35QZRkqHhWe8mtobPUhRJDxKp7JrlZD2sbdqbMWduf6ls+1EcU76Pl4dW
   ihjF1DT6y11zob0c65f9MGd0t9tOgbrasj2urmsPr/9X7KUxX2AI9SPev
   hv093UvcSXL1YNuFJyryZgEVE8NOn5lR+6R6lR0vOL1N2mM+68MQgxGRL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="350680970"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="350680970"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2023 02:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10793"; a="904361063"
X-IronPort-AV: E=Sophos;i="6.01,259,1684825200"; 
   d="scan'208";a="904361063"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 06 Aug 2023 02:23:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 02:23:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 02:23:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 6 Aug 2023 02:23:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 6 Aug 2023 02:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlathUsBOgjDuCo84NMFaOOBuR6vx6SCHLDk6/3uhKefEESHfR4G67Mt9jM6Y8VlwBggpR5tsUg7kUleQ0ggL/5CCSgmxx/CaNXtZ6YCCK2LwbOI+6OvtIUfMf4RjCENAbrBRuJTJloqy5NmFKftCBALQyO/ovMTrPIpwmfeB5BqdQbFQX3X/HNCpmlX3oaPg8fzp9lfCu6PK4GCj0/CblXtZuzyZtfCPcbVBejxKGRwUC0uLu3OqYM93bCTquElzTSLd9pMkOmumf7lcQ4asnrD6na2vXN7UkbNAYgD68MDNHm3NF/y8MNA+lai5xjxtIrf1eC566yVkWT/ixA+xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBN8k/xWukcI36K1lMEMm3mIEGhYe8vA3VO0jEWckNg=;
 b=kKQphs60I8FgZALOzvp1fRXuUPpwd61WZnrBaoGn2X2ML+UhW5G9F9PC3qdUbutnWO/CBBl0EuWk8pVoU4d/oIrz4ch8nJ1fjWlex6lTrB+LfgAqf9klq+yiMkuPifaf4sqXdWOxvgrUj2m7IlkX9Qi2nv6AMG+9ZXQbOvjOWrrAjP9pFZpR4bAv8RNYRHtu0jfb3vLCc7CeGwHuf5Gcf6qIBUk4pyMdBW006INOgRp+LOnxsrV56ph7Xn1EOJWusQAQ/OuBZlAebl4XM0YuVMvdrRBSDXJkgmcBdztUdin2SV3mOu64NAiDEO9EbXBVl7oCehDOjR+nOvx/0wQLcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Sun, 6 Aug
 2023 09:23:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.025; Sun, 6 Aug 2023
 09:23:03 +0000
Message-ID: <f894d23a-5c6a-d189-57ee-8f2bae0baf6b@intel.com>
Date:   Sun, 6 Aug 2023 17:22:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 13/19] KVM:VMX: Set up interception for CET MSRs
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-14-weijiang.yang@intel.com>
 <ZMyz2S8A4HqhPIfy@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMyz2S8A4HqhPIfy@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: b3c86b37-b554-435a-9e54-08db965ebc6e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IKsFHewg3YEdo0E9oOJ6D9CASIjKniA1UHeoV1v2Qc1S1YaiIXdgxpB63R6Dv0TRdrwzVGn/dBsBLhZ8GJGLHgnsjerEvtzLGaKeRh1Lxdg5aao8H+fsYMSJhErXLgo57OwIH4h90IFKJiTQfP0TvlhtT+cfOwozGE/9ZBU4ykoQNP9XokHFVS7h1Wn3cNY0FGdgpaUT0JcxaxPf3vUj/twrPtbh5H1w+7H8/We/VAG6Ks23LvjMeb3gKJFtI+St38axr3pNRucAoDIdpUbzF26udj1Wa2y4mUCX/CDDSes2W6gt/UbLkhSPkXVl7sXPaK3YBGOpO38iF7bya8sLhQUSIg1RypqXQky/7sySfOQDO5gdeIUZcy7wQQfOx9VgFPT1YUY3L3Y2ez+/R4kS8C/7zve9uYrdcWuXMeYF7jTpmEdkp+XIN/dl3joxDjqi5DIkGCkdE7BlOKwixBuORl0cptZaofTJ0P5WwktTu82urgtxEcthJg/4Y6UF/v/OIlCY0AFS2mmg+P3bxZ45x93z+WKO/Dnho8YSUHPy9X3WcDbGJw1l7vVJskOf4dJni4D8DSkuoUXDVfhYKOrBUW5IEARTbfdpWd8HM+Wt6xRVD/vp7+UbKugZZOEohsg0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(1800799003)(186006)(6512007)(6666004)(478600001)(37006003)(6486002)(2616005)(2906002)(5660300002)(86362001)(31696002)(6862004)(8936002)(8676002)(38100700002)(82960400001)(41300700001)(6506007)(53546011)(66476007)(66556008)(26005)(66946007)(83380400001)(36756003)(316002)(6636002)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUQxTHVFTThBUTdHc3c3UzFYdWNSVlRJUk1JMmNrUnc5YjFFQWFNUWF4UnJ4?=
 =?utf-8?B?bDhtQXd1cjR1ajhkNkRhR084Lzh5YzVhWFNXdmVleVY0RElIMFM4cDQyUXll?=
 =?utf-8?B?NEpjMU8xNzdSakFDYVovbWVVVXd4ckNFQXFjdTUycGF0aUlXVGFmbXUvMHlT?=
 =?utf-8?B?aVhlRHI1NG5mZm1vNjU5b3dZMmRKZ1B2c1YxMDJSbk5YOWtvSUViRTYydlNm?=
 =?utf-8?B?RlNlbERESGE3R0JVRFNJYmZmOWxiaGsrdy9rMk1USFkza1BCNXRSU1VJM2pY?=
 =?utf-8?B?UTNuN2ZrWU1KSFNHVUpMRHo1Sm9iWmVLenhtTFJOWlh6MWhXTG5qdmpnejdO?=
 =?utf-8?B?c2pPaEk5RGNKaTJ2dmFHclFUcmo5Z2xML1gyb0JDa1VvZ08ycXdkY3VhMUlC?=
 =?utf-8?B?b21FWW1VZzJTNGdjSDNuRktHK0ZkTlBZdmpNdUx2eEI4UkZjc0pMK3I1dzVa?=
 =?utf-8?B?TDk2MkNWbE9BUWo3dDl0Z1RZaXVGWjFJUkhlY2o0a1FDTUZCMGkxNFJWbXA0?=
 =?utf-8?B?M0F1WHk1TndhWU9WZEo1UldtZ01MRzhVSC9UZ0licWRZNDhvcXJpR0RWRjQ4?=
 =?utf-8?B?WVpsVVc1dzRvL25nOVhGNjZBZUQ0Zm5CL1dPTXZRK1NEejc0WWFkNkJ2Yldy?=
 =?utf-8?B?UEFzZHRKZHNVK1dYZDBQSFl4ZmpJbW5oYmRDd0ozcWxDQkZ1OXNULzhINmlS?=
 =?utf-8?B?SFlXdUNEZHptRjQvNUQvS3BBVit0bXdPR3JsMy9ZRTAxcVAxaUtpTWZKcnZw?=
 =?utf-8?B?bE9ZS2ZMYzRucGNGWlZCbGF6L2ltaUtSbzI5Zkt5UkQ3UW1ZeXFtUlNmb2tO?=
 =?utf-8?B?MEt4YVJxZU05dlRXY0dGL3ZKYzljLzV0cjJlS3BsQ05FT29hVm84WWRtUzkz?=
 =?utf-8?B?MWVMUTFFV1RiY1VKZVlaclkvQzU3WUxoZHIyajY3eDRLVmhVT1NnNENscExy?=
 =?utf-8?B?bEFLOWMzaWlaQTlRY1prbFpYSWJ1c2F5TlQrU1A4SFJjOUp5VFZBUkNSN0l1?=
 =?utf-8?B?M0VLWEhqOExVR3kxbFRlVHVreENGRlc5ZXA0THBNU2N1RE5YRkQ4dDV5Vlh3?=
 =?utf-8?B?a1ZyMmk5cm1rT0NpL1VhSmdqL3pqSTRTRThEWFFLdzdzRFlRRnpadXNRZUN2?=
 =?utf-8?B?K01IcjVEQ0hWSk15S0RDTnNudWhlYkZsSzdFS0RXUUEvdlNBbUFvTDVTQXJQ?=
 =?utf-8?B?ckdkSUZrTUR1c1NkQVp4R042K1FyZDdBcjBJWW1KZVdLKzBpRCsyUDg4UXBn?=
 =?utf-8?B?NForY2g3MzdUcElHLy9pYk0vZ1NGbXlRaDBoZW1INEdFSkErdzZCL1ZsSlNG?=
 =?utf-8?B?Q3plcVVhZmF4UHI2clc2VDNFZ2tUeUprMDNWQ0lQejA0bGpadGRTVlVjamxj?=
 =?utf-8?B?UGhkbGFMWEk5cWViUmtwZ3NmeFFFZnJTNmpMMWYwb2ticXh5NWQ3NmJUYkFM?=
 =?utf-8?B?azBSS21EbkMyLzd5RjFxaDM4bDZUeTZTODJIYVJHcU5IN3VGVmVEZnZNSE15?=
 =?utf-8?B?UlN3Q1Y4UzVuNzBjdE1sMHdEYWQ4UmhZeldOVDFHQ2wvQldhb3UyVEtkWGFR?=
 =?utf-8?B?a1pqZk8wemo1MlhMdHN4Ti9nMXBBbjlCU0cwRms2bHBLVjJKb2pMZjRKUy9Q?=
 =?utf-8?B?N2NjM1ZxRXBYb0kvMktIVG55a3N3b05jVFlHenlBb0EveDZuTENFKzQ4RFZC?=
 =?utf-8?B?Z3NaUFlmL0gwRVdXYng0c2p0aHZjUmlLRlR3Mm1HanFTejVMVTJiSjBUNko5?=
 =?utf-8?B?NEhkVUw2Qi9pY1dwUzZIdzRhK0hLaHZjMERRSlFRR0ZKWktxMDdHN0gzTHFO?=
 =?utf-8?B?ZkdOMnRTZXliSFRyWUlJdEpGNFNuY3IrdG80WHRlMEVXek41QnBRdUdRZXhp?=
 =?utf-8?B?WVNHb05xbDdkN0M0ZkJaVFhrSnpjV09KUW0xMlFpSzVDNTRyL1NsNFdIWnpB?=
 =?utf-8?B?dWlJeE9SQWxwWXNEZFcxelA2YTRBa0lJOTVTUy9GMjEyd1BHempoZk9DR2hJ?=
 =?utf-8?B?Z2dFVXNldi9XWUhXWmkrQWpzM3lKL1FvdEZPT1cwWXVPRklTdk80b0tuMG9W?=
 =?utf-8?B?RTc5UmNjYTlDVlNPNVM3NnFtWXNPb01hQk43N2czTTg5THI2VVdzRCsxRWpH?=
 =?utf-8?B?Zi9PVkpJSDFsSk55cG0wWXB6WWtZR1Ztb0JURk9YTWsyT0JaSkFUUEVLSXly?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c86b37-b554-435a-9e54-08db965ebc6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2023 09:23:03.6474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTUDTFfRS9LhJpb2UZyCMNVb68fllBEAVa4ME38JbY/YXaWVyDSzGLQiC8p9Me3k8JC0pnHcPIdNG857JQfeEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 4:16 PM, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:26AM -0400, Yang Weijiang wrote:
>> Pass through CET MSRs when the associated feature is enabled.
>> Shadow Stack feature requires all the CET MSRs to make it
>> architectural support in guest. IBT feature only depends on
>> MSR_IA32_U_CET and MSR_IA32_S_CET to enable both user and
>> supervisor IBT. Note, This MSR design introduced an architectual
>> limitation of SHSTK and IBT control for guest, i.e., when SHSTK
>> is exposed, IBT is also available to guest from architectual level
>> since IBT relies on subset of SHSTK relevant MSRs.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> one nit below
Thanks!
> [...]
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +		incpt = !guest_can_use(vcpu, X86_FEATURE_IBT);
> can you use guest_can_use() or guest_cpuid_has() consistently?
Hmm, the inspiration actually came from Sean:
Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs - Sean Christopherson (kernel.org) <https://lore.kernel.org/all/ZMk14YiPw9l7ZTXP@google.com/>
it would make the code more reasonable on non-CET platforms.
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +	}
>> +}
>> +
>> static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7814,6 +7853,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>
>> 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>> 	vmx_update_exception_bitmap(vcpu);
>> +
>> +	vmx_update_intercept_for_cet_msr(vcpu);
>> }
>>
>> static u64 vmx_get_perf_capabilities(void)
>> -- 
>> 2.27.0
>>

