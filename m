Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C35161C7E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 21:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgBQUzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 15:55:41 -0500
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:6180
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729782AbgBQUzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 15:55:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vrhts3qGeTThW1pwSL1EFBRmM18ues8ZrAL5YQL1Lk0xSEooEDNEnk9oi6I4iW85UEc3h7WWarMhcK9TNJgOp3trtnjRDf2/PD3FBQoOCxMTiaOghkpka2rLM1R8iCtaFTC1fDqn1bqoq8d+kkLTAtquO/AJdsfB1vR2vFj3qhdFWD84tsQP477oe+lzrXeL0n/S7MTef8Ho5cONmtOi7wokolqRTluIQpXT1HU8qgbVO4xXUxPuC5yhf17m1L8216xO226GUNTRbCkN5JTUQ2p30EbvzMTGMc6toF7MDFXnRdAffZcF7JG4L1LL5iVFR7qVrQRmhOD7izteShxsOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRqhs5i/Ncu2yedapHw9mAjTF7zo0/lIsTveoKsgK20=;
 b=UU8l2xiMeMOLsrzyz+vfKyvjiqHI2cDenlzaMidSuViud/0hfozBg6WuQCddvOgQiIvPgSGu6YMsI9wRrBH5NyfPmC1vhScRO5qvpU6/8jOQOwAvTscBBUSQ4WBQygDBH02S+blBsRC6Y0csU/+npkVukCQZ0xbFkHRP800Io1w2jWEtAR8Rl7uF2YhsL0p8EOFVPjXsf2ovlCfXXdn3ihJs3zdZZW/7wLCZt1TJD5zkNnYWXhDN5TFuDSjMUL3f+uT4tuf6hCHo1Ozy//XfCAM7Xger44EnrkeUWsbp2SvSToJCUfKlss5IKJdSYi8WtJ9iOlxADbszc4Nc7JFahw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRqhs5i/Ncu2yedapHw9mAjTF7zo0/lIsTveoKsgK20=;
 b=gaZcV7K3PX6Hm+oy4dCQk47nMx7QrMX08Kh8K31XFhNtic4b3/ksqVn2UbhuUfrWCyc7plOC6kd7D8frbQXLWvvBsjied5AlYJU9e/sj9ZFpfwdjqQhJtvduOCIu3Iy/A3oEhgSp322ySd2qnZBMlpCsIm3eRuImp8BqPqxLE10=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3884.namprd12.prod.outlook.com (10.255.173.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Mon, 17 Feb 2020 20:55:37 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2729.032; Mon, 17 Feb 2020
 20:55:37 +0000
Subject: Re: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
 <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
 <20200213195602.GD18610@linux.intel.com>
 <e2c41b25-6d6d-6685-3450-2e3e8d84efd1@de.ibm.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6da2e3d0-a2be-18d2-3548-b546052d14e3@amd.com>
Date:   Mon, 17 Feb 2020 14:55:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <e2c41b25-6d6d-6685-3450-2e3e8d84efd1@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:805:66::18) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN6PR08CA0005.namprd08.prod.outlook.com (2603:10b6:805:66::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 20:55:35 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2329ec67-c087-497c-c24d-08d7b3ebbd7f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3884:
X-Microsoft-Antispam-PRVS: <DM6PR12MB388410F7B698672FE85E9CD4EC160@DM6PR12MB3884.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(199004)(189003)(52116002)(4326008)(86362001)(53546011)(31696002)(8936002)(478600001)(2906002)(7416002)(956004)(2616005)(36756003)(6486002)(110136005)(54906003)(26005)(16576012)(316002)(31686004)(66556008)(16526019)(81156014)(81166006)(66946007)(66476007)(8676002)(5660300002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3884;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UpheTeX01U/wctEZBpjT8GHWT39L3vV3/xPWEYJpzfel0BO9OXgBZ+Vcxu1i/zvlydvrEdFmoegE4WI8wRWYgZf79hzqeWtuApoR/V+0UVjuR+kiSsH+/gGtziB1cbCdbgZbys43EIpmEIdCF9IgwWMOy+QjSpObTRKOPnTld29Y+ku3Nbz4WW0jSBxGJ5t5Sm3mGOX0zx8i8YUkUZPcQxtA8qziPsIt26dy6Z5uSw3LuF/Gf1W//L71ngxzE2s0yM9wCGzEGsi89/oM1NRz4QHsuyaM3LHHz4HUbvLcu8pxu+NNBOSTineQk0qibcdLkG1IFeHwYSTNz5LlNiRitl/X1/CeQyAk5zdXaTqNDUJA5st7FP338XZtj73hR/lr7pOB2NfDVvnC4kc4nRK1oiZF9D449TiumtrXz26oQJl4owSKGc9xLxjpoBtwVdxd
X-MS-Exchange-AntiSpam-MessageData: UHp1nLZ7NJ2FVeygvdOpOZFVCvLr7Wb3B3cOUtRQZzrARsAIPtV7wjq0VIeyofYJ8fdO1/shoKy4dh1E1YQ/Rp9Rslo94cTWQOxNzja0FgOdGQlTckBgpWkvUONRW8NsiTuw6SDfSa5NROzfHYrHqg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2329ec67-c087-497c-c24d-08d7b3ebbd7f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 20:55:37.7105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgRYmIPHG2be9Uo9Hwo/PPPzz+zJB6Jloilq7+un/ioowbZTDQbeJXMRE7ZnissxPsswWEJF1tgloIOhe2Kh8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3884
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/20 2:13 PM, Christian Borntraeger wrote:
> 
> 
> On 13.02.20 20:56, Sean Christopherson wrote:
>> On Mon, Feb 10, 2020 at 06:27:04PM +0100, Christian Borntraeger wrote:
>>> CC Marc Zyngier for KVM on ARM.  Marc, see below. Will there be any
>>> use for this on KVM/ARM in the future?
>>>
>>> CC Sean Christopherson/Tom Lendacky. Any obvious use case for Intel/AMD
>>> to have a callback before a page is used for I/O?

From an SEV-SNP perspective, I don't think so. The SEV-SNP architecture
uses page states and having the hypervisor change the state from beneath
the guest might trigger the guest into thinking it's being attacked vs
just allowing the I/O to fail. Is this a concern with flooding the console
with I/O error messages?

>>
>> Yes?
>>
>>> Andrew (or other mm people) any chance to get an ACK for this change?
>>> I could then carry that via s390 or KVM tree. Or if you want to carry
>>> that yourself I can send an updated version (we need to kind of 
>>> synchronize that Linus will pull the KVM changes after the mm changes).
>>>
>>> Andrea asked if others would benefit from this, so here are some more
>>> information about this (and I can also put this into the patch
>>> description).  So we have talked to the POWER folks. They do not use
>>> the standard normal memory management, instead they have a hard split
>>> between secure and normal memory. The secure memory  is the handled by
>>> the hypervisor as device memory and the ultravisor and the hypervisor
>>> move this forth and back when needed.
>>>
>>> On s390 there is no *separate* pool of physical pages that are secure.
>>> Instead, *any* physical page can be marked as secure or not, by
>>> setting a bit in a per-page data structure that hardware uses to stop
>>> unauthorized access.  (That bit is under control of the ultravisor.)
>>>
>>> Note that one side effect of this strategy is that the decision
>>> *which* secure pages to encrypt and then swap out is actually done by
>>> the hypervisor, not the ultravisor.  In our case, the hypervisor is
>>> Linux/KVM, so we're using the regular Linux memory management scheme
>>> (active/inactive LRU lists etc.) to make this decision.  The advantage
>>> is that the Ultravisor code does not need to itself implement any
>>> memory management code, making it a lot simpler.
>>
>> Disclaimer: I'm not familiar with s390 guest page faults or UV.  I tried
>> to give myself a crash course, apologies if I'm way out in left field...
>>
>> AIUI, pages will first be added to a secure guest by converting a normal,
>> non-secure page to secure and stuffing it into the guest page tables.  To
>> swap a page from a secure guest, arch_make_page_accessible() will be called
>> to encrypt the page in place so that it can be accessed by the untrusted
>> kernel/VMM and written out to disk.  And to fault the page back in, on s390
>> a secure guest access to a non-secure page will generate a page fault with
>> a dedicated type.  That fault routes directly to
>> do_non_secure_storage_access(), which converts the page to secure and thus
>> makes it re-accessible to the guest.
>>
>> That all sounds sane and usable for Intel.
>>
>> My big question is the follow/get flows, more on that below.
>>
>>> However, in the end this is why we need the hook into Linux memory
>>> management: once Linux has decided to swap a page out, we need to get
>>> a chance to tell the Ultravisor to "export" the page (i.e., encrypt
>>> its contents and mark it no longer secure).
>>>
>>> As outlined below this should be a no-op for anybody not opting in.
>>>
>>> Christian                                   
>>>
>>> On 07.02.20 12:39, Christian Borntraeger wrote:
>>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>
>>>> With the introduction of protected KVM guests on s390 there is now a
>>>> concept of inaccessible pages. These pages need to be made accessible
>>>> before the host can access them.
>>>>
>>>> While cpu accesses will trigger a fault that can be resolved, I/O
>>>> accesses will just fail.  We need to add a callback into architecture
>>>> code for places that will do I/O, namely when writeback is started or
>>>> when a page reference is taken.
>>>>
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>  include/linux/gfp.h | 6 ++++++
>>>>  mm/gup.c            | 2 ++
>>>>  mm/page-writeback.c | 1 +
>>>>  3 files changed, 9 insertions(+)
>>>>
>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>> index e5b817cb86e7..be2754841369 100644
>>>> --- a/include/linux/gfp.h
>>>> +++ b/include/linux/gfp.h
>>>> @@ -485,6 +485,12 @@ static inline void arch_free_page(struct page *page, int order) { }
>>>>  #ifndef HAVE_ARCH_ALLOC_PAGE
>>>>  static inline void arch_alloc_page(struct page *page, int order) { }
>>>>  #endif
>>>> +#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
>>>> +static inline int arch_make_page_accessible(struct page *page)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +#endif
>>>>  
>>>>  struct page *
>>>>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>> index 7646bf993b25..a01262cd2821 100644
>>>> --- a/mm/gup.c
>>>> +++ b/mm/gup.c
>>>> @@ -257,6 +257,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>>>>  			page = ERR_PTR(-ENOMEM);
>>>>  			goto out;
>>>>  		}
>>>> +		arch_make_page_accessible(page);
>>
>> As Will pointed out, the return value definitely needs to be checked, there
>> will undoubtedly be scenarios where the page cannot be made accessible.
> 
> Actually onm s390 this should always succeed unless we have a bug.
> 
> But we can certainly provide a variant of that patch that does check the return
> value. 
> Proper error handling for gup and WARN_ON for pae-writeback.
>>
>> What is the use case for calling arch_make_page_accessible() in the follow()
>> and gup() paths?  Live migration is the only thing that comes to mind, and
>> for live migration I would expect you would want to keep the secure guest
>> running when copying pages to the target, i.e. use pre-copy.  That would
>> conflict with converting the page in place.  Rather, migration would use a
>> separate dedicated path to copy the encrypted contents of the secure page to
>> a completely different page, and send *that* across the wire so that the
>> guest can continue accessing the original page.
>> Am I missing a need to do this for the swap/reclaim case?  Or is there a
>> completely different use case I'm overlooking?
> 
> This is actually to protect the host against a malicious user space. For 
> example a bad QEMU could simply start direct I/O on such protected memory.
> We do not want userspace to be able to trigger I/O errors and thus we
> implemented the logic to "whenever somebody accesses that page (gup) or
> doing I/O, make sure that this page can be accessed. When the guest tries
> to access that page we will wait in the page fault handler for writeback to
> have finished and for the page_ref to be the expected value.

So in this case, when the guest tries to access the page, the page may now
be corrupted because I/O was allowed to be done to it? Or will the I/O
have been blocked in some way, but without generating the I/O error?

Thanks,
Tom

> 
> 
> 
>>
>> Tangentially related, hooks here could be quite useful for sanity checking
>> the kernel/KVM and/or debugging kernel/KVM bugs.  Would it make sense to
>> pass a param to arch_make_page_accessible() to provide some information as
>> to why the page needs to be made accessible?
> 
> Some kind of enum that can be used optionally to optimize things?
> 
>>
>>>>  	}
>>>>  	if (flags & FOLL_TOUCH) {
>>>>  		if ((flags & FOLL_WRITE) &&
>>>> @@ -1870,6 +1871,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>>>>  
>>>>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
>>>>  
>>>> +		arch_make_page_accessible(page);
>>>>  		SetPageReferenced(page);
>>>>  		pages[*nr] = page;
>>>>  		(*nr)++;
>>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>>> index 2caf780a42e7..0f0bd14571b1 100644
>>>> --- a/mm/page-writeback.c
>>>> +++ b/mm/page-writeback.c
>>>> @@ -2806,6 +2806,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>>>>  		inc_lruvec_page_state(page, NR_WRITEBACK);
>>>>  		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
>>>>  	}
>>>> +	arch_make_page_accessible(page);
>>>>  	unlock_page_memcg(page);
>>>
>>> As outlined by Ulrich, we can move the callback after the unlock.
>>>
>>>>  	return ret;
>>>>  
>>>>
>>>
> 
