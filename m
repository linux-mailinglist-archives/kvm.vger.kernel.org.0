Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7800D75F99F
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 16:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjGXOSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 10:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjGXOSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 10:18:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C42DA8;
        Mon, 24 Jul 2023 07:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690208283; x=1721744283;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AuY6hkE2bPsmLrHquyLphNX3r3a17ZAcRernA635fpE=;
  b=U3uthI7MKBnfQ625cz7MyYGcfjGF52S9dIOreq0/7bWYbOV7FVZLLVhR
   lU+5gGHPUT5CsB0rs7dV5xFlUocsSArlstFH7cwyg4rWBnQ0MN4wK7Wxr
   Otj99asRg4K/TEivAiN08N6PDAAtjPtPRhpLV89+APckxCJ2zHNNV7U5r
   VJ82BYs45pvxZHURKRTQz42T5bIcknSJia3O8yTQPnZcOFSYWROn10s9f
   jM9Yksbi2YlYXbJFY7AVBXm26HesnO/RLAUFHJkQYhCImQuyxGWnmJCdt
   Q7MosCKIpKIZIQlokl20d0rOy/h3kQ+xHLeaCf7e+hY/Dm4LiWnJcrWDx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="453829621"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="453829621"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 07:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="725729148"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="725729148"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 24 Jul 2023 07:17:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 07:17:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 07:17:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 07:17:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 07:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjs3X4s5YtEaD/3cXY8VFzloYrO60gUvvEdx0VzT2sUdngVEp48vn1bOsL5iTTOENIoJIJwKiUoDbNpJOF1m9fbn+6U+RDfAZV5JSRrDUeEtR1ZFEBB0L+QSaDMXaxkAr8LxqZM3TyFcvMQKtnzqT6gZ1kCaIINIKw5WZkSPKZ69Svlhgqsp0GSPDDjd/hmjF0X+DHzGcVOFeTiOx64yHvlnraET1qnv8aS0SFNZnG9pE51S3OQu1M97aAj8yCkqfT+qk2uTsoEvb4lcVuEAoxCi8n3nIO6xBg1csRVnbBEu66OUDGARA/2/+wH3XTNv2vfEIY5/PukohS09vvpzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1YXzsQOVjY6c9g5OsjAJx/bbYaM4ZcAbb7jAZrYMzU=;
 b=I0wFfqxV7tBnY0Lku7YXwy6PhBtut0hZD1uAR5uabXouahKOwk/mtmcW6VfZhOGINwn1ggqHPl6eYH3dEyZ7VzmRm5MyaftfqVB3dvcmK7WOrr9k+yza90udIZg3qEFgBfkxfi8nAK9KIi3XT/OFk7Ny2lzSw1bjImQ/xPk5fobUhFkKAtNBU3W8h7bmBGZdSOaz7wOhlP3otxRdgieWt62hJuolS3qHEA/Rmqng25D62FQK9RH/gSlCZCYyU6cuHbLVPvsTTvcRQ4i9NVoF4tiH5ATsLxwhsZUV9K+BLX0MrU2LsuqoWq0iaxxoxgbs6sLouy9DNwCMOeDA0bqKEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB6200.namprd11.prod.outlook.com (2603:10b6:8:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 14:17:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47%6]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 14:17:07 +0000
