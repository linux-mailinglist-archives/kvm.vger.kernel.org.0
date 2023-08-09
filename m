Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606947755F2
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 10:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjHII4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 04:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjHII4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 04:56:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A01BF7;
        Wed,  9 Aug 2023 01:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691571410; x=1723107410;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cv7oIp4gD+taK5KGxCB0OO5oN7skR5NTJPfv+C4Ff7w=;
  b=NQ34GZ4obVIIvl7lbIfl6x39cPeJo5ptMVFYUVQObsAgC1qvySPhHDWB
   ACP99YSNDsJfBkaZInkJKfA0rAXIHg3E5x3njcofltm7M8+bejt91FVuk
   U2RJV4FE4aC3pgrba/89txfTUzrEcd5V1CuOhTOBK127PAv3NN1d7bXX0
   sKk3Fe34O8DaynKOH1B/vx6CO7M8ZNCBwpnNyf8dDEMRDYWH/jrnJ6drj
   LSk/LIKjqyetVZWml+UNysxJROY2Eq4Cl5KOKeUDdazBzoKdtHlO+14xF
   pEAmsMq9Ln5ANLSr/Nv21AfYqdReq3Ss/Btx3Q7j+SgtYkm4c70HlW7mo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="371060892"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="371060892"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 01:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="708640780"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="708640780"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 09 Aug 2023 01:56:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 01:56:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 01:56:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 01:56:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 01:56:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn/2dC4jFjPMxDK90NxyQp16pCR/K54a12B7RXnzBONr0ivap3IOUAm4WJllC9TNetk7xq5X3Gpg9z+EXnZbWmqAOniiV1Th13YPu7cJm3sW1eE0UE6a3MQGwRZhqhoEeDY0+VaZgIELYPs41s91wmYJ7Ov1n1bP/+sL8XzdPmEXoOo7k0wbRg7kHnFN9T1PqoPw5flZSZ2zXf5VWmfFE7Yr/UMLv6Mitq65O1gzkq+PqIdQ+0HDyJpZuJ0UeRNgbeGI90NFUBlGv81swB3c32L3kOXdXHpNEnFD9Oe3/ywbAyI0NCthrMMiViJX8UFf9+PJaagswi/pBsaAVSC3hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm+nNkTnPVH4gI+pYuujLdQS5oC9nLuuTQAs7rAxkFA=;
 b=NY9AV1g7MW8ER36UQSDzLdDfIIDqV+yner29kOeLyj9ey2enos0uLfyryYQGo5sCl4l5NaKYXetk+kfiD/QQVW/lK+MyYsdDFmuND7RPK7ckvqNxacKHOnX5muub61b/UObv+5oK/F2wFr976RvOk/X6tLOd9R5OJjsynudS+lOTd/PNQo3urMPANf4QKPBsoG5JYbG7iKTqXjyejM7ZOUblVVZN0wjbah1L4RtdDdaHhfXt3F95GSj3KxwbxSjs+KPy/fVs1P/EgaHqDtJJtorqX8Rk18YcLtqFTYNDKLpKHnOzbCDOElZnwP9JbfUAx65f//HCTZMzuXWJ4vutTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5392.namprd11.prod.outlook.com (2603:10b6:5:397::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 08:56:45 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 08:56:44 +0000
