Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A737F925
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 15:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhEMNvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 09:51:22 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:43393
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234226AbhEMNvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 09:51:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6RcXmRrWny8Bo+gHJbA79JEFrMv4uPyBlRgGtpBIIPHZV4HCnR8sTfX8TfWnenXyWDORQPyfBaZgB8mnB8NGbM15D1inyB+YXEtZ1sPDvxfM6xmFmnUkXvM3MdPjQ5ByYnWbRTBvx+25IPAgnmF8WIi45j6PFWzvnThICwm7+7cvWlJN/jJgJJXqjeRikypKB+2QliOhv+uZRguisjKRKogowvl3dUZPZhrlVWdwaLNqhx93i4mVJzJwXHEuHGb2a6OX8/D1fiyGDKNDf0Hfkhsbxld+mijN74omiKMS7B04pSMm9EyZ3j9eozQ1UcMdf9eDLGPsqfIGCs/FYdADw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzOpj4IasZDKUVkC0E2ZzxC3Oaivl8dsE1eHBzxiulw=;
 b=h6SCWeWkg/u178WH/vRQJPnW1/6WGi4bS4lIArHalWrHrRwqflHK2wARr7lRq+WQzh5b8a6GleyaVMCnAmk9mbUFDI2MYSAK4VI7iNJznvOIq8b9Gv6k64pp0xgVD4jSX6i99M0r8r2f2VzibUUxFiwO0Ox/3VIU6652FmojJaGc1GVKQNoBErl+Iu24FVbjSi994ZGBwYeIeTfjqVEbl6Zbd+Iosrf6zNnqYsYks7ugDSbFJIeT/fox6vxwopbjAoU9uTil1jYFGd0Q/LJLzSx5xDBrNSuQLncEev7dI/NJzRCNFhXT2qxVF8CTXtKmmPRalVh+AcL9vgiwOiYbig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzOpj4IasZDKUVkC0E2ZzxC3Oaivl8dsE1eHBzxiulw=;
 b=tdVxilW9FoXUICKVADBCGNi2Uh/zyrg4vHQGalcpZOkONghVt4k2HW0ZhlcyhGFDWkg2tco9WTcCrp+mutPt5JRaMUB+crgvL198YR5l7LbVJfliLPFxMATVpJSlrdWBrcQXlUCUurHW3oKHwfAJGQY5H2qK6omEXL7fbgxZrYw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Thu, 13 May 2021 13:50:02 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.025; Thu, 13 May
 2021 13:50:02 +0000
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic> <YJv5bjd0xThIahaa@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <21b36f2e-bbcb-7df3-1509-9f77634eba99@amd.com>
Date:   Thu, 13 May 2021 08:49:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YJv5bjd0xThIahaa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:806:d2::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0075.namprd11.prod.outlook.com (2603:10b6:806:d2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 13:50:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 389b2032-afe8-4374-8773-08d916160198
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988D8C41ECEFCBCCE1DBCEEEC519@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CGFpWe0D7mCCOM+1cgrdqQNnFjOiwyz9J/bh2Ca+QRUiElP2664BUVtuV6BAW0jQzp0lwYR8FZ0nD7zNUWpeAVsofwCtOprhDgfyhNVxFnuCr/zf70Ml9lfgw+xxi6q6Nb3bzDBb0LM4QgGeeYiApSVgCs7SN/RSzli8wkvyr8dlXM6yVCepuFc+gWtAVEINwZrIyxvKah+XKVBtJZhw9yH66TT1Sg8TW73NGpi/c47uV9hGgDcCj67E1ngflU+u9vzSwdN6KkMVLFgDDmxCyxz/TzZR/OANPezGbg7Vg4i4KOqM8TiisdpO2wKCrFQljbuYTh2aoUf1T+0nPzjXwSK+QP9Hf9q9j5JTE1RiH0tY18RLrxisn2hxrzIUU1b0G+EI2DKqOWeBBwtFLazWL77YyE0+gzyfcpqGjoAh/ufozqQmxCvNyK1xiRaWqy2uOLVwuh/ZyMjhVQ3P4PlLwb17XBwUbkmZ+yLexoW2GMR9E5kkkYtKBhln0uTx9bJhSv6Ipja+/U1arrHs+e/ke65oYaz7LABcPwZO/2nR6mt4DItsioMa90QTc+Fn3t8SKbRd/HwlqEdyddQGYv+S4ONt82sVBziIhoyvg35Q7Au2539dXZDHArQ44ZZrRdmWOuo9y44OtyAF6LfhC+UsALOFynGTyrhJh0o5Oyp21l5mIHAISN6/xhRNrowXLDx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(956004)(6506007)(186003)(5660300002)(2616005)(8936002)(16526019)(7416002)(66946007)(36756003)(6486002)(31696002)(6512007)(66476007)(4326008)(66556008)(86362001)(8676002)(31686004)(26005)(498600001)(110136005)(38100700002)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dEZadG9GWnVrbVBDWFhFZlhPWStwNHBGNVZQZUVNaGczRmgrK0tFMGdSbGZW?=
 =?utf-8?B?WlBUQlY0TTJZajY1aWFOL3FUb2NDMmNLWFBzTjMzK3V2Skl6N3psWVJpQ21D?=
 =?utf-8?B?dElYTjJMNys2QmFyWW9oZTVYMTc1WDBkL292aGtRZGFoT25SOW5aOUFFMmhE?=
 =?utf-8?B?WERnbWE3Qy9XSGhYU1psRkM3TjAzSU5VUlNBdExLb0dqSmZOcGV2eUU4YVBs?=
 =?utf-8?B?M3NOU2dHLzAvUW45K3lmOW5VcTdVZzg4aUJFVUtIY3NsTWNUNkVPbnhBVjAz?=
 =?utf-8?B?ODNJVFJlb2pFZVRnWWs0OGpyVkJEbjk4SmZQVHczNWZIUUVFSVZmNk1jNHo5?=
 =?utf-8?B?ckI5NFY2cjdYeEFybmRnTnJMRXB1L3BLK3c5OFNIOVBqTWVJRGVOK29lckpE?=
 =?utf-8?B?TXpZVjR4Mmt5R1I1N21qMEV2MXFpNERBbU1MTDc3bHVVbUFLbC9jTEZVVG1r?=
 =?utf-8?B?c1V4OHZHZTRjbXdFaE9wbDNwTXhQSnByakZzclhTRFdUUjc4UzRBSWk4YmZt?=
 =?utf-8?B?b1ByWTVEZkt2QVZOSlRJMmQ1SUZ5MkVSQzBVOXVkbUtZVkhEdG8vNXlPZDJm?=
 =?utf-8?B?VHRyN2grb1AwZWZkVUVEQW16T1F1RkRoSTlKbFY3Z2xJcFNkejhWdEpOQVhk?=
 =?utf-8?B?MHREZ0Y0cmh3ZFVjME5ZRnA2Rm9OeURpQmJEb1NmQWhSWXlicUVHazBhckMw?=
 =?utf-8?B?WHpXM0JFb3o4QXR1ZWl4WllwdlFTd3JqQlpqM1NZbkFhd09QY09CVU1kenZv?=
 =?utf-8?B?SDZiUkFpNzZScE80cGZOQ1k4NEJZdkNWL3pQeTRDYU9zLzc2MkVtb0pJQnBJ?=
 =?utf-8?B?ZStaL214L1lSMFJQTU9Db253emFFK3BRVnJ6S002M2IzTE1hVUFBRC9wY3Nz?=
 =?utf-8?B?SlZOME9RMHMxSldlUHRJUmFvcnFCWUFwbEFybE0xeEZINXJzT0E5RUlPZ0lG?=
 =?utf-8?B?dWdtNW9wVVBCbUJNQlR2TmZKVU1mWjArYVMwVnd3Nng2aEN3aEdjM1QwK0JI?=
 =?utf-8?B?SHdScnZ3bzBvQjlSNkoyYlh1Sk9BQldEYkNKaW5ieCtyYk1EL1cwZGNUYUhv?=
 =?utf-8?B?NWVxc1J0K2NQWEtxOTNLeHZEcnU4V0s0T1pHYnlUQkpwdzRSS2txazdxczlJ?=
 =?utf-8?B?elBLRzFXZE5XQVpBTzVFNGdmRnh3Q0c2aVJZald5QWVXVU80V1VEbjJTakg3?=
 =?utf-8?B?TjBmU0JuSDFmc0dnWUxNL3E0Q3NFNGZrVE5sSktUKzNFS1hrZDJlT1hMVjFq?=
 =?utf-8?B?RWY1WFluczM5UmtZa3NHN095ZHY1K3FEMmpMYWJ0cXFNWUFKRFNVZkpscm00?=
 =?utf-8?B?WVNhK3A5SW0vemkwRHBpVVpaakoxRkhjL2tiS3VyOWE0bzl0alBZa1VDeEE1?=
 =?utf-8?B?UjRqZnlvVXRNVW9GNGx3NTNyR1hqQkZjdi9KVW1uUEZYbmlVcFRqWDY3Tk92?=
 =?utf-8?B?aDZ2WnJOdmdjNVBPaGtaVlJOUVJNSThoZUMrNUlCVHZneGRwK1MwNHhXUW5H?=
 =?utf-8?B?Si8rWCtEVzY5QlV4Vk9VRXVYUUtobjQxSzVKbnRIeG56TUtvTW11Uk85ZkFZ?=
 =?utf-8?B?T1R2ZzBzdVlualRUb2lKZnRxRDFKcGJST0NWSzZFRkZybFEyQzRHdXhWbGo1?=
 =?utf-8?B?YktZL3pkZENVZ3A1VEhQSWhaVGptZXRUc2NtdVc5Q05UMkpGRlI5NlU1WDlj?=
 =?utf-8?B?cUdQa0ZtYmYyTm43SmczMDZFRTMxbTJRK2drWmdsNWc5WFdFNzBFWUJEZ3JE?=
 =?utf-8?Q?TG5fZiomX2sfbiyu5IPGyFJauGnd/Jfcz0R/Pj1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389b2032-afe8-4374-8773-08d916160198
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 13:50:02.3479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13/SPPtXDIuRKULGURz767wguXixFusweh96wGd/fLaMibkvMSKyKfyrDKZ4Ze0+ywkA0NE3pWmIyTSBUDDC3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/21 10:51 AM, Sean Christopherson wrote:
> On Wed, May 12, 2021, Borislav Petkov wrote:
>> On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
>>> +static inline void notify_page_enc_status_changed(unsigned long pfn,
>>> +						  int npages, bool enc)
>>> +{
>>> +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
>>> +}
>>
>> Now the question is whether something like that is needed for TDX, and,
>> if so, could it be shared by both.
> 
> Yes, TDX needs this same hook, but "can't" reuse the hypercall verbatime.  Ditto
> for SEV-SNP.  I wanted to squish everything into a single common hypercall, but
> that didn't pan out.
> 
> The problem is that both TDX and SNP define their own versions of this so that
> any guest kernel that complies with the TDX|SNP specification will run cleanly
> on a hypervisor that also complies with the spec.  This KVM-specific hook doesn't
> meet those requires because non-Linux guest support will be sketchy at best, and
> non-KVM hypervisor support will be non-existent.
> 
> The best we can do, short of refusing to support TDX or SNP, is to make this
> KVM-specific hypercall compatible with TDX and SNP so that the bulk of the
> control logic is identical.  The mechanics of actually invoking the hypercall
> will differ, but if done right, everything else should be reusable without
> modification.
> 
> I had an in-depth analysis of this, but it was all off-list.  Pasted below. 
> 
>   TDX uses GPRs to communicate with the host, so it can tunnel "legacy" hypercalls
>   from time zero.  SNP could technically do the same (with a revised GHCB spec),
>   but it'd be butt ugly.  And of course trying to go that route for either TDX or
>   SNP would run into the problem of having to coordinate the ABI for the "legacy"
>   hypercall across all guests and hosts.  So yeah, trying to remove any of the
>   three (KVM vs. SNP vs. TDX) interfaces is sadly just wishful thinking.
> 
>   That being said, I do think we can reuse the KVM specific hypercall for TDX and
>   SNP.  Both will still need a {TDX,SNP}-specific GCH{I,B} protocol so that cross-
>   vendor compatibility is guaranteed, but that shouldn't preclude a guest that is
>   KVM enlightened from switching to the KVM specific hypercall once it can do so.
>   More thoughts later on.
> 
>   > I guess a common structure could be used along the lines of what is in the
>   > GHCB spec today, but that seems like overkill for SEV/SEV-ES, which will
>   > only ever really do a single page range at a time (through
>   > set_memory_encrypted() and set_memory_decrypted()). The reason for the
>   > expanded form for SEV-SNP is that the OS can (proactively) adjust multiple
>   > page ranges in advance. Will TDX need to do something similar?
> 
>   Yes, TDX needs the exact same thing.  All three (SEV, SNP, and TDX) have more or
>   less the exact same hook in the guest (Linux, obviously) kernel.
> 
>   > If so, the only real common piece in KVM is a function to track what pages
>   > are shared vs private, which would only require a simple interface.
> 
>   It's not just KVM, it's also the relevant code in the guest kernel(s) and other
>   hypervisors.  And the MMU side of KVM will likely be able to share code, e.g. to
>   act on the page size hint.
> 
>   > So for SEV/SEV-ES, a simpler hypercall interface to specify a single page
>   > range is really all that is needed, but it must be common across
>   > hypervisors. I think that was one Sean's points originally, we don't want
>   > one hypercall for KVM, one for Hyper-V, one for VMware, one for Xen, etc.
> 
>   For the KVM defined interface (required for SEV/SEV-ES), I think it makes sense
>   to make it a superset of the SNP and TDX protocols so that it _can_ be used in
>   lieu of the SNP/TDX specific protocol.  I don't know for sure whether or not
>   that will actually yield better code and/or performance, but it costs us almost
>   nothing and at least gives us the option of further optimizing the Linux+KVM
>   combination.

Right, for SEV-SNP, as long as we know that the KVM interface is
available, it could be used. But we would have to fall back to the GHCB
specification if it could not be determined.

> 
>   It probably shouldn't be a strict superset, as in practice I don't think SNP
>   approach of having individual entries when batching multiple pages will yield
>   the best performance.  E.g. the vast majority (maybe all?) of conversions for a
>   Linux guest will be physically contiguous and will have the same preferred page
>   size, at which point there will be less overhead if the guest specifies a
>   massive range as opposed to having to santize and fill a large buffer.

Originally, the plan was to use ranges, but based on feedback during the
GHCB spec review it was updated to its current definition.

A concern from other hypervisor vendors was to be able to return back to
the guest in the middle of the hypercall, e.g. to deliver an interrupt or
such, and then allow the guest to resume the hypercall where it left off.
Not sure if you would want to build that into this hypercall, since
depending on the range, the operation could take a while.

Thanks,
Tom

> 
>   TL;DR: I think the KVM hypercall should be something like this, so that it can
>   be used for SNP and TDX, and possibly for other purposes, e.g. for paravirt
>   performance enhancements or something.
> 
>     8. KVM_HC_MAP_GPA_RANGE
>     -----------------------
>     :Architecture: x86
>     :Status: active
>     :Purpose: Request KVM to map a GPA range with the specified attributes.
> 
>     a0: the guest physical address of the start page
>     a1: the number of (4kb) pages (must be contiguous in GPA space)
>     a2: attributes
> 
>   where 'attributes' could be something like:
> 
>     bits  3:0 - preferred page size encoding 0 = 4kb, 1 = 2mb, 2 = 1gb, etc...
>     bit     4 - plaintext = 0, encrypted = 1
>     bits 63:5 - reserved (must be zero)
> 
