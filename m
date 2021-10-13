Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6142CD17
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 23:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhJMVvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 17:51:40 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:18273
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229702AbhJMVvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 17:51:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHhYMTqmdXOF3mb7RZZgQkem8GocpKB2O7eQDqG86Lw6Av1o0Qh+K4mcZWaMHwactktJv1wuhtJmBai01MnRBXRRNSRRi8SYtFJnc96JG2NtaHFaAzxAUDnkxfI8PzsDzossOX3whOK5Q1T7mtAJ0sFgysDTzbeoTDmqSttgB8zYfigveCbe4fjXohos7GBdIYU1L76sxXFtpZBS+JVp1Y8xJpeWpJFv6fDlZsmNEzczYAZN/ciw44rr4QfPtlyOAn2ObjnCRk0TDY84kMex4N5MFg/4nXdeqaig+RQJ6TQBNGZFANO/e4CV7R6MXdDthByd/tv0irhGZfvmG8tnlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brPhOveEdFg70VeBRL29HywBAgapi912n2l4jxsh9Ak=;
 b=Ma1z1aJOxJkLgcf4U67e7Y23GU5OCnx6TkPsAx8yK7LDnsrHLcDoxaMNfBicg6evzaykj/j8ORl+ba7Hyw1x9ch6zB+QlAynckbdYi3+ZL5E6bQmS9OxsfpWRq3uAcShJd6Lw7aQlMLdJLNcewywVmk6y+qQqX1a8tRfNecnWmsTiLOvcqXTA61Aie7O4jTJfhggH8s0CORmT7eKSCvNysroRtlh/+j+c9NdZhfsPXnEcCtD2NeF5keYiGlRnFFR0ct1oWX69iqlOpUs++lgVTjy7Hfe5Gvs9WDtapo0emiPKGctxxLaZLCj4c7mvUk0FjZY4mQPbmBAmHacC5HKMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brPhOveEdFg70VeBRL29HywBAgapi912n2l4jxsh9Ak=;
 b=ddqjXF6rO0UgL+DxnT4BnWekMsnSItIAevCdFGuqySiFa/kxojLSoskVtCp1lF0saca9uZlGdmW6j0vrFpxAOpx6rxEiUBwXqNoZ8R4lelq66qZdRXjzZ+1Gkl0zBZLoSG+UCn5tKEcQqDMJY971UPPQ/6rRkJFoIQeQkfrJqIg=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 21:49:32 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 21:49:32 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com> <YWYm/Gw8PbaAKBF0@google.com>
 <94128da2-c9f7-d990-2508-5a56f6cf16e7@amd.com> <YWc9KL8gghEiI48h@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <a7a541ba-129a-1083-3517-c30e9f9cd7c7@amd.com>
