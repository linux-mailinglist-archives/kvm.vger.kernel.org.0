Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2985D6589D4
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 08:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiL2HDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 02:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiL2HDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 02:03:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0720612621;
        Wed, 28 Dec 2022 23:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672297400; x=1703833400;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DPxYPtMSHpTkJf4d9/gTYqkQCzs1VPmz6kMBQpCllWg=;
  b=PLFZ+GvOb32uwN+tFqp1A1zHMi+RIq08+rWthOJ7bBpDA3I2MDiq2K26
   upWnEb0tE8bVNGybQ143TvnB9c/R2uzHZEWjBUVq7RnPVSVsFbcLH6Wrj
   Fv+hcPZtSMlRzD7Fee5O4R30jWadzZp2WgtBSPxTUM9+KbODL9XcnXdoh
   ZrwjVuH7sxNPjK83VMZZyAOE/oLCWoUw5lO3rRzGHJ61DwATQctH0qOwe
   vYwJuHEtKDx5FnzQVKGseuqkpBJLXtX5z2g4UoPLFvTg0uCDb89txoAVe
   HTrJHIeQh0pbxp0dCCIkQ/6znYcAdzucso+hedfQwLK2Cs68kyzmJlzds
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="308752967"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="308752967"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 23:03:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="721996867"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="721996867"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 28 Dec 2022 23:03:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 23:03:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 23:03:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 28 Dec 2022 23:03:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 28 Dec 2022 23:03:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6+4z1WkffgoS56BgAI9K1WCvN6xeBptJx0lwUjZ15Pv7TqdYuEHXRAUzPYE8YO6KHIb6GtJFp4Dniej3l5WnQvLBApMqnxzwq3akJJofeOvztVHWC9Ga+04vX2gEIZwr/6yiFJRuslEFlZEpPS7PaDEHia/rqWbtuMcQgqEHC9LveaIVymvtLIzgDkR922s4oDOBHlZeAia4dusYNBWVkBQlpfIP/1GoNfzQNpTJm+zNIgebwYKAZpPcqUl8B/RQA1ZQTGJBUD9Avnmb4epSWkW3YW2qPr1bitSvw5Sjb4K7/ZxrlreWu2Jj/Q4fffkfamrGgqhculEL3vMKNKtTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDBkXBwd4g6Xc2N/OvxUjpn5Qax+S5VMr3rhDasIqhY=;
 b=gejP/5KhwqTUrphKd1CzKwlwEqyRftpfW54NROALj0N/4+CHl17M1FrQTPljNUVVR6qSvN4/fTZT8hquxAy6nJF6M6A2wKtO1x9hIIuAtxOjhRbD85fVL2b1hwk0UBLRW9B+Jw1d6Txx3gYETPqYRZYEJEukCzbTpMgT52GCEJDcek+95UXB8JSanevNhd6QXkdEdt4R+KmGDguCY0hj4UXDILLJRK1y80GaKtI+TqxgfODkFXBbSy6oZ2Dx77ddKXiR99Dm+h+alcBTQKxaOZGdLZ7hBZmXW9FI8l9/jRiQ1N3I4+qA3HASkK8NIX6Ssc+zhW9wrnyfz9IZx99Y3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB6355.namprd11.prod.outlook.com (2603:10b6:510:1fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 07:03:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 07:03:07 +0000
Message-ID: <cbbdb23f-4261-4f48-4143-c5fb6c78da06@intel.com>
Date:   Thu, 29 Dec 2022 15:02:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
To:     "Zhang, Chen" <chen.zhang@intel.com>
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
 <d4dec151-553f-e762-7fcc-81ae82b5c211@intel.com>
 <MWHPR11MB0031EEA971FDA614271C22449BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <MWHPR11MB0031EEA971FDA614271C22449BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0160.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: b0cce66c-c025-44ec-ee47-08dae96abd22
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJqxU1k/AMvtDe54NGpZNcssUwmE5SRlBf2cknCvLHRo/lgKtBsWyZi3s+onyVDj2IrKkIGxXpojfN4HX0plQgkt1ZSBjwlm5CHHAaxIwqy1HSN/BOVYxqhdn1l2JWlp6Y4l2x8PgnqXgS1oeC5pXYzYoaSkJ12dPLIu/1aswUqeM0VnBUxRE+feBMJnLfguXysjaZ8iw/egsclq5dWgNbxzpHtNkOahBU5v4kDpT6vsp4TkVsvzDq3lAhyq/1+AKO2rs86hVv149QB4FASNaYLYIcXBz4PI0EyvSmfVRE6PqqsbVDU15O0TqG3GT4yne/ymwn1Lr5rped/RwRFwWsK90BLl8i2QXOsQIB891EhVFswUFXXfbZ/QuopRbcOSDUANleWIBbUce1XTqAC9uV3Hh7Lh6G5+cfix8ceawUgnyIHScJLXKIg/edB3PlGndNxSiScZhNYarZPOOpBp0YdO4DrGTYOuDkkuQSH0I1YFyI5X6p7mfMjXEgw302d4CnRrg1PZOypPY76oTbRfTxLeQm29alI+8DJF5ZD6/lcexkouQwK4h78m0Wz97PpnsHNx0RAW25RS9fYQVRqPsumLoVZVqM0a5qNiGEJOfxq0nu3RJVA5Ddi5nogRE0NBUd7Dl9tS7wiELAsdOyZ0wTPm5Vyxb1deGvYbiQpGsFUlmb6HvzYlTPC1rPLnd2njAANn6GaBQk/EQwhm6pI4bjTg0bcPYHkR1/QCOmrU03LCWI+LKL/SI9aaR/BLyopS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(66946007)(6512007)(5660300002)(66556008)(4326008)(66476007)(8676002)(31686004)(41300700001)(8936002)(6862004)(26005)(7416002)(6636002)(186003)(36756003)(2906002)(54906003)(2616005)(478600001)(6486002)(966005)(37006003)(316002)(86362001)(6666004)(53546011)(31696002)(6506007)(38100700002)(82960400001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWFFdTR2ZEd5SW12VUNQK2M2Uzl5MEFHc2RPUEx3V1ZlNWs0SEIvVmNTL3hP?=
 =?utf-8?B?TFJGbmhrWHg0TFdlb1g1NFliSEZDalIvVW9WMEtrcGg3aVpmYW0vMkhWckNX?=
 =?utf-8?B?eStWUFVqVWQvSUxQMzE3L1dDSFBQdUprMEFqcDVVbktZWHR6OHAwN3QvK09Y?=
 =?utf-8?B?dWkwd01mZUs1V3lKekh1R2RCUnVjU3NxR0Uzd1IxYnZCZ25WTjlUNVNKRHl5?=
 =?utf-8?B?KzhOcDUrSjN0RERQV2wyVTZyRWxpZ3d6azJ2MmtucFFPWkNkQ0ZrTTRHZjgw?=
 =?utf-8?B?S2pOeXFuU1hNYVBsKzB1Q2N0VVUrLzhPdm5LOW1KejQ2ZlNUTWZDOCtRWWRp?=
 =?utf-8?B?NHloRWVvZnRQQStScVErT2dMVW1ZWjFUakwyL0MxOENQdEllOE5ZRzJKaWE1?=
 =?utf-8?B?R2FpRDRPMGc5enA3ejh4S0NiRWlra2pZa0F5MHJwZXIwVjBzOVU0UzVKYTZz?=
 =?utf-8?B?a0U0cXBCbW1lbEg3ZW1qQmFRQzlyZXBYcnFBZXk4eFRWWjljem1SYlQ0RlZY?=
 =?utf-8?B?R2lMMFNvbTlYRVJ0UWgzd0l3Mm1lVVNNcmtlUUdCdS90SXBoakpEQXpMdjli?=
 =?utf-8?B?VjgzNk4yTEFCZHlBMUxjVDltaFlHcng0aWdLSUhtK29Sbk9UZ2FKdm9SeWhy?=
 =?utf-8?B?UllmNVJGenU1NjJvZ1JIeVVwODEvQXNHMjVNR3h5QmNXMGNRSEp0VkZRRUNC?=
 =?utf-8?B?ekQwMklCdHdXeTlNSW5ON3h0elBrd2l4UzV0VzZtUm0wK0x3T0ZxcVlla0dV?=
 =?utf-8?B?dThpVWdvZlV3NUxlNjd3ZXpPUlM0alMzbjNsbzloenY0Q0hxU21BQmMzUVNS?=
 =?utf-8?B?THc1YnphbWl0ejVvMmc1R3dyL1BOQW9vcElyS0taTk5wNE5GeDdPSlRyQlgz?=
 =?utf-8?B?ekMybmcvK0N5T20rNDRidlVmbEkxN3UxM2VndWlxS3haTVFtMGMxQW40Nys2?=
 =?utf-8?B?dElCbk9nSkh0SUorUHY1UW9DaCsvVFkxeFVaQldaMC9xUjI2U244TTRobXYw?=
 =?utf-8?B?VWt6c2ZBYzNWNHdsZ0RjeE0xRHdZZ0ZhQ1ZBb1lUYllkWS83TjhhZlAzK01E?=
 =?utf-8?B?UVJVKzA0WVNjY21MRTJGcTlPZFlKRnZhalNTRnRUelZKSzRxSmk2RWcvNHpV?=
 =?utf-8?B?SHM5b3dkclRoM1d3WmFCdjJ0NFErWnZBQ2Viai9SYUVzampVWnJrb1diVFBn?=
 =?utf-8?B?V0tMcTBRNDJZWDRCMFVncVhKRkl2SS9xYnJ6Yk9ObDhZbFZnWXMvVC9CVzRw?=
 =?utf-8?B?T0U2aTJJZDZEcFN5Tm5VdjlaRkZ4aDlyd1hkR2FqVGR6eUFwVXhMNlI5ZTZI?=
 =?utf-8?B?MUZDdWN5UUtaS2hJaXNweDVmMXgvNmp5WERlS0VBeVAzUCs1VFE3dEFCeUtl?=
 =?utf-8?B?b3l3ZzhZZzZONDI1SUJBVUFyOWxWREY4S1FOeW1mdUJNRlpKZFpjUG94OVB2?=
 =?utf-8?B?dXpHZHBUSlBvUHlTdzAwQ3Y0Y2sxc0RMcGx1RDBGU0R6Wnh5MTlDQnV5Mm9k?=
 =?utf-8?B?KzR5ZWtYcEsxSWVOcXpraDFBTm5mZjNOQ29yOGZsc05rUUI0bll5VFMvYWg2?=
 =?utf-8?B?WGQyTFpYL2hEL1hIb2ZUMVRHTEhRaXNTUUpTaGloN0pNa2w1RXE3bjFmVGtq?=
 =?utf-8?B?a2dpRklzdVFrNWU4b2V6Vkx3Wmh6RUdHNGhOcVJ6b1REbnc3ZmRvYW82dkE0?=
 =?utf-8?B?RUtDNFovRWo4Skh1aDJxa1FMTXFuZUc1TVp2THRxblJldVVsWjhlM2VPeHNq?=
 =?utf-8?B?VklseDlRSDY4bVFhT0JtV1Zpb2piUXRwSGFZMjBiMXlDaTRmWmtxSUxrSFl4?=
 =?utf-8?B?dkY1QXByOVgyRHZHdFhJcWtkenNxM3lIQkdBL1RoTVkyUW5nckJsVWM2U05B?=
 =?utf-8?B?L1A3U1RmZzE3STdPWHN4WTdpWmlyUGZFaTA5RGpsMmJRMXMxM1JVWDE4ZUpO?=
 =?utf-8?B?Rmp5eWtnYkczcE4yVEtRdmJUR1F3MGtTOUxvRmtPdGhwby9QUURsN2lueCtT?=
 =?utf-8?B?eWlDaE01VWVXMTkxeFZsL3U0QW9zZ2tNdWNuZVllMDdUMDRoVXRVdDlEM2FF?=
 =?utf-8?B?Tko4a09lZGt5YkFXVFJHRjdVRkhXU0ovQnpHNldvWEVVMFNoMlVXVjVWdHRQ?=
 =?utf-8?B?Y00rcUc1T2RNT0FqWFpXb05td3dTQjNDV3JuOVRxOHVEakdIbHZSMkNibjRC?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0cce66c-c025-44ec-ee47-08dae96abd22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 07:03:07.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X41wTZg0SEQ62HVUipXr3c+fDmI+4PquiKgVEocmNzxt2XnSYCEIlln2ibjFXtbkYCYrSTmfkgmyM1R9gH6EHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6355
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/29/2022 10:58 AM, Zhang, Chen wrote:

[...]

>> \
>>> +	 ARCH_CAP_VIRTUAL_ENUM)
>>>
>>>    static u64 kvm_get_arch_capabilities(void)
>>>    {
>>> @@ -1607,6 +1611,13 @@ static u64 kvm_get_arch_capabilities(void)
>>>    	 */
>>>    	data |= ARCH_CAP_PSCHANGE_MC_NO;
>>>
>>> +	/*
>>> +	 * Virtual MSRs can allow guests to notify VMM whether or not
>>> +	 * they are using specific software mitigation, allowing a VMM
>>> +	 * to enable there hardware control only where necessary.
>>> +	 */
>>> +	data |= ARCH_CAP_VIRTUAL_ENUM;
>>
>> IMO, this is:  data &= ARCH_CAP_VIRTUAL_ENUM; because it requires
>> platform support.
> Intel defined the virtual MSRs for software mitigations for all platforms.
> KVM should be unconditionally opened it for the software mitigation in migration pools.
> For example migration from the old platform to the new platform.
> Please check the Software Mitigations in Migration Pools section in documents:
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

If this series running on old platforms, how VMM can set specific vmcs 
fields,

e.g., “virtualize IA32_SPEC_CTRL” VM-execution control, to mitigate 
guest issues?


>
>>
>>> +
>>>    	/*
>>>    	 * If we're doing cache flushes (either "always" or "cond")
>>>    	 * we will do one whenever the guest does a vmlaunch/vmresume.
>>> @@ -1657,6 +1668,9 @@ static int kvm_get_msr_feature(struct
>> kvm_msr_entry *msr)
>>>    	case MSR_IA32_UCODE_REV:
>>>    		rdmsrl_safe(msr->index, &msr->data);
>>>    		break;
>>> +	case MSR_VIRTUAL_ENUMERATION:
>>> +		msr->data = VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
>>
>> Need to check bit 63 of host MSR_ARCH_CAPABILITIES before expose the
>> feature.
> Refer to the above comments.
>
> Thanks
> Chen
>
>>
>>> +		break;
>>>    	default:
>>>    		return static_call(kvm_x86_get_msr_feature)(msr);
>>>    	}
