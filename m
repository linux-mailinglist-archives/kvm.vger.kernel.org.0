Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E32371EA8
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhECRce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:32:34 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:61234
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231635AbhECRcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:32:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVn9NiSizuqy+Dyp56oVMSrHhNeA6q5XMOOxS/7U4zGvtV6djMmbxh5YxGj4eHLRBWdy7MojUiC7Uh6XDNHzydz7tcG+ygOObTAZHgsJKDy/6EkSpmrmEF7vs5X1KZndFYeqNBj4N2+nC/hilbG3SM5qMI9bXBI0eRqWpMskco1J3vSONESzpBLdvF8i10+0RvRDxKnf+ijspkiPz/26G1gBJFGtPPnhdjw6X/qc9nZMDtSqfRX2/6U35FFC8UCMeHxpySk97wmCJAphKgrpEuUexjBx5QRM+d4qvdzWtvMYYKm6LRgS7jtzMHEqMQoQ4XeTs3Y4uoTFOEMQ7SKEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/i7s8vDNOpN02jIYVlCf3PqFWtI+YOJeEJYtrDK7hM=;
 b=MZl34GM1VQIjD1DdsvA/Sm0xHzqqZAKDtYKJv5jVyYfPRDnixC0gKkDgFXCvt//yKn3ehjIk6FoPsBF2GXhms3vU5gdN8xal1ilPRxdBYKmIlHy+oQY7pfbO0JXoqeHSHsx23cKsQAjmq9/lY8GZ8TFfVdoS9PdV7TXdChH8lm7jn3HDxD6ftxim0tPQzF+f7xcAKtZ9/8hiXVYoI9HZdeZql9oy6VcYk3zlMa0jf4UA0MazBHoFhtXsRFQUsUD+SJaCROOkJO3SLXCFZTq7ir6M/lywcBv1+iOSPgozcwXh3T2fiw84p6UQX0R7BBglQ6M4TIUiBqwC+RdBFqcXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/i7s8vDNOpN02jIYVlCf3PqFWtI+YOJeEJYtrDK7hM=;
 b=L2SHQtQNUlQ6R5Lxr0406hqRJsZL30pLxXAiZuxpZqAwYudd9Vg/5Q6cXkQaYxHMALtRJpFgtFYSyjf9FivK+0CC/XSLj70LnTEh/NlDSQJ+Tq5f41kQZek++meSsMZspdL8y2X1VCy48AQfq4J2+pt1t64GmYjH9zGlM11HdhA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41; Mon, 3 May
 2021 17:31:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 17:31:38 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com,
        mingo@redhat.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
 <d25db3c9-86ba-b72f-dab7-1dde49bc1229@amd.com>
 <8764e6f0-4a2e-4eea-af69-62ff3ddfe84b@intel.com>
 <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b95703e1-a4ce-52a9-c08f-bcf6cc65c129@amd.com>
