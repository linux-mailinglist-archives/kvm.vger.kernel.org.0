Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740A529A316
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 04:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504526AbgJ0DSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 23:18:01 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:51585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2444375AbgJ0DSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 23:18:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEti5++YvxSyVLWkr3oSe2XEhjWjKQuo+xf53hD31RHxSvmtR+pomnbn2/oz0AgCbuT258E0b0REdDXvEMhvZfLe6oWEF8EE1Pmogcm834hJb7G09Ih8aiNHfr5Tem4/UjL1qMpfC37wQUTrgMIvrTGqSQ+EXui2E1Mp68VGTOzbo7PFzt5e3I4gmCKLrV77+yaSxAPPpxOpya5ElEKiPC5M0BbSQsN9cIc4dghVZvEhtLmfJM22oqU+z3K2ylenHxKhfV6uTAovxEZiRttgdptwyStuTslWyip5+nDh1T6NSF2gxVLcw4vyxXWq3XD57P2gJS++kKHrIMjl78dG2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6Z8PaWzNk9hjjC7gD+m4VjbbUD4RZxtbO3BG+jpL2o=;
 b=U9+zR4/VhoFqriq7jhs+r5HxmzsYjC5/YZ5ifxMOB5XKBrM/EeNxmtdNwbjrqOSTJygPfqCTJtIYAXCPL6RfdHo51a/RqwUAgxUC8UZtlDHHNG8n/1tANp1WjQWo4yrzj6mgqNHAuRwxhmbvY8/tYhE/6tv4rj6nuWWdv9fMM2+qVvABUdf0LFuhUrjbNfIiXEG+j7NIINJ/rrdJpzNlBXW9Sj4VP+2wUfXLMEXpl+2NcE+dFqr/EOpfRofnLnYWyoS/TqlIfLlpIp26n7SijVAveRS0AwjgO5h0OlYRa6dPro6UkRG4ynGTcxGpzLi1nrxKSqOZaBZcudr3+dIUYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6Z8PaWzNk9hjjC7gD+m4VjbbUD4RZxtbO3BG+jpL2o=;
 b=ssfzIAjhhTypD4Q5cslB7CByUu5/F09fuXm64bDgg0zVUXhnAtFLUR+A7x0kimzQlAVeRwrUGE97/z9qhBZ5fejSSe7gW6BedVFaxp2r8dSac8mxRbwTuOoHq+Gu5ibHvdcuU/xumJ4PGfKhBqcj5rIZxAj3EX4gmV/Y/2EAeuw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Tue, 27 Oct
 2020 03:17:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::4888:5f3e:dbbc:c838]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::4888:5f3e:dbbc:c838%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 03:17:56 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
To:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
 <3bf90589-8404-8bd6-925c-427f72528fc2@amd.com>
 <20200803171620.GC3151@linux.intel.com>
 <16ef9998-84a9-1db4-d9a3-a0cab055a8a2@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <a1ecadce-531f-3698-7962-cbca6a1ebaf3@amd.com>
