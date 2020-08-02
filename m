Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1031239D02
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 01:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgHBXzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 19:55:15 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:17760
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbgHBXzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 19:55:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JX4SFtOpiJEYAhZFWV+fWQWDLwvtvWrClvb76sU/HGyotZqkzXz/j15lwB28n5CfpptoJmXCvwhAn1+ouVaPOhgyWf6Wx22Tn09eSRuACZfrU82xsTaZnfy3pKU5YhLSBm3cVcm0hcgeaO1lQR9ihgpoybzYKSxL3t+QFk1jGNCs/p9rcfF6raukPipz94qOlFTBoXuPdedt82d+4BwEfM2D4VSOYhBTm/c3hsIuN2cQ2SsR1KQRYdFWRypuahAovLo8yTJXE1Pe9n73+0vyBdyYTdX17AUp02ZGb/WHjZki99frObWFsXmWeNFdF5+vw0N60SUchsBMUAq/6uKhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBn9muAuukgu0RPBuZwDISW6bVlrJZy0XWsEeUyY0+g=;
 b=bPNMizMZCslPTnT1GpqARgq62i3tclsoU4OMCh7AWH516gxssFkrUCtz1Aj8nkX2OOJzdVl3crfSEwoh5IWkxMoB6iTCmD//eiFUQoFEOnPhK4kvX+httFpcgeSniwzfdfyKrS5bNJk8W5JnsU9V4BosfiWXYlqnFvNWTKaPEcaUI0s4lw7YPWC1jki1Mn3+9MYr1K1oyLKPfZTeqbgS4AqMz941vqFKwEvBAp7NdCXQdFvW7G8Au5GzAckmhqV2yQ9w7dD06cMUq0YCy/BuEI9zjFs+N1BnwvEGeRTTKCtuNdsolBYUOVZSc9ik2Bk6ACDK/wZTHn+Gc30smHpQfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBn9muAuukgu0RPBuZwDISW6bVlrJZy0XWsEeUyY0+g=;
 b=iFeDnCKBqek7sXf33fAnQOoAH9M9pRKPHXrsAhFnTApOSmESjBUJmuBHFizNz5hszRz4MzTSd+07wDAzOtQ5qRGuKpNU0bnAFzMbuBeS22m400R987D5zyUYe7VdTQzisl2d2Gl4+Ca+tEJ6jyrzxLbWhKOK2ZwYEgelK2aO/Zc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM5PR12MB1626.namprd12.prod.outlook.com (2603:10b6:4:d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.16; Sun, 2 Aug 2020 23:55:10 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3239.021; Sun, 2 Aug 2020
 23:55:10 +0000
Subject: Re: [Patch 3/4] KVM:SVM: Pin sev_launch_update_data() pages via
 sev_get_page()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        eric van tassell <Eric.VanTassell@amd.com>
Cc:     kvm@vger.kernel.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-4-Eric.VanTassell@amd.com>
 <20200731204028.GH31451@linux.intel.com>
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <bd9f4790-66d0-7ca8-4aed-5349e765991f@amd.com>
Date:   Sun, 2 Aug 2020 18:55:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200731204028.GH31451@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.16.211] (165.204.77.11) by SA0PR11CA0082.namprd11.prod.outlook.com (2603:10b6:806:d2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Sun, 2 Aug 2020 23:55:07 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 490d0483-0da0-4d60-af60-08d8373f7d57
X-MS-TrafficTypeDiagnostic: DM5PR12MB1626:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1626B2C6276382031A743D9AE74C0@DM5PR12MB1626.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19eK/tNkz/ZgKgqAWuc/TS/vqtmr1xUIQeCQU4k+OK69gZ728LRKU3UtmyE2ri0lFL8eSJVCx2c45N66r5dflQmx3CG8FtrgslpN4GmfAhlvRS+pi5hMlYgvwtAsuHU4XaW1nG761dppKjg9AXCbQaNnn5uqoJvRjIYvB9e+UoQQW9DsdYlCMD3/q5e8Z7UZMpCaAbdFr80L501UjnmuLLH6Y3HSvlawmPOpTkSiJCtR6c5Da7lrP8icQC9jON1Nc5O28DPQLJq01ASNtygJm1J85qg82my2UEKu16O4cuRW1XymyIR4eq/CaG6q0ecbJWsBiMNep18mmVyuUJII5Ft9FFYQOVNIajF1egW5Lbml5UyYFZMwDIbc2sZaz8gQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(26005)(478600001)(316002)(83380400001)(36756003)(2906002)(6486002)(53546011)(2616005)(956004)(4326008)(52116002)(6636002)(7416002)(8936002)(110136005)(31696002)(8676002)(186003)(16526019)(66556008)(66946007)(16576012)(5660300002)(31686004)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: och9RaaojIH7/QTSvK9MY124gYMfnH6BlwPPEMXqiWdgQ02Y3nc1QtLdUtNWWCSFCCP2bsVTArvKpQxu9kZ/urLzLp1pJdPufYoAF/rSZzwAwDZ6/SN6QhLninhLz+19L0zbM1p7rP8E024VRwGUGmrDgVsoZcJ2Tlrn02YfpXZZbi8wx75xqqAJorWqbcSGWvk9798BKZNR+2nmxMj9//ODBSyvDm4vZnJfSijYmU5L/FYm81EZ19UjdnuJeKxhh+/NMPnbWOOCH6brT/JD5OI7wF9QMqsMD09DEX2gSnPcDhEuH9VHdEYRUQ8o8BFIeqZvQGUNV5X6E3D/DH1C53kDfnrkhUvlXhOazfnsswTiVYAoKPfQ9iodnMdD74L5bZsfgY/uMWf9YsROteXZ1LF5MgLuVLoc00QbtRpRQRS/vZehk1H6BMHJqwwesvCROG13Ec4i1s4XSlEZUtiKGTE/WqpRw7Bv/YPBgJZcSbz5Uhd/P9R8yEGzW/T7aPj5xbQI5ppm/S4qkleKjRiPlC+KwV9gMLRMETWIS7caORxSUGusCAxpZDQ/I+kOR2LgJE5rEgwVtmV4julLkZGWN8/wnxxeFdyRZ2DboA2yF5s4oifIFMgxhwtxWKvCuW4cxZBFAbD9FQAbAlWz5xRg7A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490d0483-0da0-4d60-af60-08d8373f7d57
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2020 23:55:10.1709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/Im5R7tJ8ZYBA/9n6giVZ3FaoVrqHwBAJxrExHG2DE782RNYVUMfTDoHB5wVr8au6Shw+tCV+jWeRe30WjKhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1626
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/31/20 3:40 PM, Sean Christopherson wrote:
> On Fri, Jul 24, 2020 at 06:54:47PM -0500, eric van tassell wrote:
>> Add 2 small infrastructure functions here which to enable pinning the SEV
>> guest pages used for sev_launch_update_data() using sev_get_page().
>>
>> Pin the memory for the data being passed to launch_update_data() because it
>> gets encrypted before the guest is first run and must not be moved which
>> would corrupt it.
>>
>> Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 48 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 040ae4aa7c5a..e0eed9a20a51 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -453,6 +453,37 @@ static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>   	return 0;
>>   }
>>   
>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>> +					      unsigned long hva)
>> +{
>> +	struct kvm_memslots *slots = kvm_memslots(kvm);
>> +	struct kvm_memory_slot *memslot;
>> +
>> +	kvm_for_each_memslot(memslot, slots) {
>> +		if (hva >= memslot->userspace_addr &&
>> +		    hva < memslot->userspace_addr +
>> +			      (memslot->npages << PAGE_SHIFT))
>> +			return memslot;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static bool hva_to_gfn(struct kvm *kvm, unsigned long hva, gfn_t *gfn)
>> +{
>> +	struct kvm_memory_slot *memslot;
>> +	gpa_t gpa_offset;
>> +
>> +	memslot = hva_to_memslot(kvm, hva);
>> +	if (!memslot)
>> +		return false;
>> +
>> +	gpa_offset = hva - memslot->userspace_addr;
>> +	*gfn = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset) >> PAGE_SHIFT;
>> +
>> +	return true;
>> +}
>> +
>>   static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>>   	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
>> @@ -483,6 +514,23 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   		goto e_free;
>>   	}
>>   
>> +	/*
>> +	 * Increment the page ref count so that the pages do not get migrated or
>> +	 * moved after we are done from the LAUNCH_UPDATE_DATA.
>> +	 */
>> +	for (i = 0; i < npages; i++) {
>> +		gfn_t gfn;
>> +
>> +		if (!hva_to_gfn(kvm, (vaddr + (i * PAGE_SIZE)) & PAGE_MASK, &gfn)) {
> 
> This needs to hold kvm->srcu to block changes to memslots while looking up
> the hva->gpa translation.
I'll look into this.
> 
>> +			ret = -EFAULT;
>> +			goto e_unpin;
>> +		}
>> +
>> +		ret = sev_get_page(kvm, gfn, page_to_pfn(inpages[i]));
> 
> Rather than dump everything into an xarray, KVM can instead pin the pages
> by faulting them into its MMU.  By pinning pages in the MMU proper, KVM can
> use software available bits in the SPTEs to track which pages are pinned,
> can assert/WARN on unexpected behavior with respect to pinned pages, and
> can drop/unpin pages as soon as they are no longer reachable from KVM, e.g.
> when the mm_struct dies or the associated memslot is removed.
> 
> Leveraging the MMU would also make this extensible to non-SEV features,
> e.g. it can be shared by VMX if VMX adds a feature that needs similar hooks
> in the MMU.  Shoving the tracking in SEV means the core logic would need to
> be duplicated for other features.
> 
> The big caveat is that funneling this through the MMU requires a vCPU[*],
> i.e. is only viable if userspace has already created at least one vCPU.
> For QEMU, this is guaranteed.  I don't know about other VMMs.
> 
> If there are VMMs that support SEV and don't create vCPUs before encrypting
> guest memory, one option would be to automatically go down the optimized
> route iff at least one vCPU has been created.  In other words, don't break
> old VMMs, but don't carry more hacks to make them faster either.
> 
> It just so happens that I have some code that sort of implements the above.
> I reworked it to mesh with SEV and will post it as an RFC.  It's far from
> a tested-and-ready-to-roll implemenation, but I think it's fleshed out
> enough to start a conversation.
> 
> [*] This isn't a hard requirement, i.e. KVM could be reworked to provide a
>      common MMU for non-nested TDP, but that's a much bigger effort.
> 
I will think about this. (I'm out of the office Monday and Tuesday.)
>> +		if (ret)
>> +			goto e_unpin;
>> +	}
>> +
>>   	/*
>>   	 * The LAUNCH_UPDATE command will perform in-place encryption of the
>>   	 * memory content (i.e it will write the same memory region with C=1).
>> -- 
>> 2.17.1
>>