Date:   Mon, 3 May 2021 12:31:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN1PR12CA0064.namprd12.prod.outlook.com
 (2603:10b6:802:20::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0064.namprd12.prod.outlook.com (2603:10b6:802:20::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Mon, 3 May 2021 17:31:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db3a632d-a162-48df-f496-08d90e594e90
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451291704424EB465DA14AFCE55B9@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGVI8J3J8Cpzfvm59shDn21JG9uKUXW/k4twRNJBgpBCjgIPn0ZtrSNbXqphhpKc6mvUmizuXVv/xFE0ckn6dFSciiD0O8ra40a2K6K9lA3ISfQxisreqCtjkHeSiRFcHPdls6zpfCuuovD+zjwO635lyFOpTFUON38FHEVNhEM3EaDaF2N3q3eImWwxv5jb9RySrGaN64lAS4qt4Ifnv/sSsJNweVZkO57NKSe7gZMokuDUWUwGCJW6Kwzwm+Baa5/lfBMPxN1708R0gGpCF/H4yuYHF+4EC7lKCxhHPZ8S0yN2y4JfO+BZaS8zN83YRGPYcg8TugJzX03MVNEoLMP78eSsudI7ocNI+EBM8uRB09qJKRaHlGiy3AUXcFkJmROwN1j5KKKJ5Q36DURI7lR4w8YHGnzO8EJVTHABKpAQ9FlVxvs33X7U9oskXZV/bkTaajzS90JKoaWNmALCEr4tuAGhBUli8Eg7z9SKosXgrj3kEWDt7aOA0LxPrvSQSffBYQJ/LPgCj4nX+FZ8kllLCh+K7WnijahjqAs9AQP4JiXA5sn/OPYOcCI8N9Ql+KSRHxRQU+TjqIlri01lYhjcocSboE0JXX1jWLKSWb/rmn9pweODFOvQpWGztN3l1oM1+gvHTbfySPWXx4ddINiPBsZsZFjo6aOwkueLB/S+2MgWZA/4unNxyH0wyzacKD1LRY4ZR20D7V2Na9/ZBu8apjcmPSPgHkPqqvJYtRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39850400004)(366004)(26005)(478600001)(6486002)(16526019)(186003)(2906002)(316002)(4326008)(36756003)(83380400001)(5660300002)(2616005)(44832011)(66476007)(6506007)(53546011)(31686004)(52116002)(31696002)(86362001)(66946007)(8676002)(66556008)(956004)(38350700002)(38100700002)(8936002)(7416002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bjFqQkxSbjZpdDdPd3YxUW1IY1VjNmsrMmxWZzY1MEF3SHFMN21CQkNSeDNm?=
 =?utf-8?B?VzRuVDczRWMrN2YvNjNtK1l6YjNLZDB4SWhlZTIwcDNqZEorTE9nZmRESHdJ?=
 =?utf-8?B?THU3ZFJjeVdmNDBrdmg3Tk40cGQzTnVyaXV1TXJ4T1gyUFFSZ1RSWXpYVXFE?=
 =?utf-8?B?eE1nOWlNRWM1WnRVZFdYSUVuSi9xTDAvMy9vblZJWXh2VWJyYko0V2lyd01o?=
 =?utf-8?B?WDM0bUwxR01qQjFkbFk3TlZXZjdRRW51YWNzdXRkV0ZCQXE1QmREWTRTQTlR?=
 =?utf-8?B?SEdnRi83SjlOdExlQjYrMUdRalluR0syUmR6bmg2bi9RcVdGRHBIaHVNRkhw?=
 =?utf-8?B?a1ZBZzhNV3BqZHVxZlpQcFhNR1N2dkRXMy90bkpTRHk5eVpJeHIraFhjV0Jm?=
 =?utf-8?B?TXhpKzA1aXdqbkNENExGZnZKMCtxMHlOaEV0SDU0UVNQdXhqYTY3ZUdxOCtS?=
 =?utf-8?B?V05JTE1neVorTVdra2xBcm5WZjA5WHoveFJ3S0ZVS056T25UYmtzYVRQdzZv?=
 =?utf-8?B?VW1wYjV0RGx1enpMMjErZjBVbE4rUTRFbDdseStZNmFpai9JNnB0OE5HTmdl?=
 =?utf-8?B?dzFHTXZleXNEYUpmbzh5ZEx5bUkva1NtN1ArUm9NZmdtWWFlTVkydzdrVmhu?=
 =?utf-8?B?Qk1Kb1NnZjNlSExkT3pHcVgvazErZlVCMVFCdnF1dDlLRDR4c2tua1Y2UTR4?=
 =?utf-8?B?QnJQc1hyaXF6SG5XM3ZKV2ZTV01Id2JDV3FZL3hYRXg1MVpUVDhCR043WjBl?=
 =?utf-8?B?MTEzdjljNmdlSDdCVll4c28rMkNzQmhha3NKSXBxOXcrV2dxemt2anQ2SGsr?=
 =?utf-8?B?RSt4Wnd3RFVTelhtMEtiaHkzSjJXcGFKNXR4U3p6SlRTNnlMdDVBR0lMNkdF?=
 =?utf-8?B?UG1aRFdVbVRRb0JZRVZlTkpIZmdINVp3MkdqSUZISlhUS3phMDc4bUFNOGxJ?=
 =?utf-8?B?RE1QcVBBVGdyN2VsQ1lOeVNXVnBhdDVlZ1RreHptQUtpckRiMTNwanVWbWQr?=
 =?utf-8?B?UmRqeC9VVlFocGZZV05wTnFUc1ZaOXVZdzBrZkVEM1UvTGVoQ1R1SHVmWk1q?=
 =?utf-8?B?THZwOWp0c3dVWkxjREVYcG40ais5bkFhVUQwSjdEV0JyTlFSdEx4akVoRktV?=
 =?utf-8?B?QVpUMlN0V0NGMjBZcnRwRnZaOW1pekNVQk11Vk1UZzRJSSsyVVBaYjlKcWZL?=
 =?utf-8?B?Zi9GVit4MlRyYTE5K0Z0OVE3Q2hKamxsSUpkZkthOWJKNWZOVlRpN3QrVHFQ?=
 =?utf-8?B?Vk81WTloU2krZThYSFdBK2lxOVhLL3Y1NVFwL0p2R2V2TDl6VFkvd0txZTFo?=
 =?utf-8?B?bjNybG9SbzJQK2RuaGk5QlFKYVgxTDcwU3FUcVkyeUs1RnV5K1hvMTV4U3Fh?=
 =?utf-8?B?OUJxZnhnOUlVR2NOMENvT29CdGJjSXJub29kUEF4L0RYVmQ4N053ZCtrVTBB?=
 =?utf-8?B?WXVmcEtxK1BoTE5HLzF3Wmk4SFRKYlFHSnlHYlhJOGRIUzdiN21KYkp3TUVz?=
 =?utf-8?B?Vjcwd0MraWhNUjk3TU1QRHg0Uy9FeDhBTVZiVXJmdm5Sa2R5S1h1RCs5Vitx?=
 =?utf-8?B?ZGhEdHJRS293eVEzZ014bnhtOGc3U0hwNFBhTUJRZlhWYnVYVkljYlFlV2h2?=
 =?utf-8?B?TW1hNTNNSDVEN09DbHNKdWp3K3BHTGIzWi9TTlVPb05OaG5jUG84Smtmbk9B?=
 =?utf-8?B?bklTaFB3Y01VZWE1aGg3cVZCVGxSNU4rWUN0SVZ4RHBuenRhRi9HS2xXb3Bp?=
 =?utf-8?Q?E/FLA4Os2guOhoG9rsu0uHRDLvWQKC5zJtegGSm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3a632d-a162-48df-f496-08d90e594e90
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 17:31:38.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txHMFvmt8WHr1agS8jPRodyFZhRs3wybGZtcSmvWw69AoSCbicVkBAOqjJB4xZ+cagC+9Bk8e/tUbWtU6MlNAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 12:19 PM, Brijesh Singh wrote:
> On 5/3/21 11:15 AM, Dave Hansen wrote:
>> On 5/3/21 8:37 AM, Brijesh Singh wrote:
>>> GHCB was just an example. Another example is a vfio driver accessing the
>>> shared page. If those pages are not marked shared then kernel access
>>> will cause an RMP fault. Ideally we should not be running into this
>>> situation, but if we do, then I am trying to see how best we can avoid
>>> the host crashes.
>> I'm confused.  Are you suggesting that the VFIO driver could be passed

One small correction, I was meaning to say VIRTIO but typed VFIO. Sorry
for the confusion.


>> an address such that the host kernel would blindly try to write private
>> guest memory?
> Not blindly. But a guest could trick a VMM (qemu) to ask the host driver
> to access a GPA which is guest private page (Its a hypothetical case, so
> its possible that I may missing something). Let's see with an example:
>
> - A guest provides a GPA to VMM to write to (e.g DMA operation).
>
> - VMM translates the GPA->HVA and calls down to host kernel with the HVA.
>
> - The host kernel may pin the HVA to get the PFN for it and then kmap().
> Write to the mapped PFN will cause an RMP fault if the guest provided
> GPA was not a marked shared in the RMP table. In an ideal world, a guest
> should *never* do this but what if it does ?
>
>
>> The host kernel *knows* which memory is guest private and what is
>> shared.  It had to set it up in the first place.  It can also consult
>> the RMP at any time if it somehow forgot.
>>
>> So, this scenario seems to be that the host got a guest physical address
>> (gpa) from the guest, it did a gpa->hpa->hva conversion and then wrote
>> the page all without bothering to consult the RMP.  Shouldn't the the
>> gpa->hpa conversion point offer a perfect place to determine if the page
>> is shared or private?
> The GPA->HVA is typically done by the VMM, and HVA->HPA is done by the
> host drivers. So, only time we could verify is after the HVA->HPA. One
> of my patch provides a snp_lookup_page_in_rmptable() helper that can be
> used to query the page state in the RMP table. This means the all the
> host backend drivers need to enlightened to always read the RMP table
> before making a write access to guest provided GPA. A good guest should
> *never* be using a private page for the DMA operation and if it does
> then the fault handler introduced in this patch can avoid the host crash
> and eliminate the need to enlightened the drivers to check for the
> permission before the access.
>
> I felt it is good idea to have some kind of recovery specially when a
> malicious guest could lead us into this path.
>
>
>>> Another reason for having this is to catch  the hypervisor bug, during
>>> the SNP guest create, the KVM allocates few backing pages and sets the
>>> assigned bit for it (the examples are VMSA, and firmware context page).
>>> If hypervisor accidentally free's these pages without clearing the
>>> assigned bit in the RMP table then it will result in RMP fault and thus
>>> a kernel crash.
>> I think I'd be just fine with a BUG_ON() in those cases instead of an
>> attempt to paper over the issue.  Kernel crashes are fine in the case of
>> kernel bugs.
> Yes, fine with me.
>
>
>>>> Or, worst case, you could use exception tables and something like
>>>> copy_to_user() to write to the GHCB.  That way, the thread doing the
>>>> write can safely recover from the fault without the instruction actually
>>>> ever finishing execution.
>>>>
>>>> BTW, I went looking through the spec.  I didn't see anything about the
>>>> guest being able to write the "Assigned" RMP bit.  Did I miss that?
>>>> Which of the above three conditions is triggered by the guest failing to
>>>> make the GHCB page shared?
>>> The GHCB spec section "Page State Change" provides an interface for the
>>> guest to request the page state change. During bootup, the guest uses
>>> the Page State Change VMGEXIT to request hypervisor to make the page
>>> shared. The hypervisor uses the RMPUPDATE instruction to write to
>>> "assigned" bit in the RMP table.
>> Right...  So the *HOST* is in control.  Why should the host ever be
>> surprised by a page transitioning from shared to private?
> I am trying is a cover a malicious guest cases. A good guest should
> follow the GHCB spec and change the page state before the access.
>
>>> On VMGEXIT, the very first thing which vmgexit handler does is to map
>>> the GHCB page for the access and then later using the copy_to_user() to
>>> sync the GHCB updates from hypervisor to guest. The copy_to_user() will
>>> cause a RMP fault if the GHCB is not mapped shared. As I explained
>>> above, GHCB page was just an example, vfio or other may also get into
>>> this situation.
>> Causing an RMP fault is fine.  The problem is shoving a whole bunch of
>> *recovery* code in the kernel when recovery isn't necessary.  Just look
>> for the -EFAULT from copy_to_user() and move on with life.
