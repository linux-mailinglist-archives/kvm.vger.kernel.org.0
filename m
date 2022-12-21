Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A67652BFF
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 05:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiLUEEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 23:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLUEEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 23:04:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A4B15FEB;
        Tue, 20 Dec 2022 20:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671595476; x=1703131476;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4qP4H0hsiLpkO+5AKT1x06DsKup5Ebhiib4B7n4kAsg=;
  b=kSMeXIkN8QkFvsxQnY7kvADiDD4fZEQdgB7Oc1cgBjPWokgibpHISIFx
   7gbnqtllKSyF2Cc0/kDsMAlJk8nZu7cdGpn3xbXaKSxl5E7y8KN8fn2no
   UVvwdQIEt9yuUc0YtrpdNYeKut7lOLVVR2CMqrUGR+Tsy0f1Ydgk8mkWL
   2TgMFwvRhgj1xkyn2JwaeKigZT3SuSmIvnrTQ0cWH/9TOSqyy1If1+kiM
   Z6uEoSxrjtZ9lnNKqTPX7tIiddu/Q4HI/Dk4kbQOFkRyNt6hzZhHQoRLT
   J6R+MU5Hu3Rp/Mo6RyEjzhVWEbNq0CFtQTYSrAvJJGYMBoMTyv4itQxGP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="300125418"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="300125418"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 20:04:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653356540"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="653356540"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 20 Dec 2022 20:04:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:04:16 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:04:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 20:04:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 20:04:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKahIvxP5u084UnI1dYJetnD8hwl4ph+yAwX4EqInvjy3Fg3Vu4CVTBNQTQ9MVOctPSdaacxZl1zSIRCemeQejKbfxIfbrjuoFCI4m/g6MHNM3SsGGU+gGtuaGuSlRqWzeG6bBPeNUUCMZ1inGqWit0sKtIG4//3emXSE9rmNjV0azb+9B3zjwXpEDOeTzu+uvJRr2lvxLCSN+xweNSwqNlu50r4dRBDBX8ypOmlE+dzNBpZuDBy40ZRxBa4EaSzEY9AoLHsE2kAjDmuZF6/DuNfvYkEEeh7xihaY1a1zDbe0l0mJWe8+IXJDcvtl9BmA9y4Oyh35/+8DwkhMeBEnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY7KT1U/Hd76usMwZKCUNd37Dar0DdW6xQTWLKZxvmU=;
 b=c3e6SIl/gyD0+CEUesylCVTwBXWD2eWPTrNXpkqoU4dpCVfb+JXpvj4m2sx0qEkgB+SWxBmYukd+NqsdC2Yn7DZnJHG0+hc6cVG441IqIK18OkIQlz5+KD+TUZjDMQRuPAmXoxye+nVGWfNsm0vHqEztm2sLiPfKrqybnHFrxhzU3tUlYoBvJh63cORvyEqNHzxiVPlOO7gMMnyQYRQ5I7ipBWuHOluczsTvRl/fVPm/Nsf35IRpD/RAfS2qnybksrU/YCd1jYvojN//RDUiqJ9xzpFnK3146c+NFHVKMtm7mQKLqM7TLqGgc6eaq1msbH/MshiTazSxwj5QdTz6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BY1PR11MB8006.namprd11.prod.outlook.com (2603:10b6:a03:52d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 04:04:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 04:04:11 +0000