Message-ID: <296c5c68-d03b-65bd-bfb6-41e6046ed389@intel.com>
Date:   Mon, 24 Jul 2023 22:16:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 11/20] KVM:x86: Save and reload GUEST_SSP to/from SMRAM
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-12-weijiang.yang@intel.com>
 <ZL5AwOBYN1JV7I4W@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZL5AwOBYN1JV7I4W@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 826434f7-46a1-446e-9aea-08db8c50a972
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3T5XqiSLIoDOHW5PKnXCB1bdqlxnfYCYJbnRvmStwDqGZBMSXi/omVKXwtQXMt2VnvmoUeFY/t2H9dvMoZ8geOlBgblOQooUwZ8cVKjfJ9hEH52upDarHtZO8rYe/Bwv03W3Mdn/zJm7rVQl55DKLhq1IxQfOoVurAjtbTlTEx6uVPzwsY1CMULfx9K58n2Cn87ygsTciOaBUtLFBXy9Ij0zpyoyU9O12MyOBSiDgUM+k5lMhcKEDKghJFaSmtVWjvKKht3d1FCoSbYUfk05Wi/bxm5MfixJlGRjg+P5RZ4rKanzFULRM875azx0pWwfkLDIm/opLSeSHgMVnNfQKpje1tJ/HKunN8IYvY00aMdwFET27GhA8YIgJmRr6+8tyvfQDSAA2gYhTPbQotFwgotJ3F0HEjkvQ6om7+xpPxkDsS1xkz2m9NvlloNKVs7eMEI7kBsgfnfxYtaPgHty5S+/NhWgOIMhzozBHrOJ/zfXYDuQklqPWH77/jPRthwG6W/L5aMwXe2kJwdZn7AXTwgOV2LrqrHjXDzha8DXABbFqyaOc2ecbGsVNU/ec8VJL9f44b45mR6i3quIFQZp4pXMDc/r+gc447JlPjFMOlYYr/fC/1bi9j4C2V3KFw8+4p0Pr3uGTP+SKDayFZysw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199021)(186003)(26005)(6506007)(53546011)(5660300002)(31696002)(36756003)(6862004)(8676002)(8936002)(2906002)(2616005)(82960400001)(86362001)(38100700002)(4326008)(6636002)(316002)(66946007)(66556008)(66476007)(478600001)(6666004)(6512007)(6486002)(83380400001)(41300700001)(31686004)(37006003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWIzcGYzU1IvMDRENUt3ekk5R3dCWTJ6d05NK3U2OUxBWjlzMUV4b3ZNSVc4?=
 =?utf-8?B?WEdYcG9lTFdYTTZQV2ZhNlBHVGFtMENqNW9PMXZEdWtQUFdlKzJqMFdYeGl0?=
 =?utf-8?B?MVdieDBQdTNwck1xb0ViNER0OGkyMzNoNGtMOWFGK1k2Si8zUmZhcXN4Nk9G?=
 =?utf-8?B?bnFYcXNCbGxicFNYcnY2UkdoT1JqSEZiNkwwbHBHdnErY0ZnT0JIQlBjODJl?=
 =?utf-8?B?ckFURStjRlIvTUUyWlpNR01TWDJHS2lpNVJRaHdiVGpqVm1mRzM1ZXpHUTdP?=
 =?utf-8?B?V0c5TUdXM3FXV1NvcVRnNUFVNlJKc3cxeEN6MEVpVVVabW11WGIwRTZwZkt4?=
 =?utf-8?B?VmpKSGp2cVhJQ1VkNDAwUForSG9xbHNGSTc3THZMSi9TSkdPbHJXYTIvdG5P?=
 =?utf-8?B?NEdzVUhzTmw3bnljcGExSzBLYVRhUm5RcFJsclVXejByZlJRWEV1V3NLV3ox?=
 =?utf-8?B?UkdoU0Rrd0xFT2lQWExVY3UyZmg0ZXFtRWJ0Zk8xa3VCT2dsVFA2QWszbHRB?=
 =?utf-8?B?WlBmODdzc0RjKysvTkRnb3Y4Mi9nY3d1d1U3TDErTjhVaThVRks3c1NtRVpY?=
 =?utf-8?B?UDcrWnA4N1hQYU1JeGpnM2xSNnFzZTZKdmNkNndvN1NZSDR6TXNPaHVLZWVG?=
 =?utf-8?B?VFlLV2dtRkZBOUU1ZGU4NzdzQllmS29tUXltVGxMZnJDaGVvM1lHNkwxTzZN?=
 =?utf-8?B?VW5xRGprQUZ0dFpHVGp4eDJoRG1BRHpXRUZZZmNWamxoOXpISC95ei9zYUlk?=
 =?utf-8?B?S2s4d2RrUGo1MjREY3pKclQyKzhQaGRldStNRFljQ0pQZmEvallocnpqTXdR?=
 =?utf-8?B?blFEWGlzcEVjMlFkaW1sVTNxdzJlaFZFMDJ6bWV0ZmE1bWtSTkszekpUR3Fw?=
 =?utf-8?B?dWcvazZ4NFdDUFFaVDc1eUJJUTdudERNRE5yaUZkdExoa3Jtb1NOSGx5Z1Zq?=
 =?utf-8?B?a3R0eHFWUkNGYUtWWDk0aldBS1FscVFUQWJ2WHJsTEc5SUhmUEczT05ibTc1?=
 =?utf-8?B?UGNhRTd2MFhpazhCcGtuREpDYVI2YUVrTG9UcFhENVdiUVFyNVd0YXhtZlJm?=
 =?utf-8?B?K3NRbE9XcG42eWNkenUrOXNjeWM1QlBEa3FtS3Q0TlhvYXRKSEdiMTlTVkU4?=
 =?utf-8?B?ZlE2eUNoK2hQcFc2dUpvNWswTGkvVmx2RG5MM0h3bU5XR3AwWU9CVlBpTzY0?=
 =?utf-8?B?K3hYbzNKL3BsYk56Z2FqL3Q4Ukx1REZmaUNtMTRYRlQwR05XWlpoL3ZyWGk2?=
 =?utf-8?B?NVh1TTJrYjRFdHBiM3FnT2hDUG5CVUFlemRvY1RTNmlYL3E2M1JwdXJDTGU5?=
 =?utf-8?B?UGU2N1hkeU41YTA3TEZVSzZObXhCK0x4Y1JhTk8yd0MvemhmaThnRHBkTWEr?=
 =?utf-8?B?eGdOcE9ZUTRkd2RWbEgzSEJUTFM3VzJMd1ZUNkxIVFpMa2lYYWI4V1BZM3BJ?=
 =?utf-8?B?ZTBiT1hCSDZIdlArTHo3MmMvUCtEN3hqRCtqWENDZjI4WkpjVDVra2Q3TGZ2?=
 =?utf-8?B?ZmdYZ0gza2oxNlZTSGRTUXF4L1FvVnB0MUdaM3RvZlhYRWdlN3FMVzV6dGEw?=
 =?utf-8?B?eEY0TE5oNnVMNUhuSEhCSWV5MHcrRWt0SzNLSVNEOCtZZ1NJelMxcUtsU0Nt?=
 =?utf-8?B?STV6amRaTlF5ODJyZnVlSVR5UUpEalBZa3pNV2lhS0p2cXBDSGEweWxDM256?=
 =?utf-8?B?Zk9JWnMxY3lQR2N3UHk1WUQ2eUFPNCtyU3NZd2RlbUpiZFQyVjh3RkZ6ZWJU?=
 =?utf-8?B?Q0xhZEpPSnhkaW1PcGRVdnRUMXRXckhCWHU3YkdCMk93RDN2RG9SSm0zM3NU?=
 =?utf-8?B?b0x5MGUrT29pc0p1ejhrd21NOWF4elVSeEIxQmNNaERRb0xENWN1dnYyVkNr?=
 =?utf-8?B?VVhyaXEwKzY2c0VRMVFYZTE1cGRIbm9PUUVtNHpXSXJKaXNwbHgxak9YTzVs?=
 =?utf-8?B?WU1tMVBVSW51VWtDSUp4Mno4azZKYVUxVTA0OHdNazZZaWs3NW5kanUwejZJ?=
 =?utf-8?B?RjhwQlVpdDlDbFFXd1dyTlpnSmVyMmQ5TXNMSVcxUS83RXVWYkRkdUYwQzFI?=
 =?utf-8?B?WXl0WGZOVUtwM3VFSHlHTnVlSTdEU1FRNDJ0bU1FYkZDVndFYjhZajZKdUhK?=
 =?utf-8?B?VWNIYTlRMWh2Si91QjZQZWhXSm16aVhWWG12RDUxR3dOK2lCQ2ZxOHd6ZGtp?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 826434f7-46a1-446e-9aea-08db8c50a972
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 14:17:07.3815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnFRYEXa3/C2IVCpmBC0Zsqrkuf/NA858+Ce5VGmWKBUreRW2ZKGoC0EeqiRbMBOpvfx3AXfE9JgG5cTGz23eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6200
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/2023 5:13 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:43PM -0400, Yang Weijiang wrote:
>> Save GUEST_SSP to SMRAM on SMI and reload it on RSM.
>> KVM emulates architectural behavior when guest enters/leaves SMM
>> mode, i.e., save registers to SMRAM at the entry of SMM and reload
>> them at the exit of SMM. Per SDM, GUEST_SSP is defined as one of
> To me, GUEST_SSP is confusing here. From QEMU's perspective, it reads/writes
> the SSP register. People may confuse it with the GUEST_SSP in nVMCS field.
> I prefer to rename it to MSR_KVM_SSP.

Hmm, looks a bit, I'll change it, thanks!

>
>> the fields in SMRAM for 64-bit mode, so handle the state accordingly.
>>
>> Check HF_SMM_MASK to determine whether kvm_cet_is_msr_accessible()
>> is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/smm.c | 17 +++++++++++++++++
>> arch/x86/kvm/smm.h |  2 +-
>> arch/x86/kvm/x86.c | 12 +++++++++++-
>> 3 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>> index b42111a24cc2..a4e19d72224f 100644
>> --- a/arch/x86/kvm/smm.c
>> +++ b/arch/x86/kvm/smm.c
>> @@ -309,6 +309,15 @@ void enter_smm(struct kvm_vcpu *vcpu)
>>
>> 	kvm_smm_changed(vcpu, true);
>>
>> +#ifdef CONFIG_X86_64
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +		u64 data;
>> +
>> +		if (!kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &data))
>> +			smram.smram64.ssp = data;
> I don't think it is correct to continue if kvm fails to read the MSR.
>
> how about:
> 		if (kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
> 			goto error;

Agree,  will change it.

>> +	}
>> +#endif
>> +
>> 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
>> 		goto error;
>>
>> @@ -586,6 +595,14 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>> 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
>> 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
>>
>> +#ifdef CONFIG_X86_64
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +		u64 data = smram.smram64.ssp;
>> +
>> +		if (is_noncanonical_address(data, vcpu) && IS_ALIGNED(data, 4))
> shouldn't the checks be already done inside kvm_set_msr()?

