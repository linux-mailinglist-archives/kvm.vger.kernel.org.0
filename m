Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBEA7D4ADE
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJXIvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjJXIvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:51:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0A1AC;
        Tue, 24 Oct 2023 01:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698137466; x=1729673466;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l6OsX3/9lH5s+21Wtm1CyKjYzTU4/4uhEe7ocZW+wo8=;
  b=Ho4ZXZMsimhi6PsKL5cbkDgdN1ndu6pLpVIxMHvOb/mka089vFyzWHcj
   MkQ+jRtJ6810+yHP8JRzne/+qmyZFI2/foc8BXN6DnmmAz3TDiwVgnyOj
   RkrnwhMLDzJw1O6XgBI4kWM+Q1f18+Ut6EiVDdAk/DVVx4Q6qEu7ui07v
   Eog1aQDnaO9Jv+9ZZ5m4weIoI9dPJyIYMb2rnZEglhxhNpH18IjcR/vTv
   gB8SlV8J9FhMVxHI0RppoGNhGltC+u3Fjiyu1adhubpC4gAzaaWaERzEP
   hAoOSshYHgFcUc+NJDYUof5YG/h9DIx0+o+VoeHECoTYSidpgPrcoadgd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="451245904"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="451245904"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:51:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="931969703"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="931969703"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 01:51:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 01:51:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 01:51:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 01:51:04 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 01:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HA8GfX30S0V1/JrAuIc1zm7DWeGo0rJln2bfltUlIEPRBk4scNmADgOfnHXM6EdaXwPRSX9UORbEXK85k/QVFIXnfqkYXrA4eMgfNDp/hSmaqm+3cMUDdI6jlFzYv81UJXAORsByqPVNz4qOzf5HXCXX/xBo0jMFIDHmfpYSC9sAyoV/weNRlRcbpVxa3aCJ3GpxnKEHpHClTJRWonU+j/8KAVz6Qzs5bzrO2sF7asvvkTE8i2NtdCalEOtu1zJc0oeYAClwp/0asSmEJfA8pr2TzxJwudzZO1zoDlpQulpdksSGyjXJBPetPGjDQrBnhHftbvCPKO3bN7zG7m1fvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcfpOVXR+y4WDQJy3V/pvu3f7A/UVXM67D7BqUCKwQM=;
 b=GIiVOqInXOK/PPUTFyMaI1jZew1lxLnj0t1n2drjI3YtGAKGYc7Qbip0MaCa/ue6s/XJxWvC6fYWW2RjaFm8LudZwwPS06psPYJxhzGkkTYiL2+5hIRb49vAtJqRmqihVuY+mhuZ3CXEcaI5Qd1T2TSWXyZDmnAsnUcrV+ZC4x/vmoXdD22sy4XMFEe1tbjGudUbhgE154QqGqARP8e2vUOfOYA27kZjLR3hWrbEqRElhW5kfyTCJJ6U3hVbQg+4OG/5LDX6JiWcllnitomKE5IYduRyjxabUhxaRz2BF5LdQBb7QQkC6fqjL6t3ppO1WAQvnwG7Ov+e/kQNGK1jpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5867.namprd11.prod.outlook.com (2603:10b6:a03:42a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Tue, 24 Oct
 2023 08:51:01 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6907.028; Tue, 24 Oct 2023
 08:51:01 +0000
Message-ID: <e02b39c1-96aa-faf9-5750-4c53b5a5fb46@intel.com>
Date:   Tue, 24 Oct 2023 16:50:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-3-weijiang.yang@intel.com>
 <ZTMdyR8e63sCTKWc@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZTMdyR8e63sCTKWc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0212.apcprd06.prod.outlook.com
 (2603:1096:4:68::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 178e6c4e-72b6-40bd-b376-08dbd46e58f4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/c5ynKqahZc7vOmvlJHmCNT3atXCFi21Oldqx7r/POE7rpof2W+ex3OefPrVxxibGuSwIpk79BHoRd9Powif3hXF7bUQgrQchVwJgz2GAuIyxIFUMAvvFFrk5tKlr58uIk5z8pptFIP+XXT0Wp3vcuqNUgdETm9L9wq1HJN8jHepu6RgRLek+2zW5N9FL19h2VgB1e6L8xISh3iWw+hNajb6rkAXH2hVAev0IxJQQZe+cp3m1yvQAbqVAfgmNZ6mBQaHqw5aXBxDJ2ayuK0bRffra6srRXMWx0/MKvlbpnVqjlth/UKYwx8ZTIMT32uLyzWtPTHbukBk2Mu0oNqxqYg6Io9f1Dqqj9S7UMDj1zFHw6bhhrPd+pC8LEUJOKy+U0Xl7HTN71Q7qCGEEG4VyDyZ1+oQ2L8Y1oEIwwNggx9esoLvNDKpvmPS7APHau23OCdYNxV7gpsha4gEqtyF2Aki2tWikyIatA+JMd1RA4+SjtBRiGYuYqNLKTy4bp5w2+nLxWYNgVCcczkGeu5C7uj1swuhQ8HZhf1DGMIClqhwlXXqNLdp7XzZYrvCTbgAAHctk8bK2e/7cu/u2Eir20hMAwmU5rkJumy8NzHhhXR16xbgjpc5eV4iqOtGoK4hCBkjO8WS35QUHpd6+mDVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(39860400002)(396003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(36756003)(31686004)(26005)(53546011)(66946007)(66476007)(38100700002)(6916009)(86362001)(2616005)(82960400001)(66556008)(31696002)(41300700001)(83380400001)(316002)(6506007)(6666004)(6512007)(6486002)(478600001)(8676002)(8936002)(2906002)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wi82ZFg1NG94Q1d5QmpyOHJ4VENzc0cvb2haK2VIU3ZQTWJCQXM1T2pJZktq?=
 =?utf-8?B?UVp6eEI5MjdiU09BVE9UUTlpMlBDQXZERkMyRUlIbk9FWWl3dEw3WmZTK0Rs?=
 =?utf-8?B?MlRlcXdCTUludmZhV2JnZFRhekxuZ3Q0bndBL3R0SGRmYUw3YXA1RGpCNElp?=
 =?utf-8?B?N2p2bGJlTWJOYUxQVHdzQklWbURMOVAyMXNjUnNyczBOR3d0LzVQazg4V0x1?=
 =?utf-8?B?bjlVVDFMK1h3WEZPS0p2ckdrb0dUUmtZYS84Snh5TG5DbVozNmhJWXB5TE81?=
 =?utf-8?B?aTBXOC9lbkpaOHJ1ek14ZzV1MGFNTXRrdlV6TDNzY0FUWWVSY0RHYllFeWl6?=
 =?utf-8?B?cWtFOWg0OG1BTDYrTWkxMXhyS2JaM2F0S29UenF2bktzZm5uRm92RkRlODJW?=
 =?utf-8?B?TDFiVlo1VnliL0NuTGRCMmQ1aE1RUnNVcEhHUFg0azM3TG9tbWc3SWdlWDlD?=
 =?utf-8?B?eW12cjNWU3I2MnVmeUYwQ0lhWkpwYmlySjNZaTZTcytvL2x4STZlaEJ0YTN6?=
 =?utf-8?B?UHo0SDNFSFRmS29PWXU4RXhYQy9PU2diem1MZnlkUXB5ak5aVXp4VmVaZ0xW?=
 =?utf-8?B?RTZEYTFNOWkxdG5qRk00MlE5SzZsN1Yxbm1ubFRhdVNIYUhDZ0FmNkYxaDB2?=
 =?utf-8?B?U1dRZXRvaDlOTksvdWZRdkpiZTgybkdYRkEwcFEwd29mRFR2dGszSFhhTXZH?=
 =?utf-8?B?RWFGYURHVWFhSi80ZEx1LzdEWkdnWTBvQ3ZSOWZWalFYNk9EanRFdU9HTTgy?=
 =?utf-8?B?NTVVdWJQb0grMXJjMFBaYllNU1AzYWFidU44RXZCMWZwVHp5RDMzUkwyU1JS?=
 =?utf-8?B?UjZSY2lqRlQ5WGNRajArVG5BS3Foa05zdnhvT2ZoaEpmL2dOYU5ibXNaZDBy?=
 =?utf-8?B?UU9xMjNpMkhaMmFtbzJ5c2dmcjRUTitkWFV4MTRGQlVwM1lKbERrOFJoTlRq?=
 =?utf-8?B?WDJLcllhUDAxd2loeGNhVUlocFJuSGdCMGRxbGRyc1MwNk1xVytVd2pUeGNK?=
 =?utf-8?B?THFrR2FYOVNyUStycm5QQVdFa25kK0VWM3paeCtIbkZ6MHhpQ3YwTkNQNXBs?=
 =?utf-8?B?VmVydG8vY2FEd0JVL1RqT2xIQ3RKbUovdTIxNUkvVUl6SGxUN3dXL2NtQmkv?=
 =?utf-8?B?UWdXRnQvVDlYaXI0VGo3TWpiVlIrSVlFQjNmd1FLU3Rpb1puWlJhY3U1RzdU?=
 =?utf-8?B?ckpFdFlxMTBlTGhHaFNnSzcwMHVzRHE0bmVDMkt0NVp2NDVUR3lRUnpuck9R?=
 =?utf-8?B?ci9EeEYvV3lhVi9oUXFoYklVRmFUZWFsSWZjdkhSSlFYVmt3VGh3Vm5Ja0NU?=
 =?utf-8?B?dGw3bzZQZzdXUThLakhyREFvZThXZm1qYmQzUkZmeFV3SDFINHFwUW5WaWVF?=
 =?utf-8?B?WFBaNmxyMDVDL0EvbU1mNzByVE1Fa2JtcStvcHM1d3dNVlhwVmVvVWFTb1dv?=
 =?utf-8?B?bDZNQ2h2dXFOZXFoMjdBT1pvUXFwRFVHcEE2QUFRQ0Q0Z3pLdDJPbFc3bVk5?=
 =?utf-8?B?dE5GYmtWclFEdzh4SVZKczhNMDBoTTFvd2gyZ1dNWVU5N2pCbzBTVEx4L3Fa?=
 =?utf-8?B?N2VZMVcyK050TFRhQjJ1V0p1bXBrMVFWZDZuZzNZYjRzMW5SaVBHbTVLd01z?=
 =?utf-8?B?T3Mxc3dCTlNiM2g5K1B0ZEFtUVd2b1ZNMDQrT3VTYmYvaXZoeUNWdUU5VS9t?=
 =?utf-8?B?Ulh0b0tMVmRYWkg3NEUrMW9KM0x4azJpcktGQ2diNzR5UmI0WGNha2NRa0o1?=
 =?utf-8?B?eE1meUZuSGR4cnM1ZGUremtOOStYVlNDWnNjbjRmVnlBYmVlSTFTOHUrQy9M?=
 =?utf-8?B?SFRkSXlnak15N3hQUFNJT3d5TW91VGFWSEFWeGpUT0dLaWFBRklsZktvZEFK?=
 =?utf-8?B?WGVBY3M3SE1pYkh3WnREejJsLzZXb0ZEUlpKNjZNY2R4RDVqQ2ZsNWtOdDJj?=
 =?utf-8?B?OUdSTEw1bFc2VzJtOVJBQUVMVWhWOG9jNEdtWk1WdzhZVXVoTEI0UmFnTUxR?=
 =?utf-8?B?eGNYc2xWZi9KSDNEV3lnYjJsVE5STU9adVJTQWthdWJrM09qeUt5RHY0dGZ2?=
 =?utf-8?B?RWJTYnI0K0NDMFNub25YY2o4ZUdrNlBzVjM4TTB5UytoUnc5eVE4ZzB0bE1M?=
 =?utf-8?B?emxtaUVpSXdYZk9KcVpPb3VlbVFUZmpKREN6dlAzREZBL2Q0VDRvV2sxZGpk?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 178e6c4e-72b6-40bd-b376-08dbd46e58f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 08:51:01.1615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJMsM7lD7Eq4MDpUAnwH+hEMlNSEAVYpPC6IiilrtMPKQfV0PP6pEkx8X2S91D3OstozPP3BAe0edVRTey6vaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5867
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/2023 8:39 AM, Sean Christopherson wrote:
> On Thu, Sep 14, 2023, Yang Weijiang wrote:
>> Fix guest xsave area allocation size from fpu_user_cfg.default_size to
>> fpu_kernel_cfg.default_size so that the xsave area size is consistent
>> with fpstate->size set in __fpstate_reset().
>>
>> With the fix, guest fpstate size is sufficient for KVM supported guest
>> xfeatures.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kernel/fpu/core.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> index a86d37052a64..a42d8ad26ce6 100644
>> --- a/arch/x86/kernel/fpu/core.c
>> +++ b/arch/x86/kernel/fpu/core.c
>> @@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>   	struct fpstate *fpstate;
>>   	unsigned int size;
>>   
>> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>> +	size = fpu_kernel_cfg.default_size +
>> +	       ALIGN(offsetof(struct fpstate, regs), 64);
> Shouldn't all the other calculations in this function also switch to fpu_kernel_cfg?
> At the very least, this looks wrong when paired with the above:
>
> 	gfpu->uabi_size		= sizeof(struct kvm_xsave);
> 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
> 		gfpu->uabi_size = fpu_user_cfg.default_size;

Hi, Sean,
Not sure what's your concerns.
 From my understanding fpu_kernel_cfg.default_size should include all enabled xfeatures in host (XCR0 | XSS),
this is also expected for supporting all guest enabled xfeatures. gfpu->uabi_size only includes enabled user
xfeatures which are operated via KVM uABIs(KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2), so the two
sizes are relatively independent since guest supervisor xfeatures are saved/restored via GET/SET_MSRS interfaces.


