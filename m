Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB042C864
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 20:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhJMSMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 14:12:53 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:42593
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238374AbhJMSMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 14:12:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXqVTxxLYj5cw0VSiass6IBiyU0v7uPp/rU2oQmmtq6FFvYzol5g20o2BoG8gpR9hEmql7xRr0mhGl2VwpcI9BfrWjYvcbIoGYgy0zikMN6mBPoEZmpgf1ceFC2M67Y3AsacIlTxUgom0st6Ea0+YqfvufJgNU20a0SF9JLq1n6n60p0QVJRQsm+BxkT9WQMO7UTOzMJRlakwLIXk3GR3yav6KG9wdsuQ7OcXV7TkRl0Cmn6hLVZgvcxCBP/sBfqDME7LeGM4nWibyWY5NO69U8krxfQHETLawHXxY0du6xXK/G/CGAalKx6bgAqnINrE/NB6V4m2AMiNM8WKun+ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eCH34C9A+yTV/Z+cdqYl73So6NX7lTiYV2JWEAlwDw=;
 b=VHP8ziiMfYdBofhoGf4c+mvqDKnjHbQ3wAEyoFPhP7CI4noBu4A/7t5f4N9KQJzOIZgGlbaVUOBH340FlZEnsUX6vJP1KCziQbgzBSSEulhG8uBgCpZPPNvyLDv4Jo5YpG/9kIZogBiJcNeWqaaKAvpbNLUvpNwdvz87qkrEK1cDmVk7iZUR7V8ePFwFQ8rw6ATVYUUPTeLg2pHlG29OzJI9HGV6hKMuZYtRk9GN8V5s5vJ7sX/OOeSri++zDwkNnEU+EiOtsww2n1v5NyL47nKnauII7qbCp87Ju6wK5R38SccIbWD4C5sE/b6ZWzdDLPwB0hMoZJTgz43LsHoVwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eCH34C9A+yTV/Z+cdqYl73So6NX7lTiYV2JWEAlwDw=;
 b=FK+hG1V2pitDE5jQ3/1rxb+qP8MHJ1wb27Aon9UDAfC0gERJiUPiS+4k4SZb4+pZK2M2L/+XXZyjGXaoibz90m2gHj6gFVKtUcLp9ggKNTO1L1NuXeWh/K/oM0MMi3nls2pC9uxziSPnszlBB+acVyKLcSTdqz9nyPXPiBADecY=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 18:10:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 18:10:45 +0000
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
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <94128da2-c9f7-d990-2508-5a56f6cf16e7@amd.com>
Date:   Wed, 13 Oct 2021 13:10:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWYm/Gw8PbaAKBF0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA0PR13CA0010.namprd13.prod.outlook.com (2603:10b6:806:130::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.7 via Frontend Transport; Wed, 13 Oct 2021 18:10:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c0baeb1-6a65-4f7b-88db-08d98e74c5fa
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4670DBA6DF06123A970E8220E5B79@SN6PR12MB4670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +sWknjZbel65NDunT6t/DYFHS0WNThQYtNAMoSa68bEoxk5G6gBqPhiQdOBFgz3BlOZLuwq3v8GjnYwK/aHWDHlvy48vYrhyc0byzv515LxNnIcswCnVt9uuT/vIdq2EkUNOC8irTR8Ueyh2ipK6lmE8Of4B6Nx2SKGH6drkGAaff7CzoI657QZsRdLSbHbxTnol9kHu0Ki+2wM0hSwOatoyjBXBqz6ezyxH3EZRd9p6n9tfCQcm1yeTTucFvd2oxcAYLbvFhm7kvCX/5jHBKy9C2dWSVIqOYHv7KIuYIh3RNBUfa48XxNCDP+phkoq4LEg4qm9BCf3ofLG9BJmt4MBS5vSWy2LlxVmbP14PlMjhQjKS23P6fde7Q5uaZMZN/IvQjA3b0YeR8p3kf2DWdcHjBbGaizsAIhSHiszia9BqM7zJcgEj0O90xeCUWblLFb+KGbpfzvw5VCzo470K0MVveX3rGbElL/hl2acQfUyS8DKeNJBOAdAGtqThyBgtIM/1j/r60aDMpvr2S48+2AslfD1n1w9M+ou3yOcARM/AwrWwuJfkIXjuxz0W9DWkE4aYfr4qof0U9w6mp72S31lFTxsd8bnCFOSQW1IO+KO9qhVU0OjWe+wFa7BG9eMUdJRSS0JzE6bX5S1VvCeW1eCf9bpcGS4nbYGsKnI+u6V4akypf12tyLorBxt3QNdpGEygJReLFeZZy6nxLtnHo5lpPIphZHtAon/JqObHJeN0RScKIGjyQoyN12suZFOuKpivl5I+j/O4ohkBfmggFYcvR2xtCiUW5tNDwK3By2zzloxMa1qDx//qgO0t1J3z1IDuxAs0mI/8M/4ZRuoQkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(7406005)(508600001)(6486002)(2906002)(6512007)(7416002)(316002)(31686004)(956004)(6916009)(44832011)(6506007)(4326008)(31696002)(2616005)(53546011)(36756003)(26005)(86362001)(5660300002)(45080400002)(66476007)(66946007)(66556008)(54906003)(38100700002)(966005)(8676002)(83380400001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1YxYVBjcDRvV1huNjlOY0F5V0FOM2VXaENrK1dwMi85cjVEZ1VERExEdlVh?=
 =?utf-8?B?MndnbDcySlM2aWlNZDlkWGVUcVl0dmEvS2lzZU0zS2o3K2hIaXR6Qi9qL1JZ?=
 =?utf-8?B?MFlSZkx4amIrN0ZQZjZaN3RDTjVoN2Uwc2NpYWVzcjNQTldMbHVaZlJ3aFVI?=
 =?utf-8?B?OFBVa3FzczV5NXJyYWk2QUpvNjhpbWxvWllTT1pZVXJJdlg2bjd4ZXBhTUpQ?=
 =?utf-8?B?emR0Y2M5RnNFeG1sMGpHRUJaOEVFNGdleXV0YjJ2UVIxMUhTV3BjazVidHBV?=
 =?utf-8?B?MmF1UWMvUXZhb21PMDlRWnFqT1ZrSlA3N05QWGoxdzJVZE9sU1NVNFpVTmhN?=
 =?utf-8?B?a2J5VmpaSHlDaUVvQXJRM3Z3NGtTRkFkSWExMk5DVThGM2tjcWx1VGZZNDRK?=
 =?utf-8?B?ZVUrM2UxUGFYNkxTSHNaWlQxL0UrSkJxeXQrdjhLUVBycU9YTVJnWFNuemRU?=
 =?utf-8?B?ejg1WkdQTFh1dThTWC9pMHgrcDJ0SUNPTWEvRHl3UDRnQ3kzQlJCaW1weHlF?=
 =?utf-8?B?UjFvdHUrRTN5VXMybkExVkZNMmlPWXNITjJ2Q3FDaHVCUzUyK0gzb0xWbmZR?=
 =?utf-8?B?OVZaRVBsMDR0MVZyRDRxNjVCRUxCNmswREJPQkpnYTRjS2V2RjY5NnNTNDl0?=
 =?utf-8?B?TzFnMG9FVTdsd3JmeTZVNjZubnpieHorcXV2b1lMVWtxVmd6K1RyNnlBN29n?=
 =?utf-8?B?RWZ6elk1R2VyVFUyUHRtWHhLcklMQmcrSGl1NkJSTGhPU0pGb2UzRlpvMnFZ?=
 =?utf-8?B?T0pSQ0R6QmUyaWhFMkNmYWU3SUo0V3BuOUc4TXN2WFhvd3BTK0phRklNME1m?=
 =?utf-8?B?QU0rYzVBWCtQR1dwNnBSK2RFY0lrdU9uT3NBbkVSNjJ6YjNQQ3Nkd2tsdjZv?=
 =?utf-8?B?ejltdGdzeUE0ODJqTzZmSlI0ZnkvdHgxcXBScHFrTHFJWjJEL3VsVFhhQlU5?=
 =?utf-8?B?T01LRWVWZTRNZkNmbVdwaWFzbE5vRVNqRVIzOHVwWnRJMlQ1cTRqNGlKZjNr?=
 =?utf-8?B?bzdXT0VrSGVNeTlHenFlZ1ZuaU41SG5rWVdDa2lNa3ZQVlU1UXhtb2todmtG?=
 =?utf-8?B?Y0ZtSGp4cVNBTTZvdlBrN2p5b2FrbWpTYm1NWHpDSGwxSUdLMGNEZGFUcElC?=
 =?utf-8?B?SnJyMlo4ZGdWT2VFMG5GUktNaDM2c3ExNjNxUHZhL2ptcUpvWlhtTi9OVUQr?=
 =?utf-8?B?K0J0RE56M09CV3BBR3ZHNVY3c3hpcnpTWDJSeUpLZk5vUWdXVkQ4QTRlU2c2?=
 =?utf-8?B?Y2lFeVoyNkFXbnZKUnd1NUd6QVQ1SU1SYkFZZjFNckRvckRIa3Uxc2tPbzU1?=
 =?utf-8?B?MnNDZlFNNmZsL3B6T09QTU0weWtNQUQxbE80ODhkYnBFZCs1NENOeVVoMlQr?=
 =?utf-8?B?THlGcmR0bE9ZcEUrRUNVdWJreGYyRlJuVjFHWWJzSUlJMFEvMmlqeWowZkZq?=
 =?utf-8?B?M0VGYzl1K1FKNnRWK1FUUmhoWGZZcDNmYlloU3pDdWRuY1JlMTlwQWFaQmtF?=
 =?utf-8?B?RnRpMEtINWIveEt1aFNvOTd0eG82UnliSDhmdkxDV1ZJQWV3K0Q0Y1o3aGtz?=
 =?utf-8?B?ZVRxV3pqK3FiTC9GR2NnRlhRYWg4cXJYZUdOWXozMVNTZ2FiTlZWWm53SFdy?=
 =?utf-8?B?QnVaRmNRSlYzNHRjbVBSYjc3b0pFaVZoc2o1MHM2Y0NCTURYR3UzSEdvOW1S?=
 =?utf-8?B?cGR2dWN4TWtaOC9zU255TTF2MnhEWWJMRHdmTkhPK05zWElrL1VNTXA2SEFJ?=
 =?utf-8?Q?x7VKRZpb7heyVGgPhrs7hY0GO7npnlIV/OrJIyw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0baeb1-6a65-4f7b-88db-08d98e74c5fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 18:10:45.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hC/UgjgOdl/7dDtX4poGntB7DWyFYTyK6No749FMpbtFC8vJZ9UTkGl5GLnRedBoMV1x67NrLVSWqbY4ws5FfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/12/21 5:23 PM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
>> either be a private or shared. A write from the hypervisor goes through
>> the RMP checks. If hardware sees that hypervisor is attempting to write
>> to a guest private page, then it triggers an RMP violation #PF.
>>
>> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
>> used to verify that its safe to map a given guest page. Use the SRCU to
>> protect against the page state change for existing mapped pages.
> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
> forces it to wait for existing maps to go away, but it doesn't prevent new maps
> from being created while the actual RMP updates are in-flight.  Most telling is
> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
>
> This also doesn't handle kvm_{read,write}_guest_cached().

Hmm, I thought the kvm_{read_write}_guest_cached() uses the
copy_{to,from}_user(). Writing to the private will cause a #PF and will
fail the copy_to_user(). Am I missing something?


>
> I can't help but note that the private memslots idea[*] would handle this gracefully,
> e.g. the memslot lookup would fail, and any change in private memslots would
> invalidate the cache due to a generation mismatch.
>
> KSM is another mess that would Just Work.
>
> I'm not saying that SNP should be blocked on support for unmapping guest private
> memory, but I do think we should strongly consider focusing on that effort rather
> than trying to fix things piecemeal throughout KVM.  I don't think it's too absurd
> to say that it might actually be faster overall.  And I 100% think that having a
> cohesive design and uABI for SNP and TDX would be hugely beneficial to KVM.
>
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210824005248.200037-1-seanjc%40google.com&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7Cd1717d511a1f473cedc408d98ddfb027%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637696814148744591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3LF77%2BcqmpUdiP6YAk7LpImisBzjRGUzdI3raqjJxl0%3D&amp;reserved=0
>
>> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	int level;
>> +
>> +	if (!sev_snp_guest(kvm))
>> +		return 0;
>> +
>> +	*token = srcu_read_lock(&sev->psc_srcu);
>> +
>> +	/* If pfn is not added as private then fail */
> This comment and the pr_err() are backwards, and confused the heck out of me.
> snp_lookup_rmpentry() returns '1' if the pfn is assigned, a.k.a. private.  That
> means this code throws an error if the page is private, i.e. requires the page
> to be shared.  Which makes sense given the use cases, it's just incredibly
> confusing.
Actually I followed your recommendation from the previous feedback that
snp_lookup_rmpentry() should return 1 for the assigned page, 0 for the
shared and -negative for invalid. I can clarify it here  again.
>
>> +	if (snp_lookup_rmpentry(pfn, &level) == 1) {
> Any reason not to provide e.g. rmp_is_shared() and rmp_is_private() so that
> callers don't have to care as much about the return values?  The -errno/0/1
> semantics are all but guarantee to bite us in the rear at some point.

If we look at the previous series, I had a macro rmp_is_assigned() for
exactly the same purpose but the feedback was to drop those macros and
return the state indirectly through the snp_lookup_rmpentry(). I can
certainly add a helper rmp_is_{shared,private}() if it makes code more
readable.


> Actually, peeking at other patches, I think it already has.  This usage in
> __unregister_enc_region_locked() is wrong:
>
> 	/*
> 	 * The guest memory pages are assigned in the RMP table. Unassign it
> 	 * before releasing the memory.
> 	 */
> 	if (sev_snp_guest(kvm)) {
> 		for (i = 0; i < region->npages; i++) {
> 			pfn = page_to_pfn(region->pages[i]);
>
> 			if (!snp_lookup_rmpentry(pfn, &level))  <-- attempts make_shared() on non-existent entry
> 				continue;
>
> 			cond_resched();
>
> 			if (level > PG_LEVEL_4K)
> 				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
>
> 			host_rmp_make_shared(pfn, level, true);
> 		}
> 	}
>
>
>> +		srcu_read_unlock(&sev->psc_srcu, *token);
>> +		pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
>> +		return -EBUSY;
>> +	}
>> +
>> +	return 0;
>> +}
>>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index d10f7166b39d..ff91184f9b4a 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -76,16 +76,22 @@ struct kvm_sev_info {
>>  	bool active;		/* SEV enabled guest */
>>  	bool es_active;		/* SEV-ES enabled guest */
>>  	bool snp_active;	/* SEV-SNP enabled guest */
>> +
>>  	unsigned int asid;	/* ASID used for this guest */
>>  	unsigned int handle;	/* SEV firmware handle */
>>  	int fd;			/* SEV device fd */
>> +
>>  	unsigned long pages_locked; /* Number of pages locked */
>>  	struct list_head regions_list;  /* List of registered regions */
>> +
>>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>> +
>>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
>> +
> Unrelated whitespace changes.
>
>>  	u64 snp_init_flags;
>>  	void *snp_context;      /* SNP guest context page */
>> +	struct srcu_struct psc_srcu;
>>  };
