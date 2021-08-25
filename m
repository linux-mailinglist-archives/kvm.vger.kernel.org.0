Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822B43F764C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240347AbhHYNvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:51:06 -0400
Received: from mail-dm3nam07on2081.outbound.protection.outlook.com ([40.107.95.81]:41632
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237799AbhHYNvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:51:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/vagrbM/RvmfHhJalLKKIHivSRpq7bfAJ56ZV//MIIgbYnGYg4X/m1CmkyybGQe709HnkdXMaYLLwC541RndXBSYt7tVoYyqdLq/+m+nC/uPP78WSjmkrxSdXOLCY7KJAjYvqtauXal2d/7rKK1hZiV8at2HHnWeVqsKxctoL1yDw7yjdTNEh6dLtNUCmRQUqjNRpVr4FzPH6YX3WvWC4Fk9r4aY/lRNE9flkbwQ84sOqRKNqSf9uXqJbggtA0oBTXLH+bd+nw3V8Jz4Jw3QJd92/G3LH5lPG/v6EDKVFAiS3SMGPEDQ+VIa0Racd5b6oMMpSyw5qLz9V7atKsocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwgJyZjTlByZgyJipd8xiHMYLZhCJeRlNDBEN4L/T3w=;
 b=cBsxwwUSj43JKL88w+N4vnVxPyQPh0Ws+3ui1S6OvqAn3CWtLicpK0zuGc7Z/x563UbyQYBt43+kuuO3x2kmui1t3e8yo6I1ynSB4u2rZFWjvN8K4Mst2K7e0BTQGa5BlPbS74OMi1ifZbFhMdb9xnC5XowHbI+giJgcSize7Fvvb8ZGsZKjSsIZCweapZtRpR+6e9aOXfXJyPRCxpDrgKYXBgU+0kyAURTjLwAOS8sy+zKOVezefrDWzvqukVU4t6Q33f216tAAnyOUFzoNvSJTvbLH4ux7zWQj77FZrEhI4a2GvEG76OgeeFOXWZ2+y/xXOD1E4jTKtD30X2SQwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwgJyZjTlByZgyJipd8xiHMYLZhCJeRlNDBEN4L/T3w=;
 b=uSB0wy9GaK6qv/jLwmsT/SC9cZtB0AUwAE+jFHIO9d/2wpW8eWRUUd+rk8hWUvYNkci1VBjd9dSGJmRnhTO8gJRZnt/4XgdhmuHMv67juwiTdJyELoR9gGf+RoWMcG8ktOKhQpl84x/2gk3cX7/qYX1/6OiHsCAHEXaUjFBlncE=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 25 Aug
 2021 13:50:15 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 13:50:15 +0000
Subject: Re: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP
 fault for user address
To:     Vlastimil Babka <vbabka@suse.cz>, Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Mike Kravetz <mike.kravetz@oracle.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-9-brijesh.singh@amd.com>
 <f6d778a0-840d-8c9c-392d-5c9ffcc0bdc6@intel.com>
 <19599ede-9fc5-25e1-dcb3-98aafd8b7e87@amd.com>
 <3f426ef8-060e-ccc9-71b9-2448f2582a30@intel.com> <YSUhg/87jZPocLDP@suse.de>
 <c5a8f7e8-7146-0737-81a1-1faceb6992ab@suse.cz>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3a82fd1d-c801-840b-afe8-63d000efe7cd@amd.com>
Date:   Wed, 25 Aug 2021 08:50:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <c5a8f7e8-7146-0737-81a1-1faceb6992ab@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.241] (165.204.77.1) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:50:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 605c1b0b-35e0-4a23-9af8-08d967cf441e
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB556868D8FA7760E01A7452AEECC69@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xeLCStfkEf0l7VMbsB/anRekrdE3QW8MA1wkxk2/wNA6W/py7+UA/jcBHeCbkpiA+W7Pq38rBwBETdRPqP7d25hN0/8rKojRkkITXcoao25+8FTwHCaj6ESjlBmQwegQATjtqX5XeYs90Av33cN8JhEPo+cL7fTC6j0YleXrivZYOMaWFrw8B4muu1p8WBSFjozbwTVu+TWIBIvQesEBB6ePJFDemxCKDbhs2tc2rqcf+Q33kYatu/797fsDs8hMI06eoJ/R43tF1y7x9i1FO4J++99d5E7FnruV98Fiu1H7ObG6uhnxReJKSJVzWfvLyfgqcb6fZq7ltPHvRj6yp58IvZz1JtV9tS0WwVtpffjP+0NS+7f5mdfqXUVdxggkNJd7AIlcjxDDgWyN5Vze+KyrRLGwr60Vh7X/zD0gmJ2Z1Nr/gA/rLXB2OsXQ9cB2dKJDelJtYyI35jM8nK+nDfy/+i6X+4us3zANTIrk6kxNcBCUF96TfKXvh1hkwJMkG7INpa2E32W8pK88ROTHexRf5u2pf3dM1+sp3FczoHiYOeiyMFdu/sBBYAAZucD5J3Kvr2f8oZm/Of6/0qwPEAn7KuwZ2r3lwyKO/OLHNLArdy3WsX8BSAtQ1tfa7GZTvDsE5b0rgNiKy3QqM3KIDoBPQHGj7/ANhC65xM60gQ4vEr6OX7orTloYRbGmEQi37Kyd1aJ9wi6WZz8zGvjAZTJRkkz2x8sAwLtvNZu4nF2oEgTU4vXwIhyifbREtw/Nfkqr36uSay70r/BEovSHQPCy7MGq5O0vK13m+ANK7DOZTuwGokTIXa5pBabDVQyr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(7416002)(16576012)(31686004)(2906002)(53546011)(966005)(316002)(38100700002)(7406005)(4326008)(5660300002)(45080400002)(8676002)(110136005)(54906003)(26005)(478600001)(86362001)(8936002)(31696002)(66476007)(186003)(956004)(2616005)(36756003)(66946007)(6486002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: WVvowln/HdWy7KTO+joE9ZFo2xC8XNrkKFZpMYZPLfQZGTogdZprqS+l04ADzE987pHa4fXFfOkp961eCotzgkiYq0wiSVBHBy1Y2kYtX2vMf5pro/CgSQn+IN7/tFelFK51a3QSrl2MvaMtmTLKWuNDGrDcTscUxCltxOzKeX1DQcb6BW/Q4k3f0NN6KNuUiQnfsoVgaROz+zuHGwM+c9F+4THGTQuzAJQi/sS9PF0AlQNFbFST/N1wW3/QeEHJVFRB2OXZ7xye+hUlto/H2tC+RvUObVJYK23BMpOjMUxiBsVWPKX7iD8UgsFdqn5nVa8uTcY3m+YsB55i/4Uph26PNpNmTr+W/4plrkitV1KUZ266jHHqusUQI7wTzPFZq2AkLEysH5N8mwSt7a9A3tLIdMHExdcFqhHFdGLaf0w4p0F3Jx/TT5YHKCBmkDpd690VEEo+fkWIegCkqqzlS5Dg++SP3kRCLwM+ozkbKJ32uAvE6LI0u1Jv6Nswdy4n1ZIjNCo68cl9lug4i0U1Brzaahx8hDLyi3M/odm6VVC6puU4AS5aG9AmIGq214BkFAHoDz37sskgmjd85LGz99n1yuQPaBOV1DPXyxzjrKoooQQlt07lzXgw6PQQdsX6SQZEVQJp4Q9BPehVFLIpECh1769QQeKGO0cHsCrnQ3gwkUW2ilbl/LhG7bAum6DYJNuT6m9r7jJhW50wEnBQCIHgimLduZyvilb0/Bh1FV2zRrcCiT5mQlTj5LxpPFBq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605c1b0b-35e0-4a23-9af8-08d967cf441e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:50:15.0862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOveZbmb+c0NZEHqDgEZOQjBrbwKMnGbk5sWmBb5O4ojIe7n4Rw6HkH+DDyHdd/wYeAXyx2yG6m5kEY29LKiWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/21 4:16 AM, Vlastimil Babka wrote:
> On 8/24/21 18:42, Joerg Roedel wrote:
>> On Mon, Aug 23, 2021 at 07:50:22AM -0700, Dave Hansen wrote:
>>> It *has* to be done in KVM, IMNHO.
>>>
>>> The core kernel really doesn't know much about SEV.  It *really* doesn't
>>> know when its memory is being exposed to a virtualization architecture
>>> that doesn't know how to split TLBs like every single one before it.
>>>
>>> This essentially *must* be done at the time that the KVM code realizes
>>> that it's being asked to shove a non-splittable page mapping into the
>>> SEV hardware structures.
>>>
>>> The only other alternative is raising a signal from the fault handler
>>> when the page can't be split.  That's a *LOT* nastier because it's so
>>> much later in the process.
>>>
>>> It's either that, or figure out a way to split hugetlbfs (and DAX)
>>> mappings in a failsafe way.
>>
>> Yes, I agree with that. KVM needs a check to disallow HugeTLB pages in
>> SEV-SNP guests, at least as a temporary workaround. When HugeTLBfs
>> mappings can be split into smaller pages the check can be removed.
> 
> FTR, this is Sean's reply with concerns in v4:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-coco%2FYPCuTiNET%252FhJHqOY%40google.com%2F&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7C692ea2e8bfd744e7ab5d08d967a918d3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637654798234874418%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=leZuMY0%2FX8xbHA%2FOrxkXNoLCGNoVUQpY5eB3EInM55A%3D&amp;reserved=0
> 
> I think there are two main arguments there:
> - it's not KVM business to decide
> - guest may do all page state changes with 2mb granularity so it might be fine
> with hugetlb
> 
> The latter might become true, but I think it's more probable that sooner
> hugetlbfs will learn to split the mappings to base pages - I know people plan to
> work on that. At that point qemu will have to recognize if the host kernel is
> the new one that can do this splitting vs older one that can't. Preferably
> without relying on kernel version number, as backports exist. Thus, trying to
> register a hugetlbfs range that either is rejected (kernel can't split) or
> passes (kernel can split) seems like a straightforward way. So I'm also in favor
> of adding that, hopefuly temporary, check.

If that's the direction taken, I think we'd be able to use a KVM_CAP_
value that can be queried by the VMM to make the determination.

Thanks,
Tom

> 
> Vlastimil
> 
>> Regards,
>>
>> 	Joerg
>>
> 
