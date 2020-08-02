Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2751C239C09
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHBUyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 16:54:06 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:51872
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbgHBUyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 16:54:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBvAB+0fHA0ZHfQ2Ap2mV/hRpiF4NaZel3gAkvHy9IVirkjzKLMtvxyp3RIaLmNs0Z5pESCNMd1i4oCzHs4dd0/VsZBVmJW8dCV0pFsBE2aJ6lx7cP+SLyQQSLcqXCWpBWWxMPA/j2RvwSjddmM8Z/UBwK+9nEEszNggBzOIJ1p9zi+WWx38pMxwElvizCcCQoirKi/2/Be6hyvs+OunDsj/iYT3tcb/QB+WIk56hTxYYfEySGOLkUvZ3uLJe4m8wGVn0DwcgdTlbZiJdQdGmJSqGHstsVukLt4PXdFbKm+8GMzeWBvRT8FufNYa0mkdDwSPZl48U21MCuF1CTnprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFBTqygAG4R5sRs5LCLysJmxDmarxB830TnftzUa81E=;
 b=XI0Qiyn5y9+6pqs2OcsYHAa1rhGfEJeRDDL0l1tL4diSCc+aeRYh0pADdiMXi7YsUgYVHZy1poo8+aUVR+pXwRiiH7DoeJ8xorWVrIap/Dn4ubSvXkZ+LYVZLXcOYIdgydDkYye/h/+t4pRfVVKSwwIDz0u/mzS0aN6BZGWTX1mnovm2umQyBkhmFxSp4vTx8uq8L4xix/EeFJl0x18M8SVKeIweRWT/ggImXfyz98IBnTvvOO78OUvlJdXtOag+zbQzBEd8Goy3paKn7jC00766+KIqL3jySShFI3PgxqT5/IIgHvJ7MSNGQKyDnsHan6oi582iQbFzu2yjW55+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFBTqygAG4R5sRs5LCLysJmxDmarxB830TnftzUa81E=;
 b=l17fj3/u7XVwmUqkien7TMiLjOleBeITdMoLkANqzuiBghtd9nmwZibWBkJPH6fGTSDUVQLUZ7//vmppNwLi2cqIObtT+G0U9xoa1jQ8FPrkMdiScrsUsaj4oKCUKvMzenppVlMjTmdEA1q7NPoc/j+yXHsp9KZi0w8EH8xNsg0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM5PR12MB2565.namprd12.prod.outlook.com (2603:10b6:4:b8::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.21; Sun, 2 Aug 2020 20:54:00 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3239.021; Sun, 2 Aug 2020
 20:53:59 +0000
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <Brijesh.Singh@amd.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Cc:     kvm@vger.kernel.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
 <20200731202502.GG31451@linux.intel.com>
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
Date:   Sun, 2 Aug 2020 15:53:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200731202502.GG31451@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0043.namprd02.prod.outlook.com
 (2603:10b6:803:2e::29) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.16.211] (165.204.77.11) by SN4PR0201CA0043.namprd02.prod.outlook.com (2603:10b6:803:2e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Sun, 2 Aug 2020 20:53:57 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 278b7c33-b007-462a-74f4-08d837262e07
X-MS-TrafficTypeDiagnostic: DM5PR12MB2565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2565C0660CD899A9426568A2E74C0@DM5PR12MB2565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y75fGrFl0UmsgJjVGyhaymVMi+elQIYxhd3zRyt4UpqfMwMIjPIg/9mku/esfRBgnfuKc3NI441TPlp1hxRcZARpsoedPsdGWN8nqDZFrQoGDalFa39505jjwTXwLvN8T9EWWI434P26F23waLQZdf8WHwCwCM75YhAjMfAR+uFHilD5hO0tjfyTV/knq+r91QQ7U2AGO5cIWmjtJ1NZ6o145ngd/wBfARpxETlNHDRTnt1q+MXC3LpcgBTquMm3fxShJ3km8YwqBYmj29lST8+CZDYdSM2+Q8UtsRHyrEAxZsjeO3zHXhr5iq28Un/dvPMjIdFwsCV1PhSAtNx+df8mo2np5111p7jqG3LQrRUy03BjkC0PgkwyxM6nTr0P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(31696002)(26005)(8936002)(53546011)(4326008)(6636002)(6666004)(956004)(8676002)(2616005)(478600001)(16526019)(186003)(83380400001)(31686004)(6486002)(316002)(52116002)(110136005)(16576012)(5660300002)(66946007)(66476007)(66556008)(36756003)(2906002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t/X7m8M8cQjgpGuLm5dKdyY+z3b2SbmhmiFGUsTX42dNd7FBCIWVOfXWxNjojKPMMXlWYYz+g8kzfqMKSiBH5NovffwSO4y+0vyEpvcV0d5FVRJxVwIbyky9o2Kg2oSnZYnQ09niQcd7kmsRHlEJjPoPWKUASOco0gydNiRGG70JgfhE90NOXgf0uGpt2dRBOe2arpxWUAcKkDtfbYNzP6+Yhhszp65BKcnl9wyAI3NCk4DiQmPUuq/X7/Sq6EVak5UT64VJxlL6/IwwkSekpI4jxGZgAet7mcgNI786VBaJUKvYvMbSnaLGVvmx48EeqR+DYPxiR8WFT/VnhJdkMMNXDNPK4qnTeM/sQvn9p43jczmB4yLKUBl183JjFUuVgs+0jZd5N6+VqfHj8d3JWPe+mPauwdTpIwNGmKCLPCMeCUofaI8vlEx5Tl5at73R2jwXM1DFNhENXIoeKBHV1DFTrDMijXHV9DxXs7RLz/IEmX7ziJixbsgCLn7yHrDZphuRDG2hu9RBl/ygrz+Ql7iVI/3FPEhA4aCNhp8nBRA6d3ieoEz3NawnuZ0npBWW43X4ZUSlM/wnY6b20CyGi5DahM/xn9TVLDECMuTv0QZVfOO82tuLJ8qlWLz1nM6fQTxBS6D/XAztU08ubbIfYw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 278b7c33-b007-462a-74f4-08d837262e07
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2020 20:53:59.6819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hlCgFwTCmPY1Nn5g3bQCzJU+1B9zW96/27WSsRunksX45WDBB+btOlvrn/R5PTnpI76c3sw3RWB6qUBuU8jV9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2565
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/31/20 3:25 PM, Sean Christopherson wrote:
> On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
>> Improve SEV guest startup time from O(n) to a constant by deferring
>> guest page pinning until the pages are used to satisfy nested page faults.
>>
>> Implement the code to do the pinning (sev_get_page) and the notifier
>> sev_set_spte_notify().
>>
>> Track the pinned pages with xarray so they can be released during guest
>> termination.
> 
> I like that SEV is trying to be a better citizen, but this is trading one
> hack for another.
> 
>    - KVM goes through a lot of effort to ensure page faults don't need to
>      allocate memory, and this throws all that effort out the window.
> 
can you elaborate on that?
>    - Tracking all gfns in a separate database (from the MMU) is wasteful.
> 
>    - Having to wait to free pinned memory until the VM is destroyed is less
>      than ideal.
> 
> More thoughts in the next patch.
> 
>> Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 71 ++++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/svm/svm.c |  2 ++
>>   arch/x86/kvm/svm/svm.h |  3 ++
>>   3 files changed, 76 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index f7f1f4ecf08e..040ae4aa7c5a 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -184,6 +184,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	sev->asid = asid;
>>   	INIT_LIST_HEAD(&sev->regions_list);
>>   
>> +	xa_init(&sev->pages_xarray);
>> +
>>   	return 0;
>>   
>>   e_free:
>> @@ -415,6 +417,42 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>   	return pages;
>>   }
>>   
>> +static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct xarray *xa = &sev->pages_xarray;
>> +	struct page *page = pfn_to_page(pfn);
>> +	int ret;
>> +
>> +	/* store page at index = gfn */
>> +	ret = xa_insert(xa, gfn, page, GFP_ATOMIC);
>> +	if (ret == -EBUSY) {
>> +		/*
>> +		 * If xa_insert returned -EBUSY, the  gfn was already associated
>> +		 * with a struct page *.
>> +		 */
>> +		struct page *cur_page;
>> +
>> +		cur_page = xa_load(xa, gfn);
>> +		/* If cur_page == page, no change is needed, so return 0 */
>> +		if (cur_page == page)
>> +			return 0;
>> +
>> +		/* Release the page that was stored at index = gfn */
>> +		put_page(cur_page);
>> +
>> +		/* Return result of attempting to store page at index = gfn */
>> +		ret = xa_err(xa_store(xa, gfn, page, GFP_ATOMIC));
>> +	}
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	get_page(page);
>> +
>> +	return 0;
>> +}
>> +
>>   static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>>   	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
>> @@ -1085,6 +1123,8 @@ void sev_vm_destroy(struct kvm *kvm)
>>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>   	struct list_head *head = &sev->regions_list;
>>   	struct list_head *pos, *q;
>> +	XA_STATE(xas, &sev->pages_xarray, 0);
>> +	struct page *xa_page;
>>   
>>   	if (!sev_guest(kvm))
>>   		return;
>> @@ -1109,6 +1149,12 @@ void sev_vm_destroy(struct kvm *kvm)
>>   		}
>>   	}
>>   
>> +	/* Release each pinned page that SEV tracked in sev->pages_xarray. */
>> +	xas_for_each(&xas, xa_page, ULONG_MAX) {
>> +		put_page(xa_page);
>> +	}
>> +	xa_destroy(&sev->pages_xarray);
>> +
>>   	mutex_unlock(&kvm->lock);
>>   
>>   	sev_unbind_asid(kvm, sev->handle);
>> @@ -1193,3 +1239,28 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>>   	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>>   	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>>   }
>> +
>> +int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
>> +			int level, bool mmio, u64 *spte)
>> +{
>> +	int rc;
>> +
>> +	if (!sev_guest(vcpu->kvm))
>> +		return 0;
>> +
>> +	/* MMIO page contains the unencrypted data, no need to lock this page */
>> +	if (mmio)
> 
> Rather than make this a generic set_spte() notify hook, I think it makes
> more sense to specifying have it be a "pin_spte" style hook.  That way the
> caller can skip mmio PFNs as well as flows that can't possibly be relevant
> to SEV, e.g. the sync_page() flow.
Not sure i understand. We do ignore mmio here. Can you detail a bit more 
what you see as problematic with the sync_page() flow?
> 
>> +		return 0;
>> +
>> +	rc = sev_get_page(vcpu->kvm, gfn, pfn);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/*
>> +	 * Flush any cached lines of the page being added since "ownership" of
>> +	 * it will be transferred from the host to an encrypted guest.
>> +	 */
>> +	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
>> +
>> +	return 0;
>> +}
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 535ad311ad02..9b304c761a99 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4130,6 +4130,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>   	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>>   
>>   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>> +
>> +	.set_spte_notify = sev_set_spte_notify,
>>   };
>>   
>>   static struct kvm_x86_init_ops svm_init_ops __initdata = {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 121b198b51e9..8a5c01516c89 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>>   	int fd;			/* SEV device fd */
>>   	unsigned long pages_locked; /* Number of pages locked */
>>   	struct list_head regions_list;  /* List of registered regions */
>> +	struct xarray pages_xarray; /* List of PFN locked */
>>   };
>>   
>>   struct kvm_svm {
>> @@ -488,5 +489,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>   void pre_sev_run(struct vcpu_svm *svm, int cpu);
>>   int __init sev_hardware_setup(void);
>>   void sev_hardware_teardown(void);
>> +int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
>> +			int level, bool mmio, u64 *spte);
>>   
>>   #endif
>> -- 
>> 2.17.1
>>
