Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771725401FB
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343779AbiFGPBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343623AbiFGPBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:01:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B57F5051;
        Tue,  7 Jun 2022 08:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654614097; x=1686150097;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5urjf3yyCNVdX4AvCUgr4B4VOToBmA0tLtZ3YDEdC20=;
  b=TDXNXhtE88bjQ+R/r0g1YCjIsg8pSQjZGLcGIxeBGbKtzMmlpoZs2W03
   Omayd3IcZVOupeh79ilmtd/5VbJyUrANHZkES9pSM7KD4N4R4TuJDF3Br
   G0Sl4JJak/eFamLFIT/J94i6VPcFcxNEOGVpbfxfbCr93BJSd7o3pGvcZ
   jQ0iYyCRFie3cXVJnE8q4BQdmeYfQkDGC13YDLzpuaIwMfUnAE9+UQ1Uw
   Z1m44yGKfkbDTb8tWM/rTYdquWxO63xqk+fmV0IVr1mzH7OrKBHqZTVAW
   jrBsV+OsIbSxyssxa2jWgJh+BgPoBdWcZPCfzee8eS034rHS2S0RJ/XeE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="277235568"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="277235568"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 08:01:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="648063534"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jun 2022 08:01:07 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 08:01:07 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 08:01:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 7 Jun 2022 08:01:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 7 Jun 2022 08:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0lUjQja+6Vb3B1PBKjAFtK5OJO4UyphNpgyLrpU9c2PCbgv/flGg72GXlpeulUCOs5uqXRKiejGiW2LYVCZouPTGcqHf0BFUww3IQ1hS12d3Zww1CyxgeY0O+uyu/kRGZ2PRjcXEreXvaaKmxp0j8vZTZljPXGXIf/nwpnqGfzyHUwXb2pn1Xempq3FpO8Fn2yGwWzLVfyKd5l1Y7fiu/D/R2kQhuTKeXyUvmR8hQFkNXMx+2cQUSznOab3kfwusuRyK5i01+dpF+JReWNp6Y2xsn5PK5EvM2idOfcM0BQIGG4m1toSeRxuyMk+eA7gox+NenpGrh+vp58w+aT1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ETgPB1QxR16Le9hrHh+BvhfjoqPpoOqg7nl3fcLIaw=;
 b=BiYNLHhAh5A+BjZBIfVaop5T/uCytCXr5xOcCrjkgp+0NnEHIvbqnIQXZW4xYqy4UiYI8P6idfnMtWzw4qoGUUjbQbvcjtF7m3ljIUyKM3+9t8/uhrHIfykAsrL9NUgY9YQtn1Xe6vFgRwp9oY61+bTP0dCEQmCuV1AXy+hILCXCdJMknIaOzerFtLAi4qvRkLTxozJIMw7DRXDG7hAOIaLffxK8Yjmyv5pGlXqmDj2AKRrH7FoIL2p2JKKRB6lj6r+xBGz5rRt6R63XKzdBjPLEMRfg1lexeLBG58cx6aAfD6li7oCoR0AR8cBkLwP7vUO5zIFtoUa7G4O0hK06/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by BN6PR11MB1266.namprd11.prod.outlook.com (2603:10b6:404:49::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 15:01:04 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b%6]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 15:01:04 +0000