Date:   Mon, 26 Oct 2020 22:22:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <16ef9998-84a9-1db4-d9a3-a0cab055a8a2@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Tue, 27 Oct 2020 03:17:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0c7825a-d145-45d7-dfe2-08d87a26e66e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB251191138C84AF828F7ECED1E5160@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tV4up3aItaRVMNYJBxAaCl4uLHTpgmRN1NeVvm+lagK0dBlRRmoWe63Wp6LCfgxf/l/UmkWOcJ3r6lymIkaGoqO6FjOKQr6W6dyJcmvqkSFIEdSUazib3YACdl2FZ+mKxJ29hvadVqwBHTImRTjgwLo1mTwOEM6ZYDnwJ79pX9i1Q6AyqQFqJcOwskCnPqaY2zgVkip00Lx8gpJJ6HTnhaspCeI/IbGIOrHjhPrH2XsmfjiVkIMCPcKdw1/xM2o+sbsViS/N+oZ/kYbLdZrH1+9HcgivT+xYJPQG20+JkNQIUZ9OylDPremMhFmVJkk4N0XN0JfqH7uNZGntesBzaa++fhDt1fMR3WBGNz0qYO23izSm/Jh6Xx6hI70DNf+3VlRDbd8zT86lrRk+RifiKNNl4V9uQQDmT+jQPLMb/DxdH4cZ2a5t3V4P6BFmoKHOCMZtt5CAAtluElIsot2e+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(956004)(316002)(66946007)(2906002)(36756003)(54906003)(66476007)(5660300002)(66556008)(31686004)(6486002)(16526019)(6666004)(2616005)(8936002)(86362001)(83380400001)(45080400002)(478600001)(4326008)(6512007)(53546011)(966005)(6506007)(31696002)(8676002)(186003)(52116002)(44832011)(26005)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yY3HTAaId750NLHjK9jDdGC7Ulc9hAcgkE+KicBfBGJzqgZXatnZBxC8PwNJp+M9SYnMiHeO+Z61gQMp41ewVO07EsJnAkE7QoL4ky0xS7zYXHaH+dgOYorj10jZg39EGZD/Xejez0O2zVHYUdjG0xU7SREIBmYnQQDfmGUDz8Cpxk696bUtZsixLtOyfDTAr/h7/mnMka3aFlVu07hmjw9nEsFpN6NjjRyytwHKrzGz7oSQX4fURtop3ws8AZ3Ub19VrOnZaiCkxa3nXXuLdXRKzov/ZuQh/x620LmWSeZT2FOBBHAc4duS5+moCS14Rfn5nh8hVzzi1hhvVb4XmS5abQumNLqT6yXOXqmyR3QhlfVrOTMcdTX8N+svnp7xQiaIxa9Ee+PLz9d7g4AlZWtN8KbknihJP3Lnf8tc6Zdcngv46Bo/Nzes6j7IWbCmdnd8+hFW2Jrv7Ugs9YXqJ3OmNajHsIzHD0IohR9IBrKAUfOTtNeWKheQ9qXOzCqeB9rowLpAlAe9oxboQ0OyO//Z1qdvGx6riM4ms2J0D4JtiGClaYou7AMymqOb/bMhT5btNfAkdW2EO1K9+HazxBpivDztP6MYP/n3EfTrufIYjpsZBeFOtY8M6OivoqaXcZeauGo0POgXkeM/MihmJw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c7825a-d145-45d7-dfe2-08d87a26e66e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 03:17:56.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2UcoWbSticrLZyHC6Kw9mnviqffXFP4Ev+TnqNaFuQNVDjh92a768d5QxPhbvAmUMWG3EKhw3bRgF2ifRBwkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 8/4/20 2:40 PM, Brijesh Singh wrote:
> On 8/3/20 12:16 PM, Sean Christopherson wrote:
>> On Mon, Aug 03, 2020 at 10:52:05AM -0500, Brijesh Singh wrote:
>>> Thanks for series Sean. Some thoughts
>>>
>>>
>>> On 7/31/20 4:23 PM, Sean Christopherson wrote:
>>>> SEV currently needs to pin guest memory as it doesn't support migrating
>>>> encrypted pages.  Introduce a framework in KVM's MMU to support pinning
>>>> pages on demand without requiring additional memory allocations, and with
>>>> (somewhat hazy) line of sight toward supporting more advanced features for
>>>> encrypted guest memory, e.g. host page migration.
>>> Eric's attempt to do a lazy pinning suffers with the memory allocation
>>> problem and your series seems to address it. As you have noticed,
>>> currently the SEV enablement  in the KVM does not support migrating the
>>> encrypted pages. But the recent SEV firmware provides a support to
>>> migrate the encrypted pages (e.g host page migration). The support is
>>> available in SEV FW >= 0.17.
>> I assume SEV also doesn't support ballooning?  Ballooning would be a good
>> first step toward page migration as I think it'd be easier for KVM to
>> support, e.g. only needs to deal with the "zap" and not the "move".
>
> Yes, the ballooning does not work with the SEV.
>
>
>>>> The idea is to use a software available bit in the SPTE to track that a
>>>> page has been pinned.  The decision to pin a page and the actual pinning
>>>> managment is handled by vendor code via kvm_x86_ops hooks.  There are
>>>> intentionally two hooks (zap and unzap) introduced that are not needed for
>>>> SEV.  I included them to again show how the flag (probably renamed?) could
>>>> be used for more than just pin/unpin.
>>> If using the available software bits for the tracking the pinning is
>>> acceptable then it can be used for the non-SEV guests (if needed). I
>>> will look through your patch more carefully but one immediate question,
>>> when do we unpin the pages? In the case of the SEV, once a page is
>>> pinned then it should not be unpinned until the guest terminates. If we
>>> unpin the page before the VM terminates then there is a  chance the host
>>> page migration will kick-in and move the pages. The KVM MMU code may
>>> call to drop the spte's during the zap/unzap and this happens a lot
>>> during a guest execution and it will lead us to the path where a vendor
>>> specific code will unpin the pages during the guest execution and cause
>>> a data corruption for the SEV guest.
>> The pages are unpinned by:
>>
>>   drop_spte()
>>   |
>>   -> rmap_remove()
>>      |
>>      -> sev_drop_pinned_spte()
>>
>>
>> The intent is to allow unpinning pages when the mm_struct dies, i.e. when
>> the memory is no longer reachable (as opposed to when the last reference to
>> KVM is put), but typing that out, I realize there are dependencies and
>> assumptions that don't hold true for SEV as implemented.
>
> So, I tried this RFC with the SEV guest (of course after adding some of
> the stuff you highlighted below), the guest fails randomly. I have seen
> a two to three type of failures 1) boot 2) kernbench execution and 3)
> device addition/removal, the failure signature is not consistent. I
> believe after addressing some of the dependencies we may able to make
> some progress but it will add new restriction which did not existed before.
>
>>   - Parent shadow pages won't be zapped.  Recycling MMU pages and zapping
>>     all SPs due to memslot updates are the two concerns.
>>
>>     The easy way out for recycling is to not recycle SPs with pinned
>>     children, though that may or may not fly with VMM admins.
>>
>>     I'm trying to resolve the memslot issue[*], but confirming that there's
>>     no longer an issue with not zapping everything is proving difficult as
>>     we haven't yet reproduced the original bug.
>>
>>   - drop_large_spte() won't be invoked.  I believe the only semi-legitimate
>>     scenario is if the NX huge page workaround is toggled on while a VM is
>>     running.  Disallowing that if there is an SEV guest seems reasonable?
>>
>>     There might be an issue with the host page size changing, but I don't
>>     think that can happen if the page is pinned.  That needs more
>>     investigation.
>>
>>
>> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20200703025047.13987-1-sean.j.christopherson%40intel.com&amp;data=02%7C01%7Cbrijesh.singh%40amd.com%7C8d0dd94297ff4d24e54108d837d0f1dc%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637320717832773086&amp;sdata=yAHvMptxstoczXBZkFCpNC4AbADOJOgluwAtIYCuNVo%3D&amp;reserved=0