Message-ID: <d4dec151-553f-e762-7fcc-81ae82b5c211@intel.com>
Date:   Wed, 21 Dec 2022 12:03:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
To:     Zhang Chen <chen.zhang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-7-chen.zhang@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221210160046.2608762-7-chen.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::26)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BY1PR11MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: 340890ba-9339-4324-0f5b-08dae3086a6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFJimagLGfRhA9P15VCDbfJj58VwW/A/DoMieQ4zfIjk/jGuwp3kDQ7Ypv0fn9tlVcihdlZy4CRqUPkH2yo1F9cUEnuuo+sw91OQpIetQph48EVtEaUcblaJX2bFWTfvB/e8ECrveVNmyZ49LMurdx9Ps+kfsi4E+B1OV2QGdRxNCuyF6UbV6e1KI8B+r60ecB0GrRZ51XiPIlCA5C0QvrXrQoIKDn9hXSCC1PMK/Gn9AEeDsi4QqgubZAp6tH9cp+bZJl9+zh2TLLRuJQiKyR/GEW5bNwqeYu/nc03GO2Q03Qoc7hN66VPyAHotqZNRjDR8BrX3Xyvi4f43nDhvm7CrIVHkZGUsgctA0C1qkcWng3bCJ/IjwGnkSbZGSKy/aLAdYTKDw9bhn+imGd7JkA0iZs4BF+KA7L6xaDjmamI/YAfJiDGyJ26kY1BZitNIQayhXv9eIj8UVhlrL3+L9N1tcvUtc5Sjz5wG6BiRGpojcc7yrOQhh1S52GC2b6ZZXqH0S7zRvhs/ZAriSGVqrtmd7091DgvZsmYmwEAM4Kb7ndNRWaZO4b1Fdei2WGLV1BDfUZ3jF1vWRhTGU/2vv+Mo/Vs0LJIm46E4gT9dgVUypmTimUQeC91pufyLcX7yW1DhDwmHKY9nnSvCr5wQyiyXbKS667uzCwQa5nYJFMtETgbaRM+ohNSy/u4ihMBUb0+oY5pi+SpLZ4vMCSsiz5Onj50oSjJvgNLC0MQnX38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(36756003)(6486002)(37006003)(6506007)(53546011)(8676002)(2616005)(66946007)(31696002)(4326008)(86362001)(66556008)(66476007)(38100700002)(6636002)(54906003)(7416002)(478600001)(316002)(82960400001)(31686004)(6666004)(83380400001)(6862004)(5660300002)(8936002)(2906002)(41300700001)(186003)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmVudER5VWViZjBZNzNwSFhsblA0a2FURGo1R0doZnlSRGh5dG95d0lDak9i?=
 =?utf-8?B?VnZnZkhVeFd3K1ZmWkYyWVBiTVNIbFlKWC84MlpBWEdHeEVtdnNmcUhnUEZs?=
 =?utf-8?B?aXdnWlAybG1JbnFKK1dSalJHYUJXQWw3aHRjRVpFWGFSeGM4SW8xUkRqaVNR?=
 =?utf-8?B?MkU4SU5JYXpVV0drUFc0Q3JBUUsxRFUxTW9jUWh6d2VqbVdTYkRkZGJlMXF1?=
 =?utf-8?B?aEU0M2JBdGFlakJPVEtOV1lyRkdva2w5Z1RrU1huMk1hSFFCVjdwU2xQYjho?=
 =?utf-8?B?Z3RPR0wzSjF4SHVwRUJWQkJ0Wm1zVHJCbDQ4UWlKenVOZWMwTjY5di9YZFZn?=
 =?utf-8?B?eUdiUEg3YUhqQ0JPRDhzYVdZRmZFaTFGWW13SmsvKzhvU1lOc1BwaXcyN3pm?=
 =?utf-8?B?eTQ4ZzVUQmtPV01EZlVSTER4YzZseHBEaitnYUx2NEVHMUtvY2FNTHVxSFkr?=
 =?utf-8?B?bFFlVjk3RnllOW96cmtlenRybGxkekpCUG56N01UU1czV29NRGhBNHd6T0dT?=
 =?utf-8?B?RERaeEtEdTRsdWM3alpkR1pFRnNuL1dJeXp5T2tDNlp5Z2xwbzIxRzA3STZZ?=
 =?utf-8?B?aTRLdmZVUFFoNDJqMi9oS1pVOEc4aDM2RC9MNFZaU2pLUUh4UnM0NDlRN3lC?=
 =?utf-8?B?NUtLbCt6bjdicGJaZlk1WUdwQU8vZ1JrUS9YYklDb0UrMUxKWXF6R3JhbnhH?=
 =?utf-8?B?cVFGdjEyRDBTZzFXUmg4d25Ld0pzTXRZVXZqZkJjMHpVMjF4S21Hejg2UUNB?=
 =?utf-8?B?Rnl6NWY0ZVBycmwrSGU3MVozQUMvYkdwazNaa2Qxc0ViUlZCb2tDTVNORWp4?=
 =?utf-8?B?QVZRYVZ4dG5FS0JDLzRlQk9KeFY4czgrOG54dTU3dGhjVFVtRDJleEFGU2RK?=
 =?utf-8?B?Si95dGhBMEF0YVk4RS9pRmxvNGw1U2pMZXZKS0dLdlY5VFZHYTB3STFiTE1B?=
 =?utf-8?B?YmpJc3ZzVUhXbHRqd1JIMkpzMnA2QmhwUEFkZDhFLzd4UVBKaVZPZ3MzMVd2?=
 =?utf-8?B?R1U3RUtjNDBlL1NCUSthUEJKcTM0eUJISDI1dTVQQUwxUlRxRGp2dWNhbFJt?=
 =?utf-8?B?MUlLMllZckpOTkFDbnFwUkpGNFVoSDdCVEFUazBCU3lIUTJBeG4vbnlTOGQ5?=
 =?utf-8?B?NjR4VlJ2cjJjcDhLdmxMYi9Kck93RHJOMUpYaVUrc2lMa2FWaGt3dVdYY3ZQ?=
 =?utf-8?B?bGhmb2prd2N6QURUeGw2RlBuZll4eFNpNUxWR1RrcEFDaTlRQTJkNEFQdG9k?=
 =?utf-8?B?ejg3UjNQYTQ1aldEc2VxejZPTTNibnpmNzF2TTdqRGtHYlpXdE5HdGZQSSt5?=
 =?utf-8?B?QjNaK2tleDFLcjFoZm9VRHVSbitwdHJFSkl3ZktVQzdGZ04vK09GcEdxNEFs?=
 =?utf-8?B?Ky8vZFVGeVpPeE5ZbTFKQ29GV0hOcERqUXZNRk1kcUYxQ0M0SVlabTlCQVNB?=
 =?utf-8?B?cjdnd1ltZUFXWi8wdERyd2ZJUS9UVTdrMmNUeWR6UTBpZ2hxWmgvVllSRnhh?=
 =?utf-8?B?U3lRNDVyajZRK0VZbzVTUUJkTVR5MTBYcFFIZndBZDFYaGQvWWFxYWl6bElZ?=
 =?utf-8?B?bGExUlh5enBiMVZaRm5lSjVnbkhZc3JGdHhHdXU0ZURtcUhyVmlZek5ja05M?=
 =?utf-8?B?VmNlODk2SWxueStRNlBneDV0Q3U3dklQQ0NBUHFhNlFueUkvYXplUExVQmNM?=
 =?utf-8?B?cjQzdjBzcUgybnByL2RNcXkrV2FoeEdSTU5UZ0NQZ3EvNHUxaWVHZ2JiazJF?=
 =?utf-8?B?T3BaWHNyTzJoVjV2aFk1MlVuK1ZVRWFGTG5iYlYwVGtuaXNPbzgzeWVveElz?=
 =?utf-8?B?RGRndmc1Z1J3dkF4L0xIcUtWNy84Ym12Vy8wY2QrSklSb0MrQXN2MEhPM2dZ?=
 =?utf-8?B?ZlVRT0hkMSttZzQ1SlRzNHRxRURYSjhUQWsydlhKSjFSc1Q2K1M5SERXMkpx?=
 =?utf-8?B?eXZYM1RWNUgxNmI0aS9ON1ZTS3RlcUFRY1NvMVUzNy9uL0wwU0pyYU1Yclc5?=
 =?utf-8?B?R0J5SUpJQUtZN20wSUpaSExrZlJGVXNRY3dZU0I2eCtpb3RYeXZPUERDcnBZ?=
 =?utf-8?B?TklNM0htZDhaWUtDZG8vbVBOVWJMcllzMkJUOWNaUmFySWdudlRWT2tKYzQv?=
 =?utf-8?B?MXJxTUpSR3hOWnVRN3BxRUgrcEl5clNIZnA3Ymxxa2s3cTVBa2JGdmloRUQw?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 340890ba-9339-4324-0f5b-08dae3086a6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 04:04:11.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2PmSV7wV91p6LOGUiIw8HRmhEnJ+GB9/0aAf9j59MhcADR+fT5boSeus+DDkh+PNyO5VqBM5TinqaGZo1qbFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/11/2022 12:00 AM, Zhang Chen wrote:
