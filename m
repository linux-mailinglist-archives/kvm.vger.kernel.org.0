Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1B3784CD8
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 00:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjHVWbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 18:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjHVWbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 18:31:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454EACF3;
        Tue, 22 Aug 2023 15:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRZK+JQVA4Vh+zNrdO3Op2U8olKCIQ2XCP1Z1i3r3ED30ovFx+9u8cXUYCcEGkAFg6oCaMHNhNLqgNyjpf1z97WHRLmJ5/o/GigD/7oi3H6mgD1StUfDuDM/s3ePKZO7cq13Aq14Y354L0w73Tyzhz5D18FCdvRC89ADDysD44GLpaldzYCydYDjvV9gvd3AxYIeQAi0I9eJx1MVuCSs35j7VtRNgMv0SuK03+GnNj/HoL9bEvTfycSm3v7r/r8Ox3neNdzzXdy8hgQFrta9lyo42MazhlQCN8nAuL2QWI/dwB7f25ZYYLrDXL2Lb/gvJVa6kBkaBMseOGDFVtjrBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeY+XDXMgxeKfoDnlxdYvLXql+mlkfXxmdOzQYE9K4A=;
 b=nRfhsEYskxUnSJKRfYxaLPGn8F4aZiFXuD/AN3alT4qvbhVs0qAQDHpuqHjKxsXlApR0DwBqmTanSu3CBQVKqFE33zrFMVUW4yGimaV7SJ5wSJpRQM/jLsSRuLmc27CNr/R+mShtZPxzywgJvRJ6WhH4/52A/R2oHS6cqNm/4jvnV/mGC3z5WUxEeSFa3Wp4rbsAfNiJvu5JiDQZ2smHN+kxB/lmIx5dAFAyS1d4Jx9VN2K9Y8a/7z6WONSSYjvrfJGuraz3wFU4HN2hDqMkL4yMjN3hwpRqa4UwyJGzIBOpM1cNXj65m0s6mVASrM3IEZBkWdFJX2x3eWzJUSOMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeY+XDXMgxeKfoDnlxdYvLXql+mlkfXxmdOzQYE9K4A=;
 b=W752Fg87GKCeADbuEayD2Orosg3poAZ7805n569VEWkudj54sqk7RQ4YEUZt7PSMCivB5J9bTS8UZKwp2UCdG9QiSyxeB0VnyWMABEkhCwMDrH4hXlJ7PMcXXqjGby/tV6zUWXq1kx/jP2RiCH9jQW+PizW7ZVdMeb9Z/3pK8v0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MW4PR12MB7117.namprd12.prod.outlook.com (2603:10b6:303:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 22:30:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b%3]) with mapi id 15.20.6699.025; Tue, 22 Aug 2023
 22:30:59 +0000
Message-ID: <e0e7e18f-6282-b95e-62d4-1f136649e2cb@amd.com>
Date:   Tue, 22 Aug 2023 17:30:50 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jacky Li <jackyli@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com> <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
 <ZN/0aefp2gw5wDXk@google.com>
 <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
 <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com>