Message-ID: <0655c963-78e5-62c9-50af-20d9de8a1001@intel.com>
Date:   Wed, 9 Aug 2023 16:56:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM1C+ILRMCfzJxx7@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1C+ILRMCfzJxx7@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: 281ae999-ccfd-412f-ac6e-08db98b68e9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ijD990QMzIbP8bCbq72O7G8mqsMRJFw2w12ogfbLjXu8xemO8aZcMHgX7rLBKdbnpjqXnV0ylbEXweMcWN2nr5Q5V+xsD/b9IEle+pMDLTH5N96JSnxpeHPS2EWXD1ePBuj/ExY1jCoLj2koN4pmwVvAuk6usxpd3rng64j0AinVXCsCxNTaY572a8U93TzmXKDvSSfYtD9NIxIOpSM8oXjKAkdgmkYGBQG7ibciusJl4lXzXl1VIGDppqwJp6UsLDKZlAHVR5+6ihpqfo3Z2Aa5cWcIsUCBt097T9VPEngXX9rtUBktVqGM0wkFOWfAydcsorW2MsjXeL/8UHZQxDsMcUjHDWHkB/WejRBCJpI77ci6IF0NqITXRJTIXioQGA1tnF9CFXBLEaMEBOStHkeVrDedTSJjXLWPhbe3xuQwA8N7KKyzLdQMP+NBAit/PiDuMf4a6G3mQk7obzcr/sKnD+yUX06uvYvIgCNY4WdyhMvTp1ApdbA6GR+CVmDiib5GNMx/7iEFYSMRjdAORBDeKOS8KMT5BB93co+TpZkguvKC3tMwp+RALI811683EWVURQqE37GkO8zdtXwBFTjkEsedKCZZ/Pdyu/6i+xCnA7JoV7R2wLLiNBhBBY+chYNNu6hqDpIfklRbmOq1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(366004)(376002)(1800799006)(186006)(451199021)(2616005)(6506007)(26005)(36756003)(53546011)(6512007)(6666004)(6486002)(478600001)(38100700002)(82960400001)(31686004)(66556008)(66476007)(66946007)(4326008)(41300700001)(316002)(8936002)(5660300002)(8676002)(6916009)(2906002)(83380400001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alZZTjN5L3phV1dhQUlGQXFMZXdVTmU4d3RsdUw1SXJvSlZmT3FPQWpycU5l?=
 =?utf-8?B?S3ZJUUFFQ3cvL3BkSSs1enBDRDhET3FNTXlQMUpZTEExTmNNMzhoTkVja2Ir?=
 =?utf-8?B?L3JlS01rV2RlZ0hCbzRqZi96ZnI0aVRtWWhTM1dZdG1jbTBqaktzaXhORzRR?=
 =?utf-8?B?dnNOSS9seG9IaTNEd05aUUtOMmN1eDN0bUhKL3d4TkttbkdrRCtuNzlVb3NU?=
 =?utf-8?B?WitrY2hKQXFqZTIxZEhuUGEzZjVQNG5nekhXTHNtWjczKzRDU0t1ZTdXR3o4?=
 =?utf-8?B?WVh5NVZqVDBZN3RNVGUvYkZQYTdBNWhUVVRLRDZkdGhObE1BSFBpYU1nT2J0?=
 =?utf-8?B?WnhpTUlEU3RhRkI4cmdYbXBrL3lXWVBWQWgxaHZFQmIwaFdQeTRpaFlvOVJh?=
 =?utf-8?B?dVhJbUcyYXJQU0F6MVFLWllxNEJ2QnJleVlLWFEvMm9VZERPVFBJMFpmVUVq?=
 =?utf-8?B?UHR5alRPK0R0VG12WGZIazNDS3l4Ykx0RmtscnRKcUtLNzUvSkJoNkMwaGc5?=
 =?utf-8?B?aG41c2JtbXhtaktEbnQxNkw0NGFvN2dYMFdNK0FjNmdFSmY3dGNUb2lZOHky?=
 =?utf-8?B?aVRGZTV0MU9SUUtxam9qMU4yZWJxLzZ3NW5RRSsxU05JVDlFc2tyL3NpRVRl?=
 =?utf-8?B?R05tRlV6eXlFMnJVb1R4Z1ZPZVpmaVFZNjR4amZ6NmJRblFDaUtOWVpiWko0?=
 =?utf-8?B?TzNVSENxWitsdW5wTHdUamU2b2Y2OVJHcjFlMG5PQnRxT0VSSitIMHRINmox?=
 =?utf-8?B?NXBNT3NhMGZySlNpWUt5N3pLdTVFdjZ0SGN1RFVpc21XYy84Vjk2ajM5OWtP?=
 =?utf-8?B?ckx3ZFo5YWxVSDJCQzVITXNvZEc5a2t5MER2R0ZSYmNaODh2SCtVd0NJNVZD?=
 =?utf-8?B?Vm1NSytWbUpCb2hoTlIyRXFpVktMOG9jNXk0VzRpZXdMNnFJelEvd3ZoZXYz?=
 =?utf-8?B?V2FjR2gweFFLd25GSEtRQlZmejlQZUlWclpQLzZ3UUZJdDR3cmRzTDBQYkpV?=
 =?utf-8?B?OHRyc1VSZkpwOXE1Q0syWTYvOHdhQTZMY3R0ejl4U0lSOEtWZ1pPRWZsYmZ1?=
 =?utf-8?B?S1FOTVNjbUtORFZPVDQwSXFlWFVYZThVVEpnTncwYnZaSlZYcVB6a3h0Y0lp?=
 =?utf-8?B?eGZCZ0phbEthMGh1U0RTaVEzdEx5bmwzUVJ2U1g0c0ptMmlBMG1XZjltbWVE?=
 =?utf-8?B?ZktFSm5HOWFsTDJ0SnZ4ZW56MlU5VlhTVFVtLzhkdGlDVkh5dUtUTEFFRzJ3?=
 =?utf-8?B?cEhLMFlndzNzbVBDdE9NRnczUUpTTWtRbkdXM3ZDUWxMTTV0SXlHQk9yU1JU?=
 =?utf-8?B?L1ZROFhVR0F4K1RUSGQza2ZhRHpDQ285VzRQRS9VRVBLODVXM2VXMDVhKy9k?=
 =?utf-8?B?dVlCY2VRandhN3ZDUlVaSURpSTlYNmxjME4vSU5Dc21NZjUwL1VwN1grRGJ4?=
 =?utf-8?B?MmxRMWVBSENKaW5OYXBpYWtYTUJtQWJhRVBGa21udDN0Wis4VXkwbk5wTkR0?=
 =?utf-8?B?Q2t3c1hHMzRUK0E5TEs5VXVtRHNUa3FFc3hka2E2RWoreHM0b0hxUnc4aXpS?=
 =?utf-8?B?REZ6WmRnZ1E3d3ZOaG5QaHhxbFM0Wmh4Q2FwbnY1VjJFWlR1aDhoSHF2ZUVP?=
 =?utf-8?B?STFFaWp3T3k0MzVLV2h1RUVkbEVram9mWWI1OFVDd2UrZm1sSW9hZ1dJbnlZ?=
 =?utf-8?B?d2hvbnVaTTdSczRBOFZPUUhFcmpSdVh4UitCZ0FERFFsa1lVV0Ztejc5MkZo?=
 =?utf-8?B?YjNmNndKSmIvTEYyRy9nUTRUQlE3ODRMbEpxTmF3dXk2V3F3NWEwTXlPTFlZ?=
 =?utf-8?B?UWhGMUkvZ002dVN6c2xZcytzeXlodEduRDJONmVNbVZBVEFwUUxpanBQNkl4?=
 =?utf-8?B?RXJwTGZjeVBDTm5nb3grWHB6UllpSXdhWTY3cGxPbnlrdGxDNmxtRk5Uek5n?=
 =?utf-8?B?TjlnL0dHR2cvdE9EL0RWTWdFd3NOWkhpSjc2QUdpNUh0NEJvcEgvOGxpVjJC?=
 =?utf-8?B?KzJEQWltcUcrTTh4NmMydkhwdDBZd09kNFVxK014bkxOZ1I3bnEzL3ZFR1Fi?=
 =?utf-8?B?YSs2RHp6aTkzKzFwbEphNmJSZXBxYTZpUDFteDFuSEJqb0x6emVBYXFCZ2Zp?=
 =?utf-8?B?WmJXb2RIRWlucng0Tm4rY2o0aUlQVEpFSXpUZzJ6WEp3U2c3bkphVTBxM3By?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 281ae999-ccfd-412f-ac6e-08db98b68e9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 08:56:44.8118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++SsAPszS8Hl+v0HWcRnK0wK8NtgX91GKsOUgyHpv34RJVdhv4v8S5wwmUrr0odCKmH6LzMyoSQEuylCU9bEyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5392
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 2:27 AM, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Yang Weijiang wrote:
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
> Hmm, this is arguably wrong for userspace-initiated writes, as it would prevent
> userspace from restoring MSRs before CPUID.
>
> And it would make the handling of MSR_IA32_XSS writes inconsistent just within
> this case statement.  The initial "can this MSR be written at all" check would
> *not* honor guest CPUID for host writes, but then the per-bit check *would* honor
> guest CPUID for host writes.
>
> But if we exempt host writes, then we'll end up with another mess, as exempting
> host writes for MSR_KVM_GUEST_SSP would let the guest coerce KVM into writing an
> illegal value by modifying SMRAM while in SMM.
>
> Blech.
>
> If we can get away with it, i.e. not break userspace, I think my preference is
> to enforce guest CPUID for host accesses to XSS, XFD, XFD_ERR, etc.  I'm 99%
> certain we can make that change, because there are many, many MSRs that do NOT
> exempt host writes, i.e. the only way this would be a breaking change is if
> userspace is writing things like XSS before KVM_SET_CPUID2, but other MSRs after
> KVM_SET_CPUID2.
>
> I'm pretty sure I've advocated for the exact opposite in the past, i.e. argued
> that KVM's ABI is to not enforce ordering between KVM_SET_CPUID2 and KVM_SET_MSR.
> But this is becoming untenable, juggling the dependencies in KVM is complex and
> is going to result in a nasty bug at some point.
>
> For this series, lets just tighten the rules for XSS, i.e. drop the host_initated
> exemption.  And in a parallel/separate series, try to do a wholesale cleanup of
> all the cases that essentially allow userspace to do KVM_SET_MSR before KVM_SET_CPUID2.
OK, will do it for this series and investigate for other MSRs.
Thanks!
