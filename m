Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6F160B4B6
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiJXSBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiJXSAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:00:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9C21AC1F9;
        Mon, 24 Oct 2022 09:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvODampSzGN2zGYVn/vUP9tylHUPzvxzytGy6bpl4Q0fKJW0gWj/9pGH2mDi7ctuyup1rgv+ZOiMiIPeMJY/qVh3H1Qa8E82VLk0lGsIIv+2+yu2k3XbL1d9JPrrB7E1vK6pEzSnw3Lmb4RNV6YOmFx0VPf7+b2ySW90TkczADamJTQ5R+LJ4u4TdIKChLyVm4FuRd5AmdEc0RpqYTdYGcwEqSunBNzGf+CaLWUBsbRuiUOvQLj4xcvV/q5I0EitbwCELbQexZvZypxcu5PFC9wBSJ5WWo5qvfcB4SC3/YyOyJT39FP2yqH+Uo4dbDlvtVu5WznsSavLI3doSAqFqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xSnzXcofB1PXgLdyTraaOZcbIPkV/2SQPjXR8/Q5P0=;
 b=EAoBvfTncwR834flBbfAYlANdm7N8+Kbe2aiOUCq4D2gPwOH+92jUqxf4ibgVFM5C6vgs7Aun4RP5Z1/pKba6LW5Lr0DYgbWXvCMWL30V0QHn3/b1WR393fJPfmyUtRxEBlCgdhwTdWjs0QBZPgNAdlGjXhmscC2lrixev7iA8FQZypdIxNjz+3KRJs0NSU5tX+OAJRqZvH1bF+reGLdIjthcsIIXP0fK73gtzH0t6gnxE1TCbhVHNX5wLFys+3fQBRZy6IPO2kHXHFpcQd7eqeHuwo7sItnwZRsnvJ0fe75WsLfjRwPCUlISQ6OGscsxa2QYuN/zBwYVHBgdx/CMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xSnzXcofB1PXgLdyTraaOZcbIPkV/2SQPjXR8/Q5P0=;
 b=3AUyvywnSsJalN5naJJc+L9oFwhDcU7qoKa0PdHml6u1b1ifZgezRp14BHRezzlJX5sW8AWxkwJ7tqYKsWCue6geBVnt1maDCZBt38xHyDbQuoylxBDiEX5fW4zizMCT2YZbTrtoDbOOFT2jpT+UjzKVymW8zg9US/Jtw71NdDQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DM6PR12MB4203.namprd12.prod.outlook.com (2603:10b6:5:21f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 16:23:47 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::9e7d:6fa5:ddb4:986f]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::9e7d:6fa5:ddb4:986f%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 16:23:47 +0000
Message-ID: <8c6a359c-0d8f-b524-984e-bc01be1866d6@amd.com>
Date:   Mon, 24 Oct 2022 11:23:43 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH] x86/sev-es: Include XSS value in GHCB CPUID request
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com
References: <20221012204716.204904-1-john.allen@amd.com>
 <Y0nGGeCK+/FPOZej@google.com>
