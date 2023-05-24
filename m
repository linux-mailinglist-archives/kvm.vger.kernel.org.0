Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F3670EDE3
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 08:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbjEXGfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 02:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjEXGfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 02:35:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF851A3;
        Tue, 23 May 2023 23:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684910145; x=1716446145;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BRAq5fEIHbT3JVzbgW5pUPfC8MHm2HgE/646FPo5wTE=;
  b=GyuS+xIfeEH46Bz5uEkSC7uwuFPCEYtZoWHPhHSsLUz2jVDs77zAh2BG
   7XHU/jZFdRRhB/qQglkH8pWWKMlZdKJ7qkLLx3I5DM+v1omO1f4MmBL70
   Ekw0VejqivKTkyzbIBSUyy1+J+EKe94RMbm7s333KBLR19JG4nwR3hI+2
   ahjyZYAGSoMAYlJvnf1qy78TeRXLVKHz8o4gATFymdDo6NROKU9YW5OQ3
   CsSzm6ge7ECUNn1p3FlTDdDlN8xzM0FoZXtpyrWgGaBeG2u2nIFxmwDuE
   goCeVHik6q2Vc2CF+A6OMUrdnqkrGU9GLCvFFb6pFEgm/Tnqchmor4Uxa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="350987395"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="350987395"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:35:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="950878916"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="950878916"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 23 May 2023 23:35:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 23:35:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 23:35:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 23:35:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 23:35:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sl58G4MrF5bYF2WDPIebvVQU/e+OESC3ldnQF811cLrJMjamxlmFnoLqeuukvMk49QVx24Ks4cin/WL5v71aC7rZYZjUN0OaUDtgWldya/eFPhMnkYosDXgJ7Odv3k4RIpLvF2Yiq3LKRCkalQVPaT1AO2Kns3qv3kdARs7RTn8Wps+9f2HQem6dgx/m8PN+TNMYXGc/XJxxXK+QaGVOIcy6RI9mVFH/p2tKZnjHzVsKf9B1AFBeZOmATT3bP0RcXgWA+582eYopy8Veq/Ut2Ag9Mf+czNZ/fvwLM2a28I8n0AnXxRJ6GCa5FjxovXslGJDFgDD75WpVgy2OQMyv6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsU3Kh+ZNIId1K6aj+f2qzR7hrWE348ivrYKfoI+t8E=;
 b=ISONQGxPPO9D74Ix6wgGkJoytwQgvWbRzgayYVUY65Ud2EDyl5bbG3YkL+Y2aK+5u9iyL9nIOUCm8Wam0WOV4JAntFLH0F9kah/LV7gKrOSxUhNspsiBU9ChXkjHdswU65XwhZXYJ3mPrZ9maEKCXWqsaH0h0ljHs4Epx4K9n6BWPJie4MBBr1f6nMdKtkbtwLFMMeK7tthDUaERFkHLfi7VZp48pVZtSf3isl1ZzDbxVSPSxtS4BTYZOtzwXw15EwHRBuok8XAI2hbMsT60G3qFIKY0i1+m70xExEIPDJ3UUffoUl7LyjE03xMkSl6TSV4EhsrUKGnWVnsG77fvsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by PH7PR11MB8600.namprd11.prod.outlook.com (2603:10b6:510:30a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 06:35:31 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::ff65:3afb:e028:4526]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::ff65:3afb:e028:4526%7]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:35:31 +0000
Message-ID: <2af0d399-727e-ae24-ef7c-7064240c735a@intel.com>
Date:   Wed, 24 May 2023 14:35:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v3 18/21] KVM:x86: Enable CET virtualization for VMX and
 advertise to userspace
