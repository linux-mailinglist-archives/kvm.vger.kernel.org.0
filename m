Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A266A461A3A
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 15:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348900AbhK2OuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 09:50:19 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:20832
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351431AbhK2OsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 09:48:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7jc5Pf1O+/FrpdwuqWbrFY/bXkprR7NqVLLC/B4YWi90eH8RMu4oo/KDGKGAweVLAKQ3bIgzZQLSTi/R3Q2QtsveN4QuWDtldwKp4NMzBuywgkRw0GiPgFH4uQLVBCS6xZY7DqbzU+QHIOEs58KmrE/DIMhbE9Eg/fo1U3Ot2p5XoHZQrVH2cIbOMiuz6oizTwEjGErj3nacevSJUmxu9DRBQYn5NOQ43pWk6k9SZDoYQsGnz+JG5ZndnvYowFFvSN9FesRF9GQMsyrLBjxKW3iDjEKlLYR/j7fvh9ashr49xmuhIuYyaXvtUXMRnb3doj/zfzYurBvy/DsSvtCsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mEtf7Q6MPRT2cTb6EXT+BOkpnCUPCEIP0dZL216mHo=;
 b=LtiVwYooOX3Jw842CKLeNZaZR7OYHJws/fuc5UHi5jK98CbFJJSGvQeMOx7bnMBM8Fq/TLTAyMxA8J/OBSaXTzcj5gX32ErAc6wapp8E12k6rageWavH7jhQnEnaOo5g9lSqTukH15g/ys3RvQn4jL+LTuEXPHwhVXCmkAbsQBo3r3uyJNOERKHodyvMIIgiKBm3YBATlFYumBikE8nXoIjgZgto3OOxCBjDQgvnxWVLioB21hy8RbP1PivUO+PAFvN9zDeEhXX3DRwR+3Hhu+XPBVtqgriAB8VgYKl8lxIad5IGNGCCSIWYLAx1qo808iOgn4RCCAXMp2MnvkefHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mEtf7Q6MPRT2cTb6EXT+BOkpnCUPCEIP0dZL216mHo=;
 b=FpgZ1tavMnJ7o9sTxR1sFOtCx9Ir3QeeYqCNbbId/ZG3QRxlE+aflLrL1zt//uO+wlKiNHWXYvoEqfiS/8yW2ahzc5mk2vTSnU/O4tV5wVAXBB7f5cORP2dT9Rs9yByQxv3hfJz/Xw0hWv36r8sCmohF/DtIvd3+iCljVU6X3J8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 29 Nov
 2021 14:44:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:44:59 +0000
Cc:     brijesh.singh@amd.com, Peter Gonda <pgonda@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
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
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Joerg Roedel <jroedel@suse.de>, Dave Hansen <dave.hansen@intel.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com> <YZ5iWJuxjSCmZL5l@suse.de>
 <bd31abd4-c8a2-bdda-ea74-1c24b29beda7@intel.com> <YZ9gAMHdEo6nQ6a0@suse.de>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9503ac53-1323-eade-2863-df11a5f36b6a@amd.com>