Content-Language: en-US
From:   John Allen <John.Allen@amd.com>
In-Reply-To: <Y0nGGeCK+/FPOZej@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DM6PR12MB4203:EE_
X-MS-Office365-Filtering-Correlation-Id: 74072910-9343-4482-1b14-08dab5dc20a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUsyMr5+ocf20jD9pmuye+xQYOf5VP0ZmKX8kEOvaqHVy04HWDh5yjZqrgqZYRQVqCyCzRnZHMaM1Pb2pqoxxZiFMRanX+6Gc6Vh2cpI/cAvGamZCo1kcxBoe4bu/W0A8YAYmz+FA5nM+FFAHt3yR1+Y9zzpC2zH1eoBLulbDkDZ0+aB1Aq8UQ1Ddt3sGtvGBRWJKMuL6HxqXLtjkIVMtj9tCfCJ/pzLUu7KYPOUPdIdfliVWzsoDoAgqRNKnf793G3dWT/t3FTxHDzawFtaYUyjlpjxeX8yROLybUNXLLFnWXRNeQBPzp6Qoqk1dbqJJdvIrFigel3j2Pr9/ak4Hi9he/X3YdO7sPWfuY4SrKMB3h34mmwwatmZsze1qzttCexAuV18HnsuNwf3cd//rN9agJBR67sdwQ/mIEUtEOOzToNaN3KeLcGxUVS1fVeIhhjS5jG3S4FGxz50wT4Nz9yTKio5X8D5LmtkWYIwNBuSuxFVxA5c0JIDTD1tyTdJsS11VW5P3WMdeXwD+MZuVwqhpfBiTxXY16fbAQFVkQwivxszwKS2qRpvvA1Qdm+yOu8wtrWwswI5+qloKGYf3BIhjPLDJa8534xnknlG7r7PqGeY2Tb2DxX7f5GYo4qHTs8zE6TnR4NsemSGhFmgZ2B4/UqrRm+si6SlFP3dvmTreaKIwB9+6T+RfQ1hGASAhDZ3nGuKXsIoNyrGv0M3jNLmCNHscOzaTrqMW2rXNtOX0/S+E4NHmx2YqrYFZti/QcauUv3W41DnOHLK3Ig9OaZguTF+WmVtU+SYsXTLXr8HpkvuXqQUx/1s1NOIGB73
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199015)(6916009)(41300700001)(38100700002)(8936002)(478600001)(6486002)(83380400001)(5660300002)(36756003)(2906002)(66556008)(66946007)(8676002)(316002)(66476007)(4326008)(966005)(6512007)(186003)(2616005)(31686004)(45080400002)(6666004)(31696002)(86362001)(26005)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk5ZS3B4aUR4RGJEaEF2T08vYjFjWXR4ODh5bzBVTEg0QWZOM2JqMWd3ald2?=
 =?utf-8?B?bkpTSUhaeVZjelk1T0pkZSsycm9VcWRwYTd6K1ovTVdzODVaTHYyV0xyNzVW?=
 =?utf-8?B?Zmc2MDZUQVh6MnI2bHQzbGNFS2UrNFA2YzIwUml4THE4NE5nUVEvWHVWa2pP?=
 =?utf-8?B?enlhcUZDQ0d3Y1M4RjlPeE1LTVRKNVZ3UGFyMmI5YU1PbENnUkVxVTAxaWJB?=
 =?utf-8?B?OHJsTEdnOTlMM2F4VnhZeGluZ0l3UzlzdWdCM3FXUmpCZmpZcm56M3RkcGpn?=
 =?utf-8?B?MHBLUG5BRU9ES295eXFxdW5sNUdMWU5NdGZBUThGR2RERVkxLzdaamRCb2da?=
 =?utf-8?B?OCtBZVRwU29Na1kvdS9ncVJkZmo3VlMxVU5NOG13R0M1MStkZkc2OUVVbE1S?=
 =?utf-8?B?TVpNbGdoeEVXWW9QUmpsd2l1VFhwZGJVSDcyTVgrR2NNM2sxaXc4RUU1c3ZO?=
 =?utf-8?B?QVNQazlXTytCYTQvSUZTZXAveFhRVmZXUkdzdG9uUE9wWVRmTitiV3Z1eFQz?=
 =?utf-8?B?bVpMd2JJclRsdThJKzRUSEsvN2UzU0F3K1dydXF5SStmMTJrdmJhU0VOTmVa?=
 =?utf-8?B?RzlEdlo4ejNHYWptU05wYWdnd2ZBN0Z0YURzVnhUVWlrd05mRWt1U3RQbldF?=
 =?utf-8?B?RUdYOGdVdmM0dXVDUmF6ckt2Rk1KWU1EaFMwQXpFSXNDMXU3MS92SlpIZExN?=
 =?utf-8?B?dlFtNThJdTFPc0M4aU15Mm9KZlJpRTNRcWNNSDcrUzE3UWx5RFAyeVBkNzln?=
 =?utf-8?B?RThBR1N3NkFYdnJ1Vy9vWHZ1ZmVEbzJ3c1NlT1JhcEJIcGpIRjlyMkVIcjRz?=
 =?utf-8?B?Nk96QUtpUzNvdDBBOXZETW5BcEsyeHVqWmpnbWJqM1ZrZHIxSWtTMlA1NWJv?=
 =?utf-8?B?TGVtZFh2R2o0b1BJN3dnaENNcGZCZU9oS2JsdDRYZmNpWnlIWVJydHF4ZCti?=
 =?utf-8?B?M0FnZXlXWC8yR2xCTm5Fd3c3aW5QUWdKdnlTRW14MmpLSjNqZG15dWpqdWV0?=
 =?utf-8?B?YU9CY3VoMHNuVVVBR2Yvbk05RmVGQldUSmFOalhhejBuVWFkVlMvUldHVUdF?=
 =?utf-8?B?NVp3Nzh5SnN0L0NZK1dnNTN0TDZSUk1XZ3dxSWpEQmpTc0xOTDFQN2M4NEVa?=
 =?utf-8?B?T0pHaDJ3Q0NEeGlGZGZMNXVFUUFKNWlCektEWjZmQktrTC9POEtlZy9FdjZ1?=
 =?utf-8?B?dmJ5YTVuOTJFZktxOVRBVnBTOVZDcnU3c1dpR21LZkpRcW5FZHl0cXBQYnRz?=
 =?utf-8?B?azZBUzJOMmtWWFBpbVFKektyVXg0SmlSaDRTQTVoa09yd3dtUkhmRHp1ekgx?=
 =?utf-8?B?VFNDTkdWdmRVSmlEa3hITHhsOE5xalFPRENWOGpmMzdWWitSYzZ6cGNXN1Yy?=
 =?utf-8?B?QjhET2NhVDQrb3FpakR3OW00amFNNXdrZGtEMStMcjB1U2VWSHRlRUh6SnR3?=
 =?utf-8?B?OUtSUzBialEzYlNIT0RlU0ZWMUVGeC9henp5MEQ1eDlvMG4rUGpVTDgwZlRH?=
 =?utf-8?B?eUN1R2dTUll6Uk81eUJzakhzUGFsRG5QZ1h2UjNmc0FXd1pEOFBuSTBza0h0?=
 =?utf-8?B?K3gyMjZnNHVjMTBuWmIyRUxPR3dJOGgrYnkxVHk4WEhxTDMyei8ySFVsczk4?=
 =?utf-8?B?cjR6ZHlFSHNuTDQzNzVzUzlqcjhZeUxyUzJMNDdsVElnQ3VCSkNKUTlMckY4?=
 =?utf-8?B?UFVKS3ZxYkJEanN4VCtVN1ZEU1lGNjR3d2tVamRXT3pCZjdwNWlkNXkzSlFm?=
 =?utf-8?B?cVlIVkJsZGVKUXAyMTlRNkZRTi9nYitXTTJ4TDhlelJ3YzdrSWlzR2JtYUNa?=
 =?utf-8?B?bTFveS9WYkt6Ly9wUDdzSmRXc0RYWlRaUHJYV2QzS2p2Y3pGdllicU9yczEx?=
 =?utf-8?B?eGNhNkVFYVl5Y1BZeVJkSlU4RUJvaC94YlVxaFdrczU2aCtlVHhSNktvV1g0?=
 =?utf-8?B?QVdzTmUyNTVaZ1V5M3lCWlV3eDVnQTRHVVlNamlNOU9GMVB2dE93dnVObkpM?=
 =?utf-8?B?Q1BjS2hvTzdkY1JaUjJtMUZ1bklFc2E3R2Nac2VMSWNHNXlrRFZQL2tPU1lO?=
 =?utf-8?B?VGloUEExd3hQVVY4YmRobzRxY3pZT1hCemNNczhtYlpTTUtxQXp6cFptdXF6?=
 =?utf-8?Q?f5ttkKy0nvwrCY1Yu3seaXsja?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74072910-9343-4482-1b14-08dab5dc20a3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:23:47.3682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8XOBiHeNIGh3gcETcOyk5lHvpHLUWP2H5cp09417d3B6uaR+cv4JjTvgY5pSIlfeRnpw0LPLsz/uKqPrzsOsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/14/2022 3:27 PM, Sean Christopherson wrote:
