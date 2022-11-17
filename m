Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB95062E5CD
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiKQU22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiKQU2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:28:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8152769DE4;
        Thu, 17 Nov 2022 12:28:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbiYryNiD/9/Qdh0r2mkeH935uSdz9ocBgnlh8IkAQtPpS8TtQZ8pNKfXomHLqeytbJruLmD7ArYPIB3phC1T/K8McMi+unNOo/PVoQfg/kWOf7gdTKRkHAxcnz+eDuIXhD0/uj5wtm1YYO04vkKgB/42ifa6fXlJTCKFxfrZk+9GoBhlO4BfM+15EmwXE0wZ+nLsHpZQ0hBteu1JsDU5ayrglUJHsCVSzHl/8UFW+EvRPwMsVfkHmtPdxT0EsQJZ/zuu9QQO1qiUtRp0DxTUTDLho4DZbsazpTbumlFNXTYFfzxEMz6tF0tBVnbe8PJlj1WmK0hDJyVDtYXDlJ9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHbn8j7f8XQENW0zkZ133Za2BXoilzBbvTwvJvaRAZk=;
 b=TdtvoNOHeqT98OpPM4z8rDSDICOMuQGIeKKoNmJiRQ8YrXW716pyR0D1kge76jEZfdg6a4eKmqtwvgXLydprHxOTux/MMemOY9Kvc/NCQEApCd7Em3xxubcAmfuDGXxNgEddokLzhDtOK3VK/UI2u/FAP67K+Ef8jDc94RpMltDyVKYWwvjVnYwjCRJFeyovFjvID/bHJm4XnD5SHQFxpRK7BYf/nTTzANHHUZV+HGhiVsN1RIhsnk55ZZAECEQHAYQ7WcKUivBrIkrYIF6j9XdpOiw8FaUAAu6485DgLzG1W0Ak5PhqUsJIbTEH06Hltg9G1Mo+MS7jq81s/26gjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHbn8j7f8XQENW0zkZ133Za2BXoilzBbvTwvJvaRAZk=;
 b=4B9L7O45l2sEK4az+gKposmO20tDaDQuNSlF70A23NxWazGqVdWjKRKkZBS2BZ8RmtcjzVmQnNuwIVt7dZ5UEHbVsjZi9IXYti+7glFDy0NBnyk/XmmpDLPUFJjnhIGWm7TNu6/BCnklXn/jGB9BAg9aE3hLTeau7Ktb96htezs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS7PR12MB5885.namprd12.prod.outlook.com (2603:10b6:8:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 20:28:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 20:28:09 +0000
Message-ID: <21689d60-cf9e-1c9c-d24d-ab656edab66e@amd.com>
Date:   Thu, 17 Nov 2022 14:28:03 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 39/49] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, Alper Gun <alpergun@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <34246866043db7bab34a92fe22f359667ab155a0.1655761627.git.ashish.kalra@amd.com>
 <CABpDEukAEGwb9w12enO=fhSbHbchypsOdO2dkR4Jei3wDW6NWg@mail.gmail.com>
 <CAMkAt6oOB5xG7OnKn58Z-oLNBd091yAajZhrWDtXyu3UCiJNfA@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAMkAt6oOB5xG7OnKn58Z-oLNBd091yAajZhrWDtXyu3UCiJNfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:610:e5::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS7PR12MB5885:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ab9b55-3b13-4eb8-fb99-08dac8da3d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGwfvdv4m90EzkIzCWrSKqGjeFiyyfBwiKjPTMy5zKiE77D8MVWfm4d7EYwQmiwySPZz8zylA7hppkaLMtSC4BsRQ8+chlsxlkqJz402MuloyXGJmgDRsKv5eyj5WINK08piQAZc0slavnhtJ8Wc5FbeIXgadV4K/6MAe6bDlJjMXx813+uv4znBuMiO8Jw8r1/L9PidplXl5BXk+Q/Tx2SV7bUrlt8oeQ1C24vdOU7IWMthaNlGqRLBpc6ifY24b1LccgQCIBAuggDgkM1mBOHWFVsbrrHj7XMqOCWZK3jpddf6SgzhxQsk/9L3DxdCzJTZpHrcdJAOnpGxw2xUgpxEYLPWWX6hSTfsASbUOIe4wCURy6xswejpwIeIbbpU96FgJcoZ+dEVe0PE4vlGhawzkj5//uod+efVcQqt8GvzlSVTFY0s2tzsbXi38k+z4yGKSdiO8ifHCDSFU9dk1TccvI35TC6nt53lM467pUeixxHAkYAWvdjeU3A80j3Sjj+BP5HSY/OTWMDUkK0xZbc0rgvBvisiTbQJMr9ToZLdYGgTIfYhF8cdeVw/Ex1QgNvarX30hh8GaHT4ZE8ZtT3g5N/EqtQg8jSKqqRJMkYZvkT4HxJqFg6qsoj1ZF4qS6l+7vG7K/YNsTWy4KIkgosLXtBb3hAkdybmiBeAVND/29NdOtQg+Lcxi0+J9EssQxCBhlLyLqObnMl/kjocjf3AgHLKXdeMLtSLzoLaW9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(31686004)(2616005)(186003)(36756003)(86362001)(110136005)(316002)(31696002)(478600001)(38100700002)(7416002)(26005)(6666004)(6512007)(53546011)(6506007)(83380400001)(7406005)(66476007)(41300700001)(8936002)(6486002)(66946007)(66556008)(5660300002)(2906002)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0taQWM4cExEcTV5Yjk3ZDdiUkczc1lJYlUrMFZNMWI2Y0dQT25TbWxlb2lN?=
 =?utf-8?B?eDMwTVNkLy9qMDJ3VTZqb2xGZzF5dG5KNXdZRU5oMmxvRGk3ODU1b1ZZVW1u?=
 =?utf-8?B?WFBnaUJ3bS80YWNtSFByWHN1aUdEeWlEVklPeU53V2llRWV6QTY0c1ZvQ1ZL?=
 =?utf-8?B?SmNhNjJLcDdZNWZlRVp1TkZKQ2xLRDhURW8zM3cyZDhnd0lNYlBMTjVFanp5?=
 =?utf-8?B?UzgzU2FwQWRWS1hDdUxzRHVqZm1WK1pnYlhXQnIyUE1WTjVIMWlmZ1l0d3Jj?=
 =?utf-8?B?S3A1YmtWMUFvV3RtRmcyanNkWWxLWi9ZRkZ2KzhKclp5N05wcHBRWE9PYWg0?=
 =?utf-8?B?ek9BKy9pL3d6RWFLekh6WllpT3BWQjdPZjU5eS90VXpYYjVNcEJaMVE2azZS?=
 =?utf-8?B?Ry9vdGJNaTFOSGg1VFllcmN2R3NOL2tHOVlCQzIyUzhFWmZtVjYxd05jQVdn?=
 =?utf-8?B?dytuWEE1OXdNWDREMWlCSWNRbjBqV29wTG0xT014OXFxVWNVdHBvK3BPZlZI?=
 =?utf-8?B?M1hiaHZuRzBIWjVNaGU1RG9KODhjMTk2elBMaUNmcFV1UWs3SzFoS2xEUkxL?=
 =?utf-8?B?dTZ1Zm5BR04ydU5UUmJpeCtxK0FkMjRHV2tQSzU0UGcvMS9zdWRRTUVUZkd0?=
 =?utf-8?B?cTcrcitUV2swMkNZb01CUC9hb1pERGRhR282Vmo4ZGlyZ204RFNCYkxUazFi?=
 =?utf-8?B?NlBDN1VSS0o4eWFjK1R1eCtkbnpJdFQwYWdhZS9paXNlaVFCcWk2dktDRmdT?=
 =?utf-8?B?eUk4c0d2REQyRlhISUlxV3ZqZndaS2xIZERuRHp6MXU4cEY2RXQxMHBSWldR?=
 =?utf-8?B?d3lKYkxPai9nS0FtM2NraEhHTjhzSU14OVRHeVM1b1hQblZhZzdCTjZlWStW?=
 =?utf-8?B?MlE2T2VRQmRjQjB3cG9ZMDJZV2Q3dG1qcjJNd2ZUMU0yUG13TTFqOGMvRlZH?=
 =?utf-8?B?NXhvTEhmNllCQnZZeWNKTE9KRkYwc1h0N0F1WWs3QlZidy96Z3NHc1EyeXlv?=
 =?utf-8?B?QXR3WDVCU0hzU0dJU3hEWS9lbGlyaFhBV1VkeDBVVnE4MG5keTdjcHQrWHBW?=
 =?utf-8?B?SnFEUTZTcmprMGR6V00yTHVkeEtMdjVQZnloV2lvVit3MlZMbndTTis5cDdQ?=
 =?utf-8?B?ZS9vV2svMUV1ZmtHVjNHUUV5Y0p2anh2aUM5RDJCdkJXZUNUQXM3SU9XZCs0?=
 =?utf-8?B?WDhEZXFQVE5xZUxTdkgrMUl2QzFVOStLZnVkSWdHdktFWEtJRzhza3huNUlt?=
 =?utf-8?B?UzFrNGRpeVRid1hLOStLRzdybSt0azAzUC84RS9CTmp5OU5WUnpJUVdvTnJk?=
 =?utf-8?B?aFA3ZDBETDlnZXBmZEJFRVZJRDNuczdhZmFnWFpZQndnY1lNeXMzcldiNDc3?=
 =?utf-8?B?QVVvVlVaOU9sRlc1dTNrT1RIOUhXTk9iR0JZS0ozSURsUlNnQ2t2dFNIc3pz?=
 =?utf-8?B?cGpGS0UwNHJuUkhaVXJPVkFWT0E3endNeTlqSDJPNGxXcXovSVk0TVhQTXZD?=
 =?utf-8?B?QXN2YmV0L0IvK1BKNmZuTEh6NnpDVWgzbjI1ZDVraTZLd3Vkb0ZTQVRNUG1F?=
 =?utf-8?B?SG9BZytrMHIyM0l3M0FZVWpHc25pWUtCRm1FdHNHbVNzOHdOZ3RqQWdvUHlX?=
 =?utf-8?B?bUk5U0R4aVVlTmEzWTgzQXFXMWY4NE5Ma2ltY3F5MFNlUnNSSUV5NjROK3pi?=
 =?utf-8?B?SlhRNWdnSlNHN2d4ZHFpQisyQ29wZjM1bE1OR283c3hUYmVCcG96SFcvT0pm?=
 =?utf-8?B?bzFFemJSb2U3ZUxUeHlYMWZ5VXJuUmN5VStvVTlGZU9LZmZVYVFqalRsR3Av?=
 =?utf-8?B?QUl2WHZrU2xlVExRc3N6eHp3SGx1N1hBaXhXMW9aVHpmYUJ3SXl0T3FQU21U?=
 =?utf-8?B?M0tQSnpoSU9jc2pnTTNzNkorMlpjeERRNDJwZTAvNzE0VkxyUFZqV0JtQis0?=
 =?utf-8?B?dGlTVEJGZHM0SjQzN1RFOUNINS94eUV3aC9JQnJHS0FTRmFURXliYWJMUzQy?=
 =?utf-8?B?VVFkSTR6R0NIUDlsckVTWXp4VTFTYk1vZC83WUFkTkRpdmdRYjZvOXRzSVFI?=
 =?utf-8?B?aGRTUEc5MU5jMjBWTzdQU0FxOVZCbi9xR1Q3bEdxNG96MzhiQlAvaDkrdFh2?=
 =?utf-8?Q?+038ua0jN9mcEQcCbzcKW5s/h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ab9b55-3b13-4eb8-fb99-08dac8da3d9a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 20:28:09.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnHfqIi5qEAlE/+KpSP/n9kVnR4qLXA+xmhvVX9VWQynKa/FZLjxpJq4V7fmrLkYqw5XYE9/1dlKrITs99pQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5885
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/2022 2:18 PM, Peter Gonda wrote:
> On Wed, Aug 17, 2022 at 9:47 PM Alper Gun <alpergun@google.com> wrote:
>>
>> On Mon, Jun 20, 2022 at 4:12 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
>>> either be a private or shared. A write from the hypervisor goes through
>>> the RMP checks. If hardware sees that hypervisor is attempting to write
>>> to a guest private page, then it triggers an RMP violation #PF.
>>>
>>> To avoid the RMP violation with GHCB pages, added new post_{map,unmap}_gfn
>>> functions to verify if its safe to map GHCB pages.  Uses a spinlock to
>>> protect against the page state change for existing mapped pages.
>>>
>>> Need to add generic post_{map,unmap}_gfn() ops that can be used to verify
>>> that its safe to map a given guest page in the hypervisor.
>>>
>>> This patch will need to be revisited later after consensus is reached on
>>> how to manage guest private memory as probably UPM private memslots will
>>> be able to handle this page state change more gracefully.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>>   arch/x86/include/asm/kvm_host.h    |  3 ++
>>>   arch/x86/kvm/svm/sev.c             | 48 ++++++++++++++++++++++++++++--
>>>   arch/x86/kvm/svm/svm.c             |  3 ++
>>>   arch/x86/kvm/svm/svm.h             | 11 +++++++
>>>   5 files changed, 64 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>>> index e0068e702692..2dd2bc0cf4c3 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -130,6 +130,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>>>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>>>   KVM_X86_OP(alloc_apic_backing_page)
>>>   KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
>>> +KVM_X86_OP(update_protected_guest_state)
>>>
>>>   #undef KVM_X86_OP
>>>   #undef KVM_X86_OP_OPTIONAL
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 49b217dc8d7e..8abc0e724f5c 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1522,7 +1522,10 @@ struct kvm_x86_ops {
>>>          unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>>>
>>>          void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>>> +
>>>          void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
>>> +
>>> +       int (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
>>>   };
>>>
>>>   struct kvm_x86_nested_ops {
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index cb2d1bbb862b..4ed90331bca0 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -341,6 +341,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>                  if (ret)
>>>                          goto e_free;
>>>
>>> +               spin_lock_init(&sev->psc_lock);
>>>                  ret = sev_snp_init(&argp->error);
>>>          } else {
>>>                  ret = sev_platform_init(&argp->error);
>>> @@ -2828,19 +2829,28 @@ static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
>>>   {
>>>          struct vmcb_control_area *control = &svm->vmcb->control;
>>>          u64 gfn = gpa_to_gfn(control->ghcb_gpa);
>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>>
>>> -       if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
>>> +       if (kvm_vcpu_map(vcpu, gfn, map)) {
>>>                  /* Unable to map GHCB from guest */
>>>                  pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
>>>                  return -EFAULT;
>>>          }
>>>
>>> +       if (sev_post_map_gfn(vcpu->kvm, map->gfn, map->pfn)) {
>>> +               kvm_vcpu_unmap(vcpu, map, false);
>>> +               return -EBUSY;
>>> +       }
>>> +
>>>          return 0;
>>>   }
>>>
>>>   static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
>>>   {
>>> -       kvm_vcpu_unmap(&svm->vcpu, map, true);
>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +
>>> +       kvm_vcpu_unmap(vcpu, map, true);
>>> +       sev_post_unmap_gfn(vcpu->kvm, map->gfn, map->pfn);
>>>   }
>>>
>>>   static void dump_ghcb(struct vcpu_svm *svm)
>>> @@ -3383,6 +3393,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>>                                  return PSC_UNDEF_ERR;
>>>                  }
>>>
>>> +               spin_lock(&sev->psc_lock);
>>> +
>>>                  write_lock(&kvm->mmu_lock);
>>>
>>>                  rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
>>> @@ -3417,6 +3429,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>>
>>>                  write_unlock(&kvm->mmu_lock);
>>>
>>> +               spin_unlock(&sev->psc_lock);
>>
>> There is a corner case where the psc_lock is not released. If
>> kvm_mmu_get_tdp_walk fails, the lock will be kept and will cause soft
>> lockup.
>>
>>> +
>>>                  if (rc) {
>>>                          pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
>>>                                             op, gpa, pfn, level, rc);
>>> @@ -3965,3 +3979,33 @@ void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)
>>>          /* Adjust the level to keep the NPT and RMP in sync */
>>>          *level = min_t(size_t, *level, rmp_level);
>>>   }
>>> +
>>> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>> +{
>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +       int level;
>>> +
>>> +       if (!sev_snp_guest(kvm))
>>> +               return 0;
>>> +
>>> +       spin_lock(&sev->psc_lock);
>>> +
>>> +       /* If pfn is not added as private then fail */
>>> +       if (snp_lookup_rmpentry(pfn, &level) == 1) {
>>> +               spin_unlock(&sev->psc_lock);
>>> +               pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
>>> +               return -EBUSY;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>> +{
>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +       if (!sev_snp_guest(kvm))
>>> +               return;
>>> +
>>> +       spin_unlock(&sev->psc_lock);
>>> +}
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index b24e0171cbf2..1c8e035ba011 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -4734,7 +4734,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>>          .vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>>>
>>>          .alloc_apic_backing_page = svm_alloc_apic_backing_page,
>>> +
>>>          .rmp_page_level_adjust = sev_rmp_page_level_adjust,
>>> +
>>> +       .update_protected_guest_state = sev_snp_update_protected_guest_state,
>>>   };
> 
> I don't see this function sev_snp_update_protected_guest_state() being
> defined anywhere in this series.
> 
> Then this line is removed in 'KVM: SVM: Support SEV-SNP AP Creation
> NAE event'. Should this line just be removed from this patch in the
> first place?

Yes, already fixed for v7.

> 
>>>
>>>   /*
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 54ff56cb6125..3fd95193ed8d 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -79,19 +79,25 @@ struct kvm_sev_info {
>>>          bool active;            /* SEV enabled guest */
>>>          bool es_active;         /* SEV-ES enabled guest */
>>>          bool snp_active;        /* SEV-SNP enabled guest */
>>> +
>>>          unsigned int asid;      /* ASID used for this guest */
>>>          unsigned int handle;    /* SEV firmware handle */
>>>          int fd;                 /* SEV device fd */
>>> +
>>>          unsigned long pages_locked; /* Number of pages locked */
>>>          struct list_head regions_list;  /* List of registered regions */
>>> +
>>>          u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>>> +
>>>          struct kvm *enc_context_owner; /* Owner of copied encryption context */
>>>          struct list_head mirror_vms; /* List of VMs mirroring */
>>>          struct list_head mirror_entry; /* Use as a list entry of mirrors */
>>>          struct misc_cg *misc_cg; /* For misc cgroup accounting */
>>>          atomic_t migration_in_progress;
>>> +
>>>          u64 snp_init_flags;
>>>          void *snp_context;      /* SNP guest context page */
>>> +       spinlock_t psc_lock;
>>>   };
>>>
>>>   struct kvm_svm {
>>> @@ -702,6 +708,11 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>>>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>>>   struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>>>   void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
>>> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
>>> +void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
>>> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>>> +void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>>> +int sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu);
> 
> Ditto should this be removed?
> 
Yes, already fixed for v7.

Thanks,
Ashish

>>>
>>>   /* vmenter.S */
>>>
>>> --
>>> 2.25.1
>>>