Date:   Mon, 29 Nov 2021 08:44:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YZ9gAMHdEo6nQ6a0@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:208:fc::24) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by MN2PR02CA0011.namprd02.prod.outlook.com (2603:10b6:208:fc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 14:44:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e45e1f5-249c-48a5-e6e8-08d9b346d124
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-Microsoft-Antispam-PRVS: <SN1PR12MB254154C3013720695CA794ACE5669@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0UjbKCB038KKYSjG7IXJhijz4UPweSrfOAUGbxRBaZlE1A3M1yTke8+qRQGUmlxX1UfdDhfPFmRRcebxEvVVY5PvsS1zlbCle4nkk3dXYqtUgDCW54G2PcpkEmVxvdfMNcm9stpScr5gaBugyDGdxIcLVy8TSRhRwunJcWGPs51wo7LkE6zQjxGJsPdH+upZm7WbIl3FBfeWVbtiAGIZpj0w2EKhH7332CWuIFyYgh+oa4FVjRSfVhwgG0YDOMUQvjKv/Wi7wwur/OpZ6gnmghfMIrYK8enLhb1E1UECvR4tJMvl7u+1l5+gm6clFgYAxClgbc+ecQx39eZuyTxkaXsmBVou9Kfv3sfsCFbE3wfxttnJX3hjxPKreBxaCzIQ3DI596+tscO39OC1bivg35COwnBPijGKp9LgJD9mvrRofigFybgoX/A9mXhpR5XU99Un9ZkiJ5v3JKlJIBW7y9muipaKRzQ/Vb2sibKNqffR+MjC5aJ/NgQYsBYPOCrB6DLlXlqqwDdmoyD4qginET6+xFa1TZ6+zyclbJNCkxE0bs9RZmQ6/sRGwFxe9VPOHYFs4pskviR0DudjlHBiZxW+Q2joOqZzFJa87zobgDou3YOtnpT9gW35+7s08KQFZJZf4INTLizPJWFfS4D8m7pHjXoNKY0ZlojRNklqQGgCqKeQAyJDVqiW97qMpHpfAVslO3VGcz684wU76mGHVGhiLFpUc4Bx8GqG7t9QOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(16576012)(66556008)(54906003)(7416002)(4326008)(110136005)(316002)(2616005)(508600001)(8936002)(66946007)(36756003)(38100700002)(31696002)(5660300002)(44832011)(8676002)(7406005)(86362001)(2906002)(186003)(956004)(53546011)(31686004)(26005)(83380400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDhIYU02dVh3cWx0WGgycmkvZnBwakJMZC85V1c4bDZHSXA3UkVaTVVxOUli?=
 =?utf-8?B?d3FDVHpubmp5OEFhcFJBNlVBWVh1R0ZmYU9iSFFRRnhjNHhzUWovQThyQ2ZM?=
 =?utf-8?B?RXZNQzU3U2ZHaTJ1RVN3aGpBYUFldkF1RnZ3R21MU05MOXAvQ0JGTDdJemJn?=
 =?utf-8?B?amNjejE1ZGhJNXZocUFWZWRNUmtlSUZlVUtlMzJZK012K1RvTU5MVGROZVpO?=
 =?utf-8?B?aFVDRjV2eWF5b1dSZXVFZ0VVeFpURXlJUDRWN1kyOGJNVEZNNTJ1cVNZWWFP?=
 =?utf-8?B?Z3lrQUVvaWFacnhzN2ZTRDg4YTlZc1JlMzhBUEpmb29WcEd3QXMzS3ZXeEJr?=
 =?utf-8?B?UWZwZW9TVmpUYXJGMVlVMG5LWUduZXdQOVJPaTFseDZMMGJpK0xwWVF6Q1Bj?=
 =?utf-8?B?R0NCZk1vUjJrajRzSDduYUhQdzBlQ25HRG91cGpvdG4veStUdVlzQkczV2Vp?=
 =?utf-8?B?clFvaFRCRnQ5WnJFemlMdHo5Y0gwYUNwdzNUeXBiSWx3dnlsNWpSRXNHSW9T?=
 =?utf-8?B?ZmtqTVJFOGhVekRyWjM2ZEhxbTRuRVg5aTlna0lTOXVIQ09vcUtMTjJrUXNp?=
 =?utf-8?B?MGlsNnA2WW9LRGNabW5UbDhFT1d6Z1Qxem1velNhOHFTRjRXNkdEb2Y5RjFT?=
 =?utf-8?B?OE9YdDF4ZWV6YWlWTWdlUHRpdmYrNTQrSlROSkQ5QmJjUEs5VFBrTThZU2R6?=
 =?utf-8?B?V3p2dXB4czB4Smx6ZzJ3Y1ZaYXIwaC9XUnpzTUFCYnNmTXR1ckw1eU9VTVNy?=
 =?utf-8?B?UE9GQjZGS01oUDlHMDBXSmdMazJFOGVFNVg4RkIzMXRiYkpKSE14SS9WMkhz?=
 =?utf-8?B?VWpzcU5nRmg5UVU4TVVjYloxRTc1bWx2ai85T0FhVHdvSGRaTmJLMWlXOURj?=
 =?utf-8?B?cEttdVMxc2k5Vkg5TVpVM1dwN1dKTWRaaUxsN0grSnYvY2R3bEw2RmJDZ082?=
 =?utf-8?B?RE5XZ2gwVTNUajN1Z3NySko0V1hzMUh5TndBSWhBcERIcE1rZGF6d1UvVnVX?=
 =?utf-8?B?TWxEN2YyaVA5RmFpK3RadDZ3SXZDc2pPMFFnU0toV2h0c1ZXZ0taT0ZzN2U4?=
 =?utf-8?B?SXNaWVlaOWFieUhnVVJUSDh2QmU5OGdUT0JRcXFyeTdGdEt6UmVqTjhaVTVW?=
 =?utf-8?B?Yi9RN1FHbmdIQnJJYXRvUzAwU2tuckJINS9nSzhEMm9yVlVpU29NMWRjbHdC?=
 =?utf-8?B?d0R0ZGRkV084SThBcFVqS0pxMXZnTmk0VDNRWFdMeWNycGdhQkQyU2dJZFUy?=
 =?utf-8?B?b1htWWIrSjQxNG9veVdmbkVqRXZaZW9FWjZCbGpZQWNjcldremJjMDU4QUFL?=
 =?utf-8?B?UFFKMzJOL1Fyb2l1L0lBd2Q3VS9YSGhJeWVrdTNMQTk5MVJwdTNlWnZxWHo3?=
 =?utf-8?B?WnpWckpIemJxL2NJOFd5dkhYclN2NTBWbnFJYXFhaTVFRVN0cG93MHhYcS9q?=
 =?utf-8?B?TmdJRTBnYWJ3SFZjZGVLN0JKQUNqOGFCcXM2QU04bVlwVlptMzR0MzNoYUVu?=
 =?utf-8?B?NW9RbThzQUVLdlBZRUlUd1UvMG5sZGdtZWtJLzNYZStwRU1Bemc0clN3Um9I?=
 =?utf-8?B?eFl3MWpnY0dWVlhobTlQd0M4Wmh0bExjamdCK0x6aVFvc1kvSDIwRGNDamhQ?=
 =?utf-8?B?NlV6U29IU1VEMFYwK0xWY1dQZE1LOVlEdkRvbmNqWWFCTTU4NWV2OTNGR282?=
 =?utf-8?B?MTB0b2pEVmxjNXBiNEZiUXpvb3ppZkpyUTBVWTJia0dKUTFyN0ZpcXd1VzN5?=
 =?utf-8?B?eTVIdTk0aFBhZDlObHlncTVCTTlaaENFemZPc1pvbDNYbzZLOWVPZHR5M2VU?=
 =?utf-8?B?b0RDSzN6MzQ1dDNTbkx5dXRveDFibXlIcmRvMm1CZ01JQnd2T2lwYlJMeVlB?=
 =?utf-8?B?Z3Q0VGRFU3phbThkaEgwUzhHb2RCSnlnaVU1NW5lK2lXeUplQ05xU3hKOERN?=
 =?utf-8?B?a2RCWEhNVy9PUUlyeFNTZTFpalVqWkRZYUhJUVlGUUhiWDVYdlNaaytuT21x?=
 =?utf-8?B?RTUxT3hrYWF6enRsUTVJUzMxejNtUStBcy9vUDdaQ00vem14eDdTYnR3MS9V?=
 =?utf-8?B?Q0xXOEJSdDhRcE8rbUl4MElCK05BN1A1TVBreTFwMHFhMFVSNGxYS3VmWkZR?=
 =?utf-8?B?ZlduanUwZUtIYTU0U2pWS2w3UmxDbDdsNlpLS2pKN3R6TFRQeUFYV1Z6cFBI?=
 =?utf-8?Q?4wMc9MEC0g7ecsgdtdG4j98=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e45e1f5-249c-48a5-e6e8-08d9b346d124
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 14:44:59.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnRT5dbS2AbvapWZl0UBlsFMmLuhU6Y8JfysKbSHtHU32hrYzRwb8GNmijNNfxvATEiBx/pKembRPuGzsGtx9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/25/21 4:05 AM, Joerg Roedel wrote:
> On Wed, Nov 24, 2021 at 09:48:14AM -0800, Dave Hansen wrote:
>> That covers things like copy_from_user().  It does not account for
>> things where kernel mappings are used, like where a
>> get_user_pages()/kmap() is in play.
> 
> The kmap case is guarded by KVM code, which locks the page first so that
> the guest can't change the page state, then checks the page state, and
> if it is shared does the kmap and the access.


The KVM use-case is well covered in the series, but I believe Dave is 
highlighting what if the access happens outside of the KVM driver (such 
as a ptrace() or others).

One possible approach to fix this is to enlighten the kmap/unmap(). 
Basically, move the per page locking mechanism used by the KVM in the 
arch-specific code and have kmap/kunmap() call the arch hooks. The arch 
hooks will do this:

Before the map, check whether the page is added as a shared in the RMP 
table. If not shared, then error.
Acquire a per-page map_lock.
Release the per-page map_lock on the kunmap().

The current patch set provides helpers to change the page from private 
to shared. Enhance the helpers to check for the per-page map_lock, if 
the map_lock is held then do not allow changing the page from shared to 
private.

Thoughts ?

> 
> This should turn an RMP fault in the kernel which is not covered in the
> uaccess exception table into a fatal error.
> 
> Regards,
> 