> On Wed, Oct 12, 2022, John Allen wrote:
>> When a guest issues a cpuid instruction for Fn0000000D_x0B
>> (CetUserOffset), KVM will intercept and need to access the guest
> 
> s/KVM will/the hypervisor may
> 
>> XSS value.
> 
> Heh, "need" is debatable.
> 
>> For SEV-ES, this is encrypted and needs to be
>> included in the GHCB to be visible to the hypervisor. The rdmsr
>> instruction needs to be called directly as the code may be used in early
>> boot in which case the rdmsr wrappers should be avoided as they are
>> incompatible with the decompression boot phase.
>>
>> Signed-off-by: John Allen <john.allen@amd.com>
>> ---
>> This patch is logically part of the SVM guest shadow stack support series seen
>> here:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20221012203910.204793-1-john.allen%40amd.com%2F&amp;data=05%7C01%7Cjohn.allen%40amd.com%7C2ed48fc57d2247f809ed08daae227f2d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638013760436182289%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=OIO3X5EQdTazOozvCHIF9E2tT%2B6aMqarmkA8o41wJ7M%3D&amp;reserved=0
>>
>> Sending this patch separately from the main series as it should apply to the
>> tip tree as opposed to the kvm tree as this patch is related to guest kernel
>> support.
>> ---
>>   arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 3a5b0c9c4fcc..34469fac03f0 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -887,6 +887,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>>   		/* xgetbv will cause #GP - use reset value for xcr0 */
>>   		ghcb_set_xcr0(ghcb, 1);
>>   
>> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd) {
> 
> IIRC, XCR0 and XSS are only needed for sub-leafs 0 and 1, i.e. this and the code
> above don't need to expose XCR0/XSS to the host for ECX > 1.
> 
> FWIW, I think it's ridiculous that the guest willingly exposes state to the host,
> it's not _that_ difficult to do the math in the guest.

That makes sense to me. I think given that the XSS code here is tied in 
with the SVM shadow stack patches, I'll submit a separate patch to first 
address only exposing XCR0 for sub-leafs 0 and 1. Then I'll address XSS in 
the next version of the SVM shadow stack patches.

> 
>> +		unsigned long lo, hi;
>> +		u64 xss;
>> +
>> +		/*
>> +		 * Since vc_handle_cpuid may be used during early boot, the
>> +		 * rdmsr wrappers are incompatible and should not be used.
>> +		 * Invoke the instruction directly.
>> +		 */
>> +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
>> +				    : "c" (MSR_IA32_XSS));
> 
> Doesn't __rdmsr() do what you want?  But even that seems unnecessary, isn't the
> current XSS available in xfeatures_mask_supervisor()?

Yes, I think you're right. That should make this change a lot more palatable.

Thanks,
John

> 
>> +		xss = (hi << 32) | lo;
>> +		ghcb_set_xss(ghcb, xss);
>> +	}
>> +
>>   	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>>   	if (ret != ES_OK)
>>   		return ret;
>> -- 
>> 2.34.3
>>