We would like to pin the guest memory on #NPF to reduce the boot delay
for the SEV guest. Are you planning to proceed with this RFC? With the
some fixes, I am able to get the RFC working for the SEV guest. I can
share those fixes with you so that you can include them on next
revision. One of the main roadblock I see is that the proposed framework
has a dependency on the memslot patch you mentioned above. Without the
memslot patch we will end up dropping (aka unpinning) spte during
memslot updates which is not acceptable for the SEV guest. I don't see
any resolution on the memslot patch yet. Any updates are appreciated. I
understand that getting memslot issue resolved may be difficult, so I am
wondering if in the meantime we should proceed with the xarray approach
to track the pinned pages and release them on VM termination.


>>>> Bugs in the core implementation are pretty much guaranteed.  The basic
>>>> concept has been tested, but in a fairly different incarnation.  Most
>>>> notably, tagging PRESENT SPTEs as PINNED has not been tested, although
>>>> using the PINNED flag to track zapped (and known to be pinned) SPTEs has
>>>> been tested.  I cobbled this variation together fairly quickly to get the
>>>> code out there for discussion.
>>>>
>>>> The last patch to pin SEV pages during sev_launch_update_data() is
>>>> incomplete; it's there to show how we might leverage MMU-based pinning to
>>>> support pinning pages before the guest is live.
>>> I will add the SEV specific bits and  give this a try.
>>>
>>>> Sean Christopherson (8):
>>>>   KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
>>>>   KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
>>>>   KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
>>>>   KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
>>>>   KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
>>>>   KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>>>>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
>>>>   KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
>>>>
>>>>  arch/x86/include/asm/kvm_host.h |   7 ++
>>>>  arch/x86/kvm/mmu.h              |   3 +
>>>>  arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
>>>>  arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
>>>>  arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
>>>>  arch/x86/kvm/svm/svm.c          |   3 +
>>>>  arch/x86/kvm/svm/svm.h          |   3 +
>>>>  7 files changed, 302 insertions(+), 44 deletions(-)
>>>>
