Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1B42C036
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhJMMlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:41:23 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:30145
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230219AbhJMMlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:41:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAQylkGq6yUha40cVMOEGyg6oYmArdgaj2mHVxY2HBpSviXBvunGPPIMmvsuy92gNklT1cZ82VgQuzJxunajwqhgAkzNnPsdI4zZ1ZJKOeYsx/ytbkqLIZk2e2Hago7qAqV4jPdri8Z1DTQjuNRNaonjgnUw3qcYSad/5bNXQ2xHY6tQLgFHIrYb/fDr42sQW9j3hv53kmQTtv5XN8E73/OTnaC7XO/PU84S28jQllcEFT6cfRppQxHHOIAqzI+nHDGCgUv3l/7cM3azLV8bPtOG8JKY7NV70jt8iqJ9aPTwzc6WPC1649wuOwoS3+XFHb1MvYZ2BCmPb3QVd9+EWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I67XC3c9y9oPJu5st0AlnpJEdPuAxJ88EfywpzGTMTc=;
 b=AyFvsu0mMODf9rdpO3iEXJgPRwKkRF+01ooyhGQaeOYVnDW8ZFyL4VG3aBC5Jj2XDETAFScaVjhcV6Gh4X8V/N8dOaZUMFSt+4tfv+AUuhb+1p2MySJrk99AY/bzaGAiq53tmfFT005o++ewHrpzlY3lacDxwN1R5cTxQcEsbkjIQ9wOW77Gyt+LhKdXlWM9WtbToVeQ4ojl0M0Syjrig+0FtuvCugB/5xekR/ZMxIh1o5dSd7jp+ILzOyfCm/DHuepEZhswJlpopY2YPUttcSwSYbOdvesn2rSt7sPghgSaprkVR3WhensRJEC+uLYSfOwzjN8nMfr2Uw/KGGajlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I67XC3c9y9oPJu5st0AlnpJEdPuAxJ88EfywpzGTMTc=;
 b=E884oiw9jy5Sgux6imt/sAjaCqV3diA5/yAJLhynHs3o6q0KMCPX+yzG/n+OT2qsJn9bsdm0S+Pj3z3Q7XdmmSJYOtU5YmLDAMdy1wK42me0rkmzDgXG8Rx4mxWSamJcfpRKJ2gQOcYUgPGmGgfzqfLAQC2WXUNHY41NtS2g7RE=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14; Wed, 13 Oct
 2021 12:39:16 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 12:39:16 +0000
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
Subject: Re: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-27-brijesh.singh@amd.com> <YWXYIWuK2T8Kejng@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <2a8bf18e-1413-f884-15c4-0927f34ee3b9@amd.com>
Date:   Wed, 13 Oct 2021 07:39:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWXYIWuK2T8Kejng@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0401CA0015.namprd04.prod.outlook.com
 (2603:10b6:803:21::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0401CA0015.namprd04.prod.outlook.com (2603:10b6:803:21::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 12:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 566917fb-f93e-4c07-6bad-08d98e4677c6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB251288F2934BA4BA88F73714E5B79@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IdN7urlgJMjuaVm1Y/Sa6bQPoMsy3rQvyqxnKUF2UgRLDnY1EXI2BwLnrNHDPkWwUUk1fXtMDoohPc6vfKWRwxJ7BLYit0v0R8N6n0eHK1MOU7kNBwdc+55bPDSa+AGq9HIEDCv68+oXUcn1qFa8A1WnK0/QbW/OymZ59J5fLbPYx4jXcyHjIyJwDbsKGjSWRIjMUazXWyLSBsa/C+EppFvzOT9DNS/EkgBmkPTnHPrWQ8EbKYHPX09QIwxUYRhxxJcFR60x+kLIhlF/rsumqaNj+C9DUEMPrb2xbxCGXU5UQI3q8WEqFzVdGNBEv9frnwU/J8DukpZMPCKH+lrRIG6fljCeIm5ot8NQIUUpeZcvCiwF01Kkq64TpkCtaYIen4HgJ6u6JytyG10T48+KlNJwOP63zisjvsn3e/sLsppKZdC4Ru/fcFhpAO7KS/3YUznYr9EV6xiMi/d+9OShMrTW9Pvq5SoIYdR6hyNDW32eas26UABoO4NXPlYvyZk5Mf8FWtnC47onOnTQD6+SirE7ua59BDIUuUARDj908ohX9V5XMNgI2g6Zt1rbrLplBy4zPQMH4e5wIFzjDfeXH2R3jrRtGuAVFDIOVyxRsHOP7Hl+kpNAIzigW4vCoFd8DFYRpuZP2fq/hYCO7WZStW6uW0ZaASDQrxibHbIHkgbJrtuzlvT63ykTIaRC/ykjwkX5tIefItAVC6i/Z0WN1ISTvLuCvvCX4XId47S6p2zERDVxHVq8BfuX7D/fHSkK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(8676002)(53546011)(83380400001)(7416002)(26005)(186003)(8936002)(38100700002)(66476007)(6512007)(66556008)(44832011)(36756003)(31696002)(508600001)(6506007)(86362001)(7406005)(6916009)(31686004)(2616005)(2906002)(6486002)(4326008)(956004)(316002)(54906003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHE2Y1RSbStwRFh6eTBWMHlmV0plckZFelF5MHhDcXN4SWl3YlRiZU9KdGE0?=
 =?utf-8?B?c3hjT2Z1a2VDMWdlV2dYbVl6bU9xWDFIckVIVzdxbXJmS0JwSFV0UmQ1eHpq?=
 =?utf-8?B?eE1mZGloMXFDTklVUlBKK0VVaktOUjF0YzUwT1A5ZXpaaWNscnZVTkJDQTNC?=
 =?utf-8?B?UnFya1JKNFcvSWhJZjBPTUJCdXRndlFLdlNNRkZhSlJxQ2czNVNjQXNGRHZp?=
 =?utf-8?B?MGFoYXBobSszdjg3Vzk0eTBSbithaEtEQmVkN1lEc2NBbnVRcmxGd0x4LzZQ?=
 =?utf-8?B?TWkxeE85ODVLeVlPRlVyRnZvVzR5YnpWYk9BVDJ4bS91TlptK2djazlLWTlI?=
 =?utf-8?B?bTRVNXNYU2IrUHltZTFMeGY1YUdTUU4wc25KUVlKL1U3d0twSEVkRFJnSElN?=
 =?utf-8?B?QURpczd4Q2NMaEoyc1dSOUxPN0F0Uyt6R2xSNHN6dWxWWkVqQzhNQ05XTjA4?=
 =?utf-8?B?d0UwK3VoQ1h6R0U3L3B4VjB3RHB3M0h2d0JQUjBqK0M5QStYeWlGK3Q3Yzhz?=
 =?utf-8?B?djFDeW9zdGwwY3hDeURMOHdaVFMyNjFJcXZUR285dExFMi95a1hwdC8rU0Yv?=
 =?utf-8?B?QVduVHlZNm9yUWtJcDhTMkIweEx1U2V0dThEK1h0b2F0eVo5bXMydEdnMURm?=
 =?utf-8?B?S2ZzK0F5YzlzNmJtODIyNG94cWw4RC9HcTgxc1ZUdllxaHF0ZWxsbFVpWUFK?=
 =?utf-8?B?ckpLSVg1a3NvZVBwYzFJUkdVYTVOMXZ4aUU3STlZaVNJT05SeXRmWFNOWnFv?=
 =?utf-8?B?cjRZNUFFbTUrQVBhWjFsSm9yQXJrUHA0YWZlbEJlSCtocFAwampMK0lsSmVR?=
 =?utf-8?B?WllsNC9tZzlpNU11Q3Vvc2t3dkxicG1sRmJnQ0hJTGxqc3g4MlhUa0tacUl4?=
 =?utf-8?B?djF1ZFY3MjRTcTNHMmx3MXBKYjF0cDVJSnVwa2FSYkl4bGtOb1JKT284STlC?=
 =?utf-8?B?MDVMQ2p5YmVyTFNjZGcrbk96VW8yL2l2L0UxTlZpQkQ5MjRKM28xaUV1Sml1?=
 =?utf-8?B?SWpVd25OOElTMXl2c0NyK2xBNXN4QUNtOUZZYkRsMXdNZ2VNY1pFM0JaTGRw?=
 =?utf-8?B?bjJxRFdjWHM2T1pscTUzUjFRRE9wNGd5MXhRMnBDb2phYWdvM0x0bW0wbFlh?=
 =?utf-8?B?SE9EbnVGMVh4T0hzNjkxc053UUdUUHpDM2Ira3JVUHFrbGFTQ0dBNHd6Z0Iy?=
 =?utf-8?B?ZStqK0RuVFY5VE1pbFhTM3lkVy84SVB0SVFxdCthbnMreG9pc01iZTZHc29m?=
 =?utf-8?B?eWRXRkF6eFBaeGgrdndsTGhCbzdsQlZZTDZsQjlRS2xSWndGN0l5OUlhOElG?=
 =?utf-8?B?bXJybm9SUkxiTHNJNy9VcHZ0Q09XS3NxMU50WmRNRm9mYmNlUHl4a1h2K1ZV?=
 =?utf-8?B?Mkw2aDAybDRXTDU2TUt0NmdRZXRPR0F4eTR6NGFUWTlVOTQ5azhrNlNxY1Uy?=
 =?utf-8?B?RXdRZVdCeGs1KzVNSnFsbkVOam5RZzlBWmQvNmx1U2NjMXNIUEZpOHowOE5S?=
 =?utf-8?B?Tkd4OXFjbXZqV1VmSUNiUmRONnZOTG8rajJ1R1RBV0wrY2hlNVZ3TWJDSHJx?=
 =?utf-8?B?a0pwajVuMi9FclpOY1VhY2R3V1JsUDcvc0Y3Ny9zSEtzc0F1eDNHMVVncnlk?=
 =?utf-8?B?ZnlKbjg0R3hwTEVKZVJoRmNQeGZNYUg4VlZtVm9ueDBKKzIydmZnM0Q0Ym9s?=
 =?utf-8?B?TWxBTVd2R2ZudnlQNkYrbWZZYVVaK3U3WW1pVGVtUkh6bk1HSzA3WmJCQnhK?=
 =?utf-8?Q?GcPVoOtyyi22eo4elPQjxgjEiET7OuHHzpiH7g1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566917fb-f93e-4c07-6bad-08d98e4677c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 12:39:15.9892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7rxHyR5WtL5wFe/VEPi8Wr+0mFinC3qGh+YOxnCWBd/9j+aJThh4z/sEJ9aGM861olVWhe8XbD3/d20N4aetQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/12/21 11:46 AM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> When SEV-SNP is enabled, the guest private pages are added in the RMP
>> table; while adding the pages, the rmp_make_private() unmaps the pages
>> from the direct map. If KSM attempts to access those unmapped pages then
>> it will trigger #PF (page-not-present).
>>
>> Encrypted guest pages cannot be shared between the process, so an
>> userspace should not mark the region mergeable but to be safe, mark the
>> process vma unmerable before adding the pages in the RMP table.
> To be safe from what?  Does the !PRESENT #PF crash the kernel?

Yes, kernel crashes when KSM attempts to access to an unmaped pfn.

[...]
>> +	mmap_write_lock(kvm->mm);
>> +	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
>> +	mmap_write_unlock(kvm->mm);
> This does not, and practically speaking cannot, work.  There are multiple TOCTOU
> bugs, here and in __snp_handle_page_state_change().  Userspace can madvise() the
> range at any later point, munmap()/mmap() the entire range, mess with the memslots
> in the PSC case, and so on and so forth.  Relying on MADV_UNMERGEABLE for functional
> correctness simply cannot work in KVM, barring mmu_notifier and a big pile of code.

AFAICT, ksm does not exclude the unmapped pfn from its scan list. We
need to tell ksm somehow to exclude the unmapped pfn from its scan list.
I understand that if userspace is messing with us, we have an issue, but
it's a userspace bug ;) To fix it right, we need to enhance ksm to
exclude the pfn when it is getting unmapped from the direct map. I
believe that work can be done outside of the SNP series. I am okay to
drop snp_mark_unmerable(), and until then, we just run with KSM
disabled. Thoughts?

thanks