> Add the 63 bit in MSR_IA32_ARCH_CAPABILITIES for enable the virtual MSRs.
> Virtual MSRs can allow guests to notify VMM whether or not
> they are using specific software mitigation, allowing a VMM
> to enable there hardware control only where necessary.
> As Intel spec defination, expose virtual MSR for guest.
> Make guest have ability to check virtual MSR 0x50000000.
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 15 +++++++++++++++
>   arch/x86/kvm/vmx/vmx.h |  1 +
>   arch/x86/kvm/x86.c     | 16 +++++++++++++++-
>   3 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 407061b369b4..6ed6b743be0e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2001,6 +2001,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>   		break;
> +	case MSR_VIRTUAL_ENUMERATION:
> +		if (!msr_info->host_initiated &&
> +		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
> +			return 1;
> +		msr_info->data = vmx->msr_virtual_enumeration;
> +		break;
>   	default:
>   	find_uret_msr:
>   		msr = vmx_find_uret_msr(vmx, msr_info->index);
> @@ -2375,6 +2381,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		ret = kvm_set_msr_common(vcpu, msr_info);
>   		break;
> +	case MSR_VIRTUAL_ENUMERATION:
> +		if (msr_info->host_initiated &&
> +		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
> +			return 1;
> +		if (data & ~VIRT_ENUM_MITIGATION_CTRL_SUPPORT)
> +			return 1;
> +		vmx->msr_virtual_enumeration = data &
> +						VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
> +		break;
>   
>   	default:
>   	find_uret_msr:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c5a41ae14237..fc873cf45f70 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -298,6 +298,7 @@ struct vcpu_vmx {
>   	 * IA32_SPEC_CTRL_MSR.
>   	 */
>   	u64		      spec_ctrl_mask;
> +	u64		      msr_virtual_enumeration;
>   	u32		      msr_ia32_umwait_control;
>   
>   	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2835bd796639..6be0a3f1281f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1532,6 +1532,8 @@ static const u32 emulated_msrs_all[] = {
>   	MSR_IA32_VMX_EPT_VPID_CAP,
>   	MSR_IA32_VMX_VMFUNC,
>   
> +	MSR_VIRTUAL_ENUMERATION,
> +
>   	MSR_K7_HWCR,
>   	MSR_KVM_POLL_CONTROL,
>   };
> @@ -1567,6 +1569,7 @@ static const u32 msr_based_features_all[] = {
>   	MSR_IA32_UCODE_REV,
>   	MSR_IA32_ARCH_CAPABILITIES,
>   	MSR_IA32_PERF_CAPABILITIES,
> +	MSR_VIRTUAL_ENUMERATION,
>   };
>   
>   static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
> @@ -1588,7 +1591,8 @@ static unsigned int num_msr_based_features;
>   	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
>   	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
>   	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
> -	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
> +	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
> +	 ARCH_CAP_VIRTUAL_ENUM)
>   
>   static u64 kvm_get_arch_capabilities(void)
>   {
> @@ -1607,6 +1611,13 @@ static u64 kvm_get_arch_capabilities(void)
>   	 */
>   	data |= ARCH_CAP_PSCHANGE_MC_NO;
>   
> +	/*
> +	 * Virtual MSRs can allow guests to notify VMM whether or not
> +	 * they are using specific software mitigation, allowing a VMM
> +	 * to enable there hardware control only where necessary.
> +	 */
> +	data |= ARCH_CAP_VIRTUAL_ENUM;


IMO, this is:  data &= ARCH_CAP_VIRTUAL_ENUM; because it requires 
platform support.


> +
>   	/*
>   	 * If we're doing cache flushes (either "always" or "cond")
>   	 * we will do one whenever the guest does a vmlaunch/vmresume.
> @@ -1657,6 +1668,9 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>   	case MSR_IA32_UCODE_REV:
>   		rdmsrl_safe(msr->index, &msr->data);
>   		break;
> +	case MSR_VIRTUAL_ENUMERATION:
> +		msr->data = VIRT_ENUM_MITIGATION_CTRL_SUPPORT;


Need to check bit 63 of host MSR_ARCH_CAPABILITIES before expose the 
feature.


> +		break;
>   	default:
>   		return static_call(kvm_x86_get_msr_feature)(msr);
>   	}
