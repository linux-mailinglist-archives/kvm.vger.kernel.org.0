Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A708024A3E4
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHSQU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 12:20:59 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:12769
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbgHSQU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 12:20:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnR+I8Lv2WT2xaeRi+Y5EkOjEkfby3YotIe4KBnl+CVvszAUq6q37iju6ftDzbdG6q72tN/x/e31RyBU7WdwvwHzAkEEH9FR5UhWtNiG8z3WDi+/YKHkQx7EYu9nMU2d0xKkSrjySyPrkDA/0U9+AoDuO1gWtqX9nvNVgt17T8fH22M0Q8Qza8vX8Qi2Nu8KZJXJsRJSbVtPNXgHfcJwB6xFc/6ELbLAfFpPxO5yswaR3qK0Auk/A/IYj63TV2cwmevW2g5Q1BANmdid7+8GABlxtOOZVJv+jmOf/CKfZCNRnm0o5Xf05tBGOdwyLLCi69+o9EII7JjtfMkhck+86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsrU8T7B6qxVXfkO6+MWkCQ1BuJ5pvpE5PdnmEjAhRU=;
 b=BH3sZrhZFGoGWKiB0+plzWSysc+7w0tK+Nsuv7fRtJwvzzsjyFDqrX5HjT5NL+selc6b04KvKYSzeACaFaGXNemIQ3VniB9Mca5SeU4ppjQ+CXxKANFA4uCXGMkumu8nu34KkoZJRZcX4pDLC/3fUhNLEfeaDklD0dOlrBeq0oN64asO7TrvIRHm/6JQzsUuXh/aOFtK3+UXAgcKzEoZNDNbjz+e3Vs1uTCKrK3XaSlyFrX/k138i4MayO/6oG9YAVl4b1ztKqhlwdx8QEx0oywXzWYaQpu5bb4fEKIK4xkmvx2in84G8AeaZT70CWe7Ek0jX5tXZCVyjZ0RnbDsDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsrU8T7B6qxVXfkO6+MWkCQ1BuJ5pvpE5PdnmEjAhRU=;
 b=LR72i7k2nNYOcI90gPc6CP9ee6xPXalT8WVGj42qkxZdvfM732i3VC5r/hA/mPdV4lJWyJ4gzmWKdw5Io/+VCoExc+/sv2CjwPoK7BtxJnLoSim5WhLTB/Zwlb6vQoDTuTfhoGDJ+kwh/5FEujTCrT7qDcTkq2c4D60XfTQMp+A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3612.namprd12.prod.outlook.com (2603:10b6:5:11b::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.15; Wed, 19 Aug 2020 16:20:53 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 16:20:53 +0000
Subject: Re: [Patch 3/4] KVM:SVM: Pin sev_launch_update_data() pages via
 sev_get_page()
From:   Eric van Tassell <evantass@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        eric van tassell <Eric.VanTassell@amd.com>
Cc:     kvm@vger.kernel.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-4-Eric.VanTassell@amd.com>
 <20200731204028.GH31451@linux.intel.com>
 <bd9f4790-66d0-7ca8-4aed-5349e765991f@amd.com>
Message-ID: <2770f023-c243-5467-217a-632ec57f4213@amd.com>
Date:   Wed, 19 Aug 2020 11:20:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <bd9f4790-66d0-7ca8-4aed-5349e765991f@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.128.53] (165.204.78.25) by SN1PR12CA0057.namprd12.prod.outlook.com (2603:10b6:802:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 16:20:50 +0000
X-Originating-IP: [165.204.78.25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c70181a3-30f8-4c8b-d48f-08d8445bd818
X-MS-TrafficTypeDiagnostic: DM6PR12MB3612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB361223AC1F88438D1D20140EE75D0@DM6PR12MB3612.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFGFhOyaXua0Khsf5FmPbqNXPw5gp5QrwemJqlg+f/YuJHL2zLVNe6XY+OmfOUXjXm1H36iN+9UuEHjOGpBLPoY+Jh65kl/r96HjwzA6Yts1zFwiTV2+fmBKRpZfiNTyKAplHsIzMxtps0wVKOU9Ug0ALJ+/hu+6BTr5HQUR+7lAonNQ6Im20KJkpKTNGqK1/yv4X7+IWx4umvH+5+wYWG9/BBViytILM51Oir4QoA0PhKzER9K+MiLI7B0i0RhpbSOWEmI/N2fBzMnHYT/AN4Jna2cIaz7pre9iZhr4Y92dIGlGXrG6OSqOLeu/eFUUEPi8MEJmUmBDk8jibVwAy/DbWf7SSZTqUGE+djajnnGrulTfX98kKJdFY6wOfn19
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(16576012)(66556008)(66946007)(7416002)(31696002)(66476007)(6486002)(110136005)(36756003)(956004)(31686004)(316002)(2616005)(83380400001)(478600001)(8676002)(6636002)(8936002)(2906002)(5660300002)(26005)(52116002)(16526019)(186003)(53546011)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nyWUhqyRof7g2CRxYpEN90vNwv+XknYg1FSRBepA+yB51oRLSs1mMlM1+UNpizcu+fTL0HRcVwwOxXTMpFn2Mlar5bg5mBO3QxhE6hXyfeuBpkzL1EISxL8B+UD52PyhcAjwiMXV6nT+9GuKtXRh5edJLT+jky5N1O/70Aw603dHVrvzKeFre2Yo0h74GUQyRpAmfYcHxZZGf62GrMhasgjFaXi1Tyr88n7M1kx50ArZnriNexGGCMCEyStLmCLOBIc6gXe17AQuVR0Ik8KWFLzo7yA66zV+bsOEby2iZIqHdCtxwq4QRDaDsZHkXX83ej7c0G2FLlPGrjuSnAgLN+Q25MdAL5+1OHP5GuFWeQpZ+C4Us545Lguzcb/pDcQRSwnH3/vDrdoUDgCZdRfHzMSOxER0KpkuyMBfTCK3T13nThOcTryOyt/B/n5g/7Ht9kZLAgiYCOKMCc3icdgAqtivFFPKEYxQmEaq7D+wHfCyJi9UK1O84JLFFzZSeNfkOqCmJJjaWiB6bfRz5Q+8JeZX7nXuJ2ON5k8rlq8lECnYigxKsvp1BNQ/YVBHYz30aziPnJprO68wsojgYEtvLX50W0Xwx3w6aPUx8OMrTr9z5q4DlrAtccYp121UNPGV3C+Uts9h1faJKr+hTNAVEw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70181a3-30f8-4c8b-d48f-08d8445bd818
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:20:53.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdoeJFvxVBbrXBO91FOr3pwp/hVXeTIBWk1w71OaFFYwDUdz82pBEe6tDVqWwWyjX69iS6foulzPmoD6GrSnYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3612
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/2/20 6:55 PM, Eric van Tassell wrote:
> 
> 
> On 7/31/20 3:40 PM, Sean Christopherson wrote:
>> On Fri, Jul 24, 2020 at 06:54:47PM -0500, eric van tassell wrote:
>>> Add 2 small infrastructure functions here which to enable pinning the 
>>> SEV
>>> guest pages used for sev_launch_update_data() using sev_get_page().
>>>
>>> Pin the memory for the data being passed to launch_update_data() 
>>> because it
>>> gets encrypted before the guest is first run and must not be moved which
>>> would corrupt it.
>>>
>>> Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 48 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 040ae4aa7c5a..e0eed9a20a51 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -453,6 +453,37 @@ static int sev_get_page(struct kvm *kvm, gfn_t 
>>> gfn, kvm_pfn_t pfn)
>>>       return 0;
>>>   }
>>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>>> +                          unsigned long hva)
>>> +{
>>> +    struct kvm_memslots *slots = kvm_memslots(kvm);
>>> +    struct kvm_memory_slot *memslot;
>>> +
>>> +    kvm_for_each_memslot(memslot, slots) {
>>> +        if (hva >= memslot->userspace_addr &&
>>> +            hva < memslot->userspace_addr +
>>> +                  (memslot->npages << PAGE_SHIFT))
>>> +            return memslot;
>>> +    }
>>> +
>>> +    return NULL;
>>> +}
>>> +
>>> +static bool hva_to_gfn(struct kvm *kvm, unsigned long hva, gfn_t *gfn)
>>> +{
>>> +    struct kvm_memory_slot *memslot;
>>> +    gpa_t gpa_offset;
>>> +
>>> +    memslot = hva_to_memslot(kvm, hva);
>>> +    if (!memslot)
>>> +        return false;
>>> +
>>> +    gpa_offset = hva - memslot->userspace_addr;
>>> +    *gfn = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset) >> 
>>> PAGE_SHIFT;
>>> +
>>> +    return true;
>>> +}
>>> +
>>>   static int sev_launch_update_data(struct kvm *kvm, struct 
>>> kvm_sev_cmd *argp)
>>>   {
>>>       unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, 
>>> size, i;
>>> @@ -483,6 +514,23 @@ static int sev_launch_update_data(struct kvm 
>>> *kvm, struct kvm_sev_cmd *argp)
>>>           goto e_free;
>>>       }
>>> +    /*
>>> +     * Increment the page ref count so that the pages do not get 
>>> migrated or
>>> +     * moved after we are done from the LAUNCH_UPDATE_DATA.
>>> +     */
>>> +    for (i = 0; i < npages; i++) {
>>> +        gfn_t gfn;
>>> +
>>> +        if (!hva_to_gfn(kvm, (vaddr + (i * PAGE_SIZE)) & PAGE_MASK, 
>>> &gfn)) {
>>
>> This needs to hold kvm->srcu to block changes to memslots while 
>> looking up
>> the hva->gpa translation.
> I'll look into this.

fixed

>>
>>> +            ret = -EFAULT;
>>> +            goto e_unpin;
>>> +        }
>>> +
>>> +        ret = sev_get_page(kvm, gfn, page_to_pfn(inpages[i]));
>>
>> Rather than dump everything into an xarray, KVM can instead pin the pages
>> by faulting them into its MMU.  By pinning pages in the MMU proper, 
>> KVM can
>> use software available bits in the SPTEs to track which pages are pinned,
>> can assert/WARN on unexpected behavior with respect to pinned pages, and
>> can drop/unpin pages as soon as they are no longer reachable from KVM, 
>> e.g.
>> when the mm_struct dies or the associated memslot is removed.
>>
>> Leveraging the MMU would also make this extensible to non-SEV features,
>> e.g. it can be shared by VMX if VMX adds a feature that needs similar 
>> hooks
>> in the MMU.  Shoving the tracking in SEV means the core logic would 
>> need to
>> be duplicated for other features.
>>
>> The big caveat is that funneling this through the MMU requires a vCPU[*],
>> i.e. is only viable if userspace has already created at least one vCPU.
>> For QEMU, this is guaranteed.  I don't know about other VMMs.
>>
>> If there are VMMs that support SEV and don't create vCPUs before 
>> encrypting
>> guest memory, one option would be to automatically go down the optimized
>> route iff at least one vCPU has been created.  In other words, don't 
>> break
>> old VMMs, but don't carry more hacks to make them faster either.
>>
>> It just so happens that I have some code that sort of implements the 
>> above.
>> I reworked it to mesh with SEV and will post it as an RFC.  It's far from
>> a tested-and-ready-to-roll implemenation, but I think it's fleshed out
>> enough to start a conversation.
>>
>> [*] This isn't a hard requirement, i.e. KVM could be reworked to 
>> provide a
>>      common MMU for non-nested TDP, but that's a much bigger effort.
>>
> I will think about this. (I'm out of the office Monday and Tuesday.)

Brijesh invested time and could not get this approach to meet SEV's 
needs as he reported in a previous email.

>>> +        if (ret)
>>> +            goto e_unpin;
>>> +    }
>>> +
>>>       /*
>>>        * The LAUNCH_UPDATE command will perform in-place encryption 
>>> of the
>>>        * memory content (i.e it will write the same memory region 
>>> with C=1).
>>> -- 
>>> 2.17.1
>>>