To:     Yang Weijiang <weijiang.yang@intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-19-weijiang.yang@intel.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20230511040857.6094-19-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0203.apcprd04.prod.outlook.com
 (2603:1096:4:187::22) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|PH7PR11MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec899b4-2fb0-4675-eb8e-08db5c21122a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2IaBYPW37GMx66yf6ihRyhJ2H7YWGdGSLPDKMqjvuxtZk+jqguQ0t5ndgVRyQOLoUAZuLCiyt1iz6CtqrU1Gr7bDk3u2beAFzeraoo7qYXHEvGfLkewv14ZVWpMZFFBO0LLPutKFmU5eqAv097iOYeVa88IA7IUy/rY7ZqK+KWL7T19U33y+q/7p9fGyuZcsSr2egHR5grag14Qib9Cx+xHvlTlnHlOZJxfysvWhID/ADu8s12EvX/puuiNsY6o4Nai/M0FKxl1KI3PDSV7mzg8NVKpzzs3EUK07u16JxL3cNFjn055HDJx7bX3gBCpWnIeh7naOchlFGDUZXBhIXrVomz5Jn6zjP4nR8xCQur2+PQa+jlvSYOHQG1eEsPxrc6AHuXYtQFr3SHLNWdDa40ifDWRFdh7pz8N/+FctBH+dC4WE35jXjwV0OtegXPGo85l2P2xJjrIyGOrp2tId5xRVr7l8pU8YcQXz2bRGmdirLz6e4tRbiNHrMst6tgWiE35GpdxUNq53qOjCR1UfXp4ifm4kIJCrbSPetbwwwcMartG9Oz7DdKM+sU7mpQnQJbL9jksowLwx8XzR2rs68cZ746GAocNLZqyWDN7V/0tIw9q5ntpxdfxSbTrcb/61BL/cEE1BpMD3RJTQbcfc8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(86362001)(6486002)(41300700001)(31686004)(478600001)(31696002)(4326008)(6666004)(66556008)(316002)(66946007)(66476007)(5660300002)(8676002)(8936002)(38100700002)(44832011)(26005)(53546011)(6512007)(186003)(2906002)(6506007)(83380400001)(2616005)(36756003)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkJJNEsrN2FhNmFMLzBaRVpZdXpEa2pjbkV4cXdmYUNOZFNTZENJdU1Ca1Zq?=
 =?utf-8?B?RU5keGNTNGZrOEREMkFFbmpUektOMVVyTXlsRU5IUnI1TXY1b3lJZTlEM21F?=
 =?utf-8?B?dEUxQ3VQQmY1QlpyU25nWkZrZmpKMkIvdWlMNkhyNHFIazB0SFFGRzBLeG8v?=
 =?utf-8?B?ZS9IaGpxTEhSZGZxTHlmejBqSTZPaGF5UUdGYm5iOE0xTUJ3azFoandmZ0o2?=
 =?utf-8?B?TmN6MjZWSlU2RVJER3BrcUxDMzRKeTBZeVB3alR4RHd1ZHhQRkpJTC9VVlBY?=
 =?utf-8?B?NFhhSmo1ekF1VkJXY1VlcGFtMnhrOXRWb3Nvd0grK3haTlI4ZE5saXdYNHR4?=
 =?utf-8?B?M1U1bVpzaUtZeVArZGtVaHhVR09OOTNIRU9UUnZ3L0sxbHlsa1ZlbU9EWmV1?=
 =?utf-8?B?MGdRbjgzT0crc2o0dzZCWGlQU3o3WHdHREhHQ3FUTVVsa3Iwb2ZCencvMVht?=
 =?utf-8?B?alpsM0ZWV2FTeTdkUkIvR0pUdW1GK1FHTnJlWSt6bzdUU1l5dzc5Mk9nN0xU?=
 =?utf-8?B?TjNxTTY2ZXh5OStjRlFLUnRRM3ZtM1NHdjUveXRXWmJkaTZ5RkF5NDFBc1FV?=
 =?utf-8?B?ZTZRbEpOM3JyNDZFMy9hbE5pL3UreGd0KzZjb0tOcm9raXZWeGdFVXkrVDFj?=
 =?utf-8?B?dXppSzVTMVl0VytyNGxBMkdWZjI1di9hM09hb2xiUW03RzhDM3M4bFRTU016?=
 =?utf-8?B?eTJTNCt3WVM0MTFHNzUrS3F3aEpiUmkvY3dNa1dJU3ViYmdGek1IZ3E0U1li?=
 =?utf-8?B?UVFvRXhqaURnUVc3Y09uT1ZtL1NwSEhHMEdZNlN1RjhWcWFiV2dqZ0xqMDdn?=
 =?utf-8?B?MGhmWk56N0M2dUdBRmlFckpBaGo5SENhajl4VW00Y0ZjVWNneDNCeURVWjNS?=
 =?utf-8?B?NWJ6NStsQkU1VmhkUU45cG4xTkVuUmRDdUZ6QjNDVGVZbFdFVVJnN0d2MDRm?=
 =?utf-8?B?T2QxdkF1dXg3aEVQOWN3V3RYMFZEbVpmSDY2N3JqV3JEVy9pUkR3ZWFTU01k?=
 =?utf-8?B?TStKZ29Wa1l0d1dESXNrd1V5M1pJOWlpdnZqa3FGOFBQd1NEZEhRTnJpU3VK?=
 =?utf-8?B?RUhrc3NpRXpsb1NRbXZCeHRhTnN6SFJ4YzRUa25vbWtHMUUyUkZUZGcxMmNL?=
 =?utf-8?B?WjNqNXNsQnA2QmUrL3QzT09sWkNQUjNaaTg3NWhLNDBCbU5vejZHWWgzUk5X?=
 =?utf-8?B?WkdsZDhkZHA2cFF3NUtCWE9BMFA0eHY4SXliZzlwZktaNWhGY0I3eHNEYkVZ?=
 =?utf-8?B?ZnZCTjBwTjZ1eUpLNlVlcXJVM0hZME5CRFZ2ekFFMmwrdlBDaDEyZ2xXL3B6?=
 =?utf-8?B?T1ZmYTh6OGdSa0JmZ1loS09UVjk3VEh1dFVVbHJ2OWZGOWhYcUVUV21laldG?=
 =?utf-8?B?YlNDUXBQcWtzU0tmWDdFcG9pSndIWm5SQVpyM21lZWN2R1h6QjQ3MmlXejNB?=
 =?utf-8?B?N1NJTkZlZE1OcVQzejVrbVpyTEczS1Z4OENYd1lNa2VmQTBSUXA3eXVzckZJ?=
 =?utf-8?B?V2szdUhQOHhCbGFlWmFlOVVPWS9nTkM4MVNDbVZaaHdLZFhnWmRpMDNCSmZl?=
 =?utf-8?B?K01JSXRjM3pkaXM2ZXEzbDhpVlNjMG9iTm94TXJ3bEhVSUhXNVlEMysvdmJH?=
 =?utf-8?B?TDU3NEFMMmQ0R21nV2ljc25VZS9EbVRKTldnY2JrQ1RMazVCSHJnbUtCdSsy?=
 =?utf-8?B?K3J2RG4zZlNqWFNHQU1EZjFtMVJ6SFpvRnZVemdPUmNicENMRFhrZkRJNmY0?=
 =?utf-8?B?RDZIU01YQkJjeHRnWktWcS9qaVlvOXpJY0dyRWR5YWZaV0tZRm4yd3B2SVZB?=
 =?utf-8?B?YjhBWEl2ZmxCVHM1aGl1OFBka0FqOUE3bzBsdkV2Z0VqVm5CT3RPUHF0ZW9n?=
 =?utf-8?B?YklncVljMWxxV2N3T3pYbzNFM2RIMTMwdktUVHRnQmlzMXBNMCs2dU5GYmd5?=
 =?utf-8?B?d0dSbUd1S3RQVTRFU2J0MTlCYWRJSDR5U1d6UnVPZjRmKzQ5N05mQy83enVz?=
 =?utf-8?B?aytPd0NUclRvTUcxbzBMckRTanRKTnFmREEvYS9kUUJhZzRCU2NkbFkzY3pQ?=
 =?utf-8?B?eWRDbDlWT01NcXQ1MUt3V3ZzYitMQTJwTVdiY0YxSm1HNDdvT0pFMS9veDBO?=
 =?utf-8?Q?8brDGZRUqbLTPdW5wNZpH9IMu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec899b4-2fb0-4675-eb8e-08db5c21122a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 06:35:31.6317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fj2o8mtmgiHJVBxgYMx39uYCU2NZY4Xb8n1d9XEhUcIDHW4t1kDzwHsXc1UV1vmF0fzv/1i4SZR0CCm+2W9zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8600
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