In-Reply-To: <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:5:40::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MW4PR12MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b0b85fd-fb1b-482f-adc2-08dba35f7518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRlVEHL+chVdY0pAJ+tO6zfG4E2p8KGijDxesiNL/K38C0Mignr4zp7DhUP5VMRA9t9LgFMtBcPMeW3QTOUZJiEMMBfzSnyo5MtblRC2TrS7V77pcVtO/a8h8i+ShQvg2EWnBNGp5Gg9UuZRQsJbwookLM89OnzJAXqSM+0+ZxqmgZwELEM8kgxjLkPHEIeAc2dPXQNMOkp+iHafVmRZzdbwptN/9+djFZ9U0LjgjtHqZlKcQY23hGEmIGucMMuo12fHC6eh5/U8zyLBKB3nQRzKxJSSH54UAfZP3nAVbfXK8hCfjXFdsQfeIoQaPgM5hF48WjSYafjdSiYaiiUkc1L8+NJPgFIcGj4TD0lB9UezE5Y4h6qHvUWJKbCw/Yb4E+53EWl98nNhxS7ZPmmhJ9PfoO4krzYYSVB8451p9h9wOJvomIZx5jh0CNVNJ+aUDsgPS6dwaxSpPsXoKqKEii08PtluguphEnhtRb8JK6Q9sUiIQhUKTwsK/xihKJK5TufKOR+o07ihnToBSa2GC6tGxoeO0ga0bpJJo13ubi9HdSzKYK1RFRhVyYYcb3D+NuUJ1FfUtwPFCebYC/faGQM9f+bbmxFocDFfe8KOnRO+zpC6nAThehpqMhHqO+E5eJ6G6++hSM3KiDdIEep0/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199024)(186009)(1800799009)(2906002)(7416002)(30864003)(38100700002)(6506007)(53546011)(6486002)(83380400001)(5660300002)(26005)(31686004)(86362001)(31696002)(8676002)(2616005)(8936002)(4326008)(316002)(66946007)(6512007)(54906003)(66556008)(66476007)(110136005)(478600001)(6666004)(36756003)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aldFbU5uWXpLdS9kTHZNYmgxRmtoT1pSUGtOUFpVcWcwbElYaTArZXBtVml3?=
 =?utf-8?B?bE9XMDZCNFJNUmFOSjJxYU1rL2pjc1JFU3ZkOEF6ejZ0VlZGSjhWa21ZL3N2?=
 =?utf-8?B?c1Z6RHM3bmpHRnpGK1ZnQVFFKzFBQVdObnFXajl5SWJQR3Zvd1BLQWhVNWNP?=
 =?utf-8?B?VloreGJTUGNpV016SjZHeFN3UGpOVmR3cnFDZjRsWWh5MnFlWGNrNDNvZXo5?=
 =?utf-8?B?ZXRETnNnMlNkZ1pGVVp5VjdqaXBCb3l4Qi9lNkMxdWlTb2oyMGJjUFZROWo3?=
 =?utf-8?B?MWVTYmI4VktNRmcvS0JDNkd1VVVsVm5IQmJQc2NxNXovQThvL2dUVkxsdEdx?=
 =?utf-8?B?L0FadWZQcVlGRnYrYUFXVG9iVEIrYjhOaGlDSGxSL2dYWjBCYlhFdWpBUmxO?=
 =?utf-8?B?R3RFandjTWJWdndXUjVhTUVvTDJLMjlzOXg0OXJRSTBybllIM0VKc1F5eVJJ?=
 =?utf-8?B?Zk80Y1l2UDBhN1ZyNTUzZ1kvdVQ3UnRUZWlwVTRxT1BuQlUvOEs4MFdWMUxz?=
 =?utf-8?B?MmNKRnQxcGVIS1RIR3QxV01FS1JGdkFBTnZZWkJRQ21rQThmRG1zZ200eG1I?=
 =?utf-8?B?SmdWT3orTDErc1IrbGEyZ1NCQ2xBcUIvMk9iS1R2UzVpOFVVVlQ1Q2twSVJo?=
 =?utf-8?B?aXk1QkJqM2M0b3hYYnhWenNHUWNOSURjL2tCbitadWRLRHhVL3ZlM0tocjFS?=
 =?utf-8?B?cTQ5T00vQmxmRVh1NU9wMzdPQUF0dHA0L25CcUV2TFQvdmlMRlZvaTdwNUZz?=
 =?utf-8?B?OUtNTitWNFJXQklxdmpCTi9HUnpPU043SjE5MnJUQmYvaVJRZDdJRDVxNUlE?=
 =?utf-8?B?ckduMG50akkwV01IN3pmU20ydnNxZHk5NzVLWXUxa1oyc1QyTUhqaVlzQkZa?=
 =?utf-8?B?bG9maXFCTXBUaDdzbXMyN01rN3g2aWZhSVNiQkxVWVcySTlWTkMrMXpBc1hp?=
 =?utf-8?B?VS9LNUZDS28xa0tUSFU1UXpzUCtrNjRJMDk4YWZ1OGIwNWx6WmFZUGFXSlNT?=
 =?utf-8?B?TDg2QTVhT0xIVDEzNVR1cHlkRTY0U2NtMmhYNFRTcmFSZkpIRm5oTEJ2eGJu?=
 =?utf-8?B?Nys5cVFpYjJZdHE3dkhrcWNnQklObWp5d2NRTSsvQldzMHNZQmZhck93NzIv?=
 =?utf-8?B?Ujg0U3BQeHBxUzY5bzBUeENQK2V1dmVxRCtsTk8zSWhZNzZyUlp5dWxoeGNi?=
 =?utf-8?B?OHFMQm8xTWNUOXVsdTd0TVFBMmVZZ0dyZFRTalltR2JEbzhJQnlhaTNqTzUy?=
 =?utf-8?B?aXNvU093Kzc3ODhmN0gxUHBsUkoveXRoMTJpZFZpT0VGd3JPZlJCdGlHNkpw?=
 =?utf-8?B?cXEvZzYrOHVPdm84NGI0U25UOURhTFBUcGt6NHRvT3Zla3pQV2hUc2dPdmln?=
 =?utf-8?B?dUM4WHVKZVY4V3hFdG1yZHZmTlplTVF4ZHNzZ1FlNmNBY0ppbUtUenBzRXJH?=
 =?utf-8?B?b0FDZldFUVFkMTk2NzVWamM0MXhlTGtzU0xlMHBpWFptenJNVGFBNHRSekkr?=
 =?utf-8?B?OEZpb1YzbkNSckFoOU96dmxMWnlWMk44dGd5QWhhRnJiT1VhVlh1TEtIL2ti?=
 =?utf-8?B?dyt0UFdOSG5uUlVqcXljWjU1Rkc1QVFXeTdUV3Z6elcxQkZnajNNZzNWeUx6?=
 =?utf-8?B?NjFvSVRPQ0ROR2JQa240RTlMWDNoc1E5K1kxaWowQzdMbFpBbWlidGlCUmo0?=
 =?utf-8?B?bzhmRWxmcHN1NHdEYzNSVS9XL1dpUDNxSVdGbkNGWUp6K05WOERlT3FXbE93?=
 =?utf-8?B?VWpFZm9FZGhQOEltQUg5Z2YxNkVtUnY1UkowOHNSWGswVklrZHpkVy9HOFZE?=
 =?utf-8?B?U1JuYTNpa01leTBFcUxUZjRrWmpRdTBCcSs3NHBLMWdJS3JrOWd6aFlNU2Mz?=
 =?utf-8?B?andwZ21HWmE0VE9YR0p1b3pYSFphRmlaNGxMWGpnaFN6LzZOMHNDdzM1V3Ay?=
 =?utf-8?B?WFVjMGxKc2YvRStyVkc4NnVVd0RPa0pqOE5HQlZWajZ3RWw1eVdZb1JRNklh?=
 =?utf-8?B?LzAwOHVIMDlPRmlTalVXdVRMRjB0bkNITldkVHgrQjR0NHNMRndjdlRuRXVu?=
 =?utf-8?B?MUlOaVVVTFVwZ2MxUzZhbGNobHRPc1FnaVdMd24wbE5vdUtWSEhhSkJiSCtG?=
 =?utf-8?Q?u3KzCCKAvQzF873QvJo3hAiPO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0b85fd-fb1b-482f-adc2-08dba35f7518
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 22:30:58.8941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LNNbggQIeRdjnDVN7GXVA/BYAs3mDMvTIITkIl0DmmDsq1HKiU8qKJxopDErIQ5M4X3JFFyvPYLvLdzNpLm4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7117
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/21/2023 4:44 PM, Kalra, Ashish wrote:
> Hello Mingwei & Sean,
> 
> On 8/18/2023 9:08 PM, Mingwei Zhang wrote:
>> +Jacky Li
>>
>> On Fri, Aug 18, 2023 at 3:45 PM Sean Christopherson 
>> <seanjc@google.com> wrote:
>>>
>>> +Mingwei to correct me if I'm wrong
>>>
>>> On Fri, Aug 18, 2023, Ashish Kalra wrote:
>>>>
>>>> On 8/18/2023 12:55 PM, Sean Christopherson wrote:
>>>>> On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
>>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>
>>>>>> kvm_mmu_invalidate_end() updates struct 
>>>>>> kvm::mmu_invalidate_in_progress
>>>>>> and it's protected by kvm::mmu_lock.  call 
>>>>>> kvm_mmu_invalidate_end() before
>>>>>> unlocking it. Not after the unlock.
>>>>>>
>>>>>> Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")
>>>>>
>>>>> This fixes is wrong.  It won't matter in the long run, but it makes 
>>>>> my life that
>>>>> much harder.
>>>>>
>>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>> ---
>>>>>>    virt/kvm/kvm_main.c | 15 ++++++++++++++-
>>>>>>    1 file changed, 14 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>>> index 8bfeb615fc4d..49380cd62367 100644
>>>>>> --- a/virt/kvm/kvm_main.c
>>>>>> +++ b/virt/kvm/kvm_main.c
>>>>>> @@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
>>>>>>            } arg;
>>>>>>            gfn_handler_t handler;
>>>>>>            on_lock_fn_t on_lock;
>>>>>> + on_unlock_fn_t before_unlock;
>>>>>>            on_unlock_fn_t on_unlock;
>>>>>
>>>>> Ugh, shame on my past me.  Having on_lock and on_unlock be 
>>>>> asymmetrical with respect
>>>>> to the lock is nasty.
>>>>>
>>>>> I would much rather we either (a) be explicit, e.g. before_(un)lock 
>>>>> and after_(un)lock,
>>>>> or (b) have just on_(un)lock, make them symetrical, and handle the 
>>>>> SEV mess a
>>>>> different way.
>>>>>
>>>>> The SEV hook doesn't actually care about running immediately after 
>>>>> unlock, it just
>>>>> wants to know if there was an overlapping memslot.  It can run 
>>>>> after SRCU is dropped,
>>>>> because even if we make the behavior more precise (right now it 
>>>>> blasts WBINVD),
>>>>> just having a reference to memslots isn't sufficient, the code 
>>>>> needs to guarantee
>>>>> memslots are *stable*.  And that is already guaranteed by the 
>>>>> notifier code, i.e.
>>>>> the SEV code could just reacquire SRCU.
>>>>
>>>> On a separate note here, the SEV hook blasting WBINVD is still causing
>>>> serious performance degradation issues with SNP triggered via
>>>> AutoNUMA/numad/KSM, etc. With reference to previous discussions 
>>>> related to
>>>> it, we have plans to replace WBINVD with CLFLUSHOPT.
>>>
>>> Isn't the flush unnecessary when freeing shared memory?  My 
>>> recollection is that
>>> the problematic scenario is when encrypted memory is freed back to 
>>> the host,
>>> because KVM already flushes when potentially encrypted mapping memory 
>>> into the
>>> guest.
>>>
>>> With SNP+guest_memfd, private/encrypted memory should be unreachabled 
>>> via the
>>> hva-based mmu_notifiers.  gmem should have full control of the page 
>>> lifecycles,
>>> i.e. can get the kernel virtual address as appropriated, and so it 
>>> SNP shouldn't
>>> need the nuclear option.
>>>
>>> E.g. something like this?
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 07756b7348ae..1c6828ae391d 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -2328,7 +2328,7 @@ static void sev_flush_encrypted_page(struct 
>>> kvm_vcpu *vcpu, void *va)
>>>
>>>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>>>   {
>>> -       if (!sev_guest(kvm))
>>> +       if (!sev_guest(kvm) || sev_snp_guest(kvm))
>>>                  return;
>>>
>>>          wbinvd_on_all_cpus();
>>
>> I hope this is the final solution :)
>>
>> So, short answer: no.
>>
>> SNP+guest_memfd prevent untrusted host user space from directly
>> modifying the data, this is good enough for CVE-2022-0171, but there
>> is no such guarantee that the host kernel in some scenarios could
>> access the data and generate dirty caches. In fact, AFAIC, SNP VM does
>> not track whether each page is previously shared, isn't it? If a page
>> was previously shared and was written by the host kernel or devices
>> before it was changed to private. No one tracks it and dirty caches
>> are there!
>>
>> So, to avoid any corner case situations like the above, it seems
>> currently we have to retain the property: flushing the cache when the
>> guest memory mapping leaves KVM NPT.
>>
>> Of course, this is fundamentally because SME_COHERENT only applies to
>> CPU cores, but not DMA. If SME_COHERENT is complete, flushing is no
>> longer needed. Alternatively, we need extra bookkeeping for KVM to
>> know whether each page has dirty cache lines. Another alternative is
>> to filter mmu_notifier reasons, which is the part that I am planning
>> to take. thoughts?
>>

