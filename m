Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C83B7A13ED
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 04:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjIOCpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 22:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjIOCpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 22:45:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA14269D;
        Thu, 14 Sep 2023 19:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694745939; x=1726281939;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VTQwm3SCZ5EiebapuMvHZiUGNBwAnRyh+rFX3VXXj5U=;
  b=W8ZeTbsBh41UCFIp5hbmGvzBEP1HAb8pHy7RcWBYXyEcA4Vih/sSX8Ka
   DPfvIvEJJzzH30lFOWKNoCxF/9lfamXf3WSA7v0X0TIhlW6Zbm2mdZCWI
   G9QWpq4ce2WKQFUvE3gOJSNwlsQIZ8cHwCgbYbx5GzltOfWGSod4/5Rke
   MP4tl5zUYUIK8fqzB1EvKw4s76fAinYpiarKGq6T3MQtjkPqVAQPO4tp1
   KCk84TrkjO5RDWPXdBVDMS2ix95V4mSgL4kNMmfZmc/NxVzuizvJdcjZg
   za3/KPa/juIS6T9KtEQ77D4nlT7wqC7IKTidr4QoQ1Hk7dOc3Oh1C8Y1S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="381868731"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="381868731"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:45:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="1075627938"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="1075627938"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 19:45:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:45:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:45:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 19:45:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 19:45:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBLJcwHZ9d6iFt/WGO26PY6uJXzMW2DAJod7MUONItvfuqRt9m1uXTfl5ZcaGsJ3SowGoLoX2cMbSNDKbIBDXYuxdUKtdA42qr4WXzpYkA/L1vj3aTUy4S5MRfFoTax4EudPk6ijXxTQ96sdpZazixgiZvDbpaXpbXoTnGgd7C9FCDA9CDWH7xkoie3TsSmOQhFl2ng3P7TMxCRIjoOz74NOvRM/NT3H6sUUuMH2SwMRo+Y4gQG7CI5mHuedTmaeNGXMKZvajw5zMotXtz7z36nryyZyajZlaBxANRlp0VXhmOBdocDZwvmJiT/IhjJmc+Bi4rE2C5W50Qf9gfZRQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTQwm3SCZ5EiebapuMvHZiUGNBwAnRyh+rFX3VXXj5U=;
 b=eeJIoYD2hBMi2b+I+qFXJjyXR7LkKs9wMG4XdWS363IbW3uokzBTH6JyJR+VkwX7FfH3S0EmcidVgy55w6BIbMJYf0MrnV5mc9u2tELMm5nKG6AyS82P0qgyVBcDmh54GKJRTLGhn6oj2c5vcP4C3vQ9PVyvZ7M2s5ZKfKac9NSGLwOqxje5stAwxPkoe27M29UkN3wZX3FbeqDuc6SajtZHz1AgI9oKvbg96Nd9GuRoOBZtZINnSSiDxMjrvrsr7AmDXLngEj0WNqqWbxqJxHhWYbXBtAR+arPyHDJ3YrqCp8JwVoaGaHrorchbdnMRuvVW3mPPQepIo9s6kq0XHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5565.namprd11.prod.outlook.com (2603:10b6:5:39e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 02:45:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 02:45:35 +0000
Message-ID: <1b5ecaa7-97fe-ecd2-6afe-0c260ae8b0be@intel.com>
Date:   Fri, 15 Sep 2023 10:45:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-3-weijiang.yang@intel.com>
 <d05a91f12cbce9827911c23afcfa5fdaf2acb5cf.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <d05a91f12cbce9827911c23afcfa5fdaf2acb5cf.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5565:EE_
X-MS-Office365-Filtering-Correlation-Id: feb0f00c-95d6-4bdc-77cf-08dbb595d63d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fph6l/gnjtH7+z7pLNAeksh6LtArEZg5oJdRq+t82GgRlcmO/lDDxCvFvrEHPnH/OyVEaBpWOohG9UbMABoZyx9qyItONj2PXiyXq/3QBBh7bpY+OK2FdlBI9YzF+XSaX1dox2RQ5fBxYhjoYJAtbYURasnsrRYcp+J7Be4uHdvKxYCwY0YLT5RgUkuS0y28PvUaDCT8Nr3j8To1fXoMyZDLWgfHaRXXktTiZwRHzYrDr6zZBVYbdzWU35tL6MDmme1UUbyDzEA13lC29PC6C+AQXLvE/CZrn1OFkE22SGP4eU9ku/35t1TDjFKAYexki3ug/+8NALwsgDf7zGUZcsKe9wIsm6ylp+xUKgpWu9yCRFKSYZZDAEUeIynuc6dR1+QKjsYE0gYpiCnVx+1hkaWPtZ1D3R7z7Wl4zi20/FbnpvfQ///liQNuYEAZXPd8UG1N/P3vUPXE7KZtf3qHO8l+xLAOGhKY3t3aZAQ9WcGFoDobJ7R6uRoAPXeTPjTn7rgB93c/tQNiCB0aumTmFKSccP0ZzK5D2faoWjMWlFw+g6plZwnikcJr6EGkjbVv8AWq0tg/Ic3EXuPMLVdSW2ha88/I0D8ATZqbxoeTI494XjkNRBlFqR0D6L8TNHG/kSWJiLyqm7ca5JaDYS2Q0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(396003)(39860400002)(136003)(1800799009)(186009)(451199024)(54906003)(110136005)(6666004)(66556008)(66476007)(66946007)(53546011)(6486002)(6506007)(6512007)(316002)(478600001)(31686004)(41300700001)(4326008)(8676002)(8936002)(5660300002)(26005)(36756003)(38100700002)(82960400001)(2906002)(2616005)(86362001)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkYzdUtNRkZYMXZvWkZJUlk3NmZrQVlsNVY4S0VFcHduUTkxNkg1UmN1Szg2?=
 =?utf-8?B?aEd0VjZ2bzczRmk1UVhCREo0bnRjc2k4ZDJraE05UnVSOUVnNmxxREdlUWpi?=
 =?utf-8?B?Sk1NaDdpN29jZ3ZYSmtsWjlyZm85WnRTRVhQb3E0cTJmRmhoT05sZzdmdk8y?=
 =?utf-8?B?ZFJ6Q2s5Zkd4dWtrbWMrZ3BhT3drMjI0bHgwTTl2UC9BTWx2Z2h6Q3JvUzdr?=
 =?utf-8?B?REpTS3JlTkM4ZUdMNlF6V2hsa2dqRGo1UmVoUDV2aU16NzBlRk5tV21qN3cv?=
 =?utf-8?B?ZTVudTJ5NmlqRkYwQnRhQnExWGxIMDFHbjFCY1VleEFYbEdDdnc3SGVCekR2?=
 =?utf-8?B?aVhoNFZ0c1NaeHJVMkxQcDRpbmNCZUVyTzVxd1IwYVN3NTNSU2lVR3dIV3lV?=
 =?utf-8?B?T3JORW9KNWZreEpsMWgyU0d2M2x2WEl3ZVlRWk8xKzM2NmhuZDhTVlBwVzZu?=
 =?utf-8?B?dlRBTmpSaklHdjZuVCt3V2RMUXVyTTF3OUxxdU13dE1oQ3VITm1hSlAyaCtH?=
 =?utf-8?B?Mm9vTnBaRGdwTDJUYnhndm5ZS0dUcnUyY0dabVBFeWp2RjF1Q2Q1U0V3WWJU?=
 =?utf-8?B?c1EvQkx1Tk5pUlR4bjhlMWd3eHltM004ZSt5Yk5IUExvTW0yczFVemZsRDN6?=
 =?utf-8?B?OXZwa2VLckQ0UTBUQ3N3c0NDeHZ6bmYycmhKTWJjUDE4aHl0aU8rcUQ0S04r?=
 =?utf-8?B?dFg2Qks4Uy80Ty9EKzlacm8yNW9keGEzM3lqVnZMemhjTWdlajRyaWVWTHpO?=
 =?utf-8?B?dDF6MDRSWlhvSm9pQXl0SEQwd3BaU21XUW5uM1B5RlJhSzZ3bWZNbDZOUDJF?=
 =?utf-8?B?NDdOQUk3Q2JVM3VHS1p4aUcvQklEQjhVSWw5aHU2cW4weWNxNDMrb1N6WlJn?=
 =?utf-8?B?Y2ZaU2RPNHpzbXBlSnZDS1FVVmNsMHltc0MvbUIxKy9uWSswR3h6cUVRdkZI?=
 =?utf-8?B?citYd2FZM0h6eUxUcU53cHgrdGhJUWxTZWNSNllkTWZnMms0Zzk4dks2d2Jl?=
 =?utf-8?B?WmVWNlFJelptSVJmWGFXREMwdXlpb1J3UGdQNnRxYStwV0ZKMlB1Z09KTjd6?=
 =?utf-8?B?RlpuNEUzdzFPTGgvbW5vNDltSzA3TFZRc3hScGZGSlROZXdIaW0zc0FTVHRl?=
 =?utf-8?B?dWhrVFZDNGdaOXgvUjB4blpsekxIbWc2STNHUTBGNmNkTjAyNitFaTNnVnh3?=
 =?utf-8?B?L2xzWUJwRkcvWkRoRVJuREhmNkxSU2RkTlR3Sy9wZnFuN0RuMi9ZMy94RDhn?=
 =?utf-8?B?ckhDbVhqMjQreXlOakRkcmxtLzVVOElvVXBXVXhXeGlrdmhhNlZSenY5TkZn?=
 =?utf-8?B?RkIvMnF2UHBva2ZHZFBLS3c0SHpVR0YwYzBKVFJQZXVtT1dTZ1lqa0FITlgy?=
 =?utf-8?B?Z2I4UjNheXZrOFBpRmd6eHYyT2pWLzhpVUZkcXpwWnkycFZyUHFKYjFSNFQ0?=
 =?utf-8?B?UWxPZ3QzcXZRUUhKWk96MHFncFRnL0hudFd1TFovdlJvWCthbEFSQUZGRksz?=
 =?utf-8?B?MHFOREJpS0lSYStoTytZZmZ0Z3V0WVVtalRjcHV2SFNBNnBJVjVIVmxBQkMw?=
 =?utf-8?B?NGRicCsvNktoNWk5YVpmU1djVzVidTI5WXVLclFNL05MWWhTTXdMeWxFUS9B?=
 =?utf-8?B?M2cwTUZ6YTMrZ3JPNmhYZmZGOGZRaHBLL1VXUlFGQ0JCYVVyWEM5QmlqREp0?=
 =?utf-8?B?SGRoQitYb1hhV2lLbzlsc29xQ0ZXUnAyLzM5RXNmc0R4Y3hnenFSeXM4Y0RX?=
 =?utf-8?B?aDNTZEo1akxOdzVVeTBDV2dIWks4QXV6SXlwd3ROYXdXNlRnRldUY3ZxejZa?=
 =?utf-8?B?L3BmTHRMNEtrRTdTUzlxMEl5b1dJdGszVzJTWEVzRS9yRGMvZ2pCdytxUnlw?=
 =?utf-8?B?OGVOK0szQlU5dFJPQVVGNUdpWExKVW9LN2didVVLbmcyR1NPakxpMWVwVVJV?=
 =?utf-8?B?Q2ZzRXBqVnZlQXpGSFk5bjZGVGhIRFJMbHNvTER2bytIZElEdzRCTXZOdGUz?=
 =?utf-8?B?WHhNQ1lhendGWVNoZDVmdFhoVm1kODhET1M0WU5qdDlLdDdVZ2lKdWVEWE8v?=
 =?utf-8?B?NDk0RkwxNWVTSEFlOUFTNjY4QU5RRmxIOWdQby8xRXV6L1NJcEpLRHY4c1ZP?=
 =?utf-8?B?ZGhEWmlKTUJrNnRnMldSZDFWMWRJUnRxSlppbGJsei84a3k2YktyVWVuYjF1?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: feb0f00c-95d6-4bdc-77cf-08dbb595d63d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 02:45:35.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZVJruiPXxDmpBhFl8up1K+yf1KfS3vr3n1NyU1f4IJSYgmJu8mQ+hbk0FadW6jrY7+k4V6zyrJAGr3LOsMjIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5565
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 6:45 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>> Fix guest xsave area allocation size from fpu_user_cfg.default_size
>> to
>> fpu_kernel_cfg.default_size so that the xsave area size is consistent
>> with fpstate->size set in __fpstate_reset().
>>
>> With the fix, guest fpstate size is sufficient for KVM supported
>> guest
>> xfeatures.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> There is no fix (Fixes: ...) here, right?

Ooh, I got it lost during rebase, thanks!

> I think this change is needed
> to make sure KVM guests can support supervisor features. But KVM CET
> support (to follow in future patches) will be the first one, right?

Exactly, the existing code takes only user xfeatures into account, and we have more
and more CPU features rely on supervisor xstates.

> The side effect will be that KVM guest FPUs now get guaranteed room for
> PASID as well as CET. I think I remember you mentioned that due to
> alignment requirements, there shouldn't usually be any size change
> though?

Yes, IIUC the precondition is AMX feature is enabled for guest so that the CET supervisor
state actually resides in the gap to next 64byte aligned address, so no actual size expansion.

> It might be nice to add that in the log, if I'm remembering
> correctly.

Sure, thanks!