On 5/11/2023 12:08 PM, Yang Weijiang wrote:
> Set the feature bits so that CET capabilities can be seen in guest via
> CPUID enumeration. Add CR4.CET bit support in order to allow guest set
> CET master control bit(CR4.CET).
> 
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
> 
> Don't expose CET feature if dependent CET bits are cleared in host XSS,
> or if XSAVES isn't supported.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/cpuid.c            | 12 ++++++++++--
>  arch/x86/kvm/vmx/capabilities.h |  4 ++++
>  arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h          |  6 ++++--
>  arch/x86/kvm/x86.c              | 21 ++++++++++++++++++++-
>  arch/x86/kvm/x86.h              |  3 +++
>  7 files changed, 62 insertions(+), 6 deletions(-)

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 50026557fb2a..858cb68e781a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -226,7 +226,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>  
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER)
>  
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
> @@ -9525,6 +9525,25 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  
>  	kvm_ops_update(ops);
>  
> +	/*
> +	 * Check CET user bit is still set in kvm_caps.supported_xss,
> +	 * if not, clear the cap bits as the user parts depends on
> +	 * XSAVES support.
> +	 */
> +	if (!kvm_cet_user_supported()) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
> +
> +	/*
> +	 * If SHSTK and IBT are available in KVM, clear CET user bit in

Should it be "If SHSTK and IBT are *not* available ..."?

> +	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
> +	 * false when called.
> +	 */
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;
> +
>  	for_each_online_cpu(cpu) {
>  		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
>  		if (r < 0)