Date:   Wed, 13 Oct 2021 16:49:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWc9KL8gghEiI48h@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:805:106::24) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR2101CA0014.namprd21.prod.outlook.com (2603:10b6:805:106::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.3 via Frontend Transport; Wed, 13 Oct 2021 21:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b577bf6-0cde-423e-6c36-08d98e9356f0
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB475067D7642A6833009E7603E5B79@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+S0ArGkQuXDixZ/vvV+J/UH5RINmnKvzjo/dLWbNy3ApRFXAwzZ5OdTFlIA2HBZgI3R03Gf5HhUmIS3uhgnhoPiXAQ3fZT1NnKVKtMYc7ltCNYOSotCxuunZnYnuicUclhNGpHf1lV1T3M26qn6ikAKQluRGrsp1ktrEylktG/oOwrseMxLq/Z7aTRt8AUub5AyP5r1Oj44OQCNv1qKEUzRy1pWwhksImXAgyHLUo1v/cFK+3fZCeNnXmVx/qQFmb9zHnra2hEVd1jarf4cDCAGIH7wyOCYdcxaUes4V2JjCEXpD+hap5B6OyVqgo3bQUllTRdfW311TiFb7kqlLdzonPTPwfG1OhL4i3TszDpQlZmqdjiN4Qrd/1dJJpFvnKwHZmOnJYf2MrY39GCb9H4jOmO9eipNZe+vOxPikkE4c+8RyEJtc/14MvrCG1gcEmFb4h3zpydJQ/HRDGTUOAxjC//SZbdhgNVLymXrSja1EAm4M9iYM/SFQESDgXeCDi3T7dCWBlfmqCZ/1xE90raAUS9vpGAMLw6CsQTXeme6hCL0mcv9jvZfiv9m2mWaHBodAaYf5fxFTHPfsH2yU64ewB0vH3uvW9txbjYSXXS4IxGhPrqH6ltBCbzWsVr+/R/8C+rdggjxkyhvKxZfxHC1dJlKueBnea0CK3ikUwjKSqWsPgxSBow09tL+2L8ur9VlW5pYDQEjb01wwUBrDVVf9+ksUke82rkEgzzJl2AqzEMOkROw7TrZ63BZBQDvc37q7oy04Hfphh0uMUM3Fas8zIhWn2iAOEq9QMTi3KwyuwSlgUyrvvilKpcaQ0EOd+LKkUWky0nl2qWqQaVrEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66556008)(8676002)(6486002)(66946007)(966005)(31686004)(66476007)(6512007)(54906003)(44832011)(86362001)(38100700002)(2906002)(31696002)(2616005)(956004)(26005)(4326008)(6506007)(316002)(186003)(7416002)(508600001)(7406005)(5660300002)(8936002)(45080400002)(6916009)(36756003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amdDZHNxYWhQUGNJRFpqT2xMWW4rVUVLYTNKZXhoVkh1K2Rod3RBTm9VaFZZ?=
 =?utf-8?B?VExoU2kwZVNzT3UxWkxMUTdvYW1jVGR0UkFOc0MxSzFvbGFoQ3drV2VkdGp1?=
 =?utf-8?B?SUlXTml6cVlFMHZaOHF4bldSeGtXcVd3NjA4M0YramF3VXRORGltVk5mUFpZ?=
 =?utf-8?B?NjhneTdDRkMrS2NNd3EzTlRGcENNZVVQa05XYkRFL3B3ekV2ZU03UWpNcmhi?=
 =?utf-8?B?TGZFWjQ4YUhVSzF6RGQybnJCTXF3UkFDanJvNjJ3aDJFYnFna2ZveWJadjFC?=
 =?utf-8?B?Y3A3NkdjbXN5MWhoU3ZYZGhzcFM3ajYwUHBmSnVmQVFLLzdyVnRzVmxtYTcw?=
 =?utf-8?B?cWRWQ1ZVaHcvUmdiek5BMGkyTXgxUFdqeGFPWFpScS82VFh4aVdia3FnK29i?=
 =?utf-8?B?ZTM5T1Z3SmgwTWxFN2J1QWFYVVdJZTR3bXNUR0phMDVDTTArL05jc3JlbHBt?=
 =?utf-8?B?QUpWWVd0Y1NEbkJqbHY2UzlaR1M3UGN4RzM5L2ZVa05YQzA3YTluNnR0M1VB?=
 =?utf-8?B?eWVQQVV1cGUwSkNqaDY4N05rVUdUQ0crSFJlVzNuVzltcTIrVGxqazFnYzQ0?=
 =?utf-8?B?RDQxUzlLakZ1VEtSWUNMd3pBOXhPTDZOSTVzYnJPQkN3WEo3ZkNGWmxnV1NQ?=
 =?utf-8?B?cnJIdTNYaWNjb0o1citoOXJOTzVvREQwdDI1TnR3bWdzUVVFOWIvaE5CaGg0?=
 =?utf-8?B?dTlrdzZHc3Rsclpzd0dURHpRWTZURmtGa0NKZ2tpdmQ3ZDZKWHdwT2pWMHBX?=
 =?utf-8?B?REJDUXIyZUlFYkprekg0THh4WlRiVmVEZHkrOWR6NVJjSUx5a2tzejEzeHlq?=
 =?utf-8?B?OHNiN2hSRUNuekNRNUhPUWZsZGdRMFI0T1huZnlpZ2NOMVBMQmtXdVo1emt6?=
 =?utf-8?B?WS9Ob3YvT1p4QzQ1RGt5YXpvV3l5QkE2QmUzTUIrZGI0djBsWUZ2M3ljZW5a?=
 =?utf-8?B?MnFpTU5DQnkzbG1raG01Sk5KNjlwRllMSE1BbUFVV1NQTXp0ZmE4cFpES3FQ?=
 =?utf-8?B?RFI1OWxYKzVUZkdDbGhDMXYxNEN6bmVyZHBVVElMNUlsNnd4WUt5NEs5RXlQ?=
 =?utf-8?B?VnpYYWUrQkYzbzB3VUQrUGsrQzNwOWF0VVF1UzlvRVVmdU9LU1pqVFRDbmw2?=
 =?utf-8?B?cWRtRWZIM2dESzA3Uk1hYWVRQTVFdUgzUk1NKzNkUWliQWIwbWJqK0NndHBX?=
 =?utf-8?B?akR3UDFsV3FuWHBrV0hWTVFRa1B5NUVZQWNWa3M2OXNqOHB6U3paeWk5Z3Fs?=
 =?utf-8?B?S0VXS3NYOVZ6M0Z2MGFrVjgyck5qM1ExRlY0d2JxTDA4R2NaZlhXaDdtVmZu?=
 =?utf-8?B?eSs0STFHcGVpaUJPQTNaM0o0b0E5Ty90VUhQYkVidGlPSXo3RDVEQXQvMWRH?=
 =?utf-8?B?SHlyUEZ3dkJocjlESVoyMHpPYVg5RUVtTjBTK1Iyb3NIWGRVL29XNmFCZGRn?=
 =?utf-8?B?TGdMekZHN0o0MFFKMWhHdzBMdlJMQ29IVHBDSjRPeEFrNXhIa2RmUU1WM1ZO?=
 =?utf-8?B?UkRrNVR0ZnBvelRDaEU2M2MveTB0N210VHN3RWpvVGVXc082OG5tTmZyNzAr?=
 =?utf-8?B?SW5Lbllqb0dBSnZnVVM5RHUrMzNQREgwcmpPc1JBMU15WVZoa2oyQzgzd2Za?=
 =?utf-8?B?L004SmFuSElvR1ltS05tR3lrU0N4RWhTZ0V1UGt6bHdBN3EvV0RTQXRhK3Fv?=
 =?utf-8?B?aWl1ZEJWa3hkbllkL0tQYzhqcG9acm0rUDREellkOG9tdE84VkZqSUJkU0NR?=
 =?utf-8?Q?Vkd+biKzs6m98LzVYU66KXcHDYM91R9THOFTQi3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b577bf6-0cde-423e-6c36-08d98e9356f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 21:49:32.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53G9PMVlkiTPx6+1xFOGQ1GESEBx4l7SFxs8e0vZh2eFXHNnomgNIVHOBsxKlB0Gp4fE4WmQWCP2V/mBQpkTsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 1:10 PM, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Brijesh Singh wrote:
>> On 10/12/21 5:23 PM, Sean Christopherson wrote:
>>> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>>>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
>>>> either be a private or shared. A write from the hypervisor goes through
>>>> the RMP checks. If hardware sees that hypervisor is attempting to write
>>>> to a guest private page, then it triggers an RMP violation #PF.
>>>>
>>>> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
>>>> used to verify that its safe to map a given guest page. Use the SRCU to
>>>> protect against the page state change for existing mapped pages.
>>> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
>>> forces it to wait for existing maps to go away, but it doesn't prevent new maps
>>> from being created while the actual RMP updates are in-flight.  Most telling is
>>> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
>>>
>>> This also doesn't handle kvm_{read,write}_guest_cached().
>> Hmm, I thought the kvm_{read_write}_guest_cached() uses the
>> copy_{to,from}_user(). Writing to the private will cause a #PF and will
>> fail the copy_to_user(). Am I missing something?
> Doh, right you are.  I was thinking they cached the kmap, but it's just the
> gpa->hva that gets cached.
>
>>> I can't help but note that the private memslots idea[*] would handle this gracefully,
>>> e.g. the memslot lookup would fail, and any change in private memslots would
>>> invalidate the cache due to a generation mismatch.
>>>
>>> KSM is another mess that would Just Work.
>>>
>>> I'm not saying that SNP should be blocked on support for unmapping guest private
>>> memory, but I do think we should strongly consider focusing on that effort rather
>>> than trying to fix things piecemeal throughout KVM.  I don't think it's too absurd
>>> to say that it might actually be faster overall.  And I 100% think that having a
>>> cohesive design and uABI for SNP and TDX would be hugely beneficial to KVM.
>>>
>>> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210824005248.200037-1-seanjc%40google.com&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C0f1a3f5f63074b60d21b08d98e857daf%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637697526304105177%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=w6xS3DcG4fcTweC5i4%2BuB4jhn3Xcj2a44BkoATVcSgQ%3D&amp;reserved=0
>>>
>>>> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token)
>>>> +{
>>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +	int level;
>>>> +
>>>> +	if (!sev_snp_guest(kvm))
>>>> +		return 0;
>>>> +
>>>> +	*token = srcu_read_lock(&sev->psc_srcu);
>>>> +
>>>> +	/* If pfn is not added as private then fail */
>>> This comment and the pr_err() are backwards, and confused the heck out of me.
>>> snp_lookup_rmpentry() returns '1' if the pfn is assigned, a.k.a. private.  That
>>> means this code throws an error if the page is private, i.e. requires the page
>>> to be shared.  Which makes sense given the use cases, it's just incredibly
>>> confusing.
>> Actually I followed your recommendation from the previous feedback that
>> snp_lookup_rmpentry() should return 1 for the assigned page, 0 for the
>> shared and -negative for invalid. I can clarify it here  again.
>>
>>>> +	if (snp_lookup_rmpentry(pfn, &level) == 1) {
>>> Any reason not to provide e.g. rmp_is_shared() and rmp_is_private() so that
>>> callers don't have to care as much about the return values?  The -errno/0/1
>>> semantics are all but guarantee to bite us in the rear at some point.
>> If we look at the previous series, I had a macro rmp_is_assigned() for
>> exactly the same purpose but the feedback was to drop those macros and
>> return the state indirectly through the snp_lookup_rmpentry(). I can
>> certainly add a helper rmp_is_{shared,private}() if it makes code more
>> readable.
> Ah rats.  Bad communication on my side.  I didn't intended to have non-RMP code
> directly consume snp_lookup_rmpentry() for simple checks.  The goal behind the
> helper was to bury "struct rmpentry" so that it wasn't visible to the kernel at
> large.  I.e. my objection was that rmp_assigned() was looking directly at a
> non-architectural struct.
>
> My full thought for snp_lookup_rmpentry() was that it _could_ be consumed directly
> without exposing "struct rmpentry", but that simple, common use cases would provide
> wrappers, e.g.
>
> static inline snp_is_rmp_private(...)
> {
> 	return snp_lookup_rmpentry(...) == 1;
> }
>
> static inline snp_is_rmp_shared(...)
> {
> 	return snp_lookup_rmpentry(...) < 1;
> }

Yep, that what I was going to do for the helper.


>
> Side topic, what do you think about s/assigned/private for the "public" APIs, as
> suggested/implied above?  I actually like the terminology when talking specifically
> about the RMP, but it doesn't fit the abstractions that tend to be used when talking
> about these things in other contexts, e.g. in KVM.

I can float the idea to see if docs folks is okay with the changes but
generally speaking we all have been referring the assigned == private in
the Linux SNP support patch.

thanks