Message-ID: <1abaea0d-7e21-b596-eb5d-75217133a504@intel.com>
Date:   Tue, 7 Jun 2022 23:00:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v2] KVM: x86/mmu: Check every prev_roots in
 __kvm_mmu_free_obsolete_roots()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220607005905.2933378-1-shaoqin.huang@intel.com>
 <Yp4x0twziuEr3KRm@google.com>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <Yp4x0twziuEr3KRm@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To MN2PR11MB3870.namprd11.prod.outlook.com
 (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25d88216-eda9-40fa-ac41-08da48968af6
X-MS-TrafficTypeDiagnostic: BN6PR11MB1266:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB12665D9781C0E294A1BC34B4F7A59@BN6PR11MB1266.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+jRkFtapXIcmZi8A6I/KTSpPkEVjo0q6fTecPQsAkLHAQlU3gt7hfZjMaJ3X+XLdxAXX31j4EX6yOx14cwjpZvIAp6oa1kVrwvY2SU3ZA9RTi7oqZKpvmEgbTRjsjroR82i3e64pYDUhj3REmvm4BUSIkJxmqasbpZnEW0CKHjPEjpHo5D/JEGbaD3ZeKJT4obWLTRDEImmKtZXEE5euguXvsN+5VY509u0Tc/cPOYkavfj/DKEGjzVeWH/mon7WOj54Lk8BzcWm/XXC+m0UDaYHgmvi77lbJthvC317+9tiWHLFRiuVMetzgSaoRiWJT8zpAQmsAO7MiBkyP7Avqe0p3U0f1FnHA1XFNxLNqx75hDUgmbEbo/VEFkUurrs6QlTMqgKiz58PG+MNC/z0AQ+s4vzN1mpO8nQnqzAZOVx3e2giuzoixSnKxLICuKP0wYrlUnMv+p7xfmE8crvAvGFWAG3CbUAKmCC7LhmnADgmniCpPud9DSF8sCnw3G2eRjPKNU3DZJOPke5ypIEbpt9aTnK9AlThJ2wC49zMF9YBtAC4QG9Eri29GNIW6RQgb3/WwULFNtD5LwC4K8nJN3O1RYLrlWWe82XV/gmPPrbGf4+KPPQA9b8xJ0fvhsX2XJqQAEwbnz1BBo0j7qvC+ECYZfnN4LyvlP4zeu2wBsCgNq+8Sq47XClR6+ah5hDGCXzoW2yxU+ncV6IK8aDiTy0SKpjkv8s+sSLYgPmKnZeBqItHaFGcsWAC3kfyJ6z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(54906003)(66946007)(8676002)(4326008)(66556008)(31696002)(66476007)(2906002)(86362001)(6916009)(6486002)(53546011)(4744005)(36756003)(7416002)(8936002)(6506007)(6512007)(26005)(5660300002)(82960400001)(31686004)(2616005)(186003)(38100700002)(508600001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEVVTG5vSUxyRW5SU1RVWWpDUmNwUjZFOXdoSGZXMitDeEE4emZvT1RFYlAz?=
 =?utf-8?B?bFBuS0l6SHZkZ2FpU2lpSFJXNVlPUFJrTGx5eTZBenJaeFVEMDg1L0gvZVFn?=
 =?utf-8?B?b01VOTRUZEkyMCttNVREeTUwSU8yeFpHV01oTVdFMUloS3lvZ3RZMEFuOVNO?=
 =?utf-8?B?SUg0dWpwZlJVRzVGRjI4b0hWSUh2SjZMUzdjczJqQzJTUlNyVFVjaWFPMndt?=
 =?utf-8?B?V1BhNGlCQ2IyVzhxR2M3aHhpVGxjcjFRbXpjUElKNFZEUEtJMWg5N0tqRUxk?=
 =?utf-8?B?ZWhEbjdydkwxQVYxQ1VteGFQRisvNldoWEpUUzhGTDU4M0pxbXBJa3BmSGZn?=
 =?utf-8?B?UUZwbERXMi9aYkQrR0VGazVrUDRTT3pCRDQvL2U3S09WWnJCanJJSzVnMzI3?=
 =?utf-8?B?WnhPK3U2eVNZa3lQWFBwM0lqUGRRQmVIa0dpOUowekpBTytSNHB3YWo3QllD?=
 =?utf-8?B?RUd1cWxORURKM0NhSEViaHJCNEkyMUMxMEdoZXNTS2cvNU9yYVZaZmgzdU9w?=
 =?utf-8?B?a0RhRUJGRGVScjg0N0pDMm54Rlh6QjY1c3U4cWF5bnBaSE1jOUFpcjhQS1BI?=
 =?utf-8?B?T0phVGkzenYrK1IwMlBJTE13bHlNcUFlK2RWWTQ4WGdnMVB5YXRzYXRuR2RW?=
 =?utf-8?B?TllSZnlnSFhYSGZ0a2hab00vank0NE5NUU9TOE84TFhid2lzeDN0NkkvWkRM?=
 =?utf-8?B?NTNZM0E0L3hSMXk5VnhDaU9NbXRxNUFRaWpkM2VtVWhDa094dkx5TWVuRFRV?=
 =?utf-8?B?TENCREZ1YkNHWkxnNnVoTVMweHNLV1RWdmE4UnpoU2tUZlA0VVlJK3Y4ZXBM?=
 =?utf-8?B?Sjd0LzhCbDdldkxEaXZaSk1rT3lEai9ZYUVyNk5VUFhTWFFJLzBQTENJWE1z?=
 =?utf-8?B?dHZQRjZaNGRFQ0NlY0Q0VWJUczBNcVVBU1BNbUJKMm5udHNkUUorZGVmUlA0?=
 =?utf-8?B?bzBTR3VON2QxTnlvaVlYNUNVdSsrOS92SjhoM0J0QnZuYWNaVXZ4b3RCbTd5?=
 =?utf-8?B?a2VxY2JTK0p0b3JSWEtxQ0hHQzY0OSt5WFpWUWtZVGRyRnc2TEorT2w5TjVG?=
 =?utf-8?B?K29UTjlJUVFqa0Z5enhpb2dpOU96QXNJdS9PaW8vZkhQSk5TTWtYbXFlNmxa?=
 =?utf-8?B?VHRLQm1RSnN2Q0dSWjltZTgreXQxQ2xtVTlRNUpIajVrVEVSSmxZSWZDZjFM?=
 =?utf-8?B?Rzk1YXlJbS82MVdHMHpaMTFqSzdyN2RXdVJ4RnpZZ2lYQWZnZ0w1ZGU3azVx?=
 =?utf-8?B?MWZnejR3Q2NlMzNuNXNuYXI3OXVMdVpuV0VmR0JDRHR2d3Q2YlJZWllSVmY1?=
 =?utf-8?B?Y25Wb2lML3pjOFR0WTRKRk9LV2wwU21LSVJpTGdxcDc0aW4wbDZ2REpCZVp3?=
 =?utf-8?B?UTBaczhjRHpLUTlnTDVTdFZDMmFoVzI0eXd5Q3lpUDdKMElXMGd2N3Rjenps?=
 =?utf-8?B?L3ZDWnpMTTh4S2hzajI3TFlCbk13YXp5dXFabW5RQ0M1Z3hsVGdISVZ4YmxO?=
 =?utf-8?B?ODh5NHdJMmZBUUNNcWdDTkI2aUludEFIZ2RkbnlPS0kyVzFnNUJSWTREYmUz?=
 =?utf-8?B?T3ZmVjlGR0U4VXVpOGFMT1hWekpBUHJMM0xEYUxhK25pVUZFcGdTejRoR1Nh?=
 =?utf-8?B?REszb05lUWdpRTZnTjBiTDN4ZHdhMzhDZDMrMFliNm0rSlJUamtRc0xya0xz?=
 =?utf-8?B?Y0hsUENMcDdWYUhENS9WczBlOEkvM0RWZkd2RDVGdVZDNC9mL2hkdkFUV0U2?=
 =?utf-8?B?MWc3RWZuZVY4cWxyVmc3MWpuOWxMdUZXQ2pZckF6V2J0amdVcjk4KytNNXNh?=
 =?utf-8?B?UW1Da3QvSW8zVis5VnlmMUpkdTBydlZGNWtoUGZoWnlVdUlqQVdIZVF2dk9K?=
 =?utf-8?B?Mk1Uc1pBL2RmZ09qU2ZTWGRjek11VWkzajhCMjhjeGQxN09IaTJoTC9udW9k?=
 =?utf-8?B?UFJNMHFxakhzQXdrSmdSNFAyTSsyWUFmY2Vady8yN0RJeTY2b3ppZm8rRkph?=
 =?utf-8?B?b1lDdGk0R0RteGVBaVJHeTNrT0swM2JWUmdwZDVuY2FNUW1JaUxFRXBETXAr?=
 =?utf-8?B?dzdoSENpZk5SbnA1aGVGcW5WRWN3cW5mVWZPMGJkTk9nWVMxamhEWDQweSth?=
 =?utf-8?B?RGZ0RnZmWXoxMStUak1OTlpPeUtuSFFrSFhjMmRJMjZJV21DMW55TFNYUmVK?=
 =?utf-8?B?Y2xhYUZoVDFGd2lCZVNMc3p5Vks1OUlmSHlKcktWSjBPM1c3Zkx2eGw2b2Jw?=
 =?utf-8?B?U1hxRlFVdTlvZE0wdWoxUnhVMEhRK2VUaG4xTjMzRDhLVk0xcEkyVndNc3o5?=
 =?utf-8?B?aFQ4cDBhTkdwOGdzN1oxalA5OG9OSlJiaElURHhzR2xyd3BkTTZGa2JCNUZt?=
 =?utf-8?Q?wV65o2+Ubzb1vQtA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d88216-eda9-40fa-ac41-08da48968af6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 15:01:04.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOBUm3G608LzuNV7K38IadOmZ9OlgpogqxWCd/CMjiu09BqObKJWKKGCU6MQPkr2MfB+ts9j8e3HDPWaq8PE3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1266
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Sean!

On 6/7/2022 12:56 AM, Sean Christopherson wrote:
> On Mon, Jun 06, 2022, shaoqin.huang@intel.com wrote:
>> From: Shaoqin Huang <shaoqin.huang@intel.com>
>>
>> When freeing obsolete previous roots, check prev_roots as intended, not
>> the current root.
>>
>> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
>> Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
> 
> Because KVM patches aren't guaranteed to be backported without it (though it's
> "only" v5.18 that's affected), this needs:
> 
>    Cc: stable@vger.kernel.org
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