Additionally looking at MMU notifier event filtering and the various 
code paths (of interest) from where the MMU invalidation notifier gets 
invoked:

For NUMA load balancing during #PF fault handling, try_to_migrate_one() 
does MMU invalidation notifier invocation with MMU_NOTIFY_CLEAR event 
and then looking at KSM code paths, try_to_merge_one_page() -> 
write_protect_page() and try_to_merge_one_page() -> replace_page() do 
the MMU invalidation notifier invocations also with MMU_NOTIFY_CLEAR event.

Now, i remember from previous discussions, that the CLEAR event is an 
overloaded event used for page zapping, madvise, etc., so i don't think 
we will be able to filter *out* this event and this event is triggering 
most of the performance issues we are observing.

So considering what Sean mentioned earlier:

 >What I'm saying is that for guests whose private memory is backed by 
 >guest_memfd(), which is all SNP guests, it should be impossible for 
 >memory that is reachable via mmu_notifiers to be mapped in KVM's MMU 
as >private.  So yes, KVM needs to flush when memory is freed from 
 >guest_memfd(), but not for memory that is reclaimed by mmu_notifiers, 
i.e. not for sev_guest_memory_reclaimed().

I think the right solution for SNP guests should be:

 >>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
 >>> index 07756b7348ae..1c6828ae391d 100644
 >>> --- a/arch/x86/kvm/svm/sev.c
 >>> +++ b/arch/x86/kvm/svm/sev.c
 >>> @@ -2328,7 +2328,7 @@ static void sev_flush_encrypted_page(struct
 >>> kvm_vcpu *vcpu, void *va)
 >>>
 >>>   void sev_guest_memory_reclaimed(struct kvm *kvm)
 >>>   {
 >>> -       if (!sev_guest(kvm))
 >>> +       if (!sev_guest(kvm) || sev_snp_guest(kvm))
 >>>                  return;
 >>>
 >>>          wbinvd_on_all_cpus();

Thoughts?

Thanks,
Ashish

> 
> Now running SNP+guest_memfd with discard=both option enabled:
> 
> # bpftrace -e 'kprobe:sev_guest_memory_reclaimed {@[kstack]=count()}'
> Attaching 1 probe...
> ^C
> 
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_release+60
>      __mmu_notifier_release+128
>      exit_mmap+657
>      __mmput+72
>      mmput+49
>      do_exit+752
>      do_group_exit+57
>      get_signal+2486
>      arch_do_signal_or_restart+51
>      exit_to_user_mode_prepare+257
>      syscall_exit_to_user_mode+42
>      do_syscall_64+109
>      entry_SYSCALL_64_after_hwframe+114
> ]: 1
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+869
>      __mmu_notifier_invalidate_range_start+152
>      change_protection+4628
>      change_prot_numa+93
>      task_numa_work+588
>      task_work_run+108
>      exit_to_user_mode_prepare+337
>      syscall_exit_to_user_mode+42
>      do_syscall_64+109
>      entry_SYSCALL_64_after_hwframe+114
> ]: 2
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+869
>      __mmu_notifier_invalidate_range_start+152
>      change_protection+4628
>      change_prot_numa+93
>      task_numa_work+588
>      task_work_run+108
>      xfer_to_guest_mode_handle_work+228
>      kvm_arch_vcpu_ioctl_run+1572
>      kvm_vcpu_ioctl+671
>      __x64_sys_ioctl+153
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]: 2
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_set_memslot+740
>      __kvm_set_memory_region.part.0+411
>      kvm_set_memory_region+89
>      kvm_vm_ioctl+1482
>      __x64_sys_ioctl+153
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]: 104
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+869
>      __mmu_notifier_invalidate_range_start+152
>      zap_page_range_single+384
>      unmap_mapping_range+279
>      shmem_fallocate+932
>      vfs_fallocate+345
>      __x64_sys_fallocate+71
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]: 5465
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+869
>      __mmu_notifier_invalidate_range_start+152
>      zap_page_range_single+384
>      madvise_vma_behavior+1967
>      madvise_walk_vmas+190
>      do_madvise.part.0+264
>      __x64_sys_madvise+98
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]: 69677
> 
> The maximum hits are seen with shmem_fallocate and madvise, which we 
> believe are response to shared<->private
> GHCB page-state-chage requests. discard=both handles discard both for
> private and shared memory, so freeing shared memory
> via fallocate(shared_memfd, FALLOC_FL_PUNCH_HOLE, ...) would trigger the
> notifiers when freeing shared pages after guest converts a GPA to
> private.
> 
> Now, as with SNP+guest_memfd, guest private memory is not mapped in host 
> anymore, so i added a generic fix (instead of Sean's proposed patch of 
> checking for SNP guest inside sev_guest_memory_reclaimed()):
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -593,6 +593,9 @@ static __always_inline int 
> __kvm_handle_hva_range(struct kvm *kvm,
>                          unsigned long hva_start, hva_end;
> 
>                          slot = container_of(node, struct 
> kvm_memory_slot, hva_node[slots->node_idx]);
> +                       if (kvm_slot_can_be_private(slot)) {
> +                               continue;
> +                       }
>                          hva_start = max(range->start, 
> slot->userspace_addr);
>                          hva_end = min(range->end, slot->userspace_addr +
>                                                    (slot->npages << 
> PAGE_SHIFT));
> 
> With this fix added, the traces are as follows:
> 
> # bpftrace -e 'kprobe:sev_guest_memory_reclaimed {@[kstack]=count()}'
> Attaching 1 probe...
> ^C
> 
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+812
>      __mmu_notifier_invalidate_range_start+152
>      change_protection+4628
>      change_prot_numa+93
>      task_numa_work+588
>      task_work_run+108
>      exit_to_user_mode_prepare+337
>      syscall_exit_to_user_mode+42
>      do_syscall_64+109
>      entry_SYSCALL_64_after_hwframe+114
> ]: 1
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_release+60
>      __mmu_notifier_release+128
>      exit_mmap+657
>      __mmput+72
>      mmput+49
>      do_exit+752
>      do_group_exit+57
>      get_signal+2486
>      arch_do_signal_or_restart+51
>      exit_to_user_mode_prepare+257
>      syscall_exit_to_user_mode+42
>      do_syscall_64+109
>      entry_SYSCALL_64_after_hwframe+114
> ]: 1
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_mmu_notifier_invalidate_range_start+812
>      __mmu_notifier_invalidate_range_start+152
>      change_protection+4628
>      change_prot_numa+93
>      task_numa_work+588
>      task_work_run+108
>      xfer_to_guest_mode_handle_work+228
>      kvm_arch_vcpu_ioctl_run+1572
>      kvm_vcpu_ioctl+671
>      __x64_sys_ioctl+153
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]:
> @[
>      sev_guest_memory_reclaimed+5
>      kvm_set_memslot+740
>      __kvm_set_memory_region.part.0+411
>      kvm_set_memory_region+89
>      kvm_vm_ioctl+1482
>      __x64_sys_ioctl+153
>      do_syscall_64+96
>      entry_SYSCALL_64_after_hwframe+114
> ]: 104
> #
> 
> As expected, the SEV hook is not invoked for the guest private memory 
> pages (no more invalidation from shmem_fallocate() + madvise()).
> 
> Isn't it better to skip invoking the KVM MMU invalidation notifier when 
> the invalidated range belongs to guest private memory ?
> 
>  > In fact, AFAIC, SNP VM does
>  > not track whether each page is previously shared, isn't it? If a page
>  > was previously shared and was written by the host kernel or devices
>  > before it was changed to private. No one tracks it and dirty caches
>  > are there!
> 
> The skipped invalidation here covered the case Mingwei mentioned above, 
> where the pages are changed from private->shared and subsequent freeing 
> of shared pages triggered the invalidation.
> 
> But, then why are we concerned about this, i thought we have concerns 
> about the case where the dirty cache lines contain encrypted guest data ?
> 
> Thanks,
> Ashish
