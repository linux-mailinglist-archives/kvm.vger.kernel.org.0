Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD070EB88
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbjEXCuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjEXCuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:50:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F134E9;
        Tue, 23 May 2023 19:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684896616; x=1716432616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iy8HlYRDqt3tXLphVOEER8uov6OIiCPDFaIxoHEF37I=;
  b=Yslgza5582WMMVslzPF8brlUDceluotRBk1GMKRAc/1uMl4GUE7MOM6q
   onW4e8GT4KeTp0rwTez5bnp3uYM/Ehj6vlhYXLKIJEe+Y2oJnwhPO9668
   bvFYTp4yzhqpOgiTTD7BW6k/RoWmORBAvfIp8OL8YEhwODS67Ci3POZG9
   pSN/DaB46tZQU7rOBRlHaumrgjFKT/Eivx8cgLAXfG1xuSWa3e10Pjn5r
   iUOfrlQh6W+qOncPRGcCiap7emPGpe8gsK3NnO39fj1HU3SBPqRQAtxpu
   QODHE+5Dw8UNEWNZNzDcdqveTQfrdKLQH0etn1qN0LCaSR07EdFmWufTX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="356657056"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="356657056"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:50:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="848555376"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="848555376"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 23 May 2023 19:50:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:50:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:50:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:50:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:50:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhtTe93Q7oA3e3AWcmAkxcRObGJESTXKZUY1oSPj0smjGQxs9aI+G3a8R2SVDOOk9TLDIEbCrlzaOS/9wU/3ufFVbKWzkEseveSc8YrzjY/ck/8wmb2s6G687ZRv7N3jWn7WI3O06kCsgszsWZc55mvsD0jl1RhdQo91UeebgHSIP2q88nyq5WXarBxJX3HnCBQaHdXqYGDs2BVVO9UX9Em6e00zVO2GmBkhHuZeCHoaH+xXE4qC39n8Hy91n1pIecijJEGfcs2YZwsYklIjIkbFjYhdjh+dlA0oLUXlN7e8Gzf5GPn6cgS2ODPQQX4eSMA9LvNt8KW49XtXPPYokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vohWCFghueASazTNVNWygIGi21x99ZxSLFpyHQPj0aU=;
 b=nzKDt9564JLFikegtSluJy/eUxKMirl/XsZIAgxQ4Mtxkt03S1g9IBPkZTHo5zoG7x5KuiW9969PD9gdtTTuu/TSm3lZentIz7GkiHWZmTPeoPlUAXyOh3gZxikZnYgAVAKRWHOAYnp9cdt8AiCnR49ItaPZJODn9vAy02rvN+M/DB09bqdLGuwDxSA5QMW2X8ADAmElCJ9dmMdgoi5k4XjBSPsvZ/wFP9tkKtYV757/VTE+InYgInxFG88vwge1YcOdNum0ul09ebjJKTazn02pzIdQM97TMbSmlhuYJJpoQOvJVF1QWz1+6ZjnZmAUIRHbgiIDj+TEdrYRuWJ6pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB6493.namprd11.prod.outlook.com (2603:10b6:8:c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:50:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 02:50:11 +0000
Message-ID: <72852c92-265e-5ae2-6f88-044181f8a1aa@intel.com>
Date:   Wed, 24 May 2023 10:49:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <30c89021-5b82-c676-bb58-1b572e57436a@linux.intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <30c89021-5b82-c676-bb58-1b572e57436a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0252.apcprd06.prod.outlook.com
 (2603:1096:4:ac::36) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB6493:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5bb1c4-639d-4ce8-b4d1-08db5c0197bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /CEuwoPkXcBKAvMNknsQKD0FSF2r+APxSC0kv9tHfSwnEHDQS2cvTEa9YoQPL8Y4P//fZu3xlrEarfE32a1VinHFWlyrg8NTfdgvq5vm5m0FUnUEI5MTZE4P130/ntI/OHHKVogqLggH7cFlMPaRKRN63otgLi7WwKOocxBwrU1hEHrprWLNb7cFzM4oh7pziH4PGu5By/W6+574oLC3D0zPE1l5JhTs1wcc4jx9SXXm9D+3csBqduriTqyrm7zZm627uPr+9TqFrrOkXidIO8Ne5NdS0c6kF6WKABs/MMybEUr9gmVLIUito961YHTCWKTte4Ri3vcTv6JdDINy7g0weZxWSvHC2reVnfKJreTCf/5qE1PnEAmAGz6E5laCTE/WLLAmoTPIEP/3/IBm+ygbM+JG1ZsZ4P0D2qQDKUr3T3FvFnr2mr6ifXUjvcJ0F0na6GJ9dhQfd/qAfPVc3D0ACxBtaO39y13kzlVsBoHF+aDdJEkO5OHnjX/pbK06f+/j8BhmrCAkwWOmVjQwBpfUkNns0lxsralQHwr+KChcO4yOxD+T8gOaZMg00CIO2+WQwu8rUknZvjj8wkXORIDUjA4G53M6ew/DIDe7qV2gEr4pUXWu9rZ0f5MMYvSNDKqDrlrvkxBqdVvUwR5OUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199021)(6486002)(41300700001)(31686004)(478600001)(31696002)(316002)(66556008)(66476007)(6916009)(4326008)(6666004)(66946007)(5660300002)(86362001)(8936002)(8676002)(38100700002)(6512007)(82960400001)(6506007)(26005)(186003)(53546011)(83380400001)(2906002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkUreitKUVBiN1kvMWJsMDJJRGcrTHdySndDRWtoKytMNXc3Rm1QZXAydHh6?=
 =?utf-8?B?TnZWNzBDN3QwV0ltK2Q2THhOUjZvMVJtNEIyWDQyWVRtbW9FYW9PWXJnb3l5?=
 =?utf-8?B?VFR3VXRPMXRVK3RoWTNiSUNEMnFWMCtBdldMb3l4bnQ3MWRqdGhlZDZ5WGVP?=
 =?utf-8?B?eTdNd1llL3JzTVlEOWd5Lzg1TXVnSU1mRDk1UUE4dFMrc1Z4a3ZCSlhHUm4y?=
 =?utf-8?B?S3loanZlUCtpdGlPdzdzRjlUc0N4MlhaUFhNNzFUeWxWbjFJbmZtcVZWTVda?=
 =?utf-8?B?bFhnTG5JYWtvUWtTNnNlWmtuakxrejZLMWM5Zm91QWtwMElzZUx6WmxEOUxS?=
 =?utf-8?B?YjBpbWlhOWh4TERMRGsyM05pTjB2dXlFRmV5Qnp2a0c2bmxZNlFkcGk0QlBF?=
 =?utf-8?B?UDVIN0FUQWVBeUthb2Q2M0hmV3VlKzdUbUYvZFFoU3lJc21sRDB6UlZxYXFW?=
 =?utf-8?B?TGdqQWV4T3NpOWY3MUJOQmUvSllPWEtDQWs1WEhIRzhjTUc2S2d5ODlDVlhp?=
 =?utf-8?B?YmwxM2xsczV1K3NhdVdpVXdsdWUxUmZGM0hGVVViZkM2aDF4elU5em5Jcmph?=
 =?utf-8?B?U3FGZTA5TXU2ZVJlN1RtVzIzTU52WmVyQkpHSi9pb0lmTFB6OXNTdzVPWDJt?=
 =?utf-8?B?b0xJaGJ1WHFsanRWMTJXZmNpcjZnNyszRDJWUVJUWkVKVXRhanFVRjFFNUVa?=
 =?utf-8?B?NDVXaElYZWlVVUkza2FzVFVVaWdJWk1OM1FqbzFBWFA1amVPVGJMTS9CcEJN?=
 =?utf-8?B?UFF6ZFltRE54OTdQUnFuMlJVcGx5dG5lb045aEYxWFMrQ3E5dTBMd3hUY3By?=
 =?utf-8?B?cVo5U28wS2ZvZ2F5MmUwdlJvRnYvSjYwOUpWbE5JUDNQS054SUlyaWQ2MitC?=
 =?utf-8?B?cy9Yd1ZXc0grbHRNNWJydEpJMTducFBrZGcrOXhYQVRtUEhNMVRqLzdmSll2?=
 =?utf-8?B?U2poQ3BybDRLbEZ4L2Nhc3BjQ2s3Uy9KcE1JeGQyaGxWcnVUZDRKMS9mMnFz?=
 =?utf-8?B?emxqL2ZyUkVGb1F5MkN2QjY0UFJmUEdWcW5kM0JPNnhNMWJRTkFYYUljemU4?=
 =?utf-8?B?aHV1OEIrM0xNZE1OUU4vVGxVcHZ1aW9JcjlwRjBqa3lpNFRBZzBJbDNLU1hL?=
 =?utf-8?B?MHpYTnA1QkxyWEUrakhaSDlMNTdiVy91R0pDYk9nUXB1M0tZWU5PVnVWSjZR?=
 =?utf-8?B?cVZ5bVBvSndnRFk0WWNicktlMFZRWDlzTXNZUzJsd0NMYkk0OWtBT25iOHZ5?=
 =?utf-8?B?VkNDUFdJMWtmdjJtNEtMQnhOcXk3YXYrdWtBeXNFQy9kZ1FlcEczK1llNGZE?=
 =?utf-8?B?ZS9uTWF2bWxUcWNYZ0d2bHZDcTRxdDBhaHJWVEE1OTNTUVJjMmZZNnVSbktz?=
 =?utf-8?B?dnJaeUVrSWRVQU9vSFhaSkpTdHFMM1dPN1NGY0c2S094ckJHVnFGMHhOSzR0?=
 =?utf-8?B?R3dHQnc1TUtGWmdSMkYwaHkrbllyOUdyTUJaakdudEIrclRGYjlucnNvdlBs?=
 =?utf-8?B?bVZyZStlRWJzRW1lZmRTVCtGVU5ic1FzRy93WnpSWFozOE0zN2NORVRoWExF?=
 =?utf-8?B?SmJXcFl0d0Q5bzVEY2NEZnhqQmZVanhGWGZ1THF6ZXI1VTh6WEgrYTBzNjNK?=
 =?utf-8?B?VjZIcUtiMVVYVVFYS3ZwaW9kSjU4cGJGUGt0UEZsaFNYWkRlSmhEbmUyUXZG?=
 =?utf-8?B?WFZpSmdaSlhYdGIwOVVxbDJDUlZxZUdWR2N5cW5kOUMyTzg3NVIyMVhWd3lH?=
 =?utf-8?B?UEFxWFBxWWVJT04vS0NVUWNSOWx3K0dLVHUrbUxDck4rdmV0R3RVelFkRTBr?=
 =?utf-8?B?MS9CZWtFNWtqd1lwYWY3ajQ1Z1BFMSs3K2ZkTlpIdWN6WEhPM3dmSHkzclFJ?=
 =?utf-8?B?MzZKcDdET0FtNmFCbGJQWWhYc21yRmp6MjhCVWFlOURvUG51SHh5dkYya3o0?=
 =?utf-8?B?V01RSUJvNi9BUVRzK1lZQUxvMzNUeVdBTDBKcG5IVVFCOGZGOWMyOXZSb0Nk?=
 =?utf-8?B?dkczVmJTcDNsWnhMS1RZWVBHekxhZWZwUkFTdDRNdGI5ZC9IV0Y0NGZxc3VR?=
 =?utf-8?B?M3ZVVytoa2xtNHN3SVMrbW9LUFdtL1dzNDBLSHZHb2w1a0J4K2ZmQXlFR3Ur?=
 =?utf-8?B?WVJsRmQxRDVNR1FVRFM5VUhhQlpxbWczbHIrVHg1WTdFaDMzenJBLzNmNGNK?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5bb1c4-639d-4ce8-b4d1-08db5c0197bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 02:50:11.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+HZpvxya7yhgBXwDZUGCfaZql5JhsNYoT2EAJUbTKQyVaytslxAwhlFQPLLcfyWYKFCnXery8Fw6RUKBid1IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6493
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


On 5/23/2023 4:21 PM, Binbin Wu wrote:
>
>
> On 5/11/2023 12:08 PM, Yang Weijiang wrote:
>> Add support for emulating read and write accesses to CET MSRs.
>> CET MSRs are universally "special" as they are either context switched
>> via dedicated VMCS fields or via XSAVES, i.e. no additional in-memory
>> tracking is needed, but emulated reads/writes are more expensive.
[...]
>> +
>> +    if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
>> +        !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
>> +        return false;
>> +
>> +    if (msr->index == MSR_IA32_PL3_SSP &&
>> +        !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
>> +        return false;
> It may be better to merge the two if statements into one to avoid 
> calling guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) twice.
>
Yeah, it sounds good to me, thanks!

> e.g,
>
>     if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
>         (!guest_cpuid_has(vcpu, X86_FEATURE_IBT) || msr->index == 
> MSR_IA32_PL3_SSP))
>         return false;
>
>
>> +
>> +    return true;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_cet_is_msr_accessible);
>> +
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>>
> ...