Nice catch, will remove them.


>
>> +			kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, data);
> please handle the failure case. Probably just return X86EMUL_UNHANDLEABLE like other
> failure paths in this function.

OK, VM should be shutdown if this field cannot be written successfully.

>
>> +	}
>> +#endif
>> 	kvm_smm_changed(vcpu, false);
>>
>> 	/*
>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>> index a1cf2ac5bd78..b3efef7cb1dc 100644
>> --- a/arch/x86/kvm/smm.h
>> +++ b/arch/x86/kvm/smm.h
>> @@ -116,7 +116,7 @@ struct kvm_smram_state_64 {
>> 	u32 smbase;
>> 	u32 reserved4[5];
>>
>> -	/* ssp and svm_* fields below are not implemented by KVM */
>> +	/* svm_* fields below are not implemented by KVM */
> move this comment one line downward

OK

>
>> 	u64 ssp;
>> 	u64 svm_guest_pat;
>> 	u64 svm_host_efer;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f7558f0f6fc0..70d7c80889d6 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3653,8 +3653,18 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>> 			return false;
>>
>> -		if (msr->index == MSR_KVM_GUEST_SSP)
>> +		/*
>> +		 * This MSR is synthesized mainly for userspace access during
>> +		 * Live Migration, it also can be accessed in SMM mode by VMM.
>> +		 * Guest is not allowed to access this MSR.
>> +		 */
>> +		if (msr->index == MSR_KVM_GUEST_SSP) {
>> +			if (IS_ENABLED(CONFIG_X86_64) &&
>> +			    !!(vcpu->arch.hflags & HF_SMM_MASK))
> use is_smm() instead.

OK.

>
>> +				return true;
>> +
>> 			return msr->host_initiated;
>> +		}
>>
>> 		return msr->host_initiated ||
>> 			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> -- 
>> 2.27.0
>>
