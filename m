Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C47741D1
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbjHHR2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbjHHR2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:28:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB5221255;
        Tue,  8 Aug 2023 09:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691511137; x=1723047137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4V8JK2lhzUmIcPA50I6oc+EkA+rsFq0IYmdZqMIjdo4=;
  b=PMJ3643dO0i5R0G1rcoEUr56DAlblE8rRd7w5qSRCX8OkFWJ0HtL16JT
   w4Tv3NMWnBXZILwEVhA8+TsETTdL/j1YrJjhgc4BhM0+upDMVB3hPcmLZ
   ylP6OkvKjCbsy9wVXS7tGAnVAQD7DR178HkYQCgWLCxa0im2kxVwto2oQ
   6GeisUL1eJmg1Fbg3UyhRBSowYOpR061lhUWYXUqqFeCSCHt2old8j7Yz
   U7cfD2kf4msShl+GVGuGJjdqbt3mGQIyX+F6ejRC/YAmPPQ2RjnLI8MQW
   j+sSOX+SLwaG762O78tEBhcLhDpi78c/ISV3kW/nrLBnZnzUla5736djf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="355770816"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="355770816"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 07:21:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="845496136"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="845496136"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 08 Aug 2023 07:21:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 07:21:01 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 07:21:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 07:21:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 07:20:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZHMyzm2pUHsr2GRuo1EyjCWL7HE0mW83Fm8ccegYdfevzXklrc06uz9oX38rTUUK0iSB83YSlsjUMJjKTvurBRqxf5y8fgzdW3DDZoGy0DbwE/e33dfshT+QYHq28uYqYjbd3hFMLKhikOPyHkRC8CFIBbUqYyrHYpiTV9tMR94F1kpsQxs9uaESwok/bZ2nHulIooCtr88yEfhEiKI3KEazEYDM1Xg/f885Y+W4pjCZC6kXmPVsuKmwYtWoH/6yVliwBaBAsqhqasgDfW+mUoTciBmCnaZiC+S9pS5NBEyQKV0Z6fT7cXHPAekuo9DEq7NgXCCmCNtRcnHHgStUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsleld6kzxPEWcZrdEWPtDK8FvA1Vnaabqcki5n0LCg=;
 b=mM6B9rqH2ktVuOkEb+Id7t+u9/EKJnAPARAwiq8Tl6PC+s1eY1ELE+arDRDzv35hWZyTYkXpATh2B64kIl2P/1wo6aRLW5kSdtcM1ai609jX9+6YFM5A+Z2iNk8z2IEXD6IJTx0i1anDcY5GU49tPx08h0EFdXk71hIy7COwX4MrskShRopkYXWPeJddZnAEoP8/BQpLWW/+yRVzb+ouPKkRTr6p7TPWhXQf+rs02rDy2eZnMI6eBRdmfT4JtYoM+PWnFJms7bgtM5/DUJoVqvZjkh/015G3N4kieHv5+U0O1Q59HPXfwj3MfOz9I34pcpyFoK25IO+GwJWBZGs3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7312.namprd11.prod.outlook.com (2603:10b6:8:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 14:20:49 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 14:20:48 +0000
Message-ID: <d888f479-370a-00d3-b929-780e0600dee5@intel.com>
Date:   Tue, 8 Aug 2023 22:20:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM0hG7Pn/fkGruWu@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM0hG7Pn/fkGruWu@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa571b5-b9e1-480b-609c-08db981aa993
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAjQPaZBMTa1HnuvtH9QrgnxbH3CAZGXWpfnunDsBbMd5y97EBfzg3xAbWBfYWLSpXAXMLuZhqksLdldBLJAiNZybVhebOxd9FnX/2Dbokx2uaBny3ez/kU3fvoh0v7kXJvlBPdUNAfsNFkCSejFG5H8mWDzC64exrOS/vEs3ZNEP1ZmDj2qhgNbW+7UX7Yo8xQoZYfvd1wHCOhmWHif7s0C9CTMfi1lP2S4QwBM4FHPnSaq8xtXagY3ROf1rSogde8E8t6aFjb+BSkbBwZXjAcFHWv3BqgpQC3DOng8ehXlp8RYbfqnT7OOaldGYWtZmTbYTXe9O2wMoKevvuB5u1gr3vMQWfkskY3Nq/olIBtdcA7/p7JSocYI1Xg/Gbwd8xl9J6N3/R44/nbHWDF0zop58aLSnBvxixVeX4upeLQmNGL31if9xl2TnOkWJpiYkTXZ+PH61dbYpvnnLiS+PHB4vGSGIYoHBO27NgDUXmDWtUETdbzdFSd/oO/K+hDBTL8bs2XPaYqb/hmsf+ZBlGWU+/KniMsE8zfj14ifjEzwXEc73yG6oZgxENcAeGBgDauZWSD2vicpT9zei//S8OaJA4FONct/eGqXwxrWKEqJIRvHCIYHK9bxIE2rhV0XPiHbIwVCKxS6BpGl1YLX2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(136003)(346002)(396003)(186006)(1800799003)(451199021)(8936002)(53546011)(6506007)(26005)(8676002)(5660300002)(66476007)(66556008)(82960400001)(66946007)(6916009)(4326008)(478600001)(38100700002)(36756003)(6486002)(6512007)(966005)(316002)(41300700001)(6666004)(2616005)(31696002)(83380400001)(31686004)(86362001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHUrZDdZQXNwUTFOQWtnTUJjblJZbi9Xa0FRMWhJOHFNNXlpOVVNSE11SXlN?=
 =?utf-8?B?d25KeGsrZ2hOK3h0eXVJNXJpQWZjRTk3QzNYZjRoQ1BXazlGRUVKUVRuOHhD?=
 =?utf-8?B?d2tUcFJhSEVpYWN5WWIrZXYzaU95bFVvcG5HeU5lc3lEZDhIVjduT01iTEpo?=
 =?utf-8?B?aEpZU1V5T09KWnhFcXArRVQ3Nmd3ZkdoWElYQjY1SlJKOEg4M2RnN2I4eTVC?=
 =?utf-8?B?QVh4bTE3TmNEdHFxa3J5Nnl0UytqVEgyOSs0S1VKVkU5RFYwL2Z6akNvNFBu?=
 =?utf-8?B?VmVNS1d1Q3pvSnozRXJVMitRejZCc0lsMVhpSlRoUmZQbFZsUHhKNjlIcDVi?=
 =?utf-8?B?NG9mMlpENXVnSUc3ekNVbmJUbWt4am5GOG9jR2lLTmpxVzdLQ2hubmp1ZHU4?=
 =?utf-8?B?WXo1UmpKMnVvdUhXR3dwU2FickZJb1RhM1JMMDFjVFlSN1NReWE5a2pZRUtF?=
 =?utf-8?B?bkVyRlBhOURyRkNBSit0cHVJTHF3QzFnQ01UYlZzem5HdjVhbmlKZ1BEOC9M?=
 =?utf-8?B?N24xeDZWSlhtSzY2clIveDFqaE5uaFNUMlpBamxlODNhdUFHODRsRW1TRWQy?=
 =?utf-8?B?TFVPY2ZQZEtOYzhJSU4rR3NYM3ErTkg1QXBoTktuWVRuWitWODJGckRSNDNY?=
 =?utf-8?B?TDBtcktDdnNtMUxlUlRobFhNaXNLcVczbFVNT0lIQUh6YytJN045QWRCZjho?=
 =?utf-8?B?d05QNUQvSEJmRGpUcFlPclVpSXBBOS8yMmZaNTJubkFYZjBPdzRyVHlMWGk3?=
 =?utf-8?B?TWJLbWRUN3lrSEFNeHZXZHhDN21YZUNJbWtadVM4UXFSV2hEYWNrYTJzT3JI?=
 =?utf-8?B?S01PbXlsaS9PblVOTUU4cTVLMVpHK0dKZ3NFeENyNkhFMEZlSlFZRE82aks2?=
 =?utf-8?B?eWpCVURoNjZWK0VReVNkVWkrZGhlTmJnMldZcjJTeERrOE55UWVueVpQdlF4?=
 =?utf-8?B?dTdYYldYMmVzd1BkbmNha0xRRmhFeVQ4ZkU4S3ppdENLeEFuTDltSWJUOUhj?=
 =?utf-8?B?ZXU2YXpWYTVYVzJDaFhGSjdzcmZ0N1d3M1UweEk1VVQ4cU9xZFlDa1AzUW1l?=
 =?utf-8?B?OGpxTHdiL2pSTWRiR29ockVqZDVJYW5INkFSSzVBMHpPME5OUm1YU1g1UkJL?=
 =?utf-8?B?cnFVTjBpVEY2djIyZGNnWnFWMGpqbGlTanY0Q3dVZlNRQlV4MFBSQ3Byb0dk?=
 =?utf-8?B?azYrbWt3R0ljcHlKcVAxV1pkSFR0Y3VQREdJRm05czRGWGdYWHJBOFl5ek9S?=
 =?utf-8?B?cUhpSjhQWTJpYldxcEVYejNybWtsOEJCOEIzZmpaRCtTTWFGdWxRbHAxTFdt?=
 =?utf-8?B?ZlRVS2VaQ3lpUDI5b2J2RU9aVnltNjdPRjZrd3RlWmZmYzVTTjFxYTFSTWJV?=
 =?utf-8?B?T2lzaXB1bHFkMWoycFUzVmVsNlhhOEE2S1VLUGc4NlFWYTNkcld6TTVHVDJM?=
 =?utf-8?B?VWFoOHJhbDFWeFo0SjlTK3J4QWNVeGI1NXBiRlhDNHZ3N0hQSzFFRDZsbERF?=
 =?utf-8?B?MENkcHI5b0x1YXRBc2FSQitQVysyWUc3a2lTMFZEREVnbkdPdzNwY2ZJekRI?=
 =?utf-8?B?cXM1aHhFSHRpYUVmOXAzSGllRFV4eHB0RjkwZzh6U25PWFZHUnlNV2NMK0dV?=
 =?utf-8?B?Q283NDUyM3dZTkhzMnQ3ZUNON1FBclFpeEVCdlpVa0pBZjB2bWVxNm45Yll2?=
 =?utf-8?B?aXFoNGk5dUs5cUg0dWxsc3ZEUUFPRlV6V2tyVmM4eksvNm85dXY4b3FvQ0la?=
 =?utf-8?B?TGJWc0N3TVMzb1dHclBSeGRWZ3ZocXI5eGNFR1FEZnIvWVp1N1QwVjZxWE1j?=
 =?utf-8?B?WVZDZDMwQWhDV2lVZ3ZlODUyMlBZaXdRRmZJQ2sxdmZuajc5aGNuM3E5S1Zh?=
 =?utf-8?B?Q045eWI4Ni81MENwckE3bFZMdWZEYk1iZ040TWhaTnNuOENsWlJkS3pWdDVB?=
 =?utf-8?B?bGU2eFJaZE00WjFGbUw4a09IRFByZ0xYc29nYkt0T0psTHFQZ1BEazRHTHM0?=
 =?utf-8?B?bDVlMW1QbC9HZlF2aUQ0UzRFdEVwSTAwMXJ0N1o5bmVVTDBUanU2bEJId1dR?=
 =?utf-8?B?d0lsblpxQVk2UlMrQUovNmVCQTVmL3VzVEZ3czVvUnpkdVFablVWd2JGWE1L?=
 =?utf-8?B?c3ZXdjczemlsUGRTTzVxNmJFOTNaWU5MLy9RRU1HcFdlSUlsLzRNa2JvZWdH?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa571b5-b9e1-480b-609c-08db981aa993
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 14:20:48.7577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJX7S4IAKGiMfkOD6Q9tlwpzPTw5n2KsCH8NKRsoSjl7F/TsV1tX4LrOtJ9I8USFM51OuQjn2uMUkEFB68pI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7312
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 12:02 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Yang Weijiang wrote:
>> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
>> CPUID(EAX=0DH,ECX=1).EBX reports required storage size of
>> all enabled xstate features in XCR0 | XSS. Guest can allocate
>> sufficient xsave buffer based on the info.
> Please wrap changelogs closer to ~75 chars.  I'm pretty sure this isn't the first
> time I've made this request...
Thanks, will keep the changelog to 70~75  chars.
>> Note, KVM does not yet support any XSS based features, i.e.
>> supported_xss is guaranteed to be zero at this time.
>>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/cpuid.c            | 20 ++++++++++++++++++--
>>   arch/x86/kvm/x86.c              |  8 +++++---
>>   3 files changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 28bd38303d70..20bbcd95511f 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -804,6 +804,7 @@ struct kvm_vcpu_arch {
>>   
>>   	u64 xcr0;
>>   	u64 guest_supported_xcr0;
>> +	u64 guest_supported_xss;
>>   
>>   	struct kvm_pio_request pio;
>>   	void *pio_data;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 7f4d13383cf2..0338316b827c 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -249,6 +249,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
>>   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>>   }
>>   
>> +static u64 cpuid_get_supported_xss(struct kvm_cpuid_entry2 *entries, int nent)
>> +{
>> +	struct kvm_cpuid_entry2 *best;
>> +
>> +	best = cpuid_entry2_find(entries, nent, 0xd, 1);
>> +	if (!best)
>> +		return 0;
>> +
>> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
>> +}
>> +
>>   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>>   				       int nent)
>>   {
>> @@ -276,8 +287,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>>   
>>   	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +		     cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
>> +		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> Nit, the variable should be xfeatures, not xstate.  Though I vote to avoid the
> variable entirely,
>
> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> 		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> 						 vcpu->arch.ia32_xss, true);
>
> though it's only a slight preference, i.e. feel free to keep your approach if
> you or others feel strongly about the style.
Yes, the variable is not necessary, will remove it.
>> +	}
>>   
>>   	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> @@ -325,6 +339,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   
>>   	vcpu->arch.guest_supported_xcr0 =
>>   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>> +	vcpu->arch.guest_supported_xss =
>> +		cpuid_get_supported_xss(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> Blech.  I tried to clean up this ugly, but Paolo disagreed[*].  Can you fold in
> the below (compile tested only) patch at the very beginning of this series?  It
> implements my suggested alternative.  And then this would become:
>
> static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_cpuid_entry2 *best;
>
> 	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
> 	if (!best)
> 		return 0;
>
> 	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> }
>
> [*] https://lore.kernel.org/all/ZGfius5UkckpUyXl@google.com
Sure, will take it into my series, thanks!
>>   	/*
>>   	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 0b9033551d8c..5d6d6fa33e5b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3780,10 +3780,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>>   		 * XSAVES/XRSTORS to save/restore PT MSRs.
>>   		 */
>> -		if (data & ~kvm_caps.supported_xss)
>> +		if (data & ~vcpu->arch.guest_supported_xss)
>>   			return 1;
>> -		vcpu->arch.ia32_xss = data;
>> -		kvm_update_cpuid_runtime(vcpu);
>> +		if (vcpu->arch.ia32_xss != data) {
>> +			vcpu->arch.ia32_xss = data;
>> +			kvm_update_cpuid_runtime(vcpu);
>> +		}
> Nit, I prefer this style:
>
> 		if (vcpu->arch.ia32_xss == data)
> 			break;
>
> 		vcpu->arch.ia32_xss = data;
> 		kvm_update_cpuid_runtime(vcpu);
>
> so that the common path isn't buried in an if-statement.
Yeah, I feel I'm a bit awkward to make code look nicer :-)
>>   		break;
>>   	case MSR_SMI_COUNT:
>>   		if (!msr_info->host_initiated)
>> -- 
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 4 Aug 2023 08:48:03 -0700
> Subject: [PATCH] KVM: x86: Rework cpuid_get_supported_xcr0() to operate on
>   vCPU data
>
> Rework and rename cpuid_get_supported_xcr0() to explicitly operate on vCPU
> state, i.e. on a vCPU's CPUID state.  Prior to commit 275a87244ec8 ("KVM:
> x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)"), KVM
> incorrectly fudged guest CPUID at runtime, which in turn necessitated
> massaging the incoming CPUID state for KVM_SET_CPUID{2} so as not to run
> afoul of kvm_cpuid_check_equal().
>
> Opportunistically move the helper below kvm_update_cpuid_runtime() to make
> it harder to repeat the mistake of querying supported XCR0 for runtime
> updates.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
>   1 file changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7f4d13383cf2..5e42846c948a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -234,21 +234,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>   		vcpu->arch.pv_cpuid.features = best->eax;
>   }
>   
> -/*
> - * Calculate guest's supported XCR0 taking into account guest CPUID data and
> - * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
> - */
> -static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
> -{
> -	struct kvm_cpuid_entry2 *best;
> -
> -	best = cpuid_entry2_find(entries, nent, 0xd, 0);
> -	if (!best)
> -		return 0;
> -
> -	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> -}
> -
>   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>   				       int nent)
>   {
> @@ -299,6 +284,21 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>   
> +/*
> + * Calculate guest's supported XCR0 taking into account guest CPUID data and
> + * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
> + */
> +static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
> +	if (!best)
> +		return 0;
> +
> +	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> +}
> +
>   static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>   {
>   	struct kvm_cpuid_entry2 *entry;
> @@ -323,8 +323,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		kvm_apic_set_version(vcpu);
>   	}
>   
> -	vcpu->arch.guest_supported_xcr0 =
> -		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> +	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>   
>   	/*
>   	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
>
> base-commit: f0147fcfab840fe9a3f03e9645d25c1326373fe6

