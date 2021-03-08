Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D6433191D
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhCHVMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:12:13 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:63941
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231335AbhCHVLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:11:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2LNIclTS64VRHArqGl/hTYWddorFJPAf65CYcLRPsqaaSYJ+TTXlwU2UBODG4WCPbzczw2xjbrZEgMVL790PGkqDIudlkXxArToMW6Z8CYZo/ww7qZSZCmv1qyLYEEFU8JzcUoapuXrpvWhdDcQRXRKfk6YWU8EH2fEMY3nJzh0yZ8qBa1q3yC5ZhQl7oXEry12TPwxhJvIISS7NsG6ro6p9lk98G+0YiDS0YHyIKkxFbD8LX4f8BNwt5ijcoI444bAB94uAuKEhysc7Excwe2LtXpClV1Ydh1+BwTdZrxBa5UTks/XJGt9g0n2vvytjSvBU4c04xFX7CtlDSs/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8TQnz52Pmavx40BoPE2qmRh8rlZTt8kkwvMcq7HF5I=;
 b=ZjweuPnM/h6FbJ/ZqGq8y4So/MkOcxq7DPXRtbdCabrE2X3hplGYwE40ycTjcKl8IscwCvanVI63w5vwBSIwIgzQ2SoDeaisJqUJLPWlIR3PyC9V790T/pCQNiJEdqJg816JpYGf/8EnkaDjV7kOMlh2qb8D1if3RPqM33qtYMAcQ0qJ6DnB9tPAmmsuDtLJ6diXWO4ouGPC+kh7pOuOnx3imsjPaHWJPdrP9KDGT6S50rrbitpvFeLfZ7f8Vp9h3xEPjn0M3mxGYzn/JCbXO206xUAsLm9jUtC1LdPjulBvC26oen92Aw77DkdGfLtfppiTnCiPiWLF8WjmAeXM1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8TQnz52Pmavx40BoPE2qmRh8rlZTt8kkwvMcq7HF5I=;
 b=0iMN1falNlY1/rfuXiHUtDtaD4neL4xTaSc/nMLeWJYEqVjGaFHxzlXuZGwfs6s9jSfx5VYNeWdCh9MoEMymR8D/Wnm21XbHL27mfm2jftwUsZWSE45hcx8yKORoQ0f9prxHsjv2IDytULmIpNbnIEsPr/Q8YVcJOxx8AeHAKvU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4559.namprd12.prod.outlook.com (2603:10b6:806:9e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 8 Mar
 2021 21:11:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3890.038; Mon, 8 Mar 2021
 21:11:43 +0000
Cc:     brijesh.singh@amd.com, Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
To:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server> <YEaAXXGZH0uSMA3v@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
Date:   Mon, 8 Mar 2021 15:11:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <YEaAXXGZH0uSMA3v@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:805:f2::21) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR04CA0080.namprd04.prod.outlook.com (2603:10b6:805:f2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 21:11:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f0f5654-daaa-4c6c-dd1c-08d8e276c678
X-MS-TrafficTypeDiagnostic: SA0PR12MB4559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45590D78A4B550A2AFBA5311E5939@SA0PR12MB4559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKaYh7aJ7wqj2eA4VcF6sZwWYd+lfNjbn5yK8uAgvFhp4UZlCxRBBKOS4DagY40f8TfFoI4a7IKY15yVKCk4wsLcYKcOQL7Sp5LunAf3e5lYgC0veZMLjBTS/JST9XlKrhRayS4rTgmT9PCv7xazG7PQ6sFS7kGLlFIpO3lqYdBCcjpwVXkn3sAMehQkC7HOMiufNLV3B2nX3H0AZsewdc2KT22LcLmAA5aaoEzLmZxHOG9FymiZIfN09Um6ZuSHfhnCLXxXx3wS7yoIdtuT4NeIwEo7rE4VExCx0JYlxCwS4PNF/dUlkb4etMjtqyxpGgCPIRYl1Ukx1kbkwBeBTVWFANDycGbc6C8NQX0n/UsGceISpleP8OINrAoiSJ13e/SitV+irQb7SBNbVg6MFgG1IlYLq9ievOA4PGIdwJVi5ULNfJrhyK4wefO/hpUM5vB0PZXyhSbJ4Fm3X9i9sMV7k4Fp8MC9UYXDrT86SGIBQqd71KgeAgJJneSn3xcI5/OQAmufUjdh5/BOp6mwIY4oudreNG6Bxw3maWKvbjtxNM2MZkr6vYEFlIFQbWtL/fQhEWQY5vOKQ351nbZeKP0hPNORs4TXGI24y0YHujo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(6506007)(53546011)(83380400001)(31686004)(44832011)(2906002)(54906003)(956004)(2616005)(110136005)(31696002)(86362001)(6636002)(6512007)(5660300002)(316002)(36756003)(6486002)(4326008)(8936002)(66946007)(66476007)(66556008)(478600001)(8676002)(186003)(26005)(52116002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THJDMDcvSGdSMzVyZUJuUGNmck9JQXN6WkpQYzZNVTJWK0ZlOTFvSERaSldU?=
 =?utf-8?B?NkZYb2NhQ0cxNzBRUUJaVE9Pei9NcDFBUFd5Wm00WndGR1NlRXFPNHZWVThi?=
 =?utf-8?B?cE9rV3JneXBDSXNEbkI1OGF5TldYNERLQ1RGQUo5Nm1NejNjTG5JSmp3ZzhI?=
 =?utf-8?B?cVVLaExjeENxaGNiYldxYVR6clFWVGxGQ1h1OWY1Z05leVRYYWhYNTBFaWhD?=
 =?utf-8?B?amxsSjJGYm5BQnk3YlpnajlWclVYcXdmUTh5SWpncUZuSGFGZzJvb291SE9h?=
 =?utf-8?B?cENHZjkvamc4ZXRmVG14WVNKWEZ5Tlp3RkdaTmFtRE9sTS9UZFJmTHJiTmRJ?=
 =?utf-8?B?VnRtT0NacHFlMVZYaEVXdGRNb1gyUWx1enFlN3FUZlE0SHcvdTI2MUlpZkhm?=
 =?utf-8?B?d2VDeHNNV2dMZUhYQkJzcEx1SVRSOGZITkJOQ1J0QkhTbnZqckI3TUVoOFBx?=
 =?utf-8?B?WnBISXdFZXVNSHJ5V3Rac054SWs5bkZqT2dzU1hqNXlHOVRmZEZyeVQ5OTRD?=
 =?utf-8?B?RUFJTC9SMHB5V1lJTGd1ZGRibUtjdDIvMGZGUmplUENHWDZnQVdtVTE4MDhw?=
 =?utf-8?B?bGpCL2ZJakkxK1RGUzZzZHlMVmxxT2J3cG5sUi9wME1KVUVYVjJkbGRaSW9l?=
 =?utf-8?B?dmlFZkpUczI0cnJIbWdjZFJnTDBtSXM2bkp1K1l5M0tDODhlNXYzb2N6NU13?=
 =?utf-8?B?QUdFMmlvampoN2NvR2NNaTRYNnBteUptc3V6c2JMYld4czliTVBEcjFUMUd2?=
 =?utf-8?B?SEk0Q2JJdWlXcXp2dUlGaW9zUHNKMGl1M28zdTc4ZWc4WmRvL0FSMEUxRXV3?=
 =?utf-8?B?aENIWHl0Tnk4enpvbVNST0NHRzM0SFoxYUlQT3AzMHA3c0RZZWVTeVcybU8v?=
 =?utf-8?B?UmtSK1o0Ym1OWVNlN0FXS29id2ZsOC8ydzdHd3pxQjBYajdmT1Q1UE9ib0Ry?=
 =?utf-8?B?UTU5WU5qamVRQUtGaEdhbkkxQnJYaUZEbFNWcy9pOFhtbXRGdUswSU5LNVlI?=
 =?utf-8?B?aWtKK2s5QnBSRlJTbDk2NVdDZC8waHdCODZKcTVMZWhsWXNwUmRqQVBTRktM?=
 =?utf-8?B?Q0htdjZMMFhVWVRvQTh6Yko0SXJXNnRJeFBwYm1QTWdXbXMwS3g1ZmZEb01M?=
 =?utf-8?B?ckZGeVJGMWt3ZlM1SHJFK0FON0FiSHlmTjR1TkUyRlFMd2lsNEhRLzg5TWc4?=
 =?utf-8?B?RkN2TEQxRGVNazIxN21iMUdDQXZUMTB5OEJOakZBRytoTzA3bXRqYXE4SDNk?=
 =?utf-8?B?TDVCTkVtaDRraDZxWW1VSEJmVDRYM2pnRWZyZTlFVStsTjhMVHRXbkk3VW9h?=
 =?utf-8?B?Rkc1N3FBYXFBQlJiN1JMKzBLY25FbFNwQzg5Z3IrMVhiWXpoSzlnYnlHSkhL?=
 =?utf-8?B?V1NMcFlHNTFIL2R6Vk1OdXNNWlpTcGZmQlRFelNicGpJbVo3U1VrTk1JZWpL?=
 =?utf-8?B?R29oYmVXeU5SelZNaTlCdGo2bXNxTFdTRWJ5UHdvRHdWbzdjcEZ4bGF2UmR6?=
 =?utf-8?B?dDN4TUxUeE9sS1EvS3EvUDNvVlN6N3cvTVlsSC83TmczWnViNnk3cy9wOWNJ?=
 =?utf-8?B?VHNuVW9iSTFORk1tSzI0YkdjSVh0d0QrVHdPMDdUSFlzaWNDVDRKL0NxbEpW?=
 =?utf-8?B?djI1SDcxcU4vR0czZjVpV3B6b29Ub3F0VTNkckg1YndYY0FsWmVQUXBBdnBM?=
 =?utf-8?B?b2pkSHg0YXBzeXJQRkdodmduemRETUVydllYdGcyaEp4aDJaSFNlK0Q5S2xV?=
 =?utf-8?Q?l4Z5rlCBjRSYpHszDS4uGGOQaHAaOa96SEvMKrE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0f5654-daaa-4c6c-dd1c-08d8e276c678
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 21:11:43.8824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gf3KQl8OFiLiba8QJCgTMWM8IPXIma4neHNbP2P2rgLzyJqMs/7i4VPnptKx0BYi8o/ojdksqy5+chq78Cwmsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4559
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/8/21 1:51 PM, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Ashish Kalra wrote:
>> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
>>> +Will and Quentin (arm64)
>>>
>>> Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
>>> point.
>>>
>>> On Fri, Feb 26, 2021, Ashish Kalra wrote:
>>>> On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
>>>>> On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>>>>> Thanks for grabbing the data!
>>>>>
>>>>> I am fine with both paths. Sean has stated an explicit desire for
>>>>> hypercall exiting, so I think that would be the current consensus.
>>> Yep, though it'd be good to get Paolo's input, too.
>>>
>>>>> If we want to do hypercall exiting, this should be in a follow-up
>>>>> series where we implement something more generic, e.g. a hypercall
>>>>> exiting bitmap or hypercall exit list. If we are taking the hypercall
>>>>> exit route, we can drop the kvm side of the hypercall.
>>> I don't think this is a good candidate for arbitrary hypercall interception.  Or
>>> rather, I think hypercall interception should be an orthogonal implementation.
>>>
>>> The guest, including guest firmware, needs to be aware that the hypercall is
>>> supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
>>> implement a common ABI is an unnecessary risk.
>>>
>>> We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
>>> require further VMM intervention.  But, I just don't see the point, it would
>>> save only a few lines of code.  It would also limit what KVM could do in the
>>> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
>>> then mandatory interception would essentially make it impossible for KVM to do
>>> bookkeeping while still honoring the interception request.
>>>
>>> However, I do think it would make sense to have the userspace exit be a generic
>>> exit type.  But hey, we already have the necessary ABI defined for that!  It's
>>> just not used anywhere.
>>>
>>> 	/* KVM_EXIT_HYPERCALL */
>>> 	struct {
>>> 		__u64 nr;
>>> 		__u64 args[6];
>>> 		__u64 ret;
>>> 		__u32 longmode;
>>> 		__u32 pad;
>>> 	} hypercall;
>>>
>>>
>>>>> Userspace could also handle the MSR using MSR filters (would need to
>>>>> confirm that).  Then userspace could also be in control of the cpuid bit.
>>> An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
>>> The data limitation could be fudged by shoving data into non-standard GPRs, but
>>> that will result in truly heinous guest code, and extensibility issues.
>>>
>>> The data limitation is a moot point, because the x86-only thing is a deal
>>> breaker.  arm64's pKVM work has a near-identical use case for a guest to share
>>> memory with a host.  I can't think of a clever way to avoid having to support
>>> TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
>>> multiple KVM variants.
>>>
>> Potentially, there is another reason for in-kernel hypercall handling
>> considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
>> of each guest page, for instance pages in hypervisor state, i.e., pages
>> with C=0 and pages in guest valid state with C=1.
>>
>> Now, there shouldn't be a need for page encryption status hypercalls on 
>> SEV-SNP as KVM can track & reference guest page status directly using 
>> the RMP table.
> Relying on the RMP table itself would require locking the RMP table for an
> extended duration, and walking the entire RMP to find shared pages would be
> very inefficient.
>
>> As KVM maintains the RMP table, therefore we will need SET/GET type of
>> interfaces to provide the guest page encryption status to userspace.
> Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
> for converting between shared and private.  And in the case of TDX, the hypercall
> can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
> the host.
>
> But, the different guest behavior doesn't require KVM to maintain a list/tree,
> e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page encryption
> status changes would also suffice.  
>
> Actually, that made me think of another argument against maintaining a list in
> KVM: there's no way to notify userspace that a page's status has changed.
> Userspace would need to query KVM to do GET_LIST after every GET_DIRTY.
> Obviously not a huge issue, but it does make migration slightly less efficient.
>
> On a related topic, there are fatal race conditions that will require careful
> coordination between guest and host, and will effectively be wired into the ABI.
> SNP and TDX don't suffer these issues because host awareness of status is atomic
> with respect to the guest actually writing the page with the new encryption
> status.
>
> For SEV live migration...
>
> If the guest does the hypercall after writing the page, then the guest is hosed
> if it gets migrated while writing the page (scenario #1):
>
>   vCPU                 Userspace
>   zero_bytes[0:N]
>                        <transfers written bytes as private instead of shared>
> 		       <migrates vCPU>
>   zero_bytes[N+1:4095]
>   set_shared (dest)
>   kaboom!


Maybe I am missing something, this is not any different from a normal
operation inside a guest. Making a page shared/private in the page table
does not update the content of the page itself. In your above case, I
assume zero_bytes[N+1:4095] are written by the destination VM. The
memory region was private in the source VM page table, so, those writes
will be performed encrypted. The destination VM later changed the memory
to shared, but nobody wrote to the memory after it has been transitioned
to the  shared, so a reader of the memory should get ciphertext and
unless there was a write after the set_shared (dest).


> If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
> data by consuming a stale list (scenario #2):
>
>   vCPU               Userspace
>                      get_list (from KVM or internally)
>   set_shared (src)
>   zero_page (src)
>                      get_dirty
>                      <transfers private data instead of shared>
>                      <migrates vCPU>
>   kaboom!


I don't remember how things are done in recent Ashish Qemu/KVM patches
but in previous series, the get_dirty() happens before the querying the
encrypted state. There was some logic in VMM to resync the encrypted
bitmap during the final migration stage and perform any additional data
transfer since last sync.


> If both guest and host order things to avoid #1 and #2, the host can still
> migrate the wrong data (scenario #3):
>
>   vCPU               Userspace
>   set_private
>   zero_bytes[0:4096]
>                      get_dirty
>   set_shared (src)
>                      get_list
>                      <transfers as shared instead of private>
> 		     <migrates vCPU>
>   set_private (dest)
>   kaboom!


Since there was no write to the memory after the set_shared (src), so
the content of the page should not have changed. After the set_private
(dest), the caller should be seeing the same content written by the
zero_bytes[0:4096]


> Scenario #3 is unlikely, but plausible, e.g. if the guest bails from its
> conversion flow for whatever reason, after making the initial hypercall.  Maybe
> it goes without saying, but to address #3, the guest must consider existing data
> as lost the instant it tells the host the page has been converted to a different
> type.
>
>> For the above reason if we do in-kernel hypercall handling for page
>> encryption status (which we probably won't require for SEV-SNP &
>> correspondingly there will be no hypercall exiting),
> As above, that doesn't preclude KVM from exiting to userspace on conversion.
>
>> then we can implement a standard GET/SET ioctl interface to get/set the guest
>> page encryption status for userspace, which will work across SEV, SEV-ES and
>> SEV-SNP.
